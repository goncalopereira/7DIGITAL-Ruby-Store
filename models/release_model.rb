load 'lib/js_strings.rb'

class ReleaseModel	

	attr_accessor :image_url,:release_name,:js_array_tracks,:artist_name,:url, :release_date, :label

	def initialize release_image,artist_name,release_title,release_url,tracks
		@image_url = release_image
		@release_name = release_title
		js_string_helper = JSStrings.new
		@js_array_tracks = js_string_helper.track_list_string(tracks)
		@artist_name = artist_name
		@url = release_url
	end
	
end