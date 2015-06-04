class Air.Behaviors.AdminEdit extends Air.BaseBehavior

  ui:
    'edit' : '.adminEdit'

  events:
    'click @ui.edit': 'editModel'

  editModel: ->
    Air.vent.trigger 'admin:' + @options.query + ':model:edit', @view.model
