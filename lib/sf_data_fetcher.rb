require 'uri'
require 'net/http'
require 'json'

class SfDataFetcher
  include Singleton

  def fetch
    url ='https://data.sfgov.org/resource/rqzj-sfat.json?'
    # We only need the foodtruck id, title, food_types and coordinates
    url += '$select=' + 'objectid,applicant,fooditems,latitude,longitude'
    # We want the Food Trucks that are approved
    url += '&$where=' + URI::encode("status='APPROVED' AND facilitytype='Truck'")
    response = Net::HTTP.get(URI(url))
    JSON.parse(response) 
  end
end