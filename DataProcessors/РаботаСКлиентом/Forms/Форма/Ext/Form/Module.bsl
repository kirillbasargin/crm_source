﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Запросы.Параметры.УстановитьЗначениеПараметра("Клиент", Неопределено);
	
	ОбновитьФормуНаСервере();
	Если Параметры.Свойство("НомерТелефона") И Параметры.Свойство("ID_Звонка") Тогда
		НавСсылка = ?(Параметры.Свойство("НавСсылка"), Параметры.НавСсылка, "");
		Телефония_ID_Звонка = Параметры.ID_Звонка;
		Телефония_НомерТелефона = Параметры.НомерТелефона;
		Клиенты.Параметры.УстановитьЗначениеПараметра("Телефоны", "%" + УправлениеТелефониейКлиентСервер.ОбрезатьНомер(Телефония_НомерТелефона) + "%");
		Элементы.КлиентыОтключитьПоискПоНомеру.Видимость = Истина;
		Элементы.КлиентыОтключитьПоискПоНомеру.Заголовок = Телефония_НомерТелефона;			
		Элементы.ИнфоОЗвонке.Видимость = Истина;
		Элементы.ИнфоОЗвонке.Заголовок = "Обработка вызова: " + Телефония_НомерТелефона + ?(Параметры.Свойство("Дата"), " от " + Параметры.Дата, "");
	ИначеЕсли Параметры.Свойство("ПозиционированиеНаКлиенте") Тогда
		Элементы.Клиенты.ТекущаяСтрока = Параметры.ПозиционированиеНаКлиенте;	
	КонецЕсли;
	
	//++ Юкаев Роман 20180314 (//790375
	Если Пользователи.РолиДоступны("МенеджерИпотечный") Тогда
		Элементы.ГруппаСоздать.Видимость = Ложь;
		Элементы.ЗапросыГруппаСоздать.Видимость = Ложь;
		Элементы.СоздатьРасчетИпотеки.Видимость = Истина;
		ЭтоИпотечныйМенеджер = Истина;
	КонецЕсли;
	//-- Юкаев Роман 20180314 )
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Источник = "ПанельТелефонии" Тогда
		Если ИмяСобытия = "ПереходВРаботуСКлиентом" Тогда			
			ОтключитьПоискПоНомеру(Неопределено);			
			Телефония_ID_Звонка = Параметр.ID_Звонка;
			Телефония_НомерТелефона = Параметр.НомерТелефона;
			Элементы.КлиентыОтключитьПоискПоНомеру.Видимость = Истина;
			Элементы.КлиентыОтключитьПоискПоНомеру.Заголовок = Телефония_НомерТелефона;			
			НавСсылка = ?(Параметры.Свойство("НавСсылка"), Параметр.НавСсылка, "");
			Элементы.ИнфоОЗвонке.Заголовок = "Обработка вызова: " + Телефония_НомерТелефона + ?(Параметр.Свойство("Дата"), " от " + Параметр.Дата, "");			
			Клиенты.Параметры.УстановитьЗначениеПараметра("Телефоны", "%" + УправлениеТелефониейКлиентСервер.ОбрезатьНомер(Телефония_НомерТелефона) + "%");
			Элементы.Клиенты.Обновить();
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "ОбновитьРабочийСтолКлиента" Тогда 
		ОбновитьВзаимодействияНаСервере();
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ЗапросыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
    ПараметрыФормы = Новый Структура("Ключ, Клиент, Телефония_ID_Звонка, Телефония_НомерТелефона", ВыбраннаяСтрока, Элементы.Клиенты.ТекущаяСтрока, Телефония_ID_Звонка, Телефония_НомерТелефона);
	ОткрытьФорму("Документ.Запрос.ФормаОбъекта", ПараметрыФормы);
	
	//ПараметрыФормы = Новый Структура("Ключ, а", ВыбраннаяСтрока, Новый Структура("Клиент, Телефония_ID_Звонка, Телефония_НомерТелефона", Элементы.Клиенты.ТекущаяСтрока, Телефония_ID_Звонка, Телефония_НомерТелефона));
	//ОткрытьФорму("Документ.Запрос.ФормаОбъекта", ПараметрыФормы);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПолеПоискаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)	
	
	//ПолеПоиска = Текст;	
	//ВыполнитьПоиск(Неопределено);	
	
КонецПроцедуры

&НаКлиенте
Процедура РежимПоискаПриИзменении(Элемент)
	
	//ПолеПоиска = "";
	ВыполнитьПоиск(Неопределено);		
	
КонецПроцедуры

&НаКлиенте
Процедура ИнфоОЗвонкеНажатие(Элемент)
	ПерейтиПоНавигационнойСсылке(НавСсылка);
КонецПроцедуры

&НаКлиенте
Процедура ВзаимодействияТабДокОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	СтандартнаяОбработка = Ложь;
	ДокументВзаимодействие = ПолучитьЗначениеРасшифровкиНаСервере(Расшифровка, АдресХранилищаДанныеРасшифровки);
	Если ДокументВзаимодействие <> "" Тогда
		ОткрытьЗначение(ДокументВзаимодействие);	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПолеПоискаПриИзменении(Элемент)
	ВыполнитьПоиск(Неопределено);	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицФормы

&НаКлиенте
Процедура ЛистингПриАктивизацииСтроки(Элемент)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ВзаимодействияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(,Элемент.ТекущиеДанные.Взаимодействие);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КлиентыПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("АктивизацияСтрокиКлиентыЗавершение", 0.1, Истина);
	
	////++ Юкаев Роман 20180129 (
	//АктивизацияСтрокиКлиентыЗавершение();
	////-- Юкаев Роман 20180129 )

