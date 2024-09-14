﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Открывает форму, в которой пользователь может сменить пароль.
Процедура ОткрытьФормуСменыПароля(Пользователь = Неопределено, ОбработкаПродолжения = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВернутьПарольБезУстановки", Ложь);
	ПараметрыФормы.Вставить("СтарыйПароль", Неопределено);
	ПараметрыФормы.Вставить("ИмяДляВхода",  "");
	Если ДополнительныеПараметры <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ПараметрыФормы, ДополнительныеПараметры);
	КонецЕсли;
	ПараметрыФормы.Вставить("Пользователь", Пользователь);
	
	ОткрытьФорму("ОбщаяФорма.СменаПароля", ПараметрыФормы,,,,, ОбработкаПродолжения);
	
КонецПроцедуры

// См. ПользователиСлужебныйВМоделиСервисаКлиент.ЗапроситьПарольДляАутентификацииВСервисе.
Процедура ЗапроситьПарольДляАутентификацииВСервисе(ОбработкаПродолжения, ФормаВладелец = Неопределено, ПарольПользователяСервиса = Неопределено) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ПользователиВМоделиСервиса") Тогда
		
		МодульПользователиСлужебныйВМоделиСервисаКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль(
			"ПользователиСлужебныйВМоделиСервисаКлиент");
		
		МодульПользователиСлужебныйВМоделиСервисаКлиент.ЗапроситьПарольДляАутентификацииВСервисе(
			ОбработкаПродолжения, ФормаВладелец, ПарольПользователяСервиса);
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьИнтерактивнуюОбработкуПриОшибкеНедостаточноПравДляВходаВПрограмму(Параметры, ОписаниеОшибки) Экспорт
	
	Параметры.Отказ = Истина;
	Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения(
		"ИнтерактивнаяОбработкаПриОшибкеНедостаточноПравДляВходаВПрограмму", ЭтотОбъект, ОписаниеОшибки);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Для работы интерфейса ролей в управляемой форме.

