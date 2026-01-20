# == Schema Information
#
# Table name: sermons
#
#  id               :bigint           not null, primary key
#  auto_imported    :boolean          default(FALSE)
#  description      :string
#  duration         :string
#  link             :string
#  published_at     :datetime
#  thumbnail_url    :string
#  title            :string
#  view_count       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  youtube_video_id :string
#
# Indexes
#
#  index_sermons_on_published_at       (published_at)
#  index_sermons_on_youtube_video_id  (youtube_video_id) UNIQUE
#
class Sermon < ApplicationRecord
  validates :title, presence: true
  validates :youtube_video_id, uniqueness: true, allow_nil: true

  scope :recent, -> { order(published_at: :desc, created_at: :desc) }
  scope :auto_imported, -> { where(auto_imported: true) }
  scope :manually_created, -> { where(auto_imported: false) }

  def youtube_url
    return link if link.present?
    return nil if youtube_video_id.blank?
    "https://www.youtube.com/watch?v=#{youtube_video_id}"
  end

  def youtube_embed_url
    return nil if youtube_video_id.blank?
    "https://www.youtube.com/embed/#{youtube_video_id}"
  end

  # Extrai o video_id de uma URL do YouTube
  def self.extract_video_id(url)
    return nil if url.blank?

    # Padrões de URL do YouTube
    patterns = [
      /(?:youtube\.com\/watch\?v=|youtu\.be\/)([^&\n?#]+)/,
      /youtube\.com\/embed\/([^&\n?#]+)/,
      /youtube\.com\/v\/([^&\n?#]+)/
    ]

    patterns.each do |pattern|
      match = url.match(pattern)
      return match[1] if match
    end

    nil
  end

  # Antes de salvar, extrai o video_id do link se não estiver preenchido
  before_save :extract_video_id_from_link

  private

  def extract_video_id_from_link
    if youtube_video_id.blank? && link.present?
      self.youtube_video_id = Sermon.extract_video_id(link)
    end
  end
end
