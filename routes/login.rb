get '/login' do
  haml :login
end

post '/login' do
	email = params[:email]
	password = params[:password]

	session[:user] = @api_client.user.authenticate(email,password)

 	redirect '/'
end

get '/logout' do
  session[:user] = nil
  redirect "/"
end
