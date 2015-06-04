@mixins.select2 = 
  
  initLocationPickers: (opts = {})->
    _.defaults opts,
      selector: "[name='startLocation'], [name='endLocation']",
      url: Config.routePrefix + "locations/search"
      dropdownCssClass: "select2-bigdrop"
      allowClear: true

    @$(opts.selector).select2
      allowClear: opts.allowClear
      minimumInputLength: 1
      dropdownCssClass : opts.dropdownCssClass
      escapeMarkup: (m) -> m
      formatResult: (el) -> "#{el.code} <small>#{el.name}</small>"
      formatSelection: (el) -> "#{el.code} <small>#{el.name}</small>"  
      ajax: 
        url: opts.url
        dataType: 'json'
        data: (q, p) -> 
          q: q
        results: (d, p) ->
          results: _.map d, (el) ->
            {id: el.id, code: el.code, name: el.name}

      initSelection: (el, cb) ->
        cb {id: $(el).val(), code: $(el).attr('data-code'), name: $(el).attr 'data-name'}

  initAirlinePickers: ->
    @$("[name='airline']").select2
      allowClear: true
      minimumInputLength: 1
      dropdownCssClass : 'select2-smalldrop'
      escapeMarkup: (m) -> m
      formatResult: (el) -> "#{el.code} <small>#{el.name}</small>"
      formatSelection: (el) -> "#{el.code} <small>#{el.name}</small>" 
      ajax: 
        url: Config.routePrefix + "airlines/search"
        dataType: 'json'
        data: (q, p) -> 
          q: q
        results: (d, p) ->
          results: _.map d, (el) ->
            {id: el.id, code: el.code, name: el.name}

      initSelection: (el, cb) ->
        cb {id: $(el).val(), code: $(el).attr('data-code'), name: $(el).attr 'data-name'}

  initAirlinePickersSpecial: (opts = {})->
    _.defaults opts,
      selector: "[name='']"
      allowClear: true
    @$(opts.selector).select2
      allowClear: opts.allowClear
      minimumInputLength: 1
      dropdownCssClass : 'select2-smalldrop'
      escapeMarkup: (m) -> m
      formatResult: (el) -> "#{el.code} <small>#{el.name}</small>"
      formatSelection: (el) -> "#{el.code} <small>#{el.name}</small>" 
      ajax: 
        url: Config.routePrefix + "airlines/search"
        dataType: 'json'
        data: (q, p) -> 
          q: q
        results: (d, p) ->
          results: _.map d, (el) ->
            {id: el.id, code: el.code, name: el.name}

      initSelection: (el, cb) ->
        cb {id: $(el).val(), code: $(el).attr('data-code'), name: $(el).attr 'data-name'}