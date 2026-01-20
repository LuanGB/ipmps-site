# == Schema Information
#
# Table name: site_config_services
#
#  id             :bigint           not null, primary key
#  description    :text
#  schedule       :string
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  site_config_id :bigint           not null
#
# Indexes
#
#  index_site_config_services_on_site_config_id  (site_config_id)
#
# Foreign Keys
#
#  fk_rails_...  (site_config_id => site_configs.id)
#
require "test_helper"

class SiteConfig::ServiceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
