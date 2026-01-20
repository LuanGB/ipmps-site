require 'google/apis/youtube_v3'

class YoutubeService
  YOUTUBE_API_SERVICE_NAME = 'youtube'
  YOUTUBE_API_VERSION = 'v3'

  def initialize
    @service = Google::Apis::YoutubeV3::YouTubeService.new
    @service.key = ENV['YOUTUBE_API_KEY']
  end

  # Busca os últimos vídeos de um canal
  # channel_id: ID do canal do YouTube
  # max_results: Número máximo de resultados (padrão: 10)
  def fetch_latest_videos(channel_id, max_results = 10)
    return [] if ENV['YOUTUBE_API_KEY'].blank?

    begin
      response = @service.list_searches(
        'snippet',
        channel_id: channel_id,
        order: 'date',
        max_results: max_results,
        type: 'video'
      )

      videos = []

      response.items.each do |search_result|
        video_id = search_result.id.video_id
        video_details = fetch_video_details(video_id)

        next unless video_details

        videos << {
          video_id: video_id,
          title: search_result.snippet.title,
          description: search_result.snippet.description,
          thumbnail_url: search_result.snippet.thumbnails&.high&.url || search_result.snippet.thumbnails&.default&.url,
          published_at: search_result.snippet.published_at,
          duration: video_details[:duration],
          view_count: video_details[:view_count]
        }
      end

      videos
    rescue Google::Apis::Error => e
      Rails.logger.error "YouTube API Error: #{e.message}"
      []
    end
  end

  # Busca detalhes de um vídeo específico
  def fetch_video_details(video_id)
    return nil if ENV['YOUTUBE_API_KEY'].blank?

    begin
      response = @service.list_videos(
        'contentDetails,statistics',
        id: video_id
      )

      return nil if response.items.empty?

      video = response.items.first

      {
        duration: parse_duration(video.content_details.duration),
        view_count: video.statistics.view_count.to_i
      }
    rescue Google::Apis::Error => e
      Rails.logger.error "YouTube API Error fetching video details: #{e.message}"
      nil
    end
  end

  # Extrai o ID do canal de uma URL do YouTube
  def self.extract_channel_id(url_or_handle)
    return nil if url_or_handle.blank?

    # Se já é um ID de canal (começa com UC)
    return url_or_handle if url_or_handle.match?(/^UC[a-zA-Z0-9_-]{22}$/)

    # Extrai de URL
    patterns = [
      /youtube\.com\/channel\/([^\/\?&]+)/,
      /youtube\.com\/c\/([^\/\?&]+)/,
      /youtube\.com\/@([^\/\?&]+)/,
      /youtube\.com\/user\/([^\/\?&]+)/
    ]

    patterns.each do |pattern|
      match = url_or_handle.match(pattern)
      return match[1] if match
    end

    # Se não encontrou padrão, retorna o valor original
    # (pode ser um handle ou username que precisa ser convertido)
    url_or_handle
  end

  private

  # Converte duração ISO 8601 (PT1H2M10S) para formato legível (1:02:10)
  def parse_duration(iso_duration)
    return nil if iso_duration.blank?

    match = iso_duration.match(/PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?/)
    return nil unless match

    hours = match[1].to_i
    minutes = match[2].to_i
    seconds = match[3].to_i

    if hours > 0
      format('%d:%02d:%02d', hours, minutes, seconds)
    else
      format('%d:%02d', minutes, seconds)
    end
  end
end