КонецПроцедуры

&НаКлиенте
Процедура ЗапросыПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("АктивизацияСтрокиЗапросыЗавершение", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапросыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьЗапрос(Команда)
	
	ПараметрыФормыЗапроса = Новый Структура("Клиент, Телефония_ID_Звонка, Телефония_НомерТелефона", Элементы.Клиенты.ТекущаяСтрока, Телефония_ID_Звонка, Телефония_НомерТелефона);
	ОткрытьФорму("Документ.Запрос.ФормаОбъекта", ПараметрыФормыЗапроса, , Новый УникальныйИдентификатор);
	
	//ПараметрыФормыЗапроса = Новый Структура("ЗначенияЗаполнения", Новый Структура("Клиент, Телефония_ID_Звонка, Телефония_НомерТелефона", Элементы.Клиенты.ТекущаяСтрока, Телефония_ID_Звонка, Телефония_НомерТелефона));
	//ОткрытьФорму("Документ.Запрос.ФормаОбъекта", ПараметрыФормыЗапроса);	
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗапрос_БезКлиента(Команда)
	
	ПараметрыФормыЗапроса = Новый Структура("Телефония_ID_Звонка, Телефония_НомерТелефона", Телефония_ID_Звонка, Телефония_НомерТелефона);
	ОткрытьФорму("Документ.Запрос.ФормаОбъекта", ПараметрыФормыЗапроса, , Новый УникальныйИдентификатор);
	
	//ПараметрыФормыЗапроса = Новый Структура("ЗначенияЗаполнения", Новый Структура("Телефония_ID_Звонка, Телефония_НомерТелефона", Телефония_ID_Звонка, Телефония_НомерТелефона));
	//ОткрытьФорму("Документ.Запрос.ФормаОбъекта", ПараметрыФормыЗапроса);	
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВстречу(Команда)
	
	СоздатьНовоеВзаимодействие("Встреча");
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьТелефонныйЗвонок(Команда)
	
	СоздатьНовоеВзаимодействие("ТелефонныйЗвонок");
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЭлектронноеПисьмо(Команда)
	
	СоздатьНовоеВзаимодействие("ЭлектронноеПисьмоИсходящее");
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСообщениеSMS(Команда)
	
	СоздатьНовоеВзаимодействие("СообщениеSMS");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьПоискПоНомеру(Команда)
	
	//Телефония_ID_Звонка = "";
	//Телефония_НомерТелефона = "";
	Элементы.КлиентыОтключитьПоискПоНомеру.Видимость = Ложь;
	                                                              
	Для каждого Элемент Из Клиенты.Параметры.Элементы Цикл 
		Если Элемент.Параметр = Новый ПараметрКомпоновкиДанных("Телефоны") Тогда
			Элемент.Использование = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;	
	Элементы.Клиенты.Обновить();

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПоиск(Команда)
		
	Если НЕ ПустаяСтрока(ПолеПоиска) Тогда
		Если НЕ РежимПоиска Тогда			
			НомерТелефона = УправлениеТелефониейКлиентСервер.ФорматироватьТелефон(СокрЛП(ПолеПоиска));
			Если СтрДлина(НомерТелефона) = 11 И (Сред(НомерТелефона, 1, 1) = "7" ИЛИ Сред(НомерТелефона, 1, 1) = "8") Тогда
				НомерТелефона = Прав(НомерТелефона, 10);
			КонецЕсли;	
			Клиенты.Параметры.УстановитьЗначениеПараметра("Телефоны", "%" + НомерТелефона + "%"); //УправлениеТелефониейКлиентСервер.ФорматироватьТелефон(СокрЛП(ПолеПоиска))
			Для каждого Элемент Из Клиенты.Параметры.Элементы Цикл 
				Если Элемент.Параметр = Новый ПараметрКомпоновкиДанных("ФИО") Тогда
					Элемент.Использование = Ложь;
				КонецЕсли;
			КонецЦикла;			
		Иначе
			Клиенты.Параметры.УстановитьЗначениеПараметра("ФИО", "%" + СокрЛП(ПолеПоиска) + "%");
			Для каждого Элемент Из Клиенты.Параметры.Элементы Цикл 
				Если Элемент.Параметр = Новый ПараметрКомпоновкиДанных("Телефоны") Тогда
					Элемент.Использование = Ложь;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	Иначе		
		//ОтключитьПоискПоНомеру(Неопределено);
		Для каждого Элемент Из Клиенты.Параметры.Элементы Цикл 
			Если Элемент.Параметр = Новый ПараметрКомпоновкиДанных("ФИО")
				ИЛИ Элемент.Параметр = Новый ПараметрКомпоновкиДанных("Телефоны") Тогда
				Элемент.Использование = Ложь;
			КонецЕсли;
		КонецЦикла;				
	КонецЕсли;	
	Элементы.Клиенты.Обновить();	
	
КонецПроцедуры

&НаКлиенте
Процедура СброситьПоиск(Команда)
	
	ПолеПоиска = "";
	ВыполнитьПоиск(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьФорму(Команда)
	
	//СброситьПоиск(Неопределено);
	ОбновитьФормуНаСервере();
	Элементы.Запросы.Обновить();
	Элементы.Листинг.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьЗапрос(Команда)

	ПараметрыФормы = Новый Структура("ЗначениеКопирования, Клиент, Телефония_ID_Звонка, Телефония_НомерТелефона", Элементы.Запросы.ТекущаяСтрока, Элементы.Клиенты.ТекущаяСтрока, Телефония_ID_Звонка, Телефония_НомерТелефона);
	ОткрытьФорму("Документ.Запрос.ФормаОбъекта", ПараметрыФормы);
	
	//ПараметрыФормы = Новый Структура("ЗначениеКопирования, ЗначенияЗаполнения", Элементы.Запросы.ТекущаяСтрока, Новый Структура("Клиент, Телефония_ID_Звонка, Телефония_НомерТелефона", Элементы.Клиенты.ТекущаяСтрока, Телефония_ID_Звонка, Телефония_НомерТелефона));
	//ОткрытьФорму("Документ.Запрос.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура АктивизацияСтрокиКлиентыЗавершение()

	Если Элементы.Клиенты.ТекущаяСтрока = Неопределено Тогда
		ТекущийКлиент = ПредопределенноеЗначение("Справочник.Клиенты.ПустаяСсылка");
		ТекущийЗапрос = ПредопределенноеЗначение("Документ.Запрос.ПустаяСсылка");
		Запросы.Параметры.УстановитьЗначениеПараметра("Клиент", ТекущийКлиент); 
			
		Возврат;
	КонецЕсли;
	
	ТекущийКлиент = Элементы.Клиенты.ТекущаяСтрока; 
	Запросы.Параметры.УстановитьЗначениеПараметра("Клиент", ТекущийКлиент);	
	//Элементы.Запросы.ТекущаяСтрока = ПолучитьПервуюСтрокуСписка();	
	
	ПодключитьОбработчикОжидания("АктивизацияСтрокиЗапросыЗавершение", 0.1, Истина);
	
	//Чтобы был один серверный вызов
	//ЗаполнитьДанныеПриВыбореКлиентаНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура АктивизацияСтрокиЗапросыЗавершение()
	
	ТекущиаяСтрока = Элементы.Запросы.ТекущаяСтрока;
		
	Если ТекущиаяСтрока = Неопределено Тогда
		//++ Юкаев Роман 20180129 (
		ТекущийЗапрос = ПредопределенноеЗначение("Документ.Запрос.ПустаяСсылка");
		//ТекущийРасчет = ПредопределенноеЗначение("Документ.РасчетИпотеки.ПустаяСсылка");
		ТекущийРасчет = Неопределено;
		//-- Юкаев Роман 20180129 )
		
		ОбновитьФормуНаСервере();
		Бюджет 					= "";
		КоличествоКомнат 		= "";
		Мотивация 				= "";
		Отделка 				= "";
		СтопФакторы 			= "";
		ФакторыВыбора 			= "";
		ФормыОплаты 			= "";
		ЦельПокупки 			= "";
			
		Возврат;
	Иначе
		Если ЭтоИпотечныйМенеджер Тогда
			ЗаполнитьДанныеИпотечник();
		КонецЕсли;
	КонецЕсли;	
	
	ТекущийЗапрос = ТекущиаяСтрока;
	
	Если ЭтоИпотечныйМенеджер Тогда
		ПодключитьОбработчикОжидания("АктивизацияСтрокиРасчетЗавершение", 0.1, Истина);
	КонецЕсли;
	
	УстановитьПараметрыПриАктивизацииСтрокиЗапроса();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеПриВыбореКлиентаНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументЗапрос.Ссылка КАК Ссылка,
	|	ДокументЗапрос.Дата КАК Дата,
	|	ДокументЗапрос.Стадия КАК Стадия
	|ИЗ
	|	Документ.Запрос КАК ДокументЗапрос
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Запрос.Участники КАК ЗапросУчастники
	|		ПО (ЗапросУчастники.Ссылка = ДокументЗапрос.Ссылка)
	|ГДЕ
	|	НЕ &Клиент = НЕОПРЕДЕЛЕНО
	|	И ВЫБОР
	|			КОГДА ЗапросУчастники.Ссылка ЕСТЬ NULL
	|				ТОГДА ЛОЖЬ
	|			ИНАЧЕ ЗапросУчастники.Клиент = &Клиент
	|		КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	Стадия,
	|	Дата";
	Запрос.УстановитьПараметр("Клиент", ТекущийКлиент);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		ТекущийЗапрос = Выборка.Ссылка;
		
	Иначе
		
		ТекущийЗапрос = Документы.Запрос.ПустаяСсылка();
	
	КонецЕсли;	
	
	УстановитьПараметрыПриАктивизацииСтрокиЗапроса();
	Запросы.Параметры.УстановитьЗначениеПараметра("Клиент", ТекущийКлиент);
		
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыПриАктивизацииСтрокиЗапроса()

	Листинг.Параметры.УстановитьЗначениеПараметра("Запрос", ТекущийЗапрос);

    ОбработкаОбъект 							= РеквизитФормыВЗначение("Объект");    
    Схема 										= ОбработкаОбъект.ПолучитьМакет("СКД_ДетальнаяИнформацияПоЗапросу");
    Настройки 									= Схема.НастройкиПоУмолчанию;
	//Отбор по умолчанию у нас всегда один и по запросу, поэтому используем самый простой способ до него добраться. )
	Настройки.Отбор.Элементы[0].ПравоеЗначение 	= Элементы.Запросы.ТекущаяСтрока;
    КомпоновщикМакета 							= Новый КомпоновщикМакетаКомпоновкиДанных;
	Макет 										= КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновка 						= Новый ПроцессорКомпоновкиДанных;
	
	ПроцессорКомпоновка.Инициализировать(Макет);
	
	ТаблицаРезультат 	= Новый ТаблицаЗначений;	
	ПроцессорВывода 	= Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(ТаблицаРезультат);	
	ПроцессорВывода.Вывести(ПроцессорКомпоновка);
	
	Если ТаблицаРезультат.Количество() > 0 Тогда
		//СКД всегда вернёт нам две строки - первая: детальные записи, вторая: итоги. Итоги нельзя отключить, так как используем ресурсы
		//Поэтому берём данные первой строки
		СтрокаДетальныхЗаписей 	= ТаблицаРезультат[0];
		Бюджет 					= СтрокаДетальныхЗаписей.ОбъемСредствНаПокупку;
		КоличествоКомнат 		= СтрокаДетальныхЗаписей.КоличествоКомнат;
		Мотивация 				= СтрокаДетальныхЗаписей.МотивацииМотивация;
		Отделка 				= СтрокаДетальныхЗаписей.Отделка;
		СтопФакторы 			= СтрокаДетальныхЗаписей.СтопФакторыСтопФактор;
		ФакторыВыбора 			= СтрокаДетальныхЗаписей.ФакторыВыбораОНФакторВыбора;
		ФормыОплаты 			= СтрокаДетальныхЗаписей.ФормыОплатыФормаОплаты;
		ЦельПокупки 			= СтрокаДетальныхЗаписей.ЦелиПокупкиЦельПокупки;
	Иначе
		Бюджет 					= "";
		КоличествоКомнат 		= "";
		Мотивация 				= "";
		Отделка 				= "";
		СтопФакторы 			= "";
		ФакторыВыбора 			= "";
		ФормыОплаты 			= "";
		ЦельПокупки 			= "";
	КонецЕсли;
	
	ОбновитьВзаимодействияНаСервере();	
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДокументыБронирование, 		"ДокументЗапрос", ТекущийЗапрос, ВидСравненияКомпоновкиДанных.Равно, ,Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДокументыЗаявкиНаСделку, 	"ДокументОснование", ТекущийЗапрос, ВидСравненияКомпоновкиДанных.Равно, ,Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДокументыВыдачаПодарков, 	"ДокументОснование", ТекущийЗапрос, ВидСравненияКомпоновкиДанных.Равно, ,Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	
	//++ Юкаев Роман 20180123 (
	Если Пользователи.РолиДоступны("ПрохожденияАнкетированияИпотечныхКлиентов") Тогда			
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(РасчетыИпотеки, "Запрос", ?(ЗначениеЗаполнено(ТекущийЗапрос), ТекущийЗапрос, Документы.Запрос.ПустаяСсылка()), ВидСравненияКомпоновкиДанных.Равно, ,Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ИпотечныеЗаявки, "РасчетИпотеки", ПолучитьСписокДокументовРасчетИпотеки(ТекущийЗапрос), ВидСравненияКомпоновкиДанных.ВСписке, ,Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ЗапросыНаОдобрениеИпотеки, "РасчетИпотеки", ПолучитьСписокДокументовРасчетИпотеки(ТекущийЗапрос), ВидСравненияКомпоновкиДанных.ВСписке, ,Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Анкеты, "РасчетИпотеки", ПолучитьСписокДокументовРасчетИпотеки(ТекущийЗапрос), ВидСравненияКомпоновкиДанных.ВСписке, ,Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	ИначеЕсли Пользователи.РолиДоступны("ИспользованиеРабочегоСтолаМенеджераФилиала") ИЛИ Пользователи.РолиДоступны("ИспользованиеРабочегоСтолаМенеджераОСС") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ИпотечныеЗаявки, "Запрос", ТекущийЗапрос, ВидСравненияКомпоновкиДанных.Равно, , ?(НЕ ЗначениеЗаполнено(ТекущийЗапрос), Ложь, Истина), РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);				
	КонецЕсли; 
	//-- Юкаев Роман 20180123)
		
КонецПроцедуры

//++ Юкаев Роман 20180123 (
&НаКлиенте
Процедура АктивизацияСтрокиРасчетЗавершение()
	
	ТекСтрока = Элементы.РасчетыИпотеки.ТекущаяСтрока;
	
	ЗаполнитьДанныеИпотечник();
	
	Если ТекСтрока = Неопределено Тогда
		ТекущийРасчет = Неопределено;
		Возврат;
	КонецЕсли;
	
	ТекущийРасчет = ТекСтрока;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(РасчетыИпотеки, "Запрос", ТекущийЗапрос, ВидСравненияКомпоновкиДанных.ВСписке);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокДокументовРасчетИпотеки(Запрос)
	
	Если Не ЗначениеЗаполнено(Запрос) тогда
		Возврат Новый СписокЗначений;
	КонецЕсли;
	
	ЗапросТ = Новый Запрос;
	ЗапросТ.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	РасчетИпотеки.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.РасчетИпотеки КАК РасчетИпотеки
		|ГДЕ
		|	РасчетИпотеки.Запрос = &Запрос
		|
		|СГРУППИРОВАТЬ ПО
		|	РасчетИпотеки.Ссылка";
	
	ЗапросТ.УстановитьПараметр("Запрос", Запрос);
	
	Результат = ЗапросТ.Выполнить();
	
	Если Результат.Пустой() Тогда
		
		Возврат Новый СписокЗначений;
	Иначе
		Выборка = Результат.Выбрать();
		
		СписокДокументов = Новый СписокЗначений;
		Пока Выборка.Следующий() Цикл
			СписокДокументов.Добавить(Выборка.Ссылка);
		КонецЦикла;
	
		Возврат СписокДокументов;
	КонецЕсли;
	
КонецФункции
//-- Юкаев Роман 20180123)

&НаСервереБезКонтекста
Функция ПолучитьЗначениеРасшифровкиНаСервере(Расшифровка, АдресХранилищаДанныеРасшифровки)
	
	ДанныеРасшифровкиКомпоновки = ПолучитьИзВременногоХранилища(АдресХранилищаДанныеРасшифровки);
	ПоляРасшфроки 				= ДанныеРасшифровкиКомпоновки.Элементы.Получить(Расшифровка).ПолучитьПоля();	
	НайденноеПоле 				= ПоляРасшфроки.Найти("Взаимодействие"); 
	
	Если НайденноеПоле = Неопределено Тогда
		Возврат "";
	Иначе
		Возврат НайденноеПоле.Значение;	
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура СоздатьНовоеВзаимодействие(ТипОбъекта)
	
	ПараметрыСоздания = Новый Структура;
		
	Если Элементы.Запросы.ТекущаяСтрока = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ПараметрыСоздания.Вставить("ЗначенияЗаполнения",Новый Структура("Предмет", Элементы.Запросы.ТекущаяСтрока));
	
	ВзаимодействияКлиент.СоздатьНовоеВзаимодействие(ТипОбъекта, ПараметрыСоздания, ЭтотОбъект);

КонецПроцедуры

&НаСервере
Функция ПолучитьПервуюСтрокуСписка(ИмяСписка = "Запросы", Поле = "Ссылка")

    Схема = Элементы[ИмяСписка].ПолучитьИсполняемуюСхемуКомпоновкиДанных();
    Настройки = Элементы[ИмяСписка].ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
    КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
    МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
    
    ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
    ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
    
    ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
    ТаблицаРезультат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	Возврат ?(ТаблицаРезультат.Количество(), ТаблицаРезультат[0][Поле], Неопределено);
	
КонецФункции

&НаСервере
Процедура ОбновитьФормуНаСервере()

	//++ Юкаев Роман 20180123 ( // 766996
	Видимость = Пользователи.РолиДоступны("ПрохожденияАнкетированияИпотечныхКлиентов");
	ЭтоАдминистратор = Пользователи.ЭтоПолноправныйПользователь(Пользователи.ТекущийПользователь(), Истина);
	
	Элементы.ГруппаАнкета.Видимость = Видимость Или ЭтоАдминистратор;
	Элементы.ГруппаЗапросыНаОдобрениеИпотеки.Видимость = Видимость Или ЭтоАдминистратор;
	Элементы.ГруппаИпотечнаяЗаявка.Видимость = (Видимость ИЛИ Пользователи.РолиДоступны("МенеджерФилиала") ИЛИ Пользователи.РолиДоступны("МенеджерОСС")) Или ЭтоАдминистратор;
	Элементы.ГруппаРасчетыИпотеки.Видимость = Видимость Или ЭтоАдминистратор;
	Элементы.ГруппаЛистинг.Видимость = Не Видимость Или ЭтоАдминистратор;
	Элементы.ГруппаЗаявки.Видимость = Истина;
	Элементы.ГруппаБронирование.Видимость = Не Видимость Или ЭтоАдминистратор;
	Элементы.ГруппаПодарки.Видимость = Не Видимость Или ЭтоАдминистратор;
	
	//
	Элементы.ГруппаПравоИпотечник.Видимость = Видимость И Не ЭтоАдминистратор;
	Элементы.ГруппаПраво.Видимость = Не Видимость Или ЭтоАдминистратор;
	
	Если Видимость Тогда
		ЗаполнитьДанныеИпотечник();
		
		//Если ЗначениеЗаполнено(ТекущийЗапрос) Тогда
		СписокДокументов = ПолучитьСписокДокументовРасчетИпотеки(ТекущийЗапрос);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ИпотечныеЗаявки, "РасчетИпотеки", СписокДокументов, ВидСравненияКомпоновкиДанных.ВСписке);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ЗапросыНаОдобрениеИпотеки, "РасчетИпотеки", СписокДокументов, ВидСравненияКомпоновкиДанных.ВСписке);
		Если ЗначениеЗаполнено(ТекущийЗапрос) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДокументыЗаявкиНаСделку, "ДокументОснование", ТекущийЗапрос, ВидСравненияКомпоновкиДанных.ВСписке);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(РасчетыИпотеки, "Запрос", ТекущийЗапрос, ВидСравненияКомпоновкиДанных.ВСписке);
		Иначе
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДокументыЗаявкиНаСделку, "ДокументОснование", СписокДокументов, ВидСравненияКомпоновкиДанных.ВСписке);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(РасчетыИпотеки, "Запрос", СписокДокументов, ВидСравненияКомпоновкиДанных.ВСписке);
		КонецЕсли;
		//Иначе
		//	
		//КонецЕсли;
	КонецЕсли;
	//-- Юкаев Роман 20180123 )
		
	Если ЗначениеЗаполнено(ТекущийКлиент) Тогда
		Запросы.Параметры.УстановитьЗначениеПараметра("Клиент", ТекущийКлиент); //Справочники.Клиенты.ПустаяСсылка()
	КонецЕсли;
	
	Листинг.Параметры.УстановитьЗначениеПараметра("Запрос", ТекущийЗапрос); //Документы.Запрос.ПустаяСсылка()
	ОбновитьВзаимодействияНаСервере();		
	//Элементы.Клиенты.ТекущаяСтрока = ПолучитьПервуюСтрокуСписка("Клиенты");
	
	УстановитьПараметрыПриАктивизацииСтрокиЗапроса();
	
	//<исправление зависания>
	//Если ЗначениеЗаполнено(ТекущийКлиент) И НЕ НетЗапросовПоКлиенту Тогда  
	//	Запросы.Параметры.УстановитьЗначениеПараметра("Клиент", ТекущийКлиент); //Справочники.Клиенты.ПустаяСсылка()	
	//КонецЕсли;
	//
	//НовоеЗначение_НетЗапросовПоКлиенту = ПолучитьКоличествоСтрокСписка("Запросы") = 0;
	//Если ЗначениеЗаполнено(ТекущийКлиент) И НЕ НовоеЗначение_НетЗапросовПоКлиенту = НетЗапросовПоКлиенту Тогда
	//	Запросы.Параметры.УстановитьЗначениеПараметра("Клиент", ТекущийКлиент);
	//КонецЕсли;
	//
	//НетЗапросовПоКлиенту = НовоеЗначение_НетЗапросовПоКлиенту;//ПолучитьКоличествоСтрокСписка("Запросы") = 0;		
	//
	//Листинг.Параметры.УстановитьЗначениеПараметра("Запрос", ТекущийЗапрос); //Документы.Запрос.ПустаяСсылка()
	//ОбновитьВзаимодействияНаСервере();		
	//УстановитьПараметрыПриАктивизацииСтрокиЗапроса();	
	//</исправление зависания>
		
