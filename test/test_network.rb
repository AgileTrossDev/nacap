

 ### TEST ####
def build_test_network
  
 

  return net

end


def build_test_cache
  cache = UserCache.new(5)
  for u in ["Scott","Bob","Sam","April","Sagan"]
    tmp = User.new(u)
    cache.post(tmp.name, tmp.to_hash)
  end
  
  return cache
end


require 'test/unit'
require 'network'
require 'user'


class TestNetwork < Test::Unit::TestCase
  
  def test_creation
    net = Network.new
  
    for u in ["Scott","Bob","Sam","April","Sagan"]
      # CONSIDER: Mocking User
      tmp = User.new(u)
      net.add_user(tmp)
    end
    
    net.connect_users("Scott","April")
    net.connect_users("Scott", "Sagan")
    net.connect_users("Sagan", "April")
    net.connect_users("Bob", "Sam")
    net.connect_users("Bob", "April")
    
    assert net.are_connected?("Scott","April")
    assert false == net.are_connected?("Scott","Bob")
    
  end
  
  
  def test_connection_sets
    net = build_test_network
    
    # Request connections 2-layer deeps from Scott
    con_set = net.return_connections("Scott", 2)

    assert con_set.include? "Scott"
    assert con_set.include? "April"
    assert con_set.include? "Sagan"
    assert con_set.include? "Bob"
    assert false ==  con_set.include?("Fred")
    assert false ==  con_set.include?("Sam")
    
  end
  
  ### Helpers ###
  def build_test_network
    net = Network.new
  
    for u in ["Scott","Bob","Sam","April","Sagan"]
      # CONSIDER: Mocking User
      tmp = User.new(u)
      net.add_user(tmp)
    end
    
    net.connect_users("Scott","April")
    net.connect_users("Scott", "Sagan")
    net.connect_users("Sagan", "April")
    net.connect_users("Bob", "Sam")
    net.connect_users("Bob", "April")
    net.connect_users("Bob", "Fred")
    
    return net
    
  end
  
  def disp_s s
    s.each do |n|
      puts "NAME: #{n}"
    end
  end
  
  
end







### MAIN ####

#con_set = net.return_connections("Scott", 2)
#disp_s con_set
#
#
#con_set = net.return_connections("Scott", 3)
#disp_s con_set
#
#con_set = net.return_connections("Scott", 4)
#disp_s con_set

