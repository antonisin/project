@Air.module "Footer.Lid", (Lid, App, Backbone, Marionette, $, _) ->

  class Lid.View extends Air.BaseItemView
    template  : 'footer/lid/view'
    className : 'footer footer-custom'
    sendText: "<span class='text-info'><i class='fa fa-envelope'></i></span> Отправить предложения"
    sendLoadingText : "<span class='text-info'><i class='fa fa-spinner fa-spin'></i></span> Ждите"

    events:
      'click a'                              : 'click'
      'click #send-offers'                   : 'sendOffers'
      'click #create-sale'                   : 'createSale' 
      'mouseenter a[class!=disabled]'        : 'mouseEnter' 
      'mouseleave a[class!=disabled]'        : 'mouseLeave'
      'offers:sent'                          : 'sent'
      'click #go-top'                        : 'goTop'

    goTop:->
      $('body').animate({scrollTop: 0 }, 400)

    initialize: ->
      @listenTo @, 'offers:sending',   => @sending()
      @listenTo @, 'offers:sent',      => @sent()
      @listenTo @, 'booking:ready',    => @$("a").removeClass 'disabled'
      @listenTo @, 'booking:notready', => @$("a").addClass 'disabled'
      @listenTo App.vent , 'remove:disable:create:sale', => @$('#create-sale').removeClass 'disabled'

    click: (e) ->
      if @$(e.target).hasClass 'disabled'
        e.stopImmediatePropagation()
        e.preventDefault()
        @trigger 'error', 'lid:footer:nobooking'
        false

    createSale: ->
      @trigger 'click:create:sale'
      false
      
    sendOffers: ->
      @trigger 'click:send:offers' if !@$("#send-offers").hasClass 'disabled'
      false

    sending: ->
      @$("#send-offers").addClass('disabled').html @sendLoadingText

    sent: ->
      @$("#send-offers").removeClass('disabled').html @sendText

    mouseEnter: (e) ->
      $el = $ e.target
      $el.find('i').addClass 'fa-spin'

    mouseLeave: (e) ->
      $el = $ e.target
      $el.find('i').removeClass 'fa-spin'
