describe UpdateStore do
  describe 'exectute' do 
    # Creating existing database
    let!(:foodtruck1){
      FoodTruck.create({
        id: 'ft1', 
        title: 'FoodTruck1', 
        food_types: ['banana'],
        location: [12.32387, 233.1323]
      })
    }
    let!(:foodtruck2){
      FoodTruck.create({
        id: 'ft2', 
        title: 'FoodTruck2', 
        food_types: ['banana','strawberry'],
        location: [-122.398658184604, 37.7891192076677]
      })
    }
    #Set fetched data
    let!(:fetched_data) {
      [
        {
          "applicant"=>'FoodTruck2', 
          "fooditems"=>"Cupcakes", 
          "longitude"=>"-122.398658184604", 
          "latitude"=>"37.7901490737255", 
          "objectid"=>"ft2"
        },
        {
          "applicant"=>"FoodTruck3", 
          "fooditems"=>"Grilled Cheese Sandwiches", 
          "longitude"=>"-122.395881039335", 
          "latitude"=>"37.7891192076677", 
          "objectid"=>"ft3"
        }
      ]
    }

    before do 
      # stubbing parameters fetched from SFDATA Library
      instance = SfDataFetcher.instance
      instance.stub(:fetch) { fetched_data }
      SfDataFetcher.stub(:instance) { instance }
      wait_for_elasicsearch
      UpdateStore.execute
      wait_for_elasicsearch
    end

    it 'should remove the truck that is not sent anymore' do 
      expect(FoodTruck.search({}).to_a.map(&:id)).not_to include 'ft1'
    end

    it 'should add the new food truck' do
      expect(FoodTruck.search({}).to_a.map(&:id)).to include 'ft3'
    end

    it 'should update the modified food truck' do 
      modified_food_truck = FoodTruck.find('ft2')
      expect(modified_food_truck.food_types).to eq(["cupcakes"])
    end
  end
end