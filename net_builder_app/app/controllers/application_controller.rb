# Sinatra Application hosting the network building algorithm

require 'sinatra'
require 'json'

configure { set :server, :puma }

require_relative 'net_builder'

class ApplicationController < Sinatra::Base
  # code for the controller here...
  get '/' do
    'Network Builder App is up and running'
  end
  
  get '/net/:name/:depth' do
    puts "GET NET #{params[:name]}, #{params[:depth]}"
    #user =  CacheManager.instance.get(params[:name])
    
    user = {"scott" => "Bob"}
    content_type :json
    return 200, user.to_json
  end


 
end