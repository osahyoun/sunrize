require 'sinatra'
require 'sinatra/jsonp'
require './lib/user'
require './lib/fetcher'

get '/' do
  if params[:username]
    @user = Sunrize::User.find(params[:username])
  end
  erb :index
end

get '/user/:username' do
  content_type :json
  JSONP Sunrize::User.find(params[:username])
end

post '/check_name' do
  begin
    unless Sunrize::User.exists?(params[:username])
      Sunrize::Fetcher.fetch(params[:username])
    end
    redirect "/?username=#{params[:username]}"
  rescue Sunrize::UserNotFoundError
    redirect "/?s=not_found"
  else
    redirect "/"
  end
end