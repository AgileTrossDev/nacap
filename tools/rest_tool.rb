require 'thor'
require 'rest_client'


 class CLI < Thor
  desc "Welcome", "Greetings"
  def hello
    puts "Hello there partner.  Use these tools to interact with system"
  end
 end


CLI.start(ARGV)