﻿#Область ПрограммныйИнтерфейс

Процедура СформироватьОтчет(Результат, КомпоновщикНастроек, ДанныеРасшифровки) Экспорт
		
	ТекстЗапросаУНП = 
		"ВЫБРАТЬ
		|	АктуальноеСостояниеБюджетаСрезПоследних.СостояниеБП
		|ПОМЕСТИТЬ вт_АктуализацияБюджета
		|ИЗ
		|	РегистрСведений.АктуальноеСостояниеБюджета.СрезПоследних(&ПериодДействия, ДатаНачалаПлана = &Период) КАК АктуальноеСостояниеБюджетаСрезПоследних
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПланПродажБюджетированияОперативный.Проект КАК ПроектУПН,
		|	ПРЕДСТАВЛЕНИЕ(ПланПродажБюджетированияОперативный.Классификатор) КАК Классификатор,
		|	ПланПродажБюджетированияОперативный.ПериодДействия КАК ПериодДействия,
		|	ВЫРАЗИТЬ(ПланПродажБюджетированияОперативный.Значение КАК ЧИСЛО(15, 2)) КАК Значение
		|ИЗ
		|	РегистрСведений.ПланПродажБюджетированияОперативный КАК ПланПродажБюджетированияОперативный
		|ГДЕ
		|	ПланПродажБюджетированияОперативный.Период = &Период
		|	И ПланПродажБюджетированияОперативный.ПериодДействия = &Период
		|	И ПланПродажБюджетированияОперативный.СостояниеБП В
		|			(ВЫБРАТЬ
		|				вт_АктуализацияБюджета.СостояниеБП
		|			ИЗ
		|				вт_АктуализацияБюджета КАК вт_АктуализацияБюджета)
		|	И ПланПродажБюджетированияОперативный.Показатель = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ПоказателиПланаПродаж.ПланРеализацииШт)";
	
	пПериод = КомпоновщикНастроек.ПараметрыДанных.Элементы.Найти("Период");
	Если пПериод.Использование Тогда		
		ПараметрыЗапроса = Новый Структура();
		// Установка параметров	
		ПараметрыЗапроса.Вставить("ПериодДействия", пПериод.Значение.ДатаНачала);
		ПараметрыЗапроса.Вставить("Период", 		НачалоМесяца(пПериод.Значение.ДатаНачала));		
	КонецЕсли;
	
	ТаблицаРезультатовУПН = ПолучитьТаблицуДанныхИзУПН(Ложь, ТекстЗапросаУНП, ПараметрыЗапроса);
	ПодготовитьТаблицуДанныхИзУПН(ТаблицаРезультатовУПН);
	
	ТаблицаРезультатовУПН_DS = ПолучитьТаблицуДанныхИзУПН(Истина, ТекстЗапросаУНП, ПараметрыЗапроса);
	ПодготовитьТаблицуДанныхИзУПН(ТаблицаРезультатовУПН_DS);
	
	ТаблицаРезультатов = ТаблицаРезультатовУПН.Скопировать();
	Для Каждого СтрокаТаблицыDS Из ТаблицаРезультатовУПН_DS Цикл
		НоваяСтрока = ТаблицаРезультатов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицыDS); 	
	КонецЦикла;
	
	НаборыДанных = Новый Структура("ТЗДляОтчета", ТаблицаРезультатов); 
			   
	ДанныеРасшифровки		  = Новый ДанныеРасшифровкиКомпоновкиДанных;
	КомпоновщикМакета		  = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновкиДанных	  = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек, ДанныеРасшифровки);
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных, НаборыДанных, ДанныеРасшифровки);
			  
	Результат.Очистить();
	ДокументРезультат = Результат;
	ПроцессорВывода   = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;	
	
	ПроцессорВывода.УстановитьДокумент(Результат);
	
	//ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных, Истина);
		
	ПроцессорВывода.НачатьВывод();
	Пока Истина Цикл
		//сч = ДанныеРасшифровки.Элементы.Количество();
		ЭлементРезультата = ПроцессорКомпоновкиДанных.Следующий();
		Если ЭлементРезультата = Неопределено Тогда
			Прервать;                                
		Иначе
			ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
		КонецЕсли;
	КонецЦикла;
	ПроцессорВывода.ЗакончитьВывод();

КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	НастройкиКД = КомпоновщикНастроек.ПолучитьНастройки();
	
	СтандартнаяОбработка = Ложь;
	
	СформироватьОтчет(ДокументРезультат, НастройкиКД, ДанныеРасшифровки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПодготовитьТаблицуДанныхИзУПН(ТаблицаРезультатов)

	ТаблицаРезультатов.Колонки.Добавить("Проект", 					Новый ОписаниеТипов("СправочникСсылка.Проекты"));
	ТаблицаРезультатов.Колонки.Добавить("ТипОбъектаНедвижимости", 	Новый ОписаниеТипов("ПеречислениеСсылка.ВидыОбъектовНедвижимости"));

	ТипыОбъектовНедвижимости = Новый Соответствие;
	ТипыОбъектовНедвижимости.Вставить("Продажа жилых объектов НОВЫЕ сделки", 					Перечисления.ВидыОбъектовНедвижимости.ЖилаяНедвижимость);
	ТипыОбъектовНедвижимости.Вставить("Продажа коммерческих объектов НОВЫЕ сделки", 			Перечисления.ВидыОбъектовНедвижимости.НежилаяНедвижимость);
	ТипыОбъектовНедвижимости.Вставить("Продажа машиномест НОВЫЕ сделки", 						Перечисления.ВидыОбъектовНедвижимости.Машиноместо);
	ТипыОбъектовНедвижимости.Вставить("Продажа ЗУ с коммуникациями и без подряда НОВЫЕ сделки", Перечисления.ВидыОбъектовНедвижимости.ЗемельныйУчасток);
	
	//НаборЗаписей = РегистрыСведений.СоответствиеПроектовУПНПроектамCRM.СоздатьНаборЗаписей();
	НаборЗаписей = РегистрыСведений.СопоставлениеПроектовCRMПроектамНСИ.СоздатьНаборЗаписей();
	
	Для Каждого СтрокаТЧ Из ТаблицаРезультатов Цикл
		СтрокаТЧ.ТипОбъектаНедвижимости = ТипыОбъектовНедвижимости[СтрокаТЧ.Классификатор];		
		
		ПроектыНСИ = Справочники.ПроектыНСИ.НайтиПоНаименованию(СтрокаТЧ.ПроектУПН, Истина);
		
		НаборЗаписей.Отбор.ПроектНСИ.Установить(ПроектыНСИ);
		НаборЗаписей.Прочитать(); 		
		Если НаборЗаписей.Количество() > 0 Тогда
			СтрокаТЧ.Проект = НаборЗаписей[0].ПроектCRM;
		КонецЕсли;
		//СтрокаТЧ.Проект = Справочники.Проекты.НайтиПоНаименованию(СтрокаТЧ.ПроектУПН);
	КонецЦикла;	
	
	ТаблицаРезультатов.Колонки.Удалить("Классификатор");
	ТаблицаРезультатов.Колонки.Удалить("ПроектУПН");
	
	Индекс = ТаблицаРезультатов.Количество() - 1;
	
	Пока Индекс >= 0 Цикл
		
		Если НЕ ЗначениеЗаполнено(ТаблицаРезультатов[Индекс].Проект) 
				ИЛИ НЕ ЗначениеЗаполнено(ТаблицаРезультатов[Индекс].ТипОбъектаНедвижимости) Тогда
			ТаблицаРезультатов.Удалить(Индекс);						
		КонецЕсли;
		Индекс = Индекс - 1;
		
	КонецЦикла;		
	
КонецПроцедуры

Функция ПолучитьТаблицуДанныхИзУПН(БазаDS = Ложь, ТекстЗапросаУНП, ПараметрыЗапроса)

	//МассивВходящихПараметров
	МассивВП = Новый Массив;
	СтруктураПолей = Новый Структура();
	//СтруктураПолей.Вставить("ПутьКДанным", "ПроектУПН");
	СтруктураПолей.Вставить("ПутьКДанным", "ПроектУПН");
	
	ПрограммныйКод = """Результат = Строка(Параметр.Ссылка)""";    
	//СтруктураПолей.Вставить("Выражение", "ОбщегоНазначения.ВычислитьПрограммныйКод("+ПрограммныйКод+",ПроектУПН)");
	СтруктураПолей.Вставить("Выражение", "ОбщегоНазначения.ВычислитьПрограммныйКод(" + ПрограммныйКод + ",ПроектУПН)");
	МассивВП.Добавить(СтруктураПолей);
	
	ПроксиСервер 	= Неопределено;
	ИмяСервиса 		= "RandomQuery";
	CRMСервер.ПодключитьсяКСервису(ПроксиСервер, БазаDS, ИмяСервиса);	
	
	ФлагОшибки 	= Ложь;
	
	Попытка
		ДанныеXDTO = ПроксиСервер.ExecuteQuery(ТекстЗапросаУНП, СериализаторXDTO.ЗаписатьXDTO(ПараметрыЗапроса), 90, СериализаторXDTO.ЗаписатьXDTO(МассивВП));
		
		СтруктураВозврата = СериализаторXDTO.ПрочитатьXDTO(ДанныеXDTO);        
		Если НЕ СтруктураВозврата = Неопределено Тогда 
			ОписаниеОшибки     	= СтруктураВозврата.ТекстОшибки;
			ФлагОшибки        	= СтруктураВозврата.Ошибка;
		Иначе
			ФлагОшибки 	= Истина;
			Отказ 		= Истина;
		КонецЕсли;
		
	Исключение
		Результат 	= ОписаниеОшибки();
		ФлагОшибки 	= Истина;
	КонецПопытки;											
	
	Если ФлагОшибки Тогда
		
		ТекстСообщения = "Возникла ошибка при обработке выполнения произвольного запроса к базе УНП" + ?(ПустаяСтрока(ОписаниеОшибки), "", ": " + ОписаниеОшибки);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
	Иначе
		
		Если Не ПустаяСтрока(СтруктураВозврата.РезультатЗапроса)Тогда
			ЧтениеXML = Новый ЧтениеXML();
			ЧтениеXML.УстановитьСтроку(СтруктураВозврата.РезультатЗапроса);
			ХранилищеЗначенияТаблицаЗначений = ПрочитатьXML(ЧтениеXML,Тип("ХранилищеЗначения"));
			Если Не ХранилищеЗначенияТаблицаЗначений = Неопределено Тогда 
				ТаблицаРезультатов = ХранилищеЗначенияТаблицаЗначений.Получить();
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ТаблицаРезультатов;

КонецФункции // ()

#КонецОбласти

