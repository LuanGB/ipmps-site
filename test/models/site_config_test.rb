# == Schema Information
#
# Table name: site_configs
#
#  id              :bigint           not null, primary key
#  active          :boolean
#  last_updated_by :integer
#  site_data       :jsonb
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "test_helper"

class SiteConfigTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
