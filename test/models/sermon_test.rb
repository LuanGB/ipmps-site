# == Schema Information
#
# Table name: sermons
#
#  id               :bigint           not null, primary key
#  auto_imported    :boolean
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
require "test_helper"

class SermonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
