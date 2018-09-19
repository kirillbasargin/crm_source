﻿#Область СлужебныеПроцедурыИФункции

//////////////////////////////////////////////////////////////////////////////
// Обработчики событий подписок для плана обмена "ОбменУТNewCRM".

// Описание см. в ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюДокумента.
//
Процедура ОбменУТNewCRMЗарегистрироватьИзменениеДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	// ОбменДанными.Загрузка не требуется, т.к. подписка относиться к плану обмена.
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюДокумента("ОбменУТNewCRM", Источник, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

// Описание см. в ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью.
//
Процедура ОбменУТNewCRMЗарегистрироватьИзменение(Источник, Отказ) Экспорт
	
	// ОбменДанными.Загрузка не требуется, т.к. подписка относиться к плану обмена.
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("ОбменУТNewCRM", Источник, Отказ);
	
КонецПроцедуры

// Описание см. в ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра.
//
Процедура ОбменУТNewCRMЗарегистрироватьИзменениеНабораЗаписей(Источник, Отказ, Замещение) Экспорт
	
	// ОбменДанными.Загрузка не требуется, т.к. подписка относиться к плану обмена.
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("ОбменУТNewCRM", Источник, Отказ, Замещение);
	
КонецПроцедуры

// Описание см. в ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением.
//
Процедура ОбменУТNewCRMЗарегистрироватьУдаление(Источник, Отказ) Экспорт
	
	// ОбменДанными.Загрузка не требуется, т.к. подписка относиться к плану обмена.
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("ОбменУТNewCRM", Источник, Отказ);
	
КонецПроцедуры

#КонецОбласти
