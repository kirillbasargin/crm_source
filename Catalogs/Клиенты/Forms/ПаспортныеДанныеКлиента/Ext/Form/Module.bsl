﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Параметры.ФизическоеЛицо) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, ПоулчитьПаспортныеДанныеКлиента(Параметры.ФизическоеЛицо));	
	//Элементы.ДанныеСвидетельстваОРождении.Видимость = ЗначениеЗаполнено(НомерАкта) И ЗначениеЗаполнено(ДатаАкта);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПоулчитьПаспортныеДанныеКлиента(Клиент)
	
	СтруктураПараметров = Новый Структура("АдресПоПропискеКлиента, ВидДокумента, ДатаАкта, ДатаВыдачи, ДатаРождения, Имя, 
										  |КемВыдан, КодПодразделения, МатьНациональность, МатьФИО, МестоРождения, Номер, НомерАкта,
										  |ОтецНациональность, ОтецФИО, Отчество, Пол, Серия, Фамилия");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДокументыФизическихЛиц.ФизЛицо КАК ФизЛицо,
	|	МАКСИМУМ(ДокументыФизическихЛиц.Период) КАК Период
	|ПОМЕСТИТЬ вт_СписокКлиентовДляСреза
	|ИЗ
	|	РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|ГДЕ
	|	ДокументыФизическихЛиц.ФизЛицо = &ФизЛицо
	|
	|СГРУППИРОВАТЬ ПО
	|	ДокументыФизическихЛиц.ФизЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДокументыФизическихЛиц.ФизЛицо КАК ФизЛицо,
	|	ДокументыФизическихЛиц.ВидДокумента КАК ВидДокумента
	|ПОМЕСТИТЬ ВТ_АктуальныйВидДокумента
	|ИЗ
	|	вт_СписокКлиентовДляСреза КАК вт_СписокКлиентовДляСреза
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|		ПО вт_СписокКлиентовДляСреза.ФизЛицо = ДокументыФизическихЛиц.ФизЛицо
	|			И вт_СписокКлиентовДляСреза.Период = ДокументыФизическихЛиц.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КлиентыКонтактнаяИнформация.Представление КАК АдресПоПропискеКлиента,
	|	ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.ПустаяСсылка) КАК ВидДокумента,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК ДатаАкта,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК ДатаВыдачи,
	|	КлиентыКонтактнаяИнформация.Ссылка.ДатаРождения КАК ДатаРождения,
	|	"""" КАК Имя,
	|	"""" КАК КемВыдан,
	|	"""" КАК КодПодразделения,
	|	"""" КАК МатьНациональность,
	|	"""" КАК МатьФИО,
	|	КлиентыКонтактнаяИнформация.Ссылка.МестоРождения КАК МестоРождения,
	|	"""" КАК Номер,
	|	"""" КАК НомерАкта,
	|	"""" КАК ОтецНациональность,
	|	"""" КАК ОтецФИО,
	|	"""" КАК Отчество,
	|	КлиентыКонтактнаяИнформация.Ссылка.Пол КАК Пол,
	|	"""" КАК Серия,
	|	"""" КАК Фамилия,
	|	1 КАК Сортировка
	|ИЗ
	|	Справочник.Клиенты.КонтактнаяИнформация КАК КлиентыКонтактнаяИнформация
	|ГДЕ
	|	КлиентыКонтактнаяИнформация.Ссылка = &ФизЛицо
	|	И КлиентыКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Адрес)
	|	И КлиентыКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.АдресПоПропискеКлиента)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	"""",
	|	ДокументыФизическихЛицСрезПоследних.ВидДокумента,
	|	ДАТАВРЕМЯ(1, 1, 1),
	|	ДокументыФизическихЛицСрезПоследних.ДатаВыдачи,
	|	ДАТАВРЕМЯ(1, 1, 1),
	|	"""",
	|	ДокументыФизическихЛицСрезПоследних.КемВыдан,
	|	ДокументыФизическихЛицСрезПоследних.КодПодразделения,
	|	"""",
	|	"""",
	|	"""",
	|	ДокументыФизическихЛицСрезПоследних.Номер,
	|	"""",
	|	"""",
	|	"""",
	|	"""",
	|	ЗНАЧЕНИЕ(Перечисление.ПолФизическогоЛица.ПустаяСсылка),
	|	ДокументыФизическихЛицСрезПоследних.Серия,
	|	"""",
	|	2
	|ИЗ
	|	РегистрСведений.ДокументыФизическихЛиц.СрезПоследних(
	|			&Период,
	|			ФизЛицо = &ФизЛицо
	|				И ВидДокумента В
	|					(ВЫБРАТЬ
	|						ВТ_АктуальныйВидДокумента.ВидДокумента
	|					ИЗ
	|						ВТ_АктуальныйВидДокумента КАК ВТ_АктуальныйВидДокумента)) КАК ДокументыФизическихЛицСрезПоследних
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	"""",
	|	ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.ПустаяСсылка),
	|	СвидетельстваОРожденииФизическихЛицСрезПоследних.ДатаАкта,
	|	ДАТАВРЕМЯ(1, 1, 1),
	|	ДАТАВРЕМЯ(1, 1, 1),
	|	"""",
	|	"""",
	|	"""",
	|	СвидетельстваОРожденииФизическихЛицСрезПоследних.МатьНациональность,
	|	СвидетельстваОРожденииФизическихЛицСрезПоследних.МатьФИО,
	|	"""",
	|	"""",
	|	СвидетельстваОРожденииФизическихЛицСрезПоследних.НомерАкта,
	|	СвидетельстваОРожденииФизическихЛицСрезПоследних.ОтецНациональность,
	|	СвидетельстваОРожденииФизическихЛицСрезПоследних.ОтецФИО,
	|	"""",
	|	ЗНАЧЕНИЕ(Перечисление.ПолФизическогоЛица.ПустаяСсылка),
	|	"""",
	|	"""",
	|	3
	|ИЗ
	|	РегистрСведений.СвидетельстваОРожденииФизическихЛиц.СрезПоследних(&Период, ФизическоеЛицо = &ФизЛицо) КАК СвидетельстваОРожденииФизическихЛицСрезПоследних
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	"""",
	|	ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.ПустаяСсылка),
	|	ДАТАВРЕМЯ(1, 1, 1),
	|	ДАТАВРЕМЯ(1, 1, 1),
	|	ДАТАВРЕМЯ(1, 1, 1),
	|	ФИОФизическихЛицСрезПоследних.Имя,
	|	"""",
	|	"""",
	|	"""",
	|	"""",
	|	"""",
	|	"""",
	|	"""",
	|	"""",
	|	"""",
	|	ФИОФизическихЛицСрезПоследних.Отчество,
	|	ЗНАЧЕНИЕ(Перечисление.ПолФизическогоЛица.ПустаяСсылка),
	|	"""",
	|	ФИОФизическихЛицСрезПоследних.Фамилия,
	|	4
	|ИЗ
	|	РегистрСведений.ФИОФизическихЛиц.СрезПоследних(&Период, ФизическоеЛицо = &ФизЛицо) КАК ФИОФизическихЛицСрезПоследних";
	
	Запрос.УстановитьПараметр("Период", ТекущаяДата());
	Запрос.УстановитьПараметр("ФизЛицо", Клиент);
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл		
			Если Выборка.Сортировка = 1 Тогда
				ЗаполнитьЗначенияСвойств(СтруктураПараметров, Выборка, "АдресПоПропискеКлиента, Пол, ДатаРождения, МестоРождения");
			ИначеЕсли Выборка.Сортировка = 2 Тогда
				ЗаполнитьЗначенияСвойств(СтруктураПараметров, Выборка, "ВидДокумента, ДатаВыдачи, КемВыдан, КодПодразделения, Номер, Серия");
			ИначеЕсли Выборка.Сортировка = 3 Тогда
				ЗаполнитьЗначенияСвойств(СтруктураПараметров, Выборка, "ДатаАкта, МатьНациональность, МатьФИО, НомерАкта, ОтецНациональность, ОтецФИО");
			ИначеЕсли Выборка.Сортировка = 4 Тогда
				ЗаполнитьЗначенияСвойств(СтруктураПараметров, Выборка, "Имя, Отчество, Фамилия");
			КонецЕсли;					
		КонецЦикла;
	КонецЕсли;
	
	Возврат СтруктураПараметров;
	
КонецФункции

