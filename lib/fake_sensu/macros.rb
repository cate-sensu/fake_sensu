module FakeSensu
  module FakeSensuMacros

    def reset_fake_sensu!
      RestClient.get("http://localhost:4567/reset")
    end

  end
end
