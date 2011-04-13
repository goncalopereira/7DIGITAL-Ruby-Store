	

get %r{/locker/([0-9]+)/download/([0-9]+)/([0-9]+)} do |page_number,release_id,track_id|
	pass if @user.nil?
	
	@locker = @api_client.user.get_locker(@user.oauth_access_token, {:page => page_number})

	@locker.locker_releases.each do |locker_release|
		locker_release.locker_tracks.each do |locker_track|
			if locker_release.release.id == release_id.to_i and locker_track.track.id == track_id.to_i
				redirect locker_track.download_urls[0].url
			end 
		end
	end	

	pass
end

get %r{/locker/stream/([0-9]+)/([0-9]+)} do |release_id,track_id|
	pass if @user.nil?

	redirect @api_client.user.get_stream_track_url(release_id, track_id, @user.oauth_access_token)
end

get %r{/locker(\/)?([0-9]*)} do |slash,page_number|
   
	pass if @user.nil?
		
	@page_number = 1 
	@page_number = page_number.to_i unless page_number.nil? or page_number.nil? or page_number.to_i == 0
	
	puts @page_number
	
	@locker = @api_client.user.get_locker(@user.oauth_access_token, {:page => @page_number})
	
	haml :locker
end	
