get '/locker' do
	redirect '/locker/0/0'
end

get '/locker/:release_id/:track_id' do |release_id,track_id|
  country = get_country
  credentials = Credentials.new
  api_client = get_api_client credentials, country

  @user = session[:user]
  @basket = get_basket api_client

	if !@user.nil?
   	
		@locker = api_client.user.get_locker(@user.oauth_access_token)
    
		if release_id != 0
			@player_track_url = api_client.user.get_stream_track_url(release_id, track_id, @user.oauth_access_token)
		end
		
	haml :locker
  else
    redirect '/'
  end
end
