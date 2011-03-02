require File.expand_path('../../spec_helper', __FILE__)

describe "ArtistManager" do

  before do
    @client = stub(Sevendigital::Client)
    @client.stub!(:operator).and_return(mock(Sevendigital::ApiOperator))
    @artist_manager = Sevendigital::ArtistManager.new(@client)
  end

  it "get_details should call artist/details api method and return digested artist" do
    an_artist_id = 123
    an_artist = Sevendigital::Artist.new(@client)
    an_api_response = fake_api_response("release/details")

    mock_client_digestor(@client, :artist_digestor) \
          .should_receive(:from_xml).with(an_api_response.content.artist).and_return(an_artist)

    @client.should_receive(:make_api_request) \
            .with(:GET, "artist/details", {:artistId => an_artist_id}, {}) \
            .and_return(an_api_response)

    artist = @artist_manager.get_details(an_artist_id)
    artist.should == an_artist
	end

  it "get_releases should call artist/releases api method and return list of digested releases" do
    an_artist_id = 123
    a_list_of_releases = [Sevendigital::Release.new(@client), Sevendigital::Release.new(@client)]
    an_api_response = fake_api_response("artist/releases")

    mock_client_digestor(@client, :release_digestor) \
         .should_receive(:list_from_xml).with(an_api_response.content.releases).and_return(a_list_of_releases)

    @client.should_receive(:make_api_request) \
            .with(:GET, "artist/releases", {:artistId => an_artist_id}, {}) \
            .and_return(an_api_response)
    
    releases = @artist_manager.get_releases(an_artist_id)
    releases.should == a_list_of_releases
  end

  it "get_top_tracks should call artist/topTracks method and digest the returned list of tracks" do
    an_artist_id = 123
    a_top_tracks_list = [Sevendigital::Track.new(@client)]
    an_api_response = fake_api_response("artist/toptracks")
    
    mock_client_digestor(@client, :track_digestor) \
        .should_receive(:list_from_xml).with(an_api_response.content.tracks).and_return(a_top_tracks_list)

    @client.should_receive(:make_api_request) \
            .with(:GET, "artist/topTracks", {:artistId => an_artist_id}, {}) \
            .and_return(an_api_response)

    tracks = @artist_manager.get_top_tracks(an_artist_id)
    tracks.should == a_top_tracks_list

  end

  it "get_similar should call artist/similar method and digest the returned list of artists" do
    an_artist_id = 123
    a_similar_artists_list = [Sevendigital::Artist.new(@client), Sevendigital::Artist.new(@client)]
    an_api_response = fake_api_response("artist/similar")

    mock_client_digestor(@client, :artist_digestor) \
        .should_receive(:list_from_xml).with(an_api_response.content.artists).and_return(a_similar_artists_list)

    @client.should_receive(:make_api_request) \
            .with(:GET, "artist/similar", {:artistId => an_artist_id}, {}) \
            .and_return(an_api_response)

    artists = @artist_manager.get_similar(an_artist_id)
    artists.should == a_similar_artists_list

  end

  it "get_top_by_tag should call artist/byTag/top api method and digest the nested artist list from response" do

    tags = "alternative-indie"
    an_api_response = fake_api_response("artist/byTag/top")
    a_release_list = []

    mock_client_digestor(@client, :artist_digestor) \
      .should_receive(:nested_list_from_xml) \
      .with(an_api_response.content.tagged_results, :tagged_item, :tagged_results) \
      .and_return(a_release_list)

    @client.should_receive(:make_api_request) \
            .with(:GET, "artist/byTag/top", {:tags => tags}, {}) \
            .and_return(an_api_response)

    releases = @artist_manager.get_top_by_tag(tags)
    releases.should == a_release_list

  end

  it "browse should call artist/browse api method and digest the artist list from response" do

    letter = "ra"
    an_api_response = fake_api_response("artist/browse")
    an_artist_list = []

    mock_client_digestor(@client, :artist_digestor) \
      .should_receive(:list_from_xml) \
      .with(an_api_response.content.artists) \
      .and_return(an_artist_list)

    @client.should_receive(:make_api_request) \
            .with(:GET, "artist/browse", {:letter => letter}, {}) \
            .and_return(an_api_response)

    artists = @artist_manager.browse(letter)
    artists.should == an_artist_list

  end


  it "get_chart should call artist/chart api method and digest the artist list from response" do

    api_response = fake_api_response("artist/chart")
    a_chart = [Sevendigital::ChartItem.new(@client)]

    mock_client_digestor(@client, :chart_item_digestor) \
        .should_receive(:list_from_xml).with(api_response.content.chart).and_return(a_chart)

    @client.should_receive(:make_api_request) \
      .with(:GET, "artist/chart", {}, {}) \
      .and_return(api_response)

    chart = @artist_manager.get_chart
    chart.should == a_chart
  end


  it "get_tags should call artist/tags api method and return list of digested tags" do
    an_artist_id = 123
    a_list_of_tags = [Sevendigital::Tag.new, Sevendigital::Tag.new]
    an_api_response = fake_api_response("artist/tags")
    options = {:page => 1}

    mock_client_digestor(@client, :tag_digestor) \
         .should_receive(:list_from_xml).with(an_api_response.content.tags).and_return(a_list_of_tags)

    @client.should_receive(:make_api_request) \
            .with(:GET, "artist/tags", {:artistId => an_artist_id}, options) \
            .and_return(an_api_response)

    releases = @artist_manager.get_tags(an_artist_id, options)
    releases.should == a_list_of_tags
  end

end