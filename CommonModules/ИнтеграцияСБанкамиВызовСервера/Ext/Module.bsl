﻿
//Возвращает статус отправки
Функция ОтправитьНовуюЗаявку(Объект) Экспорт
	
	Если Объект.РекомендуемыйБанк = Справочники.Банки.НайтиПоНаименованию("Райффайзен Банк", Истина) Тогда
		Возврат ИнтеграцияСБанкамиСервер.ОтправитьНовуюЗаявкуНаСервере(Объект, Пользователи.ТекущийПользователь());
	Иначе
		Возврат Новый Структура("Текст, Статус", "Обработка заявок возможна только для банка ""Райффайзен Банк"".", Ложь);
	КонецЕсли;
	
КонецФункции