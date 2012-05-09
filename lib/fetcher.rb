require 'faraday'
require 'nokogiri'
require './lib/user'
require './lib/redis_connection'

module Sunrize

  class UserNotFoundError < StandardError
  end

  class Fetcher
    include Sunrize::RedisConnection

    attr_reader :username, :url

    HOST = 'http://www.memrise.com'
    ATTRIBUTES = %w{username rank courses courses_total high_fives thumbs_up points word_count}

    def initialize(username)
      @username = username
    end

    def self.find(username)
      self.new(username)
    end

    def self.fetch(username)
      new(username).save
    end

    def resource
      "#{HOST}/user/#{username}/"
    end
    alias :url :resource

    def rank
      returning_rank do
        markup.css('h1.name a.rank')
      end
    end

    def word_count
      returning_number do
        markup.css('span#words-learned-stat')
      end
    end

    def points
      returning_number do
        markup.css('div.stat.profile.points span#points-stat')
      end
    end

    def thumbs_up
      returning_number do
        markup.css('span#total-rating-stat')
      end
    end

    def high_fives
      returning_number do
        markup.css('div.block.purple div.header h3')
      end
    end

    def courses_total
      returning_number do
        courses_markup.css('div.header h3')
      end
    end

    def courses
      returning_array_of_courses do
        courses_markup.css('div.rows a')
      end.to_json
    end

    def save
      ATTRIBUTES.each do |a|
        redis.hset redis_key, a, send(a)
      end
      self
    end

    private

    def redis_key
      @redis_key ||= "sunrize:#{@username}"
    end

    def request
      @request ||= Faraday.get(resource)
    end

    def markup
      raise Sunrize::UserNotFoundError if request.status == 404
      @markup ||= Nokogiri::HTML(request.body)
    end

    def courses_markup
      @courses ||= markup.css('div.block.green')
    end

    def returning_number
      yield.first.content.
        gsub(/[^0-9]/,'').to_i
    end

    def returning_rank
      content = yield.first.content
      if content.match /points/
         ""
      else
        returning_number do
          yield
        end
      end
    end

    def returning_array_of_courses
      yield.map do |course|
        [course.css('div.fnt.m.bold.colored').first.content, "#{HOST}#{course.attr('href')}"]
      end
    end

  end

end