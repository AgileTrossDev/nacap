require 'test/unit'
require 'cache'
require 'User'
require 'db_mgr'

class TestCache < Test::Unit::TestCase
  
  def test_cache_nominal_push_get
    cache = UserCache.new(DbMgr.new('nacap_demo','alberta'), 5)
    for u in ["Scott","Bob","Sam","April","Sagan"]
      tmp = User.new(u)
      cache.post(tmp.name, tmp.to_hash)
    end
    
    for u in ["Scott","Bob","Sam","April","Sagan"]
      assert cache.get(u)
    end
    
  end
  
  def test_cache_over_flow
    cache = UserCache.new(DbMgr.new('nacap_demo','alberta'),5)
    
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

  def test_cache_keep_most_recent
    cache = UserCache.new(DbMgr.new('nacap_demo','alberta'),5)
    
    puts "\nLOADING CACHE....\n"
    # Load more records than cache can ohold
    for u in ["Fred","Scott","Bob","Sam","April","Sagan"]
      tmp = User.new(u)
      cache.post(tmp.name, tmp.to_hash)
      
      if (tmp.name != "Sagan")
        assert_equal("Fred", cache.next_to_pop, "Expected key to pop is wrong")
        #assert "Fred" == cache.next_to_pop
      else
        assert "Scott" == cache.next_to_pop
      end
    end
    

    puts "\nGetting all elements from cache...\n"
    for u in ["Scott","Bob","Sam","April","Sagan"]
      assert cache.get(u)
    end


    puts "\nHERE\n"
    # At this point the oldest element in the cache is 'scott'
    # Lets get it, and then show `Bob` is the next to pop
    assert "Scott" == cache.next_to_pop
    assert cache.get("Scott")
    assert "Bob" == cache.next_to_pop





    
    # TODO: Will need to correct when backing store is in place
    assert_raise do
      cache.get("Fred")
      cache.get("Joe")
    end
    
  end





  
  ### Helpers ###
  def build_test_cache
    cache = UserCache.new(DbMgr.new('nacap_demo','alberta'),5)
    for u in ["Scott","Bob","Sam","April","Sagan"]
      tmp = User.new(u)
      cache.post(tmp.name, tmp.to_hash)
    end
    
    return cache
  end
end