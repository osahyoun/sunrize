# encoding: utf-8
require 'redis'
require 'webmock/rspec'

def stub_get(user)
  stub_request(:get, "http://www.memrise.com/user/#{user}/").
         with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => fixture("#{user}.html"), :headers => {})
  end

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

def fixture_stats
  {
    'osahyoun' => {
      :username => 'osahyoun',
      :rank => 6329,
      :word_count => 315,
      :points => 112726,
      :thumbs_up => 0,
      :high_fives => 2,
      :courses_total => 5,
      :courses => [
        ["French - The 1170 most common verbs", "http://www.memrise.com/set/10004259/french-the-1170-most-common-verbs/"],
        ["Introductory Spanish", "http://www.memrise.com/set/10007193/introductory-spanish/"]
      ]
    },
    'MonkeyKing' => {
      :username => 'MonkeyKing',
      :rank => 44,
      :word_count => 2961,
      :points => 2197050,
      :thumbs_up => 0,
      :high_fives => 68,
      :courses_total => 9,
      :courses => [
        ["Characters 501 - 1000 in Mandarin", "http://www.memrise.com/set/10011007/characters-501-1000-in-mandarin/"],
        ["高级汉语口语 上册", "http://www.memrise.com/set/10019695/-305/"]
      ]
    }
  }

end
