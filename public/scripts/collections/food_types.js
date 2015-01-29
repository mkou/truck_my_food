// The Food Types collection
// The app has two food types collection. 
//   - The first one is fetched once on the load page and contains ALL the food types available and is used to populate the autocomplete
//   - The second one is the list of food types around a location. It's the list of the 5 closest trucks that might be present.
// This last collection listens to the changes of latitude and longitude the search models to fetch the data from the serverwindow.

FoodTypes = Backbone.Collection.extend({
  model: FoodTruck,
  url: function(){
    if (this.around) {
      return "v1/food_types/around_location";
    }else {
      return 'v1/food_types';
    }
  },
  initialize: function(opts){
    this.around = opts['around'];
    var search = opts['search'];

    if (this.around) {
      this.listenTo(search, 'change:latitude', this.reload, this);
      this.listenTo(search, 'change:longitude', this.reload, this);
    }
  },

  reload: function() {
    this.fetch( { data: App.search.attributes } )
  }
})