КонецПроцедуры

//++ Юкаев Роман 20180129 (
&НаСервере
Процедура ЗаполнитьДанныеИпотечник()
	
	Если ЗначениеЗаполнено(ТекущийЗапрос) Тогда
		ИпотечныйСтатусКлиента = ПолучитьИпотечныйСтатусКлиента(ТекущийЗапрос);
	Иначе
		ИпотечныйСтатусКлиента = Перечисления.СтатусыИпотечныхЗаявок.ПустаяСсылка();
	КонецЕсли;
	
	Если ИпотечныйСтатусКлиента = Перечисления.СтатусыИпотечныхЗаявок.ПоданаЗаявкаНаКредит Тогда
		РекомендуемыеБанки = ПолучитьБанки(Ложь, ТекущийЗапрос);
	ИначеЕсли ИпотечныйСтатусКлиента = Перечисления.СтатусыИпотечныхЗаявок.ОдобрениеБанка Тогда
		РекомендуемыеБанки = ПолучитьБанки(Истина, ТекущийЗапрос);
	Иначе
		РекомендуемыеБанки = "";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущийРасчет) Тогда
		СтоимостьКвартиры = ТекущийРасчет.СтоимостьКвартирыРуб;
		ПервоначальныйВзнос = ТекущийРасчет.ПервоначальныйВзносРуб;
		СуммаКредита = ТекущийРасчет.СуммаКредитаРуб;
		ТипОбъекта = ТекущийРасчет.ТипОбъекта;
		Созаемщики = ПолучитьСписокСозаемщиков(ТекущийРасчет);
	Иначе
		СтоимостьКвартиры = 0;
		ПервоначальныйВзнос = 0;
		СуммаКредита = 0;
		ТипОбъекта = Справочники.ПараметрыПримененияСтавок_Значения.ПустаяСсылка();
		Созаемщики = "";
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокСозаемщиков(Док)
	
	Стр = "";
	
	Если ЗначениеЗаполнено(Док) Тогда
		
		Для Каждого СтрЗ Из Док.ДанныеОЗаемщиках Цикл
			Стр = Стр + СтрЗ.ФИО.Наименование + "; ";
		КонецЦикла;
		
		Стр = Лев(Стр, СтрДлина(Стр) - 1);
	КонецЕсли;
	
	Возврат Стр;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьБанки(Ключ, Запрос)
	
	СписокБанков = "";
	
	ЗапросТ = Новый Запрос;
	ЗапросТ.Текст = 
		"ВЫБРАТЬ
		|	ИпотечныеЗаявкиВБанкСрезПоследних.РекомендуемыйБанк КАК РекомендуемыйБанк
		|ИЗ
		|	РегистрСведений.ИпотечныеЗаявкиВБанк.СрезПоследних КАК ИпотечныеЗаявкиВБанкСрезПоследних
		|ГДЕ
		|	ИпотечныеЗаявкиВБанкСрезПоследних.Запрос = &Запрос
		|	И ИпотечныеЗаявкиВБанкСрезПоследних.РешениеБанка = &РешениеБанка";
	
	ЗапросТ.УстановитьПараметр("Запрос", Запрос);
	
	Если Ключ Тогда
		ЗапросТ.УстановитьПараметр("РешениеБанка", Справочники.РешенияБанков.ОдобрениеБанка);
	Иначе
		ЗапросТ.Текст = СтрЗаменить(ЗапросТ.Текст, "ИпотечныеЗаявкиВБанкСрезПоследних.РешениеБанка = &РешениеБанка", "Истина");
	КонецЕсли;
	
	Результат = ЗапросТ.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		
	    Пока Выборка.Следующий() Цикл
			СписокБанков = СписокБанков + Выборка.РекомендуемыйБанк.Наименование + "; ";
		КонецЦикла;
		
		СписокБанков = Лев(СписокБанков, СтрДлина(СписокБанков) - 1);
	КонецЕсли;
	
	Возврат СписокБанков;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьИпотечныйСтатусКлиента(ТекущийЗапрос)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИпотечныйСтатусКлиентаСрезПоследних.ИпотечныйСтатус КАК Статус
		|ИЗ
		|	РегистрСведений.ИпотечныйСтатусКлиента.СрезПоследних(&Период, Запрос = &Запрос) КАК ИпотечныйСтатусКлиентаСрезПоследних";
	
	Запрос.УстановитьПараметр("Запрос", ТекущийЗапрос);
	Запрос.УстановитьПараметр("Период", ТекущаяДата());
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Перечисления.СтатусыИпотечныхЗаявок.ПустаяСсылка()
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.Статус;
	КонецЕсли;
	
