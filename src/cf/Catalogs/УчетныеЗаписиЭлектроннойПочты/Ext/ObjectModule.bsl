﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ЗаполнитьОбъектЗначениямиПоУмолчанию();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ИспользоватьДляОтправки И Не ИспользоватьДляПолучения Тогда
		ПроверяемыеРеквизиты.Очистить();
		ПроверяемыеРеквизиты.Добавить("Наименование");
		Возврат;
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не ИспользоватьДляОтправки Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СерверИсходящейПочты");
	КонецЕсли;
	
	Если Не ИспользоватьДляПолучения И ПротоколВходящейПочты = "POP" Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СерверВходящейПочты");
	КонецЕсли;
		
	Если Не ПустаяСтрока(АдресЭлектроннойПочты) И Не ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(АдресЭлектроннойПочты, Истина) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Почтовый адрес заполнен неверно.'"), ЭтотОбъект, "АдресЭлектроннойПочты");
		МассивНепроверяемыхРеквизитов.Добавить("АдресЭлектроннойПочты");
		Отказ = Истина;
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ОбщегоНазначения.УдалитьДанныеИзБезопасногоХранилища(Ссылка);
	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Пользователь <> СокрЛП(Пользователь) Тогда
		Пользователь = СокрЛП(Пользователь);
	КонецЕсли;
	
	Если ПользовательSMTP <> СокрЛП(ПользовательSMTP) Тогда
		ПользовательSMTP = СокрЛП(ПользовательSMTP);
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.Свойство("НеПроверятьИзменениеНастроек") И Не Ссылка.Пустая() Тогда
		ТребуетсяПроверкаПароля = Справочники.УчетныеЗаписиЭлектроннойПочты.ТребуетсяПроверкаПароля(Ссылка, ЭтотОбъект);
		Если ТребуетсяПроверкаПароля Тогда
			ПроверкаПароля = Неопределено;
			Если Не ДополнительныеСвойства.Свойство("Пароль", ПроверкаПароля) Или Не ПарольВведенВерно(ПроверкаПароля) Тогда
				ТекстСообщенияОбОшибке = НСтр("ru = 'Не подтвержден пароль для изменения настроек учетной записи.'");
				ВызватьИсключение ТекстСообщенияОбОшибке;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УчетнаяЗаписьДляВосстановленияПароля = РаботаСПочтовымиСообщениямиСлужебный.НастройкиУчетнойЗаписиДляВосстановленияПароля();
	
	Если УчетнаяЗаписьДляВосстановленияПароля.Используется
		 И УчетнаяЗаписьДляВосстановленияПароля.УчетнаяЗаписьПочты = Ссылка Тогда
		
		Если Пользователи.ЭтоПолноправныйПользователь() Тогда
			
			УстановитьПривилегированныйРежим(Истина);
			ПарольSMTP = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Ссылка, "ПарольSMTP");
			УстановитьПривилегированныйРежим(Ложь);
			
			Настройки = ДополнительныеНастройкиАутентификации.ПолучитьНастройкиВосстановленияПароля();
			Настройки.АдресСервераSMTP = СерверИсходящейПочты;
			Настройки.ИмяОтправителя   = ИмяПользователя;
			Настройки.ИспользоватьSSL  = ИспользоватьЗащищенноеСоединениеДляИсходящейПочты;
			Настройки.ПарольSMTP       = ПарольSMTP;
			Настройки.ПользовательSMTP = ПользовательSMTP;
			Настройки.ПортSMTP         = ПортСервераИсходящейПочты;
			
			ДополнительныеНастройкиАутентификации.УстановитьНастройкиВосстановленияПароля(Настройки);
		Иначе
			ВызватьИсключение НСтр("ru='Настройки почты используются для восстановления пароля и
			|могут быть изменены только администратором.'");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьОбъектЗначениямиПоУмолчанию()
	
	ИмяПользователя = НСтр("ru = '1С:Предприятие'");
	ИспользоватьДляПолучения = Ложь;
	ИспользоватьДляОтправки = Ложь;
	ОставлятьКопииСообщенийНаСервере = Ложь;
	ПериодХраненияСообщенийНаСервере = 0;
	ВремяОжидания = 30;
	ПортСервераВходящейПочты = 110;
	ПортСервераИсходящейПочты = 25;
	ПротоколВходящейПочты = "POP";
	
	Если Предопределенный Тогда
		Наименование = НСтр("ru = 'Системная учетная запись'");
	КонецЕсли;
	
КонецПроцедуры

Функция ПарольВведенВерно(ПроверкаПароля)
	УстановитьПривилегированныйРежим(Истина);
	Пароли = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Ссылка, "Пароль,ПарольSMTP");
	УстановитьПривилегированныйРежим(Ложь);
	
	ПроверяемыеПароли = Новый Массив;
	Если ЗначениеЗаполнено(Пароли.Пароль) Тогда
		ПроверяемыеПароли.Добавить(Пароли.Пароль);
	КонецЕсли;
	Если ЗначениеЗаполнено(Пароли.ПарольSMTP) Тогда
		ПроверяемыеПароли.Добавить(Пароли.ПарольSMTP);
	КонецЕсли;
	
	Для Каждого ПроверяемыйПароль Из ПроверяемыеПароли Цикл
		Если ПроверкаПароля <> ПроверяемыйПароль Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли