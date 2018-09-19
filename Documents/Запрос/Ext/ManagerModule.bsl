﻿
Функция ПолучитьНомерПоследнейВерсииЛистинга(Ссылка, ДляЗаписи = Ложь) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	МАКСИМУМ(ЛистингСрезПоследних.ВерсияДокумента) КАК ВерсияДокумента
	|ИЗ
	|	РегистрСведений.Листинг.СрезПоследних(, Запрос = &Запрос) КАК ЛистингСрезПоследних 
	|Имеющие
	|	НЕ МАКСИМУМ(ЛистингСрезПоследних.ВерсияДокумента) ЕСТЬ NULL";
	
	Запрос.УстановитьПараметр("Запрос", Ссылка);	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат 1;
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		//Если функция используется для получения номера при записи регистра, то увеличиваем на единицу
		Возврат ?(ДляЗаписи, Выборка.ВерсияДокумента + 1, Выборка.ВерсияДокумента);
	КонецЕсли;	

КонецФункции

#Область СтандартныеПодсистемы_ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
// Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
	//Позволяет скрыть служебные реквизиты
	//Настройки.ПриПолученииСлужебныхРеквизитов = Истина;
	
КонецПроцедуры

// Ограничивает видимость реквизитов объекта в отчете по версии.
//
// Параметры:
// Реквизиты - Массив - список имен реквизитов объекта.
//Процедура ПриПолученииСлужебныхРеквизитов(Реквизиты) Экспорт
//    Реквизиты.Добавить("ИмяРеквизита"); // реквизит объекта
//    Реквизиты.Добавить("ИмяТабличнойЧасти.*"); // табличная часть объекта
//КонецПроцедуры

#КонецОбласти 

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Взаимодействия.

// Возвращает партнера и контактных лиц сделки.
// 
Функция ПолучитьКонтакты(Ссылка) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаПоКонтактам();
	Запрос.УстановитьПараметр("Предмет",Ссылка);
	
	НачатьТранзакцию();
	Попытка
		РезультатЗапроса = Запрос.Выполнить();
		
		Если РезультатЗапроса.Пустой() Тогда
			Результат = Неопределено;
		Иначе
			Результат = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Контакт");
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Возвращает текст запроса по контактам взаимодействий, содержащимся в документе.
//
// Параметры:
//  ТекстВременнаяТаблица - Строка - Имя временной таблицы, в которую помещаются полученные данные.
//  Объединить  - Булево  - признак, указывающий на необходимость добавления конструкции ОБЪЕДИНИТЬ в запрос.
//
// Возвращаемое значение:
//   Строка   - сформированный текст запроса для получения контактов взаимодействий объекта.
//
Функция ТекстЗапросаПоКонтактам(ТекстВременнаяТаблица = "", Объединить = Ложь) Экспорт
	
	ШаблонВыбрать = ?(Объединить,"ВЫБРАТЬ РАЗЛИЧНЫЕ","ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ");
	
	ТекстЗапроса = "
	|%ШаблонВыбрать%
	|	Запрос.Клиент КАК Контакт,
	|	ИСТИНА КАК Основной " + ТекстВременнаяТаблица + "
	|	
	|ИЗ
	|	Документ.Запрос КАК Запрос
	|ГДЕ
	|	Запрос.Ссылка = &Предмет
	|	И (НЕ Запрос.Клиент = ЗНАЧЕНИЕ(Справочник.Клиенты.ПустаяСсылка))
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	УчастникиЗапроса.Клиент,
	|	ВЫБОР
	|		КОГДА УчастникиЗапроса.Клиент = УчастникиЗапроса.Ссылка.Клиент
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ
	|ИЗ
	|	Документ.Запрос.Участники КАК УчастникиЗапроса
	|ГДЕ
	|	УчастникиЗапроса.Ссылка = &Предмет
	|
	|УПОРЯДОЧИТЬ ПО
	|	Основной УБЫВ";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"%ШаблонВыбрать%",ШаблонВыбрать);
	
	Если Объединить Тогда
		
		ТекстЗапроса = "
		| ОБЪЕДИНИТЬ ВСЕ
		|" + ТекстЗапроса;
		
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

#Область СтандартныеПодсистемы_ШаблоныСообщений

