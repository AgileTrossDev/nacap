require 'thor'
require 'json'
require 'rest_client'


 class CLI < Thor
  desc "Welcome", "Greetings"
  def hello
    puts "Hello there partner.  Use these tools to interact with system"
  end
  
  
  desc "RESTful POST", "Reads a JSON file in and POSTs it to the URL"
  def post url,path
    puts "Posting file #{path} to #{url}"
    data = JSON.parse(File.read(path))
    response = RestClient.post url, data, {:content_type => :json, :accept => :json}
    puts "POST Response: #{response}"
  end
  
  desc "RESTful GET", "Makes a GET to the URL"
  def get url
    response = RestClient.get url
    puts "POST Response: #{response}"
  end
  
 end


CLI.start(ARGV)