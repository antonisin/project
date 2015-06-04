@Air.module 'Lid.TasksBar', (TasksBar, App, Backbone, Marionette, $, _) ->

  class TasksBar.ItemView extends Air.BaseItemView
    template: 'taskmanager/view/tasksbar/item'
    events:
      'click .hideBlock' : 'hide'

    hide: (e) ->
      if e.target.nodeName != "I" then e = $(e).parent()
      $(document).find('.taskManager').toggle('blind','' ,500)
      $(e.target).toggleClass('fa-chevron-down fa-chevron-up')
