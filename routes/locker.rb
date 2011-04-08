get '/locker' do
  country = get_country
  credentials = Credentials.new
  api_client = get_api_client credentials, country

  @user = session[:user]
  @basket = get_basket api_client

  if @user != nil
    puts @user.oauth_access_token
    @locker = api_client.user.get_locker(@user.oauth_access_token)
    haml :locker
  else
    redirect '/'
  end
end