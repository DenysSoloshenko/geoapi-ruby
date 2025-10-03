# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
require 'webmock/rspec'   # <— add this

WebMock.disable_net_connect!(allow_localhost: true)
ENV['API_KEY'] = nil
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
