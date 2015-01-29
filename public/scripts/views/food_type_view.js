// View of a single tag in the food type search
//listens to the model it is attached to: renders the view when the model is changed
window.FoodTypeView = Backbone.View.extend({
  template:  '{{food_type}} <span data-role="remove"></span>',
  tagName: 'span',
  className: 'tag',
  events: {
    'click [data-role=remove]': 'remove_tag'
  },
  render: function(){
    this.$el.html(Mustache.to_html(this.template,this.model.toJSON()));
    return this;
  },
  remove_tag : function() {
    food_type = this.model.get('food_type');
    var new_food_types = _.clone(App.search.get('food_types')).filter(function(i) { return i !=  food_type});
    App.search.set({ food_types: new_food_types });
    this.el.remove();
  }
});
