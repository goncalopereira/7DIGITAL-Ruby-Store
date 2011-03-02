require "spec_helper"
require 'ostruct'
require 'oauth'

describe "ApiOperator" do

  before do
    response_digestor = stub(Sevendigital::ApiResponseDigestor)
    response_digestor.stub!(:from_http_response). and_return(fake_digested_response)

    stub_api_client(test_configuration, response_digestor)

    Net::HTTP.stub!(:get_response).and_return(fake_api_response)

    @api_operator = Sevendigital::ApiOperator.new(@client)

    @stub_api_request = stub_api_request()

  end

  it "should create http request uri based on api method and client configuration" do

    api_request = Sevendigital::ApiRequest.new(:GET, "api/method", {:param1 => "value", :paramTwo => 2})

    uri = @api_operator.create_request_uri(api_request)

    uri.kind_of?(URI).should == true

    uri.to_s.should =~ /http:\/\/base.api.url\/version\/api\/method/
    uri.to_s.should =~ /[\?\&]param1=value/
    uri.to_s.should =~ /[\?\&]paramTwo=2/

  end

  it "should URL encode parameters accourding to OAuth spec" do

    api_request = Sevendigital::ApiRequest.new(:GET, "api/method", {:param1 => "a+b@c.d", :paramTwo => "<a b>"})

    uri = @api_operator.create_request_uri(api_request)

    uri.to_s.should =~ /[\?\&]param1=a%2Bb%40c.d/
    uri.to_s.should =~ /[\?\&]paramTwo=%3Ca%20b%3E/

  end

  it "should create http GET request" do

    api_request = Sevendigital::ApiRequest.new(:GET, "api/method", {:param1 => "value", :paramTwo => 2})

    client, request = @api_operator.create_http_request(api_request)

    request.class.should == Net::HTTP::Get

  end

  it "should create http POST request" do

    api_request = Sevendigital::ApiRequest.new(:POST, "api/method", {:param1 => "value", :paramTwo => 2})

    client, request = @api_operator.create_http_request(api_request)

    request.class.should == Net::HTTP::Post

  end

  it "should create http DELETE request" do

    api_request = Sevendigital::ApiRequest.new(:DELETE, "api/method", {:param1 => "value", :paramTwo => 2})

    client, request = @api_operator.create_http_request(api_request)

    request.class.should == Net::HTTP::Delete

  end

  it "should create http PUT request" do

    api_request = Sevendigital::ApiRequest.new(:PUT, "api/method", {:param1 => "value", :paramTwo => 2})

    client, request = @api_operator.create_http_request(api_request)

    request.class.should == Net::HTTP::Put

  end

  it "should have empty body if no form parameters provided" do

    api_request = Sevendigital::ApiRequest.new(:GET, "api/method", {:param1 => "value", :paramTwo => 2})

    client, request = @api_operator.create_http_request(api_request)

    request.instance_variable_get("@body").empty?.should == true

  end

  it "should set up any form parameters in body" do

    api_request = Sevendigital::ApiRequest.new(:GET, "api/method", {:param1 => "value", :paramTwo => 2})
    api_request.form_parameters[:shop_id] = "1234"
    api_request.form_parameters[:email] = "test+email@example.com"
    api_request.form_parameters[:ignore] = nil

    client, request = @api_operator.create_http_request(api_request)

    #request.instance_variable_get("@body").should == "email=test%40example.com&shopId=1234"
    request.instance_variable_get("@body").should =~ /email=test%2Bemail%40example.com/
    request.instance_variable_get("@body").should =~ /shopId=1234/
  end

  it "should create HTTPS request uri based on api method that requires secure connection and client configuration" do

    api_request = Sevendigital::ApiRequest.new(:GET, "api/method", {:param1 => "value", :paramTwo => 2})
    api_request.require_secure_connection

    uri = @api_operator.create_request_uri(api_request)

    uri.kind_of?(URI).should == true

    uri.to_s.should =~ /https:\/\/base.api.url\/version\/api\/method/
    uri.to_s.should =~ /[\?\&]param1=value/
    uri.to_s.should =~ /[\?\&]paramTwo=2/

  end

  it "should create http request uri based on api method for non standard api service" do

    @client.should_receive(:api_host_and_version).with(:media).and_return(["media-base.api.url","media-version"])

    api_request = Sevendigital::ApiRequest.new(:GET, "api/method", {:param1 => "value", :paramTwo => 2})
    api_request.api_service = :media
    uri = @api_operator.create_request_uri(api_request)

    uri.kind_of?(URI).should == true

    uri.to_s.should =~ /http:\/\/media-base.api.url\/media-version\/api\/method/
    uri.to_s.should =~ /[\?\&]param1=value/
    uri.to_s.should =~ /[\?\&]paramTwo=2/

  end

  it "should make HTTP request and get http response" do

    http_response = fake_api_response

    @stub_http_request = stub(Net::HTTP::Get)
    @stub_http_client =  stub(Net::HTTP)

    @api_operator.should_receive(:create_http_request).with(@stub_api_request).and_return([@stub_http_client, @stub_http_request])

    @stub_http_client.should_receive(:request).with(@stub_http_request).and_return(http_response)

    response = @api_operator.make_http_request(@stub_api_request)

    response.should == http_response

  end

  it "should digest the HTTP response and get it out" do

    http_response = fake_api_response
    digested_response = fake_digested_response

    @client.api_response_digestor.should_receive(:from_http_response).with(http_response).and_return(digested_response)

    response = @api_operator.digest_http_response(http_response)

    response.should == digested_response

  end

    it "should call API by making an http request and digesting the response" do

    http_response = fake_api_response
    digested_response = fake_digested_response

    @api_operator.should_receive(:make_http_request).and_return(http_response)

    @client.api_response_digestor.should_receive(:from_http_response).with(http_response).and_return(digested_response)

    response = @api_operator.call_api(@stub_api_request)

    response.should == digested_response

  end

  it "should throw an exception if response is not ok" do

    failed_response = fake_digested_response(false)
    failed_response.stub!(:error_code).and_return(4000)
    failed_response.stub!(:error_message).and_return("error")
    @api_operator.should_receive(:make_http_request).and_return(fake_api_response)
    @client.api_response_digestor.stub!(:from_http_response).and_return(failed_response)
    
    running { @api_operator.call_api(@stub_api_request) }.should raise_error(Sevendigital::SevendigitalError) { |error|
      error.error_code.should == 4000
      error.error_message.should == "error"
    }

  end

  it "should create a 2-legged signed HTTP request" do
    api_request = Sevendigital::ApiRequest.new(:GET, "api/method", {:param1 => "value", :paramTwo => 2})
    api_request.require_signature
    http_client, http_request = @api_operator.create_http_request(api_request)
    http_client.use_ssl?.should == false
    http_request.path.should =~ /api\/method/
    http_request.path.should =~ /param1=value/
    http_request["Authorization"].should =~ /OAuth oauth_consumer_key="oauth_consumer_key"/
    http_request["Authorization"].should =~ / oauth_signature=/