// Только для внутреннего использования.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//  Безусловно - Булево
//
Процедура РазвернутьПодсистемыРолей(Форма, Безусловно = Истина) Экспорт
	
	Элементы = Форма.Элементы;
	
	Если НЕ Безусловно
	   И НЕ Элементы.РолиПоказатьТолькоВыбранныеРоли.Пометка Тогда
		
		Возврат;
	КонецЕсли;
	
	// Развернуть все.
	Для каждого Строка Из Форма.Роли.ПолучитьЭлементы() Цикл
		Элементы.Роли.Развернуть(Строка.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
	
КонецПроцедуры

// Только для внутреннего использования.
Процедура ВыбратьНазначение(ДанныеФормы, Заголовок, ВыбиратьПользователей = Истина, ЭтоОтбор = Ложь, ОписаниеОповещения = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ДанныеФормы", ДанныеФормы);
	ДополнительныеПараметры.Вставить("ЭтоОтбор", ЭтоОтбор);
	ДополнительныеПараметры.Вставить("ОписаниеОповещения", ОписаниеОповещения);
	
	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ПослеВыбораНазначения", ЭтотОбъект, ДополнительныеПараметры);
	
	Назначение = ?(ЭтоОтбор, ДанныеФормы.ВидПользователей, ДанныеФормы.Объект.Назначение);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок", Заголовок);
	ПараметрыФормы.Вставить("Назначение", Назначение);
	ПараметрыФормы.Вставить("ВыбиратьПользователей", ВыбиратьПользователей);
	ПараметрыФормы.Вставить("ЭтоОтбор", ЭтоОтбор);
	ОткрытьФорму("ОбщаяФорма.ВыборТиповПользователей", ПараметрыФормы,,,,, ОписаниеОповещенияОЗакрытии);
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Обработчики ожидания.

// Открывает окно предупреждения безопасности.
Процедура ПоказатьПредупреждениеБезопасности() Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	Ключ = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыРаботыКлиента, "КлючПредупрежденияБезопасности");
	Если ЗначениеЗаполнено(Ключ) Тогда
		ОткрытьФорму("ОбщаяФорма.ПредупреждениеБезопасности", Новый Структура("Ключ", Ключ));
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОбщегоНазначенияКлиентПереопределяемый.ПередНачаломРаботыСистемы.
Процедура ПередНачаломРаботыСистемы(Параметры) Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если ПараметрыКлиента.Свойство("ОшибкаНедостаточноПравДляВходаВПрограмму") Тогда
		Параметры.ПолученныеПараметрыКлиента.Вставить("ОшибкаНедостаточноПравДляВходаВПрограмму");
		УстановитьИнтерактивнуюОбработкуПриОшибкеНедостаточноПравДляВходаВПрограмму(Параметры,
			ПараметрыКлиента.ОшибкаНедостаточноПравДляВходаВПрограмму);
	КонецЕсли;
	
КонецПроцедуры

// См. ОбщегоНазначенияКлиентПереопределяемый.ПередНачаломРаботыСистемы.
Процедура ПередНачаломРаботыСистемы2(Параметры) Экспорт
	
	// Проверяет авторизацию пользователя и уведомляет об ошибке.
	ПараметрыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если ПараметрыКлиента.Свойство("ОшибкаАвторизации") Тогда
		Параметры.Отказ = Истина;
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения("ПоказатьПредупреждениеИПродолжить",
			СтандартныеПодсистемыКлиент, ПараметрыКлиента.ОшибкаАвторизации);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// См. ОбщегоНазначенияКлиентПереопределяемый.ПередНачаломРаботыСистемы.
Процедура ПередНачаломРаботыСистемы3(Параметры) Экспорт
	
	// Требует сменить пароль при необходимости.
	ПараметрыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если ПараметрыКлиента.Свойство("ТребуетсяСменитьПароль") Тогда
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения(
			"ИнтерактивнаяОбработкаПриСменеПароляПриЗапуске", ЭтотОбъект);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// См. ОбщегоНазначенияКлиентПереопределяемый.ПослеНачалаРаботыСистемы.
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	Ключ = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыРаботыКлиента, "КлючПредупрежденияБезопасности");
	Если ЗначениеЗаполнено(Ключ) Тогда
		// Небольшая задержка чтобы платформа успела отрисовать текущее окно, поверх которого выводится окно предупреждения.
		ПодключитьОбработчикОжидания("ПоказатьПредупреждениеБезопасностиПослеЗапуска", 0.3, Истина);
	КонецЕсли;
	
	Если ПараметрыРаботыКлиента.Свойство("ЗадатьВопросПроОтключениеOpenIDConnect") Тогда
		ОповещениеНажатия = Новый ОписаниеОповещения("ЗадатьВопросПроОтключениеOpenIDConnect", ЭтотОбъект);
		ЗаголовокСообщения = НСтр("ru = 'Предупреждение безопасности'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Отключите аутентификацию %1, если не используется.'"), "OpenID-Connect");
		ПоказатьОповещениеПользователя(ЗаголовокСообщения, ОповещениеНажатия,
			ТекстСообщения, БиблиотекаКартинок.Предупреждение32, СтатусОповещенияПользователя.Важное);
	КонецЕсли;
	
КонецПроцедуры

// См. СтандартныеПодсистемыКлиент.ПриПолученииСерверногоОповещения.
Процедура ПриПолученииСерверногоОповещения(ИмяОповещения, Результат) Экспорт
	
	Если Результат = "ВходВПрограммуЗапрещен" Тогда
		ОткрытьФорму("ОбщаяФорма.ВходВПрограммуЗапрещен");
		
	ИначеЕсли Результат = "РолиИзменены" Тогда
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Права доступа обновлены'"),
			"e1cib/app/ОбщаяФорма.КонтрольИзмененияРолейПользователяИБ",
			НСтр("ru = 'Перезапустите программу, чтобы они вступили в силу.'"),
			БиблиотекаКартинок.Предупреждение32,
			СтатусОповещенияПользователя.Важное,
			"КонтрольИзмененияРолейПользователяИБ");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

///////////////////////////////////////////////////////////////////////////////
// Обработчики оповещений.

// Предупреждает пользователя об ошибке недостатка прав для входа в программу.
Процедура ИнтерактивнаяОбработкаПриОшибкеНедостаточноПравДляВходаВПрограмму(Параметры, ОписаниеОшибки) Экспорт
	
	ПоказатьПредупреждение(
		Новый ОписаниеОповещения("ИнтерактивнаяОбработкаПриОшибкеНедостаточноПравДляВходаВПрограммуПослеПредупреждения",
			ЭтотОбъект, Параметры),
		ОписаниеОшибки);
	
