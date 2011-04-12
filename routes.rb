require 'rubygems'
require 'sevendigital'
require 'sinatra'
require 'haml'

Dir["./lib/*.rb"].each {|file| require file }
Dir["./models/*.rb"].each {|file| require file }
Dir["./routes/*.rb"].each {|file| require file }

use Rack::Session::Pool
set :environment, :development
set :host_name, ENV['SD_API_HOST_NAME']
set :api_key, ENV['SD_API_KEY']
set :api_secret,ENV['SD_API_SECRET']

get %r{/([A-Z][A-Z])?} do |country|

  	if !country.nil? and country != ''
		set_country country
		redirect '/' #refresh api_client with new country...
	end
	
	@release_chart = @api_client.release.get_chart()
	
	haml :index
end

