﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура СоздатьНастройкиПодключения(ПараметрыПроцедуры, АдресРезультата) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("КодОшибки",              "");
	Результат.Вставить("СообщениеОбОшибке",      "");
	Результат.Вставить("РезультатСохранения",    Неопределено);
	
	РезультатОперации = СервисОбменаСообщениями.ИдентификаторОбменДанными(
		ПараметрыПроцедуры.ИдентификаторСистемы,
		ПараметрыПроцедуры.ОписаниеНастройки);
	
	Если ЗначениеЗаполнено(РезультатОперации.КодОшибки) Тогда
		ЗаполнитьЗначенияСвойств(
			Результат,
			РезультатОперации,
			"КодОшибки, СообщениеОбОшибке");
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
		Возврат;
	КонецЕсли;
	
	ИмяПланаОбмена = ОбменДаннымиСВнешнимиСистемами.ИмяПланаОбмена();
	
	Контекст = Новый Структура;
	Контекст.Вставить("Режим",                  "НовоеПодключение");
	Контекст.Вставить("ИмяПланаОбмена",         ИмяПланаОбмена);
	Контекст.Вставить("ИдентификаторНастройки", ПараметрыПроцедуры.ИдентификаторСистемы);
	
	НастройкиТранспорта = Новый Структура;
	НастройкиТранспорта.Вставить("ИдентификаторСистемы",   ПараметрыПроцедуры.ИдентификаторСистемы);
	НастройкиТранспорта.Вставить("ИдентификаторОбмена",    РезультатОперации.ИдентификаторОбмена);
	НастройкиТранспорта.Вставить("НаименованиеСистемы",    ПараметрыПроцедуры.НаименованиеСистемы);
	НастройкиТранспорта.Вставить("СсылкаНаВнешнююСистему", ПараметрыПроцедуры.СсылкаНаВнешнююСистему);
	НастройкиТранспорта.Вставить("НаименованиеНастройки",  ПараметрыПроцедуры.НаименованиеНастройки);
	НастройкиТранспорта.Вставить("ОписаниеНастройки",      ПараметрыПроцедуры.ОписаниеНастройки);
	НастройкиТранспорта.Вставить("ОписаниеСистемы",        ПараметрыПроцедуры.ОписаниеСистемы);
	
	ПараметрыПодключения = Новый Структура;
	ПараметрыПодключения.Вставить("НаименованиеКорреспондента",      ПараметрыПроцедуры.НаименованиеСистемы);
	ПараметрыПодключения.Вставить("НастройкиТранспорта",             НастройкиТранспорта);
	ПараметрыПодключения.Вставить("РасписаниеСинхронизации",         ПараметрыПроцедуры.РасписаниеЗагрузки);
	ПараметрыПодключения.Вставить("ИспользоватьРегламентноеЗадание", ПараметрыПроцедуры.АвтоматическиПоРасписанию);
	
	Попытка
		ОбменДаннымиСервер.ПриСохраненииНастроекПодключенияВнешнейСистемы(
			Контекст,
			ПараметрыПодключения,
			Результат.РезультатСохранения);
	Исключение
		Результат.КодОшибки         = "ОшибкаСозданияУзла";
		ИнформацияОбОшибке          = ИнформацияОбОшибке();
		Результат.СообщениеОбОшибке = ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
		ОбменДаннымиСВнешнимиСистемами.ЗаписатьИнформациюВЖурналРегистрации(
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке),
			Истина);
	КонецПопытки;
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

