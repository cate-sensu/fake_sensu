module FakeSensu
  class Server

    def initialize(*args)
      inject_rspec_suite
      start_api
    end

    def inject_rspec_suite
      RSpec.configure do |config|
        config.after :suite do
          puts "\nstopping fake sensu api @ #{$fake_sensu_pid}!"
          Process.kill 9, $fake_sensu_pid
        end

      end
    end

    def start_api
      puts "starting fake sensu api!"
      ru_path = File.join(File.dirname(__FILE__), "config.ru")
      $fake_sensu_pid = Process.spawn("rackup --env production #{ru_path}", :out => "/dev/stdout")
      sleep 4
    end

  end
end

