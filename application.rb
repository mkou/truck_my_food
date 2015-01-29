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

  mount API::FoodTrucks
  mount API::FoodTypes

  add_swagger_documentation base_path: "/api",
                            api_version: 'v1',
                            hide_documentation_path: true
end

