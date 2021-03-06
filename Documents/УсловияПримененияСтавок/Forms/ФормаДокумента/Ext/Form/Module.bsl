﻿//&НаКлиенте
//Перем Расположения, Строки, Колонки;

&НаКлиенте
Процедура СхемаУсловияПримененияСтавкиПриИзменении(Элемент)
	
	Объект.ЗначенияСтавок.Очистить();
	НарисоватьСхему();

КонецПроцедуры

&НаКлиенте
Процедура НарисоватьСхему(ОчищатьЗначение=Истина)
		
	//ТабДок = Новый ТабличныйДокумент;
	//Документы.УсловияПримененияСтавок.ЗаполнитьТабДокПоСхеме(Объект.СхемаУсловияПримененияСтавки, ТабДок, Расположения, ,СтрокиКолонки);
	//Строки = СтрокиКолонки.Строки;
	//Колонки = СтрокиКолонки.Колонки;
	//
	//ТД.Очистить();
	//ТД.Вывести(ТабДок);
	
	НарисоватьСхемуНаСервере();
	Если ОчищатьЗначение Тогда
		Объект.ЗначенияСтавок.Очистить();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура НарисоватьСхемуНаСервере()
	Перем СтрокиКолонки;
	
	ТабДок = Новый ТабличныйДокумент;
	Документы.УсловияПримененияСтавок.ЗаполнитьТабДокПоСхеме(Объект.СхемаУсловияПримененияСтавки, ТабДок, Расположения, ,СтрокиКолонки);
	
	Если СтрокиКолонки <> Неопределено Тогда
		Строки = СтрокиКолонки.Строки;
		Колонки = СтрокиКолонки.Колонки;
	КонецЕсли;
	
	ТД.Очистить();
	ТД.Вывести(ТабДок);

КонецПроцедуры

&НаКлиенте
Процедура ТДОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ТДВыбор(Элемент, Область, СтандартнаяОбработка)
	
	Расположение = ПолучитьРасположение(Область);
	ОбработатьВыбор(Расположение, Область.Имя);  //ОбработатьВыбор(Расположение.Значение, Область.Имя);
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыбор(Расположение, ОбластьИмя)
	
	Если Расположение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ РедактируемоеПоле(Расположение) Тогда
		ФормаВвода = ПолучитьФорму("Документ.УсловияПримененияСтавок.Форма.ФормаВводаЗначения", Новый Структура("ЗначенияПересечения, Строки, Колонки, ОбластьИмя", Расположение.Значение.ЗначенияПересечения, Строки, Колонки, ОбластьИмя),ЭтаФорма);
		ФормаВвода.Открыть();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Функция РедактируемоеПоле(Расположение, Текст="")
	
	Если Расположение = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
			
		
	ЗначенияПересечения = Расположение.Значение.ЗначенияПересечения;
	РазрешитьРедактирование = Истина;
	
	Для Каждого Стр Из ЗначенияПересечения Цикл
		Если ЗначениеРеквизита(Стр,"Владелец") <> Строки И ЗначениеРеквизита(Стр,"Владелец")<> Колонки Тогда
			РазрешитьРедактирование = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат РазрешитьРедактирование;
	
КонецФункции

&НаСервереБезКонтекста
ФУнкция ЗначениеРеквизита(Ссылка, Реквизит)
	Возврат Ссылка[Реквизит];
КонецФУнкции


&НаКлиенте
Функция ПолучитьРасположение(Область)
	
	Колонка = Область.Лево;
	Строка = Область.Верх;
	
	Для Каждого Стр Из Расположения Цикл
		Если Стр.Значение.Колонка = Колонка И Стр.Значение.Строка = Строка Тогда
			Возврат Стр;
		КонецЕсли;
	КонецЦикла;

КонецФункции

