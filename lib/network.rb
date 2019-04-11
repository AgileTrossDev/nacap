require 'set'
require_relative 'user'

class Network
  attr_accessor :users
  
  def initialize (query_tool= nil)
    @users = {}
    @store = query_tool
  end
  
  def import_user user_name
    return if has_user(user_name)
    puts "Importing User"
    user = @store.query_user(user_name)
    add_user(user)
  end
  
  def has_user(user_name)
    return  @users.has_key?(user_name)
  end
  
  
  def add_user(user)
    puts "ADDING USER: #{user}"
    user = User.build_user_from_hash(user) unless user.class != Hash
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
  
  
  # Processes a Queue of names and puts the connections
  # that still need to be processed on out queue.
  # The Result set is updated
  def process_queue in_q, out_q, result

    while not in_q.empty?
      
      cur = in_q.pop
      puts "Processing: #{cur} "
      next unless not result.include? cur
    
      # We may need to query the cahce to
      # to get information about a user
      import_user cur unless has_user cur
      
      # Add Name to result set
      result.add cur
      
      # Now add connections that will need to be processed.
      puts @users[cur].disp
      cur_user = @users[cur]
      cur_user.connections.each do |con|
        out_q << con
      end
    end
  end
  
  
  # Returns the social network in the form of a set for a person that is N-Deep
  def return_connections(name, n, song_likes=[])
    
    
    # increment to account for root user
    n = n.to_i unless n.class == Integer
    n +=1
    
    # Queues that hold names of users to be processed.
    # Seeded with root user
    q1 = Queue.new
    q2 = Queue.new
    q1 << name
    
    # Maintains the final connection
    result = Set.new
    
    # Loops until we are N-Deep
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





