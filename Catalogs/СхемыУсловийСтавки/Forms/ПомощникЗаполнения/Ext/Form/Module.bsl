﻿
&НаКлиенте
Процедура ФакторыФакторОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда
	ЭтоПервый = Истина;
	Для Каждого Стр Из ВыбранноеЗначение Цикл
		Если Стр.ЭтоГруппа Тогда 
			Продолжить;
		КонецЕсли;
		НовФактор  = ?(ЭтоПервый,Элементы.Факторы.ТекущиеДанные.Фактор, Факторы.Добавить());
		НовФактор.Значение = Стр;
		НовФактор.Фактор = Стр.Владелец;
	КонецЦикла;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	Массив = Новый Массив;
	
	Для Каждого Стр Из ВладелецФормы.СхемаУсловий.Настройки.Отбор.ДоступныеПоляОтбора.Элементы Цикл
		Для Каждого Эл Из Стр.Элементы Цикл
			ПараметрыОтбора = Новый Структура("Фактор, Значение, Заголовок");
			ПараметрыОтбора.Фактор = Стр.Заголовок; 
			ПараметрыОтбора.Значение = Эл.Поле;
			ПараметрыОтбора.Заголовок = Эл.Заголовок;
			Массив.Добавить(ПараметрыОтбора);
		КонецЦикла;
	КонецЦикла;
	ФормаПодбора = ПолучитьФорму("Справочник.ПараметрыПримененияСтавок_Значения.ФормаВыбора",Новый Структура("ПараметрыВыбора", Массив),Элементы.Факторы);
	ФормаПодбора.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура ФакторыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Для Каждого Стр Из ВыбранноеЗначение Цикл
		Если ВернутьЗначениеРеквизита(Стр, "ЭтоГруппа") Тогда 
			Продолжить;
		КонецЕсли;
		НовФактор  = Факторы.Добавить();
		НовФактор.Значение = Стр;
		НовФактор.Фактор = ВернутьЗначениеРеквизита(Стр, "Владелец");
		НовФактор.Сортировка = ВернутьЗначениеРеквизита(Стр, "Сортировка");
	КонецЦикла;
	Факторы.Сортировать("Сортировка Возр");

КонецПроцедуры

&НаСервереБезКонтекста
Функция ВернутьЗначениеРеквизита(Ссылка, Реквизит)
	Возврат Ссылка[Реквизит]
КонецФункции

&НаКлиенте
Процедура Сформировать(Команда)
	Если НЕ ЗначениеЗаполнено(ВладелецФормы.Объект.Ссылка) Тогда
		Сообщить("Сначала нужно записать схему!");
		Возврат;
	КонецЕсли;
	Соответствие = Новый Соответствие;
	

	Для Каждого Стр Из Факторы Цикл
		Массив = Соответствие.Получить(Стр.Фактор);
		Если Массив = Неопределено Тогда
			Массив = Новый Массив;
		КонецЕсли;
		СтруктураВозврата = Новый Структура("Фактор, Значение");
		ЗаполнитьЗначенияСвойств(СтруктураВозврата, Стр);
		Массив.Добавить(СтруктураВозврата);
		Соответствие.Вставить(Стр.Фактор, Массив);
	КонецЦикла;
	
	ВладелецФормы.ОбновитьСхему(Истина);
	ВладелецФормы.ОбработкаВыбораПараметров(Соответствие);
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ФакторыЗначениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ВыбранноеЗначение.Количество() = 1 Тогда
		Элементы.Факторы.ТекущиеДанные.Значение = ВыбранноеЗначение[0];
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Для Каждого Стр Из Параметры.ВсеИспользуемыеЗначения Цикл
		НовСтр = Факторы.Добавить();
		НовСтр.Фактор = Стр.Владелец;
		НовСтр.Значение = Стр;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	Факторы.Очистить();
КонецПроцедуры
