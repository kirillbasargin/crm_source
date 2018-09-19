﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Проекты.Ссылка КАК Проект
	|ИЗ
	|	Справочник.ПроектыУПН КАК Проекты
	|ГДЕ
	|	НЕ Проекты.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Проекты.Наименование";	
	
	СписокПроектов.Загрузить(Запрос.Выполнить().Выгрузить());
		
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	Для каждого СтрокаТЗ Из СписокПроектов Цикл
		СтрокаТЗ.Выбрать = Ложь;	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	Для каждого СтрокаТЗ Из СписокПроектов Цикл
		СтрокаТЗ.Выбрать = Истина;	
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	АдресВХ = ВыгрузитьНаСервере(Параметры.УИДФормыВладельца);
	ОповеститьОВыборе(АдресВХ);	
	
КонецПроцедуры

&НаСервере
Функция ВыгрузитьНаСервере(УИДФормыВладельца)
	
	ТЗ_Банков = СписокПроектов.Выгрузить(Новый Структура("Выбрать", Истина), "Проект");
	
	Если ТЗ_Банков.Количество() > 0 Тогда
		АдресВХ = ПоместитьВоВременноеХранилище(ТЗ_Банков, Новый УникальныйИдентификатор(УИДФормыВладельца));
	Иначе
		АдресВХ = "";
	КонецЕсли;
	
	Возврат АдресВХ;
	
КонецФункции

