ENV['RACK_ENV'] = 'test'
ENV["REDISTOGO_URL"] = 'redis://username:password@localhost:6379'

require File.join(File.dirname(__FILE__), '..', '..', 'application.rb')

require 'capybara'
require 'capybara/cucumber'
require 'rspec'
require 'webmock/cucumber'

Capybara.app = Sinatra::Application

class ApplicationWorld
  include Capybara::DSL
  include RSpec::Expectations
  include RSpec::Matchers
end

World do
  ApplicationWorld.new
end


module Helper
  def fixture_path
    File.join(File.dirname(__FILE__), '..', '..', 'spec', 'fixtures')
  end

  def fixture(file)
    File.new(fixture_path + '/' + file).read
  end

  def delete_keys
    require 'redis'
    r = Redis.new
    r.keys("sunrize:*").each{|k| r.del k}
  end
end

World(Helper)
