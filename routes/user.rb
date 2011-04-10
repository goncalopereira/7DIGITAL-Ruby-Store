get '/user' do

	@api_client.card
	if @user.nil?
		redirect '/'
	end
	
	haml :user
end
