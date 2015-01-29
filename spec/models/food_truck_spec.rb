require 'spec_helper'

describe FoodTruck do
  expected_data =  { id: '1234', title: 'blabla', food_types: ['yummy'], location: [12.323, 233.1323] }

  subject(:food_truck) { 
    FoodTruck.new(attributes) 
  }
  expected_data.keys.each do |field|
    context "when the FoodTruck has no #{field}" do
      let(:attributes){ expected_data.except(field)}
      it 'should not be valid' do
        expect(subject.valid?).to equal false
      end
    end
  end

  context 'when the FoodTruck has all fields' do 
    let(:attributes){ expected_data }
    it 'should be valid' do
      expect(subject.valid?).to equal true
    end
  end

  describe '#find_by_id' do
    let!(:foodtruck)  { FoodTruck.create(expected_data) }
    let!(:foodtruck2) { FoodTruck.create(expected_data.merge({ id: 'coucou' }) ) }
    context 'when we look for an existing id' do
      it 'should return the correct element' do 
        expect(FoodTruck.find_by_id('coucou').id).to eq(foodtruck2.id)
      end
    end
    context 'when we look for a non existing id' do
      it 'should return nul' do 
        expect(FoodTruck.find_by_id('yummy')).to equal nil
      end
    end
  end

  describe '#indexed_search' do 
    subject do 
      FoodTruck.indexed_search(opts)
    end

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
        title: 'FoodTruck3', 
        food_types: ['banana','strawberry'],
        location: [12.32987987, 233.139847]
      })

    }
    let!(:foodtruck3){
      FoodTruck.create({
        id: 'ft3', 
        title: 'FoodTruck3', 
        food_types: ['kiwi','lemon'],
        location: [12.32390, 233.1345]
      })
    }
    context 'when we search by location' do 
      let!(:opts) { { latitude: 12.32387, longitude: 233.1323} }
      it 'should render foodtrucks ordered by distance: the closest first' do
        expect(subject.to_a.map(&:id)).to eq(['ft1','ft3', 'ft2']);
      end
    end
    context 'when we search by one food type' do 
      let!(:opts) { { food_types: ['banana']} }
      it 'should render only the ones with the corect food types' do
        expect(subject.to_a.map(&:id)).to eq(['ft1', 'ft2']);
      end
    end
    context 'when we search by several food types' do 
      let(:opts) { { food_type: ['kiwi', 'strawberry']} }
      it 'should render only the ones with the corect food types' do
          expect(subject.to_a.map(&:id)).to eq(['ft2', 'ft3']);
      end
    end
  end
end