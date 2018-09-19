﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра(
		"ТекущийПользователь", Пользователи.ТекущийПользователь());
	
	РаботаСФайламиСлужебныйВызовСервера.ЗаполнитьУсловноеОформлениеСпискаФайлов(Список);
	
	ПриИзмененииИспользованияПодписанияИлиШифрованияНаСервере();
	
	Если КлиентскоеПриложение.ТекущийВариантИнтерфейса() = ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2 Тогда
		Элементы.ФормаИзменить.Видимость = Ложь;
		Элементы.ФормаИзменить82.Видимость = Истина;
	КонецЕсли;
	
	НавигационнаяСсылка = "e1cib/app/" + ЭтотОбъект.ИмяФормы;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПапкиФайлов" Тогда
		Элементы.Список.Обновить();
	ИначеЕсли ИмяСобытия = "Запись_Файл" Тогда
		Элементы.Список.Обновить();
		Если ТипЗнч(Параметр) = Тип("Структура") И Параметр.Свойство("Файл") Тогда
			Элементы.Список.ТекущаяСтрока = Параметр.Файл;
		ИначеЕсли Источник <> Неопределено Тогда
			Элементы.Список.ТекущаяСтрока = Источник;
		КонецЕсли;
	ИначеЕсли ВРег(ИмяСобытия) = ВРег("Запись_НаборКонстант")
	   И (ВРег(Источник) = ВРег("ИспользоватьЭлектронныеПодписи")
		  Или ВРег(Источник) = ВРег("ИспользоватьШифрование")) Тогда
		ПодключитьОбработчикОжидания("ПриИзмененииИспользованияПодписанияИлиШифрования", 0.3, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(Элементы.Список.ТекущиеДанные.Ссылка, Неопределено, УникальныйИдентификатор);
	РаботаСФайламиСлужебныйКлиент.ОткрытьФайлСОповещением(Неопределено, ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	УстановитьДоступностьФайловыхКоманд();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Просмотреть(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(Элементы.Список.ТекущиеДанные.Ссылка, Неопределено, УникальныйИдентификатор);
	РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляСохранения(Элементы.Список.ТекущиеДанные.Ссылка, , УникальныйИдентификатор);
	РаботаСФайламиСлужебныйКлиент.СохранитьКак(Неопределено, ДанныеФайла, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Освободить(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ОсвободитьЗавершение", ЭтотОбъект);
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	ПараметрыОсвобожденияФайла = РаботаСФайламиСлужебныйКлиент.ПараметрыОсвобожденияФайла(Обработчик, Элементы.Список.ТекущиеДанные.Ссылка);
	ПараметрыОсвобожденияФайла.ХранитьВерсии = ТекущиеДанные.ХранитьВерсии;	
	ПараметрыОсвобожденияФайла.ФайлРедактируетТекущийПользователь = ТекущиеДанные.РедактируетТекущийПользователь;
	ПараметрыОсвобожденияФайла.Редактирует = ТекущиеДанные.Редактирует;	
	РаботаСФайламиСлужебныйКлиент.ОсвободитьФайлСОповещением(ПараметрыОсвобожденияФайла);
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	Элементы.Список.Обновить();
	ПодключитьОбработчикОжидания("УстановитьДоступностьФайловыхКоманд", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСвойстваФайла(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПрисоединенныйФайл", ТекущиеДанные.Ссылка);
	
	ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ПрисоединенныйФайл", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометкуУдаления(Команда)
	УстановитьСнятьПометкуУдаления(Элементы.Список.ВыделенныеСтроки);
	Элементы.Список.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	Отказ = Истина;
	УстановитьСнятьПометкуУдаления(Элементы.Список.ВыделенныеСтроки);
	Элементы.Список.Обновить();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОсвободитьЗавершение(Результат, ПараметрыВыполнения) Экспорт
	УстановитьДоступностьФайловыхКоманд();
КонецПроцедуры

// Доступны файловые команды - есть хотя бы одна строка в списке и выделена не группировка.
&НаКлиенте
Функция ФайловыеКомандыДоступны()
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(Элементы.Список.ТекущиеДанные.Ссылка) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура УстановитьДоступностьФайловыхКоманд()
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		
		Если ТипЗнч(Элементы.Список.ТекущиеДанные.Ссылка) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			
			УстановитьДоступностьКоманд(Элементы.Список.ТекущиеДанные.РедактируетТекущийПользователь,
				Элементы.Список.ТекущиеДанные.Редактирует);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьСнятьПометкуУдаления(Знач ВыделенныеСтроки)
	
	Если ТипЗнч(ВыделенныеСтроки) = Тип("Массив") Тогда
		Для каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
			Файл = ВыделеннаяСтрока.Файл.ПолучитьОбъект();
			Файл.УстановитьПометкуУдаления(НЕ Файл.ПометкаУдаления);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКоманд(РедактируетТекущийПользователь, Редактирует)
	
	Элементы.ФормаОсвободить.Доступность = ЗначениеЗаполнено(Редактирует);
	Элементы.СписокКонтекстноеМенюОсвободить.Доступность = ЗначениеЗаполнено(Редактирует);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииИспользованияПодписанияИлиШифрования()
	
	ПриИзмененииИспользованияПодписанияИлиШифрованияНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииИспользованияПодписанияИлиШифрованияНаСервере()
	
	РаботаСФайламиСлужебный.КриптографияПриСозданииФормыНаСервере(ЭтотОбъект,, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПрисоединенныйФайл", ТекущиеДанные.Ссылка);
	
	ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ПрисоединенныйФайл", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти
