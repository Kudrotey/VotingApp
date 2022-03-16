require 'sinatra/base'
require 'sinatra/reloader'
require 'erb'
require 'yaml/store'

class VotingApp < Sinatra::Base 
    configure :development do
        register Sinatra::Reloader
    end

    Choices = {
        'PIZ' => 'Pizza',
        'CUR' => 'Curry',
        'NOO' => 'Noodles',
        'BUR' => 'Burger',
    }

    get '/' do
        @title = "Welcome to the Food Voting App!"
        erb :index
    end

    post '/cast' do
        @title = "Thanks for casting your vote!"
        @vote = params['vote']
        @store = YAML::Store.new 'votes.yml'
        @store.transaction do
            @store['votes'] ||= {}
            @store['votes'][@vote] ||= 0
            @store['votes'][@vote] += 1
        end
        erb :cast
    end

    get '/results' do
        @title = "Results so far:"
        @store = YAML::Store.new 'votes.yml'
        @votes = @store.transaction { @store['votes'] }
        erb :results
    end
    
end