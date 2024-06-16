#  In memory cache that maintains a limited number of recently used records for quick access.
#  Relies on a backing store to permentaly store data.  
# 
# Implements an LRU Alrogirthm
#


require 'pg'  # TODO: Refactor out DB and provide connection at initialization

# CLass representing a Node in a Linked List that contains a hash key to a record of data in the Cache
#
# NOTE: This list is managed in a way so that it is orderd in the freqency the records are referenced
class CacheRecord

  attr_accessor :next_record, :prev_record, :key

  def initialize(key_value, prev_node =nil , next_node= nil)
    @key = key_value
    @next_record = next_node
    @prev_record = prev_node
  end

end

class UserCache
  attr_accessor :limit
  
  DataRecord = Struct.new(:user_data, :tracking_record)
  
  def initialize(data_store, l = 100)
    @limit = l            # The Maximum number of recrods to track in the cache

    # Hash containing user data, where the key is the user name
    #
    # NOTE: Each record in the cache will have a reference to the record in the
    # link list tracking it's frequency of references relative to the other records
    @data = {}            

    @db = data_store      # Backing Database

    # Using a Linked List of CacheRecords to track the least used records.
    #
    # NOTE: The Link List will we be ordered by refernce frequency.  This 
    # cache only cares about tracking the most recent referenced record,
    # and the oldest record, which is at risk of being dropped if the 
    # cache has reach it's limit 
    @oldest_record = nil
    @newest_record = nil
    @record_cnt = 0
  end

  def update_tracking_list_recently_referenced_record tracking_record

    if tracking_record == @newest_record
      # No Action if record is already tracked as the newest, just return
      return nil
    elsif tracking_record == @oldest_record and @oldest_record != @newest_record
        # Promote second oldest record, to oldest
        puts tracking_record.key
        @oldest_record = @oldest_record.prev_record 
        @oldest_record.next_record = nil        
    else
      # Record is in the middle, so remove it from the list by connecting
      # the bordering records together
      tracking_record.prev_record.next_record = tracking_record.next_record
      tracking_record.next_record.prev_record = tracking_record.prev_record
    end

    # Now append the recently referenced record to the newest record position in the linked list
    tracking_record.next_record = @newest_record     
    tracking_record.prev_record = nil
    @newest_record.prev_record = tracking_record 
    @newest_record = tracking_record      
  end


  # Drops oldest records if they break the cache limit. Nominally there should only be 1 record breaking the limit
  def update_list_with_a_trim

    while @record_cnt > limit
      puts "Cache is droping key: #{@oldest_record.key}"
      @data.delete(@oldest_record.key)
      @oldest_record = @oldest_record.prev_record 
      @oldest_record.next_record = nil
      @record_cnt -= 1    
    end

  end

  def  update_track_list_with_new_record tracking_record

    if @newest_record.nil?
      # Cache is currently empty, so it is not linked to anything and is now also the oldest record
      tracking_record.next_record = nil
      tracking_record.prev_record = nil    
      @oldest_record =  tracking_record
    else
      # Incoming record replaces current newest record and are linked in the process 
      tracking_record.next_record = @newest_record
      tracking_record.prev_record = nil
      @newest_record.prev_record = tracking_record
    end

    @record_cnt += 1
    @newest_record = tracking_record

    update_list_with_a_trim
    

  end
  
  # Attempts to pull data from cache, if not it will query the backingstore
  # Tracking is updated to reflect latest usage of record
  # Returns the users data in the form of a hash
  def get(u_name)

    if @data.has_key?(u_name)
      rec = @data[u_name]
      update_tracking_list_recently_referenced_record rec.tracking_record
      return rec.user_data
    else
      # Check DB for Record
      puts ("Querying the database #{@data.has_key?(u_name)} #{@data}")      
      rec = @db.query_for_all_user_data(u_name)
      post u_name, rec
      return rec
    end
    
    return nil
  end
  
  def post(user_key, u_data)
    
    if @data.has_key?(user_key)
      # Record exists, so update existing information
      @data[user_key].user_data = u_data
      update_tracking_list_newly_referenced_record @data[user_key]      
    else
      # New Data, so add it       
      @data[user_key] = DataRecord.new(u_data, CacheRecord.new(user_key))
      update_track_list_with_new_record @data[user_key].tracking_record      
    end
    
    disp

    # Update Back store
    # TODO: Make async
    @db.insert_if_does_not_exist u_data
    
  end
  
  def next_to_pop
    return @oldest_record.key
  end
  
  
  def disp
    puts "Tracking... "
    cur = @newest_record
    while not cur.nil?
      puts " - #{cur.key}"
      cur = cur.next_record
    end

    #puts "Data....\n#{@data}"
   
  end
  
end