&НаКлиенте
Процедура ТДПриИзмененииСодержимогоОбласти(Элемент, Область)
	
	Расположение = ПолучитьРасположение(Область);
	Если НЕ РедактируемоеПоле(Расположение) Тогда
		СформироватьТабличныйДокумент();
		Возврат;
	КонецЕсли;
	ЗаполнитьЗначенияЯчейки(ПредопределенноеЗначение("ПланВидовХарактеристик.ПараметрыПримененияСтавок.ПустаяСсылка"),
	ПредопределенноеЗначение("Справочник.ПараметрыПримененияСтавок_Значения.ПустаяСсылка")
	,Область.Имя, Область.Текст,0);
	
	ОтобразитьОбласть(Область.Имя);
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЗначенияЯчейки(Тип, Параметр, Расположение, Значение, Группа) Экспорт
	
	Отбор = Новый Структура("Тип, Параметр, Расположение, Группа", Тип, Параметр, Расположение, Группа);
	СтрокиТаблицы = Объект.ЗначенияСтавок.НайтиСтроки(Отбор);
	Если СтрокиТаблицы.Количество() = 0  Тогда
		СтрокаТаблицы = Объект.ЗначенияСтавок.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, Отбор);
		СтрокаТаблицы.Ставка = Значение;
	КонецЕсли;
	Для Каждого СтрокаТаблицы Из СтрокиТаблицы Цикл
		СтрокаТаблицы.Ставка = Значение;
	КонецЦикла;
	
	ОтобразитьОбласть(Расположение);
	ЭтаФорма.ТекущийЭлемент = Элементы.ДатаРегистрации;
	ЭтаФорма.ОбновитьОтображениеДанных();
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьОбласть(Имя)
	
	Отбор = Новый Структура("Расположение", Имя);
	СтрокиТаблицы = Объект.ЗначенияСтавок.НайтиСтроки(Отбор);
	Область = ТД.Область(Имя);
	Если СтрокиТаблицы.Количество() = 1 Тогда
		Область.Текст = СтрокиТаблицы[0].Ставка;
	ИначеЕсли СтрокиТаблицы.Количество()>1 Тогда
		Область.Текст = "";
		Для Каждого Стр Из СтрокиТаблицы Цикл
			Область.Текст = Область.Текст +?(Область.Текст = "", ""," / ")+ Стр.Ставка;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьТабличныйДокумент()
	
	НарисоватьСхему(Ложь);
	Если Расположения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Стр Из Объект.ЗначенияСтавок Цикл
		Текст = "";
		
		Область = ТД.Область(Стр.Расположение);
		Расположение = ПолучитьРасположение(Область);
		
		Если РедактируемоеПоле(Расположение, Текст) Тогда
			Область.Текст = Стр.Ставка;
		Иначе
		Отбор = Новый Структура("Расположение", Стр.Расположение);
		СтрокиТаблицы = Объект.ЗначенияСтавок.НайтиСтроки(Отбор);
		Область.Текст = "";
		Для Каждого СтрокаТаблицы Из СтрокиТаблицы Цикл
			Область.Текст = Область.Текст +?(Область.Текст = "", ""," / ")+ СтрокаТаблицы.Ставка;
		КонецЦикла;

		КонецЕсли;
		Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Право;
	КонецЦикла;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СформироватьТабличныйДокумент();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьЗначенияСтавок(ЗначенияСтавок)
	
	Объект.ЗначенияСтавок.Загрузить(ЗначенияСтавок);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ЗаписьСхемыУсловийСтавки" И Источник = Объект.СхемаУсловияПримененияСтавки Тогда
		НарисоватьСхему(Истина);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если Параметры.Свойство("ВидОперации") Тогда
		Объект.ВидОперации = Параметры.ВидОперации;	
	КонецЕсли;

	Если Параметры.Свойство("Дата") Тогда
		Объект.ДатаРегистрации = Параметры.Дата;
		Объект.Дата = ТекущаяДата();
	ИначеЕсли  НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Дата = ТекущаяДата();
		Объект.ДатаРегистрации = Объект.Дата;
	КонецЕсли;

	Если Параметры.Свойство("Схема") Тогда
		Объект.СхемаУсловияПримененияСтавки = Параметры.Схема;
		Объект.Программа = Объект.СхемаУсловияПримененияСтавки.Владелец;
		Объект.Банк = Объект.Программа.Владелец;
	КонецЕсли;
	
	
	ОбновитьСхему();
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЗначенияСтавок = Объект.ЗначенияСтавок.Выгрузить();
		Документы.УсловияПримененияСтавок.ОтобразитьЗначенияВТабДоке(Объект.СхемаУсловияПримененияСтавки, ТД, Расположения,Объект.ДатаРегистрации, ЗначенияСтавок);
		ЗагрузитьЗначенияСтавок(ЗначенияСтавок);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСхему(ЭтоЗаполнение=Ложь) Экспорт
	
	Отборы.Настройки.Отбор.Элементы.Очистить();

	СКД = Документы.УсловияПримененияСтавок.СоздатьСхемуКомпоновки();
	
	АдресСхемыКомпоновкиДоступнныеПоля = ПоместитьВоВременноеХранилище(СКД, ЭтаФорма.УникальныйИдентификатор);
	
	ИсточникНастроекДоступнныеПоля = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДоступнныеПоля);
	Отборы.Инициализировать(ИсточникНастроекДоступнныеПоля);
	НастройкиКомпоновкиДанных = Неопределено;
	
	Если Не Объект.Ссылка.Пустая() Тогда
		
		НастройкиКомпоновкиДанных = ПолучитьНастройкиКомпоновкиДанных(Объект.Ссылка);
	Иначе
		Если Параметры.Свойство(Параметры.ЗначениеКопирования) И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			НастройкиКомпоновкиДанных = ПолучитьНастройкиКомпоновкиДанных(Параметры.ЗначениеКопирования);			
		ИначеЕсли ЭтоЗаполнение Тогда
			Сообщить("Сначала нужно записать документ!");
		КонецЕсли;
	КонецЕсли;	
	
	Если НЕ НастройкиКомпоновкиДанных = Неопределено Тогда
		Отборы.ЗагрузитьНастройки(НастройкиКомпоновкиДанных);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьНастройкиКомпоновкиДанных(Условие)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Отборы.ХранилищеНастроекКомпоновкиДанных
	|ИЗ
	|	Документ.УсловияПримененияСтавок КАК Отборы
	|ГДЕ
	|	Отборы.Ссылка = &Условие";
	
	Запрос.УстановитьПараметр("Условие", Условие);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ХранилищеНастроекКомпоновкиДанных.Получить();
	КонецЕсли;  	
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Процедура ОтборыНастройкиОтборПередНачаломИзменения(Элемент, Отказ)

КонецПроцедуры

&НаСервере
Процедура УстановитьПВ(Владелец, Элемент)
	
КонецПроцедуры


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("УсловияПримененияСтавокИзменение",Объект.СхемаУсловияПримененияСтавки);
	СформироватьТабличныйДокумент();
КонецПроцедуры

