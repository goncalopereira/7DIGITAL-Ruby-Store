get %r{/locker(\/?)([0-9]*)(\/?)([0-9]*)} do |slash,release_id,slash_2,track_id|

	if !@user.nil?
   	
		@locker = @api_client.user.get_locker(@user.oauth_access_token)
    
		if release_id != '' and track_id != ''
			@player_track_url = @api_client.user.get_stream_track_url(release_id, track_id, @user.oauth_access_token)
		end
		
		haml :locker
  	else
    		redirect '/'
  	end
end
