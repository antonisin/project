@Air.module 'Booking.Offer', (Offer, App, Backbone, Marionette, $, _) ->

  class Offer.MailLayout extends Air.BaseLayout
    template: 'booking/offer/mail_layout'

    dialog:
      title: 'Отправка предложений'
      buttons:
        save: false
        cancel: false

    regions:
      content: '#content'

  class Offer.MailErrorView extends Air.BaseItemView
    template: 'booking/offer/mail_validate_error'

    initialize: (opts) ->
      { @errors } = opts

    onShow: ->
      if @errors
        $c = $("<ul>").appendTo @$("#errors")
        for o in @errors.global
          $("<li>").appendTo($c).html("<h5>#{o}</h5>")

        for o, offer of @errors.offers
          continue if offer.errors.length is 0 and offer.flights.length is 0

          $o = $("<li>").appendTo($c).html("<h5>Предложение ##{o}</h5>")
          $o = $("<ul>").appendTo $o

          for error in offer.errors
            $("<li>").appendTo($o).html "#{error}"

          for f, flight of offer.flights
            $f = $("<li>").appendTo($o).html("<i>Перелёт ##{f}</i>")
            $f = $("<ul>").appendTo $f

            for error in flight
              $("<li>").appendTo($f).html "#{error}"
      else
        @$("#errors").html 'При обработке предложений произошла неизвестная ошибка'

  class Offer.MailSuccessView extends Air.BaseItemView
    template: 'booking/offer/mail_validate_success'
    events:
      'click .addEmail' : 'addEmail'
      'change input[name="email"]' : 'checkEmail'
      'click .removeEmail' : 'removeEmail'

    initialize: (opts) ->
      { @emails, @previewUrl } = opts

      @listenTo @, 'click:send', @send

    onShow: ->
      for email, i in @emails
        $("<label>")
          .appendTo(@$("#emails"))
          .append("<input type='checkbox' value='#{email}' name='email[#{i}]'/>")
          .append email

      @$("a").attr 'href', @previewUrl
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

  class Offer.MailSendSuccessView extends Air.BaseItemView
    template: 'booking/offer/mail_send_success'

    initialize: (opts) ->
      { @emails, @previewUrl } = opts

    onShow: ->
      for email, i in @emails
        $("<li>")
          .appendTo(@$("#emails"))
          .append email

      @$("a").attr 'href', @previewUrl

  class Offer.MailSendErrorView extends Air.BaseItemView
    template: 'booking/offer/mail_send_error'