
class JSHelper

def track_list_string track_list, key_param
		track_list_js_string = ""  
		track_list.each do |track|
		url = "#{track.preview_url}#{key_param}&redirect=false"
		url_parse = URI.parse(url)
		print = Net::HTTP.get_response(url_parse)

		api_response = print.body
		data = XmlSimple.xml_in(api_response)

		track_list_js_string = track_list_js_string + "{name:\"#{track.artist.name}-#{track.title}\",mp3:\" #{data['url']}\"},"
	end
  
	return "[" + track_list_js_string + "]"	
end
end
