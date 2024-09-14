﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определить объекты метаданных, в формах списков которых
// будут выведены команды объединения дублей и замены ссылок
// см. ПоискИУдалениеДублейКлиент.ОбъединитьВыделенные и ПоискИУдалениеДублейКлиент.ЗаменитьВыделенные
// 
// Параметры:
//  Объекты - Массив из ОбъектМетаданных
//
// Пример:
//	Объекты.Добавить(Метаданные.Справочники._ДемоНоменклатура);
//	Объекты.Добавить(Метаданные.Справочники._ДемоКонтрагенты);
//
Процедура ПриОпределенииОбъектовСКомандойГрупповогоИзмененияОбъектов(Объекты) Экспорт

	// _Демо начало примера
	Объекты.Добавить(Метаданные.Справочники._ДемоНоменклатура);
	// _Демо конец примера

КонецПроцедуры

// Определить объекты метаданных, в модулях менеджеров которых ограничивается возможность 
// редактирования реквизитов при групповом изменении.
//
// Параметры:
//   Объекты - Соответствие из КлючИЗначение - в качестве ключа указать полное имя объекта метаданных,
//                            подключенного к подсистеме "Групповое изменение объектов". 
//                            Дополнительно в значении могут быть перечислены имена экспортных функций:
//                            "РеквизитыНеРедактируемыеВГрупповойОбработке",
//                            "РеквизитыРедактируемыеВГрупповойОбработке".
//                            Каждое имя должно начинаться с новой строки.
//                            Если указано "*", значит, в модуле менеджера определены обе функции.
//
// Пример: 
//   Объекты.Вставить(Метаданные.Документы.ЗаказПокупателя.ПолноеИмя(), "*"); // определены обе функции.
//   Объекты.Вставить(Метаданные.БизнесПроцессы.ЗаданиеСРолевойАдресацией.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
//   Объекты.Вставить(Метаданные.Справочники.Партнеры.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке
//		|РеквизитыНеРедактируемыеВГрупповойОбработке");
//
Процедура ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты) Экспорт
	
	// _Демо начало примера
	Объекты.Вставить(Метаданные.БизнесПроцессы._ДемоЗаданиеСРолевойАдресацией.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Документы._ДемоЗаказПокупателя.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники._ДемоВидыНоменклатуры.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники._ДемоКонтактныеЛицаПартнеров.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники._ДемоКонтрагенты.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники._ДемоНоменклатура.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники._ДемоНоменклатураПрисоединенныеФайлы.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники._ДемоОрганизации.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники._ДемоПартнеры.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники._ДемоПроектыПрисоединенныеФайлы.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники._ДемоСчетНаОплатуПокупателюПрисоединенныеФайлы.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	// _Демо конец примера
	
КонецПроцедуры

// Определяет реквизиты объекта, которые разрешается редактировать с помощью обработки группового изменения реквизитов.
// По умолчанию все реквизиты объекта разрешено редактировать. Для ограничения списка реквизитов необходимо заполнить
// одну из коллекций РедактируемыеРеквизиты и НередактируемыеРеквизиты. Если заполнены обе коллекции, то для разрешения
// неоднозначности приоритет отдается в пользу коллекции НередактируемыеРеквизиты.
// 
// Параметры:
//  Объект - ОбъектМетаданных - объект, для которого устанавливается список редактируемых реквизитов.
//  РедактируемыеРеквизиты - Неопределено, Массив из Строка - имена редактируемых групповой обработкой реквизитов объекта.
//                                                            Значение игнорируется, если заполнен параметр НередактируемыеРеквизиты.
//  НередактируемыеРеквизиты - Неопределено, Массив из Строка - имена не редактируемых групповой обработкой реквизитов объекта.
// 
Процедура ПриОпределенииРедактируемыхРеквизитовОбъекта(Объект, РедактируемыеРеквизиты, НередактируемыеРеквизиты) Экспорт

КонецПроцедуры

#КонецОбласти
