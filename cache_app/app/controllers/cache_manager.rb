# Wraps an instance of a cache and makes it a singleton

# TODO: Fix loadpath


require 'singleton'
require_relative '../../../lib/cache'

class CacheManager
  include Singleton
  
  def initialize
    # TODO: Make configurable
    @cache = UserCache.new(10)
  end
  
  def get user_name
    @cache.disp
    return @cache.get(user_name)
  end
  
  def post user_name, user_data
    @cache.post(user_name,user_data)
  end
  
  
  def ingest_array data
    puts data
    data.each do |u|
      post u["name"], u
    end
    @cache.disp
  end
  
end