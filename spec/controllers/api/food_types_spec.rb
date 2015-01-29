describe API::FoodTrucks do
  describe "GET /v1/food_types" do
    let!(:foodtruck){
      FoodTruck.create({
        id: 'ft', 
        title: 'FoodTruck1', 
        food_types: ['burger', 'hot-dog'],
        location: [12.32387, 233.1323]
      })
    }

    it "Renders all the food types" do
      wait_for_elasticsearch
      get "/v1/food_types"
      expect(response_status).to eq 200
      expect(parsed_response).to eq [{"key"=>"burger", "doc_count"=>1}, {"key"=>"hot-dog", "doc_count"=>1}]
    end
  end
  describe "GET /v1/food_types/around_location" do
    context 'without giving the latitude and longitude' do
      it "Raise bad request error" do
        get "/v1/food_types/around_location"
        expect(response_status).to eq 400
        expect(parsed_response['error']).to eq 'latitude is missing, longitude is missing'
      end
    end
    context 'when giving the latitude and longitude' do
      context 'when given valid floats' do
          let!(:foodtruck){
            FoodTruck.create({
              id: 'ft', 
              title: 'FoodTruck1', 
              food_types: ['banana', 'ninja'],
              location: [12.32387, 233.1323]
            })
          }
        it "Renders what we wanted" do
          wait_for_elasticsearch
          get "/v1/food_types/around_location?latitude=12.32387&longitude=233.1323"
          expect(response_status).to eq 200
          expect(parsed_response).to eq  [{"key"=>"banana"}, {"key"=>"ninja"}]
        end
      end
      context 'when given non valid floats' do 
        it "Raise bad request error" do
          get "/v1/food_types/around_location?latitude=banana&longitude=cornichon"
          expect(response_status).to eq 400
          expect(parsed_response['error']).to eq 'latitude and longitude must be valid floats'
        end
      end
    end
  end
end