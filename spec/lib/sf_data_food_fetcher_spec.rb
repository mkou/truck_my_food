describe SfDataFetcher do
  let(:data) {
    [
      {"applicant"=>"Cupkates Bakery, LLC", "fooditems"=>"Cupcakes", "longitude"=>"-122.398658184604", "latitude"=>"37.7901490737255", "objectid"=>"546631"},
      {"applicant"=>"Cheese Gone Wild", "fooditems"=>"Grilled Cheese Sandwiches", "longitude"=>"-122.395881039335", "latitude"=>"37.7891192076677", "objectid"=>"526147"}
     ].to_json
  }

  before do
    Net::HTTP.stub(:get) { data }
  end
  describe '#fetch' do 
    it 'should call the SF Data url with the correct query' do 
      expect(Net::HTTP).to receive(:get).with(URI("https://data.sfgov.org/resource/rqzj-sfat.json?$select=objectid,applicant,fooditems,latitude,longitude&$where=status='APPROVED'%20AND%20facilitytype='Truck'"))
      SfDataFetcher.instance.fetch()
    end
    it 'should render the results parsed JSOn data from SFdata' do
      SfDataFetcher.instance.fetch().should == JSON.parse(data)
    end
  end
end