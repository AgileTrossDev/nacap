# Builds up the user's network

require 'json'
# TODO: Fix loadpath
require_relative '../../../lib/network'
require_relative 'query_tool'
class NetBuilder

  
  def initialize
   
  end
  
  def build user_name, depth
    net = Network.new(QueryTool.new)
    con_set = net.return_connections(user_name, depth.to_i)
    puts "Network Size: #{con_set.size}"
    return format_connection_set(con_set)
  end
  
  
  def format_connection_set con_set
    puts con_set
    results = []
    con_set.each do |u|
      # Display the element.
      results.push u
    end
    return {"network" => results}.to_json
  end
  
  
  
end