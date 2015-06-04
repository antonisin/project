@mixins.ui_init = 
  
  updateUI: (opts = {})->
  	_.defaults opts, 
  		tooltip: _.defaults opts.tooltip or {}, 
  			container: 'body'

    App.initUniform @$("input[type=checkbox]:not(.toggle, .make-switch), input[type=radio]:not(.toggle, .star, .make-switch)")
    @$el.find('.ttp').tooltip opts.tooltip 
    @$("[data-filter-type]").inputFilter()

  updateUniform: ->
    $.uniform.update @$("input[type=checkbox]:not(.toggle, .make-switch), input[type=radio]:not(.toggle, .star, .make-switch)")
