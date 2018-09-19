﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Отчеты CRM" (вызов сервера).
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// См. описание процедуры ОтчетыCRM.ДобавитьОтчетВИсторию()
Процедура ДобавитьОтчетВИсторию(Вариант) Экспорт
	
	ОтчетыCRM.ДобавитьОтчетВИсторию(Вариант);
	
КонецПроцедуры

//++ Юкаев Роман 20171218 (
Функция РассчитатьСкидку(Стоимость, ЦенаОтделкиКвМ, Площадь, Скидка) Экспорт
	
	Если Скидка = Справочники.ТипыСкидок.ПустаяСсылка() Тогда
		Возврат 0;
	Иначе
		ВидСкидки = Скидка.ВидСкидки;
		Если ВидСкидки = Перечисления.ВидыСкидок.Абсолютная Тогда
			Если Площадь = 0 Тогда
				Возврат 0;
			Иначе
				Если Скидка.РазмерСкидки < Стоимость / Площадь Тогда
					Возврат Скидка.РазмерСкидки * Площадь;
				Иначе
					Возврат 0;
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли ВидСкидки = Перечисления.ВидыСкидок.АбсолютнаяОтСтоимостиВО Тогда
			Если Площадь = 0 ИЛИ Скидка.РазмерСкидки > Стоимость Тогда
				Возврат 0;
			Иначе
				Возврат Скидка.РазмерСкидки;
			КонецЕсли;
		ИначеЕсли ВидСкидки = Перечисления.ВидыСкидок.Относительная Тогда
			Если Скидка.БезУчетаСтоимостиОтделки Тогда
				Возврат (Стоимость - ЦенаОтделкиКвМ * Площадь) * Скидка.РазмерСкидки / 100;
			Иначе
				Возврат Стоимость * Скидка.РазмерСкидки / 100
			КонецЕсли;
		ИначеЕсли ВидСкидки = Перечисления.ВидыСкидок.Комплексная Тогда
			
			СуммаСкидки = 0;
			РасчетнаяСтоимость = Стоимость;
			
			Для Каждого ЭлементСкидка Из Скидка.Состав Цикл
				РазмерСкидки = РассчитатьСкидку(РасчетнаяСтоимость, ЦенаОтделкиКвМ, Площадь, ЭлементСкидка.Скидка);
				Если РазмерСкидки = 0 Тогда
					Прервать;
				Иначе
					РасчетнаяСтоимость = РасчетнаяСтоимость - РазмерСкидки;
					СуммаСкидки = СуммаСкидки + РазмерСкидки;
				КонецЕсли;
			КонецЦикла;
			
			Возврат СуммаСкидки;
		Иначе
			Возврат 0;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции
//-- Юкаев Роман 20171218 )
#КонецОбласти
