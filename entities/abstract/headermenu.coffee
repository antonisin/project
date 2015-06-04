@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.HeaderMenuItem extends Entities.BaseModel

  class Entities.HeaderMenuCollection extends Entities.BaseCollection
    model: Entities.HeaderMenuItem

  class Entities.HeaderDropdownItem extends Entities.BaseModel

  class Entities.HeaderDropdownCollection  extends Entities.BaseCollection
    model: Entities.HeaderDropdownItem

  API =
    getHeaderMenuItems: ->
      new Entities.HeaderMenuCollection App.request('role:filter', [
        {name: 'Главная'    , icon: 'tachometer', url: 'dashboard'   , role: []        , type: 'default'}
        {name: 'Задачник'   , icon: 'tasks'     , url: 'taskstorage' , role: []        , type: 'default'}
        {name: 'Лиды'       , icon: 'group'     , url: 'lid'         , role: []        , type: 'default'}
        {name: 'Продажи'    , icon: 'money'     , url: 'sale'        , role: []        , type: 'default'}
        {name: 'Настройки'  , icon: 'gears'     , url: 'preferences' , role: []        , type: 'default'}
        {name: 'Админка'    , icon: 'gears'     , url: 'admin'       , role: ['admin'] , type: 'default'}
        {name: 'Мониторинг' , icon: 'table'     , url: 'monitoring'  , role: ['admin'] , type: 'default'}
        {name: 'Бухгалтерия', icon: 'dollar'    , url: 'accounting/invoices', role: ['admin'], type: 'drop-down'}
      ])

    getHeaderDropdownItems: (tasks) ->
      new Entities.HeaderDropdownCollection tasks

  App.reqres.setHandler 'header:menu:entities', API.getHeaderMenuItems
  App.reqres.setHandler 'header:menu:dropdown:items', API.getHeaderDropdownItems