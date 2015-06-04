class Air.Behaviors.SaveModel extends Air.BaseBehavior

  initialize: ->


    @listenTo @view, 'dialog:click:save', =>
      if !@view.model.validate()
        @view.trigger 'validation:model:is:valid'
      else
        @view.trigger 'validation:model:is:not:valid'
        if @options.message
          Air.execute 'notify:error', Air.request('lang:get', @options.message)
        else
          Air.execute 'notify:error', Air.request('lang:get', 'validation:error')
