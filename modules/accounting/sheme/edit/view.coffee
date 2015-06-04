@Air.module 'Accounting.Scheme.Edit', (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.ItemView extends Air.BaseItemView
    _modelBinder: undefined
    template: 'accounting/scheme/edit/item'

    events:
      'click .addRow': 'addRow'
      'click .addCol': 'addCol'
      'click .removeCol': 'removeCol'
      'click .removeRow': 'removeRow'
      'change input:not([name="schemeName"])': 'changeInput'
      'click .bonusShow:not(.disabled)' : 'bonusShow'
      'click .schemeShow:not(.disabled)': 'schemeShow'
      'click .addBonusRow': 'addBonusRow'
      'click .removeBonusRow': 'removeBonusRow'

    dialog: ->
      title: if @model.id then 'Редактироваание схемы: ' + @model.get('schemeName') else 'Добавление нововй схемы'

    onShow: ->
      @$('input:not([name="schemeName"])').inputFilter 'number'
      @updateUI()
      @bind()
      if @model.get('conversions')
        @resizeModal (@model.get('conversions').length - 2)

    bonusShow: ->
      @setSizeModal 40
      @toggleBlock()

    schemeShow: ->
      @resizeModal @$el.find('#scheme-edit tbody tr:first td').length - 3
      @toggleBlock()

    addBonusRow: ->
      tr = @$el.find('#bonus-edit tbody tr:last').clone()
      tr.find('input').val ''
      @$el.find('#bonus-edit tbody').append tr

    removeBonusRow: (e) ->
      if @$el.find('#bonus-edit tbody tr').length > 1
        @$el.find(e.currentTarget).closest('tr').remove()

    toggleBlock: ->
      @$el.find('.bonusShow, .schemeShow').toggleClass 'disabled'
      @$el.find('.blockBonus, .blockScheme').toggleClass 'hide'

    templateHelpers: ->
      parentModel : @model

    initialize: ->
      @model = @options.model
      @listenTo @, 'dialog:click:save', => @save()
      @listenTo @, 'modal:hidden', -> $('#dialogLarge').css({left: '', width: ''})

    bind: ->
      @bindings =
        schemeName : '[name="schemeName"]'

      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @

    addCol: ->
      if @$el.find('#scheme-edit thead tr:last th').length < 9
        th = @$el.find('thead tr th:last').prev()
        cel = th.clone()
        cel.find('input').addClass('empty').val('')
        th.after cel[0]

        td = @$el.find('#scheme-edit tbody tr:not(:last) td:nth-last-child(2)')
        cel = td.last().clone()
        cel.find('input').addClass('empty').val('')
        td.after cel[0]

        td = @$el.find('td:last').prev()
        cel = td.clone()
        td.after cel[0]

        @resizeModal 1

    removeRow: (e) ->
      if @$el.find('#scheme-edit tbody tr').length > 2
        @$(e.target).closest('tr').remove()

    addRow: ->
      tr = @$el.find('#scheme-edit tr:last').prev()
      row = tr.clone()
      row.find('input').addClass('empty').val('')
      tr.after row

    removeCol: (e) ->
      if @$el.find('[name="conversion"]').length > 2
        tds = @$el.find('tr:last td')
        index = tds.index($(e.target).closest('td')) + 1
        @$el.find("td:nth-child(#{index})").remove()
        @$el.find("thead tr:last th:nth-child(#{index})").remove()
        @resizeModal -1

    getPercents: ->
      array = []

      percents = @$el.find '[name="percent"]'
      percents.each (index, element) =>
        array.push parseInt(element.value)

      array

    getConversions: ->
      array = []

      conversions = @$el.find '[name="conversion"]'
      conversions.each (index, element) =>
        array.push parseInt(element.value)

      array

    getGPLid: ->
      array = []

      gpLid = @$el.find '[name="GPLid"]'
      gpLid.each (index, element) =>
        array.push  parseInt(element.value)

      array

    getGP: ->
      array  = []

      gp = @$el.find '[name="GP"]'
      gp.each (index, element) =>
        array.push parseInt(element.value)

      array

    getBonus: ->
      array = []

      bonus = @$el.find '[name="bonus"]'
      bonus.each (index, element) =>
        array.push parseInt(element.value)

      array

    changeInput: (e) ->
      @$(e.target).removeClass 'empty'

      if e.target.value
        @$(e.target).removeClass('has-error')
      else
        @$(e.target).addClass('has-error')

    getData: ->
      'conversions': @getConversions()
      'percents': @getPercents()
      'GPLid': @getGPLid()
      'bonusScheme': ['bonus': @getBonus(),'GP' : @getGP()]

    save: ->
      if @$el.find('input[name="schemeName"]').val() == ''
        @$el.find('input[name="schemeName"]').addClass 'has-error'

      errors = @$el.find('input.has-error, input.empty')
      if errors.length > 0 and @$el.find('input[name="schemeName"]').val() == ''
        App.execute 'notify:error', App.request('lang:get', 'usersaveerror')
        errors.addClass('has-error')
      else
        @model.trigger 'save:action', @getData()
        App.execute 'notify:success', App.request('lang:get', 'data:save:success')

    resizeModal: (K) ->
      left =  $('#dialogLarge').position().left
      width = $('#dialogLarge').width()
      $('#dialogLarge').css
        'left' : left - K * 60
        'width' : width + K * 120

    setSizeModal: (value) ->
      $('#dialogLarge').css
        'left' : ((100 - value) / 2) + '%'
        'width' : value + '%'
