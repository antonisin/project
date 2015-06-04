@Air.module 'Lid.View', (View, App, Backbone, Marionette, $, _) ->

  class View.CommentsController extends App.Base.Controller
    name: 'lid/history/comments'

    initialize: (opts) ->
      { @collection } = opts
      @show @getView()

      @listenTo App.vent, 'history:comments:add', (opts) =>
        return if opts.id isnt @collection.historyId

        comment = App.request 'history:comment', opts
        comment.save comment.attributes,
          success: => @collection.add comment

    getView: ->
      new View.CommentsListView
        collection: @collection

  class View.CommentsListItemView extends Air.BaseItemView
    template  : 'lid/history/comment_item'
    tagName   : "tr"

  class View.CommentsListEmptyView extends Air.BaseItemView
    template  : 'lid/history/comment_empty'
    tagName   : 'tr'
    className : 'control-label'

  class View.CommentsListView extends Air.BaseCompositeView
    template              : 'lid/history/comments_list'
    itemView              : View.CommentsListItemView
    emptyView             : View.CommentsListEmptyView
    itemViewContainer     : 'table'

    appendHtml: (compositeView, itemView, index) ->
      if compositeView.isBuffering
        compositeView.elBuffer.insertBefore itemView.el, null
      else
        container = @getItemViewContainer compositeView
        container.prepend itemView.el

    appendBuffer: (compositeView, buffer) ->
      container = @getItemViewContainer compositeView
      container.append buffer


  App.reqres.setHandler 'lid:view:history', (opts) =>
    new View.CommentsController opts