// СтандартныеПодсистемы.ШаблоныСообщений
// Вызывается при подготовке шаблонов сообщений и позволяет переопределить список реквизитов и вложений.
//
// Параметры:
//  Реквизиты               - ДеревоЗначений - список реквизитов шаблона.
//         ** Имя            - Строка - Уникальное имя общего реквизита.
//         ** Представление  - Строка - Представление общего реквизита.
//         ** Тип            - Тип    - Тип реквизита. По умолчанию строка.
//         ** Формат         - Строка - Формат вывода значения для чисел, дат, строк и булевых значений.
//  Вложения                - ТаблицаЗначений - печатные формы и вложения
//         ** Имя            - Строка - Уникальное имя вложения.
//         ** Представление  - Строка - Представление варианта.
//         ** ТипФайла       - Строка - Тип вложения, который соответствует расширению файла: "pdf", "png", "jpg", mxl" и др.
//  ДополнительныеПараметры - Структура - дополнительные сведения о шаблоне сообщений.
//
Процедура ПриПодготовкеШаблонаСообщения(Реквизиты, Вложения, ДополнительныеПараметры) Экспорт
КонецПроцедуры
// Вызывается в момент создания сообщений по шаблону для заполнения значений реквизитов и вложений.
//
// Параметры:
//  Сообщение - Структура - структура с ключами:
//    * ЗначенияРеквизитов - Соответствие - список используемых в шаблоне реквизитов.
//      ** Ключ     - Строка - имя реквизита в шаблоне;
//      ** Значение - Строка - значение заполнения в шаблоне.
//    * ЗначенияОбщихРеквизитов - Соответствие - список используемых в шаблоне общих реквизитов.
//      ** Ключ     - Строка - имя реквизита в шаблоне;
//      ** Значение - Строка - значение заполнения в шаблоне.
//    * Вложения - Соответствие - значения реквизитов 
//      ** Ключ     - Строка - имя вложения в шаблоне;
//      ** Значение - ДвоичныеДанные, Строка - двоичные данные или адрес во временном хранилище вложения.
//  ПредметСообщения - ЛюбаяСсылка - ссылка на объект являющийся источником данных.
//  ДополнительныеПараметры - Структура -  Дополнительная информация о шаблоне сообщения.
//
Процедура ПриФормированииСообщения(Сообщение, ПредметСообщения, ДополнительныеПараметры) Экспорт
КонецПроцедуры
// Заполняет список получателей SMS при отправке сообщения сформированного по шаблону.
//
// Параметры:
//   ПолучателиSMS - ТаблицаЗначений - список получается SMS.
//     * НомерТелефона - Строка - номер телефона, куда будет отправлено сообщение SMS.
//     * Представление - Строка - представление получателя сообщения SMS.
//     * Контакт       - Произвольный - контакт, которому принадлежит номер телефона.
//  ПредметСообщения - ЛюбаяСсылка, Структура - ссылка на объект являющийся источником данных, либо структура,
//    * Предмет               - ЛюбаяСсылка - ссылка на объект являющийся источником данных
//    * ПроизвольныеПараметры - Соответствие - заполненный список произвольных параметров.//
//
Процедура ПриЗаполненииТелефоновПолучателейВСообщении(ПолучателиSMS, ПредметСообщения) Экспорт
	#Если Сервер Тогда
	ШаблоныСообщений.ЗаполнитьПолучателей(ПолучателиSMS, ПредметСообщения, "Клиент", Перечисления.ТипыКонтактнойИнформации.Телефон);
	#КонецЕсли
КонецПроцедуры
// Заполняет список получателей письма при отправки сообщения сформированного по шаблону.
//
// Параметры:
//   ПолучателиПисьма - ТаблицаЗначений - список получается письма.
//     * Адрес           - Строка - адрес электронной почты получателя.
//     * Представление   - Строка - представление получается письма.
//     * Контакт         - Произвольный - контакт, которому принадлежит адрес электрнной почты.
//  ПредметСообщения - ЛюбаяСсылка, Структура - ссылка на объект являющийся источником данных, либо структура,
//                                              если шаблон содержит произвольные параметры:
//    * Предмет               - ЛюбаяСсылка - ссылка на объект являющийся источником данных
//    * ПроизвольныеПараметры - Соответствие - заполненный список произвольных параметров.
//
Процедура ПриЗаполненииПочтыПолучателейВСообщении(ПолучателиПисьма, ПредметСообщения) Экспорт
КонецПроцедуры
// Конец СтандартныеПодсистемы.ШаблоныСообщений

#КонецОбласти 