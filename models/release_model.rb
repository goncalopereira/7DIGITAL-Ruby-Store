load 'lib/js_strings.rb'

class ReleaseModel	

	attr_accessor :image_url,:release_name,:tracks,:artist_name,:url, :release_date, :label

  def formatted_date
    @release_date.strftime("%d/%m/%Y")
  end

  def js_array_tracks
    js_string_helper = JSStrings.new
    js_string_helper.track_list_string(tracks)
  end
	
end