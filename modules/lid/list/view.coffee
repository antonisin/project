@Air.module 'Lid.List', (List, App, Backbone, Marionette, $, _) ->
  class List.ListItemView extends Air.BaseItemView
    template          : 'lid/list/item'
    tagName           : 'tr'

    onShow: ->
      @$(".pop").popover trigger: "hover"

      @updateUI()

    events:
      'click td:not(".notClick")' : -> @trigger 'item:click', @model
      'click .notClick'      : ->
        @$('.lidTableItems').toggleClass 'lidTableItemHide', 200
        @$('.fa-long-arrow-down').toggleClass 'fa-long-arrow-up'

      'click #delete'   : (e) ->
        e.stopImmediatePropagation()
        @trigger 'click:delete', @model

  class List.ListEmptyView extends Air.BaseItemView
    template          : "lid/list/empty"
    tagName           : "tr"

  class List.ListTableView extends Air.BaseCompositeView
    template              : 'lid/list/list'
    itemView              : List.ListItemView
    emptyView             : List.ListEmptyView
    itemViewContainer     : 'tbody'

    events:
      'click .dt-search' : -> @trigger 'toggle:search'
      'click .toggleList': (e) -> @toggleList e.target

    toggleList: (el) ->
      if el.nodeName == 'A' then el = @$(el).find('i') else el = @$(el)
      el.toggleClass 'fa-angle-up fa-angle-down'
      @$('.lidTableItems').toggleClass 'lidTableItemHide', 200
      @$('.fa-long-arrow-down').toggleClass 'fa-long-arrow-up'

    onBeforeRender: ->
      $('.has-tooltip').tooltip 'destroy'

    onShow: ->
      @updateUI()
      App.Utils.DT.initDT '#lidstable',
        ordering: false
        searching: false

  class List.ListFilterView extends Air.BaseItemView
    template          : "lid/list/filter"
    tagName           : "form"
    className         : "form-inline"

    events:
      'click #advanced'        : 'advanced'
      'submit'                 : 'submit'
      'keyup input'            : 'processKey'
      'change [name="period"]'      : 'filterDate'
      'change [name="createdFrom"]' : 'changeCreatedFrom'
      'change [name="startFrom"]'   : 'changeStartFrom'
      'change [name="endFrom"]'     : 'changeEndFrom'

      'click .btn-danger' : (e)->
        $(':input:not(:button):not(:checkbox):not(:submit)').val('')
        $('.select2-container').select2('val', '');
        $('.deep-search').prop('checked', false).closest('span').removeClass();
        @submit(e)

    initialize: (opts) ->
      { @classes, @statuses } = opts

    onShow: ->
      @renderLists()
      @initComponents()

    initComponents: ->
      @initDatePickers startDate: null
      @updateUI()
      @initLocationPickers()

    filterDate: ->
      dateFormat = 'DD/MM/YYYY'
      endValue = moment().format dateFormat
      period = @$("select[name='period']").val()

      if period is 'today'
        startValue = endValue
      else if period is 'yesterday'
        startValue = moment().subtract('days', 1).format dateFormat
        endValue = startValue
      else if period is 'this-week'
        startValue = moment().startOf('week').format dateFormat
      else if period is 'last-week'
        startValue = moment().subtract('weeks', 1).startOf('week').format dateFormat
        endValue = moment().subtract('weeks', 1).endOf('week').format dateFormat
      else if period is 'this-month'
        startValue = moment().startOf('month').format dateFormat
      else if period is 'last-month'
        startValue = moment().subtract('months', 1).startOf('month').format dateFormat
        endValue = moment().subtract('months', 1).endOf('month').format dateFormat
      else if period is 'half-year'
        startValue = moment().subtract('months', 6).format dateFormat
      else if period is 'year'
        startValue = moment().subtract('year', 1).format dateFormat

      @$("input[name='createdFrom']").val startValue
      @$("input[name='createdTill']").val endValue

      @$(".date-picker").datepicker('update')

    changeCreatedFrom: ->
      $(".createdTill").datepicker 'setStartDate', $(".createdFrom").datepicker('getDate')
      $('.createdTill').datepicker "show"

    changeStartFrom: ->
      $(".startTill").datepicker "setStartDate", $(".startFrom").datepicker('getDate')
      $(".startTill").datepicker "show"

    changeEndFrom: ->
      $(".endTill").datepicker "setStartDate", $(".endFrom").datepicker('getDate')
      $(".endTill").datepicker "show"

    processKey: (e) ->
      if e.which is 13
        event.preventDefault()
        @trigger 'submit', @$el.serialize()

    renderLists: ->
      _.each @classes.models, (el) =>
        $("<option>").appendTo(@$("[name='klass']")).append(el.get('name')).val(el.id)

      _.each @statuses.models, (el) =>
        $("<option>").appendTo(@$("[name='status']")).append(el.get('name')).val(el.id)

    advanced: (e) ->
      @$el.find("#advanced").tooltip 'hide'
      @$("#search_detailed").slideToggle()
      $('.search_z_button').find("i.change").toggleClass "fa-chevron-up fa-chevron-down"

    submit: (e) ->
      e.preventDefault()
      @trigger 'submit', @$el.serialize()
      _.defer =>
        $('.ttp').tooltip 'hide'
        $('.has-tooltip').tooltip 'destroy'
