# Wraps an instance of a cache and makes it a singleton

# TODO: Fix loadpath
  
require 'singleton'
require_relative '../../../lib/cache'
require_relative '../../../lib/db_mgr'

class CacheManager
  include Singleton
  
  def initialize
    # TODO: Make configurable/Pull from environment
    db = DbMgr.new('nacap_demo','alberta')
    @cache = UserCache.new(db,10)
  end
  
  def get user_name
    @cache.disp
    return @cache.get(user_name)
  end
  
  def post user_name, user_data
    @cache.post(user_name,user_data)
  end
  
  def ingest_array data
    data.each do |u|
      post u["name"], u
    end
  end
  
end