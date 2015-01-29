window.App = new (Backbone.View.extend({

  initialize: function(){
    FoodMap.initialize();
    this.search = new Search({longitude: 37.772674, latitude: -122.444725, food_types: []});
    this.foodTrucks = new FoodTrucks(this.search);
    this.foodTrucks.fetch({data: this.search.attributes});
    this.foodTypesAround = new  FoodTypes({around: true, search: this.search});
    this.foodTypesAround.fetch({data: this.search.attributes});
    this.foodTrucksView = new FoodTrucksView({collection: this.foodTrucks});
    this.foodTypes = new FoodTypes({});
    this.foodTypesView = new FoodTypesView({collection: this.foodTypes});  
  },

  render: function(){
    $('#food-trucks').html(this.foodTrucksView.el);
    this.foodTrucksView.render();
    this.foodTypes.fetch();
  }
}));


$(function(){ App.render() });