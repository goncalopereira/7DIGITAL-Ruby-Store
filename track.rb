class Track
	def artist_name
		@artist_name
	end
	
	def track_name
		@track_name
	end
	
	def url
		@url
	end
	
	def initialize artist, track, url
		@artist_name = artist
		@track_name = track
		@url = url
	end	
end