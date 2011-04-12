get '/login' do
	needs_ssl
	pass if !@user.nil?

	haml :login
end

post '/login' do
	needs_ssl
	pass if !@user.nil?

	email = params[:email]
	password = params[:password]

	session[:user] = @api_client.user.authenticate(email,password)

 	redirect '/'
end

get '/logout' do
	needs_ssl
  	pass if @user.nil?
	
	session[:user] = nil

  	redirect "/"
end
