require 'eventmachine'

require './driver/connection'
require './driver/std/base'

HEARTBEAT_INTERVAL = 1

EM::run do 
  EM::start_server '0.0.0.0', 4000, MudServer

  EM::error_handler{ |e|
    puts "Error in event loop: #{e.message} #{e.inspect}"
    e.backtrace.each { |frame| puts "#{frame}" }
  }

  EM::add_periodic_timer(2) do
    MudServer.broadcast("Teehee\r\n");
  end

  EM::add_periodic_timer(HEARTBEAT_INTERVAL) do
    livings = Mud::Object.values.select { |ob| ob.respond_to? :heartbeat }

    EM.tick_loop do
      if livings.empty?
        :stop
      else
        livings.shift.heartbeat
      end
    end
  end
end
