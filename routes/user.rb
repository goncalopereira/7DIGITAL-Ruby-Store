get '/user' do

	pass unless !@user.nil?
	
	haml :user
end
