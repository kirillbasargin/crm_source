﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Групповое изменение объектов.

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Обязательный");
	Результат.Добавить("Заметки");
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
