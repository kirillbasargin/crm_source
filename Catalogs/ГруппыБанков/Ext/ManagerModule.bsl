﻿Функция ПолучитьГруппуБанковПоБанку(Банк, ДатаПроверки) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ГруппыБанковБанки.Ссылка
	               |ИЗ
	               |	Справочник.ГруппыБанков.Банки КАК ГруппыБанковБанки
	               |ГДЕ
	               |	ГруппыБанковБанки.Банк = &Банк
	               |	И &ДатаДоговора МЕЖДУ НАЧАЛОПЕРИОДА(ГруппыБанковБанки.ДатаНачала, ДЕНЬ) И КОНЕЦПЕРИОДА(ГруппыБанковБанки.ДатаОкончания, ДЕНЬ)";
	Запрос.УстановитьПараметр("Банк", Банк);
	Запрос.УстановитьПараметр("ДатаДоговора", ДатаПроверки);
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
КонецФункции