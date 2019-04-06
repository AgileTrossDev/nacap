class User
  attr_accessor :name, :connections, :songs

  def initialize(name)
    @name = name
    @connections = []
    @songs = []
  end
  
  def disp
    puts "USER: #{@name} | SONGS: #{@song} | Connections: #{@connections}" 
  end
end
  

class Network
  attr_accessor :users
  
  def initialize ()
    @users = {}
  end
  
  def add_user(user)
    user = User.new(user) unless  user.class != String
    @users[user.name] = user
  end
  
  def connect_users(user1, user2)
    add_user(user1) unless @users.key?(user1)
    add_user(user2) unless @users.key?(user2) 
    
    @users[user1].connections.push(user2)
    @users[user2].connections.push(user1)
    
    puts " #{@users[user1].connections.size} #{@users[user1].connections.class}"

  end
  
  def add_user_like(name,song)
    add_user(user) unless @users.key?(user.name)
    @users[user].songs.insert(song)   
  end
  
  def disp 
     @users.each do |name, user| 
      user.disp
    end
  end
  
  
  
end



 
def build_test_network
  
   a = User.new("Scott")
   b = User.new("Bob")
   c = User.new ("Sam")
   d = User.new ("April")
   e = User.new ("Sagan")
  
  net = Network.new
  
  net.add_user(a)
  net.add_user(b)
  net.add_user(c)
  net.add_user(d)
  net.add_user(e)
  
  net.connect_users("Scott","April")
  net.connect_users("Scott", "Sagan")
  net.connect_users("Sagan", "April")
  net.connect_users("Bob", "Sam")
  
  
  return net

end


net = build_test_network
net.disp


