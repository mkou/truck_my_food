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
