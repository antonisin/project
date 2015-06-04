@Air.module 'Lid.SalesPaper', (SalesPaper, App, Backbone, Marionette, $, _) ->

  class SalesPaper.EmptyView extends Air.BaseItemView
    template: 'taskmanager/view/salespaper/empty'

  class SalesPaper.ItemView extends  Air.BaseItemView
    template: 'taskmanager/view/salespaper/item'
    className: 'col-md-12'

  class SalesPaper.CompositeView extends Air.BaseCompositeView
    template         : 'taskmanager/view/salespaper/composite'
    itemView         : SalesPaper.ItemView
    emptyView        : SalesPaper.EmptyView
    itemViewContainer: '#items'
