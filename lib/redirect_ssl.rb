def is_secure?

	if !request.secure? and settings.environment != :development
		return false
	else 
		return true
	end	
end

def needs_ssl
	if !is_secure?
		redirect 'https://' + request.host + request.path
	end
end
