module FakeSensu
  class Server

    def initialize(*args)
      inject_rspec_suite
    end

    def inject_rspec_suite
      Rspec.configure do |config|
        config.before :suite do
          puts "starting fake sensu api!"
          ru_path = File.expand_path "config.ru", __FILE__
          $fake_sensu_pid = Process.spawn("rackup --env production #{ru_path}", :out => "/dev/stdout")
          sleep 1
        end

        config.after :suite do
          puts "\nstopping fake sensu api @ #{$fake_sensu_pid}!"
          Process.kill 9, $fake_sensu_pid
        end
      end
    end

  end
end

