require './driver/connection_state'
require './driver/std/player'

class MudServer < EM::Connection

  include EM::Protocols::LineText2

  @@connections = []

  attr_accessor :player
  attr_accessor :conn_state

  def self.connections
    @@connections
  end

  def self.broadcast(msg, except = nil)
    @@connections.each do |con|
      con.send_message("#{msg}") if con.logged_in? and con != except
    end
  end

  def send_message(msg)
    send_data "#{msg}\r\n"
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
      when ConnectionState::NEW_CHAR_PASSWORD then send_data "Select a password (>= 6 characters): "
      when ConnectionState::CONFIRM_PASSWORD then send_data "Confirm your password: "
      when ConnectionState::PLAYING then send_data "> "
    end
  end

  def receive_line data
    close_connection if data =~ /quit/i

    data.strip!

    case @conn_state
      when ConnectionState::CONNECTED then
        if Player.pfile_exists?(data.downcase)
          @player = Player.load(data)
          @conn_state = ConnectionState::ENTER_PASSWORD
        else
          send_data "That player does not exist.  Creating a new character.\r\n"
          @player = Player.new(data)
          @conn_state = ConnectionState::NEW_CHAR_PASSWORD
        end
      when ConnectionState::ENTER_PASSWORD then
        if @player and @player.check_password?(data)
          @conn_state = ConnectionState::PLAYING
          puts "-- #{@player.name} entered the game."
        else
          send_data "Invalid password.\r\n"
          @player = nil
          @conn_state = ConnectionState::CONNECTED
        end
      when ConnectionState::NEW_CHAR_PASSWORD
        if data.length >= 6
          @player.password = data
          @conn_state = ConnectionState::CONFIRM_PASSWORD
        else
          send_data "Invalid password.\r\n"
          @player = nil
          @conn_state = ConnectionState::CONNECTED
        end
      when ConnectionState::CONFIRM_PASSWORD then
        if @player.check_password?(data)
          @player.save
          puts "-- #{@player.name} entered the game."
          @conn_state = ConnectionState::PLAYING
        else
          send_data "Bad confirmation.  Starting over.\r\n"
          @player = nil
          @conn_state = ConnectionState::CONNECTED
        end
      when ConnectionState::PLAYING then
        MudServer.broadcast "#{@player.name}: #{data}"
    end

    send_prompt
  end

  def unbind
    puts "-- #{@player.name} logged out." if @player
    @@connections.delete(self)
  end
end
