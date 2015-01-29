//The FoofTruckView has two components:
// - The list element on the left of the page
// - The food trucks markers on the right of the page
// It listens to the model it is attached to, if it changes, the view will be updated

window.FoodTruckView = Backbone.View.extend({
  initialize: function(){
    this.model.on('change', this.render, this);
  },

  id: function(){
    return this.model.get('id');
  },

  className: 'food-truck',

  template: '<img src="images/food-truck.png"> {{title}}',

  events: {
    'click' : 'openInfoWindow'
  },

  render: function(){
    this.$el.html(Mustache.to_html(this.template,this.model.toJSON()));
    this.addGeoMarker();
    return this;
  },

  addGeoMarker: function (){
    var image = 'images/food-truck.png';
    var position = new google.maps.LatLng(this.model.get('latitude'), this.model.get('longitude'));
    this.marker = App.mapView.createMarker(position, this.model.get('title'),  image)
    this.infowindow = App.mapView.createInfowindow(this.infowindowcontent(), this.marker)
    App.mapView.markers.push(this.marker);
  },

  openInfoWindow: function() {
    google.maps.event.trigger(this.marker, 'click');
  },

  infowindowcontent: function(){
    return '<div id="map-marker-tag">'+
      '<h3 id="firstHeading" class="firstHeading">'+this.model.get('title')+'</h3>'+
      '<div >'+
      '<p><b>Food types: </b>' + this.model.get('food_types') + '</p>'
      '</div>'+
      '</div>';
  }
});
