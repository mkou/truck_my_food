require 'grape'
require 'grape-swagger'

module API
  class FoodTrucks < Grape::API
    version 'v1' # path-based versioning by default
    format :json # We don't like xml anymore

    resources :food_trucks do
      desc "Search foodtrucks around coordinates, by types .."
      params do 
        requires :latitude
        requires :longitude
        optional :limit
        optional :food_types
      end

      get :search do 
        limit      = params[:limit] 
        latitude   = params[:latitude].to_f
        longitude  = params[:longitude].to_f
        food_types = Array(params[:food_types])
        food_truck_search = FoodTruck.indexed_search(latitude: latitude, longitude: longitude, limit: limit, food_types: food_types)
        food_truck_search.to_a.map(&:to_hsh)
      end
    end
  end
end