class Credentials
	attr_accessor :key, :secret
	
	def initialize
		
		credentials_file_name = 'credentials'

		if File.exists?(credentials_file_name)				
			file = File.new(credentials_file_name,"r")	
			@key = file.gets.split.join("\n")
			@secret = file.gets.split.join("\n")
		else
			throw  'no credentials file'
		end
	end
		
end
