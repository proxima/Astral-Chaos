require 'rubygems'
require 'eventmachine'
require 'connection_state'

class MudServer < EM::Connection

  include EM::Protocols::LineText2

  attr_accessor :player
  attr_accessor :conn_state
  attr_accessor :username

  @@connections = []

  def self.broadcast(msg, except = nil)
    @@connections.each do |con| 
      con.send_message("#{msg}") if con.logged_in? and con != except
    end
  end

  def send_message(msg)
    send_data "#{msg}\r\n"
    send_prompt
  end

  def post_init
    puts "-- Connection established."
    @conn_state = ConnectionState::CONNECTED
    @@connections << self
    send_prompt
  end

  def logged_in?
    return (@conn_state == ConnectionState::PLAYING)
  end

  def send_prompt
    case @conn_state
      when ConnectionState::CONNECTED then send_data "Please enter your username: "
      when ConnectionState::ENTER_PASSWORD then send_data "Enter your password: "
      when ConnectionState::CONFIRM_PASSWORD then send_data "Confirm your password: "
      when ConnectionState::PLAYING then send_data "> "
    end
  end

  def receive_line data
    close_connection if data =~ /quit/i

    data.strip!

    case @conn_state
      when ConnectionState::CONNECTED then
        filename = "./data/players/#{data.downcase}.dat"
        if File.exists?(filename)
          @username = data.capitalize
          @conn_state = ConnectionState::ENTER_PASSWORD
        else
          send_data "That player does not exist.\r\n"
        end
    end

    send_prompt
  end

  def unbind
    puts "-- #{@username} logged out."
    @@connections.delete(self) 
  end

end

EM::run do 
  EM::start_server '0.0.0.0', 4000, MudServer
end
