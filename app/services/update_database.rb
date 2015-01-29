# Update the elasticsearch indexes information with the data fetched from the SFdataFetcher library
# This operation is scheduled once a day

class UpdateDatabase 

  def self.execute
    food_trucks_data = ::SfDataFetcher.instance.fetch
    delete_deprecated_food_trucks(food_trucks_data)
    food_trucks_data.each do |food_truck_data|
      puts 'create or update '+ food_truck_data['objectid']
      create_or_update_food_truck(food_truck_data)
    end
  end

  private
  def self.create_or_update_food_truck(food_truck_data)
    food_truck = FoodTruck.find_by_id(food_truck_data['objectid']) 
    new_item = !!!food_truck
    food_truck = FoodTruck.new if new_item
    food_truck.title = food_truck_data['applicant']
    food_truck.id = food_truck_data['objectid']
    food_truck.food_types = food_truck_data['fooditems'].gsub(': ', ':').split(':').map(&:downcase)
    food_truck.location = [food_truck_data['latitude'].to_f, food_truck_data['longitude'].to_f]
    food_truck.save
  end

  def self.delete_deprecated_food_trucks(food_trucks_data)
    new_food_truck_ids = food_trucks_data.map{ |food_truck_data| food_truck_data['objectid']}
    old_food_truck_ids = FoodTruck.all.map(&:id)
    to_delete_food_truck_ids = old_food_truck_ids - new_food_truck_ids
    to_delete_food_truck_ids.each do |to_delete_food_truck_id|
      puts 'removing '+ to_delete_food_truck_id
      FoodTruck.find(to_delete_food_truck_id).delete
    end
  end
end
