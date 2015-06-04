class Air.BaseItemView extends Backbone.Marionette.ItemView
  @mixin 'ui_init', 'select2'

  initDatePickers: (opts = {}) ->
    _.defaults opts,
      autoclose : true
      format    : 'dd/mm/yyyy'
      startDate : '+0d'
      language  : 'ru'

    @$('.date-picker').datepicker opts

  initTimeEntry: (opts = {}) ->
    _.defaults opts,
      show24Hours: true
      defaultTime: '00:00'
      spinnerImage: ''
      weekStart: 1
    @$('.timepicker').timeEntry opts

  onClose: ->
    @$el.find('.ttp').tooltip 'destroy'
    @$('.date-picker').datepicker "remove"
    $.each @$el.find("[name='startLocation'], [name='endLocation'], [name='city'], [name='airline'], [name='startDelta'], [name='endDelta']"), -> $(@).select2("destroy")

  onBeforeClose: ->
    @$el.find('.ttp').tooltip 'destroy'

  scrollTopAnimated: ->
    $('html, body').animate({scrollTop:0}, 220)

  appendView : (view) ->
    appendView = view.render().el
    @$el.after(appendView)

