require 'net/http'
require 'xmlsimple'

class JSStrings

def get_usable_track_url preview_url, key_param
	url = "#{preview_url}#{key_param}&redirect=false"
	url_parse = URI.parse(url)
	print = Net::HTTP.get_response(url_parse)
	api_response = print.body
	data = XmlSimple.xml_in(api_response)
	return data['url']
end

def track_list_string track_list
		track_list_js_string = ""  
		track_list.each do |track|
		
		track_list_js_string = track_list_js_string + "{name:\"#{track.artist_name}-#{track.track_name}\",mp3:\" #{track.url}\"},"
	end
  
	return "[" + track_list_js_string + "]"	
end
end

class APIService

def get_usable_track_url preview_url, key_param
	url = "#{preview_url}#{key_param}&redirect=false"
	url_parse = URI.parse(url)
	print = Net::HTTP.get_response(url_parse)
	api_response = print.body
	data = XmlSimple.xml_in(api_response)
	return data['url']
end

def get_tracks
	
end

end