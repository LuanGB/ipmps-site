class AddYoutubeFieldsToSermons < ActiveRecord::Migration[8.0]
  def change
    add_column :sermons, :youtube_video_id, :string
    add_column :sermons, :thumbnail_url, :string
    add_column :sermons, :published_at, :datetime
    add_column :sermons, :duration, :string
    add_column :sermons, :view_count, :integer
    add_column :sermons, :auto_imported, :boolean, default: false

    add_index :sermons, :youtube_video_id, unique: true
    add_index :sermons, :published_at
  end
end
