require 'json'
require 'sinatra'

module FakeSensu
  class Api < Sinatra::Base

    configure do
      version = ENV['FAKE_SENSU_VERSION'] || "0.10.2"
      response_path = File.dirname(__FILE__) + "/responses/#{version}.json"
      responses = JSON.parse(File.read(response_path))["index"]
      set :info, responses["info"]
      set :clients, responses["clients"]
      set :checks, responses["checks"]
      set :events, responses["events"]
      set :stashes, responses["stashes"]
      set :immutable_info, info.freeze 
      set :immutable_clients, clients.freeze 
      set :immutable_checks, checks.freeze 
      set :immutable_events, events.freeze 
      set :immutable_stashes, stashes.freeze 
    end

    get '/info' do
      content_type :json
      body settings.info
    end

    get '/clients' do
      content_type :json
      settings.clients
    end

    get %r{/clients/([\w\.-]+)$} do |client_name|
      content_type :json
      clients = JSON.parse(settings.clients)
      clients.each do |client|
        clients.each do |client|
          if client.has_value? client_name
            @body = client.reject! {|k| k == "name"}.to_json
          end
        end
      end
      @body ? "#{@body}" : ""
    end

    get '/checks' do
      content_type :json
      settings.checks
    end
    
    get %r{/checks?/([\w\.-]+)$} do |check_name|
      content_type :json
      checks = JSON.parse(settings.checks)
      checks.each do |check|
        if check.has_value? check_name
          @body = check.to_json
        end
      end
      @body ? "#{@body}" : ""
    end

    post %r{/(?:check/)?request$} do
      post_body = JSON.parse(request.body.read)
      check_name = post_body["check"]
      check = post_body["check"]
      subscribers = check["subscribers"].to_a 
      command = check["command"]
      payload = {
        :name => check_name,
        :command => command,
        :issued => Time.now.to_i
      }
      body payload
    end

    get '/events' do
      content_type :json
      body settings.events
    end

    get %r{/events/([\w\.-]+)$} do |client_name|
      content_type :json
      events = JSON.parse(settings.events)
      @body = []
      events.each do |event|
        if event.has_value? client_name
          @body << event.to_json
        end
      end
      @body ? "#{@body}" : ""
    end

    get %r{/events?/([\w\.-]+)/([\w\.-]+)$} do |client_name, check_name|
      content_type :json
      event_json = JSON.parse(settings.events)
      unless event_json.nil?
        event_json.each do |event|
          if event.has_value?(check_name) && event.has_value?(client_name)
            @body = event.to_json
          end
        end
      end
      @body ? "#{@body}" : ""
    end

    delete %r{/events?/([\w\.-]+)/([\w\.-]+)$} do |client_name, check_name|
      content_type :json
      events = JSON.parse(settings.events)
      events.each do |event|
        if event["client"] == client_name && event["check"] == check_name
          events.delete_if {|e| 
            (e.has_value?(check_name) && e.has_value?(client_name))
          }
          settings.events = events.to_json
        end
      end
      body ''
    end

    get '/stashes' do
      content_type :json
      body settings.stashes
    end

    get %r{/stash(?:es)?/(.*)} do |path|
      content_type :json
      stashes = JSON.parse(settings.stashes)
      stashes.each do |stash|
        if stash.has_value? path
          @body = stash["content"]
        end
      end
      @body ? "#{@body}" : ""
    end
    
    post %r{/stash(?:es)?/(.*)} do |path|
      content_type :json
      stashes = JSON.parse(settings.stashes)
      stashes = stashes + [{"path" => path, "content" => {"timestamp" => Time.now.to_i}}]
      settings.stashes = stashes.to_json
      body ''
    end

    post '/stashes' do 
      content_type :json
      post_body = JSON.parse(request.body.read)
      path = post_body["path"]
      content = post_body["content"]
      stashes = JSON.parse(settings.stashes)
      stashes = stashes + [{"path" => path, "content" => content}]
      settings.stashes = stashes.to_json
    end

    delete %r{/stash(?:es)?/(.*)} do |path|
      content_type :json
      stashes = JSON.parse(settings.stashes) 
      stashes.each do |stash|
        if stash.has_value? path
          stashes.delete_if {|stash| stash.has_value? path}
          settings.stashes = stashes.to_json
          body = ''
        else
          body = 'not found'
        end
      end
      body
    end

    get '/reset' do
      settings.info = settings.immutable_info
      settings.clients = settings.immutable_clients
      settings.checks = settings.immutable_checks
      settings.events = settings.immutable_events
      settings.stashes = settings.immutable_stashes
      body ''
    end
  end
end
