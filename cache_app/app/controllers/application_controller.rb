# Sinatra Application hosting the cache

require 'sinatra'
configure { set :server, :puma }


require_relative 'cache_manager'

class ApplicationController < Sinatra::Base
  # code for the controller here...
  get '/' do
    'Cache App is up and running'
  end
  
  get '/cache/:name' do
  
  
  end


  post '/cache' do
  
  
  end 
  
  
end