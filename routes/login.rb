get '/login/:session_id' do |session_id|
	pass if session.object_id.to_s != session_id.to_s #who is this!?
	pass if params['status'] != 'Authorised'
	pass if session[:request_token].nil?
	
	access_token = @api_client.oauth.get_access_token(session[:request_token])
	
	session[:user] = @api_client.user.login(access_token)
	
	redirect '/'
end

get '/login' do
	pass if !@user.nil?

	request_token = @api_client.oauth.get_request_token()
	
	session[:request_token] = request_token
	credentials = Credentials.new
	key = credentials.key

	redirect "https://account.7digital.com/#{key}/oauth/authorise?oauth_token=#{request_token.token}&oauth_callback=http%3a%2f%2f#{settings.host_name}%2flogin%2f#{session.object_id}"
end

get '/logout' do
  	pass if @user.nil?
	
	session[:user] = nil

  	redirect "/"
end
