@Air.module 'Sale.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends Air.BaseLayout
    template: 'sale/list/layout'
    regions:
      filter  : '#filter'
      list    : '#list'
    events:
      'click .dt-search.top' : -> @trigger 'view:toggle:search'
    initialize: ->
      @listenTo @ , 'view:toggle:search' , =>
        @$('.dt-search').toggle(100)
        @$('#filter').toggle(200)
