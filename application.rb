module API
end

require 'grape'
require 'elasticsearch/persistence/model'
require 'grape-swagger'
require 'pry'

Dir["#{File.dirname(__FILE__)}/app/models/*.rb"].each {|f| require f}
Dir["#{File.dirname(__FILE__)}/app/**/*.rb"].each {|f| require f}
Dir["#{File.dirname(__FILE__)}/app/**/**/*.rb"].each {|f| require f}
Dir["#{File.dirname(__FILE__)}/lib/*.rb"].each {|f| require f}

env = (ENV['RACK_ENV'] || :development)

#initialize Elasticsearch
es_host = ENV['BONSAI_URL'] || 'http://localhost:9200' 
Elasticsearch::Persistence.client = Elasticsearch::Client.new host: es_host, log: true

class API::Root < Grape::API
  format :json

  helpers do

    def validate_latitude_and_longitude
      unless valid_float?(params[:latitude]) && valid_float?(params[:longitude])  
        error!('latitude and longitude must be valid floats', 400) 
      end
    end

    def valid_float?(float)
      true if Float float rescue false
    end

  end

  mount API::FoodTrucks
  mount API::FoodTypes

  add_swagger_documentation mount_path: "/api",
                            api_version: 'v1',
                            base_path: '/v1'
  end

