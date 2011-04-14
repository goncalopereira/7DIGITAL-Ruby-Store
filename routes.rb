require 'rubygems'
require 'sevendigital'
require 'sinatra'
require 'haml'

Dir["./lib/*.rb"].each {|file| require file }
Dir["./models/*.rb"].each {|file| require file }
Dir["./routes/*.rb"].each {|file| require file }
require './index.rb' #moving to routes folder will make catch-all go first

use Rack::Session::Pool
set :environment, :development
set :host_name, ENV['SD_API_HOST_NAME']
set :api_key, ENV['SD_API_KEY']
set :api_secret,ENV['SD_API_SECRET']


