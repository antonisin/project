errorClass = 'has-error'
_.extend Backbone.Validation.callbacks,

  valid: (view, attr, sel) ->
    $input = view.$ "[name='#{attr}']"
    $parent = $input.closest '.form-group'
    if $parent.length > 0
      $parent.removeClass errorClass
    else
      $input.removeClass errorClass

  invalid: (view, attr, error, sel) ->
    $input = view.$ "[name='#{attr}']"
    $parent = $input.closest '.form-group'
    if $parent.length > 0
      $parent.addClass errorClass
    else
      $input.addClass errorClass
