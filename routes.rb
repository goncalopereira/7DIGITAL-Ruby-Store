require 'rubygems'
require 'sevendigital'
require 'sinatra'
require 'haml'

Dir["./lib/*.rb"].each {|file| require file }
Dir["./models/*.rb"].each {|file| require file }
Dir["./routes/*.rb"].each {|file| require file }

use Rack::Session::Pool
set :environment, :development

get '/:country' do |country|
  session[:country] = country
	redirect '/'
end

get '/' do
  haml :index
end
