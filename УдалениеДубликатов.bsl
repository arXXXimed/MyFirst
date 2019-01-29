&НаСервере
Процедура УдалитьДублирующиеЗаписиНаСервере()
	
	ВремяНачала 	= ТекущаяДата();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЦеныНоменклатурыПоставщиков.Регистратор КАК Регистратор,
	|	ЦеныНоменклатурыПоставщиков.Партнер КАК Партнер,
	|	ЦеныНоменклатурыПоставщиков.ВидЦеныПоставщика КАК ВидЦеныПоставщика,
	|	ЦеныНоменклатурыПоставщиков.Номенклатура КАК Номенклатура,
	|	ЦеныНоменклатурыПоставщиков.Характеристика КАК Характеристика,
	|	ЦеныНоменклатурыПоставщиков.Цена КАК Цена,
	|	ЦеныНоменклатурыПоставщиков.Упаковка КАК Упаковка,
	|	ЦеныНоменклатурыПоставщиков.Валюта КАК Валюта,
	|	ЦеныНоменклатурыПоставщиков.Период КАК Период
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатурыПоставщиков КАК ЦеныНоменклатурыПоставщиков
	|ГДЕ
	|	ЦеныНоменклатурыПоставщиков.Период МЕЖДУ &НачалоПериода И &КонецПериода
	|
	|УПОРЯДОЧИТЬ ПО
	|	Партнер,
	|	ВидЦеныПоставщика,
	|	Номенклатура,
	|	Характеристика,
	|	Период";
	Запрос.УстановитьПараметр("НачалоПериода", ПериодОбработки.ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода", ПериодОбработки.ДатаОкончания);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	
	ДанныеПредыдущейЗаписи = Новый Структура();
	ДанныеПредыдущейЗаписи.Вставить("Партнер");
	ДанныеПредыдущейЗаписи.Вставить("ВидЦеныПоставщика");
	ДанныеПредыдущейЗаписи.Вставить("Номенклатура");
	ДанныеПредыдущейЗаписи.Вставить("Характеристика");
	ДанныеПредыдущейЗаписи.Вставить("Цена");
	ДанныеПредыдущейЗаписи.Вставить("Упаковка");
	ДанныеПредыдущейЗаписи.Вставить("Валюта");
	
	
	КЭШДокументов = Новый Соответствие;
	
	Пока Выборка.Следующий() Цикл
		
		// Проверяем Запись с предыдущей записью
		ЗаписьДубликат = Ложь;
		Для Каждого КлючИЗначение из ДанныеПредыдущейЗаписи Цикл
			Если Выборка[КлючИЗначение.Ключ] <> КлючИЗначение.Значение Тогда // ЗаписьОставляем
				ЗаписьДубликат = Истина;
			КонецЕсли; 
			
		КонецЦикла;
		ЗаполнитьЗначенияСвойств(ДанныеПредыдущейЗаписи,Выборка);
		Если Не ЗаписьДубликат Тогда
			Продолжить;
		КонецЕсли;
		Если ТипЗнч(Выборка.Регистратор) <> Тип("ДокументСсылка.РегистрацияЦенНоменклатурыПоставщика") Тогда
			Продолжить;
		КонецЕсли;
		
		//Создаем структуру данных текущей записи
		
		ДанныеТекущейСтроки = Новый Структура;
		Для Каждого Колонка из Результат.Колонки Цикл
			ДанныеТекущейСтроки.Вставить(Колонка.Имя);			
		КонецЦикла;
		ЗаполнитьЗначенияСвойств(ДанныеТекущейСтроки,Выборка);
		
		МассивУдаляемыхЗаписей = КЭШДокументов.Получить(Выборка.Выборка);
		Если МассивУдаляемыхЗаписей = Неопределено Тогда
			МассивУдаляемыхЗаписей = Новый Массив;
			КЭШДокументов.Вставить(Выборка.Регистратор, МассивУдаляемыхЗаписей);
			
		КонецЕсли;
		МассивУдаляемыхЗаписей.Добавить(ДанныеТекущейСтроки);
	КонецЦикла;
	
	/// А тут можно обрабатывать документы и РС	
	///Достаочно исопльзовать Наш КЭШДокументов
	
	
	Длительность = ТекущаяДата() - ВремяНачала;
	
	Сообщить("Длительность: " + Длительность + "сек.");	
	
КонецПроцедуры
