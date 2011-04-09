require 'rubygems'
require 'sevendigital'
require 'sinatra'
require 'haml'

Dir["./lib/*.rb"].each {|file| require file }
Dir["./models/*.rb"].each {|file| require file }
Dir["./routes/*.rb"].each {|file| require file }

use Rack::Session::Pool
set :environment, :development

get %r{/([A-Z][A-Z])?} do |country|

  	if !country.nil? and country != ''
		session[:country] = country
	end

	haml :index
end

