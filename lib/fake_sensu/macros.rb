module FakeSensu
  module FakeSensuMacros

    def reset_fake_sensu!
      RestClient.get("http://localhost:9292/reset")
    end

  end
end