КонецФункции
//-- Юкаев Роман 20180129 )

&НаСервере
Процедура ОбновитьВзаимодействияНаСервере()
	
	Если Элементы.Запросы.ТекущаяСтрока = Неопределено Тогда
		ТабличныйДокумент.Очистить();
		Возврат;
	КонецЕсли;
	
	ОбработкаОбъект 					= РеквизитФормыВЗначение("Объект");
    Схема 								= ОбработкаОбъект.ПолучитьМакет("СКД_Взаимодействия");
	МакетОформления						= ОбработкаОбъект.ПолучитьМакет("МакетОформленияВзаимодействия");
    Настройки 							= Схема.НастройкиПоУмолчанию;
    ПараметрыДанных 					= Настройки.ПараметрыДанных.Элементы;
    ПараметрДанныхПредмет				= ПараметрыДанных.Найти("Предмет");
    ПараметрДанныхПредмет.Использование	= Истина;
	ПараметрДанныхПредмет.Значение 		= Элементы.Запросы.ТекущаяСтрока;	
	//Помещаем в переменную данные о расшифровке данных
	ДанныеРасшифровки 					= Новый ДанныеРасшифровкиКомпоновкиДанных;	
	//Формируем макет, с помощью компоновщика макета
	КомпоновщикМакета 					= Новый КомпоновщикМакетаКомпоновкиДанных;	
	//Передаем в макет компоновки схему, настройки и данные расшифровки
	МакетКомпоновки 					= КомпоновщикМакета.Выполнить(Схема, Настройки, ДанныеРасшифровки, МакетОформления);
		//Выполним компоновку с помощью процессора компоновки
	ПроцессорКомпоновкиДанных 			= Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки,,ДанныеРасшифровки);	
	//Очищаем поле табличного документа
	ТабличныйДокумент.Очистить();	
	//Выводим результат в табличный документ
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ТабличныйДокумент);	
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	АдресХранилищаДанныеРасшифровки = ПоместитьВоВременноеХранилище(ДанныеРасшифровки, ЭтотОбъект.УникальныйИдентификатор);
	
	КоличествоСтрок = ТабличныйДокумент.ВысотаТаблицы;
	КоличествоКолонок = ТабличныйДокумент.ШиринаТаблицы;
	
	Для СтрокаДокумента = 1 По КоличествоСтрок Цикл
	
		Для КолонкаДокумента = 1 По КоличествоКолонок Цикл
		
			Область = ТабличныйДокумент.Область(СтрокаДокумента, КолонкаДокумента);
			Расшифровка = Область.Расшифровка;
			Если ТипЗнч(Расшифровка) = Тип("ИдентификаторРасшифровкиКомпоновкиДанных") Тогда
			
				 ПоляРасшифровки = ДанныеРасшифровки.Элементы.Получить(Расшифровка).ПолучитьПоля();
				 НайденноеПоле = ПоляРасшифровки.Найти("ИндексКартинки");
				 Если НЕ НайденноеПоле = Неопределено Тогда
				 
				 	ИндексКартинки = НайденноеПоле.Значение;
					Если ТипЗнч(ИндексКартинки) = Тип("Число") Тогда
						
						//Если ИндексКартинки = 0 Тогда
						//	Картинка = БиблиотекаКартинок.Встреча;
						//ИначеЕсли ИндексКартинки = 1 Тогда
						//	Картинка = БиблиотекаКартинок.ТелефонныйЗвонок;
						//ИначеЕсли ИндексКартинки = 2 Тогда
						//	Картинка = БиблиотекаКартинок.НаписатьSMS;
						//ИначеЕсли ИндексКартинки = 3 Тогда
						//	Картинка = БиблиотекаКартинок.ЭлектронноеПисьмоВходящее;
						//ИначеЕсли ИндексКартинки = 4 Тогда	
						//	Картинка = БиблиотекаКартинок.ЭлектронноеПисьмоИсходящее;
						//КонецЕсли;
						
						Если ИндексКартинки = 0 Тогда
							Картинка = БиблиотекаКартинок.Взаимодействия_Встреча; //БиблиотекаКартинок.Встреча;
						ИначеЕсли ИндексКартинки = 1 Тогда
							Картинка = БиблиотекаКартинок.Взаимодействия_ТелефонныйЗвонок;//БиблиотекаКартинок.ТелефонныйЗвонок;
						ИначеЕсли ИндексКартинки = 2 Тогда
							Картинка = БиблиотекаКартинок.Взаимодействие_СообщениеSMS; //БиблиотекаКартинок.НаписатьSMS;
						ИначеЕсли ИндексКартинки = 3 Тогда
							Картинка = БиблиотекаКартинок.Взаимодействия_ЭП; //БиблиотекаКартинок.ЭлектронноеПисьмоВходящее;
						ИначеЕсли ИндексКартинки = 4 Тогда	
							Картинка = БиблиотекаКартинок.Взаимодействия_ЭП; //БиблиотекаКартинок.ЭлектронноеПисьмоИсходящее;
						ИначеЕсли ИндексКартинки = 5 Тогда	
							Картинка = БиблиотекаКартинок.Взаимодействия_Сделка; //БиблиотекаКартинок.ЭлектронноеПисьмоИсходящее;
						ИначеЕсли ИндексКартинки = 6 Тогда	
							Картинка = БиблиотекаКартинок.Взаимодействия_Расторжение; //БиблиотекаКартинок.ЭлектронноеПисьмоИсходящее;
						КонецЕсли;
												
						КартинкаВДокументе 					= ТабличныйДокумент.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Картинка);
						КартинкаВДокументе.Картинка 		= Картинка;
						КартинкаВДокументе.РазмерКартинки 	= РазмерКартинки.РеальныйРазмерБезУчетаМасштаба;
						КартинкаВДокументе.Расположить(Область);
						//Область.АвтоВысотаСтроки 			= Ложь;
						КартинкаВДокументе.Лево				= Цел(КартинкаВДокументе.Лево);
						//КартинкаВДокументе.Высота			= Область.ВысотаСтроки -1;
						РасшифровкаВзаимодействия = ПоляРасшифровки.Найти("Взаимодействие");
						Если РасшифровкаВзаимодействия <> Неопределено Тогда
							КартинкаВДокументе.Расшифровка = Расшифровка;						
						КонецЕсли;
						КартинкаВДокументе.ЦветЛинии		= WebЦвета.Белый;						
					
					КонецЕсли;
					
				 
				 КонецЕсли;
			
			КонецЕсли;
		
		КонецЦикла;
	
	КонецЦикла;
	МакетДляЗакрывающейСекции 	= ОбработкаОбъект.ПолучитьМакет("МакетДляЗакрывающейСекции");
	ОбластьМакета 				= МакетДляЗакрывающейСекции.ПолучитьОбласть("ЗакрывающаяСекция");
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
КонецПроцедуры

