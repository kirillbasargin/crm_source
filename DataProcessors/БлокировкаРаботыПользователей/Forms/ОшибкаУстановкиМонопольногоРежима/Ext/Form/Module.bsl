﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УдалениеПомеченныхОбъектов = Параметры.УдалениеПомеченныхОбъектов;
	Если УдалениеПомеченныхОбъектов Тогда
		Заголовок = НСтр("ru = 'Не удалось выполнить удаление помеченных объектов'");
		Элементы.ТекстСообщенияОбОшибке.Заголовок = НСтр("ru = 'Невозможно выполнить удаление помеченных объектов, т.к. в программе работают другие пользователи:'");
	КонецЕсли;
	
	АктивныеПользователиШаблон = НСтр("ru = 'Активные пользователи (%1)'");
	
	КоличествоАктивныхСеансов = КоличестваАктивныхСеансовНаСервере();
	Элементы.АктивныеПользователи.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(АктивныеПользователиШаблон, КоличествоАктивныхСеансов);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если КоличествоАктивныхСеансов = 0 Тогда
		Отказ = Истина;
		ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗакрытии, Ложь);
	Иначе
		Если Параметры.УдалениеПомеченныхОбъектов Тогда
			СоединенияИБКлиент.УстановитьПризнакЗавершитьВсеСеансыКромеТекущего(Истина);
		КонецЕсли;
		ПодключитьОбработчикОжидания("ОбновитьКоличествоАктивныхСеансов", 30);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если Параметры.УдалениеПомеченныхОбъектов Тогда
		СоединенияИБКлиент.УстановитьПризнакЗавершитьВсеСеансыКромеТекущего(Ложь);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура АктивныеПользователиНажатие(Элемент)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьСписокАктивныхПользователейЗавершение", ЭтотОбъект);
	ОткрытьФорму("Обработка.АктивныеПользователи.Форма.АктивныеПользователи", , , , , ,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура АктивныеПользователи2Нажатие(Элемент)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьСписокАктивныхПользователейЗавершение", ЭтотОбъект);
	ОткрытьФорму("Обработка.АктивныеПользователи.Форма.АктивныеПользователи" , , , , , ,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьСеансыИПерезапуститьПрограмму(Команда)
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.Страница2;
	ТекущаяСтраницаПомощника = "Страница2";
	Элементы.ФормаПовторитьЗапускПрограммы.Видимость = Ложь;
	Элементы.ФормаЗавершитьСеансыИПерезапуститьПрограмму.Видимость = Ложь;
	
	// Задание параметров блокировки ИБ.
	ОбновитьКоличествоАктивныхСеансов();
	УстановитьБлокировкуФайловойБазы();
	СоединенияИБКлиент.УстановитьОбработчикиОжиданияЗавершенияРаботыПользователей(Истина);
	ПодключитьОбработчикОжидания("ТаймАутЗавершенияРаботыПользователей", 60);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьЗапускПрограммы(Команда)
	
	ОтменитьБлокировкуФайловойБазы();
	
	Закрыть(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПовторитьЗапускПрограммы(Команда)
	
	Закрыть(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьСписокАктивныхПользователейЗавершение(Результат, ДополнительныеПараметры) Экспорт
	ОбновитьКоличествоАктивныхСеансов();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКоличествоАктивныхСеансов()
	
	Если ТекущаяСтраницаПомощника = "Страница2" Тогда
		АктивныеПользователи = "АктивныеПользователи2";
	Иначе
		АктивныеПользователи = "АктивныеПользователи";
	КонецЕсли;
	
	Результат = КоличестваАктивныхСеансовНаСервере();
	Если Результат = 0 Тогда
		Закрыть(Ложь);
	Иначе
		Элементы[АктивныеПользователи].Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(АктивныеПользователиШаблон, Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция КоличестваАктивныхСеансовНаСервере()
	
	СеансыИнформационнойБазы = ПолучитьСеансыИнформационнойБазы();
	
	НомерСеансаТекущегоПользователя = НомерСеансаИнформационнойБазы();
	КоличествоСеансовПрепятствующихПродолжению = 0;
	Для Каждого СеансИБ Из СеансыИнформационнойБазы Цикл
		
		Если СеансИБ.ИмяПриложения = "Designer"
			Или СеансИБ.НомерСеанса = НомерСеансаТекущегоПользователя Тогда
			Продолжить;
		КонецЕсли;
		
		КоличествоСеансовПрепятствующихПродолжению = КоличествоСеансовПрепятствующихПродолжению + 1;
	КонецЦикла;
	
	Возврат КоличествоСеансовПрепятствующихПродолжению;
	
КонецФункции

&НаКлиенте
Процедура ТаймАутЗавершенияРаботыПользователей()
	
	ПродолжительностьЗавершенияРаботыПользователей = ПродолжительностьЗавершенияРаботыПользователей + 1;
	
	Если ПродолжительностьЗавершенияРаботыПользователей >= 3 Тогда
		ОтменитьБлокировкуФайловойБазы();
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.Страница1;
		ТекущаяСтраницаПомощника = "Страница1";
		Элементы.ТекстСообщенияОбОшибке.Заголовок = НСтр("ru = 'Невозможно выполнить обновление версии программы, т.к. не удалось завершить работу пользователей:'");
		Элементы.ФормаПовторитьЗапускПрограммы.Видимость = Истина;
		Элементы.ФормаЗавершитьСеансыИПерезапуститьПрограмму.Видимость = Истина;
		ОтключитьОбработчикОжидания("ТаймАутЗавершенияРаботыПользователей");
		ПродолжительностьЗавершенияРаботыПользователей = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьБлокировкуФайловойБазы()
	
	Объект.ЗапретитьРаботуПользователей = Истина;
	Если УдалениеПомеченныхОбъектов Тогда
		Объект.НачалоДействияБлокировки = ТекущаяДатаСеанса() + 2*60;
		Объект.ОкончаниеДействияБлокировки = Объект.НачалоДействияБлокировки + 60;
		Объект.СообщениеДляПользователей = НСтр("ru = 'Программа заблокирована для удаления помеченных объектов.'");
	Иначе
		Объект.НачалоДействияБлокировки = ТекущаяДатаСеанса() + 2*60;
		Объект.ОкончаниеДействияБлокировки = Объект.НачалоДействияБлокировки + 5*60;
		Объект.СообщениеДляПользователей = НСтр("ru = 'Программа заблокирована для выполнения обновления.'");
	КонецЕсли;
	
	Попытка
		РеквизитФормыВЗначение("Объект").ВыполнитьУстановку();
	Исключение
		ЗаписьЖурналаРегистрации(СоединенияИБКлиентСервер.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,,, 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьБлокировкуФайловойБазы()
	
	РеквизитФормыВЗначение("Объект").ОтменитьБлокировку();
	
КонецПроцедуры

#КонецОбласти
