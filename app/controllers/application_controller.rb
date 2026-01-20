class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  def current_site_config
    @site_config ||= SiteConfig.current
  end
  helper_method :current_site_config
end
