# Sinatra Application hosting the cache

require 'sinatra'
require 'json'

configure { set :server, :puma }

require_relative 'cache_manager'

class ApplicationController < Sinatra::Base
  # code for the controller here...
  get '/' do
    'Cache App is up and running'
  end
  
  get '/cache/:name' do
    user =  CacheManager.instance.get(params[:name])
    content_type :json
    return 200, user.to_json
  end


  post '/cache' do
    users = params[:data]
    CacheManager.instance.ingest_array(users)
  end   
end