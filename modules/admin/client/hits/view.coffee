@Air.module 'Admin.Client.Hits', (Hits, App, Backbone, Marionette, $, _) ->
  class Hits.HitsItemView extends App.BaseItemView
    template          : 'admin/client/hit_item'
    tagName           : 'tr'

  class Hits.HitsItemViewEmpty
    template          : 'admin/client/hit_empty'
    tagName           : 'tr'

  class Hits.HitsCollectionView extends App.BaseCompositeView
    template          : 'admin/client/hit_list'
    itemView          : Hits.HitsItemView
    emptyView         : Hits.HitsItemViewEmpty
    itemViewContainer : 'tbody'

    onDomRefresh: ->
      if @collection.length > 10
        @$("table").scrollTableBody()
        _.defer =>
          @$(".jqstb-scroll").width @$(".jqstb-scroll").width() - 12  
      if @collection.length > 1
        App.vent.trigger 'dialog:position:update'


