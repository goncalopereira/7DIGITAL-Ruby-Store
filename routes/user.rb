get '/user' do

	pass if @user.nil?
	
	@cards = @user.get_cards
	
	haml :user
end
