require 'eventmachine'

require './driver/connection'
require './lib/std/living'

HEARTBEAT_INTERVAL = 1

EM::run do 
  EM::start_server '0.0.0.0', 4000, MudServer

  EM::add_periodic_timer(HEARTBEAT_INTERVAL) do
    livings = Living.all
    EM.tick_loop do
      if livings.empty?
        :stop
      else
        livings.shift.heartbeat
      end
    end
  end
end
