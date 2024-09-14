﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// См. УправлениеСвойствамиПереопределяемый.ЗаполнитьНаборыСвойствОбъекта
Процедура ЗаполнитьНаборыСвойствОбъекта(Объект, ТипСсылки, НаборыСвойств, СтандартнаяОбработка, КлючНазначения) Экспорт
	
	Если ТипСсылки = Тип("СправочникСсылка._ДемоПартнеры") Тогда
		ЗаполнитьНаборыСвойствПартнера(Объект, ТипСсылки, НаборыСвойств);
		
	ИначеЕсли ТипСсылки = Тип("СправочникСсылка._ДемоНоменклатура") Тогда
		ЗаполнитьНаборСвойствПоВидуНоменклатуры(Объект, ТипСсылки, НаборыСвойств);
		
	ИначеЕсли ТипСсылки = Тип("СправочникСсылка._ДемоКонтрагенты") Тогда
		
		ЗаполнитьНаборСвойствКонтрагентов(Объект, ТипСсылки, НаборыСвойств);
	КонецЕсли;
	
КонецПроцедуры

// См. УправлениеСвойствамиПереопределяемый.ПриПолученииПредопределенныхНаборовСвойств
Процедура ПриПолученииПредопределенныхНаборовСвойств(Наборы) Экспорт
	
	// Наборы справочника Демо: Контрагенты
	Набор = Наборы.Строки.Добавить();
	Набор.Имя = "Справочник__ДемоКонтрагенты";
	Набор.ЭтоГруппа = Истина;
	Набор.Идентификатор = Новый УникальныйИдентификатор("3001280c-f6ec-4fa9-bc4a-5eee8f177b60");
	
	ДочернийНабор = Набор.Строки.Добавить();
	ДочернийНабор.Имя = "Справочник_ДемоКонтрагенты_Основное";
	ДочернийНабор.Идентификатор = Новый УникальныйИдентификатор("766448ee-5143-4c28-820d-1d272302ab61");
	
	ДочернийНабор = Набор.Строки.Добавить();
	ДочернийНабор.Имя = "Справочник_ДемоКонтрагенты_Прочее";
	ДочернийНабор.Идентификатор = Новый УникальныйИдентификатор("3b4e0dcd-b7a6-4257-bc69-5118e7fb47e0");
	
	Набор = Наборы.Строки.Добавить();
	Набор.Имя = "Справочник__ДемоОрганизации";
	Набор.Идентификатор = Новый УникальныйИдентификатор("a4632c5e-a6c9-4141-83bc-be8e77ff1690");
	
КонецПроцедуры

// См. УправлениеСвойствамиПереопределяемый.ПриПолученииНаименованийНаборовСвойств.
Процедура ПриПолученииНаименованийНаборовСвойств(Наименования, КодЯзыка) Экспорт
	
	Наименования["Справочник_ДемоКонтрагенты_Основное"] = НСтр("ru = 'Основное';", КодЯзыка);
	Наименования["Справочник_ДемоКонтрагенты_Прочее"]   = НСтр("ru = 'Прочее';", КодЯзыка);
КонецПроцедуры