КонецПроцедуры

// Завершает работу после предупреждения пользователя об ошибке недостатка прав для входа в программу.
Процедура ИнтерактивнаяОбработкаПриОшибкеНедостаточноПравДляВходаВПрограммуПослеПредупреждения(Параметры) Экспорт
	
	ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
	
КонецПроцедуры

// Предлагает пользователю сменить пароль или завершить работу.
Процедура ИнтерактивнаяОбработкаПриСменеПароляПриЗапуске(Параметры, Контекст) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПриВходеВПрограмму", Истина);
	
	ОткрытьФорму("ОбщаяФорма.СменаПароля", ПараметрыФормы,,,,, Новый ОписаниеОповещения(
		"ИнтерактивнаяОбработкаПриСменеПароляПриЗапускеЗавершение", ЭтотОбъект, Параметры));
	
КонецПроцедуры

// Продолжение процедуры ИнтерактивнаяОбработкаПриСменеПароляПриЗапуске.
Процедура ИнтерактивнаяОбработкаПриСменеПароляПриЗапускеЗавершение(Результат, Параметры) Экспорт
	
	Если Не ЗначениеЗаполнено(Результат) Тогда
		Параметры.Отказ = Истина;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
	
КонецПроцедуры

// Предлагает отключить аутентификацию OpenID-Connect после запуска.
Процедура ЗадатьВопросПроОтключениеOpenIDConnect(Контекст) Экспорт
	
	ОбработкаЗавершения = Новый ОписаниеОповещения(
		"ЗадатьВопросПроОтключениеOpenIDConnectЗавершение", ЭтотОбъект);
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Для пользователей включена аутентификация %1.
		           |Если такой вид аутентификации не используется, рекомендуется его отключить.'"),
		"OpenID-Connect");
	
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить("ОтключитьУВсехПользователей", НСтр("ru = 'Отключить у всех пользователей'"));
	Кнопки.Добавить("НеОтключать",                 НСтр("ru = 'Не отключать'"));
	Кнопки.Добавить("НапомнитьПозже",              НСтр("ru = 'Напомнить позже'"));
	
	ДополнительныеПараметры = СтандартныеПодсистемыКлиент.ПараметрыВопросаПользователю();
	ДополнительныеПараметры.Заголовок = НСтр("ru = 'Предупреждение безопасности'");
	ДополнительныеПараметры.ПредлагатьБольшеНеЗадаватьЭтотВопрос = Ложь;
	
	СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю(ОбработкаЗавершения,
		ТекстВопроса, Кнопки, ДополнительныеПараметры);
	
КонецПроцедуры

// Продолжение процедуры ЗадатьВопросПроОтключениеOpenIDConnect.
Процедура ЗадатьВопросПроОтключениеOpenIDConnectЗавершение(Результат, Параметры) Экспорт
	
	Ответ = ?(Результат <> Неопределено, Результат.Значение, "НапомнитьПозже");
	
	Если Ответ = "ОтключитьУВсехПользователей" Тогда
		СтандартныеПодсистемыВызовСервера.ОбработатьОтветПроОтключениеOpenIDConnect(Истина);
	ИначеЕсли Ответ = "НеОтключать" Тогда
		СтандартныеПодсистемыВызовСервера.ОбработатьОтветПроОтключениеOpenIDConnect(Ложь);
	КонецЕсли;
	
КонецПроцедуры

