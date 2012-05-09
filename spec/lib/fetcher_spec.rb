require 'helper'
require 'fetcher'
require 'json'

describe Sunrize::Fetcher do
  it "should work" do
    Sunrize::Fetcher.new('foobar').should be_a Sunrize::Fetcher
  end

  it "should be instantiable" do
    f = Sunrize::Fetcher.find('foobar')
    f.username.should == 'foobar'
  end

  describe 'user' do

    context 'is not registered on memrise' do
      it 'should say when memrise returns a 404' do
        stub_request(:get, "http://www.memrise.com/user/barney/").
             with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
             to_return(:status => 404, :body => fixture("not_found.html"), :headers => {})

        lambda do
          @user = Sunrize::Fetcher.fetch('barney')
        end.should raise_error(Sunrize::UserNotFoundError)
      end
    end

    context "user has no rank" do
      it "should know return blank" do
        stub_request(:get, "http://www.memrise.com/user/barney/").
             with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
             to_return(:status => 200, :body => fixture("no_ranking.html"), :headers => {})

        @user = Sunrize::Fetcher.fetch('barney')
        @user.rank.should == ''

      end
    end


    ['osahyoun', 'MonkeyKing'].each do |user|
      context "when user is #{user}" do

        before(:each) do
          stub_get(user)
          @user = Sunrize::Fetcher.fetch(user)
          @s = fixture_stats[user]
        end

        it "should know url" do
          @user.url.should == "http://www.memrise.com/user/#{user}/"
        end

        it "should know rank" do
          @user.rank.should == @s[:rank]
        end

        it "should know learnt words total" do
          @user.word_count.should == @s[:word_count]
        end

        it "should know points total" do
          @user.points.should == @s[:points]
        end

        it "should know rating total" do
          @user.thumbs_up.should == @s[:thumbs_up]
        end

        it "should know high-fives total" do
          @user.high_fives.should == @s[:high_fives]
        end

        it "should know courses total" do
          @user.courses_total.should == @s[:courses_total]
        end

        it "should know names of courses" do
          JSON.parse(@user.courses).first.should == @s[:courses].first
          JSON.parse(@user.courses).last.should == @s[:courses].last
        end
      end
    end

    describe 'persistence' do
      before do
        stub_get('osahyoun')
        @redis = Redis.new
      end

      before(:each) do
        @redis.del 'sunrize:osahyoun'
      end

      it "should save user to redis" do
        @redis.exists('sunrize:osahyoun').should be(false)
        Sunrize::Fetcher.fetch('osahyoun')
        @redis.exists('sunrize:osahyoun').should be(true)
      end

    end
  end
end