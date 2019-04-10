require 'set'

class Network
  attr_accessor :users
  
  def initialize 
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
  
  def are_connected?(user_name_1, user_name_2)
    return @users[user_name_1].is_connected?(user_name_2)
  end
  
  def process_queue in_q, out_q, result

    while not in_q.empty?
      
      cur = in_q.pop
      next unless not result.include? cur
      
      result.add cur
    
      cur_user = @users[cur]
      cur_user.connections.each do |con|
        out_q << con
      end
    end
  end
  
  def return_connections(name, n)
    q1 = Queue.new
    q2 = Queue.new
    n +=1
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





