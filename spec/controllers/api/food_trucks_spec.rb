describe API::FoodTrucks do
  describe "GET /v1/food_trucks/search" do
    context 'without giving the latitude and longitude' do
      it "Raise bad request error" do
        get "/v1/food_trucks/search"
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
              food_types: ['banana'],
              location: [12.32387, 233.1323]
            })
          }
        it "Renders what we wanted" do
          wait_for_elasticsearch
          get "/v1/food_trucks/search?latitude=12.32387&longitude=233.1323"
          expect(response_status).to eq 200
          expect(parsed_response).to eq  [{"id"=>"ft", "title"=>"FoodTruck1", "food_types"=>"banana", "latitude"=>12.32387, "longitude"=>233.1323}]
        end
      end
      context 'when given non valid floats' do 
        it "Raise bad request error" do
          get "/v1/food_trucks/search?latitude=banana&longitude=cornichon"
          expect(response_status).to eq 400
          expect(parsed_response['error']).to eq "latitude is invalid, longitude is invalid"
        end
      end
    end
    context 'when giving the limit' do 
      context 'when given a non integer' do 
        it "Raise bad request error" do
          get "/v1/food_trucks/search?latitude=12.32387&longitude=233.1323&limit=camembert"
          expect(response_status).to eq 400
          expect(parsed_response['error']).to eq "limit is invalid"
        end
      end
      context 'when given an integer' do 
        let!(:foodtruck){
          FoodTruck.create({
            id: 'ft', 
            title: 'FoodTruck1', 
            food_types: ['banana'],
            location: [12.32387, 233.1323]
          })
        }
       let!(:foodtruck2){
          FoodTruck.create({
            id: 'ft2', 
            title: 'FoodTruck2', 
            food_types: ['banana'],
            location: [12.32389, 233.1390]
          })
        }
        it "Renders what we wanted" do
          wait_for_elasticsearch
          get "/v1/food_trucks/search?latitude=12.32387&longitude=233.1323&limit=1"
          expect(response_status).to eq 200
          expect(parsed_response.count).to eq 1
        end
      end
    end
    context 'when giving food types' do 
      context 'when given a non array' do 
        it "Raise bad request error" do
          get "/v1/food_trucks/search?latitude=12.32387&longitude=233.1323&food_types=camembert"
          expect(response_status).to eq 400
          expect(parsed_response['error']).to eq "food_types is invalid"
        end
      end
      context 'when given a correct array' do 
        let!(:foodtruck){
          FoodTruck.create({
            id: 'ft', 
            title: 'FoodTruck1', 
            food_types: ['banana'],
            location: [12.32387, 233.1323]
          })
        }
       let!(:foodtruck2){
          FoodTruck.create({
            id: 'ft2', 
            title: 'FoodTruck2', 
            food_types: ['yogourt'],
            location: [12.32389, 233.1390]
          })
        }
        it "Renders what we wanted" do
          wait_for_elasticsearch
          get "/v1/food_trucks/search?latitude=12.32387&longitude=233.1323&food_types%5B%5D=banana"
          expect(response_status).to eq 200
          expect(parsed_response).to eq [{"id"=>"ft", "title"=>"FoodTruck1", "food_types"=>"banana", "latitude"=>12.32387, "longitude"=>233.1323}]
        end
      end
    end
  end
end