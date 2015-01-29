// Handles all map and place autocomplete related events
// creates Markers and view windows
// Updates the search on right click
// Listens to the changes of the food_types around to render the current position marker with the food types window
window.MapView = Backbone.View.extend({
  initialize: function(food_types_around) {
     this.options = {
      zoom: 13, 
      center: new google.maps.LatLng(37.772674, -122.444725)
    };
    this.map = new google.maps.Map(document.getElementById('gmaps-canvas'), this.options)
    this.autocomplete_place();
    this.markers = [];
    google.maps.event.addListener(this.map, 'rightclick', this.updateFromRightClick.bind(this));

    this.listenTo(food_types_around, 'reset', this.setCurrentPositionMarker, this);
  },

  autocomplete_place: function () {
    var options = {
      componentRestrictions: {'country': 'us'}
    }
    this.autocomplete = new google.maps.places.Autocomplete(document.getElementById('place-autocomplete'), options)
    google.maps.event.addListener(this.autocomplete, 'place_changed', this.updateFromAutocomplete.bind(this));
  },

  updateFromAutocomplete: function(){
    this.position = this.autocomplete.getPlace().geometry.location;
    this.update();
  },

  updateFromRightClick: function(e){
    this.position = e.latLng;
    this.update();
  },

  update: function() {
    
    var latitude = this.position.lat();
    var longitude = this.position.lng();

    //Update the search
    App.search.set({latitude: latitude, longitude: longitude});
  },

  setCurrentPositionMarker: function() {
    //Create a marker for the new position
    var marker = this.createMarker(this.position, 'SearchPosition', null);

    // Add an infowindow to this position with the closest food_types available.
    var infoContent = '<h3> Around this position, you will find.. </h3>';
    App.foodTypesAround.forEach(function(food_type) {
      infoContent +='<span class="tag mini">' + food_type.get('key') + '</span>';
    });
    var infowindow = this.createInfowindow(infoContent, marker);
    infowindow.open(this.map, marker);

    this.zoomAndCenter();

    // Replace the locationMarker with the new one
    if (this.locationMarker){
      this.locationMarker.setMap(null);
    }
    this.locationMarker = marker;
  },

  createMarker: function (position, title, image){
    return new google.maps.Marker({
      position: position,
      map: this.map,
      title: title,
      icon: image
    }, this);
  },

  createInfowindow: function (infocontent, marker) {
    var infowindow =  new google.maps.InfoWindow({
      content: infocontent,
      maxWidth: 300,
      maxHeight: 200
    });

    // Link the infowindow to the marker and open it
    google.maps.event.addListener(marker, 'click', function() {
      infowindow.open(this.map, marker);
      this.map.setCenter(marker.position);
    });
    return infowindow;
  },
  deleteMarkers: function () {
    for (var i = 0; i < this.markers.length; i++) {
      this.markers[i].setMap(null);
    }
    this.markers=[];
  },
  zoomAndCenter: function(){
     // Zoom and center the map
    this.map.setZoom(15);
    this.map.setCenter(this.position);
  }
});