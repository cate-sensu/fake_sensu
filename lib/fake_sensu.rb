require "fake_sensu/version"
require "fake_sensu/api"
require "fake_sensu/macros"
require "fake_sensu/server"

module FakeSensu

  def self.version(*args)
    args.first || '0.9.12'
  end

  def self.start!
    FakeSensu::Server.new
  end

end
