# Performs query to the Cache/backing store  

require 'json'
require 'rest_client'


class QueryTool

  
  def initialize
   
  end
  
  def query_user user_name
    response = RestClient.get "http://localhost:9000/cache/#{user_name}"
    puts "POST Response: #{response}"
    return JSON.parse(response)
  end
  
  
  
end