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
  # The Result set is updated when
  def process_queue in_q, out_q, result, n ,cnt, exclude

    while not in_q.empty?
      
      cur = in_q.pop
      #puts "Processing: #{cur} "
      next unless not result.include? cur
    
      # We may need to query the cahce to
      # to get information about a user
      import_user cur unless has_user cur
      
      # Add Name to result set
      puts "#{n} #{cnt}  #{cur}"
      
      if (n==cnt)
        # Found the level we are looking for, so add to results
        result.add cur unless exclude.include?(cur)
      else 
        # Adding connections that will need to be processed.
        #puts @users[cur].disp
        exclude.add cur
        cur_user = @users[cur]
        cur_user.connections.each do |con|
          out_q << con
        end
      end
    end
  end
  
  
  # Returns the members linked to a user of N-Deep into a social
  # network in the form of a Set 
  def return_connections(name, n, song_likes=[])

    n = n.to_i unless n.class == Integer
    
    # Queues that hold names of users to be processed.
    # Seeded with root user
    q1 = Queue.new
    q2 = Queue.new
    q1 << name
    
    # Maintains the final connection
    result = Set.new
    exclude = Set.new
    
    # Loops until we are N-Deep
    cnt = 0
    while n != cnt
      if (cnt%2==0)
        process_queue(q1,q2, result, n-1, cnt,exclude)
      else
        process_queue(q2,q1, result, n-1 ,cnt,exclude)
      end
      cnt+=1
    end
    
    return result
  end
end





