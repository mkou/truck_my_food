module API
  class FoodTrucks < Grape::API
    version 'v1' # path-based versioning by default
    format :json # We don't like xml anymore

    helpers do

      def validate_latitude_and_longitude
        error!('latitude and longitude must be valid floats', 400) unless params[:latitude].valid_float? && params[:longitude].valid_float?
      end

      def valid_float?
        true if Float self rescue false
      end

    end

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