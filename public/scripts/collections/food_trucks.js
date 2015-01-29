// The Food Truck collection
// Listens to any changes of the search models to fetch the data from the server
window.FoodTrucks = Backbone.Collection.extend({
  model: FoodTruck,
  url: 'v1/food_trucks/search',

  initialize: function(search){
    this.search = search;
    this.listenTo(search, 'change', this.reload, this);
  }, 
  reload: function(){
    this.fetch({data: this.search.attributes, reset: true});
  }
})