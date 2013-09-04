require 'spec_helper'

describe "FakeSensu::Api" do
  include Rack::Test::Methods
  
  def app
    FakeSensu::Api
  end


  describe "GET /info" do
    it "returns an info hash" do
      get "/info"
      last_response.should be_ok
      body = last_response.body
      body.should be_a String
      JSON.parse(body).should be_a Hash
    end


    it "sets the version passed in" do
      get "/info"
      body = JSON.parse(last_response.body)
      version = body["sensu"]["version"]
      version.should eq "0.10.2"
    end
  end

  describe "GET /clients" do
    before :each do
      get "/clients"
      last_response.should be_ok
      @body = JSON.parse(last_response.body)
    end

    it "returns a clients array" do
      @body.should be_a Array
    end

    it "should return 2 clients" do
      @body.count.should eq 2
    end

    it "should include a client with an fqdn-type name" do
      fqdns = []
      @body.each do |hash|
        if hash["name"].include? "www.fqdn.com"
          fqdns << hash
        end
      end
      fqdns.count.should eq 1
    end
  end

  describe "GET /clients/:name" do
    it "should return a client with an fqdn name" do
      get "/clients/www.fqdn.com"
      last_response.should be_ok
      body = JSON.parse(last_response.body)
      body.should be_a Hash
    end
  end

  describe "GET /checks" do
    it "should return 2 checks" do
      get "/checks"
      last_response.should be_ok
      body = JSON.parse(last_response.body)
      body.should be_a Array
      body.count.should eq 2
    end
  end

  describe "GET /check/request" do
    it "should be successful" do
      header = {'Content-Type' => 'application/json'}
      body = {:check => "tokens"}.to_json
      post "/check/request", body, header
      last_response.should be_ok
    end
  end

  describe "GET /events" do
    before :each do 
      get "/events"
      @body = JSON.parse(last_response.body)
    end

    it "should be successful" do
      last_response.should be_ok
    end

    it "should return 4 events" do
      @body.count.should eq 4
    end
  end

  describe "GET /events/:client_name" do
    it "should return events for a client" do
      get "/events/www.fqdn.com"
      body = JSON.parse(last_response.body)
      last_response.should be_ok
      body.count.should eq 2
    end
  end

  describe "GET /events/:client_name/:check_name" do
    it "should return events for a client and check name" do
      get "/events/www.fqdn.com/test"
      body = JSON.parse(last_response.body)
      last_response.should be_ok
      body.should be_a Hash
    end
  end

  describe "DELETE /events/:client_name/:check_name" do
    it "should resolve an event by client and check name" do
      get "/events"
      pre_events = JSON.parse(last_response.body)
      pre_events.count.should eq 4
      delete "/events/www.fqdn.com/test"
      last_response.should be_ok
      get "/events"
      post_events = JSON.parse(last_response.body)
      post_events.count.should eq 3
      get "/reset"
    end
  end

  describe "GET /stashes" do
    it "should return a list of stashes" do
      get "/stashes"
      body = JSON.parse(last_response.body)
      last_response.should be_ok
      body.count.should eq 2
    end
  end

  describe "GET /stashes/:path" do
    it "should return a single stash" do
      get "/stashes/test/test"
      body = eval(last_response.body)
      body.should be_a Hash
      body["key"].should eq "value"
    end
  end

  describe "POST /stashes" do
    it "should create a stash" do
      get "/stashes"
      stashes = JSON.parse(last_response.body)
      stashes.count.should eq 2
      header = {'Content-Type' => 'application/json'}
      body = {:path => "test_stash", 
              :content => 
              {:reason => "testing stashes"}}.to_json
      post "/stashes", body, header
      last_response.should be_ok
      get "/stashes"
      stashes = JSON.parse(last_response.body)
      stashes.count.should eq 3
      get "/reset"
    end
  end

  describe "DELETE /stashes/:path" do
    it "should resolve a stash" do
      get "/stashes"
      stashes = JSON.parse(last_response.body)
      stashes.count.should eq 2
      delete "/stashes/test/test"
      last_response.should be_ok
      get "/stashes"
      stashes = JSON.parse(last_response.body)
      stashes.count.should eq 1
      get "/reset"
    end
  end

end
