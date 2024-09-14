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

// СтандартныеПодсистемы.ОбменДанными

// Заполняет настройки, влияющие на использование плана обмена.
// 
// Параметры:
//  Настройки - см. ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию
//
Процедура ПриПолученииНастроек(Настройки) Экспорт
	
	Настройки.ПланОбменаИспользуетсяВМоделиСервиса = Истина;
	
	Настройки.НазначениеПланаОбмена = "РИБСФильтром";
	
	Настройки.Алгоритмы.ПриПолученииОписанияВариантаНастройки = Истина;
	Настройки.Алгоритмы.ОписаниеОграниченийПередачиДанных     = Истина;
	
КонецПроцедуры

// Заполняет набор параметров, определяющих вариант настройки обмена.
// 
// Параметры:
//  ОписаниеВарианта       - см. ОбменДаннымиСервер.ОписаниеВариантаНастройкиОбменаПоУмолчанию
//  ИдентификаторНастройки - Строка - идентификатор варианта настройки обмена.
//  ПараметрыКонтекста     - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияОписанияВариантаНастройки
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки, ПараметрыКонтекста) Экспорт
	
	ОписаниеВарианта.ИспользоватьПомощникСозданияОбменаДанными = Ложь;
	
	ОписаниеВарианта.КраткаяИнформацияПоОбмену = НСтр("ru = 'Предназначен для обеспечения работы с приложением в автономном режиме.'");
	
	ОписаниеВарианта.НаименованиеКонфигурацииКорреспондента = НСтр("ru = '1С:Библиотека стандартных подсистем'");
	
	ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = НСтр("ru = 'Демо: Автономная работа'");
	
	ИспользуемыеТранспортыСообщенийОбмена = Новый Массив;
	ИспользуемыеТранспортыСообщенийОбмена.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.WS);
	ОписаниеВарианта.ИспользуемыеТранспортыСообщенийОбмена = ИспользуемыеТранспортыСообщенийОбмена;
	
	// Отборы
	СтруктураТабличнойЧастиОрганизации = Новый Структура;
	СтруктураТабличнойЧастиОрганизации.Вставить("Организация", Новый Массив);
	
	ОписаниеВарианта.Отборы.Вставить("ИспользоватьОтборПоОрганизациям", Ложь);
	ОписаниеВарианта.Отборы.Вставить("Организации", СтруктураТабличнойЧастиОрганизации);
	
КонецПроцедуры

// Возвращает строку описания ограничений миграции данных для пользователя.
// Прикладной разработчик на основе установленных отборов на узле должен сформировать 
// строку описания ограничений удобную для восприятия пользователем.
// 
// Параметры:
//  НастройкаОтборовНаУзле - Структура - структура отборов на узле плана обмена.
//  ВерсияКорреспондента   - Строка    - версия корреспондента.
//  ИдентификаторНастройки - Строка    - идентификатор варианта настройки обмена.
//
// Возвращаемое значение:
//  Строка - описание ограничений миграции данных для пользователя.
//
Функция ОписаниеОграниченийПередачиДанных(НастройкаОтборовНаУзле, ВерсияКорреспондента, ИдентификаторНастройки) Экспорт
	
	Описание = ?(НастройкаОтборовНаУзле.ИспользоватьОтборПоОрганизациям,
		НСтр("ru = 'В автономном рабочем месте доступна только часть данных.'"),
		НСтр("ru = 'В автономном рабочем месте доступны все данные.'"));
	
	Возврат Описание;
	
КонецФункции

// Конец СтандартныеПодсистемы.ОбменДанными

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив из Строка
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("РегистрироватьИзменения");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

#КонецОбласти

#КонецЕсли