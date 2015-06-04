class Air.Behaviors.CheckEmail extends Air.BaseBehavior

  ui:
    'check': '.checkEmail'

  events:
    'click @ui.check': 'checkEmail'

  checkEmail:(e) =>
    @elem = e.currentTarget.children[0]
    email = @$(e.currentTarget).prev().val()

    @view.$el.find(@elem).addClass 'fa-spinner fa-spin'
    @sendDataXHR email

  sendDataXHR: (data) =>
    $.ajax
      url: Config.routePrefix + 'check/email'
      method: 'POST'
      data:
        'email': data
      success:(data) =>
        @view.$el.find(@elem).removeClass 'fa-spinner fa-spin'
        if data
          Air.execute 'notify:success', Air.request('lang:get', 'lid:email:exist')
        else
          Air.execute 'notify:error', Air.request('lang:get', 'lid:email:not:exist')
      error: =>
        @view.$el.find('.checkEmail span').removeClass 'fa-spinner fa-spin'
