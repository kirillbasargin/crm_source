﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("УзелОбменаСсылка", УзелОбменаСсылка);
	Если Параметры.Свойство("Имя", ПредупреждениеПриОткрытии) Тогда
		Если ПредупреждениеПриОткрытии = "ФормаРедактироватьНомераСообщений" Тогда
			ПредупреждениеПриОткрытии = Неопределено;
		ИначеЕсли ПредупреждениеПриОткрытии = "ДеревоМетаданных" Тогда
			ПредупреждениеПриОткрытии = Истина;
		Иначе 
			Отказ = Истина;
		КонецЕсли 
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
	ПрочитатьНомераСообщений();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(ПредупреждениеПриОткрытии) Тогда
		ПоказатьЗначение(, ПредупреждениеПриОткрытии);
		Отказ = Истина;
	КонецЕсли;
	
	Заголовок = УзелОбменаСсылка;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Производит запись измененных данных и закрывает форму.
//
&НаКлиенте
Процедура ЗаписатьИзмененияУзла(Команда)
	
	ЗаписатьНомераСообщений();
	Оповестить("ИзменениеДанныхУзлаОбмена", УзелОбменаСсылка, ЭтотОбъект);
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЭтотОбъект(ТекущийОбъект = Неопределено) 
	
	Если ТекущийОбъект = Неопределено Тогда
		Возврат РеквизитФормыВЗначение("Объект");
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект");
	Возврат Неопределено;
КонецФункции

&НаСервере
Процедура ПрочитатьНомераСообщений()
	
	Данные = ЭтотОбъект().ПолучитьПараметрыУзлаОбмена(УзелОбменаСсылка, "НомерОтправленного, НомерПринятого, ВерсияДанных", Элементы.НомерПринятого, ПредупреждениеПриОткрытии);
	Если Данные = Неопределено Тогда
		НомерОтправленного = Неопределено;
		НомерПринятого     = Неопределено;
		ВерсияДанных       = Неопределено;
	Иначе
		НомерОтправленного = Данные.НомерОтправленного;
		НомерПринятого     = Данные.НомерПринятого;
		ВерсияДанных       = Данные.ВерсияДанных;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНомераСообщений()
	
	Данные = Новый Структура("НомерОтправленного, НомерПринятого", НомерОтправленного, НомерПринятого);
	ЭтотОбъект().УстановитьПараметрыУзлаОбмена(УзелОбменаСсылка, Данные);
КонецПроцедуры

#КонецОбласти
