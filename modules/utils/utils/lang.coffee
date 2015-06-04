@Air.module 'Utils.Lang', (Lang, App, Backbone, Marionette, $, _) ->

  API =
    get: (name) ->
      translations[App.lang][name]

  translations =
    ru:
      'nav:users:admin:title' : 'Пользователи'


      'offers:send:success'             : 'Предложения успешно отправлены'
      'offers:send:error:notselected'   : 'Не выбрано ни одного предложения'
      'offers:send:error:validation'    : 'Ошибка валидации'
      'offers:send:error:notsaved'      : 'Есть несохраненные предложения'
      'offers:send:error:emptycodes'    : 'Отсутствует код резервации'
      'offer:select:not:saved'          : 'Нельзя выбрать несохраненное предложение'
      'offer:select:not:saved:multi'    : 'Среди предложений есть несохраненные'
      'offer:add:success'               : 'Предложение успешно добавлено'
      'offer:remove:question'           : 'Удалить предложение №'
      'lid:footer:nobooking'                  : 'Нет активного заказа'

      'sale:create:prompt:noselected'         : 'Не выбрано ни одного предложения. Создать продажу без предложения?'
      'sale:create:error:morethanoneselected' : 'Выберите либо одно предложение, либо ни одного'
      'sale:create:error:notsent'             : 'Данное предложение не было отправлено клиенту'
      'sale:create:error:hotlink'             : 'Чтобы создать продажу, воспользуетесь интерфейсом лида'
      'sale:delete:prompt:text'               : 'Введите причину удаления (максимум 255 символов)'
      'sale:delete:prompt:title'              : 'Удаление продажи'
      'sale:delete:request:sent'              : 'Запрос на удаление уже отправлен'
      'sale:delete:confirm:withoutrequest'    : 'Точно удалить продажу?'
      'sale:delete:confirm:withrequest'       : '<blockquote><p>{%2}</p><small>{%1}, {%3}</small></blockquote>Подтверждаете удаление?'
      'sale:delete:wait:confirm'              : 'Запрос отправлен администратору'
      'sale:send:noemails'                    : 'Выберите хотя бы один имейл'
      'sale:send:no:emails'                   : 'Добавьте в лида хотя бы один имейл'
      'sale:send:error'                       : 'Не удалось отправить продажу. Проверьте введеные данные.'
      'sale:delete:success'                   : 'Продажа успешно удалена'
      'sale:flight:delete:success'            : 'Полет успешно удалён'
      'passengers:confirm:error'              : 'Ошибка, не удалось подтвердить данные'
      'passengers:confirm:success'            : 'Данные успешно сохранены'

      'userediterror'                         : 'Нельзя редактировать чужой профиль'
      'usersavesuccess'                       : 'Данные сохранены'
      'userdeletesuccess'                     : 'Данные удалены'
      'usersaveerror'                         : 'Ошибка валидации данных'
      'usersaveerror2'                        : 'Пользователь с таким почтовым адресом уже существует'
      'user:statistic:format:error'           : 'Пожалуйста, вводите только числа'

      'subscriber:save:success'               : 'Подписчик успешно добавлен'
      'subscriber:save:error'                 : 'Ошибка валидации данных'
      'subscriber:save:error2'                : 'Подписчик с такие почтовым адресом уже существует'
      'subscribers:delete:confirm'            : 'Точно удалить подписчика?'
      'subscribers:remove:success'            : 'Подписчик успешно удален'

      'booking:delete:error:hassale'          : 'У заказа есть продажи'

      'settings:delete:confirm'               : 'Точно удалить данную настройку?'
      'settings:delete:system'                : 'Нельзя удалить системную настройку'
      'settings:remove:success'               : 'Настройка удалена'
      'setting:save:error'                    : 'Настройка не была сохранена'
      'setting:save:success'                  : 'Настройка успешно сохранена'
      'setting:title:edit'                    : 'Редактирование настройки #{%1}'
      'setting:title:add'                     : 'Добавление настройки'
      'country:title:add'                     : 'Добавить страну'
      'country:title:edit'                    : 'Изменить страну'

      'booking:delete:confirm'                  : 'Точно удалить заказ #{%1}?'
      'lid:delete:confirm'                    : 'Точно удалить лид #{%1}?'
      'lid:delete:success'                    : 'Лид успешно удалён'
      'offerFlight:delete:confirm'            : 'Точно удалить полет #{%1}?'
      'booking:view:errorid'                  : 'Неверный номер заказа'
      'user:delete:confirm'                   : 'Точно удалить пользователя #{%1}?'
      'nothing:changed'                       : 'Ничего не изменилось'
      'offers:send:error:noemails'            : 'Выберите хотя бы один имейл'

      'landing:direction:delete'              : 'Направление удалено'
      'landing:direction:delete:confirm'      : 'Точно удалить  направление?'
      'landing:direction:delete:success'      : 'Направление удалено'
      'landing:direction:edit:success'        : 'Направление успешно изменено'
      'landing:direction:save:success'        : 'Направление успешно сохранено'
      'landing:item:delete:success'            : 'Посадочная страница удалена'

      'landing:title:add'                     : 'Добавить  посадочную страницу'
      'landing:delete:confirm'                : 'Точно удалить посадочную страницу?'
      'main:slider:delete:confirm'            : 'Точно удалить слайд (изображение)?'
      'main:testimonial:delete:confirm'       : 'Точно удалить отзыв?'
      'slider:delete:success'                 : 'Слайд (изображение) удалён'


      'location:title:add'                    : 'Добавить локацию'
      'location:save:success'                 : 'Локация успешно добавлена'
      'locations:delete:confirm'              : 'Точно удалить локацию?'
      'locations:remove:success'              : 'Локация успешно удалена'
      'location:save:error'                   : 'Не удалось сохранить локацию. Проверьте введеные данные.'

      'airplaneType:title:add'                : 'Добавить тип самолета'
      'airplaneType:title:edit'               : 'Изменить тип самолета'
      'airplaneType:save:success'             : 'Тип самолета успешно сохранен'
      'airplaneTypes:delete:confirm'          : 'Точно удалить тип самолета?'
      'airplaneTypes:remove:success'          : 'Тип самолета успешно удален'
      'airplaneType:save:error'               : 'Не удалось сохранить тип самолета. Проверьте введеные данные.'

      'consolidator:title:add'                : 'Добавить консолидатор'
      'consolidator:save:success'             : 'Консолидатор успешно сохранен'
      'consolidator:title:edit'               : 'Изменить  консолидатор'
      'consolidators:delete:confirm'          : 'Точно удалить консолидатор?'
      'consolidators:remove:success'          : 'Консолидатор успешно удален'

      'foodType:title:add'                    : 'Добавить тип питания'
      'foodType:title:edit'                   : 'Изменить тип питания'
      'foodType:save:success'                 : 'Тип питания успешно сохранен'
      'foodTypes:delete:confirm'              : 'Точно удалить тип питания?'
      'foodTypes:remove:success'              : 'Тип питания успешно удален'

      'offerComment:title:add'                : 'Добавить комментарий'
      'offerComment:title:edit'               : 'Изменить комментарий'
      'offerComment:save:success'             : 'Комментарий успешно сохранен'
      'offerComment:save:error'               : 'Ошибка валидации данных'
      'offerComments:delete:confirm'          : 'Точно удалить комментарий?'
      'offerComments:remove:success'          : 'Комментарий успешно удален'

      'offerLabel:title:add'                  : 'Добавить ярлык'
      'offerLabel:save:success'               : 'Ярлык успешно добавлен'
      'offerLabel:save:error'                 : 'Ошибка валидации данных'
      'offerLabel:title:edit'                 : 'Изменить ярлык'
      'offerLabels:delete:confirm'            : 'Точно удалить ярлык?'
      'offerLabels:remove:success'            : 'Ярлык успешно удален'

      'user:remove:success'                   : 'Пользователь успешно удалён'

      'role:no:access'                        : 'Недостаточно прав для доступа к данной странице'
      'location:title:edit'                   : 'Редактирование локации'

      'client:view:title'                     : 'Посетитель'
      'clients:delete:confirm'                : 'Точно удалить посетителя?'
      'clients:remove:success'                : 'Посетитель успешно удален'

      'country:save:success'                  : 'Страна успешно сохранена'
      'country:save:error'                    : 'Ошибка валидации данных'
      'countrys:delete:confirm'               : 'Точно удалить страну?'
      'countrys:remove:success'               : 'Страна успешно удалена'

      'cityCode:save:success'                 : 'Город успешно сохранен'
      'cityCode:delete:confirm'               : 'Точно удалить город?'
      'cityCode:remove:success'               : 'Город успешно удален'
      'cityCode:title:add'                    : 'Добавить город'
      'cityCode:title:edit'                   : 'Изменить город'

      'referal:save:success'                  : 'Реферал успешно сохранен'
      'referal:delete:confirm'                : 'Точно удалить реферал?'
      'referal:remove:success'                : 'Реферал успешно удален'
      'referal:title:add'                     : 'Добавить реферал'
      'referal:title:edit'                    : 'Изменить реферал'

      'phone:save:success'                    : 'Телефон успешно сохранен'
      'phone:delete:confirm'                  : 'Точно удалить телефон?'
      'phone:remove:success'                  : 'Телефон успешно удален'
      'phone:title:add'                       : 'Добавить телефон'
      'phone:title:edit'                      : 'Изменить телефон'

      'locale_ru'                             : 'rus'
      'locale_en'                             : 'eng'

      'testimonial:title:add'                 : 'Добавление отзыва'
      'testimonial:title:edit'                : 'Редактирование отзыва'
      'testimonial:save:success'              : 'Отзыв успешно добавлен'
      'testimonial:update:success'            : 'Отзыв успешно изменен'
      'testimonial:delete:success'            : 'Отзыв удалён'
      'slider:save:success'                   : 'Изображение (слайд) успешно добавлен'
      'data:save:success'                     : 'Данные сохранены'

      'monitoring:category:delete:confirm'    : 'Удалить категорию?'
      'monitoring:subcategory:delete:confirm' : 'Удалить субкатегорию?'
      'booking:add:offer:no:sale'             : 'Пожалуйста, укажите минимум одну реальную цену.'
      'booking:add:offer:no:net'              : 'Пожалуйста, укажите минимум одну цену для продажи.'
      'booking:add:offer:no:code'             : 'Пожалуйста, введите код'
      'booking:add:offer:wrong:price'         : 'Пожалуйста, введите корректную цену'

      'fine:title:add'                        : 'Добавление штрафа'
      'fine:title:edit'                       : 'Редактирование штрафа #{%1}?'
      'fine:save:error'                       : 'Ошибка валидации данных'
      'fine:save:success'                     : 'Штраф успешно сохранен'
      'fine:delete:confirm'                   : 'Точно удалить штраф #{%1}?'
      'fine:delete:success'                   : 'Штраф успешно удалён'

      'fine:reason:delete:confirm'            : 'Удалить нарушение #{%1}?'
      'fine:reason:delete:success'            : 'Нарушение успешно удалено'
      'fine:reason:edit'                      : 'Редактирование нарушения #{%1}'
      'fine:reason:add'                       : 'Добавление нарушения'

      'fine:status:delete:confirm'            : 'Удалить статус #{%1}?'
      'fine:status:delete:success'            : 'Статус успешно удален'
      'fine:status:edit'                      : 'Редактирование статуса #{%1}'
      'fine:status:add'                       : 'Добавление статуса'

      'team:delete:confirm'                   : 'Точно удалить данную запись?'
      'team:remove:success'                   : 'Запись удалена'
      'team:save:error'                       : 'Ошибка валидации данных'
      'team:save:success'                     : 'Запись успешно сохранена'
      'team:title:edit'                       : 'Редактирование записи #{%1}'
      'team:title:add'                        : 'Добавление записи'

      'watcher:save:success'                  : 'Успешно сохраненно.'
      'watcher:save:error'                    : 'Ошибка валидации данных'

      'scheme:delete'        : 'Удалить схему?'


      ### Tasks and Preferences ###
      'task:done:success': 'Задача успешно выполнена'
      'task:save:success': 'Задание успешно сохранено'
      'task:save:error'  : 'Ошибка валидации'
      'task:comment:save:success': 'Комментарий успешно отправлен'
      'task:tag:delete:confirmation': 'Удалить категорию #{%1}?'
      'task:tag:delete:success': 'Категория успешно удаленна!'

      ### Basic ###
      'validation:error' : 'Ошибка валидации'
      'save:success' : 'Данные успешно сохранены'
      'save:error': 'При сохранение данных произошла ощибка'
      'delete:confirm': 'Удалить елемент?'
      'delete:success': 'Данные успешно удаленны'

      'progress:delete:confirm': 'Точно удалить достижение?'

      'lid:email:exist': 'Email существует'
      'lid:email:not:exist': 'Email не существует'


  App.reqres.setHandler 'lang:get', (name, modifiers) ->
    t = API.get(name) or name

    if modifiers
      for i in [0..modifiers.length]
        t = t.replace "{%#{i+1}}", modifiers[i]

    t
