// Prepares the autocomplete with the data from the collection
// Updates the search when a food_type is selected
// Adds the tags of the searched food_types
window.FoodTypesView = Backbone.View.extend({
  initialize: function(){
    this.listenTo(this.collection, "reset", this.prepare_autocomplete, this);
    this.$typeaheadEl = $('#food-type-autocomplete');
  },
  el: $('#food-types'),
  prepare_autocomplete: function(){
    food_types_names = this.collection.pluck('key');
    var current_view = this;
    this.$typeaheadEl.typeahead('destroy');
    this.$typeaheadEl.typeahead({
        source: food_types_names,
        afterSelect: function(food_type) {
          var new_food_types = _.clone(App.search.get('food_types'));
          new_food_types.push(food_type);
          //Set the search
          App.search.set({food_types: new_food_types});
          current_view.addTag(food_type);
          $('#food-type-autocomplete').val('');
        }
    });
  },
  addTag: function(food_type) {
    var foodType = new FoodType({food_type: food_type})
    var foodTypeView = new FoodTypeView({model: foodType});
    this.$el.append(foodTypeView.render().el);
  }
});