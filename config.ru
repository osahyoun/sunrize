$LOAD_PATH << './lib'

require 'bundler/setup'
require './application'

run Sinatra::Application


