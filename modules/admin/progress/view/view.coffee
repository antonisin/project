@Air.module 'Admin.Progress.View', (View, App, Backbone, Marionette, $, _) ->

  class View.ItemView extends App.BaseItemView
    template: 'admin/progress/view/item'
    className: 'progressBox'

    behaviors:
      AdminEdit: query: 'progress'
      AdminDelete: query: 'progress'

  class View.CompositeView extends App.BaseCompositeView
    template: 'admin/progress/view/layout'
    itemView: View.ItemView
    itemViewContainer: '#items'

    behaviors:
      AdminAdd: query: 'progress'

    onDomRefresh:->
      @initDT()

    initDT: ->
      App.Utils.DT.initDT '#lidstable',
        sort: [0, 'asc']
        initComplete: (=> @$("#add").prependTo @$("#lidstable_wrapper .row:first .col-md-6:last"))
