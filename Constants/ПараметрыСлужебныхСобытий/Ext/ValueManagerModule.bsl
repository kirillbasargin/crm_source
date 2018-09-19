﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Процедура обновляет параметры программных событий при изменении конфигурации.
// 
// Параметры:
//  ЕстьИзменения - Булево (возвращаемое значение) - если производилась запись,
//                  устанавливается Истина, иначе не изменяется.
//
Процедура Обновить(ЕстьИзменения = Неопределено, ТолькоПроверка = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТолькоПроверка ИЛИ МонопольныйРежим() Тогда
		СнятьМонопольныйРежим = Ложь;
	Иначе
		СнятьМонопольныйРежим = Истина;
		УстановитьМонопольныйРежим(Истина);
	КонецЕсли;
	
	ОбработчикиСобытий = СтандартныеПодсистемыСервер.ОбработчикиСобытий();
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Константа.ПараметрыСлужебныхСобытий");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		
		ЕстьТекущиеИзменения = Ложь;
		СтандартныеПодсистемыСервер.ОбновитьПараметрРаботыПрограммы("ПараметрыСлужебныхСобытий",
			"ОбработчикиСобытий", ОбработчикиСобытий, ЕстьТекущиеИзменения, ТолькоПроверка);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		Если СнятьМонопольныйРежим Тогда
			УстановитьМонопольныйРежим(Ложь);
		КонецЕсли;
		ВызватьИсключение;
	КонецПопытки;
	
	Если ЕстьТекущиеИзменения Тогда
		ЕстьИзменения = Истина;
	КонецЕсли;
	
	Если Не (ТолькоПроверка И ЕстьТекущиеИзменения) Тогда
		СтандартныеПодсистемыСервер.ПодтвердитьОбновлениеПараметраРаботыПрограммы(
			"ПараметрыСлужебныхСобытий", "ОбработчикиСобытий");
	КонецЕсли;
	
	Если СнятьМонопольныйРежим Тогда
		УстановитьМонопольныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
