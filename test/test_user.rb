require 'test/unit'
require 'user'

class TestUser < Test::Unit::TestCase
  
  def test_creation
    a = User.new("Scott")
    a.add_connection("Sagan")
    a.add_song("Free Ride")
    
    h = a.to_hash
    
    assert h["name"] = "Scott"
    assert h["connections"].include? "Sagan"
    assert h["songs"].include? "Free Ride"
    
    assert a.is_connected?("Sagan")
    assert false == a.is_connected?("Bob")
  end
  
end