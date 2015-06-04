@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.AdminMenuItem extends Entities.BaseModel

    choose: ->
      _.invoke @collection.models, 'unchoose'
      @set 'chosen', true

    unchoose: ->
      @set 'chosen', false

  class Entities.AdminMenuCollection extends Entities.BaseCollection
    model: Entities.AdminMenuItem

  API =
    getAdminMenuItems: ->
      new Entities.AdminMenuCollection [
        {name: 'Общее'       , type: 'separator'}
        {name: 'Пользователи', icon: 'user' , url: 'users'    }
        {name: 'Команды'     , icon: 'sitemap', url: 'teams' }
        {name: 'Лиды'        , icon: 'group', url: 'lids'     }
        {name: 'Настройки'   , icon: 'gears', url: 'settings' }
        {name: 'Достижения'  , icon: 'flag-checkered', url: 'progress' }

        {name: 'Бухгалтерия' , type: 'separator'}
        {name: 'Нарушения'   , icon: 'user', url: 'reasons'}
        {name: 'Статусы'     , icon: 'user', url: 'status'}

        {name: 'Посадочные страницы', type: 'separator'}
        {name: 'Посадочные страницы', icon: 'gears'  , url: 'landings' }
        {name: 'Направления'        , icon: 'gears'  , url: 'landingDirections' }

        {name: 'Публичная часть' , type: 'separator'}
        {name: 'Посетители'      , icon: 'group'   , url: 'clients'  }
        {name: 'Главная страница', icon: 'home'   , url: 'main' }
        {name: 'Подписчики'      , icon: 'pencil-square-o'   , url: 'subscribers' }

        {name: 'Справочники'   , type: 'separator'}
        {name: 'Локации'       , icon: 'map-marker' , url: 'locations' }
        {name: 'Типы самолетов', icon: 'plane'  , url: 'airplaneTypes' }
        {name: 'Консолидаторы' , icon: 'adjust' , url: 'consolidators' }
        {name: 'Страны'        , icon: 'flag'   , url: 'countries' }
        {name: 'Типы питания'  , icon: 'cutlery', url: 'foodTypes' }

        {name: 'Предложения', type: 'separator'}
        {name: 'Комментарии', icon: 'comment' , url: 'offerComments' }
        {name: 'Ярлыки'     , icon: 'bookmark', url: 'offerLabels' }

        {name: 'Номера'           , type: 'separator'}
        {name: 'Рефералы'         , icon: 'rocket', url: 'referal' }
        {name: 'Города'           , icon: 'crosshairs', url: 'cityCode' }
        {name: 'Телефоные номера' , icon: 'phone', url: 'phone' }

        {name: 'Мониторинг', type: 'separator'}
        {name: 'Категории' , icon: 'bookmark', url: 'monitoring/categories' }
#content#
      ]

  App.reqres.setHandler 'admin:menu:entities', API.getAdminMenuItems
