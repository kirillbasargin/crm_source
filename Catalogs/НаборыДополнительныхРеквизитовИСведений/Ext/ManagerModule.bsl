﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	РедактируемыеРеквизиты = Новый Массив;
	
	Возврат РедактируемыеРеквизиты;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Обновляет состав наименований предопределенных наборов в
// параметрах дополнительных реквизитов и сведений.
// 
// Параметры:
//  ЕстьИзменения - Булево (возвращаемое значение) - если производилась запись,
//                  устанавливается Истина, иначе не изменяется.
//
Процедура ОбновитьСоставНаименованийПредопределенныхНаборов(ЕстьИзменения = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПредопределенныеНаборы = ПредопределенныеНаборы();
	
	НачатьТранзакцию();
	Попытка
		ЕстьТекущиеИзменения = Ложь;
		СтароеЗначение = Неопределено;
		
		СтандартныеПодсистемыСервер.ОбновитьПараметрРаботыПрограммы(
			"СтандартныеПодсистемы.Свойства.ПредопределенныеНаборыДополнительныхРеквизитовИСведений",
			ПредопределенныеНаборы, ЕстьТекущиеИзменения, СтароеЗначение);
		
		СтандартныеПодсистемыСервер.ДобавитьИзмененияПараметраРаботыПрограммы(
			"СтандартныеПодсистемы.Свойства.ПредопределенныеНаборыДополнительныхРеквизитовИСведений",
			?(ЕстьТекущиеИзменения,
			  Новый ФиксированнаяСтруктура("ЕстьИзменения", Истина),
			  Новый ФиксированнаяСтруктура()) );
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Если ЕстьТекущиеИзменения Тогда
		ЕстьИзменения = Истина;
	КонецЕсли;
	
КонецПроцедуры



#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПредопределенныеНаборы()
	
	ПредопределенныеНаборы = Новый Соответствие;
	
	ИменаПредопределенных = Метаданные.Справочники.НаборыДополнительныхРеквизитовИСведений.ПолучитьИменаПредопределенных();
	
	Для каждого Имя Из ИменаПредопределенных Цикл
		ПредопределенныеНаборы.Вставить(
			Имя, УправлениеСвойствамиСлужебный.НаименованиеПредопределенногоНабора(Имя));
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(ПредопределенныеНаборы);
	
КонецФункции

#КонецОбласти

#КонецЕсли
