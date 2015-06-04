@Air.module 'Lid.TasksPaper', (TasksPaper, App, Backbone, Marionette, $, _) ->

  class TasksPaper.CommentItemView extends Air.BaseItemView
    template: 'taskmanager/view/taskspaper/comment'
    className: 'col-md-12'

  class TasksPaper.CommentCollectionView extends Air.BaseCollectionView
    itemView: TasksPaper.CommentItemView

  class TasksPaper.EmptyView extends Air.BaseItemView
    template: 'taskmanager/view/taskspaper/empty'

  class TasksPaper.ItemView extends Air.BaseItemView
    template: 'taskmanager/view/taskspaper/item'
    className: 'col-md-12'
    events:
      'click .addComment': 'addComment'
      'click .toggleComments' : 'toggleComments'

    toggleComments: ->
      @$el.next().find('.comment, .date').toggleClass 'hide'
      @$el.find('.showComments, .hideComments').toggleClass 'hide'

    addComment: ->
      @$el.next().find('.comment, .date').removeClass 'hide'
      @$el.find('.hideComments').addClass 'hide'
      @$el.find('.showComments').removeClass 'hide'
      @trigger 'task:add:comment', @model

    onShow: ->
      @collection = App.request 'lid:task:paper:comment:collection', @model.get('comments')
      @listenTo App.vent, 'task:add:model:in:collection' + @model.id, (model) =>
        @collection.push model

      @view = @getView()

      @appendView @view
#      @toggleComments()

    getView: ->
      new TasksPaper.CommentCollectionView
        collection: @collection

  class TasksPaper.CompositeView extends Air.BaseCompositeView
    template         : 'taskmanager/view/taskspaper/composite'
    itemView         : TasksPaper.ItemView
    emptyView        : TasksPaper.EmptyView
    itemViewContainer: '#items'
    renderOrder: "DESC"

    triggers:
      'click .addTask': 'addTask'
      'click .closeBooking': 'lid:task:paper:booking:close'
