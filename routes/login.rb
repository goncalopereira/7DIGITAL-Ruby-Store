get '/login' do
  puts 'login'
  haml :login
end

post '/login' do
  country = get_country
  email = params[:email]
  password = params[:password]

	credentials = Credentials.new
	api_client = get_api_client credentials, country

  session[:user] = api_client.user.authenticate(email,password)

  redirect "/#{country}"
end

get '/logout' do
  session[:user] = nil
  redirect "/"
end
