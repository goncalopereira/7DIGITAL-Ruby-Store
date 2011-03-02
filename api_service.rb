require 'net/http'
require 'xmlsimple'

class APIService

def get_usable_track_url preview_url, key_param
	url = "#{preview_url}#{key_param}&redirect=false"
	url_parse = URI.parse(url)
	print = Net::HTTP.get_response(url_parse)
	api_response = print.body
	data = XmlSimple.xml_in(api_response)
	return data['url']
end

def get_tracks release_tracks, credentials_key
	tracks = Array.new
	extra_key_parameters_per_track = "&oauth_consumer_key=" + credentials_key
	release_tracks.each do |track|		
		url = get_usable_track_url(track.preview_url,extra_key_parameters_per_track) 
		tracks << Track.new(track.artist.name, track.title, url)
	end
	
	return tracks
end

end