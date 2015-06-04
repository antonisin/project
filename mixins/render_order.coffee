@mixins.render_order =

  initialize: ->
    if @renderOrder is 'DESC'
      @appendHtml = (collectionView, itemView) ->
        if collectionView.isBuffering
          collectionView.elBuffer.insertBefore itemView.el, collectionView.elBuffer.firstChild
        else
          collectionView.$el.prepend itemView.el

      @appendBuffer = (collectionView, buffer) ->
        collectionView.$el.append buffer
