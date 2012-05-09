require 'redis'

module Sunrize
  class User

    def initialize(username)
      @username = username
    end

    def self.find(username)
      new(username).load
    end

    def self.exists?(username)
      self.new(username).exists?
    end

    def load
      if exists?
        data = @redis.hgetall key
        data['courses'] = JSON.parse(data['courses'])
        data
      else
        not_found
      end
    end

    def redis
      @redis ||= Redis.new
    end

    def exists?
      redis.exists key
    end

    private


    def key
      "sunrize:#{@username}"
    end

    def not_found
      {:status => '404', :message => "User was not found."}
    end

  end
end