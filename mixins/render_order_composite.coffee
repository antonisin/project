@mixins.render_order_composite =

  initialize: ->
    if @renderOrder is 'DESC'
      @appendHtml = (compositeView, itemView) ->
        if compositeView.isBuffering
          compositeView.elBuffer.insertBefore itemView.el, compositeView.elBuffer.firstChild
        else
          container = @getItemViewContainer compositeView
          container.prepend itemView.el

      @appendBuffer = (compositeView, buffer) ->
        container = @getItemViewContainer compositeView
        container.append buffer
