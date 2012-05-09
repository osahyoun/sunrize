require 'redis'

module Sunrize
  module RedisConnection

    def redis
      uri = URI.parse(ENV["REDISTOGO_URL"])
      @redis ||= Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
    end

  end
end