class Air.Behaviors.AdminDelete extends Air.BaseBehavior

  ui:
    'delete': '.adminDelete'

  events:
    'click @ui.delete': 'deleteModel'

  deleteModel: ->
    Air.execute 'show:confirm', Air.request('lang:get', @options.query + ':delete:confirm', []), =>
      @view.model.destroy()
      Air.execute 'notify:success', Air.request('lang:get', 'delete:success')
