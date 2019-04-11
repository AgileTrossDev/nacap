require 'set'

class User
  attr_accessor :name, :connections, :songs
 
  def self.build_user_from_hash(h)
   
    u = User.new(h["name"])
    
    if h.has_key?("connections")
      puts "Connections: #{h["connections"]}"
      h["connections"].each do |c|
        u.connections.push(c)
      end
    end
    
    if h.has_key?("songs")
      puts "Connections: #{h["songs"]}"
      h["songs"].each do |s|
        u.songs.push(s)
      end
    end 
    return u
  
  end


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
  

