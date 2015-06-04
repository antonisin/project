@Air.module 'Preference.Tags', (Tags, App, Backbone, Marionette, $, _) ->

  class Tags.ItemView extends App.BaseItemView
    template: 'preference/tag/item'
    tagName : 'tr'
    triggers:
      'click #delete:not(.disabled)': 'preference:tag:delete'
      'click #edit:not(.disabled)'  : 'preference:tag:edit'

    templateHelpers :=>
      'indexOf': (@model.collection.indexOf @model) + 1

  class Tags.CompositeView extends App.BaseCompositeView
    template: 'preference/tag/list'
    itemView: Tags.ItemView
    itemViewContainer: 'tbody'

    triggers:
      'click #add': 'preference:tags:add'

    onDomRefresh:->
      @initDT()

    initDT: ->
      App.Utils.DT.initDT '#tagsTable',
        ordering : false
        searching: false
        sort: [0, 'asc']
        paginate: false
        initComplete: (=> @$("#add").prependTo @$("#lidstable_wrapper .row:first .col-md-6:last"))
