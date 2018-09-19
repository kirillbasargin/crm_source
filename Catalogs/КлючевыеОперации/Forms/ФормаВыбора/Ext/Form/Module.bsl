﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОценкаПроизводительностиКлиентСервер.УстановитьЭлементОтбора(
		Список.Отбор,
		"Ссылка",
		Параметры.Отбор,
		ВидСравненияКомпоновкиДанных.НеВСписке);
	
	ОценкаПроизводительностиКлиентСервер.УстановитьЭлементОтбора(
		Список.Отбор,
		"ПометкаУдаления",
		Ложь,
		ВидСравненияКомпоновкиДанных.Равно);
	
КонецПроцедуры

#КонецОбласти