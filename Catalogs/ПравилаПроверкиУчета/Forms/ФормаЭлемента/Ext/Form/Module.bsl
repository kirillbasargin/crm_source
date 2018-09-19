﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Отказ = Истина;
		ВызватьИсключение НСтр("ru='Интерактивное создание запрещено.'");
	КонецЕсли;
	
	МодульПользователи = ОбщегоНазначения.ОбщийМодуль("Пользователи");
	Если Не ((Не ОбщегоНазначения.РазделениеВключено() И МодульПользователи.ЭтоПолноправныйПользователь())
		Или (ОбщегоНазначения.РазделениеВключено() И МодульПользователи.ЭтоПолноправныйПользователь(, Истина))) Тогда
		
		Элементы.ПредставлениеРасписания.Видимость = Ложь;
		Элементы.ГруппаДляРазработчика.Видимость   = Ложь;
		Элементы.СпособВыполнения.Видимость        = Ложь;
		
	Иначе
		
		УстановитьВидимостьНастройкиЗадания();
		СформироватьСтрокуСРасписанием(Объект.ИдентификаторРегламентногоЗадания);
		
	КонецЕсли;
	
	УстановитьДоступностьПоляВажности(ЭтотОбъект, Объект.Идентификатор);
	
	ПроверкиВеденияУчета = КонтрольВеденияУчетаПовтИсп.ПроверкиВеденияУчета();
	СтрокаПроверки       = ПроверкиВеденияУчета.Проверки.Найти(Объект.Идентификатор, "Идентификатор");
	
	ПутьДоПроцедурыОбработчика = ?(СтрокаПроверки = Неопределено, НСтр("ru = 'Не задан обработчик у проверки'"), СтрокаПроверки.ОбработчикПроверки);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не ЗначениеЗаполнено(ТекущийОбъект.Код) Тогда
		ТекущийОбъект.УстановитьНовыйКод();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АдресИндивидуальногоРасписания) Тогда
		ТекущийОбъект.РасписаниеВыполненияПроверки = ПолучитьИзВременногоХранилища(АдресИндивидуальногоРасписания);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СпособВыполненияПриИзменении(Элемент)
	
	УстановитьВидимостьНастройкиЗадания();
	СформироватьСтрокуСРасписанием(Объект.ИдентификаторРегламентногоЗадания);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеИндивидуальногоРасписанияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеХранилища = ПолучитьИзВременногоХранилища(НавигационнаяСсылкаФорматированнойСтроки);
	Если ДанныеХранилища = "ДобавитьЗадание" Тогда
		ДиалогРасписания    = Новый ДиалогРасписанияРегламентногоЗадания(Новый РасписаниеРегламентногоЗадания);
		ОповещениеИзменения = Новый ОписаниеОповещения("ДобавитьЗаданиеЗавершение", ЭтотОбъект);
		ДиалогРасписания.Показать(ОповещениеИзменения);
	Иначе
		ДиалогРасписания    = Новый ДиалогРасписанияРегламентногоЗадания(ДанныеХранилища);
		ОповещениеИзменения = Новый ОписаниеОповещения("ИзменитьЗаданиеЗавершение", ЭтотОбъект);
		ДиалогРасписания.Показать(ОповещениеИзменения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьПроверку(Команда)
	
	ДлительнаяОперация = ВыполнитьПроверкуНаСервере();
	Если ДлительнаяОперация <> Неопределено Тогда
		
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Истина;
		ПараметрыОжидания.ТекстСообщения       = НСтр("ru = 'Идет выполнение проверки. Это может занять некоторое время'");
		ПараметрыОжидания.Интервал             = 2;
		
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, , ПараметрыОжидания);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВернутьПравилоНаПоддержку(Команда)
	
	ТекстВопроса = НСтр("ru = 'Текущее правило проверки будет возвращено на поддержку.
	|Это означает, что при переходе на новую версию, поля правила будут обновлены из метаданных.
	|Продолжить?'");
	Обработчик = Новый ОписаниеОповещения("ВернутьПравилоНаПоддержкуНаКлиенте", ЭтотОбъект);
	ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ВыполнитьПроверкуНаСервере()
	
	Если МонопольныйРежим() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ДлительнаяОперация <> Неопределено Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ДлительнаяОперация.ИдентификаторЗадания);
	КонецЕсли;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение           = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Выполнение проверки ""%1""'"), Объект.Наименование);
	ПараметрыВыполнения.ЗапуститьВФоне              = Истина;
	
	МассивПараметров = Новый Массив;
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Идентификатор",                     Объект.Идентификатор);
	ПараметрыЗадания.Вставить("Представление",                     Объект.Наименование);
	ПараметрыЗадания.Вставить("ИдентификаторРегламентногоЗадания", Объект.ИдентификаторРегламентногоЗадания);
	ПараметрыЗадания.Вставить("ДатаНачалаПроверки",                Объект.ДатаНачалаПроверки);
	ПараметрыЗадания.Вставить("ЛимитПроблем",                      Объект.ЛимитПроблем);
	ПараметрыЗадания.Вставить("СпособВыполнения",                  Объект.СпособВыполнения);
	ПараметрыЗадания.Вставить("ПроверкаБылаОстановлена",           Ложь);
	ПараметрыЗадания.Вставить("РучнойЗапуск",                      Истина);
	
	МассивПараметров.Добавить(ПараметрыЗадания);
	
	Результат = ДлительныеОперации.ВыполнитьВФоне("КонтрольВеденияУчетаСлужебный.ВыполнитьПроверкиВФоновомЗадании", Новый Структура("МассивПараметров", МассивПараметров), ПараметрыВыполнения);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура УстановитьВидимостьНастройкиЗадания()
	
	Если (ОбщегоНазначения.РазделениеВключено() И Пользователи.ЭтоПолноправныйПользователь(, Истина)) Или Не ОбщегоНазначения.РазделениеВключено() Тогда
		Элементы.ПредставлениеРасписания.Видимость = Объект.СпособВыполнения = Перечисления.СпособВыполненияПроверки.ПоОбщемуРасписанию
			Или Объект.СпособВыполнения = Перечисления.СпособВыполненияПроверки.ПоОтдельномуРасписанию;
	Иначе
		Элементы.ПредставлениеРасписания.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьСтрокуСРасписанием(ИдентификаторРегламентногоЗадания)
	
	ОбщееРегламентноеЗадание = РегламентныеЗаданияСервер.Задание(Метаданные.РегламентныеЗадания.ПроверкаВеденияУчета);
	Если ОбщееРегламентноеЗадание <> Неопределено Тогда
		Если Не ОбщегоНазначения.РазделениеВключено() Тогда
			ОбщееРасписаниеПредставление = Строка(ОбщееРегламентноеЗадание.Расписание);
		Иначе
			Если Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
				ОбщееРасписаниеПредставление = Строка(ОбщееРегламентноеЗадание.Шаблон.Расписание.Получить());
			КонецЕсли;
		КонецЕсли;
	Иначе
		ОбщееРасписаниеПредставление = НСтр("ru = 'Не найдено общее регламентное задание'");
	КонецЕсли;
	
	Если Объект.СпособВыполнения = Перечисления.СпособВыполненияПроверки.ПоОбщемуРасписанию Тогда
		
		Элементы.ПредставлениеРасписания.Заголовок = 
			Новый ФорматированнаяСтрока(НСтр("ru='Проверка выполняется по общему расписанию:'") + " ",
			Новый ФорматированнаяСтрока(ОбщееРасписаниеПредставление, , ЦветаСтиля.ГиперссылкаЦвет));
			
	ИначеЕсли Объект.СпособВыполнения = Перечисления.СпособВыполненияПроверки.ПоОтдельномуРасписанию Тогда
		
		ОтдельноеРегламентноеЗадание     = Неопределено;
		ОтдельноеРасписаниеПредставление = "";
		
		Если ЗначениеЗаполнено(ИдентификаторРегламентногоЗадания) Тогда
			ОтдельноеРегламентноеЗадание = РегламентныеЗаданияСервер.Задание(ИдентификаторРегламентногоЗадания);
			Если ОтдельноеРегламентноеЗадание <> Неопределено Тогда
				ОтдельноеРасписаниеПредставление = Строка(ОтдельноеРегламентноеЗадание.Расписание) + ". ";
			КонецЕсли;
		КонецЕсли;
		
		Если Не ОбщегоНазначения.РазделениеВключено() Тогда
			
			Если ОтдельноеРегламентноеЗадание = Неопределено Тогда
				Элементы.ПредставлениеРасписания.Заголовок = 
					Новый ФорматированнаяСтрока(НСтр("ru='Проверка выполняется по общему расписанию:'") + " ",
					Новый ФорматированнаяСтрока(ОтдельноеРасписаниеПредставление, , ЦветаСтиля.ГиперссылкаЦвет),
					Новый ФорматированнаяСтрока(НСтр("ru='Настроить индивидуальное?'"), , , , ПоместитьВоВременноеХранилище("ДобавитьЗадание", УникальныйИдентификатор)));
			Иначе
				Элементы.ПредставлениеРасписания.Заголовок = 
					Новый ФорматированнаяСтрока(НСтр("ru='Индивидуальное расписание выполнения проверки:'") + " ",
					Новый ФорматированнаяСтрока(ОтдельноеРасписаниеПредставление, , , , ПоместитьВоВременноеХранилище(ОтдельноеРегламентноеЗадание.Расписание, УникальныйИдентификатор)));
			КонецЕсли;
				
		Иначе
			
			Если ОтдельноеРегламентноеЗадание = Неопределено Тогда
				Элементы.ПредставлениеРасписания.Заголовок = 
					Новый ФорматированнаяСтрока(НСтр("ru='Проверка выполняется по общему расписанию:'") + " ",
					Новый ФорматированнаяСтрока(ОтдельноеРасписаниеПредставление + ". ", , ЦветаСтиля.ГиперссылкаЦвет));
			Иначе
				Элементы.ПредставлениеРасписания.Заголовок = 
					Новый ФорматированнаяСтрока(НСтр("ru='Индивидуальное расписание выполнения проверки:'") + " ",
					Новый ФорматированнаяСтрока(ОтдельноеРасписаниеПредставление, , ЦветаСтиля.ГиперссылкаЦвет));
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьЗаданиеЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	
	Если Расписание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РегламентноеЗадание = РегламентныеЗаданияСервер.Задание(Объект.ИдентификаторРегламентногоЗадания);
	Если РегламентноеЗадание = Неопределено Тогда
		ДобавитьЗаданиеЗавершение(Расписание, ДополнительныеПараметры);
	Иначе
		
		РегламентныеЗаданияСервер.ИзменитьЗадание(Объект.ИдентификаторРегламентногоЗадания, Новый Структура("Расписание", Расписание));
		Элементы.ПредставлениеРасписания.Заголовок = 
			Новый ФорматированнаяСтрока(НСтр("ru='Индивидуальное расписание выполнения проверки:'") + " ",
			Новый ФорматированнаяСтрока(Строка(Расписание), , , , ПоместитьВоВременноеХранилище(Расписание, УникальныйИдентификатор)));
		
		АдресИндивидуальногоРасписания = ПоместитьВоВременноеХранилище(Новый ХранилищеЗначения(ОбщегоНазначенияКлиентСервер.РасписаниеВСтруктуру(Расписание)), УникальныйИдентификатор);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьЗаданиеЗавершение(Расписание, ДополнительныеПараметры) Экспорт
		
	Если Расписание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КлючЗадания = Строка(Новый УникальныйИдентификатор);
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Расписание",    Расписание);
	ПараметрыЗадания.Вставить("Использование", Истина);
	ПараметрыЗадания.Вставить("Метаданные",    Метаданные.РегламентныеЗадания.ПроверкаВеденияУчета);
	
	РегламентноеЗадание = РегламентныеЗаданияСервер.ДобавитьЗадание(ПараметрыЗадания);
	
	Объект.ИдентификаторРегламентногоЗадания = Строка(РегламентноеЗадание.УникальныйИдентификатор);
	
	ПараметрыЗадания = Новый Структура;
	
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Строка(РегламентноеЗадание.УникальныйИдентификатор));
	
	ПараметрыЗадания.Вставить("Параметры", МассивПараметров);
	РегламентныеЗаданияСервер.ИзменитьЗадание(РегламентноеЗадание.УникальныйИдентификатор, ПараметрыЗадания);
	
	Элементы.ПредставлениеРасписания.Заголовок = 
		Новый ФорматированнаяСтрока(НСтр("ru='Индивидуальное расписание выполнения проверки:'") + " ",
		Новый ФорматированнаяСтрока(Строка(Расписание), , , , ПоместитьВоВременноеХранилище(Расписание, УникальныйИдентификатор)));
		
	АдресИндивидуальногоРасписания = ПоместитьВоВременноеХранилище(Новый ХранилищеЗначения(ОбщегоНазначенияКлиентСервер.РасписаниеВСтруктуру(Расписание)), УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьДоступностьПоляВажности(Форма, Идентификатор)
	
	ПроверкиВеденияУчета = КонтрольВеденияУчетаПовтИсп.ПроверкиВеденияУчета();
	Проверки             = ПроверкиВеденияУчета.Проверки;
	СтрокаПроверки       = Проверки.Найти(Идентификатор, "Идентификатор");
	
	Форма.Элементы.ВажностьПроблемы.Доступность = Не (СтрокаПроверки <> Неопределено И СтрокаПроверки.ЗапрещеноИзменениеВажности);
	
КонецПроцедуры

&НаКлиенте
Процедура ВернутьПравилоНаПоддержкуНаКлиенте(Ответ, ПараметрыВыполнения) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ВернутьПравилоНаПоддержкуНаСервере();
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ВернутьПравилоНаПоддержкуНаСервере()
	Объект.ПроверкаВеденияУчетаИзменена = Ложь;
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти