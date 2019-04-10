require 'test/unit'
require 'cache'
require 'User'

class TestCache < Test::Unit::TestCase
  
  def test_cache_nominal_push_get
    cache = UserCache.new(5)
    for u in ["Scott","Bob","Sam","April","Sagan"]
      tmp = User.new(u)
      cache.post(tmp.name, tmp.to_hash)
    end
    
    for u in ["Scott","Bob","Sam","April","Sagan"]
      assert cache.get(u)
    end
    
  end
  
  def test_cache_over_flow
    cache = UserCache.new(5)
    
    for u in ["Fred","Scott","Bob","Sam","April","Sagan"]
      tmp = User.new(u)
      cache.post(tmp.name, tmp.to_hash)
      
      if (tmp.name != "Sagan")
        assert "Fred" == cache.next_to_pop
      else
        assert "Scott" == cache.next_to_pop
      end
    end
    
    for u in ["Scott","Bob","Sam","April","Sagan"]
      assert cache.get(u)
    end
    
    # TODO: Will need to correct when backing store is in place
    assert_raise do
      cache.get("Fred")
      cache.get("Joe")
    end
    
  end
  
  ### Helpers ###
  def build_test_cache
    cache = UserCache.new(5)
    for u in ["Scott","Bob","Sam","April","Sagan"]
      tmp = User.new(u)
      cache.post(tmp.name, tmp.to_hash)
    end
    
    return cache
  end
end