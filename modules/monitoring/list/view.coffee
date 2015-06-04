@Air.module 'Monitoring.List', (List, App, Backbone, Marionette, $, _) ->
  class List.ListItemView extends Air.BaseItemView
    template          : 'monitoring/list/item'
    tagName           : 'tr'
    events            :
      'click #archive' : -> @trigger 'monitoring:click:archive' , @model
      'click #listen'  : -> @trigger 'asterisk:click:listen', @model
      'click #whisper' : -> @trigger 'asterisk:click:whisper', @model
      'click #barge'   : -> @trigger 'asterisk:click:barge', @model
      'click #hangup'  : -> @trigger 'asterisk:click:hangup', @model

    initialize: ->
      @model.set('order', @model.collection.indexOf(@model) + 1)

  class List.ListEmptyView extends Air.BaseItemView
    template          : "monitoring/list/empty"
    tagName           : "tr"

  class List.ListCompositeView extends Air.BaseCompositeView
    template              : 'monitoring/list/list'
    itemView              : List.ListItemView
    emptyView             : List.ListEmptyView
    itemViewContainer     : 'tbody'

    onShow: ->
      if @className == 'inline' then @$('.line-time').append('На линии')
      else @$('.line-time').append('В очереди')

      App.Utils.DT.initDT @$('table'),
        searching: false
        info: false
        paging:false
        processing: false
      @updateUI()
