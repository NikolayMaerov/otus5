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

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Таблица - см. УправлениеДоступом.ТаблицаНаборыЗначенийДоступа
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	// Логика ограничения для
	// - чтения:    Автор ИЛИ Исполнитель ИЛИ Проверяющий ИЛИ (Предмет И <исполнитель/проверяющий по адресации>).
	// - изменения: Автор.
	//
	// Если предмет не задан (т.е. бизнес-процесс без основания),
	// тогда предмет не участвует в логике ограничения.
	
	// Чтение, Изменение: набор № 1.
	Строка = Таблица.Добавить();
	Строка.НомерНабора     = 1;
	Строка.Чтение          = Истина;
	Строка.Изменение       = Истина;
	Строка.ЗначениеДоступа = Автор;
	
	// Чтение: набор № 2.
	Строка = Таблица.Добавить();
	Строка.НомерНабора     = 2;
	Строка.Чтение          = Истина;
	Строка.ЗначениеДоступа = Исполнитель;
	
	// Чтение: набор № 3.
	Строка = Таблица.Добавить();
	Строка.НомерНабора     = 3;
	Строка.Чтение          = Истина;
	Строка.ЗначениеДоступа = Проверяющий;
	
	МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
	Если ТипЗнч(Предмет) = Тип("СправочникСсылка.Пользователи") Тогда
		Строка = Таблица.Добавить();
		Строка.НомерНабора     = 4;
		Строка.Чтение          = Истина;
		Строка.ЗначениеДоступа = ГруппаИсполнителейЗадач;
		
		Строка = Таблица.Добавить();
		Строка.НомерНабора     = 5;
		Строка.Чтение          = Истина;
		Строка.ЗначениеДоступа = ГруппаИсполнителейЗадачПроверяющий;
		
		Строка = Таблица.Добавить();
		Строка.НомерНабора     = 6;
		Строка.ЗначениеДоступа = Предмет;
		
	ИначеЕсли ЗначениеЗаполнено(Предмет) И МодульУправлениеДоступом.ВозможноЗаполнитьНаборыЗначенийДоступа(Предмет) Тогда
		
		НаборыГруппыДоступаИсполнителей = УправлениеДоступом.ТаблицаНаборыЗначенийДоступа();
		Строка = НаборыГруппыДоступаИсполнителей.Добавить();
		Строка.НомерНабора     = 1;
		Строка.Чтение          = Истина;
		Строка.ЗначениеДоступа = ГруппаИсполнителейЗадач;
		
		Строка = НаборыГруппыДоступаИсполнителей.Добавить();
		Строка.НомерНабора     = 2;
		Строка.Чтение          = Истина;
		Строка.ЗначениеДоступа = ГруппаИсполнителейЗадачПроверяющий;
		
		НаборыПредмета = УправлениеДоступом.ТаблицаНаборыЗначенийДоступа();
		УправлениеДоступом.ЗаполнитьНаборыЗначенийДоступа(Предмет, НаборыПредмета, Ссылка);
		НаборыПредмета = НаборыПредмета.Скопировать(НаборыПредмета.НайтиСтроки(Новый Структура("Чтение", Истина)));
		
		// Умножение наборов предмета на наборы группы доступа исполнителей.
		УправлениеДоступом.ДобавитьНаборыЗначенийДоступа(НаборыПредмета, НаборыГруппыДоступаИсполнителей, Истина);
		
		// Добавление результата к таблице наборов.
		УправлениеДоступом.ДобавитьНаборыЗначенийДоступа(Таблица, НаборыПредмета);
		
	Иначе // Без зависимости от предмета.
		Строка = Таблица.Добавить();
		Строка.НомерНабора     = 4;
		Строка.Чтение          = Истина;
		Строка.ЗначениеДоступа = ГруппаИсполнителейЗадач;
		
		Строка = Таблица.Добавить();
		Строка.НомерНабора     = 5;
		Строка.Чтение          = Истина;
		Строка.ЗначениеДоступа = ГруппаИсполнителейЗадачПроверяющий;
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	БизнесПроцессыИЗадачиСервер.ПроверитьПраваНаИзменениеСостоянияБизнесПроцесса(ЭтотОбъект);
		
	УстановитьПривилегированныйРежим(Истина);
	ГруппаИсполнителейЗадач = БизнесПроцессыИЗадачиСервер.ГруппаИсполнителейЗадач(
		РольИсполнителя, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации);
	ГруппаИсполнителейЗадачПроверяющий = БизнесПроцессыИЗадачиСервер.ГруппаИсполнителейЗадач(
		РольПроверяющего, ОсновнойОбъектАдресацииПроверяющий, ДополнительныйОбъектАдресацииПроверяющий);
	УстановитьПривилегированныйРежим(Ложь);
		
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	Если РеквизитыАдресацииЗаполнены() Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Исполнитель");
	КонецЕсли;
	Если Не ПроверитьВыполнение Или Не РольПроверяющего.Пустая() Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Проверяющий");
	КонецЕсли;
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
		// Внешний пользователь при добавлении задания в качестве исполнителя может указывать только роли исполнителей.
	Если Пользователи.ЭтоСеансВнешнегоПользователя()
		И НедопустимыйИсполнительДляВнешнегоПользователя() Тогда
			Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоНовый() Тогда
		Автор = Пользователи.АвторизованныйПользователь();
		СрокИсполнения = ТекущаяДатаСеанса();
		Состояние = Перечисления.СостоянияБизнесПроцессов.Активен;
		Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Пользователи") Тогда
			Исполнитель = ДанныеЗаполнения;
		КонецЕсли;
	КонецЕсли;
	
	Если ДанныеЗаполнения <> Неопределено И ТипЗнч(ДанныеЗаполнения) <> Тип("Структура")
		И ДанныеЗаполнения <> Задачи.ЗадачаИсполнителя.ПустаяСсылка() Тогда
		Предмет = ДанныеЗаполнения;
	КонецЕсли;

	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка._ДемоСчетНаОплатуПокупателю") Тогда
		Если НЕ Пользователи.ЭтоСеансВнешнегоПользователя() 
			И ПравоДоступа("Чтение", Метаданные.Справочники.ВнешниеПользователи) Тогда
				ОбработкаЗаполненияДляВнешнегоПользователя(ДанныеЗаполнения);
		КонецЕсли;
		Проверяющий = Пользователи.АвторизованныйПользователь();
	КонецЕсли;

	БизнесПроцессыИЗадачиСервер.ЗаполнитьГлавнуюЗадачу(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДатаЗавершения = '00010101000000';
	Состояние = Перечисления.СостоянияБизнесПроцессов.Активен;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий элементов карты маршрута.

// Обработчик события ПередСозданиемЗадач. 
// 
// Параметры:
//  ТочкаМаршрутаБизнесПроцесса - ТочкаМаршрутаБизнесПроцессаСсылка._ДемоЗаданиеСРолевойАдресацией - точка маршрута
//      бизнес-процесса, на которой происходит создание задач.
//  ФормируемыеЗадачи - Массив из ЗадачаОбъект.ЗадачаИсполнителя - массив формируемых задач.
//  Отказ - Булево - признак отказа от добавления задачи. Если в теле процедуры-обработчика установить данному параметру
//                   значение Истина, то запись задач произведена не будет.
// 
Процедура ВыполнитьПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	
	Если НЕ РеквизитыАдресацииЗаполнены() Тогда
		
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	// Устанавливаем реквизиты адресации и доп. реквизиты для каждой задачи.
	Для каждого Задача Из ФормируемыеЗадачи Цикл
		
		Задача.Автор = Автор;
		Задача.Исполнитель = ?(ЗначениеЗаполнено(Исполнитель), Исполнитель, Неопределено);
		Задача.РольИсполнителя = ?(ЗначениеЗаполнено(РольИсполнителя), РольИсполнителя, Неопределено);
		Задача.ОсновнойОбъектАдресации = ОсновнойОбъектАдресации;
		Задача.ДополнительныйОбъектАдресации = ДополнительныйОбъектАдресации;
		Задача.Наименование = Наименование;
		Задача.СрокИсполнения = СрокИсполнения;
		Задача.Предмет = Предмет;
		Задача.Описание = Описание;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПоручениеИсполнителюПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	
	Если Задача.ДатаИсполнения > ТекущаяДатаСеанса() Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Фактическая дата выполнения задачи не может быть больше текущей даты.'"),
			Задача, "Объект.ДатаИсполнения");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьВыполнениеПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Результат = ПроверитьВыполнение; 
