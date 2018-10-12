﻿
#Область ПрограммныйИнтерфейс

Процедура ЗагрузкаСобытийCQ_ЗаявкиНаЗвонок() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПараметрыПолученияЗаявокНаCallBack.Ссылка КАК Сайт,
	|	ПараметрыПолученияЗаявокНаCallBack.ОбъектНедвижимости КАК Проект,
	|	ПараметрыПолученияЗаявокНаCallBack.ВидНедвижимости КАК ВидНедвижимости,
	|	ПараметрыПолученияЗаявокНаCallBack.CQ_auth_token КАК auth_token,
	|	ПараметрыПолученияЗаявокНаCallBack.CQ_AppID КАК app_id,
	|	СобытияCQ.Ссылка КАК Событие,
	|	СобытияCQ.ВидСобытия КАК ВидСобытия,
	|	СобытияCQ.ID КАК event_id,
	|	СобытияCQ.ТипСобытия КАК ТипСобытия,
	|	СобытияCQ.ФильтрСтрокой КАК ФильтрСтрокой,
	|	СобытияCQ.ИмяСобытияCQ КАК ИмяСобытияCQ,
	|	СобытияCQ.СвойствоСортировки КАК СвойствоСортировки,
	|	СобытияCQ.НаправлениеСортировки КАК НаправлениеСортировки,
	|	СобытияCQ.Лимит КАК Лимит,
	|	СобытияCQ.Наименование КАК НазваниеСобытия
	|ИЗ
	|	Справочник.СобытияCQ КАК СобытияCQ
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПараметрыПолученияЗаявокНаCallBack КАК ПараметрыПолученияЗаявокНаCallBack
	|		ПО СобытияCQ.Владелец = ПараметрыПолученияЗаявокНаCallBack.Ссылка
	|ГДЕ
	|	ПараметрыПолученияЗаявокНаCallBack.ПодключенCQ
	|	И НЕ ПараметрыПолученияЗаявокНаCallBack.ПометкаУдаления
	|	И НЕ СобытияCQ.ПометкаУдаления
	|	И СобытияCQ.Включено
	|	И СобытияCQ.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыСобытийCQ.ЗаявкаНаЗвонок)";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ВыполнитьЗагрузкуЗаявокНаЗвонок(ВыборкаДетальныеЗаписи);
	КонецЦикла;
		
КонецПроцедуры