#   http_request["Authorization"].should !=~ / oauth_token="token"/
  end

  it "should create a 3-legged signed HTTP request" do
    api_request = Sevendigital::ApiRequest.new(:GET, "api/method", {:param1 => "value", :paramTwo => 2})
    api_request.require_signature
    api_request.token = OAuth::AccessToken.new(@client.oauth_consumer, "token", "secret")
    http_client, http_request = @api_operator.create_http_request(api_request)
    http_client.use_ssl?.should == false
    http_request.path.should =~ /api\/method/
    http_request.path.should =~ /param1=value/
    http_request["Authorization"].should =~ /OAuth oauth_consumer_key="oauth_consumer_key"/
    http_request["Authorization"].should =~ / oauth_signature=/
    http_request["Authorization"].should =~ / oauth_token="token"/
  end

  it "should create a 3-legged signed HTTPS request" do
    api_request = Sevendigital::ApiRequest.new(:GET, "api/method", {:param1 => "value", :paramTwo => 2})
    api_request.require_signature
    api_request.require_secure_connection
    api_request.token = OAuth::AccessToken.new(@client.oauth_consumer, "token", "secret")
    http_client, http_request = @api_operator.create_http_request(api_request)
    http_client.inspect.should =~ /base\.api\.url:443/
    http_client.use_ssl?.should == true
    http_client.verify_mode.should == OpenSSL::SSL::VERIFY_NONE
    http_request.path.should =~ /api\/method/
    http_request.path.should =~ /param1=value/
    http_request["Authorization"].should =~ /OAuth oauth_consumer_key="oauth_consumer_key"/
    http_request["Authorization"].should =~ / oauth_signature=/
    http_request["Authorization"].should =~ / oauth_token="token"/
  end

  it "should create a standard HTTP request" do
    api_request = Sevendigital::ApiRequest.new(:GET, "api/method", {:param1 => "value", :paramTwo => 2})
    http_client, http_request = @api_operator.create_http_request(api_request)
    http_client.inspect.should =~ /base\.api\.url:80/
    http_client.use_ssl?.should == false
    http_request.path.should =~ /api\/method/
    http_request.path.should =~ /param1=value/
    http_request.path.should =~ /oauth_consumer_key=oauth_consumer_key/
  end

  it "should add custom user agent info to created HTTP request" do

    @client.stub!(:user_agent_info).and_return("7digital Gem")

    api_request = Sevendigital::ApiRequest.new(:GET, "api/method", {:param1 => "value", :paramTwo => 2})
    http_client, http_request = @api_operator.create_http_request(api_request)
    http_request["User-agent"].should =~ /7digital Gem/
  end

  it "get_request_uri should return oauth sign URI if api request requires signature" do

    api_request = Sevendigital::ApiRequest.new(:GET, "api/method", {:param1 => "value", :paramTwo => 2})
    api_request.token = OAuth::AccessToken.new(nil, "token", "token_secret")
    api_request.require_signature
    api_request.require_secure_connection
    signed_uri =  @api_operator.get_request_uri(api_request)

    signed_uri.should =~ /oauth_signature=/
    signed_uri.should =~ /oauth_consumer_key=oauth_consumer_key&/
    signed_uri.should =~ /oauth_token=token&/
    signed_uri.should =~ /https:\/\/base.api.url\/version\/api\/method/
  end

  it "get_request_uri should return simple request URI if api request does not require signature" do

    api_request = Sevendigital::ApiRequest.new(:GET, "api/method", {:param1 => "value", :paramTwo => 2})
    signed_uri =  @api_operator.get_request_uri(api_request)

    signed_uri.match(/oauth_signature=/).should == nil
    signed_uri.should =~ /oauth_consumer_key=oauth_consumer_key/
    signed_uri.should =~ /http:\/\/base.api.url\/version\/api\/method/
  end

  it "get_request_uri should return secure request URI if api request does not require signature" do

    api_request = Sevendigital::ApiRequest.new(:GET, "api/method", {:param1 => "value", :paramTwo => 2})
    api_request.require_secure_connection
    signed_uri =  @api_operator.get_request_uri(api_request)

    signed_uri.match(/oauth_signature=/).should == nil
    signed_uri.should =~ /oauth_consumer_key=oauth_consumer_key/
    signed_uri.should =~ /https:\/\/base.api.url\/version\/api\/method/
  end

  def test_configuration
    configuration = OpenStruct.new
    configuration.oauth_consumer_key = "oauth_consumer_key"
    return configuration
  end

  def fake_api_response(code = 200, body = "response_body")
    return Net::HTTP.new("1.1", code, body)
  end

  def fake_digested_response(is_ok = true)
    proxy =  stub(Peachy::Proxy)#.new('<response status="ok"><content>test</content></response>')
    proxy.stub!(:ok?).and_return(is_ok)
    proxy
  end

  def stub_api_client(configuration, response_digestor)
  @client = stub(Sevendigital::Client)
  @client.stub!(:configuration).and_return(configuration)
  @client.stub!(:oauth_consumer).and_return(OAuth::Consumer.new( configuration.oauth_consumer_key, configuration.oauth_consumer_secret))
  @client.stub!(:api_response_digestor).and_return(response_digestor)
  @client.stub!(:default_parameters).and_return({:country => 'sk'})
  @client.stub!(:user_agent_info).and_return("7digital")
  @client.stub!(:verbose?).and_return(false)
  @client.stub!(:very_verbose?).and_return(false)
  @client.stub!(:api_host_and_version).and_return(["base.api.url","version"])

end

def stub_api_request
  api_request = stub(Sevendigital::ApiRequest)

  api_request.stub!(:parameters).and_return({})
  api_request.stub!(:api_service).and_return(nil)
  api_request.stub!(:api_method).and_return("m")
  api_request.stub!(:requires_signature?).and_return(false)
  api_request.stub!(:requires_secure_connection?).and_return(false)
  api_request.stub!(:ensure_country_is_set)
  return api_request
end

end