# == Schema Information
#
# Table name: posts
#
#  id               :bigint           not null, primary key
#  category         :string
#  content          :string
#  description      :text
#  publication_date :datetime
#  title            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Post < ApplicationRecord
  CATEGORIES = %w[news events]

  has_one_attached :cover
  has_one_attached :thumbnail
  has_many_attached :content_files
  include AttachmentsUrls

  has_many :categories, class_name: "Post::Category"

  validates :category, inclusion: { in: CATEGORIES }

  def html_safe_content
    content&.html_safe
  end
end
