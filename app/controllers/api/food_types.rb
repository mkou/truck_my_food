require 'grape'
require 'grape-swagger'

module API
  class FoodTypes < Grape::API
    version 'v1' # path-based versioning by default
    format :json # We don't like xml anymore

    resources :food_types do  
      desc "Render the food types facets (food type and number of items)"
      get  do 
        food_truck_search = FoodTruck.indexed_search({})
        food_truck_search.response.aggregations.food_type.buckets
      end

      desc "Get food types around coordinates"
      params do 
        requires :latitude
        requires :longitude
      end
      get :around_location do 
        latitude   = params[:latitude].to_f
        longitude  = params[:longitude].to_f
        food_truck_search = FoodTruck.indexed_search(latitude: latitude, longitude: longitude, limit: 5)
        food_truck_search.to_a.map(&:food_types).flatten.uniq.map { |food_type| { key: food_type } } 
      end
    end
  end
end