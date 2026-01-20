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
class SiteConfig < ApplicationRecord
  DEFAULT_SITE_DATA = {
    title: "Default Site Title",
    description: "This is the default site description."
  }.freeze

  belongs_to :last_updated_by, class_name: AdminUser.name, foreign_key: "last_updated_by"
  has_many :slides, class_name: SiteConfig::Slide.name, inverse_of: :site_config, dependent: :destroy
  has_many :verses, class_name: SiteConfig::Verse.name, inverse_of: :site_config, dependent: :destroy
  has_many :services, class_name: SiteConfig::Service.name, inverse_of: :site_config, dependent: :destroy

  accepts_nested_attributes_for :slides, allow_destroy: true
  accepts_nested_attributes_for :verses, allow_destroy: true
  accepts_nested_attributes_for :services, allow_destroy: true

  scope :active, -> { where(active: true) }

  def self.current
    active.last || SiteConfig.new
  end

  def site_data
    return {} if new_record?
    super || DEFAULT_SITE_DATA
  end
end