// См. УправлениеСвойствамиПереопределяемый.ПриНачальномЗаполненииЭлементов
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт

	// Наборы справочника Демо: Партнеры
	Набор = Элементы.Добавить();
	Набор.ИмяПредопределенногоНабора = "Справочник__ДемоПартнеры";
	Набор.ЭтоГруппа = Истина;
	Набор.Используется = Истина;
	Набор.Ссылка = Новый УникальныйИдентификатор("2c8d6c08-1d35-43ce-a690-32ccf53b03f2");
	МультиязычностьСервер.ЗаполнитьМультиязычныйРеквизит(Набор, "Наименование",
			"ru = 'Демо: Партнеры'", КодыЯзыков); // @НСтр-1
	
	ДочернийНабор = Элементы.Добавить();
	ДочернийНабор.Родитель = Новый УникальныйИдентификатор("2c8d6c08-1d35-43ce-a690-32ccf53b03f2");
	ДочернийНабор.ИмяПредопределенногоНабора = "Справочник_Партнеры_Клиенты";
	ДочернийНабор.Используется = Истина;
	ДочернийНабор.Ссылка = Новый УникальныйИдентификатор("277e1f06-e4f6-4c23-8d31-0d4347e207a2");
	МультиязычностьСервер.ЗаполнитьМультиязычныйРеквизит(ДочернийНабор, "Наименование",
		"ru = 'Клиент'", КодыЯзыков); // @НСтр-1
	
	ДочернийНабор = Элементы.Добавить();
	ДочернийНабор.Родитель = Новый УникальныйИдентификатор("2c8d6c08-1d35-43ce-a690-32ccf53b03f2");
	ДочернийНабор.ИмяПредопределенногоНабора = "Справочник_Партнеры_Конкуренты";
	ДочернийНабор.Используется = Истина;
	ДочернийНабор.Ссылка = Новый УникальныйИдентификатор("0bf6c2ff-000e-44ff-aae3-a41c7f9cb33a");
	МультиязычностьСервер.ЗаполнитьМультиязычныйРеквизит(ДочернийНабор, "Наименование",
		"ru = 'Конкурент'", КодыЯзыков); // @НСтр-1
	
	ДочернийНабор = Элементы.Добавить();
	ДочернийНабор.Родитель = Новый УникальныйИдентификатор("2c8d6c08-1d35-43ce-a690-32ccf53b03f2");
	ДочернийНабор.ИмяПредопределенногоНабора = "Справочник_Партнеры_Общие";
	ДочернийНабор.Используется = Истина;
	ДочернийНабор.Ссылка = Новый УникальныйИдентификатор("b6f8b9f2-087d-4429-9f19-25f1df5498f7");
	МультиязычностьСервер.ЗаполнитьМультиязычныйРеквизит(ДочернийНабор, "Наименование",
		"ru = 'Общие'", КодыЯзыков); // @НСтр-1
	
	ДочернийНабор = Элементы.Добавить();
	ДочернийНабор.Родитель = Новый УникальныйИдентификатор("2c8d6c08-1d35-43ce-a690-32ccf53b03f2");
	ДочернийНабор.ИмяПредопределенногоНабора = "Справочник_Партнеры_Поставщики";
	ДочернийНабор.Используется = Истина;
	ДочернийНабор.Ссылка = Новый УникальныйИдентификатор("d225a089-e318-494d-bdd8-d6a5c63cde23");
	МультиязычностьСервер.ЗаполнитьМультиязычныйРеквизит(ДочернийНабор, "Наименование",
		"ru = 'Поставщик'", КодыЯзыков); // @НСтр-1
	
	ДочернийНабор = Элементы.Добавить();
	ДочернийНабор.Родитель = Новый УникальныйИдентификатор("2c8d6c08-1d35-43ce-a690-32ccf53b03f2");
	ДочернийНабор.ИмяПредопределенногоНабора = "Справочник_Партнеры_Прочие";
	ДочернийНабор.Используется = Истина;
	ДочернийНабор.Ссылка = Новый УникальныйИдентификатор("d63aa128-926f-4e94-b3ad-d4e0f07d3d39");
	МультиязычностьСервер.ЗаполнитьМультиязычныйРеквизит(ДочернийНабор, "Наименование",
		"ru = 'Прочее'", КодыЯзыков); // @НСтр-1
	
	// Наборы справочника Демо: Номенклатура
	Набор = Элементы.Добавить();
	Набор.ИмяПредопределенногоНабора = "Справочник__ДемоНоменклатура";
	Набор.ЭтоГруппа = Истина;
	Набор.Используется = Истина;
	Набор.Ссылка = Новый УникальныйИдентификатор("c7cd91d8-6f8a-4d10-82bf-c6fba8475a98");
	МультиязычностьСервер.ЗаполнитьМультиязычныйРеквизит(Набор, "Наименование",
		"ru = 'Демо: Номенклатура'", КодыЯзыков); // @НСтр-1
	
	ДочернийНабор = Элементы.Добавить();
	ДочернийНабор.Родитель = Новый УникальныйИдентификатор("c7cd91d8-6f8a-4d10-82bf-c6fba8475a98");
	ДочернийНабор.ИмяПредопределенногоНабора = "Справочник__ДемоНоменклатура_Общие";
	ДочернийНабор.Используется = Истина;
	ДочернийНабор.Ссылка = Новый УникальныйИдентификатор("9265848a-53cc-470a-8778-20995e98f1ae");
	МультиязычностьСервер.ЗаполнитьМультиязычныйРеквизит(ДочернийНабор, "Наименование",
		"ru = 'Общие'", КодыЯзыков); // @НСтр-1
	
	// Наборы документа Демо: Счета на оплату покупателям
	Набор = Элементы.Добавить();
	Набор.ИмяПредопределенногоНабора = "Документ__ДемоСчетНаОплатуПокупателю";
	Набор.Используется = Истина;
	Набор.Ссылка = Новый УникальныйИдентификатор("aa635963-6b4d-4635-845d-100100ca2d4a");
	МультиязычностьСервер.ЗаполнитьМультиязычныйРеквизит(Набор, "Наименование",
		"ru = 'Демо: Счета на оплату покупателям'", КодыЯзыков); // @НСтр-1
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции.

