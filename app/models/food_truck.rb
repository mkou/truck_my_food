class FoodTruck
  include Elasticsearch::Persistence::Model
  # Avoiding killing database
  index_name [ENV['RACK_ENV'], 'food_trucks'].compact.join('_')

  attribute :title,  String
  attribute :id, String
  attribute :food_types, String, default: [], mapping: { analyzer: 'keyword'}
  attribute :location, String, mapping: { type: 'geo_point', geohash_precision: 4}


  # Validate the presence of the `title and location` attribute
  validates :title, presence: true
  validates :location, presence: true 
  validates :id, presence: true
  validates :food_types, presence: true

  # Silently fail find by id
  def self.find_by_id(id)
    begin
      self.find(id)
    rescue Elasticsearch::Persistence::Repository::DocumentNotFound
      nil
    end
  end

  def self.indexed_search(options)
    geo_center = [options[:latitude], options[:longitude]] if options[:latitude] && options[:longitude]
    per_page = options[:limit] || 10
    food_types = options[:food_types]

    search = {};

    if geo_center.present?
      search.merge!({
        sort: [{
          _geo_distance: {
            location: geo_center,
            order: 'asc',
            unit: 'miles'
          }
        }],
        size: per_page
      })
    end

    if food_types.present?
      search.merge!({
        query: {
          bool: {
            must: { 
              terms: { food_types: food_types }
            }
          }
        }
      })
    end

    search.merge!({
      aggregations: {
        food_type: {
          terms: {
            field: 'food_types',
            size: 400
          }
        }
      }})
    
    self.search(search)
  end

  def to_hsh
    {
      id: id,
      title: title,
      food_types: food_types.to_sentence,
      latitude: location[0],
      longitude: location[1]
    }
  end
end
