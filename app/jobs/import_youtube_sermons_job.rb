class ImportYoutubeSermonsJob < ApplicationJob
  queue_as :default

  def perform(force_update: false)
    binding.pry
    # Busca o canal do YouTube configurado no SiteConfig
    site_config = SiteConfig.current
    youtube_channel = site_config.site_data["youtube"]

    if youtube_channel.blank?
      Rails.logger.warn "YouTube channel not configured in SiteConfig"
      return { success: false, error: "Canal do YouTube não configurado" }
    end

    # Extrai o ID do canal
    channel_id = YoutubeService.extract_channel_id(youtube_channel)

    # Busca os últimos vídeos
    youtube_service = YoutubeService.new
    videos = youtube_service.fetch_latest_videos(channel_id, 50) # Busca últimos 50 vídeos

    imported_count = 0
    updated_count = 0
    errors = []

    videos.each do |video_data|
      begin
        sermon = Sermon.find_or_initialize_by(youtube_video_id: video_data[:video_id])

        # Se já existe e não é para forçar atualização, pula
        next if sermon.persisted? && !force_update

        is_new = sermon.new_record?

        sermon.assign_attributes(
          title: video_data[:title],
          description: video_data[:description]&.truncate(255),
          link: "https://www.youtube.com/watch?v=#{video_data[:video_id]}",
          thumbnail_url: video_data[:thumbnail_url],
          published_at: video_data[:published_at],
          duration: video_data[:duration],
          view_count: video_data[:view_count],
          auto_imported: true
        )

        if sermon.save
          is_new ? imported_count += 1 : updated_count += 1
        else
          errors << "Erro ao salvar vídeo #{video_data[:video_id]}: #{sermon.errors.full_messages.join(', ')}"
        end
      rescue => e
        errors << "Erro ao processar vídeo #{video_data[:video_id]}: #{e.message}"
        Rails.logger.error "Error importing sermon: #{e.message}"
      end
    end

    result = {
      success: true,
      imported: imported_count,
      updated: updated_count,
      total_videos: videos.count,
      errors: errors
    }

    Rails.logger.info "YouTube import completed: #{result.inspect}"
    result
  end
end
