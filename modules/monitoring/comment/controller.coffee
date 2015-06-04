@Air.module 'Monitoring.Comment', (Comment, App, Backbone, Marionette, $, _) ->
  class Comment.Controller extends App.Base.Controller
    
    initialize: (opts) ->
      @show @getView opts.model.get('comment')

    getView: (comment) ->
      view = new Comment.View
        comment: comment

      @listenTo view, 'dialog:click:save', ->
        @modelSave view

      view

    modelSave: (view) ->
      viewValue =  view.$('[name="comment"]')
      findSimbol = /// \S+///

      if viewValue.val()!="" and findSimbol.test viewValue.val()
        @model.set 'comment', viewValue.val()
        @loading()
        @model.save @model.attributes,
          wait: true, 
          success: =>
            App.vent.trigger 'monitoring:comment:sync'
            App.execute 'notify:success', App.request('lang:get','data:save:success')
            @close()
      else
       viewValue.addClass('has-error')
       App.execute 'notify:error', App.request('lang:get', 'usersaveerror')
