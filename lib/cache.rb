#  In memory cache that maintains a limited number of recently used records for quick access.
#  Relies on a backing store to permentaly store data.

# TODO: Refactor out DB and provide connection at initialization

require 'pg'

class UserCache
  attr_accessor :limit
  
  DataRecord = Struct.new(:user_data, :tracking_index)
  
  def initialize(data_store, l=100)
    @limit = l
    @data = {}
    @tracking = []
    @db = data_store
  end
  
  # Attempts to pull data from cache, if not it will query the backingstore
  # Tracking is updated to reflect latest usage of record
  # Returns the users data in the form of a hash
  def get(u_name)
    if @data.has_key?(u_name)
      rec = @data[u_name]
      @tracking.insert(rec.tracking_index, @tracking.delete_at(rec.tracking_index))
      return rec.user_data
    else
      # QUERY DB
      puts ("Querying the database #{@data.has_key?(u_name)} #{@data}")
      
      rec = @db.query_for_all_user_data(u_name)
      post u_name, rec
      return rec
    end
    
  end
  
  def post(user_key, u_data)
    if @data.has_key?(user_key)
      # Record exists, so update
      @data[user_key].user_data = u_data
      @tracking.insert(@data[user_key].tracking_index, @tracking.delete_at(@data[user_key].tracking_index))
    else
      # New Data, so add to hash
      @data[user_key] = DataRecord.new(u_data, @tracking.size)
      @tracking.push(user_key)
    end
      
    # Manage the tracking array
    while (@data.size>@limit)
      puts "Cleaning..."
      disp
      @data.delete(@tracking[0])
      @tracking.shift(1)
    end
    disp
    #Update Back STore
    @db.insert_if_does_not_exist u_data
    
  end
  
  def next_to_pop
    return @tracking[0]
  end
  
  
  def disp
    puts "Data: "
    @data.each do |key, value|
      puts "#{key}: #{value}"
    end
    
    puts "Tracking: "
    @tracking.each_with_index do |rec ,i|
      puts "#{i}: #{rec}"
    end
  end
  
end
