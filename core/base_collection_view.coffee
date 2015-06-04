class Air.BaseCollectionView extends Backbone.Marionette.CollectionView
  itemViewEventPrefix: 'childview'
  @mixin 'ui_init', 'select2', 'render_order'

  onBeforeClose: ->
    @$el.find('.ttp').tooltip 'destroy'

