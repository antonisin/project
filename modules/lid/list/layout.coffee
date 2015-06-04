@Air.module 'Lid.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends Air.BaseLayout
    template: 'lid/list/layout'
    regions:
      list    : '#list'
      filter  : '#filter'
    events:
      'click .dt-search.top' : -> @trigger 'view:toggle:search'
    initialize: ->
      @listenTo @ , 'view:toggle:search' , =>
        @$('.dt-search').toggle(100)
        @$('#filter').toggle(200)
