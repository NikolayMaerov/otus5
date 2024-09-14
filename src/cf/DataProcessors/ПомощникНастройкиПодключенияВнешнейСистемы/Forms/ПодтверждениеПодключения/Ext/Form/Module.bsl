﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("Корреспондент") Тогда
		ВызватьИсключение НСтр("ru = 'Некорректные параметры формы.'");
	КонецЕсли;
	
	ПараметрыПодключения = ОбменДаннымиСВнешнимиСистемами.ПриПолученииНастроекПодключенияВнешнейСистемы(
		Параметры.Корреспондент);
	
	// Заполнение формы.
	ИдентификаторОбмена = ПараметрыПодключения.НастройкиТранспорта.ИдентификаторОбмена;
	Корреспондент       = Параметры.Корреспондент;
	
	ЭтотОбъект.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Подтверждение подключения к %1'"),
		ПараметрыПодключения.НастройкиТранспорта.НаименованиеСистемы);
	
	Элементы.ДекорацияПерейти.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Перейти в <a href = ""%1"">%2</a>.'"),
			ПараметрыПодключения.НастройкиТранспорта.СсылкаНаВнешнююСистему,
			ПараметрыПодключения.НастройкиТранспорта.НаименованиеСистемы));
	
	УстановитьВидимостьДоступность(Элементы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияОшибкаОбработкаНавигационнойСсылки(
		Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка)
	
	ОбменДаннымиСВнешнимиСистемамиКлиент.ДекорацияОшибкаОбработкаНавигационнойСсылки(
		ЭтотОбъект,
		Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПолучитьПодтверждение(Команда)
	
	Если ПодтверждениеОбработано Тогда
		ЭтотОбъект.Закрыть();
		Возврат;
	КонецЕсли;
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	РезультатВыполнения = ПолучитьПодтверждениеПодключенияНаСервере(
		Корреспондент,
		ИдентификаторОбмена,
		ЭтотОбъект.УникальныйИдентификатор);
		
	ОповещениеОЗавершении = Новый ОписаниеОповещения(
		"ПолучитьПодтверждениеЗавершение",
		ЭтотОбъект);
	
	Если РезультатВыполнения.Статус = "Выполнено" Тогда
		ПолучитьПодтверждениеЗавершение(РезультатВыполнения, Неопределено);
		Возврат;
	КонецЕсли;
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаДлительнаяОперация;
	УстановитьВидимостьДоступность(Элементы);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		РезультатВыполнения,
		ОповещениеОЗавершении,
		ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ЭтотОбъект.Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПроверкаПодключения;
	УстановитьВидимостьДоступность(Элементы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьДоступность(Элементы)
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПроверкаПодключения Тогда
		Элементы.ПолучитьПодтверждение.Видимость  = Истина;
		Элементы.Отмена.Видимость = Истина;
		Элементы.Назад.Видимость  = Ложь;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаДлительнаяОперация Тогда
		Элементы.ПолучитьПодтверждение.Видимость  = Ложь;
		Элементы.Отмена.Видимость = Ложь;
		Элементы.Назад.Видимость  = Ложь;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаОшибкиПроверкиПодключения Тогда
		Элементы.ПолучитьПодтверждение.Видимость  = Ложь;
		Элементы.Отмена.Видимость = Истина;
		Элементы.Назад.Видимость  = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтображениеОшибки(Элементы, ОписаниеОшибки)
	
	Элементы.ДекорацияОшибка.Заголовок = ИнтернетПоддержкаПользователейКлиентСервер.ФорматированнаяСтрокаИзHTML(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1
				|
				|
				|Подробнее см. <a href = ""OpenLog"">журнал регистрации</a>.'"),
			ОписаниеОшибки));
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаОшибкиПроверкиПодключения;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПодтверждениеПодключенияНаСервере(
		Корреспондент,
		ИдентификаторОбмена,
		УникальныйИдентификатор)
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ИдентификаторОбмена", ИдентификаторОбмена);
	ПараметрыПроцедуры.Вставить("Корреспондент",       Корреспондент);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания =
		НСтр("ru = 'Создание новой настройки синхронизации данных с внешней системой.'");
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне(
		"Обработки.ПомощникНастройкиПодключенияВнешнейСистемы.ПолучитьПодтверждениеПодключения",
		ПараметрыПроцедуры,
		ПараметрыВыполнения);
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаКлиенте
Процедура ПолучитьПодтверждениеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		РезультатОперации = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		Если ЗначениеЗаполнено(РезультатОперации.КодОшибки) Тогда
			УстановитьОтображениеОшибки(
				Элементы,
				РезультатОперации.СообщениеОбОшибке);
			УстановитьВидимостьДоступность(Элементы);
		Иначе
			Если РезультатОперации.ПодтверждениеОбработано Тогда
				Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПроверкаПодключения;
				УстановитьВидимостьДоступность(Элементы);
				Элементы.ДекорацияКартинкаСостояниеПодключения.Картинка = БиблиотекаКартинок.НастройкаОбменаДаннымиАктивна;
				УстановитьЗаголовкиЭлементовПриУспешномЗавершении(Элементы);
				Элементы.Отмена.Видимость = Ложь;
			КонецЕсли;
			ПодтверждениеОбработано = РезультатОперации.ПодтверждениеОбработано;
		КонецЕсли;
		
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		УстановитьОтображениеОшибки(
			Элементы,
			Результат.КраткоеПредставлениеОшибки);
		УстановитьВидимостьДоступность(Элементы);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьЗаголовкиЭлементовПриУспешномЗавершении(Элементы)
	
	Элементы.ДекорацияНадписьСостояниеПодключения.Заголовок = НСтр("ru = 'Подтверждение подключения получено'");
	Элементы.ПолучитьПодтверждение.Заголовок = НСтр("ru = 'Готово'");
	
КонецПроцедуры

#КонецОбласти