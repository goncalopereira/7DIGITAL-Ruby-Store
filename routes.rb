require 'rubygems'
require 'sevendigital'
require 'sinatra'
require 'haml'

Dir["./lib/*.rb"].each {|file| require file }
Dir["./models/*.rb"].each {|file| require file }

use Rack::Session::Pool
set :environment, :development

before do 
	country = get_country
	credentials = Credentials.new
	@api_client = get_api_client credentials, country
	
	@user = session[:user]
	@basket = get_basket @api_client
end

def get_api_client credentials, country
		
	return Sevendigital::Client.new(
		:oauth_consumer_key => credentials.key,
        :oauth_consumer_secret => credentials.secret,
        :lazy_load? => true,
        :country => country,
        :cache => VerySimpleCache.new,
        :verbose => "verbose"
   )	  	   
end

def get_basket api_client
  if session[:basket].nil?
    session[:basket] = api_client.basket.create()
  end

  session[:basket]
end

def get_country
  if session[:country].nil?
    'GB'
  else
    session[:country]
  end
end

Dir["./routes/*.rb"].each {|file| require file }

get '/:country' do |country|
  session[:country] = country
	redirect '/'
end

get '/' do
  redirect '/search'
end
