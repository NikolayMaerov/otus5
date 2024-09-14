﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// Возвращает сведения о внешней обработке.
//
// Возвращаемое значение:
//   см. ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке
//
Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке("2.2.2.1");
	ПараметрыРегистрации.Информация = НСтр("ru = 'Обработка заполнения справочника ""Демо: Контрагенты"". Используется для демонстрации возможностей подсистемы ""Дополнительные отчеты и обработки.""'");
	ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиЗаполнениеОбъекта();
	ПараметрыРегистрации.Версия = "3.0.2.1";
	ПараметрыРегистрации.БезопасныйРежим = Ложь;
	ПараметрыРегистрации.Назначение.Добавить("Справочник._ДемоКонтрагенты");
	
	// См. реализацию команды в процедуре ВыполнитьКоманду модуля обработки.
	Команда = ПараметрыРегистрации.Команды.Добавить();
	Команда.Представление = НСтр("ru = 'Заполнить реквизит ""Полное наименование"" (вызов серверной процедуры)'");
	Команда.Идентификатор = "ЗаполнитьПолноеНаименование";
	Команда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовСерверногоМетода();
	Команда.ПоказыватьОповещение = Истина;
	
	// См. реализацию команды в процедуре ДобавитьПрефиксКНаименованию модуля формы обработки.
	Команда = ПараметрыРегистрации.Команды.Добавить();
	Команда.Представление = НСтр("ru = 'Добавить префикс к реквизиту ""Наименование"" (открытие формы)...'");
	Команда.Идентификатор = "ДобавитьПрефиксКНаименованию";
	Команда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы();
	Команда.ПоказыватьОповещение = Ложь;
	
	// См. реализацию команды в процедуре ВыполнитьКоманду модуля обработки.
	Команда = ПараметрыРегистрации.Команды.Добавить();
	Команда.Представление = НСтр("ru = 'Комплексная очистка (вызов серверной процедуры)'");
	Команда.Идентификатор = "ОчиститьВсе";
	Команда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовСерверногоМетода();
	Команда.ПоказыватьОповещение = Ложь;
	
	// См. реализацию команды в процедуре ВыполнитьКоманду модуля формы обработки.
	Команда = ПараметрыРегистрации.Команды.Добавить();
	Команда.Представление = НСтр("ru = 'Комплексное заполнение (вызов клиентской процедуры)'");
	Команда.Идентификатор = "ЗаполнитьВсе";
	Команда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовКлиентскогоМетода();
	Команда.ПоказыватьОповещение = Истина;
	
	// См. реализацию команды в процедуре ВыполнитьКоманду модуля обработки.
	Команда = ПараметрыРегистрации.Команды.Добавить();
	Команда.Представление = НСтр("ru = 'Заполнить реквизит ""ИНН"" не записывая объект (заполнение формы)'");
	Команда.Идентификатор = "ЗаполнитьИНН";
	Команда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыЗаполнениеФормы();
	Команда.ПоказыватьОповещение = Ложь;
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

// Обработчик серверных команд.
//
// Параметры:
//   ИдентификаторКоманды - Строка - имя команды, определенное в функции СведенияОВнешнейОбработке().
//   ОбъектыНазначения    - Массив - ссылки объектов, для которых вызвана команда.
//                        - Неопределено - для команд "ЗаполнениеФормы".
//   ПараметрыВыполнения  - Структура - контекст выполнения команды:
//       * ДополнительнаяОбработкаСсылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - ссылка обработки.
//           Может использоваться для чтения параметров обработки.
//           Пример см. в комментарии к функции ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы().
//
Процедура ВыполнитьКоманду(ИдентификаторКоманды, ОбъектыНазначения, ПараметрыВыполнения) Экспорт
	ДатаЗавершенияВМиллисекундах = ТекущаяУниверсальнаяДатаВМиллисекундах() + 4;
	
	Если ИдентификаторКоманды = "ЗаполнитьИНН" Тогда
		ЗаполнитьИНН(ПараметрыВыполнения.ЭтаФорма);
	ИначеЕсли ИдентификаторКоманды = "ЗаполнитьПолноеНаименование" Тогда
		ЗаполнитьКонтрагентов(ОбъектыНазначения, Истина, Ложь);
	ИначеЕсли ИдентификаторКоманды = "ЗаполнитьВсе" Тогда
		ЗаполнитьКонтрагентов(ОбъектыНазначения, Истина, Истина);
	ИначеЕсли ИдентификаторКоманды = "ДобавитьПрефиксКНаименованию" Тогда
		ЗаполнитьКонтрагентов(ОбъектыНазначения, Ложь, Истина);
	ИначеЕсли ИдентификаторКоманды = "ОчиститьВсе" Тогда
		ОчиститьРеквизитыКонтрагентов(ОбъектыНазначения);
	Иначе
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Команда ""%1"" не поддерживается обработкой ""%2""'"),
			ИдентификаторКоманды,
			Метаданные().Представление());
	КонецЕсли;
	
	// Имитация длительной операции.
	Пока ТекущаяУниверсальнаяДатаВМиллисекундах() < ДатаЗавершенияВМиллисекундах Цикл
	КонецЦикла;
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обработчик команды.
Процедура ЗаполнитьИНН(Форма)
	
	Генератор = Новый ГенераторСлучайныхЧисел;
	
	Форма.Объект.ИНН = Формат(Генератор.СлучайноеЧисло(1, 999999999), "ЧЦ=12; ЧДЦ=0; ЧВН=; ЧГ=");
	Форма.Модифицированность = Истина;
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = НСтр("ru = 'Поле ""ИНН"" заполнено.'");
	Сообщение.Поле = "ИНН";
	Сообщение.Сообщить();
	
