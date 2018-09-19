﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Объект.АвторФайлов) Тогда
		ВКачествеАвтораФайлов = "Пользователь";
		Элементы.АвторФайлов.Доступность = Истина;
	Иначе
		ВКачествеАвтораФайлов = "ПланОбмена";
		Элементы.АвторФайлов.Доступность = Ложь;
	КонецЕсли;
	
	Если Не ПустаяСтрока(Объект.Сервис) Тогда
		Если Объект.Сервис = "https://webdav.yandex.ru" Тогда
			СервисПредставление = "Яндекс.Диск"
		ИначеЕсли Объект.Сервис = "https://webdav.4shared.com" Тогда
			СервисПредставление = "4shared.com"
		ИначеЕсли Объект.Сервис = "https://dav.box.com/dav" Тогда
			СервисПредставление = "Box"
		ИначеЕсли Объект.Сервис = "https://dav.dropdav.com" Тогда
			СервисПредставление = "Dropbox"
		КонецЕсли;
	КонецЕсли;
	
	Если Не ПустаяСтрока(Объект.Наименование) Тогда
		Элементы.ВКачествеАвтораФайлов.СписокВыбора[0].Представление =
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Элементы.ВКачествеАвтораФайлов.Заголовок, "(" + Объект.Наименование + ")");
	КонецЕсли;
	
	// Обработчик подсистемы запрета редактирования реквизитов объектов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов") Тогда
		МодульЗапретРедактированияРеквизитовОбъектов = ОбщегоНазначения.ОбщийМодуль("ЗапретРедактированияРеквизитовОбъектов");
    	МодульЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не Отказ Тогда
		УстановитьПривилегированныйРежим(Истина);
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ТекущийОбъект.Ссылка, Логин, "Логин");
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ТекущийОбъект.Ссылка, Пароль);
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УстановитьПривилегированныйРежим(Истина);
	Логин = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(ТекущийОбъект.Ссылка,"Логин");
	Пароль = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(ТекущийОбъект.Ссылка);
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура СервисПредставлениеПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	Если СервисПредставление = "Яндекс.Диск" Тогда
		Объект.Сервис = "https://webdav.yandex.ru"
	ИначеЕсли СервисПредставление = "4shared.com" Тогда
		Объект.Сервис = "https://webdav.4shared.com"
	ИначеЕсли СервисПредставление = "Box" Тогда
		Объект.Сервис = "https://dav.box.com/dav"
	ИначеЕсли СервисПредставление = "Dropbox" Тогда
		Объект.Сервис = "https://dav.dropdav.com"
	Иначе
		Объект.Сервис = "";
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВКачествеАвтораФайловПриИзменении(Элемент)
	
	Объект.АвторФайлов = Неопределено;
	Элементы.АвторФайлов.Доступность = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПроверитьНастройки(Команда)
	
	ОчиститьСообщения();
	
	Если Объект.Ссылка.Пустая() Или Модифицированность Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьНастройкиЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Для проверки настроек необходимо записать данные учетной записи. Продолжить?'");
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить("Продолжить", НСтр("ru = 'Продолжить'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
	Иначе
		ПроверитьВозможностьСинхронизацииСОблачнымСервисом();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	МодульЗапретРедактированияРеквизитовОбъектовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ЗапретРедактированияРеквизитовОбъектовКлиент");
	МодульЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПроверитьНастройкиЗавершение(РезультатДиалога, ДополнительныеПараметры) Экспорт
	
	Если РезультатДиалога <> "Продолжить" Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Записать() Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьВозможностьСинхронизацииСОблачнымСервисом();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВозможностьСинхронизацииСОблачнымСервисом()
	
	СообщениеОбОшибке = "";
	СтруктураРезультата = Неопределено;
	
	ВыполнитьПроверкуПодключения(Объект.Ссылка, СтруктураРезультата);
	
	РезультатПротокол = СтруктураРезультата.РезультатПротокол;
	РезультатТекст = СтруктураРезультата.РезультатТекст;
	
	Если СтруктураРезультата.Отказ Тогда
		ПоказатьПредупреждение(Неопределено, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Проверка параметров учетной записи завершилась с ошибками.
					   |Проверьте правильность задания корневой папки, логина и пароля.
					   |
					   |Технические подробности:
					   |
					   |%1'"),
					   СтроковыеФункцииКлиентСервер.ИзвлечьТекстИзHTML(РезультатПротокол)),,
			НСтр("ru = 'Проверка учетной записи'"));
	Иначе
		ПоказатьПредупреждение(Неопределено, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Проверка параметров учетной записи завершилась успешно. 
					   |%1'"),
			РезультатТекст),,
			НСтр("ru = 'Проверка учетной записи'"));
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПроверкуПодключения(УчетнаяЗапись, СтруктураРезультата)
	РаботаСФайламиСлужебный.ВыполнитьПроверкуПодключения(УчетнаяЗапись, СтруктураРезультата);
КонецПроцедуры

&НаКлиенте
Процедура ВКачествеАвтораФайловПользовательПриИзменении(Элемент)
	
	Элементы.АвторФайлов.Доступность = Истина;
	
КонецПроцедуры

#КонецОбласти