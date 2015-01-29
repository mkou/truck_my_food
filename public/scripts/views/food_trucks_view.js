// The View of the collection of food trucks populates creates new food truck single views (marker + list)
// It listens to any change on the collection to render the views
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
    var container = document.createDocumentFragment();
    this.collection.forEach(function(foodTruck) {
      var foodTruckView = new FoodTruckView({model: foodTruck});
      container.appendChild(foodTruckView.render().el);
    }, this);
    this.$el.append(container);
  },
  deleteMarkers: function(){
    App.mapView.deleteMarkers();
  }
});