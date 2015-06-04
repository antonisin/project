@Air.module 'Monitoring.Comment', (Comment, App, Backbone, Marionette, $, _) ->

  class Comment.View extends Air.BaseItemView
    template    : 'monitoring/comment/view'
    tagName     : 'form'
    className   : 'form-horizontal'
    _modelBinder: undefined
    dialog      :
      title: 'Коментарий'

    events      :
      'submit form': ->
        @trigger 'click:save', @model,

       'keyup textarea': (e) ->
        @$('#number').html(e.target.value.length)
        
    templateHelpers: ->
      comment: @comment

    initialize: (opts)->
      @comment = opts.comment