Процедура ЗагрузкаСобытийCQ_ЭлектронныеПисьма() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 	
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗаявкаНаЗвонок.reqID КАК User_id,
	|	ЗаявкаНаЗвонок.Сайт КАК Сайт,
	|	Взаимодействия.Предмет КАК Запрос,
	|	ЗаявкаНаЗвонок.Контакт КАК Контакт,
	|	КлиентыCQ.Email КАК Email
	|ПОМЕСТИТЬ ВТ_Клиенты
	|ИЗ
	|	Документ.ЗаявкаНаЗвонок КАК ЗаявкаНаЗвонок
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияЗвонков КАК ИсторияЗвонков
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеЗапросовЗвонкам КАК СоответствиеЗапросовЗвонкам
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.Взаимодействия КАК Взаимодействия
	|				ПО СоответствиеЗапросовЗвонкам.Взаимодействие = Взаимодействия.Взаимодействие
	|			ПО ИсторияЗвонков.ID_Звонка = СоответствиеЗапросовЗвонкам.ID_Звонка
	|		ПО (ИсторияЗвонков.ЗаявкаИнициатор = ЗаявкаНаЗвонок.Ссылка)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КлиентыCQ КАК КлиентыCQ
	|		ПО ЗаявкаНаЗвонок.reqID = КлиентыCQ.User_id
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыЭлектронныхПисемCQ КАК ПараметрыЭлектронныхПисемCQ
	|		ПО ЗаявкаНаЗвонок.reqID = ПараметрыЭлектронныхПисемCQ.User_id
	|ГДЕ
	//|	ЗаявкаНаЗвонок.ДатаПоследнейЗагрузки МЕЖДУ &НачалоПериода И &КонецПериода
	|	ЗаявкаНаЗвонок.ДатаРаспределения МЕЖДУ &НачалоПериода И &КонецПериода
	|	И ЗаявкаНаЗвонок.ТипВызова = ЗНАЧЕНИЕ(Перечисление.ТипыВызовов.ЗаявкаОтCQ)
	|	И НЕ ЗаявкаНаЗвонок.ПометкаУдаления
	|	И Взаимодействия.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыВзаимодействий.Завершено)
	|	И НЕ ЗаявкаНаЗвонок.reqID = 0
	|	И НЕ ЗаявкаНаЗвонок.Контакт = ЗНАЧЕНИЕ(Справочник.Клиенты.ПустаяСсылка)
	|	И НЕ КлиентыCQ.Клиент = ЗНАЧЕНИЕ(Справочник.Клиенты.ПустаяСсылка)
	|	И НЕ КлиентыCQ.Email = """"
	|	И ПараметрыЭлектронныхПисемCQ.ЭлектронноеПисьмо ЕСТЬ NULL
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сайт
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КлиентыCQ.User_id КАК User_id,
	|	КлиентыCQ.Сайт КАК Сайт,
	|	КлиентыCQ.Запрос КАК Запрос,
	|	КлиентыCQ.Контакт КАК Контакт,
	|	КлиентыCQ.Email КАК Email,
	|	ПараметрыПолученияЗаявокНаCallBack.ОбъектНедвижимости КАК Проект,
	|	ПараметрыПолученияЗаявокНаCallBack.ВидНедвижимости КАК ВидНедвижимости,
	|	ПараметрыПолученияЗаявокНаCallBack.CQ_auth_token КАК auth_token,
	|	ПараметрыПолученияЗаявокНаCallBack.CQ_AppID КАК app_id,
	|	СобытияCQ.Ссылка КАК Событие,
	|	СобытияCQ.ВидСобытия КАК ВидСобытия,
	|	СобытияCQ.ID КАК event_id,
	|	СобытияCQ.ТипСобытия КАК ТипСобытия,
	|	СобытияCQ.ФильтрСтрокой КАК ФильтрСтрокой,
	|	СобытияCQ.ИмяСобытияCQ КАК ИмяСобытияCQ,
	|	СобытияCQ.СвойствоСортировки КАК СвойствоСортировки,
	|	СобытияCQ.НаправлениеСортировки КАК НаправлениеСортировки,
	|	СобытияCQ.Лимит КАК Лимит,
	|	СобытияCQ.Наименование КАК НазваниеСобытия
	|ИЗ
	|	ВТ_Клиенты КАК КлиентыCQ
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СобытияCQ КАК СобытияCQ
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПараметрыПолученияЗаявокНаCallBack КАК ПараметрыПолученияЗаявокНаCallBack
	|			ПО СобытияCQ.Владелец = ПараметрыПолученияЗаявокНаCallBack.Ссылка
	|		ПО (СобытияCQ.Владелец = КлиентыCQ.Сайт)
	|ГДЕ
	|	ПараметрыПолученияЗаявокНаCallBack.ПодключенCQ
	|	И НЕ ПараметрыПолученияЗаявокНаCallBack.ПометкаУдаления
	|	И НЕ СобытияCQ.ПометкаУдаления
	|	И СобытияCQ.Включено
	|	И СобытияCQ.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыСобытийCQ.ЭлектронноеПисьмоИсходящее)
	|	И СобытияCQ.ТипСобытия = ЗНАЧЕНИЕ(Перечисление.ТипыСобытийCQ.ОтправленоЭлектронноеПисьмо)";	
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоДня(ТекущаяДата()));
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(ТекущаяДата()));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
		
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ВыполнитьЗагрузкуЭлектронныхПисем(ВыборкаДетальныеЗаписи, ВыборкаДетальныеЗаписи.User_id, ВыборкаДетальныеЗаписи.Контакт, ВыборкаДетальныеЗаписи.Email, ВыборкаДетальныеЗаписи.Запрос, ВыборкаДетальныеЗаписи.Сайт);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновлениеСобытийCQ_ЭлектронныеПисьма() Экспорт
	
	ОбновитьПараметрыЭлектронныхПисемCQПоСтатусу(Перечисления.СтатусыИсходящегоЭлектронногоПисьма.Исходящее);
	ОбновитьПараметрыЭлектронныхПисемCQПоСтатусу(Перечисления.СтатусыИсходящегоЭлектронногоПисьма.Прочитано);
	
КонецПроцедуры

Процедура ОбновлениеЛидовCQ() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 	
	"ВЫБРАТЬ
	|	ПараметрыПолученияЗаявокНаCallBack.Ссылка КАК Сайт,
	|	ПараметрыПолученияЗаявокНаCallBack.ОбъектНедвижимости КАК Проект,
	|	ПараметрыПолученияЗаявокНаCallBack.ВидНедвижимости КАК ВидНедвижимости,
	|	ПараметрыПолученияЗаявокНаCallBack.CQ_auth_token КАК auth_token,
	|	ПараметрыПолученияЗаявокНаCallBack.CQ_AppID КАК app_id,
	|	СобытияCQ.Ссылка КАК Событие,
	|	СобытияCQ.ВидСобытия КАК ВидСобытия,
	|	СобытияCQ.ID КАК event_id,
	|	СобытияCQ.ТипСобытия КАК ТипСобытия,
	|	СобытияCQ.ФильтрСтрокой КАК ФильтрСтрокой,
	|	СобытияCQ.ИмяСобытияCQ КАК ИмяСобытияCQ,
	|	СобытияCQ.СвойствоСортировки КАК СвойствоСортировки,
	|	СобытияCQ.НаправлениеСортировки КАК НаправлениеСортировки,
	|	СобытияCQ.Лимит КАК Лимит,
	|	СобытияCQ.Наименование КАК НазваниеСобытия
	|ИЗ
	|	Справочник.ПараметрыПолученияЗаявокНаCallBack КАК ПараметрыПолученияЗаявокНаCallBack
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СобытияCQ КАК СобытияCQ
	|		ПО (СобытияCQ.Владелец = ПараметрыПолученияЗаявокНаCallBack.Ссылка)
	|ГДЕ
	|	ПараметрыПолученияЗаявокНаCallBack.ПодключенCQ
	|	И НЕ ПараметрыПолученияЗаявокНаCallBack.ПометкаУдаления
	|	И НЕ СобытияCQ.ПометкаУдаления
	|	И СобытияCQ.Включено
	|	И СобытияCQ.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыСобытийCQ.Лид)
	|	И СобытияCQ.ТипСобытия = ЗНАЧЕНИЕ(Перечисление.ТипыСобытийCQ.ОбновлениеЛида)";	
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ОбновитьЛидыCQ(ВыборкаДетальныеЗаписи);
	КонецЦикла;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбновитьЛидыCQ(ПараметрыЗапроса)
	
	Если НЕ ПараметрыЗапроса.ВидСобытия = Перечисления.ВидыСобытийCQ.Лид
		И ПараметрыЗапроса.ТипСобытия = Перечисления.ТипыСобытийCQ.ОбновлениеЛида Тогда
		Возврат;
	КонецЕсли;		
	
	ИмяМетода = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("/v1/apps/%1/users", ПараметрыЗапроса.app_id);		
	
	Параметры = Новый Структура;
	Параметры.Вставить("auth_token", ПараметрыЗапроса.auth_token);
	Параметры.Вставить("filters", ПараметрыЗапроса.ФильтрСтрокой);
	Если ЗначениеЗаполнено(ПараметрыЗапроса.СвойствоСортировки) Тогда
		Параметры.Вставить("sort_prop", ПараметрыЗапроса.СвойствоСортировки);
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыЗапроса.НаправлениеСортировки) Тогда
		Параметры.Вставить("sort_order", ПараметрыЗапроса.НаправлениеСортировки);
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыЗапроса.Лимит) Тогда
		Параметры.Вставить("limit", ПараметрыЗапроса.Лимит);
	КонецЕсли;	
	
	ОтветСервера = ПолучитьРезультатыЗапроса(ИмяМетода, Параметры);
	
	Если НЕ ОтветСервера = Неопределено Тогда	
		Если ОтветСервера.meta.status = 200 Тогда
			Для каждого ДанныеПользователя Из ОтветСервера.data.users Цикл
				СохранитьКлиентаCQ(ПараметрыЗапроса.Сайт, ДанныеПользователя.id, ДанныеПользователя.props);
			КонецЦикла;
		Иначе
			ПричинаОшибки = "";
			Если ОтветСервера.meta.Свойство("error") Тогда
				ПричинаОшибки = ОтветСервера.meta.error;		
			КонецЕсли;				
			Если ОтветСервера.meta.Свойство("error_message") Тогда
				ПричинаОшибки = ПричинаОшибки + " : " + ОтветСервера.meta.error_message; 	
			КонецЕсли;				
			ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр(
				"ru = 'Не удалось выполнить запрос %1 по причине: %2'"), ИмяМетода, ПричинаОшибки);		
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Выполнение запроса к CQ'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка, , , ОписаниеОшибки);								
		КонецЕсли;		
	КонецЕсли;
		
КонецПроцедуры

Процедура ОбновитьПараметрыЭлектронныхПисемCQПоСтатусу(СтатусПисьма)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 	
	"ВЫБРАТЬ
	|	ПараметрыЭлектронныхПисемCQСрезПоследних.ЭлектронноеПисьмо КАК ЭлектронноеПисьмо,
	|	ПараметрыЭлектронныхПисемCQСрезПоследних.Сайт КАК Сайт,
	|	ПараметрыЭлектронныхПисемCQСрезПоследних.User_id КАК User_id,
	|	ПараметрыЭлектронныхПисемCQСрезПоследних.message_id КАК message_id,
	|	ПараметрыЭлектронныхПисемCQСрезПоследних.conversation_id КАК conversation_id,
	|	ПараметрыЭлектронныхПисемCQСрезПоследних.Клиент КАК Клиент,
	|	ПараметрыЭлектронныхПисемCQСрезПоследних.Email КАК Email
	|ПОМЕСТИТЬ ВТ_ИсходящиеПисьма
	|ИЗ
	|	РегистрСведений.ПараметрыЭлектронныхПисемCQ.СрезПоследних КАК ПараметрыЭлектронныхПисемCQСрезПоследних
	|ГДЕ
	|	ПараметрыЭлектронныхПисемCQСрезПоследних.СтатусПисьма = &СтатусПисьма
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сайт
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ИсходящиеПисьма.User_id КАК User_id,
	|	ВТ_ИсходящиеПисьма.Сайт КАК Сайт,
	|	ВТ_ИсходящиеПисьма.ЭлектронноеПисьмо КАК ЭлектронноеПисьмо,
	|	ВТ_ИсходящиеПисьма.message_id КАК message_id,
	|	ВТ_ИсходящиеПисьма.conversation_id КАК conversation_id,
	|	ВТ_ИсходящиеПисьма.Клиент КАК Клиент,
	|	ВТ_ИсходящиеПисьма.Email КАК Email,
	|	ПараметрыПолученияЗаявокНаCallBack.CQ_auth_token КАК auth_token,
	|	ПараметрыПолученияЗаявокНаCallBack.CQ_AppID КАК app_id,
	|	СобытияCQ.Ссылка КАК Событие,
	|	СобытияCQ.ВидСобытия КАК ВидСобытия,
	|	СобытияCQ.ID КАК event_id,
	|	СобытияCQ.ТипСобытия КАК ТипСобытия,
	|	СобытияCQ.ФильтрСтрокой КАК ФильтрСтрокой,
	|	СобытияCQ.ИмяСобытияCQ КАК ИмяСобытияCQ,
	|	СобытияCQ.СвойствоСортировки КАК СвойствоСортировки,
	|	СобытияCQ.НаправлениеСортировки КАК НаправлениеСортировки,
	|	СобытияCQ.Лимит КАК Лимит,
	|	СобытияCQ.Наименование КАК НазваниеСобытия
	|ИЗ
	|	ВТ_ИсходящиеПисьма КАК ВТ_ИсходящиеПисьма
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СобытияCQ КАК СобытияCQ
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПараметрыПолученияЗаявокНаCallBack КАК ПараметрыПолученияЗаявокНаCallBack
	|			ПО СобытияCQ.Владелец = ПараметрыПолученияЗаявокНаCallBack.Ссылка
	|		ПО (СобытияCQ.Владелец = ВТ_ИсходящиеПисьма.Сайт)
	|ГДЕ
	|	ПараметрыПолученияЗаявокНаCallBack.ПодключенCQ
	|	И НЕ ПараметрыПолученияЗаявокНаCallBack.ПометкаУдаления
	|	И НЕ СобытияCQ.ПометкаУдаления
	|	И СобытияCQ.Включено
	|	И СобытияCQ.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыСобытийCQ.ЭлектронноеПисьмоИсходящее)
	|	И СобытияCQ.ТипСобытия В (ЗНАЧЕНИЕ(Перечисление.ТипыСобытийCQ.ПрочиталЭлектронноеПисьмо), ЗНАЧЕНИЕ(Перечисление.ТипыСобытийCQ.ПерешелПоСсылкеВЭлектронномПисьме))";	
		
	Запрос.УстановитьПараметр("СтатусПисьма", СтатусПисьма);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
		
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ВыполнитьОбновлениеСтатусовЭлектронныхПисем(ВыборкаДетальныеЗаписи, ВыборкаДетальныеЗаписи.Клиент, ВыборкаДетальныеЗаписи.User_id, ВыборкаДетальныеЗаписи.Email, ВыборкаДетальныеЗаписи.Сайт, ВыборкаДетальныеЗаписи.ЭлектронноеПисьмо, ВыборкаДетальныеЗаписи.conversation_id, ВыборкаДетальныеЗаписи.message_id);
	КонецЦикла;
		
КонецПроцедуры

Процедура ВыполнитьОбновлениеСтатусовЭлектронныхПисем(ПараметрыЗапроса, Клиент, User_ID, Email, Сайт, ЭлектронноеПисьмо, conversation_id, message_id) 
		
	Если НЕ ПараметрыЗапроса.ВидСобытия = Перечисления.ВидыСобытийCQ.ЭлектронноеПисьмоИсходящее
		И (ПараметрыЗапроса.ТипСобытия = Перечисления.ТипыСобытийCQ.ПерешелПоСсылкеВЭлектронномПисьме 
				ИЛИ ПараметрыЗапроса.ТипСобытия = Перечисления.ТипыСобытийCQ.ПрочиталЭлектронноеПисьмо) Тогда
		Возврат;
	КонецЕсли;		
	
	ИмяМетода = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("/v1/users/%1/events", СтрЗаменить(User_ID, Символы.НПП, ""));
		
	Параметры = Новый Структура;
	Параметры.Вставить("auth_token", ПараметрыЗапроса.auth_token);
	Параметры.Вставить("filter_name", ПараметрыЗапроса.НазваниеСобытия);
	
	МассивРезультатов_События = Новый Массив;
	
	ВыполнитьЗапросРекурсивно(ИмяМетода, Параметры, МассивРезультатов_События);
	
	Если МассивРезультатов_События.Количество() Тогда							
		Для каждого СобытияПользователя Из МассивРезультатов_События Цикл
			Для каждого СобытиеПользователя Из СобытияПользователя Цикл				
				Если Не СобытиеПользователя.Свойство("id") 
					ИЛИ Не СобытиеПользователя.Свойство("created")
					ИЛИ Не СобытиеПользователя.Свойство("props") Тогда
					Продолжить;
				КонецЕсли;	
				
				Если Не СобытиеПользователя.props.Свойство("message_type") 
					И СобытиеПользователя.props.type = "email"
					И СобытиеПользователя.props.message_type = "auto" Тогда
					Продолжить;	
				КонецЕсли;	
				
				ПараметрыСобытия = Новый Структура("id, created, conversation_id, message_id", 
											СобытиеПользователя.id, СобытиеПользователя.created, СобытиеПользователя.props.conversation_id, СобытиеПользователя.props.message_id);
											
				Если ПараметрыСобытия.conversation_id = conversation_id И ПараметрыСобытия.message_id = message_id Тогда							
					ЭлектронноеПисьмоОбъект = ЭлектронноеПисьмо.ПолучитьОбъект();
					Если НЕ ЭлектронноеПисьмоОбъект = Неопределено Тогда				
						Если ПараметрыЗапроса.ТипСобытия = Перечисления.ТипыСобытийCQ.ПрочиталЭлектронноеПисьмо Тогда
							ЭлектронноеПисьмоОбъект.СтатусПисьма = Перечисления.СтатусыИсходящегоЭлектронногоПисьма.Прочитано;
						ИначеЕсли ПараметрыЗапроса.ТипСобытия = Перечисления.ТипыСобытийCQ.ПерешелПоСсылкеВЭлектронномПисьме Тогда
							ЭлектронноеПисьмоОбъект.СтатусПисьма = Перечисления.СтатусыИсходящегоЭлектронногоПисьма.ПереходПоСсылке;
						КонецЕсли;
						ЭлектронноеПисьмоОбъект.Записать();						
						СформироватьЗаписьРегиструПараметрыЭлектронныхПисемCQ(ЭлектронноеПисьмо, Клиент, User_id, Email, ЭлектронноеПисьмоОбъект.СтатусПисьма, Сайт, ПараметрыСобытия);
						Возврат;
					КонецЕсли;					
				КонецЕсли;																		
			КонецЦикла;				
		КонецЦикла;		
	КонецЕсли;
		
КонецПроцедуры

Процедура ВыполнитьЗагрузкуЭлектронныхПисем(ПараметрыЗапроса, User_ID, Клиент, Email, Предмет, Сайт) 
		
	Если НЕ ПараметрыЗапроса.ВидСобытия = Перечисления.ВидыСобытийCQ.ЭлектронноеПисьмоИсходящее
		И ПараметрыЗапроса.ТипСобытия = Перечисления.ТипыСобытийCQ.ОтправленоЭлектронноеПисьмо Тогда
		Возврат;
	КонецЕсли;		
	
	ИмяМетода = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("/v1/users/%1/events", СтрЗаменить(User_ID, Символы.НПП, ""));
		
	Параметры = Новый Структура;
	Параметры.Вставить("auth_token", ПараметрыЗапроса.auth_token);
	Параметры.Вставить("filter_name", ПараметрыЗапроса.НазваниеСобытия);
	
	МассивРезультатов_События = Новый Массив;
	
	ВыполнитьЗапросРекурсивно(ИмяМетода, Параметры, МассивРезультатов_События);
	
	Если МассивРезультатов_События.Количество() Тогда			
		Для каждого СобытияПользователя Из МассивРезультатов_События Цикл
			Для каждого СобытиеПользователя Из СобытияПользователя Цикл				
				Если Не СобытиеПользователя.Свойство("id") 
					ИЛИ Не СобытиеПользователя.Свойство("created")
					ИЛИ Не СобытиеПользователя.Свойство("props") Тогда
					Продолжить;
				КонецЕсли;	
				
				Если Не СобытиеПользователя.props.Свойство("message_type") 
					И СобытиеПользователя.props.type = "email"
					И СобытиеПользователя.props.message_type = "auto" Тогда
					Продолжить;	
				КонецЕсли;	
				
				ПараметрыСобытия = Новый Структура("id, created, conversation_id, message_id", 
											СобытиеПользователя.id, СобытиеПользователя.created, СобытиеПользователя.props.conversation_id, СобытиеПользователя.props.message_id);
											
				МассивРезультатов_Диалоги = ПолучитьДиалогиСПользователем(User_ID, ПараметрыЗапроса);
				Если МассивРезультатов_Диалоги.Количество() Тогда			
					Для каждого ДиалогиПользователя Из МассивРезультатов_Диалоги Цикл
						Для каждого ДиалогПользователя Из ДиалогиПользователя Цикл
							Если ДиалогПользователя.id = ПараметрыСобытия.conversation_id 
									И ДиалогПользователя.message = ПараметрыСобытия.message_id Тогда									
								Если ДиалогПользователя.part_last.Свойство("sent_via") И ДиалогПользователя.part_last.sent_via = "message_auto" Тогда
									ТекстПисьма = ДиалогПользователя.part_last.body;
									Прочитано = ДиалогПользователя.part_last.read;
									ДатаПисьма = Дата(1970, 1, 1, 0, 0, 0) + ДиалогПользователя.part_last.created;
									ОтправительПредставление = ?(ДиалогПользователя.part_last.Свойство("from"), ДиалогПользователя.part_last.from.name, "Carrot Quest");
									СоздатьЭлектронноеПисьмоПоСобытиюЛида(Клиент, Email, Предмет, ДатаПисьма, ТекстПисьма, ОтправительПредставление, User_ID, Сайт, ПараметрыСобытия);
								КонецЕсли;
							КонецЕсли;
						КонецЦикла;		
					КонецЦикла;
				Иначе
					Продолжить;
				КонецЕсли;					
			КонецЦикла;				
		КонецЦикла;			
	КонецЕсли;
		
КонецПроцедуры

Процедура СоздатьЭлектронноеПисьмоПоСобытиюЛида(Контакт, Email, Предмет, ДатаПисьма, ТекстПисьма, ОтправительПредставление, User_ID, Сайт, ПараметрыПисьма)	
	
	Если НЕ ЗначениеЗаполнено(Контакт) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭлектронноеПисьмоПоСобытиюЛидаСоздано(ПараметрыПисьма) Тогда
		Возврат;	
	КонецЕсли;
	
	НовыйДокумент = Документы.ЭлектронноеПисьмоИсходящее.СоздатьДокумент();
	
	НовыйДокумент.Дата = ДатаПисьма;
	НовыйДокумент.ДатаОтправления = ДатаПисьма;
	НовыйДокумент.Важность = Перечисления.ВариантыВажностиВзаимодействия.Высокая;
	НовыйДокумент.Автор = Справочники.Пользователи.Робот;
	НовыйДокумент.Кодировка = "UTF-8";
	НовыйДокумент.Комментарий = "Создано автоматически";
	НовыйДокумент.Ответственный = НовыйДокумент.Автор;
	
	НовыйДокумент.СтатусПисьма = Перечисления.СтатусыИсходящегоЭлектронногоПисьма.Исходящее;	
	НовыйДокумент.Тема = "Автоматическая рассылка клиентам Carrot Quest";
	НовыйДокумент.ТекстHTML = ТекстПисьма;
	НовыйДокумент.ТипТекста = Перечисления.ТипыТекстовЭлектронныхПисем.HTML;
	
	НовыйДокумент.УчетнаяЗапись = Справочники.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты;
	НовыйДокумент.ОтправительПредставление = ОтправительПредставление;
	
	Адрес = ?(ЗначениеЗаполнено(Email), Email, ПолучитьЭлектронныйАдресКонтакта(Контакт));
	Если НЕ ПустаяСтрока(Адрес) Тогда
		Получатель = НовыйДокумент.ПолучателиПисьма.Добавить();
		Получатель.Адрес = Адрес;
		Получатель.Контакт = Контакт;
		Получатель.Представление = СокрЛП(Контакт);
	КонецЕсли;
	
	СписокПолучателейПисьма = "";
	Для Каждого Ст Из НовыйДокумент.ПолучателиПисьма Цикл
		СписокПолучателейПисьма = ?(ПустаяСтрока(СписокПолучателейПисьма), Ст.Представление, ";" + Ст.Представление);
	КонецЦикла;
	НовыйДокумент.СписокПолучателейПисьма = СписокПолучателейПисьма;
	
	НовыйДокумент.ДополнительныеСвойства.Вставить("СистемноеПроведение");
	
	Попытка
		НовыйДокумент.Записать();
	Исключение
		ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр(
			"ru = 'Не удалось записать электронное письмо исходящее по причине: %1'"), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Загрузка рассылок из Carrot Quest'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , ОписаниеОшибки);								
		Возврат;
	КонецПопытки;
	
	СформироватьЗаписьПоПредмету(НовыйДокумент.Ссылка, Предмет);	
	СформироватьЗаписьРегиструПараметрыЭлектронныхПисемCQ(НовыйДокумент.Ссылка, Контакт, User_id, Адрес, НовыйДокумент.СтатусПисьма, Сайт, ПараметрыПисьма);
	
КонецПроцедуры

Функция ЭлектронноеПисьмоПоСобытиюЛидаСоздано(ПараметрыСобытия)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПараметрыЭлектронныхПисемCQ.ЭлектронноеПисьмо КАК ЭлектронноеПисьмо
	|ИЗ
	|	РегистрСведений.ПараметрыЭлектронныхПисемCQ КАК ПараметрыЭлектронныхПисемCQ
	|ГДЕ
	|	ПараметрыЭлектронныхПисемCQ.id = &id
	|	И ПараметрыЭлектронныхПисемCQ.created = &created
	|	И ПараметрыЭлектронныхПисемCQ.conversation_id = &conversation_id
	|	И ПараметрыЭлектронныхПисемCQ.message_id = &message_id";
	
	Запрос.УстановитьПараметр("conversation_id", ПараметрыСобытия.conversation_id);
	Запрос.УстановитьПараметр("created", ПараметрыСобытия.created);
	Запрос.УстановитьПараметр("id", ПараметрыСобытия.id);
	Запрос.УстановитьПараметр("message_id", ПараметрыСобытия.message_id);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат Не РезультатЗапроса.Пустой();

КонецФункции

Процедура СформироватьЗаписьРегиструПараметрыЭлектронныхПисемCQ(ЭлектронноеПисьмо, Клиент, User_id, Email, СтатусПисьма, Сайт, ПараметрыПисьма)
	
	Период = Дата(1970, 1, 1, 0, 0, 0) + ПараметрыПисьма.created;
	
	НаборЗаписей = РегистрыСведений.ПараметрыЭлектронныхПисемCQ.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ЭлектронноеПисьмо.Установить(ЭлектронноеПисьмо);
	НаборЗаписей.Отбор.Период.Установить(Период);
	НаборЗаписей.Прочитать();
	
	ИсходныйНабор = НаборЗаписей.Выгрузить();
	
	Если НаборЗаписей.Количество() Тогда
		Запись = НаборЗаписей[0];		
	Иначе	
		Запись = НаборЗаписей.Добавить();
		Запись.ЭлектронноеПисьмо = ЭлектронноеПисьмо;
		Запись.Период = Период;
	КонецЕсли;

	ЗаполнитьЗначенияСвойств(Запись, ПараметрыПисьма);
	
	Запись.Клиент = Клиент;
	Запись.СтатусПисьма = СтатусПисьма;
	Запись.User_id = User_id;
	Запись.Email = Email;
	Запись.Сайт = Сайт;
	
	Если НЕ ОбщегоНазначения.ДанныеСовпадают(ИсходныйНабор, НаборЗаписей.Выгрузить()) Тогда
		НаборЗаписей.Записать();	
	КонецЕсли;	
	
КонецПроцедуры

Процедура СформироватьЗаписьПоПредмету(Документ, Предмет)
	
	НаборЗаписей = РегистрыСведений.ПредметыПапкиВзаимодействий.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Взаимодействие.Установить(Документ);
	НаборЗаписей.Прочитать();
	
	Запись = НаборЗаписей.Добавить();
	Запись.Взаимодействие = Документ;
	Запись.Предмет = Предмет;
	Запись.Рассмотрено = Истина;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

Функция ПолучитьЭлектронныйАдресКонтакта(Контакт)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПользователиКонтактнаяИнформация.Представление КАК Представление
	|ИЗ
	|	Справочник.Пользователи.КонтактнаяИнформация КАК ПользователиКонтактнаяИнформация
	|ГДЕ
	|	ПользователиКонтактнаяИнформация.Ссылка = &Ссылка
	|	И ПользователиКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)
	|	И ПользователиКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.EmailПользователя)";
	
	Запрос.УстановитьПараметр("Ссылка", Контакт);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат "";
	Иначе
		Выборка = Результат.Выбрать();
	
		Выборка.Следующий();
		Возврат Выборка.Представление;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьДиалогиСПользователем(User_ID, ПараметрыЗапроса)
	
	ИмяМетода = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("/v1/users/%1/conversations", СтрЗаменить(User_ID, Символы.НПП, ""));	
	
	Параметры = Новый Структура;
	Параметры.Вставить("auth_token", ПараметрыЗапроса.auth_token);
	МассивРезультатов = Новый Массив;
	
	ВыполнитьЗапросРекурсивно(ИмяМетода, Параметры, МассивРезультатов);
		
	Возврат МассивРезультатов;
	
КонецФункции

Процедура ВыполнитьЗапросРекурсивно(ИмяМетода, ПараметрыЗапроса, МассивРезультатов)
	
	ОтветСервера = ПолучитьРезультатыЗапроса(ИмяМетода, ПараметрыЗапроса);		
	
	Если НЕ ОтветСервера = Неопределено Тогда	
		Если ОтветСервера.meta.status = 200 Тогда
			Если ОтветСервера.data.Количество() Тогда
				МассивРезультатов.Добавить(ОтветСервера.data);
			КонецЕсли;	
			Если НЕ ОтветСервера.meta.next_after = Неопределено Тогда
				ПараметрыЗапроса.Вставить("after", ОтветСервера.meta.next_after);
				ВыполнитьЗапросРекурсивно(ИмяМетода, ПараметрыЗапроса, МассивРезультатов);	
			КонецЕсли;
		Иначе
			ПричинаОшибки = "";
			Если ОтветСервера.meta.Свойство("error") Тогда
				ПричинаОшибки = ОтветСервера.meta.error;		
			КонецЕсли;				
			Если ОтветСервера.meta.Свойство("error_message") Тогда
				ПричинаОшибки = ПричинаОшибки + " : " + ОтветСервера.meta.error_message; 	
			КонецЕсли;				
			ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр(
				"ru = 'Не удалось выполнить запрос %1 по причине: %2'"), ИмяМетода, ПричинаОшибки);		
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Выполнение запроса к CQ'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка, , , ОписаниеОшибки);									
		КонецЕсли;
	КонецЕсли;	

КонецПроцедуры	

Процедура ВыполнитьЗагрузкуЗаявокНаЗвонок(ПараметрыЗапроса) 
	
	Если НЕ ПараметрыЗапроса.ВидСобытия = Перечисления.ВидыСобытийCQ.ЗаявкаНаЗвонок Тогда
		Возврат;
	КонецЕсли;		
	
	ИмяМетода = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("/v1/apps/%1/users", ПараметрыЗапроса.app_id);		
	
	Параметры = Новый Структура;
	Параметры.Вставить("auth_token", ПараметрыЗапроса.auth_token);
	Параметры.Вставить("filters", ПараметрыЗапроса.ФильтрСтрокой);
	Если ЗначениеЗаполнено(ПараметрыЗапроса.СвойствоСортировки) Тогда
		Параметры.Вставить("sort_prop", ПараметрыЗапроса.СвойствоСортировки);
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыЗапроса.НаправлениеСортировки) Тогда
		Параметры.Вставить("sort_order", ПараметрыЗапроса.НаправлениеСортировки);
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыЗапроса.Лимит) Тогда
		Параметры.Вставить("limit", ПараметрыЗапроса.Лимит);
	КонецЕсли;	
	
	ОтветСервера = ПолучитьРезультатыЗапроса(ИмяМетода, Параметры);
	
	Если НЕ ОтветСервера = Неопределено Тогда	
		Если ОтветСервера.meta.status = 200 Тогда
			Для каждого ДанныеПользователя Из ОтветСервера.data.users Цикл
				СохранитьКлиентаCQ(ПараметрыЗапроса.Сайт, ДанныеПользователя.id, ДанныеПользователя.props);
				СоздатьЗаявкуНаЗвонокПоСобытиюЛида(ПараметрыЗапроса, ДанныеПользователя.id, ДанныеПользователя.props);
			КонецЦикла;
			Если Константы.ИспользоватьАвтораспределениеЗаявок.Получить() Тогда 
				УправлениеЗаявкамиНаЗвонок.АвтоРаспределениеЗаявок(?(ПараметрыЗапроса.ТипСобытия = Перечисления.ТипыСобытийCQ.ОставленТелефон, Перечисления.ГруппыРаспределенияЗаявок.ГПТ, Неопределено),
					?(ПараметрыЗапроса.ТипСобытия = Перечисления.ТипыСобытийCQ.ОставленТелефон, Перечисления.ВидыЗаявокНаЗвонок.ОбратныйЗвонок, Перечисления.ВидыЗаявокНаЗвонок.EmailЛид));
			КонецЕсли;					
		Иначе
			ПричинаОшибки = "";
			Если ОтветСервера.meta.Свойство("error") Тогда
				ПричинаОшибки = ОтветСервера.meta.error;		
			КонецЕсли;				
			Если ОтветСервера.meta.Свойство("error_message") Тогда
				ПричинаОшибки = ПричинаОшибки + " : " + ОтветСервера.meta.error_message; 	
			КонецЕсли;				
			ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр(
				"ru = 'Не удалось выполнить запрос %1 по причине: %2'"), ИмяМетода, ПричинаОшибки);		
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Выполнение запроса к CQ'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка, , , ОписаниеОшибки);								
		КонецЕсли;		
	КонецЕсли;
	
КонецПроцедуры

Процедура СоздатьЗаявкуНаЗвонокПоСобытиюЛида(ПараметрыЗапроса, id, props)
	
	Если Не props.Свойство(ПараметрыЗапроса.ИмяСобытияCQ)
		ИЛИ НЕ ЗначениеЗаполнено(id) Тогда
		Возврат;
	КонецЕсли;
	
	ДиВ = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(props[ПараметрыЗапроса.ИмяСобытияCQ], "T");
	cтрГМД = ДиВ[0];
	стрВ = ДиВ[1];
	ГМД = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(cтрГМД, "-");
	стрДата = Формат(Дата(ГМД[0], ГМД[1], ГМД[2]), "ДЛФ=Д");
	reqData = Дата(стрДата + " " + стрВ);		
	
	Если ЗаявкаНаЗвонокПоСобытиямЛидаБылаЗагружена(id, reqData) Тогда
		Возврат;
	КонецЕсли;	
	
	reqContact = ?(props.Свойство("phone"), УправлениеТелефониейКлиентСервер.ФорматироватьТелефон(СокрЛП(props.phone)), "");						
	
	ЗаявкаОбъект = Документы.ЗаявкаНаЗвонок.СоздатьДокумент();	
	ЗаявкаОбъект.id = ПараметрыЗапроса.ИмяСобытияCQ + ":" + СтрЗаменить(id, Символы.НПП, ""); //Строка(Новый УникальныйИдентификатор);
	
	ЗаявкаОбъект.СобытиеCQ = ПараметрыЗапроса.Событие;
	
	ТекущаяДата = ТекущаяДата();
	ЗаявкаОбъект.Дата = ТекущаяДата;	
	ЗаявкаОбъект.ДатаПоследнейЗагрузки = ТекущаяДата;
	ЗаявкаОбъект.reqData = reqData; 	
	ЗаявкаОбъект.reqContact = reqContact;
	ЗаявкаОбъект.reqEmail = ?(props.Свойство("email"), props.email, "");
	
	ЗаявкаОбъект.Контакт = ПолучитьКлиентаДаннымCQ(id);
	
	Если ЗначениеЗаполнено(ЗаявкаОбъект.reqContact) И Не ЗначениеЗаполнено(ЗаявкаОбъект.Контакт) Тогда 
		ЗаявкаОбъект.Контакт = УправлениеТелефониейСервер.ОпределитьКлиента(ЗаявкаОбъект.reqContact)
	КонецЕсли;
	ЗаявкаОбъект.ГруппаРаспределения = ?(ПараметрыЗапроса.ТипСобытия = Перечисления.ТипыСобытийCQ.ОставленТелефон, Перечисления.ГруппыРаспределенияЗаявок.ГПТ, Неопределено);
	ЗаявкаОбъект.Статус = Перечисления.СтатусЗаявкиCallBack.НеОбработано;
	ЗаявкаОбъект.ВидЗаявкиНаЗвонок = ?(ПараметрыЗапроса.ТипСобытия = Перечисления.ТипыСобытийCQ.ОставленEmail, Перечисления.ВидыЗаявокНаЗвонок.EmailЛид, Перечисления.ВидыЗаявокНаЗвонок.ОбратныйЗвонок);		
	ЗаявкаОбъект.ТипВызова = Перечисления.ТипыВызовов.ЗаявкаОтCQ;
	ЗаявкаОбъект.ЭтапРаботы = Перечисления.ЭтапыРаботыЗавок.Начальный;
	ЗаявкаОбъект.Приоритет = ?(ПараметрыЗапроса.ТипСобытия = Перечисления.ТипыСобытийCQ.ОставленТелефон, Перечисления.ПриоритетыЗаявокНаЗвонок.Приоритет2, Неопределено);
	
	ВремяЗаявки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Формат(ЗаявкаОбъект.reqData, "ДЛФ=В"), ":");
	Попытка
		Если Число(ВремяЗаявки[0]) >= 9 И Число(ВремяЗаявки[0]) < 21  Тогда
			ЗаявкаОбъект.ТипПоступленияЗаявки = Перечисления.ТипыЗаявковПоВремениПоступления.Обычная;
		Иначе
			ЗаявкаОбъект.ТипПоступленияЗаявки = Перечисления.ТипыЗаявковПоВремениПоступления.Ночная;
		КонецЕсли; 
	Исключение
		ЗаявкаОбъект.ТипПоступленияЗаявки = Перечисления.ТипыЗаявковПоВремениПоступления.ПустаяСсылка();
	КонецПопытки;
	
	ЗаявкаОбъект.Сайт = ПараметрыЗапроса.Сайт;
	ЗаявкаОбъект.Проект = ПараметрыЗапроса.Проект;
	ЗаявкаОбъект.ВидНедвижимости = ПараметрыЗапроса.ВидНедвижимости;
		
	ЗаявкаОбъект.Тема = ПараметрыЗапроса.НазваниеСобытия;
	ЗаявкаОбъект.reqType = "Заявка от CQ";
	ЗаявкаОбъект.reqID = id;
	ЗаявкаОбъект.reqText = "";

	ЗаявкаОбъект.ЭтоТестоваяЗаявка = ?(ЗначениеЗаполнено(Справочники.СпамНомера.НайтиПоНаименованию(ЗаявкаОбъект.reqContact, Истина)), Истина, Ложь); //ПроверитьНаСпамНомер(ЗаявкаОбъект.reqContact);
	ЗаявкаОбъект.Автор = Справочники.Пользователи.Робот;
	ЗаявкаОбъект.ДеньОбработки = 1;	
	ЗаявкаОбъект.ТипРаспределения = ?(ПараметрыЗапроса.ТипСобытия = Перечисления.ТипыСобытийCQ.ОставленТелефон, Перечисления.ТипыРаспределенияЗаявокНаЗвонок.Сегодняшние, Неопределено);
	ЗаявкаОбъект.Записать();					
		
КонецПроцедуры

Функция ПолучитьКлиентаДаннымCQ(ID) 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КлиентыCQ.Клиент КАК Клиент
	|ИЗ
	|	РегистрСведений.КлиентыCQ КАК КлиентыCQ
	|ГДЕ
	|	КлиентыCQ.User_id = &User_id";
	
	Запрос.УстановитьПараметр("User_id", ID);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.Клиент;
	КонецЕсли;
	
КонецФункции

Функция ЗаявкаНаЗвонокПоСобытиямЛидаБылаЗагружена(reqID, reqData)
	
	Запрос = Новый Запрос;	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаявкаНаЗвонок.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЗаявкаНаЗвонок КАК ЗаявкаНаЗвонок
	|ГДЕ
	|	НЕ ЗаявкаНаЗвонок.ПометкаУдаления
	|	И ЗаявкаНаЗвонок.reqData = &reqData
	|	И ЗаявкаНаЗвонок.ТипВызова = ЗНАЧЕНИЕ(Перечисление.ТипыВызовов.ЗаявкаОтCQ)
	|	И ЗаявкаНаЗвонок.reqID = &reqID";	
	
	Запрос.УстановитьПараметр("reqID", reqID);	
	Запрос.УстановитьПараметр("reqData", reqData);	
	
	Возврат НЕ Запрос.Выполнить().Пустой();
		
КонецФункции

Процедура СохранитьКлиентаCQ(Сайт, User_id, СвойстваПользователя)
	
	НаборЗаписей = РегистрыСведений.КлиентыCQ.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.User_id.Установить(User_id);
	НаборЗаписей.Прочитать();
	
	ИсходныйНабор = НаборЗаписей.Выгрузить();
	
	Если Не НаборЗаписей.Количество() Тогда
		Запись = НаборЗаписей.Добавить();
		Запись.User_id = User_id; 
	Иначе
		Запись = НаборЗаписей[0];		
	КонецЕсли;

	ЗаполнитьЗначенияСвойств(Запись, СвойстваПользователя);	
	Запись.Сайт = Сайт;
	
	Если СвойстваПользователя.Свойство("Initial_utm_campaign") И ЗначениеЗаполнено(СвойстваПользователя.Initial_utm_campaign) Тогда
		Запись.Initial_utm_campaign = УправлениеОбращениямиCoMagic.Получить_UTM_Campaign(СокрЛП(СвойстваПользователя.Initial_utm_campaign));
	КонецЕсли;
	Если СвойстваПользователя.Свойство("Initial_utm_source") И ЗначениеЗаполнено(СвойстваПользователя.Initial_utm_source) Тогда
		Запись.Initial_utm_source = УправлениеОбращениямиCoMagic.Получить_UTM_Source(СокрЛП(СвойстваПользователя.Initial_utm_source));
	КонецЕсли;
	Если СвойстваПользователя.Свойство("Initial_utm_medium") И ЗначениеЗаполнено(СвойстваПользователя.Initial_utm_medium) Тогда
		Запись.Initial_utm_medium = УправлениеОбращениямиCoMagic.Получить_UTM_Medium(СокрЛП(СвойстваПользователя.Initial_utm_medium));
	КонецЕсли;
	Если СвойстваПользователя.Свойство("Initial_utm_content") И ЗначениеЗаполнено(СвойстваПользователя.Initial_utm_content) Тогда
		Запись.Initial_utm_content = УправлениеОбращениямиCoMagic.Получить_UTM_Content(СокрЛП(СвойстваПользователя.Initial_utm_content));
	КонецЕсли;
	Если СвойстваПользователя.Свойство("Initial_utm_term") И ЗначениеЗаполнено(СвойстваПользователя.Initial_utm_term) Тогда
		Запись.Initial_utm_term = УправлениеОбращениямиCoMagic.Получить_UTM_Term(СокрЛП(СвойстваПользователя.Initial_utm_term));
	КонецЕсли;
	
	Если НЕ ОбщегоНазначения.ДанныеСовпадают(ИсходныйНабор, НаборЗаписей.Выгрузить()) Тогда
		НаборЗаписей.Записать();	
	КонецЕсли;
		
КонецПроцедуры

Функция ПолучитьРезультатыЗапроса(ИмяМетода, ПараметрыЗапроса)

	ОтветСервера = ВыполнитьЗапрос(ИмяМетода, ПараметрыЗапроса);
	Если ОтветСервера = Неопределено Тогда
		ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр(
			"ru = 'Не удалось выполнить запрос %1'"), ИмяМетода);		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Выполнение запроса к CQ'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , ОписаниеОшибки);				
	КонецЕсли;
	
	Возврат ОтветСервера;
	
КонецФункции

Функция ВыполнитьЗапрос(ИмяМетода, ПараметрыЗапроса, Метод = "GET")
	
	Заголовки = Новый Соответствие;
	Если Метод = "POST" Тогда
		Заголовки.Вставить("Content-Type", "application/json");
	КонецЕсли;
	Заголовки.Вставить("Accept", "application/json");	
	
	HTTPЗапрос = ПодготовитьHTTPЗапрос(ИмяМетода, Заголовки, ПараметрыЗапроса, Метод);
	HTTPОтвет = Неопределено;
	
	Попытка
		Соединение = Новый HTTPСоединение("api.carrotquest.io", , , , ПолучениеФайловИзИнтернетаКлиентСервер.ПолучитьПрокси("https"), 60);                                        
		Если Метод = "POST" Тогда
			HTTPОтвет = Соединение.ОтправитьДляОбработки(HTTPЗапрос);
		ИначеЕсли Метод = "GET" Тогда
			HTTPОтвет = Соединение.Получить(HTTPЗапрос);
		КонецЕсли;
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Выполнение запроса к CQ'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Если НЕ HTTPОтвет = Неопределено Тогда		
		ТекстОтвета = HTTPОтвет.ПолучитьТелоКакСтроку();		
		
		//<test>, Басаргин (26.07.2018) {
		ТекстОтвета = СтрЗаменить(ТекстОтвета, "$", "");		
		ТекстОтвета = СтрЗаменить(ТекстОтвета, "\u041f\u043e\u0441\u043b\u0435\u0434\u043d\u044f\u044f \u043f\u043e\u0441\u0435\u0449\u0435\u043d\u043d\u0430\u044f \u0441\u0442\u0440\u0430\u043d\u0438\u0446\u0430", "ПоследняяПосещеннаяСтраница");				
		//<test> }
		
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(ТекстОтвета);
		ОтветСервера = ПрочитатьJSON(ЧтениеJSON);
		ЧтениеJSON.Закрыть();
		
		Возврат ОтветСервера;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция ПодготовитьHTTPЗапрос(АдресРесурса, Заголовки, ПараметрыЗапроса, Метод = "POST") 
	
	HTTPЗапрос = Новый HTTPЗапрос(АдресРесурса, Заголовки);
	
	Если ТипЗнч(ПараметрыЗапроса) = Тип("Строка") Тогда
		СтрокаПараметров = ПараметрыЗапроса;
		HTTPЗапрос.УстановитьТелоИзСтроки(СтрокаПараметров);
	Иначе		
		Если Метод = "POST" Тогда			
			ЗаписьJSON = Новый ЗаписьJSON;
			ЗаписьJSON.УстановитьСтроку();
			ЗаписатьJSON(ЗаписьJSON, ПараметрыЗапроса);			
			СтрокаПараметров = ЗаписьJSON.Закрыть();
			HTTPЗапрос.УстановитьТелоИзСтроки(СтрокаПараметров);
		ИначеЕсли Метод = "GET" Тогда
			СписокПараметров = Новый Массив;
			Для Каждого Параметр Из ПараметрыЗапроса Цикл
				СписокПараметров.Добавить(Параметр.Ключ + "=" + КодироватьСтроку(Параметр.Значение, СпособКодированияСтроки.КодировкаURL));
			КонецЦикла;
			СтрокаПараметров = СтрСоединить(СписокПараметров, "&");			
			АдресРесурса = АдресРесурса + "?" + СтрокаПараметров;
			HTTPЗапрос.АдресРесурса = АдресРесурса;
		Иначе
			СтрокаПараметров = "";	
		КонецЕсли;
	КонецЕсли;
	
	Возврат HTTPЗапрос;

КонецФункции

#КонецОбласти
