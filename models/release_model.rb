load 'lib/js_strings.rb'

class ReleaseModel	
	def image_url
		@image_url
	end
	
	def release_name
		@release_name
	end
	
	def js_array_tracks
		@tracks
	end
	
	def artist_name
		@artist_name
	end
	
	def url
		@url
	end
	
	def initialize release_image,artist_name,release_title,release_url,tracks
		@image_url = release_image
		@release_name = release_title
		js_string_helper = JSStrings.new
		@tracks = js_string_helper.track_list_string(tracks)
		@artist_name = artist_name
		@url = release_url
	end
	
end