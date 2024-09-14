﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Удаляет либо одну, либо все записи из регистра.
//
// Параметры:
//  Предмет  - ДокументСсылка
//           - СправочникСсылка
//           - Неопределено - предмет, для которого удаляется запись.
//                            Если указано значение Неопределено, то регистр будет
//                            очищен полностью.
//
Процедура УдалитьЗаписьИзРегистра(Предмет = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = СоздатьНаборЗаписей();
	Если Предмет <> Неопределено Тогда
		НаборЗаписей.Отбор.Предмет.Установить(Предмет);
	КонецЕсли;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Выполняет запись в регистр сведений для указанного предмета.
//
// Параметры:
//  Предмет                       - ДокументСсылка
//                                - СправочникСсылка - предмет, для которого выполняется запись.
//  КоличествоНеРассмотрено       - Число - количество не рассмотренных взаимодействий для предмета.
//  ДатаПоследнегоВзаимодействия  - Дата - дата последнего взаимодействия по предмету.
//  Активен                       - Булево - признак активности предмета.
//
Процедура ВыполнитьЗаписьВРегистр(Предмет,
	                              КоличествоНеРассмотрено = Неопределено,
	                              ДатаПоследнегоВзаимодействия = Неопределено,
	                              Активен = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если КоличествоНеРассмотрено = Неопределено И ДатаПоследнегоВзаимодействия = Неопределено И Активен = Неопределено Тогда
		
		Возврат;
		
	ИначеЕсли КоличествоНеРассмотрено = Неопределено ИЛИ ДатаПоследнегоВзаимодействия = Неопределено ИЛИ Активен = Неопределено Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	СостоянияПредметовВзаимодействий.Предмет,
		|	СостоянияПредметовВзаимодействий.КоличествоНеРассмотрено,
		|	СостоянияПредметовВзаимодействий.ДатаПоследнегоВзаимодействия,
		|	СостоянияПредметовВзаимодействий.Активен
		|ИЗ
		|	РегистрСведений.СостоянияПредметовВзаимодействий КАК СостоянияПредметовВзаимодействий
		|ГДЕ
		|	СостоянияПредметовВзаимодействий.Предмет = &Предмет";
		
		Запрос.УстановитьПараметр("Предмет",Предмет);
		
		Результат = Запрос.Выполнить();
		Если НЕ Результат.Пустой() Тогда
			
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			
			Если КоличествоНеРассмотрено = Неопределено Тогда
				КоличествоНеРассмотрено = Выборка.КоличествоНеРассмотрено;
			КонецЕсли;
			
			Если ДатаПоследнегоВзаимодействия = Неопределено Тогда
				ДатаПоследнегоВзаимодействия = ДатаПоследнегоВзаимодействия.Предмет;
			КонецЕсли;
			
			Если Активен = Неопределено Тогда
				Активен = Выборка.Активен;
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;

	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Предмет.Установить(Предмет);
	
	Запись = НаборЗаписей.Добавить();
	Запись.Предмет                      = Предмет;
	Запись.КоличествоНеРассмотрено      = КоличествоНеРассмотрено;
	Запись.ДатаПоследнегоВзаимодействия = ДатаПоследнегоВзаимодействия;
	Запись.Активен                      = Активен;
	НаборЗаписей.Записать();

КонецПроцедуры

// Блокирует РС СостоянияПредметовВзаимодействий.
// 
// Параметры:
//  Блокировка       - БлокировкаДанных - устанавливаемая блокировка.
//  ИсточникДанных   - ТаблицаЗначений - источник данных для блокировки.
//  ИмяПолеИсточника - Строка - имя поля источника, которое будет использовано для установки блокировки по предмету.
//
Процедура ЗаблокироватьСостоянияПредметовВзаимодействий(Блокировка, ИсточникДанных, ИмяПолеИсточника) Экспорт
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СостоянияПредметовВзаимодействий"); 
	ЭлементБлокировки.ИсточникДанных = ИсточникДанных;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Предмет", ИмяПолеИсточника);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли