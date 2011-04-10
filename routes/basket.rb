get %r{(/partial)?/basket/add/([0-9]+)(\/?)([0-9]*)} do |partial,release_id,slash,track_id|
  
	track_id = nil if track_id == ''

	@basket = @api_client.basket.add_item(session[:basket].id,release_id, track_id)
	session[:basket] = @basket

  	if partial.nil?
		redirect '/'
	else 
		haml :'/partials/basket_partial'
	end
end

get %r{(/partial)?/basket/remove/([0-9]+)} do  |partial,item_id|

  	@basket = @api_client.basket.remove_item(session[:basket].id,item_id)
	session[:basket] = @basket

	if partial.nil?
		redirect '/'
	else
		haml :'/partials/basket_partial'
	end
end
