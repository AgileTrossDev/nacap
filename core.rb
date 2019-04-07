require 'set'


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
  
  
  def process_queue in_q, out_q, result
    
    
    while not in_q.empty?
      
      cur = in_q.pop
      next unless not result.include? cur
      
      result.add cur
      puts "Processing: #{cur}"
      cur_user = @users[cur]
      cur_user.connections.each do |con|
        out_q << con
      end
    end
  end
  
  
  
  def return_connections(name, n)
    q1 = Queue.new
    q2 = Queue.new
    
    result = Set.new
    q1 << name
    cnt = 0
    while n != cnt
      
      if (cnt%2==0)
        process_queue(q1,q2, result)
      else
        process_queue(q2,q1, result)
      end
      
      cnt+=1
    
    end
    
    return result
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
  net.connect_users("Bob", "April")
  
  
  return net

end

def disp_s s
  s.each do |n|
    puts "NAME: #{n}"
  end
end

# MAIN
net = build_test_network
net.disp

con_set = net.return_connections("Scott", 2)
disp_s con_set


con_set = net.return_connections("Scott", 3)
disp_s con_set

con_set = net.return_connections("Scott", 4)
disp_s con_set

