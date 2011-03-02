class JSStrings

def track_list_string track_list
		track_list_js_string = ""  
		track_list.each do |track|
		
		track_list_js_string = track_list_js_string + "{name:\"#{track.artist_name}-#{track.track_name}\",mp3:\" #{track.url}\"},"
	end
  
	return "[" + track_list_js_string + "]"	
end
end
