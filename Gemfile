source "https://rubygems.org"

ruby "3.4.5"

# Rails defaults
gem "rails", "~> 8.0.2", ">= 8.0.2.1"
gem "propshaft"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false
gem "image_processing", "~> 1.2"

# scss / sass support
gem "dartsass-rails"

# active admin
gem "activeadmin"
gem "activeadmin_addons"
gem "activeadmin_dark_color_scheme"
gem "active_admin_datetimepicker"
gem "activeadmin_json_editor"
gem "activeadmin_quill_editor"
gem "activeadmin-select2", github: "mfairburn/activeadmin-select2"
gem "select2-rails"
gem "coffee-rails"
gem "jquery-minicolors-rails"

# authentication
gem "devise"

# pagination
gem "kaminari"

# i18n
gem "rails-i18n", "~> 8.0.0"
gem "kaminari-i18n"
gem "devise-i18n"

# YouTube API
gem "google-api-client"

# Background jobs
gem "sidekiq"
gem "sidekiq-cron"

group :development, :test do
  gem "dotenv-rails", require: false
  gem "pry"
  gem "annotaterb"
  gem "foreman"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "mailcatcher", "~> 0.10.0"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
