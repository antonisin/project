class Air.Behaviors.AdminAdd extends Air.BaseBehavior

  ui:
    'add' : '.adminAdd'

  events:
    'click @ui.add': 'addModel'

  addModel: ->
    Air.vent.trigger 'admin:' + @options.query + ':model:add'
