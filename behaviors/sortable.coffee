class Air.Behaviors.Sortable extends Air.BaseBehavior

  onShow: ->
    @$el.sortable
      axis: "y"
      update: @update
#      containment: @$el

  update: (e, ui) =>
    @view.$el.find('li').each @reOrder
    @view.collection.reset @view.collection.models
    @view.collection.sort()
    @collectionSave 'task/order/' + window.data.user.id, @getOrder()

  reOrder: (index, element) =>
    position = element.firstChild.getAttribute('data-id')
    position = parseInt(position)
    @view.collection.get(position).set('order', index)

  getOrder: ->
    @array = []
    @view.collection.models.forEach (model) =>
      @array.push model.id
    window.data.user.taskCategoriesOrder = @array
    @array