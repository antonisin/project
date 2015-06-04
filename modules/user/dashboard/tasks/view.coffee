@Air.module 'User.Dashboard.Tasks', (Tasks, App, Backbone, Marionette, $, _) ->

  class Tasks.ItemView extends Air.BaseItemView
    template: 'dashboard/tasks/item'
    tagName: 'tr'

  class Tasks.CompositeView extends Air.BaseCompositeView
    template: 'dashboard/tasks/list'
    itemView: Tasks.ItemView
    className: 'portlet box blue tabbable message_tab'
    itemViewContainer: 'tbody'

    ui:
      'range' : 'li'

    events:
      'click @ui.range': 'changeRange'

    changeRange: (e) ->
      @$el.find('li').removeClass 'active'
      @$(e.currentTarget).addClass 'active'

      range = e.currentTarget.getAttribute('data')
      @trigger 'dashboard:tasks:range:change', range
