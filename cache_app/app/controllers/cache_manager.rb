# Wraps an instance of a cache and makes it a singleton

# TODO: Fix loadpath


require 'singleton'
require_relative '../../../lib/cache'

class CacheManager
  include Singleton
  
  def initialize
    # TODO: Make configurable
    @cache = UserCache.new(5)
  end
  
  def get user_name
    return @cache.get(user_name)
  end
  
  def post user_name, user_data
    @cache.post(user_name,user_data)
  end
  
end