// Записывает в форму результат выбора назначения.
//
// Параметры:
//  РезультатЗакрытия - Неопределено
//                    - СписокЗначений
//  ДополнительныеПараметры - Структура:
//    * ДанныеФормы - ФормаКлиентскогоПриложения
//                  - РасширениеУправляемойФормыДляОбъектов:
//        ** Объект - ДанныеФормыСтруктура
//        ** Элементы - ВсеЭлементыФормы:
//              *** ВыбратьНазначение - КнопкаФормы
//    * ЭтоОтбор - Булево
//    * ОписаниеОповещения - ОписаниеОповещения
//
Процедура ПослеВыбораНазначения(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ДополнительныеПараметры.ЭтоОтбор Тогда
		Назначение = ДополнительныеПараметры.ДанныеФормы.Объект.Назначение;
		Назначение.Очистить();
	КонецЕсли;
	
	МассивСинонимов = Новый Массив;
	МассивТипов = Новый Массив;
	
	Для Каждого Элемент Из РезультатЗакрытия Цикл
		
		Если Элемент.Пометка Тогда
			МассивСинонимов.Добавить(Элемент.Представление);
			МассивТипов.Добавить(Элемент.Значение);
			Если Не ДополнительныеПараметры.ЭтоОтбор Тогда
				НоваяСтрока = Назначение.Добавить();
				НоваяСтрока.ТипПользователей = Элемент.Значение;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	ЗаголовокЭлемента = СтрСоединить(МассивСинонимов, ", ");
	
	Если ДополнительныеПараметры.ЭтоОтбор Тогда
		ДополнительныеПараметры.ДанныеФормы.ВидПользователей = ЗаголовокЭлемента;
	Иначе
		ДополнительныеПараметры.ДанныеФормы.Элементы.ВыбратьНазначение.Заголовок = ЗаголовокЭлемента;
	КонецЕсли;
	
	Если ДополнительныеПараметры.ОписаниеОповещения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещения, МассивТипов);
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Процедуры и функции обработки "НастройкиПользователей".

