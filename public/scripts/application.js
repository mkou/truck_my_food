// The App :)
window.App = new (Backbone.View.extend({

  initialize: function(){
    //Initialize the search
    this.search = new Search({longitude: 37.772674, latitude: -122.444725, food_types: []});

    // Create and fetch the food trucks
    this.foodTrucks = new FoodTrucks(this.search);
    this.foodTrucks.fetch({data: this.search.attributes, reset: true});

    // Create an fetch the food types around the search
    this.foodTypesAround = new  FoodTypes({around: true, search: this.search});
    this.foodTypesAround.fetch({data: this.search.attributes});

    //Initialize the map
    this.mapView = new MapView(this.foodTypesAround);

    // Prepare FoodTrucks view
    this.foodTrucksView = new FoodTrucksView({collection: this.foodTrucks});

    // Populate the autocomplete on food data
    this.foodTypes = new FoodTypes({});
    this.foodTypesView = new FoodTypesView({collection: this.foodTypes});  
  },

  render: function(){
    $('#food-trucks').html(this.foodTrucksView.el);
    this.foodTrucksView.render();
    this.foodTypes.fetch({ reset: true });
  }
}));


$(function(){ App.render() });