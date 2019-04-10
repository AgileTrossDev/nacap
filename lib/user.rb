require 'set'

class User
  attr_accessor :name, :connections, :songs

  def initialize(name)
    @name = name
    @connections = []
    @songs = []
  end
  
  def add_connection(con_name)
    @connections.push(con_name) 
  end
  
  
  def add_song(song_name)
    @songs.push(song_name)
  end
  
  
  def is_connected?(user_name)
    return @connections.include?(user_name)
  end
  
  
  def to_hash
    return {"name" => @name, "connections" => @connections, "songs" => @songs }
  end

  def disp
    puts "USER: #{@name} | SONGS: #{@song} | Connections: #{@connections}" 
  end
end
  

