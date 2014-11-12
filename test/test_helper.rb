ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'rack/test'

class ActiveSupport::TestCase
  ActiveRecord::Migration.maintain_test_schema!
  
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include Devise::TestHelpers

  def sample_file(filename="sample_file.png")
    Rack::Test::UploadedFile.new("test/fixtures/#{filename}", 'image/png')
  end
end
