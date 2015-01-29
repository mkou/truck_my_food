window.FoodTypes = Backbone.Collection.extend({
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