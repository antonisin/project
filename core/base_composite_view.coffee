class Air.BaseCompositeView extends Backbone.Marionette.CompositeView
  itemViewEventPrefix: 'childview'
  @mixin 'ui_init', 'select2', 'render_order_composite'

  onBeforeClose: ->
    @$el.find('.ttp').tooltip 'destroy'

  appendView : (view) ->
    appendView = view.render().el
    @$el.find(@itemViewContainer).append(appendView)
