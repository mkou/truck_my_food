module API
end

require 'grape'
require 'elasticsearch/persistence/model'
require 'grape-swagger'

Dir["#{File.dirname(__FILE__)}/app/models/*.rb"].each {|f| require f}
Dir["#{File.dirname(__FILE__)}/app/**/*.rb"].each {|f| require f}
Dir["#{File.dirname(__FILE__)}/app/**/**/*.rb"].each {|f| require f}
Dir["#{File.dirname(__FILE__)}/lib/*.rb"].each {|f| require f}

env = (ENV['RACK_ENV'] || :development)

class API::Root < Grape::API
  format :json

  mount FoodTrucks::API

  add_swagger_documentation mount_path: '/api/docs',
                            api_version: 'v1',
                            hide_documentation_path: true
end