// Предназначена для открытия переданного отчета или формы.
//
// Параметры:
//  ТекущийЭлемент               - ТаблицаФормы - выделенная строка дерева значений.
//  Пользователь                 - Строка - имя пользователя информационной базы,
//  ТекущийПользователь          - Строка - имя пользователя информационной базы, для открытия формы
//                                 должен совпадать значением параметра "Пользователь".
//  ИмяФормыПерсональныхНастроек - Строка - путь для открытия формы персональных настроек.
//                                 Вида "ОбщаяФорма.НазваниеФормы".
//
Процедура ОткрытьОтчетИлиФорму(ТекущийЭлемент, Пользователь, ТекущийПользователь, ИмяФормыПерсональныхНастроек) Экспорт
	
	ЭлементДереваЗначений = ТекущийЭлемент;
	Если ЭлементДереваЗначений.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Пользователь <> ТекущийПользователь Тогда
		ТекстПредупреждения =
			НСтр("ru = 'Для просмотра настроек другого пользователя необходимо
			           |запустить программу от его имени и открыть нужную настройку.'");
		ПоказатьПредупреждение(,ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	Если ЭлементДереваЗначений.Имя = "НастройкиОтчетовДерево" Тогда
		
		КлючОбъекта = ЭлементДереваЗначений.ТекущиеДанные.Ключи[0].Значение;
		КлючОбъектаМассивСтрок = СтрРазделить(КлючОбъекта, "/", Ложь);
		КлючВарианта = КлючОбъектаМассивСтрок[1];
		ПараметрыОтчета = Новый Структура("КлючВарианта, КлючПользовательскихНастроек", КлючВарианта, "");
		
		Если ЭлементДереваЗначений.ТекущиеДанные.Тип = "НастройкаОтчета" Тогда
			КлючПользовательскихНастроек = ЭлементДереваЗначений.ТекущиеДанные.Ключи[0].Представление;
			ПараметрыОтчета.Вставить("КлючПользовательскихНастроек", КлючПользовательскихНастроек);
		КонецЕсли;
		
		ОткрытьФорму(КлючОбъектаМассивСтрок[0] + ".Форма", ПараметрыОтчета);
		Возврат;
		
	ИначеЕсли ЭлементДереваЗначений.Имя = "ВнешнийВид" Тогда
		
		Для Каждого КлючОбъекта Из ЭлементДереваЗначений.ТекущиеДанные.Ключи Цикл
			
			Если КлючОбъекта.Пометка = Истина Тогда
				
				ИмяФормы = СтрРазделить(КлючОбъекта.Значение, "/")[0];
				ИмяФормыЧастями = СтрРазделить(ИмяФормы, ".");
				Пока ИмяФормыЧастями.Количество() > 4 Цикл
					ИмяФормыЧастями.Удалить(4);
				КонецЦикла;
				ИмяФормы = СтрСоединить(ИмяФормыЧастями, ".");
				ОткрытьФорму(ИмяФормы);
				Возврат;
			Иначе
				РодительЭлемента = ЭлементДереваЗначений.ТекущиеДанные.ПолучитьРодителя();
				
				Если ЭлементДереваЗначений.ТекущиеДанные.ТипСтроки = "НастройкиРабочегоСтола" Тогда
					ПоказатьПредупреждение(,
						НСтр("ru = 'Для просмотра настроек рабочего стола перейдите к разделу
						           |""Рабочий стол"" в командном интерфейсе программы.'"));
					Возврат;
				КонецЕсли;
				
				Если ЭлементДереваЗначений.ТекущиеДанные.ТипСтроки = "НастройкиКомандногоИнтерфейса" Тогда
					ПоказатьПредупреждение(,
						НСтр("ru = 'Для просмотра настроек командного интерфейса
						           |выберите нужный раздел командного интерфейса программы.'"));
					Возврат;
				КонецЕсли;
				
				Если РодительЭлемента <> Неопределено Тогда
					ТекстПредупреждения =
						НСтр("ru = 'Для просмотра данной настройки откройте ""%1"" 
						           |и затем перейдите к форме ""%2"".'");
					ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПредупреждения,
						РодительЭлемента.Настройка, ЭлементДереваЗначений.ТекущиеДанные.Настройка);
					ПоказатьПредупреждение(,ТекстПредупреждения);
					Возврат;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
		ПоказатьПредупреждение(,НСтр("ru = 'Просмотр данной настройки не предусмотрен.'"));
		Возврат;
		
	ИначеЕсли ЭлементДереваЗначений.Имя = "ПрочиеНастройки" Тогда
		
		Если ЭлементДереваЗначений.ТекущиеДанные.Тип = "ПерсональныеНастройки"
			И ИмяФормыПерсональныхНастроек <> "" Тогда
			ОткрытьФорму(ИмяФормыПерсональныхНастроек);
			Возврат;
		КонецЕсли;
		
		ПоказатьПредупреждение(,НСтр("ru = 'Просмотр данной настройки не предусмотрен.'"));
		Возврат;
		
	КонецЕсли;
	
	ПоказатьПредупреждение(,НСтр("ru = 'Выберите настройку для просмотра.'"));
	
КонецПроцедуры

// Предназначена для формирования строки пояснения при копировании настроек.
//
// Параметры:
//  ПредставлениеНастройки            - Строка - название настройки. Используется если копируется одна настройка.
//  КоличествоНастроек                - Число  - количество настроек. Используется, если копируется две более настроек.
//  ПояснениеКомуСкопированыНастройки - Строка - кому копируются настройки.
//
// Возвращаемое значение:
//  Строка - текст пояснения при копировании настройки.
//
Функция ФормированиеПоясненияПриКопировании(ПредставлениеНастройки, КоличествоНастроек, ПояснениеКомуСкопированыНастройки) Экспорт
	
	Если КоличествоНастроек = 1 Тогда
		
		Если СтрДлина(ПредставлениеНастройки) > 24 Тогда
			ПредставлениеНастройки = Лев(ПредставлениеНастройки, 24) + "...";
		КонецЕсли;
		
		ПояснениеОповещения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '""%1"" скопирована %2'"),
			ПредставлениеНастройки,
			ПояснениеКомуСкопированыНастройки);
	Иначе
		ПрописьПредмета = Формат(КоличествоНастроек, "ЧДЦ=0") + " "
			+ ПользователиСлужебныйКлиентСервер.ПредметЦелогоЧисла(КоличествоНастроек,
				"", НСтр("ru = 'настройка,настройки,настроек,,,,,,0'"));
		
		ПояснениеОповещения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Скопировано %1 %2'"),
			ПрописьПредмета,
			ПояснениеКомуСкопированыНастройки);
	КонецЕсли;
	
	Возврат ПояснениеОповещения;
	
КонецФункции

// Формирует строку получателя настройки.
//
// Параметры:
//  КоличествоПользователей - Число  - используется, если значение больше единицы.
//  Пользователь            - Строка - имя пользователя. Используется, если количество пользователей
//                            равно единице.
//
// Возвращаемое значение:
//  Строка - пояснение кому копируется настройка.
//
Функция ПояснениеПользователи(КоличествоПользователей, Пользователь) Экспорт
	
	Если КоличествоПользователей = 1 Тогда
		ПояснениеКомуСкопированыНастройки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'пользователю ""%1""'"), Пользователь);
	Иначе
		ПояснениеКомуСкопированыНастройки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 пользователям'"), КоличествоПользователей);
	КонецЕсли;
	
	Возврат ПояснениеКомуСкопированыНастройки;
	
КонецФункции

#КонецОбласти