// Получает наборы свойств партнера по установленным флагам.
// 
Процедура ЗаполнитьНаборыСвойствПартнера(Объект, ТипСсылки, НаборыСвойств)
	
	Если ТипЗнч(Объект) = ТипСсылки Тогда
		Партнер = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Объект, "Клиент, Конкурент, Поставщик, ПрочиеОтношения, ЭтоГруппа");
	Иначе
		Партнер = Объект;
	КонецЕсли;
	
	Если Партнер.ЭтоГруппа = Ложь Тогда
		
		Строка = НаборыСвойств.Добавить();
		Строка.Набор = УправлениеСвойствами.НаборСвойствПоИмени("Справочник_Партнеры_Общие");
		Строка.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
		Строка.ОтображатьЗаголовок = Истина;
		Строка.ОбщийНабор = Истина;
		Строка.Заголовок  = НСтр("ru = 'Для всех партнеров'");
		
		Если Партнер.Клиент Тогда
			Строка = НаборыСвойств.Добавить();
			Строка.Набор = УправлениеСвойствами.НаборСвойствПоИмени("Справочник_Партнеры_Клиенты");
			Строка.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
			Строка.Заголовок = НСтр("ru = 'Для клиентов'");
			Строка.ОтображатьЗаголовок = Истина;
		КонецЕсли;
		
		Если Партнер.Конкурент Тогда
			Строка = НаборыСвойств.Добавить();
			Строка.Набор = УправлениеСвойствами.НаборСвойствПоИмени("Справочник_Партнеры_Конкуренты");
			Строка.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
			Строка.ОтображатьЗаголовок = Истина;
			Строка.Заголовок = НСтр("ru = 'Для конкурентов'");
		КонецЕсли;
		
		Если Партнер.Поставщик Тогда
			Строка = НаборыСвойств.Добавить();
			Строка.Набор = УправлениеСвойствами.НаборСвойствПоИмени("Справочник_Партнеры_Поставщики");
			Строка.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
			Строка.ОтображатьЗаголовок = Истина;
			Строка.Заголовок = НСтр("ru = 'Для поставщиков'");
		КонецЕсли;
		
		Если Партнер.ПрочиеОтношения Тогда
			Строка = НаборыСвойств.Добавить();
			Строка.Набор = УправлениеСвойствами.НаборСвойствПоИмени("Справочник_Партнеры_Прочие");
			Строка.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
			Строка.ОтображатьЗаголовок = Истина;
			Строка.Заголовок = НСтр("ru = 'Для прочих'");
		КонецЕсли;
		
		// Свойства группы удаленных реквизитов.
		Строка = НаборыСвойств.Добавить();
		Строка.Набор = Справочники.НаборыДополнительныхРеквизитовИСведений.ПустаяСсылка();
		Строка.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
		Строка.ОтображатьЗаголовок = Истина;
		Строка.Заголовок = НСтр("ru = 'Более не используемые реквизиты'");
	КонецЕсли;
	
КонецПроцедуры

// Получает набор свойств объекта по виду номенклатуры.
Процедура ЗаполнитьНаборСвойствПоВидуНоменклатуры(Объект, ТипСсылки, НаборыСвойств)
	
	Строка = НаборыСвойств.Добавить();
	Строка.Набор = УправлениеСвойствами.НаборСвойствПоИмени("Справочник__ДемоНоменклатура_Общие");
	Строка.ОбщийНабор = Истина;
	
	Если ТипЗнч(Объект) = ТипСсылки Тогда
		Номенклатура = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Объект, "ЭтоГруппа, ВидНоменклатуры");
	Иначе
		Номенклатура = Объект;
	КонецЕсли;
	
	Если Номенклатура.ЭтоГруппа = Ложь Тогда
		Строка = НаборыСвойств.Добавить();
		Строка.Набор = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
			Номенклатура.ВидНоменклатуры, "НаборСвойств");
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьНаборСвойствКонтрагентов(Объект, ТипСсылки, НаборыСвойств)
	
	Строка = НаборыСвойств.Добавить();
	Строка.Набор = УправлениеСвойствами.НаборСвойствПоИмени("Справочник_ДемоКонтрагенты_Основное");
	
	Строка = НаборыСвойств.Добавить();
	Строка.Набор = УправлениеСвойствами.НаборСвойствПоИмени("Справочник_ДемоКонтрагенты_Прочее");
	
КонецПроцедуры

#КонецОбласти