Процедура ОбновитьНастройкиПодключения(ПараметрыПроцедуры, АдресРезультата) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("КодОшибки",           "");
	Результат.Вставить("СообщениеОбОшибке",   "");
	Результат.Вставить("РезультатСохранения", Неопределено);
	
	// Инициализация параметров для обновления данных обмена.
	Контекст = Новый Структура;
	Контекст.Вставить("Корреспондент", ПараметрыПроцедуры.Корреспондент);
	
	ПараметрыПодключения = Неопределено;
	ОбменДаннымиСервер.ПриПолученииНастроекПодключенияВнешнейСистемы(
		Контекст,
		ПараметрыПодключения);
	
	// Обновление описания в сервисе.
	РезультатОперации = СервисОбменаСообщениями.ОбновитьОписаниеНастройки(
		ПараметрыПодключения.НастройкиТранспорта.ИдентификаторОбмена,
		ПараметрыПроцедуры.ОписаниеНастройки);
	
	Если ЗначениеЗаполнено(РезультатОперации.КодОшибки) Тогда
		ЗаполнитьЗначенияСвойств(
			Результат,
			РезультатОперации,
			"КодОшибки, СообщениеОбОшибке");
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
		Возврат;
	КонецЕсли;
	
	// Обновление настроек транспорта.
	ИмяПланаОбмена = ОбменДаннымиСВнешнимиСистемами.ИмяПланаОбмена();
	ПараметрыПодключения.НастройкиТранспорта.ОписаниеНастройки = ПараметрыПроцедуры.ОписаниеНастройки;
	
	Контекст = Новый Структура;
	Контекст.Вставить("Режим",                  "РедактированиеПараметровПодключения");
	Контекст.Вставить("ИмяПланаОбмена",         ИмяПланаОбмена);
	Контекст.Вставить("ИдентификаторНастройки", ПараметрыПодключения.НастройкиТранспорта.ИдентификаторСистемы);
	Контекст.Вставить("Корреспондент",          ПараметрыПроцедуры.Корреспондент);
	
	Попытка
		ОбменДаннымиСервер.ПриСохраненииНастроекПодключенияВнешнейСистемы(
			Контекст,
			ПараметрыПодключения,
			Результат.РезультатСохранения);
	Исключение
		Результат.КодОшибки         = "ОшибкаОбновленияУзла";
		ИнформацияОбОшибке          = ИнформацияОбОшибке();
		Результат.СообщениеОбОшибке = ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
		ОбменДаннымиСВнешнимиСистемами.ЗаписатьИнформациюВЖурналРегистрации(
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке),
			Истина);
	КонецПопытки;
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

Процедура ПолучитьПодтверждениеПодключения(ПараметрыПроцедуры, АдресРезультата) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ПодтверждениеОбработано",  Ложь);
	Результат.Вставить("КодОшибки",                "");
	Результат.Вставить("СообщениеОбОшибке",        "");
	Результат.Вставить("РезультатСохранения",      Неопределено);
	
	РезультатОперации = СервисОбменаСообщениями.ОписаниеФайлаОбменаДанными(
		ПараметрыПроцедуры.ИдентификаторОбмена);
	
	Если РезультатОперации.КодОшибки = "НетФайловДляЗагрузки" Тогда
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
		Возврат;
	ИначеЕсли ЗначениеЗаполнено(РезультатОперации.КодОшибки) Тогда
		ЗаполнитьЗначенияСвойств(
			Результат,
			РезультатОперации,
			"КодОшибки, СообщениеОбОшибке");
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
		Возврат;
	КонецЕсли;
	
	ПараметрыОтправки = Новый Структура;
	ПараметрыОтправки.Вставить("ВыполнятьЗагрузку",         Истина);
	ПараметрыОтправки.Вставить("ВыполнятьОтправкуНастроек", Ложь);
	
	Ошибка = Ложь;
	
	Попытка
		ОбменДаннымиСервер.ВыполнитьОбменДаннымиСВнешнейСистемой(
			ПараметрыПроцедуры.Корреспондент,
			ПараметрыОтправки,
			Ошибка);
		Результат.ПодтверждениеОбработано = Не Ошибка;
	Исключение
		Результат.КодОшибки         = "ОшибкаОбменаДанными";
		ИнформацияОбОшибке          = ИнформацияОбОшибке();
		Результат.СообщениеОбОшибке = ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
		ОбменДаннымиСВнешнимиСистемами.ЗаписатьИнформациюВЖурналРегистрации(
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке),
			Истина);
	КонецПопытки;
	
	Если Ошибка Тогда 
		Результат.КодОшибки         = "ОшибкаОбменаДанными";
		ИнформацияОбОшибке          = ИнформацияОбОшибке();
		Результат.СообщениеОбОшибке = НСтр("ru = 'При загрузке файла обмена возникли ошибки.'");
		ОбменДаннымиСВнешнимиСистемами.ЗаписатьИнформациюВЖурналРегистрации(
			Результат.СообщениеОбОшибке,
			Истина);
	КонецЕсли;
		
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли