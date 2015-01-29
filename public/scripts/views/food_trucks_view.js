window.FoodTrucksView = Backbone.View.extend({
  initialize: function(){
    this.listenTo(this.collection, "change reset add remove", this.render);
  },
  el: $("#food-trucks"),
  render: function(){
    this.addAll();
    return this;
  },
  addAll: function(){
    this.$el.empty();
    this.deleteMarkers();
    this.collection.forEach(this.addOne, this);
  },
  addOne: function(foodTruck){
    var foodTruckView = new FoodTruckView({model: foodTruck});
    this.$el.append(foodTruckView.render().el);
  },
  deleteMarkers: function(){
    FoodMap.deleteMarkers();
  }
});