//++ Юкаев Роман 20180129 (
&НаКлиенте
Процедура РасчетыИпотекиПриАктивизацииСтроки(Элемент)
	АктивизацияСтрокиРасчетЗавершение();
КонецПроцедуры

&НаКлиенте
Процедура СоздатьРасчетИпотеки(Команда)
	
	СтруктураПараметров = Новый Структура("Запрос,ФИО");
	
	ТекущиеДанныеЗапрос = Элементы.Запросы.ТекущиеДанные;
	Если ТекущиеДанныеЗапрос = Неопределено Тогда
		СтруктураПараметров.Запрос = ПредопределенноеЗначение("Документ.Запрос.ПустаяСсылка");
		ТекущиеДанныеКлиент = Элементы.Клиенты.ТекущиеДанные;
		Если ТекущиеДанныеКлиент = Неопределено Тогда
			СтруктураПараметров.ФИО = ПредопределенноеЗначение("Справочник.Клиенты.ПустаяСсылка");
		Иначе
			СтруктураПараметров.ФИО = ТекущиеДанныеКлиент.Ссылка;
		КонецЕсли;
	Иначе
		СтруктураПараметров.Запрос = Элементы.Запросы.ТекущаяСтрока;
		СтруктураПараметров.ФИО = ТекущиеДанныеЗапрос.Клиент;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Основание", СтруктураПараметров);
	
	ОткрытьФорму("Документ.РасчетИпотеки.ФормаОбъекта", ПараметрыФормы, ЭтаФорма, ЭтаФорма,,,,РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьРасчетИпотеки1(Команда)
	
	СтруктураПараметров = Новый Структура("Запрос,ФИО,НовыйДокумент");
	
	СтруктураПараметров.Запрос = ПредопределенноеЗначение("Документ.Запрос.ПустаяСсылка");
	СтруктураПараметров.ФИО = ПредопределенноеЗначение("Справочник.Клиенты.ПустаяСсылка");
	СтруктураПараметров.НовыйДокумент = Истина;
	
	ПараметрыФормы = Новый Структура("Основание", СтруктураПараметров);
	
	ОткрытьФорму("Документ.РасчетИпотеки.ФормаОбъекта", ПараметрыФормы, ЭтаФорма, ЭтаФорма,,,,РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры
//-- Юкаев Роман 20180129 )

&НаСервере
Функция ПолучитьКоличествоСтрокСписка(ИмяСписка = "Запросы")

    Схема = Элементы[ИмяСписка].ПолучитьИсполняемуюСхемуКомпоновкиДанных();
    Настройки = Элементы[ИмяСписка].ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
    КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
    МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
    
    ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
    ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
    
    ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
    ТаблицаРезультат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
		
	Возврат ТаблицаРезультат.Количество();
	
КонецФункции

&НаКлиенте
Процедура ДокументыЗаявкиНаСделкуВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.ДокументыЗаявкиНаСделку.ТекущиеДанные;
	Если НЕ ТекущиеДанные = Неопределено Тогда
		ПоказатьЗначение(, ТекущиеДанные.ЗаявкаНаСделку);	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
