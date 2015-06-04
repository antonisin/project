@Air.module 'TaskStorage.View.Tasks', (Tasks, App, Backbone, Marionette, $, _) ->

  class Tasks.ItemView extends Air.BaseItemView
    template: 'taskstorage/view/tasks/item'
    tagName : 'tr'
    className: ->
      if parseInt(@model.get('isMarked')) == 1 then 'custom-yellow' else ''

    events:
      'click .isMarked': 'toggleMarked'
      'click .isPicked': 'togglePicked'

    triggers:
      'click .hideTask': 'taskstorage:tasks:hide:task'
      'click .done'    : 'taskstorage:tasks:done:task'
      'click .linkLid' : 'taskstorage:task:lid:link'
      'click td:not(.controls)': 'taskstorage:task:lid:link'

    toggleMarked: (e)->
      @$el.find(e.target).toggleClass('text-yellow')
      @trigger 'taskstorage:tasks:is:marked:toggle', @model, +@$el.find(e.target).hasClass('text-yellow');

    togglePicked: (e) ->
      @$el.find(e.target).toggleClass('text-success')
      @trigger 'taskstorage:tasks:is:picked:toggle', @model, +@$el.find(e.target).hasClass('text-success');

  class Tasks.EmptyView extends Air.BaseItemView
    template: 'taskstorage/view/tasks/empty'
    tagName: 'tr'

  class Tasks.CompositeView extends Air.BaseCompositeView
    template: 'taskstorage/view/tasks/list'
    itemView: Tasks.ItemView
    emptyView: Tasks.EmptyView
    itemViewContainer: 'tbody'