КонецПроцедуры

// Обработчик события ПриСозданииВложенныхБизнесПроцессов
// 
// Параметры:
//  ТочкаМаршрутаБизнесПроцесса - ТочкаМаршрутаБизнесПроцессаСсылка._ДемоЗаданиеСРолевойАдресацией - точка бизнес-процесса,
// 	                                                              на которой происходит создание вложенных бизнес-процессов.
//  ФормируемыеБизнесПроцессы - Массив из БизнесПроцессОбъект._ДемоЗаданиеСРолевойАдресацией - массив формируемых бизнес-процессов.
//  Отказ - Булево - признак отказа от записи и старта вложенных бизнес-процессов. Если в теле процедуры-обработчика установить
//                   данному параметру значение Истина, то запись и старт вложенных бизнес-процессов произведен не будет.
// 
Процедура ПроверитьПриСозданииВложенныхБизнесПроцессов(ТочкаМаршрутаБизнесПроцесса, ФормируемыеБизнесПроцессы, Отказ)
	
	Для Каждого БизнесПроцессПроверки Из ФормируемыеБизнесПроцессы Цикл
		 БизнесПроцессПроверки.Исполнитель = Проверяющий;
		 БизнесПроцессПроверки.РольИсполнителя = РольПроверяющего;
		 БизнесПроцессПроверки.ОсновнойОбъектАдресации = ОсновнойОбъектАдресацииПроверяющий;
		 БизнесПроцессПроверки.ДополнительныйОбъектАдресации = ДополнительныйОбъектАдресацииПроверяющий;
		 БизнесПроцессПроверки.Наименование = НСтр("ru = 'Проверить:'") + " " + Наименование;
		 БизнесПроцессПроверки.Автор = Автор;
		 БизнесПроцессПроверки.СрокИсполнения = СрокПроверки;
		 БизнесПроцессПроверки.Предмет = Предмет;
		 БизнесПроцессПроверки.Записать();
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗавершениеПриЗавершении(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	ДатаЗавершения = БизнесПроцессыИЗадачиСервер.ДатаЗавершенияБизнесПроцесса(Ссылка);
	Записать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбработкаЗаполненияДляВнешнегоПользователя(Знач ДанныеЗаполнения)
	
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВнешниеПользователи.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ВнешниеПользователи КАК ВнешниеПользователи
	|ГДЕ
	|	ВнешниеПользователи.ОбъектАвторизации = &ОбъектАвторизации");
	
	Запрос.УстановитьПараметр("ОбъектАвторизации", ДанныеЗаполнения.Партнер);
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Если РезультатЗапроса.Следующий() Тогда
		Исполнитель = РезультатЗапроса.Ссылка;
	КонецЕсли;

КонецПроцедуры

Функция РеквизитыАдресацииЗаполнены() 
	
	Возврат ЗначениеЗаполнено(Исполнитель) Или НЕ РольИсполнителя.Пустая();

КонецФункции

Функция НедопустимыйИсполнительДляВнешнегоПользователя()
	
	Если ТипЗнч(РольИсполнителя) = ТипЗнч(Справочники.РолиИсполнителей.ПустаяСсылка()) И НЕ ЗначениеЗаполнено(Исполнитель) Тогда
		ОбъектАвторизацииПустаяСсылка = Справочники[ВнешниеПользователи.ТекущийВнешнийПользователь().ОбъектАвторизации.Метаданные().Имя].ПустаяСсылка();
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	РолиИсполнителейНазначение.Ссылка
		|ИЗ
		|	Справочник.РолиИсполнителей.Назначение КАК РолиИсполнителейНазначение
		|ГДЕ
		|	РолиИсполнителейНазначение.ТипПользователей = &ТипПользователей
		|	И РолиИсполнителейНазначение.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", РольИсполнителя);
		Запрос.УстановитьПараметр("ТипПользователей", ОбъектАвторизацииПустаяСсылка);
		
		РезультатЗапроса = Запрос.Выполнить().Выбрать();
		
		Если РезультатЗапроса.Следующий() Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли