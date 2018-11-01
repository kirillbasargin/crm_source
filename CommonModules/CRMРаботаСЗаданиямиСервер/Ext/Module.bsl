﻿
Процедура СоздатьЗаданиеНаСогласованиеЗаявки(ЗаявкаНаСделку, Проект, Ипотека, НомерЭтапаСогласования) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	ЗаданиеНаСогласование 							= БизнесПроцессы.СогласованиеЗаявкиНаСделку.СоздатьБизнесПроцесс();
	ЗаданиеНаСогласование.Заполнить(ЗаявкаНаСделку);
	ЗаданиеНаСогласование.Наименование 				= "Согласование """ + ЗаявкаНаСделку + """" + ?(Ипотека, " ипотечным специалистом ", " юристом ") + """" + Проект + """";
	ЗаданиеНаСогласование.Исполнитель				= ?(Ипотека, Справочники.РолиИсполнителей.ИпотечныеСпециалисты, Справочники.РолиИсполнителей.Юристы);
	ЗаданиеНаСогласование.ОсновнойОбъектАдресации	= Проект;
	ЗаданиеНаСогласование.Предмет					= ЗаявкаНаСделку;
	ЗаданиеНаСогласование.Автор						= ПараметрыСеанса.ТекущийПользователь;
	ЗаданиеНаСогласование.Проверяющий				= ПараметрыСеанса.ПроверяющийЗаданияПользователь;														
	ЗаданиеНаСогласование.Дата 						= ТекущаяДата();
	ЗаданиеНаСогласование.СрокИсполнения 			= КонецДня(ТекущаяДата());
	//ЗаданиеНаСогласование.НаПроверке 				= Ложь;
	ЗаданиеНаСогласование.Записать();
	ЗаданиеНаСогласование.Старт(БизнесПроцессы.СогласованиеЗаявкиНаСделку.ТочкиМаршрута[?(Ипотека, "СтартИпотечник", "СтартЮрист")]);
	
КонецПроцедуры 

Процедура ОтменитьЗаданиеНаСогласованиеЗаявки(ЗаявкаНаСделку) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);

	БП_Ссылка = БизнесПроцессы.СогласованиеЗаявкиНаСделку.ПустаяСсылка();
	
	//Отменяем запущенный бизнес процесс
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СогласованиеЗаявкиНаСделку.Ссылка КАК Ссылка
	|ИЗ
	|	БизнесПроцесс.СогласованиеЗаявкиНаСделку КАК СогласованиеЗаявкиНаСделку
	|ГДЕ
	|	СогласованиеЗаявкиНаСделку.Стартован
	|	И НЕ СогласованиеЗаявкиНаСделку.Завершен
	|	И СогласованиеЗаявкиНаСделку.Предмет = &Предмет";
	Запрос.УстановитьПараметр("Предмет", ЗаявкаНаСделку);
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка 			= РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		БП_Ссылка			= Выборка.Ссылка;
	    БП_Объект 			= БП_Ссылка.ПолучитьОбъект();
		БП_Объект.Стартован = Ложь;
		БП_Объект.Записать();
		БП_Объект.УстановитьПометкуУдаления(Истина);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(БП_Ссылка) Тогда
	
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗадачаИсполнителя.Ссылка КАК Ссылка
		|ИЗ
		|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
		|ГДЕ
		|	ЗадачаИсполнителя.БизнесПроцесс = &БизнесПроцесс";
		Запрос.УстановитьПараметр("БизнесПроцесс", БП_Ссылка);
		РезультатЗапроса = Запрос.Выполнить();
		Если НЕ РезультатЗапроса.Пустой() Тогда
			Выборка 		= РезультатЗапроса.Выбрать();
			Выборка.Следующий();
		    ЗадачаОбъект 								= Выборка.Ссылка.ПолучитьОбъект();
			ЗадачаОбъект.Выполнена 						= Истина;
			ЗадачаОбъект.СостояниеБизнесПроцесса 		= Перечисления.СостоянияБизнесПроцессов.Остановлен;
			ЗадачаОбъект.ДатаИсполнения 				= ТекущаяДата();
			ЗадачаОбъект.Записать();
			ЗадачаОбъект.УстановитьПометкуУдаления(Истина);
		КонецЕсли;
		
	КонецЕсли;	

КонецПроцедуры

Процедура СформироватьЗаписиПоСтатусуСделки(СсылкаЗаявкаНаСделку, Дата, СтатусСтрокой, АвторИзменения = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписейРС = РегистрыСведений.СтатусыСделки.СоздатьНаборЗаписей();
	НаборЗаписейРС.Отбор.Период.Установить(Дата);
	НаборЗаписейРС.Отбор.ЗаявкаНаСделку.Установить(СсылкаЗаявкаНаСделку);
	
	НоваяЗапись = НаборЗаписейРС.Добавить();
	
	НоваяЗапись.ЗаявкаНаСделку 				= СсылкаЗаявкаНаСделку;
	НоваяЗапись.Период 						= Дата;
	НоваяЗапись.Статус 						= Перечисления.СтатусыСделки[СтатусСтрокой];
	
	//<729503>, Басаргин (08.11.2017) {
	НоваяЗапись.ЗадачаИсполнителя = ПолучитьЗадачуИсполнителя(СсылкаЗаявкаНаСделку);
	//<729503> }
	
	//<792882>, Басаргин (26.03.2018) {
	Если НЕ АвторИзменения = Неопределено Тогда
		НаборЗаписейРС.ДополнительныеСвойства.Вставить("АвторИзменения", АвторИзменения);
	КонецЕсли;
	//<792882> }
	
	НаборЗаписейРС.Записать();		

	//<729503>, Басаргин (03.11.2017) {
	РегистрыСведений.РассылкаПоСогласованиюЗаявокНаСделку.ЗаписатьРассылку(СсылкаЗаявкаНаСделку, Перечисления.СтатусыСделки[СтатусСтрокой], Дата, НоваяЗапись.ЗадачаИсполнителя);
	//<729503> }
	
КонецПроцедуры

Процедура РассылкаУведомленийПоСогласованиюЗаявокНаСделку() Экспорт
	РегистрыСведений.РассылкаПоСогласованиюЗаявокНаСделку.РассылкаУведомленийПоСогласованиюЗаявокНаСделку();
КонецПроцедуры

Функция ПолучитьЗадачуИсполнителя(Предмет) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =	
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ЗадачаИсполнителя.Ссылка КАК Ссылка
	|ИЗ
	|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
	|ГДЕ
	|	НЕ ЗадачаИсполнителя.ПометкаУдаления
	|	И ЗадачаИсполнителя.Выполнена
	|	И ЗадачаИсполнителя.Предмет = &Предмет
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗадачаИсполнителя.ДатаИсполнения УБЫВ";
	
	Запрос.УстановитьПараметр("Предмет", Предмет);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда	
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();	
		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
			Возврат ВыборкаДетальныеЗаписи.Ссылка;
		КонецЕсли;
	КонецЕсли;	
	
КонецФункции

//<792882>, Басаргин (16.03.2018) {
Процедура ОбновитьЗапросПриРасторженииСделки(Сделка, ВыполнитьУдалениеЗаписиСПересчетом = Ложь) Экспорт //ЗаявкаНаСделку
	
	//<828132>, Басаргин (22.06.2018) {
	СделкаОбъект = Сделка.ПолучитьОбъект();
	Если НЕ СделкаОбъект = Неопределено Тогда
		РегистрыСведений.Взаимодействия.ЗаписатьСделку(СделкаОбъект);
	КонецЕсли;
	Если ВыполнитьУдалениеЗаписиСПересчетом Тогда
		РегистрыСведений.Взаимодействия.ВыполнитьУдалениеЗаписиСПересчетом(СделкаОбъект.Ссылка);
	КонецЕсли;
	//<828132> }	
		
	//ЗапросСсылка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗаявкаНаСделку, "ДокументОснование");	
	//Если ЗначениеЗаполнено(ЗапросСсылка) Тогда
	//	ЗапросОбъект = ЗапросСсылка.ПолучитьОбъект();
	//	Если НЕ ЗапросОбъект = Неопределено Тогда
	//		ЗапросОбъект.Стадия = Перечисления.СтадииЗапроса.Переговоры;
	//		ЗапросОбъект.Статус = Перечисления.СтатусыЗапроса.Отказ;
	//		ЗапросОбъект.РасшифровкаСтатуса = Справочники.ПричиныСтатусовЗапроса.РасторжениеСделки;
	//		ЗапросОбъект.ДополнительныеСвойства.Вставить("СистемноеПроведение", Истина);
	//		ЗапросОбъект.ДополнительныеСвойства.Вставить("АвторВерсии", Справочники.Пользователи.Робот);
	//		//ЗапросОбъект.ОбменДанными.Загрузка = Истина;			
	//		Попытка
	//			ЗапросОбъект.Записать(РежимЗаписиДокумента.Проведение);
	//		Исключение
	//			ЗаписьЖурналаРегистрации("ОбновитьЗапросПриРасторженииСделки", 
	//				УровеньЖурналаРегистрации.Ошибка, 
	//				Метаданные.Документы.Запрос, 
	//				ЗапросОбъект.Ссылка,
	//				"При обновлении запроса по растроженной сделке произошла ошибка: " + ОписаниеОшибки());				
	//		КонецПопытки;		
	//	КонецЕсли;
	//КонецЕсли;		
	
КонецПроцедуры
//<792882> }

//<804013>, Басаргин (10.04.2018) {
Процедура УдалениеДублейКлиентовРегламентно() Экспорт
		
	ДеревоКлиентов = Обработки.СлияниеДублейКлиентов.ЗаполнитьДеревоДублей();	
	Если НЕ ДеревоКлиентов = Неопределено И ДеревоКлиентов.Строки.Количество() Тогда
		Обработки.СлияниеДублейКлиентов.ОбработатьКлиентовРегламентно(ДеревоКлиентов);
	КонецЕсли;	
		
КонецПроцедуры

Процедура УдалениеДублейКлиентов(ДеревоКлиентов) Экспорт
	
	Если НЕ ДеревоКлиентов = Неопределено И ДеревоКлиентов.Строки.Количество() Тогда
		Обработки.СлияниеДублейКлиентов.ОбработатьКлиентов(ДеревоКлиентов);
	КонецЕсли;
	
КонецПроцедуры
//<804013> }

//<804027>, Басаргин (10.04.2018) {
Процедура УдалениеДублейЗапросовРегламентно() Экспорт
	
	ДеревоДублейЗапросов = Обработки.СлияниеДублейЗапросов.ПолучитьДеревоДублейЗапросов();	
	Если НЕ ДеревоДублейЗапросов = Неопределено И ДеревоДублейЗапросов.Строки.Количество() Тогда
		Обработки.СлияниеДублейЗапросов.ОбработатьЗапросыРегламентно(ДеревоДублейЗапросов);
	КонецЕсли;	
		
КонецПроцедуры

Процедура УдалениеДублейЗапросов(ТаблицаЗапросов) Экспорт
	
	Если НЕ ТаблицаЗапросов = Неопределено И ТаблицаЗапросов.Строки.Количество() Тогда
		Обработки.СлияниеДублейЗапросов.ОбработатьЗапросы(ТаблицаЗапросов);
	КонецЕсли;
	
КонецПроцедуры
//<804027> }

//<814510>, Басаргин (04.05.2018) {
&НаСервере
Процедура ВыполнитьЗаполнениеРегистраНаСервере(НачалоПериода, КонецПериода, Предмет, ВыбратьПервые = 0) Экспорт
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 100
	|	0 КАК Уровень,
	|	Запрос.Ссылка КАК Ссылка,
	|	Взаимодействия.ДатаВзаимодействия КАК ДатаВзаимодействия,
	|	Взаимодействия.Ответственный КАК Ответственный,
	|	ЕСТЬNULL(ДокументЗаявкаНаСделку.Ответственный, ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)) КАК ОтветственныйЗаявкиНаСделку,
	|	ЕСТЬNULL(Сделки.ДатаСозданияСделки, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаСозданияСделки,
	|	ВЫБОР
	|		КОГДА Взаимодействия.ГруппаОтветственного = &ГруппаГПТ
	|				И Взаимодействия.ТипВзаимодействия = ЗНАЧЕНИЕ(Перечисление.ТипыВзаимодействий.ТелефонныйЗвонок)
	|				И Взаимодействия.АктивностьВзаимодействия = ЗНАЧЕНИЕ(Перечисление.ТипАктивностиВзаимодействия.Первичное)
	|				И Взаимодействия.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыВзаимодействий.Завершено)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтадииЗапроса.Звонок)
	|		КОГДА Взаимодействия.ГруппаОтветственного В (&ГруппыВстреч)
	|				И Взаимодействия.ТипВзаимодействия = ЗНАЧЕНИЕ(Перечисление.ТипыВзаимодействий.Встреча)
	|				И Взаимодействия.АктивностьВзаимодействия = ЗНАЧЕНИЕ(Перечисление.ТипАктивностиВзаимодействия.Первичное)
	|				И Взаимодействия.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыВзаимодействий.Завершено)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтадииЗапроса.Переговоры)
	|		КОГДА НЕ ДокументЗаявкаНаСделку.Ссылка ЕСТЬ NULL
	|				И НЕ ЕСТЬNULL(Сделки.СтатусСделки, ЗНАЧЕНИЕ(Перечисление.СтатусыСделокСправочник.ПустаяСсылка)) = ЗНАЧЕНИЕ(Перечисление.СтатусыСделокСправочник.Расторгнута)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтадииЗапроса.Сделка)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.СтадииЗапроса.ПустаяСсылка)
	|	КОНЕЦ КАК СтадияЗапроса,
	|	Взаимодействия.Взаимодействие КАК Взаимодействие,
	|	Запрос.Статус КАК Статус,
	|	Запрос.РасшифровкаСтатуса КАК РасшифровкаСтатуса
	|ПОМЕСТИТЬ ВТ_ИсходныеДанные
	|ИЗ
	|	Документ.Запрос КАК Запрос
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.Взаимодействия КАК Взаимодействия
	|		ПО (Взаимодействия.Предмет = Запрос.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаявкаНаСделку КАК ДокументЗаявкаНаСделку
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Сделки КАК Сделки
	|			ПО ДокументЗаявкаНаСделку.Ссылка = Сделки.ЗаявкаНаСделку
	|		ПО Запрос.Ссылка = ДокументЗаявкаНаСделку.ДокументОснование
	|ГДЕ
	|	НЕ Запрос.ПометкаУдаления
	|	И Запрос.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|	И Запрос.Ссылка = &Запрос
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ИсходныеДанные.Уровень КАК Уровень,
	|	ВТ_ИсходныеДанные.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА ВТ_ИсходныеДанные.СтадияЗапроса = ЗНАЧЕНИЕ(Перечисление.СтадииЗапроса.Сделка)
	|			ТОГДА ВТ_ИсходныеДанные.ДатаСозданияСделки
	|		ИНАЧЕ ВТ_ИсходныеДанные.ДатаВзаимодействия
	|	КОНЕЦ КАК ДатаВзаимодействия,
	|	ВЫБОР
	|		КОГДА ВТ_ИсходныеДанные.СтадияЗапроса = ЗНАЧЕНИЕ(Перечисление.СтадииЗапроса.Сделка)
	|			ТОГДА ВТ_ИсходныеДанные.ОтветственныйЗаявкиНаСделку
	|		ИНАЧЕ ВТ_ИсходныеДанные.Ответственный
	|	КОНЕЦ КАК Ответственный,
	|	ВТ_ИсходныеДанные.СтадияЗапроса КАК СтадияЗапроса,
	|	ВТ_ИсходныеДанные.Взаимодействие КАК Взаимодействие,
	|	ВТ_ИсходныеДанные.Статус КАК Статус,
	|	ВТ_ИсходныеДанные.РасшифровкаСтатуса КАК РасшифровкаСтатуса
	|ИЗ
	|	ВТ_ИсходныеДанные КАК ВТ_ИсходныеДанные
	|ГДЕ
	|	НЕ ВТ_ИсходныеДанные.СтадияЗапроса = ЗНАЧЕНИЕ(Перечисление.СтадииЗапроса.ПустаяСсылка)
	|ИТОГИ
	|	1 КАК Уровень
	|ПО
	|	Ссылка";	
	
	Если НЕ ЗначениеЗаполнено(Предмет) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И Запрос.Ссылка = &Запрос", "");
		Если ЗначениеЗаполнено(НачалоПериода) И ЗначениеЗаполнено(КонецПериода) Тогда
			Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
			Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);		
		Иначе
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "И Запрос.Дата МЕЖДУ &НачалоПериода И &КонецПериода", "");
		КонецЕсли;	
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И Запрос.Дата МЕЖДУ &НачалоПериода И &КонецПериода", "");
		Запрос.УстановитьПараметр("Запрос", Предмет);
	КонецЕсли;
		
	Если ВыбратьПервые = 0 Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПЕРВЫЕ 100", "");
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПЕРВЫЕ 100", "ПЕРВЫЕ " + Формат(ВыбратьПервые, "ЧГ=0"));
	КонецЕсли;
	
	ГруппыВстреч = Новый Массив;
	ГруппыВстреч.Добавить(Справочники.ГруппыПользователей.НайтиПоНаименованию("Филиал"));
	ГруппыВстреч.Добавить(Справочники.ГруппыПользователей.НайтиПоНаименованию("Земля опт"));
	ГруппыВстреч.Добавить(Справочники.ГруппыПользователей.НайтиПоНаименованию("Земля розница"));
	ГруппыВстреч.Добавить(Справочники.ГруппыПользователей.НайтиПоНаименованию("Коммерческая Недвижимость"));
	ГруппыВстреч.Добавить(Справочники.ГруппыПользователей.НайтиПоНаименованию("Центральный офис"));
	
	Запрос.УстановитьПараметр("ГруппаГПТ", 	Справочники.ГруппыПользователей.НайтиПоНаименованию("ГПТ", Истина));
	Запрос.УстановитьПараметр("ГруппыВстреч", ГруппыВстреч);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ДеревоЗначений = РезультатЗапроса.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);	
	
	ЧислоСтрокВТаблице = ДеревоЗначений.Строки.Количество();
	
	Если ЧислоСтрокВТаблице = 1 Тогда 
		ВыполнитьЗаписиСтадийЗапросов(ДеревоЗначений);	
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
			
			ПорцияДереваКлиентов = ПодготовитьПорциюДереваЗначений(ДеревоЗначений, ИндексНачала, РазмерПорции);
			НаборПараметров = Новый Массив;
			НаборПараметров.Добавить(ПорцияДереваКлиентов);	
			
			Задание = ФоновыеЗадания.Выполнить("CRMРаботаСЗаданиямиСервер.ВыполнитьЗаписиСтадийЗапросов", НаборПараметров, "Обработка по созданию стадий запросов в отдельном потоке - " + НомерПотока, "ВыполнитьЗаписиСтадийЗапросов");		
			МассивЗаданий.Добавить(Задание);
			
			Если ЧислоСтрокВТаблице <= НомерПотока Тогда
				Прервать;
			КонецЕсли;		
		КонецЦикла;	
		
	    Если МассивЗаданий.Количество() > 0 Тогда
	        Попытка
	            ФоновыеЗадания.ОжидатьЗавершения(МассивЗаданий);
			Исключение
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка выполнения задания ВыполнитьЗаписиСтадийЗапросов: " + ОписаниеОшибки());
				Возврат;
			КонецПопытки;        
	    КонецЕсли;	
	КонецЕсли;	
	
КонецПроцедуры

Процедура ВыполнитьЗаписиСтадийЗапросов(ДеревоЗначений) Экспорт
	
	ОценкаПроизводительностиСуществует = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОценкаПроизводительности");
	Если ОценкаПроизводительностиСуществует Тогда
		МодульОценкаПроизводительности = ОбщегоНазначения.ОбщийМодуль("ОценкаПроизводительности");
		ВремяНачала = МодульОценкаПроизводительности.НачатьЗамерВремени();
	КонецЕсли;			
	
	Для каждого СтрокаГруппировки Из ДеревоЗначений.Строки Цикл	
		
		СтрокиЗвонок = СтрокаГруппировки.Строки.НайтиСтроки(Новый Структура("СтадияЗапроса", Перечисления.СтадииЗапроса.Звонок));	
		Если СтрокиЗвонок.Количество() Тогда			
			ВыборкаДетальныеЗаписи = СтрокиЗвонок[0];
			
			НаборЗаписей = РегистрыСведений.ИзменениеСтатусаСтадииЗапроса.СоздатьНаборЗаписей();			
			НаборЗаписей.Отбор.Период.Установить(ВыборкаДетальныеЗаписи.ДатаВзаимодействия);
			НаборЗаписей.Отбор.Запрос.Установить(ВыборкаДетальныеЗаписи.Ссылка);			
			НаборЗаписей.Прочитать();
			
			Если НЕ НаборЗаписей.Количество() Тогда
				НоваяЗапись = НаборЗаписей.Добавить();
				НоваяЗапись.Период = ВыборкаДетальныеЗаписи.ДатаВзаимодействия;
				НоваяЗапись.Запрос = ВыборкаДетальныеЗаписи.Ссылка;
				НоваяЗапись.Стадия = ВыборкаДетальныеЗаписи.СтадияЗапроса;
				//НоваяЗапись.Статус = ВыборкаДетальныеЗаписи.Статус;
				//НоваяЗапись.РасшифровкаСтатуса = ВыборкаДетальныеЗаписи.РасшифровкаСтатуса;
				НоваяЗапись.ДокументВзаимодействия = ВыборкаДетальныеЗаписи.Взаимодействие;
				НоваяЗапись.Ответственный = ВыборкаДетальныеЗаписи.Ответственный;
				
				НаборЗаписей.Записать();
			КонецЕсли;
		КонецЕсли;
		
		СтрокиПереговоры = СтрокаГруппировки.Строки.НайтиСтроки(Новый Структура("СтадияЗапроса", Перечисления.СтадииЗапроса.Переговоры));	
		Если СтрокиПереговоры.Количество() Тогда			
			ВыборкаДетальныеЗаписи = СтрокиПереговоры[0];
			
			НаборЗаписей = РегистрыСведений.ИзменениеСтатусаСтадииЗапроса.СоздатьНаборЗаписей();			
			НаборЗаписей.Отбор.Период.Установить(ВыборкаДетальныеЗаписи.ДатаВзаимодействия);
			НаборЗаписей.Отбор.Запрос.Установить(ВыборкаДетальныеЗаписи.Ссылка);			
			НаборЗаписей.Прочитать();
			
			Если НЕ НаборЗаписей.Количество() Тогда
				НоваяЗапись = НаборЗаписей.Добавить();
				НоваяЗапись.Период = ВыборкаДетальныеЗаписи.ДатаВзаимодействия;
				НоваяЗапись.Запрос = ВыборкаДетальныеЗаписи.Ссылка;
				НоваяЗапись.Стадия = ВыборкаДетальныеЗаписи.СтадияЗапроса;
				//НоваяЗапись.Статус = ВыборкаДетальныеЗаписи.Статус;
				//НоваяЗапись.РасшифровкаСтатуса = ВыборкаДетальныеЗаписи.РасшифровкаСтатуса;
				НоваяЗапись.ДокументВзаимодействия = ВыборкаДетальныеЗаписи.Взаимодействие;
				НоваяЗапись.Ответственный = ВыборкаДетальныеЗаписи.Ответственный;
				
				НаборЗаписей.Записать();
			КонецЕсли;
		КонецЕсли;
		
		СтрокиСделка = СтрокаГруппировки.Строки.НайтиСтроки(Новый Структура("СтадияЗапроса", Перечисления.СтадииЗапроса.Сделка));	
		Если СтрокиСделка.Количество() Тогда			
			ВыборкаДетальныеЗаписи = СтрокиСделка[0];
			
			НаборЗаписей = РегистрыСведений.ИзменениеСтатусаСтадииЗапроса.СоздатьНаборЗаписей();			
			НаборЗаписей.Отбор.Период.Установить(ВыборкаДетальныеЗаписи.ДатаВзаимодействия);
			НаборЗаписей.Отбор.Запрос.Установить(ВыборкаДетальныеЗаписи.Ссылка);			
			НаборЗаписей.Прочитать();
			
			Если НЕ НаборЗаписей.Количество() Тогда
				НоваяЗапись = НаборЗаписей.Добавить();
				НоваяЗапись.Период = ВыборкаДетальныеЗаписи.ДатаВзаимодействия;
				НоваяЗапись.Запрос = ВыборкаДетальныеЗаписи.Ссылка;
				НоваяЗапись.Стадия = ВыборкаДетальныеЗаписи.СтадияЗапроса;
				//НоваяЗапись.Статус = ВыборкаДетальныеЗаписи.Статус;
				//НоваяЗапись.РасшифровкаСтатуса = ВыборкаДетальныеЗаписи.РасшифровкаСтатуса;
				//НоваяЗапись.ДокументВзаимодействия = ВыборкаДетальныеЗаписи.Взаимодействие; //?
				НоваяЗапись.Ответственный = ВыборкаДетальныеЗаписи.Ответственный;
				
				НаборЗаписей.Записать();
			КонецЕсли;
		КонецЕсли;
		
		ОбновитьДанныеЗапроса(СтрокаГруппировки.Ссылка);
				
	КонецЦикла;
		
	Если ОценкаПроизводительностиСуществует Тогда
		МодульОценкаПроизводительности.ЗакончитьЗамерВремени("ВыполнитьЗаписиСтадийЗапросов", ВремяНачала);
	КонецЕсли;	
		
КонецПроцедуры	

Функция ПодготовитьПорциюДереваЗначений(Знач ДеревоЗначений, ИндексНачала, РазмерПорции) Экспорт
	
	ПорцияДереваКлиентов = ДеревоЗначений.Скопировать();
	ПорцияДереваКлиентов.Строки.Очистить();
	
	Для Сч = 1 По РазмерПорции Цикл
		Индекс = ?(Сч = 1, ИндексНачала, Индекс + 1);
		СтрокаПорции = ПорцияДереваКлиентов.Строки.Добавить();
		РекурсивноеДобавлениеНайденногоУзла(СтрокаПорции, ДеревоЗначений.Строки[Индекс]);		
	КонецЦикла;
	
	Возврат ПорцияДереваКлиентов;
	
КонецФункции

Процедура РекурсивноеДобавлениеНайденногоУзла(Получатель, Источник) Экспорт 
	
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

Процедура ОбновитьДанныеЗапроса(ЗапросСсылка) 
	
	ДокОбъект = ЗапросСсылка.ПолучитьОбъект();
	Если ДокОбъект = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Стадия = ПолучитьАктуальнуюСтадию(ЗапросСсылка);
	Если НЕ ЗначениеЗаполнено(Стадия) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ДокОбъект.Стадия = Стадия;
	ДокОбъект.ОбменДанными.Загрузка = Истина;
 	ДокОбъект.ДополнительныеСвойства.Вставить("ПропуститьЗаписьВерсииОбъекта");
	ДокОбъект.ДополнительныеСвойства.Вставить("СистемноеПроведение", Истина);
	ДокОбъект.Проведен = Истина;
	ДокОбъект.Записать(РежимЗаписиДокумента.Запись);
	
	ВыполнитьДвиженияПоРегиструПараметрыЗапроса(ДокОбъект);
	ВыполнитьДвиженияПоРегиструПараметрыЗапросаЛинейно(ДокОбъект);
	ВыполнитьДвиженияПоИсторииСтадийСтатусов(ДокОбъект);
	
	ДокОбъект.Движения.Записать();
	
КонецПроцедуры

Функция ПолучитьАктуальнуюСтадию(ЗапросСсылка)
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИзменениеСтатусаСтадииЗапросаСрезПоследних.Стадия КАК Стадия,
	|	ИзменениеСтатусаСтадииЗапросаСрезПоследних.Статус КАК Статус,
	|	ИзменениеСтатусаСтадииЗапросаСрезПоследних.РасшифровкаСтатуса КАК РасшифровкаСтатуса
	|ИЗ
	|	РегистрСведений.ИзменениеСтатусаСтадииЗапроса.СрезПоследних(, Запрос = &Запрос) КАК ИзменениеСтатусаСтадииЗапросаСрезПоследних";
	
	Запрос.УстановитьПараметр("Запрос", ЗапросСсылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.Стадия;
	КонецЕсли;
	
КонецФункции

#Область ДвиженияПоЗапросу

Процедура ВыполнитьДвиженияПоРегиструПараметрыЗапросаЛинейно(ЭтотОбъект)
	
	Движение = ЭтотОбъект.Движения.ПараметрыЗапросаЛинейный.Добавить();
	ЗаполнитьЗначенияСвойств(Движение, ЭтотОбъект);
	Движение.Запрос = ЭтотОбъект.Ссылка;
	ЭтотОбъект.Движения.ПараметрыЗапросаЛинейный.Записывать = Истина;
	
КонецПроцедуры

Процедура ВыполнитьДвиженияПоРегиструПараметрыЗапроса(ЭтотОбъект)
	
	ТаблицаПоПараметрамЗапроса = ЭтотОбъект.Движения.ПараметрыЗапроса.ВыгрузитьКолонки();
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПараметрыЗапроса.ИмяПредопределенныхДанных КАК ИмяРеквизита,
	|	ПараметрыЗапроса.ИспользоватьВсегда КАК ИспользоватьВсегда,
	|	ПараметрыЗапроса.Ссылка КАК Параметр
	|ИЗ
	|	Справочник.ПараметрыЗапроса КАК ПараметрыЗапроса
	|ГДЕ
	|	НЕ ПараметрыЗапроса.ПометкаУдаления";
	РезультатЗапроса 	= Запрос.Выполнить();
	ВыборкаРеквизитов 	= РезультатЗапроса.Выгрузить();	
	
	РеквизитыДокумента 		= ЭтотОбъект.Метаданные().Реквизиты;
	ТабличныеЧастиДокумента = ЭтотОбъект.Метаданные().ТабличныеЧасти;
	
	Для Каждого РеквизитДокумента Из РеквизитыДокумента Цикл			
		СформироватьЗаписьПоПараметрам(ЭтотОбъект, РеквизитДокумента, ТаблицаПоПараметрамЗапроса, ВыборкаРеквизитов);
	КонецЦикла;	
	
	Для Каждого ТЧДокумента Из ТабличныеЧастиДокумента Цикл	
		СформироватьЗаписиПоТабличнымЧастям(ЭтотОбъект, ТЧДокумента, ТаблицаПоПараметрамЗапроса, ВыборкаРеквизитов);
	КонецЦикла;	
	
	Если ТаблицаПоПараметрамЗапроса.Количество() > 0 Тогда
		
		ТаблицаПоПараметрамЗапроса.ЗаполнитьЗначения(ЭтотОбъект.Дата, "Период");
		ЭтотОбъект.Движения.ПараметрыЗапроса.Загрузить(ТаблицаПоПараметрамЗапроса);
		ЭтотОбъект.Движения.ПараметрыЗапроса.Записывать = Истина;		
	
	КонецЕсли;
		
КонецПроцедуры

Процедура СформироватьЗаписьПоПараметрам(ЭтотОбъект, РеквизитДокумента, ТаблицаПоПараметрамЗапроса, ВыборкаРеквизитов)

	ЗначениеРеквизитаДокумента 	= ЭтотОбъект[РеквизитДокумента.Имя];
	СтрокаТаблицыПараметров 	= ВыборкаРеквизитов.Найти(РеквизитДокумента.Имя);
	
	Если СтрокаТаблицыПараметров = Неопределено Тогда
		Возврат;	
	КонецЕсли;
	
	Если ТипЗнч(ЗначениеРеквизитаДокумента) = Тип("Булево") Тогда
		ДобавитьНовуюСтрокуВТаблицуПараметров(ТаблицаПоПараметрамЗапроса, ЗначениеРеквизитаДокумента, СтрокаТаблицыПараметров, "ЗначениеБулево");	
	ИначеЕсли ТипЗнч(ЗначениеРеквизитаДокумента) = Тип("Число") Тогда
		ДобавитьНовуюСтрокуВТаблицуПараметров(ТаблицаПоПараметрамЗапроса, ЗначениеРеквизитаДокумента, СтрокаТаблицыПараметров, "ЗначениеЧисло");	
	Иначе
		ДобавитьНовуюСтрокуВТаблицуПараметров(ТаблицаПоПараметрамЗапроса, ЗначениеРеквизитаДокумента, СтрокаТаблицыПараметров, "ЗначениеСсылка");
	КонецЕсли;				

КонецПроцедуры

Процедура СформироватьЗаписиПоТабличнымЧастям(ЭтотОбъект, ТЧДокумента, ТаблицаПоПараметрамЗапроса, ВыборкаРеквизитов)

	ТабличнаяЧастьДокумента 	= ЭтотОбъект[ТЧДокумента.Имя];
	СтрокаТаблицыПараметров 	= ВыборкаРеквизитов.Найти(ТЧДокумента.Имя);
	
	Если СтрокаТаблицыПараметров = Неопределено Тогда
		Возврат;	
	КонецЕсли;
	
	Для Каждого РеквизитТабличнойЧасти Из ТЧДокумента.Реквизиты Цикл
	
		СтрокаТаблицыПараметровДляТЧ 	= ВыборкаРеквизитов.Найти(РеквизитТабличнойЧасти.Имя);
		
		Если СтрокаТаблицыПараметровДляТЧ = Неопределено Тогда
			Продолжить;	
		КонецЕсли;
		
		НомерСтроки = 0;
		Для Каждого СтрокаТЧ Из ТабличнаяЧастьДокумента Цикл
			ДобавитьНовуюСтрокуВТаблицуПараметров(ТаблицаПоПараметрамЗапроса, 
													СтрокаТЧ[РеквизитТабличнойЧасти.Имя], 
													СтрокаТаблицыПараметровДляТЧ, 
													"ЗначениеСсылка", 
													НомерСтроки);
			НомерСтроки = НомерСтроки + 1;
		КонецЦикла;		
			
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьНовуюСтрокуВТаблицуПараметров(ТаблицаПоПараметрамЗапроса, 
													ЗначениеРеквизитаДокумента, 
													СтрокаТаблицыПараметров, 
													ИмяКолонки, 
													НомерСтроки = 0)

	Если СтрокаТаблицыПараметров.ИспользоватьВсегда 
			ИЛИ (?(ТипЗнч(ЗначениеРеквизитаДокумента) = Тип("Булево"), ЗначениеРеквизитаДокумента, Истина) 
					И ЗначениеЗаполнено(ЗначениеРеквизитаДокумента)) Тогда
		
		НоваяСтрокаТЗ 					= ТаблицаПоПараметрамЗапроса.Добавить();
		НоваяСтрокаТЗ.НомерПараметра	= НомерСтроки;
		НоваяСтрокаТЗ.Параметр			= СтрокаТаблицыПараметров.Параметр; 
		НоваяСтрокаТЗ[ИмяКолонки]		= ЗначениеРеквизитаДокумента;
			
	КонецЕсли;	

КонецПроцедуры

Процедура ВыполнитьДвиженияПоИсторииСтадийСтатусов(ЭтотОбъект)
	
	Ссылка = ЭтотОбъект.Ссылка;
	Стадия = ЭтотОбъект.Стадия;
	Статус = ЭтотОбъект.Статус;
	РасшифровкаСтатуса = ЭтотОбъект.РасшифровкаСтатуса;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИзменениеСтатусаСтадииЗапросаСрезПоследних.Стадия КАК Стадия,
	|	ИзменениеСтатусаСтадииЗапросаСрезПоследних.Статус КАК Статус,
	|	ИзменениеСтатусаСтадииЗапросаСрезПоследних.РасшифровкаСтатуса КАК РасшифровкаСтатуса
	|ИЗ
	|	РегистрСведений.ИзменениеСтатусаСтадииЗапроса.СрезПоследних(, Запрос = &Запрос) КАК ИзменениеСтатусаСтадииЗапросаСрезПоследних
	|ГДЕ
	|	(ИзменениеСтатусаСтадииЗапросаСрезПоследних.Стадия <> &Стадия
	|			ИЛИ ИзменениеСтатусаСтадииЗапросаСрезПоследних.Статус <> &Статус
	|			ИЛИ ИзменениеСтатусаСтадииЗапросаСрезПоследних.РасшифровкаСтатуса <> &РасшифровкаСтатуса)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИзменениеСтатусаСтадииЗапроса.Запрос КАК Запрос
	|ИЗ
	|	РегистрСведений.ИзменениеСтатусаСтадииЗапроса КАК ИзменениеСтатусаСтадииЗапроса
	|ГДЕ
	|	ИзменениеСтатусаСтадииЗапроса.Запрос = &Запрос";
	Запрос.УстановитьПараметр("Запрос", 			Ссылка);
	Запрос.УстановитьПараметр("Стадия", 			Стадия);
	Запрос.УстановитьПараметр("Статус", 			Статус);
	Запрос.УстановитьПараметр("РасшифровкаСтатуса", РасшифровкаСтатуса);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Если НЕ РезультатЗапроса[0].Пустой()
			ИЛИ РезультатЗапроса[1].Пустой() Тогда
		
		Период 	= ТекущаяДата();		
		НаборЗаписей = РегистрыСведений.ИзменениеСтатусаСтадииЗапроса.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Период.Установить(Период);
		НаборЗаписей.Отбор.Запрос.Установить(Ссылка);
		
		НоваяЗапись = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяЗапись, Ссылка);
		НоваяЗапись.Период = Период;
		НоваяЗапись.Запрос = Ссылка;
		
		НаборЗаписей.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

//<814510> }

//<821883>, Басаргин (28.05.2018) {
Процедура ИсправлениеКонтактнойИнформации() Экспорт
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Клиенты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Клиенты КАК Клиенты
	|ГДЕ
	|	НЕ Клиенты.ПометкаУдаления
	|	И НЕ Клиенты.ЭтоГруппа";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаКлиентов = РезультатЗапроса.Выгрузить();
		
	ЧислоСтрокВТаблице = ТаблицаКлиентов.Количество(); 
		
	ЧислоПотоков = 10;		
	РазмерПорции = Цел(ЧислоСтрокВТаблице / ЧислоПотоков);	
	РазмерПорции = ?(РазмерПорции = 0, 1 , РазмерПорции);
	МассивЗаданий = Новый Массив;

	Для НомерПотока = 1 По ЧислоПотоков Цикл 		
		ИндексНачала = (НомерПотока - 1) * РазмерПорции;		
		Если (НомерПотока = ЧислоПотоков) Тогда
			РазмерПорции = ЧислоСтрокВТаблице - (ЧислоПотоков * РазмерПорции) + РазмерПорции;			
		КонецЕсли;  
		
		ПорцияТаблицыКлиентов = ПодготовитьПорциюТаблицыКлиентов(ТаблицаКлиентов, ИндексНачала, РазмерПорции); 
		НаборПараметров = Новый Массив;
		НаборПараметров.Добавить(ПорцияТаблицыКлиентов);	
		
		Задание = ФоновыеЗадания.Выполнить("CRMРаботаСЗаданиямиСервер.ИсправитьКонтактнуюИнформациюВФоне", НаборПараметров, "Исправление контактной информации в отдельном потоке -  - " + НомерПотока, "ИсправитьКонтактнуюИнформациюВФоне");		
		МассивЗаданий.Добавить(Задание);
		
		Если ЧислоСтрокВТаблице <= НомерПотока Тогда
			Прервать;
		КонецЕсли;		
	КонецЦикла;	
	
    Если МассивЗаданий.Количество() > 0 Тогда
        Попытка
            ФоновыеЗадания.ОжидатьЗавершения(МассивЗаданий);
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка выполнения задания ИсправитьКонтактнуюИнформациюВФоне: " + ОписаниеОшибки());
			Возврат;
		КонецПопытки;        
    КонецЕсли;		
	
КонецПроцедуры

Процедура ИсправитьКонтактнуюИнформациюВФоне(ПорцияТаблицыКлиентов) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Для каждого Строка Из ПорцияТаблицыКлиентов Цикл
		ОбработатьКлиента(Строка.Ссылка);	
	КонецЦикла;
	
КонецПроцедуры

Функция ПодготовитьПорциюТаблицыКлиентов(Знач ТаблицаКлиентов, ИндексНачала, РазмерПорции)
	
	ПорцияТаблицыйКлиентов = ТаблицаКлиентов.Скопировать();
	ПорцияТаблицыйКлиентов.Очистить();
	
	Для Сч = 1 По РазмерПорции Цикл
		Индекс = ?(Сч = 1, ИндексНачала, Индекс + 1);
		СтрокаПорции = ПорцияТаблицыйКлиентов.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаПорции, ТаблицаКлиентов[Индекс]);	
	КонецЦикла;
	
	Возврат ПорцияТаблицыйКлиентов; 
		
КонецФункции

Процедура ОбработатьКлиента(Клиент) Экспорт
	
	УчастникОбъект = Клиент.ПолучитьОбъект();	
	
	Если НЕ УчастникОбъект = Неопределено Тогда
		Записывать = Ложь;
		МассивСтрокНаУдаление = Новый Массив;
		Для каждого СтрокаТабличнойЧасти Из УчастникОбъект.КонтактнаяИнформация Цикл					
			Если НЕ СтрокаТабличнойЧасти.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон
				И (СтрокаТабличнойЧасти.Вид = Справочники.ВидыКонтактнойИнформации.ОсновнойТелефонКлиента
				ИЛИ СтрокаТабличнойЧасти.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонКлиента) Тогда
				Продолжить;	
			КонецЕсли;				
			
			//<847271>, Басаргин (18.07.2018) {
			НомерТелефона = УправлениеТелефониейКлиентСервер.ФорматироватьТелефон(УправлениеТелефониейКлиентСервер.ТолькоДопустимыеСимволыНомера(СтрокаТабличнойЧасти.НомерТелефона));
			Если СтрДлина(НомерТелефона) < 5 Тогда
				МассивСтрокНаУдаление.Добавить(СтрокаТабличнойЧасти);
				Продолжить;
			КонецЕсли;
			
			СтрокаТабличнойЧасти.НомерТелефона = НомерТелефона;
			СтрокаТабличнойЧасти.НомерТелефонаБезКодов = Прав(СтрокаТабличнойЧасти.НомерТелефона, 7); 
			СтрокаТабличнойЧасти.Представление = УправлениеТелефониейКлиентСервер.ПривестиТелефонКВиду(СтрокаТабличнойЧасти.НомерТелефона); 
			КонтактнаяИнформацияXDTO = УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияXDTOПоПредставлению(СтрокаТабличнойЧасти.Представление, СтрокаТабличнойЧасти.Вид);
			СтрокаТабличнойЧасти.ЗначенияПолей = УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияXDTOВXML(КонтактнаяИнформацияXDTO);
			Записывать = Истина;
			//<847271> }

			Результат = СтрокаТабличнойЧасти.НомерТелефона;				
			Если НЕ СтрокаТабличнойЧасти.НомерТелефонаБезКодов = Прав(Результат, 7) Тогда
				СтрокаТабличнойЧасти.НомерТелефонаБезКодов = Прав(Результат, 7);				
				КонтактнаяИнформацияXDTO = УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияXDTOПоПредставлению(СтрокаТабличнойЧасти.Представление, СтрокаТабличнойЧасти.Вид);
				СтрокаТабличнойЧасти.ЗначенияПолей = УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияXDTOВXML(КонтактнаяИнформацияXDTO);
				Записывать = Истина;
			КонецЕсли;
						
		КонецЦикла;
		
		//<847271>, Басаргин (18.07.2018) {		
		Для каждого НайденнаяСтрока Из МассивСтрокНаУдаление Цикл
			УчастникОбъект.КонтактнаяИнформация.Удалить(НайденнаяСтрока);
			Записывать = Истина;				
		КонецЦикла;
		
		Если ЗначениеЗаполнено(УчастникОбъект.ОсновнойТелефон) Тогда			
			НайденныеСтроки = УчастникОбъект.КонтактнаяИнформация.НайтиСтроки(Новый Структура("Вид, Тип", Справочники.ВидыКонтактнойИнформации.ОсновнойТелефонКлиента, Перечисления.ТипыКонтактнойИнформации.Телефон)); 			
			Если НЕ НайденныеСтроки.Количество() Тогда
				НомерТелефона = УправлениеТелефониейКлиентСервер.ФорматироватьТелефон(УправлениеТелефониейКлиентСервер.ТолькоДопустимыеСимволыНомера(УчастникОбъект.ОсновнойТелефон));
				Если НЕ СтрДлина(НомерТелефона) < 5 Тогда
					СтрокаТабличнойЧасти = УчастникОбъект.КонтактнаяИнформация.Добавить();
					СтрокаТабличнойЧасти.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон;
					СтрокаТабличнойЧасти.Вид = Справочники.ВидыКонтактнойИнформации.ОсновнойТелефонКлиента;
					СтрокаТабличнойЧасти.НомерТелефона = НомерТелефона;
					СтрокаТабличнойЧасти.НомерТелефонаБезКодов = Прав(СтрокаТабличнойЧасти.НомерТелефона, 7); 
					СтрокаТабличнойЧасти.Представление = УправлениеТелефониейКлиентСервер.ПривестиТелефонКВиду(СтрокаТабличнойЧасти.НомерТелефона); 
					КонтактнаяИнформацияXDTO = УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияXDTOПоПредставлению(СтрокаТабличнойЧасти.Представление, СтрокаТабличнойЧасти.Вид);
					СтрокаТабличнойЧасти.ЗначенияПолей = УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияXDTOВXML(КонтактнаяИнформацияXDTO);
					Записывать = Истина;
				КонецЕсли;
			КонецЕсли;																													
		КонецЕсли;		
		//<847271> }
		
		ПервыйСимвол = Лев(УчастникОбъект.ФИО, 1);
		ПоследнийСимвол = Прав(УчастникОбъект.ФИО, 1);
		Если ПервыйСимвол = " " ИЛИ ПоследнийСимвол = "" Тогда
			УчастникОбъект.ФИО = СокрЛП(УчастникОбъект.ФИО);
			Записывать = Истина;
		КонецЕсли;
		Если СтрНайти(УчастникОбъект.ФИО, "  ") Тогда
			Пока СтрНайти(УчастникОбъект.ФИО, "  ") Цикл
				УчастникОбъект.ФИО = СтрЗаменить(УчастникОбъект.ФИО, "  ", " ");
			КонецЦикла;
			Записывать = Истина;
		КонецЕсли;
		Попытка
			ОчиститьЦифрыВФИО(УчастникОбъект.ФИО);
		Исключение
		КонецПопытки;
		Если Записывать Тогда
			УчастникОбъект.ДополнительныеСвойства.Вставить("ПропуститьЗаписьВерсииОбъекта");		
			УчастникОбъект.ОбменДанными.Загрузка = Истина;	
			УчастникОбъект.Записать();
			Если УчастникОбъект.Заблокирован() Тогда
				УчастникОбъект.Разблокировать();
			КонецЕсли;			
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

Процедура ОчиститьЦифрыВФИО(ФИО)
	
	RegExp = Новый COMОбъект("VBScript.RegExp"); 
    
    RegExp.IgnoreCase = Истина;
    RegExp.Global = Истина;
    RegExp.MultiLine = Истина;
     
    RegExp.Pattern = "\d+";
	
	Если RegExp.Test(ФИО) Тогда
		ФИО = RegExp.Replace(ФИО, "");	
 	КонецЕсли;     
	
КонецПроцедуры
//<821883> }

//<828132>, Басаргин (09.10.2018) {
Процедура ЗаполнениеВзаимодействий_Этап4(Выгрузка) Экспорт
		
	ОценкаПроизводительностиСуществует = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОценкаПроизводительности");
	Если ОценкаПроизводительностиСуществует Тогда
		МодульОценкаПроизводительности = ОбщегоНазначения.ОбщийМодуль("ОценкаПроизводительности");
		ВремяНачала = МодульОценкаПроизводительности.НачатьЗамерВремени();
	КонецЕсли;			

	//ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();	
	//Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	
	Для каждого ВыборкаДетальныеЗаписи Из Выгрузка Цикл
	
		ВзаимодействиеОбъект = ВыборкаДетальныеЗаписи.ВзаимодействиеСсылка.ПолучитьОбъект();

		Если ВзаимодействиеОбъект = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ (ТипЗнч(ВзаимодействиеОбъект) = Тип("СправочникОбъект.Сделки") ИЛИ ТипЗнч(ВзаимодействиеОбъект) = Тип("ДокументОбъект.ЗаявкаНаСделку")) 
				И (НЕ ВзаимодействиеОбъект.СтатусЗапроса = ВыборкаДетальныеЗаписи.СтатусЗапроса
				ИЛИ НЕ ВзаимодействиеОбъект.РасшифровкаСтатусаЗапроса = ВыборкаДетальныеЗаписи.РасшифровкаСтатусаЗапроса) Тогда
			ВзаимодействиеОбъект.СтатусЗапроса = ВыборкаДетальныеЗаписи.СтатусЗапроса;
			ВзаимодействиеОбъект.РасшифровкаСтатусаЗапроса= ВыборкаДетальныеЗаписи.РасшифровкаСтатусаЗапроса;
			ВзаимодействиеОбъект.ДополнительныеСвойства.Свойство("НеЗаписыватьКонтакты", Истина); 
			ВзаимодействиеОбъект.Записать();	
		КонецЕсли;
		
		НаборЗаписей = РегистрыСведений.Взаимодействия.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Взаимодействие.Установить(ВыборкаДетальныеЗаписи.ВзаимодействиеСсылка);
		НаборЗаписей.Прочитать();
		Если НаборЗаписей.Выбран() Тогда
			Для каждого Запись Из НаборЗаписей Цикл
				Запись.СтатусЗапроса = ВыборкаДетальныеЗаписи.СтатусЗапроса;
				Запись.РасшифровкаСтатусаЗапроса = ВыборкаДетальныеЗаписи.РасшифровкаСтатусаЗапроса;
				Запись.ДатаПоследнегоИзменения = ВыборкаДетальныеЗаписи.ДатаВзаимодействия;
			КонецЦикла;
			НаборЗаписей.Записать();
		КонецЕсли;

	КонецЦикла;

	Если ОценкаПроизводительностиСуществует Тогда
		МодульОценкаПроизводительности.ЗакончитьЗамерВремени("Этап4", ВремяНачала);
	КонецЕсли;			
		
КонецПроцедуры
//<828132> }
