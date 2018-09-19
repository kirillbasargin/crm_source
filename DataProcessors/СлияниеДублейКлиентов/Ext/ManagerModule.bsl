﻿
#Область ПрограммныйИнтерфейс

Функция ЗаполнитьДеревоДублей(Клиенты = Неопределено, Первые = 0) Экспорт
		
	Запрос = Новый Запрос;
	Запрос.Текст = 	
	"ВЫБРАТЬ
	|	КлиентыКонтактнаяИнформация.Ссылка КАК Клиент,
	|	КлиентыКонтактнаяИнформация.Ссылка.ФИО КАК ФИО,
	|	КлиентыКонтактнаяИнформация.НомерТелефонаБезКодов КАК НомерТелефона
	|ПОМЕСТИТЬ ВТ_КлиентыКонтактнаяИнформация
	|ИЗ
	|	Справочник.Клиенты.КонтактнаяИнформация КАК КлиентыКонтактнаяИнформация
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсключенияДублированияКлиентов КАК ИсключенияДублированияКлиентов
	|		ПО КлиентыКонтактнаяИнформация.Ссылка = ИсключенияДублированияКлиентов.Клиент
	|			И КлиентыКонтактнаяИнформация.НомерТелефонаБезКодов = ИсключенияДублированияКлиентов.ТелефонБезНомеров
	|ГДЕ
	|	НЕ КлиентыКонтактнаяИнформация.Ссылка.ПометкаУдаления
	|	И КлиентыКонтактнаяИнформация.НомерТелефонаБезКодов <> """"
	|	И ИсключенияДублированияКлиентов.Клиент ЕСТЬ NULL
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Клиент,
	|	НомерТелефона,
	|	ФИО
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	КлиентыКонтактнаяИнформация.Клиент КАК Клиент,
	|	КлиентыКонтактнаяИнформация.НомерТелефона КАК НомерТелефона,
	|	КлиентыКонтактнаяИнформация.ФИО КАК ФИО,
	|	ДублирующийКлиентКонтактнаяИнформация.Клиент КАК ДублирующийКлиент,
	|	ДублирующийКлиентКонтактнаяИнформация.НомерТелефона КАК ДублирующийНомер,
	|	ДублирующийКлиентКонтактнаяИнформация.ФИО КАК ДублирующеесяФИО
	|ПОМЕСТИТЬ вт_ИсходныеДанные
	|ИЗ
	|	ВТ_КлиентыКонтактнаяИнформация КАК КлиентыКонтактнаяИнформация
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_КлиентыКонтактнаяИнформация КАК ДублирующийКлиентКонтактнаяИнформация
	|		ПО КлиентыКонтактнаяИнформация.Клиент <> ДублирующийКлиентКонтактнаяИнформация.Клиент
	|			И (ДублирующийКлиентКонтактнаяИнформация.НомерТелефона = КлиентыКонтактнаяИнформация.НомерТелефона)
	|			И (ДублирующийКлиентКонтактнаяИнформация.ФИО = КлиентыКонтактнаяИнформация.ФИО)
	|ГДЕ
	|	ИСТИНА
	|	И КлиентыКонтактнаяИнформация.Клиент В(&Клиенты)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	вт_ИсходныеДанные.Клиент КАК Клиент,
	|	вт_ИсходныеДанные.НомерТелефона КАК ТелефонБезНомеров,
	|	вт_ИсходныеДанные.ФИО КАК ФИО,
	|	ЛОЖЬ КАК Основной,
	|	ЛОЖЬ КАК Слияние,
	|	ЛОЖЬ КАК Исключение,
	|	0 КАК Уровень,
	|	0 КАК КоличествоСсылок
	|ПОМЕСТИТЬ вт_НеСгруппированныйРезультат
	|ИЗ
	|	вт_ИсходныеДанные КАК вт_ИсходныеДанные
	|
	|СГРУППИРОВАТЬ ПО
	|	вт_ИсходныеДанные.Клиент,
	|	вт_ИсходныеДанные.НомерТелефона,
	|	вт_ИсходныеДанные.ФИО
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	вт_ИсходныеДанные.ДублирующийКлиент,
	|	вт_ИсходныеДанные.ДублирующийНомер,
	|	вт_ИсходныеДанные.ДублирующеесяФИО,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	0,
	|	0
	|ИЗ
	|	вт_ИсходныеДанные КАК вт_ИсходныеДанные
	|
	|СГРУППИРОВАТЬ ПО
	|	вт_ИсходныеДанные.ДублирующийКлиент,
	|	вт_ИсходныеДанные.ДублирующийНомер,
	|	вт_ИсходныеДанные.ДублирующеесяФИО
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	вт_НеСгруппированныйРезультат.Клиент КАК Клиент,
	|	вт_НеСгруппированныйРезультат.ТелефонБезНомеров КАК ТелефонБезНомеров,
	|	вт_НеСгруппированныйРезультат.ФИО КАК ФИО,
	|	вт_НеСгруппированныйРезультат.Основной КАК Основной,
	|	вт_НеСгруппированныйРезультат.Слияние КАК Слияние,
	|	вт_НеСгруппированныйРезультат.Исключение КАК Исключение,
	|	вт_НеСгруппированныйРезультат.Уровень КАК Уровень,
	|	вт_НеСгруппированныйРезультат.КоличествоСсылок КАК КоличествоСсылок
	|ИЗ
	|	вт_НеСгруппированныйРезультат КАК вт_НеСгруппированныйРезультат
	|
	|СГРУППИРОВАТЬ ПО
	|	вт_НеСгруппированныйРезультат.Клиент,
	|	вт_НеСгруппированныйРезультат.ТелефонБезНомеров,
	|	вт_НеСгруппированныйРезультат.ФИО,
	|	вт_НеСгруппированныйРезультат.Основной,
	|	вт_НеСгруппированныйРезультат.Слияние,
	|	вт_НеСгруппированныйРезультат.Исключение,
	|	вт_НеСгруппированныйРезультат.Уровень,
	|	вт_НеСгруппированныйРезультат.КоличествоСсылок
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТелефонБезНомеров,
	|	ФИО
	|ИТОГИ
	|	МАКСИМУМ(1) КАК Уровень
	|ПО
	|	ТелефонБезНомеров,
	|	ФИО";		

	Если Клиенты = Неопределено ИЛИ НЕ Клиенты.Количество() Тогда //Объект.Клиент
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И КлиентыКонтактнаяИнформация.Клиент В(&Клиенты)", "");
	Иначе
		Запрос.УстановитьПараметр("Клиенты", Клиенты);	//Объект.Клиент
	КонецЕсли;	
	
	Если Первые > 0 Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ВЫБРАТЬ ПЕРВЫЕ 1", "ВЫБРАТЬ ПЕРВЫЕ " + СтрЗаменить(Первые, Символы.НПП, ""));		
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ВЫБРАТЬ ПЕРВЫЕ 1", "ВЫБРАТЬ ");	
	КонецЕсли;	
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Возврат РезультатЗапроса.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);		
	КонецЕсли;	
	
КонецФункции

Процедура ОбработатьКлиентов(ДеревоКлиентов) Экспорт
			
	ОценкаПроизводительностиСуществует = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОценкаПроизводительности");
	Если ОценкаПроизводительностиСуществует Тогда
		МодульОценкаПроизводительности = ОбщегоНазначения.ОбщийМодуль("ОценкаПроизводительности");
		ВремяНачала = МодульОценкаПроизводительности.НачатьЗамерВремени();
	КонецЕсли;	
	
	УстановитьПризнакиКлиентовСлияния(ДеревоКлиентов);
		
	ПараметрыЗамены = Новый Структура("СпособУдаления,УчитыватьПрикладныеПравила,ВключатьБизнесЛогику, ЗаменаПарыВТранзакции", "Пометка", Ложь, Истина, Ложь);
	
	Для каждого ГруппировкаПоТелефону Из ДеревоКлиентов.Строки Цикл				
		Если СтрДлина(ГруппировкаПоТелефону.ТелефонБезНомеров) < 7 Тогда
			Продолжить;
		КонецЕсли;		
		Для каждого ГруппировкаПоФИО Из ГруппировкаПоТелефону.Строки Цикл		
			МассивКлиентов = Новый Массив;
			Для каждого ДетальнаяЗапись Из ГруппировкаПоФИО.Строки Цикл
				Если ДетальнаяЗапись.Слияние Тогда			
					МассивКлиентов.Добавить(ДетальнаяЗапись.Клиент);					
				КонецЕсли;
				Если ДетальнаяЗапись.Основной Тогда
					КлиентДляЗамены = ДетальнаяЗапись.Клиент;
				КонецЕсли;
			КонецЦикла;		
			Если ЗначениеЗаполнено(КлиентДляЗамены) Тогда			
				Для каждого ЭлементМассива Из МассивКлиентов Цикл
					СоответствиеЗамены = Новый Соответствие;
					СоответствиеЗамены.Вставить(ЭлементМассива, КлиентДляЗамены);
					ОбщегоНазначения.ЗаменитьСсылки(СоответствиеЗамены, ПараметрыЗамены);
					СкопироватьКонтактнуюИнформацию(ЭлементМассива, КлиентДляЗамены);
					СкопироватьРеквизиты(ЭлементМассива, КлиентДляЗамены);
					СкорректироватьГражданство(КлиентДляЗамены);
				КонецЦикла;		
			КонецЕсли;
		КонецЦикла;		
	КонецЦикла;
	
	Если ОценкаПроизводительностиСуществует Тогда
		МодульОценкаПроизводительности.ЗакончитьЗамерВремени("СлияниеДублейКлиентовСборСтатистики", ВремяНачала);
	КонецЕсли;	
	
КонецПроцедуры

Процедура ОбработатьКлиентовРегламентно(ДеревоКлиентов) Экспорт
			
	ЧислоСтрокВТаблице = ДеревоКлиентов.Строки.Количество();
	
	Если ЧислоСтрокВТаблице = 1 Тогда 
		ОбработатьКлиентов(ДеревоКлиентов);	
	Иначе
		ЧислоПотоков = 10;		
		РазмерПорции = Цел(ЧислоСтрокВТаблице / ЧислоПотоков);	
		РазмерПорции = ?(РазмерПорции = 0, 1 , РазмерПорции);
		МассивЗаданий = Новый Массив;
	
		Для НомерПотока = 1 По ЧислоПотоков Цикл 		
			ИндексНачала = (НомерПотока - 1) * РазмерПорции;		
			Если (НомерПотока = ЧислоПотоков) Тогда
				РазмерПорции = ЧислоСтрокВТаблице - (ЧислоПотоков * РазмерПорции) + РазмерПорции;			
			КонецЕсли;  
			
			ПорцияДереваКлиентов = ПодготовитьПорциюДереваКлиентов(ДеревоКлиентов, ИндексНачала, РазмерПорции);
			НаборПараметров = Новый Массив;
			НаборПараметров.Добавить(ПорцияДереваКлиентов);	
			
			Задание = ФоновыеЗадания.Выполнить("CRMРаботаСЗаданиямиСервер.УдалениеДублейКлиентов", НаборПараметров, "Обработка дублей клиентов в отдельном потоке - " + НомерПотока, "УдалениеДублейКлиентов");		
			МассивЗаданий.Добавить(Задание);
			
			Если ЧислоСтрокВТаблице <= НомерПотока Тогда
				Прервать;
			КонецЕсли;		
		КонецЦикла;	
		
	    Если МассивЗаданий.Количество() > 0 Тогда
	        Попытка
	            ФоновыеЗадания.ОжидатьЗавершения(МассивЗаданий);
			Исключение
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка выполнения задания УдалениеДублейКлиентов: " + ОписаниеОшибки());
				Возврат;
			КонецПопытки;        
	    КонецЕсли;	
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПодготовитьПорциюДереваКлиентов(Знач ДеревоКлиентов, ИндексНачала, РазмерПорции)
	
	ПорцияДереваКлиентов = ДеревоКлиентов.Скопировать();
	ПорцияДереваКлиентов.Строки.Очистить();
	
	Для Сч = 1 По РазмерПорции Цикл
		Индекс = ?(Сч = 1, ИндексНачала, Индекс + 1);
		Если СтрДлина(ДеревоКлиентов.Строки[Индекс].ТелефонБезНомеров) < 7 Тогда
			Продолжить;
		КонецЕсли;		
		СтрокаПорции = ПорцияДереваКлиентов.Строки.Добавить();
		РекурсивноеДобавлениеНайденногоУзла(СтрокаПорции, ДеревоКлиентов.Строки[Индекс]);		
	КонецЦикла;
	
	Возврат ПорцияДереваКлиентов;
	
КонецФункции

Процедура РекурсивноеДобавлениеНайденногоУзла(Получатель, Источник) 
	
	ЗаполнитьЗначенияСвойств(Получатель, Источник);
	
    Для Каждого СтрокаИсточника Из Источник.Строки Цикл        
        ТекущаяСтрока = Получатель.Строки.Добавить();
        ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаИсточника);
        ТекущаяСтрока.Уровень = Получатель.Уровень() + 1;        
        Если СтрокаИсточника.Строки.Количество() > 0 Тогда
            РекурсивноеДобавлениеНайденногоУзла(ТекущаяСтрока, СтрокаИсточника);
        КонецЕсли;        
    КонецЦикла;
    
КонецПроцедуры

Процедура УстановитьПризнакиКлиентовСлияния(ДеревоКлиентов)
	
	Для каждого ГруппировкаПоТелефону Из ДеревоКлиентов.Строки Цикл
		Для каждого ГруппировкаПоФИО Из ГруппировкаПоТелефону.Строки Цикл
			ЗаполнитьКоличестваСсылок(ГруппировкаПоФИО.Строки);
	    КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры 

Процедура ЗаполнитьКоличестваСсылок(Строки)
	
	Оригинал = Неопределено;	
	МаксимальноеКоличество = 0;
	
	Для каждого ДетальнаяЗапись Из Строки Цикл
		ДетальнаяЗапись.КоличествоСсылок = ПолучитьКоличествоСсылокКлиента(ДетальнаяЗапись.Клиент);
		Если ДетальнаяЗапись.КоличествоСсылок > МаксимальноеКоличество Тогда
			МаксимальноеКоличество = ДетальнаяЗапись.КоличествоСсылок;
		КонецЕсли;
	КонецЦикла;
	
	Если МаксимальноеКоличество > 0 Тогда		
		//НайденныеСтроки = Строки.НайтиСтроки(Новый Структура("КоличествоСсылок", МаксимальноеКоличество));
		//Если НайденныеСтроки.Количество() > 1 Тогда
		//	Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		//		СтруктураЗапросовКлиента = ВернутьСтруктуруДанныхПоЗапросам(НайденнаяСтрока.Клиент);     ВернутьСтруктуруДанныхПоЗапросам(Строки[1].Клиент)
		//		Если СтруктураЗапросовКлиента.Количество() Тогда
		//			НайденнаяСтрока.КоличествоСсылок = НайденнаяСтрока.КоличествоСсылок + 1;
		//			МаксимальноеКоличество = НайденнаяСтрока.КоличествоСсылок;
		//		Иначе
		//			НайденнаяСтрока.КоличествоСсылок = 0;
		//			МаксимальноеКоличество = 0;
		//		КонецЕсли;
		//	КонецЦикла;
		//КонецЕсли;
		//
		//МаксимальноеКоличество = МаксимальноеЗначениеВМассиве(Строки.ВыгрузитьКолонку("КоличествоСсылок"));
		
		НайденныеСтроки = Строки.НайтиСтроки(Новый Структура("КоличествоСсылок", МаксимальноеКоличество));
		Если НайденныеСтроки.Количество() Тогда
			НайденныеСтроки[0].Основной = Истина;
			Оригинал = НайденныеСтроки[0].Клиент;
			Для каждого ДетальнаяЗапись Из Строки Цикл
				Если НЕ ДетальнаяЗапись.Клиент = Оригинал Тогда
					ДетальнаяЗапись.Слияние = Истина;	
				КонецЕсли;
			КонецЦикла;	
		КонецЕсли;	
	КонецЕсли;
		
КонецПроцедуры

Функция МаксимальноеЗначениеВМассиве(Массив)
	
	МаксимальноеЗначение = 0;
	
	Для Индекс = 0 По Массив.Количество() - 1 Цикл
		Значение = Массив[Индекс];
		
		Если МаксимальноеЗначение < Значение Тогда
			МаксимальноеЗначение = Значение;
		КонецЕсли;
	КонецЦикла;
	
	Возврат МаксимальноеЗначение;
	
КонецФункции

Функция ПолучитьКоличествоСсылокКлиента(Клиент)
	
	СписокСсылок = Новый Массив;
	СписокСсылок.Добавить(Клиент);
	
	ИсключитьОтбъекты = Новый Массив;
	ИсключитьОтбъекты.Добавить(Метаданные.РегистрыСведений.ВерсииОбъектов);
	
	ВключитьОбъекты = Новый Массив;
	ДеревоМД = ОбменДаннымиСервер.ДеревоМетаданныхКонфигурации();
	Для Каждого Стр Из ДеревоМД.Строки Цикл
		Для Каждого Стр1 Из Стр.Строки Цикл
			ВключитьОбъекты.Добавить(Стр1.ПолноеИмя)
		КонецЦикла;
	КонецЦикла;	
	
	ОбластьПоиска = Новый Массив;
	ТабСсылок = НайтиПоСсылкам(СписокСсылок, ОбластьПоиска, ВключитьОбъекты, ИсключитьОтбъекты);

	Возврат ТабСсылок.Количество();
	
КонецФункции

Процедура СкопироватьКонтактнуюИнформацию(КлиентЗаменяемый, КлиентЗамены)
	
	ОбъектКлиентЗамены 			= КлиентЗамены.ПолучитьОбъект();
	КИ_КлиентаЗамены 			= ОбъектКлиентЗамены.КонтактнаяИнформация;
	
	НеобходимоЗаписатьКлиента 	= ЛожЬ;
	
	//Телефоны
	Для каждого СтрокаКИ Из КлиентЗаменяемый.КонтактнаяИнформация Цикл
		Если СтрокаКИ.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
			НайденнаяСтрока = КИ_КлиентаЗамены.Найти(СтрокаКИ.НомерТелефонаБезКодов);
			Если НайденнаяСтрока = Неопределено Тогда
				НоваяСтрока = КИ_КлиентаЗамены.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаКИ);
				НеобходимоЗаписатьКлиента = Истина;
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;
	
	//Адрес
	Для каждого СтрокаКИ Из КлиентЗаменяемый.КонтактнаяИнформация Цикл
		Если СтрокаКИ.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес Тогда
			НайденнаяСтрока = КИ_КлиентаЗамены.Найти(СтрокаКИ.Представление);
			Если НайденнаяСтрока = Неопределено Тогда
				НоваяСтрока = КИ_КлиентаЗамены.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаКИ);
				НеобходимоЗаписатьКлиента = Истина;
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;	
	
	//Прочая КИ
	Для каждого СтрокаКИ Из КлиентЗаменяемый.КонтактнаяИнформация Цикл
		Если СтрокаКИ.Тип <> Перечисления.ТипыКонтактнойИнформации.Телефон
				И СтрокаКИ.Тип <> Перечисления.ТипыКонтактнойИнформации.Адрес Тогда
			НоваяСтрока = КИ_КлиентаЗамены.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаКИ);
			НеобходимоЗаписатьКлиента = Истина;
		КонецЕсли;	
	КонецЦикла;	
	
	Если НеобходимоЗаписатьКлиента Тогда		
		УстановитьПривилегированныйРежим(Истина);
		ОбъектКлиентЗамены.ОбменДанными.Загрузка = Истина;
		ОбъектКлиентЗамены.ДополнительныеСвойства.Вставить("ПропуститьЗаписьВерсииОбъекта");		
		ОбъектКлиентЗамены.Записать();
		
		ОбъектКлиентЗамены.ОбменДанными.Загрузка = Ложь;
		ОбъектКлиентЗамены.ДополнительныеСвойства.Вставить("АвторВерсии", Справочники.Пользователи.Робот);	
		//ОбъектКлиентЗамены.ДополнительныеСвойства.Вставить("СистемноеПроведение", Истина);		
		ВерсионированиеОбъектов.ЗаписатьВерсиюОбъекта(ОбъектКлиентЗамены, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

Процедура СкопироватьРеквизиты(КлиентЗаменяемый, КлиентЗамены)
	
	ОбъектКлиентЗамены 			= КлиентЗамены.ПолучитьОбъект();
	НеобходимоЗаписатьКлиента 	= ЛожЬ;
	
	Если ПустаяСтрока(ОбъектКлиентЗамены.МестоРождения) 
			И НЕ ПустаяСтрока(КлиентЗаменяемый.МестоРождения) Тогда
		ОбъектКлиентЗамены.МестоРождения 	= КлиентЗаменяемый.МестоРождения;
		НеобходимоЗаписатьКлиента 			= Истина;
	КонецЕсли;
	
	Если ОбъектКлиентЗамены.ДатаРождения = '00010101' 
			И НЕ КлиентЗаменяемый.ДатаРождения = '00010101' Тогда
		ОбъектКлиентЗамены.ДатаРождения 	= КлиентЗаменяемый.ДатаРождения;
		НеобходимоЗаписатьКлиента 			= Истина;
	КонецЕсли;	
	
	Если НеобходимоЗаписатьКлиента Тогда
		ОбъектКлиентЗамены.ОбменДанными.Загрузка = Истина;
		ОбъектКлиентЗамены.Записать();
	КонецЕсли;
	
КонецПроцедуры

Процедура СкорректироватьГражданство(КлиентЗамены)
	
	НаборЗаписей = РегистрыСведений.ГражданствоФизическихЛиц.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ФизическоеЛицо.Установить(КлиентЗамены);
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество() > 1 Тогда
		Для каждого Запись Из НаборЗаписей Цикл
		    Если Запись.Страна = Справочники.СтраныМира.ПустаяСсылка() Тогда
				НаборЗаписей.Удалить(Запись);
				Прервать;
			КонецЕсли;		
		КонецЦикла;
	КонецЕсли;
	НаборЗаписей.Записать();
	
КонецПроцедуры

Функция ВернутьСтруктуруДанныхПоЗапросам(Клиент)
	
	СтруктураРезультат = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗапросУчастники.Ссылка КАК Запрос,
	|	Запрос.Проект КАК Проект,
	|	Запрос.Стадия КАК Стадия
	|ИЗ
	|	Документ.Запрос.Участники КАК ЗапросУчастники
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Запрос КАК Запрос
	|		ПО ЗапросУчастники.Ссылка = Запрос.Ссылка
	|ГДЕ
	|	ЗапросУчастники.Клиент = &Клиент
	|	И НЕ Запрос.ПометкаУдаления
	|	И Запрос.Проведен";
	
	Запрос.УстановитьПараметр("Клиент", Клиент);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка 	= РезультатЗапроса.Выбрать();
		НомерСтроки = 1;
		Пока Выборка.Следующий() Цикл
			СтруктураСтроки = Новый Структура("Запрос,Проект,Стадия");
			ЗаполнитьЗначенияСвойств(СтруктураСтроки, Выборка);
		 	СтруктураРезультат.Вставить("Строка" + Строка(НомерСтроки), СтруктураСтроки);
		КонецЦикла;
	КонецЕсли;
	
	Возврат СтруктураРезультат;	
	
КонецФункции

Процедура СоздатьЗаписьИсключенияДублированияКлиентов(Клиент, ТелефонБезНомеров)
			
	НаборЗаписей = РегистрыСведений.ИсключенияДублированияКлиентов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Клиент.Установить(Клиент);
	НаборЗаписей.Отбор.ТелефонБезНомеров.Установить(ТелефонБезНомеров);
	НоваяЗапись 					= НаборЗаписей.Добавить();
	НоваяЗапись.Клиент 				= Клиент;
	НоваяЗапись.ТелефонБезНомеров 	= ТелефонБезНомеров;	
	НаборЗаписей.Записать();
	
КонецПроцедуры

Функция ПолучитьСтрокиНижнегоУровня(Дерево, Таблица = Неопределено) Экспорт
	
	Если Таблица = Неопределено Тогда
		Таблица = Новый ТаблицаЗначений;
		Для Каждого Колонка Из Дерево.Колонки Цикл
			Таблица.Колонки.Добавить(Колонка.Имя, Колонка.ТипЗначения);
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого СтрокаДерева Из Дерево.Строки Цикл
		Если СтрокаДерева.Уровень = 0 Тогда		
			ЗаполнитьЗначенияСвойств(Таблица.Добавить(), СтрокаДерева);
		Иначе
			ПолучитьСтрокиНижнегоУровня(СтрокаДерева, Таблица);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Таблица;
	
КонецФункции

Функция ПодготовитьПорциюТаблицыКлиентов(Знач ТаблицаКлиентов, ИндексНачала, РазмерПорции)
	
	ПорцияТаблицыЗапросов = ТаблицаКлиентов.Скопировать();
	ПорцияТаблицыЗапросов.Очистить();
	
	Для Сч = 1 По РазмерПорции Цикл
		Индекс = ?(Сч = 1, ИндексНачала, Индекс + 1);
		СтрокаПорции = ПорцияТаблицыЗапросов.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаПорции, ТаблицаКлиентов[Индекс]);	
	КонецЦикла;
	
	Возврат ДобавитьУровеньРодителяТаблицы(ПорцияТаблицыЗапросов); 
		
КонецФункции

Функция ДобавитьУровеньРодителяТаблицы(ПорцияТаблицыЗапросов) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	вт_СгруппированныйРезультат.Клиент КАК Клиент,
	|	вт_СгруппированныйРезультат.ТелефонБезНомеров КАК ТелефонБезНомеров,
	|	вт_СгруппированныйРезультат.ФИО КАК ФИО,
	|	вт_СгруппированныйРезультат.Основной КАК Основной,
	|	вт_СгруппированныйРезультат.Слияние КАК Слияние,
	|	вт_СгруппированныйРезультат.Исключение КАК Исключение,
	|	вт_СгруппированныйРезультат.Уровень КАК Уровень,
	|	вт_СгруппированныйРезультат.КоличествоСсылок КАК КоличествоСсылок
	|ПОМЕСТИТЬ ВТ_ПорцияТаблицыЗапросов
	|ИЗ
	|	&ВремТЗ КАК вт_СгруппированныйРезультат
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ПорцияТаблицыЗапросов.Клиент КАК Клиент,
	|	ВТ_ПорцияТаблицыЗапросов.ТелефонБезНомеров КАК ТелефонБезНомеров,
	|	ВТ_ПорцияТаблицыЗапросов.ФИО КАК ФИО,
	|	ВТ_ПорцияТаблицыЗапросов.Основной КАК Основной,
	|	ВТ_ПорцияТаблицыЗапросов.Слияние КАК Слияние,
	|	ВТ_ПорцияТаблицыЗапросов.Исключение КАК Исключение,
	|	ВТ_ПорцияТаблицыЗапросов.Уровень КАК Уровень,
	|	ВТ_ПорцияТаблицыЗапросов.КоличествоСсылок КАК КоличествоСсылок
	|ИЗ
	|	ВТ_ПорцияТаблицыЗапросов КАК ВТ_ПорцияТаблицыЗапросов
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВТ_ПорцияТаблицыЗапросов.ТелефонБезНомеров,
	|	ВТ_ПорцияТаблицыЗапросов.ФИО
	|ИТОГИ
	|	МАКСИМУМ(1) КАК Уровень
	|ПО
	|	ТелефонБезНомеров";	
		
	Запрос.УстановитьПараметр("ВремТЗ", ПорцияТаблицыЗапросов);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Возврат РезультатЗапроса.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	КонецЕсли;		
	
КонецФункции

#КонецОбласти
