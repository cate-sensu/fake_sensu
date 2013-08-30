require "fake_sensu/version"
require "fake_sensu/macros"
require "fake_sensu/server"

module FakeSensu

  def self.start!(*args)
    version = args.first || "0.10.2"
    FakeSensu::Server.new(version)
  end

end

