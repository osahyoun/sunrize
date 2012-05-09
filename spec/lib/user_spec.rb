require 'helper'
require 'user'
require 'fetcher'
require 'json'

describe Sunrize::User do
  before do
    @redis = Redis.new
    @redis.del 'sunrize:osahyoun'
  end

  it 'should respond appropriately when user not found' do
    response = Sunrize::User.find('osahyoun')
    response.should == {:status => '404', :message => "User was not found."}
  end

  it "should know if a user does not exists" do
    Sunrize::User.exists?('iDoNotExist').should == false
  end

  it "should know if a user exists" do
    stub_get('osahyoun')
    Sunrize::Fetcher.fetch('osahyoun')
    Sunrize::User.exists?('osahyoun').should == true
  end

  it 'should return user data when user is found' do
    stub_get('osahyoun')
    Sunrize::Fetcher.new('osahyoun').save
    user = Sunrize::User.find('osahyoun')

    fixture_stats['osahyoun'].each do |key, val|
      if key == :courses
        user[key.to_s].first.should == val.first
      else
        user[key.to_s].should == val.to_s
      end
    end
  end
end
