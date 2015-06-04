@Air.module 'Sale.Send', (Send, App, Backbone, Marionette, $, _) ->

  class Send.SendLayout extends Air.BaseLayout
    template: 'sale/send/layout'

    dialog:
      title: 'Отправка продажи'

    regions:
      content: '#content'

  class Send.SendPrepareView extends Air.BaseItemView
    template: 'sale/send/prepare'
    events:
      'click .addEmail' : 'addEmail'
      'change input[name="email"]' : 'checkEmail'
      'click .removeEmail' : 'removeEmail'

    initialize: (opts) ->
      { @emails, @id } = opts

      @listenTo @, 'sale:send', @send

    onShow: ->
      if !(@emails.length == 1 and @emails[0] == "")
        for email, i in @emails
          $("<label>")
            .appendTo(@$("#emails"))
            .append("<input type='checkbox' value='#{email}' name='email[#{i}]'/>")
            .append email

      @$("a").attr 'href', "#{Config.routePrefix}sale/send/#{@id}"
      App.vent.trigger 'dialog:position:update'
      @updateUI()

    checkEmail: (e) ->
      @$(e.target).removeClass('new')
      if !@validateEmail e.target.value then @$(e.target).addClass('has-error')
      else @$(e.target).removeClass('has-error')

    validateEmail: (email) ->
      re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i
      return re.test(email);

    addEmail: ->
      input = "<input style = 'margin: 0 0 4px 5px; width: 350px; display: inline-block;' class='form-control new ' name='email' checked/>
              <span class='glyphicon glyphicon-remove  removeEmail red' style='cursor:pointer'></span>";
      @$("#otherEmail").append(input)

    removeEmail: (e)->
      @$(e.target).prev().remove()
      @$(e.target).remove()

    send: ->
      if @$("input.has-error[name='email'], input.new[name='email']").length > 0
        App.execute 'notify:error', App.request('lang:get', 'sale:send:noemails')
      else
        if @$("input:checked").length == 0 and @$("input[name='email']").length == 0
          App.execute 'notify:error', App.request('lang:get', 'sale:send:noemails')
        else
          @serialize()

    serialize: ->
      m = []
      $.each @$("input:checked, input[name='email']"), -> m.push @value
      @trigger 'send', m

  class Send.SendFailView extends Air.BaseItemView
    template: 'sale/send/fail'

    initialize: (opts) ->
      @errors = opts.errors

    onShow: ->
      for error in @errors
        $("<li>")
          .appendTo("#errors")
          .html(error)

  class Send.SendSuccessView extends Air.BaseItemView
    template: 'sale/send/success'

    initialize: (opts) ->
      @emails = opts.emails

    onShow: ->
      # debugger
      for email, i in @emails
        $("<li>")
          .appendTo(@$("#emails"))
          .append email

      @$("a").attr 'href', "#{Config.routePrefix}sale/send/#{@model.id}"