КонецПроцедуры

// Обработчик команд ЗаполнитьПолноеНаименование, ДобавитьПрефиксКНаименованию, ЗаполнитьВсе и ОчиститьВсе.
Процедура ЗаполнитьКонтрагентов(ОбъектыНазначения, ЗаполнятьНаименование, ДобавлятьПрефикс) Экспорт
	
	Если ОбъектыНазначения.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не выбраны контрагенты для заполнения'");
	КонецЕсли;
	
	Ошибки = Новый Массив;
	
	// Заполнение объектов
	Для Каждого ЭлементОбъектНазначения Из ОбъектыНазначения Цикл
		НачатьТранзакцию();
		Попытка
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Справочник._ДемоКонтрагенты");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ЭлементОбъектНазначения);
			Блокировка.Заблокировать();
			
			ОбъектНазначения = ЭлементОбъектНазначения.ПолучитьОбъект();
			Если ЗаполнятьНаименование Тогда
				Если Не ПустаяСтрока(ОбъектНазначения.НаименованиеПолное) Тогда
					Ошибки.Добавить(
						СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Объект ""%1"" не обработан: реквизит ""%2"" не пустой.'"),
							Строка(ОбъектНазначения), "НаименованиеПолное"));
				Иначе
					ОбъектНазначения.НаименованиеПолное = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Полное наименование заполнено %1'"),
						Строка(ТекущаяДатаСеанса()));
				КонецЕсли;
			КонецЕсли;
			
			Если ДобавлятьПрефикс Тогда
				ОбъектНазначения.Наименование = "ПР " + ОбъектНазначения.Наименование;
			КонецЕсли;
			
			ОбъектНазначения.Записать();
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
	КонецЦикла;
	
	Если ЗаполнятьНаименование И ДобавлятьПрефикс Тогда
		ЗаголовокОповещения = НСтр("ru = 'Наименование и префикс заполнены'");
	ИначеЕсли ЗаполнятьНаименование Тогда
		ЗаголовокОповещения = НСтр("ru = 'Полное наименование заполнено'");
	ИначеЕсли ДобавлятьПрефикс Тогда
		ЗаголовокОповещения = НСтр("ru = 'Добавлен префикс к краткому наименованию'");
	КонецЕсли;
	ВывестиОповещение(ОбъектыНазначения, ЗаголовокОповещения, Ошибки);
	
КонецПроцедуры

// Обработчик команды ОчиститьВсе.
Процедура ОчиститьРеквизитыКонтрагентов(ОбъектыНазначения) 
	
	Если ОбъектыНазначения.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не выбраны контрагенты для очистки реквизитов'");
	КонецЕсли;
	
	// Заполнение объектов
	Для Каждого ЭлементОбъектНазначения Из ОбъектыНазначения Цикл
		НачатьТранзакцию();
		Попытка
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Справочник._ДемоКонтрагенты");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ЭлементОбъектНазначения);
			Блокировка.Заблокировать();
			
			ОбъектНазначения = ЭлементОбъектНазначения.ПолучитьОбъект();
			ОбъектНазначения.Наименование = СтрЗаменить(ОбъектНазначения.Наименование, "ПР ", "");
			ОбъектНазначения.НаименованиеПолное = "";
			ОбъектНазначения.ИНН = "";
			ОбъектНазначения.Записать();
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
	КонецЦикла;
	
	ВывестиОповещение(ОбъектыНазначения, НСтр("ru = 'Наименование и префикс очищены'"));
	
КонецПроцедуры

Процедура ВывестиОповещение(ОбъектыНазначения, ЗаголовокОповещения, Ошибки = Неопределено)
	Всего = ОбъектыНазначения.Количество();
	Ошибок = ?(Ошибки <> Неопределено, Ошибки.Количество(), 0);
	Заполнено = Всего - Ошибок;
	
	Если Всего = 1 Тогда
		Если Ошибок > 0 Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = Ошибки[0];
			Сообщение.Поле = "Объект.НаименованиеПолное";
			Сообщение.Сообщить();
		Иначе
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = ЗаголовокОповещения;
			Сообщение.Сообщить();
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если Ошибок = 0 Тогда
		ТекстОповещения = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(
			НСтр("ru = ';Обработан %1 объект;; Обработано %1 объекта; Обработано %1 объектов; Обработано %1 объекта'"),
			Всего);
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ТекстОповещения;
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	
	Кратко = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Всего объектов: %1
			|Успешно заполнено: %2
			|Ошибок: %3'"),
		Формат(Всего,     "ЧН=0; ЧГ=0"),
		Формат(Заполнено, "ЧН=0; ЧГ=0"), 
		Формат(Ошибок,    "ЧН=0; ЧГ=0"));
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = Кратко;
	Сообщение.Сообщить();
	
	Подробно = "";
	Для Каждого ТекстОшибки Из Ошибки Цикл
		Подробно = Подробно + "---" + Символы.ПС + Символы.ПС + ТекстОшибки + Символы.ПС + Символы.ПС;
	КонецЦикла;
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Обработка заполнения справочника Демо: Контрагенты'", ОбщегоНазначения.КодОсновногоЯзыка()), 
		УровеньЖурналаРегистрации.Информация,
		Метаданные.Справочники._ДемоКонтрагенты,
		,
		Подробно);
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли