get '/user' do

	pass if @user.nil?
	
	haml :user
end
