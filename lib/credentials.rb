class Credentials
	attr_accessor :key, :secret
	
	def initialize		
			@key = ENV['SD_API_KEY']
			@secret = ENV['SD_API_SECRET']
		
      if @key.nil? or @key == '' or @secret.nil? or @secret == ''
        throw 'no credentials found, please set up SD_API_KEY and SD_API_SECRET'
      end
	end
		
end
