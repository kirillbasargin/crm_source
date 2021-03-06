﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если Не ЭтоГруппа И Использование = Ссылка.Использование Тогда
		Использование = Не ПометкаУдаления;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		Код = СокрЛП(Новый УникальныйИдентификатор);
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроверкаВеденияУчетаИзменена = ОбъектБылИзменен();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

#Область СлужебныеПроцедурыИФункции

Функция ОбъектБылИзменен()
	
	Если ЭтоНовый() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ПроверкаВеденияУчетаИзменена Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ПроверятьИзмененность") И Не ДополнительныеСвойства.ПроверятьИзмененность Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ПроверяемыеРеквизиты = Новый Массив;
	
	Если ЭтоГруппа Тогда
		ПроверяемыеРеквизиты.Добавить("Наименование");
	Иначе
		
		Реквизиты = Метаданные().Реквизиты;
		Для Каждого Реквизит Из Реквизиты Цикл
			
			Если Реквизит.Имя = "ДополнительныеПараметры"
				Или Реквизит.Имя = "РасписаниеВыполненияПроверки"
				Или Реквизит.Имя = "ПроверкаВеденияУчетаИзменена" Тогда
				Продолжить;
			КонецЕсли;
			
			ПроверяемыеРеквизиты.Добавить(Реквизит.Имя);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Для Каждого ПроверяемыйРеквизит Из ПроверяемыеРеквизиты Цикл
		
		Если Ссылка[ПроверяемыйРеквизит] <> ЭтотОбъект[ПроверяемыйРеквизит] Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецФункции;

#КонецОбласти
