&НаСервере
функция ПолучитьТалбличныйДокументИзТаблицыФормы(ТаблицаФормы)
	
	// Получаем имя Реквизита в котором Содержаться данные
	ПутьКТаблице = ТаблицаФормы.ПутьКДанным;
	
	// Создаем первоначальную СКД
	СКД =   Новый СхемаКомпоновкиДанных;
	Источник = СКД.ИсточникиДанных.Добавить();
	Источник.Имя = "ИсточникДанных";
	Источник.СтрокаСоединения = "";
	Источник.ТипИсточникаДанных = "Local";
	
	НаборДанных = СКД.НаборыДанных.Добавить(Тип("НаборДанныхОбъектСхемыКомпоновкиДанных"));
	НаборДанных.Имя = "ТаблицаЗначений";
	НаборДанных.ИсточникДанных = "ИсточникДанных";
	наборДанных.ИмяОбъекта = "Таблица";
	
	//Заполняем поля набора данных объект
	//Заполняем из реквизитов, потому что там есть заголовки и типы значений
	ПоляНабораДанных = НаборДанных.Поля;
	
	РеквизитыТаблицы = ПолучитьРеквизиты(ПутьКТаблице);
	Для Каждого РеквизитТаблицы Из РеквизитыТаблицы Цикл
		ПолеНабора = ПоляНабораДанных.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
		ПолеНабора.Поле = РеквизитТаблицы.Имя;
		ПолеНабора.ПутьКДанным = РеквизитТаблицы.Имя;
		//ПолеНабора.Заголовок =   РеквизитТаблицы.Заголовок
		ПолеНабора.ТипЗначения = РеквизитТаблицы.ТипЗначения;
	КонецЦикла;
	
	//Заполняем настройки: выбранные поля и условное оформление
	
	// Создадим первоначальную группировку с автополем, что бы 
	//выбирались все поля
	НастройкиКомпановкиДанных = Новый НастройкиКомпоновкиДанных;
	ВыбранныеПоля = НастройкиКомпановкиДанных.Выбор.Элементы;
	ВыборСКД  = НастройкиКомпановкиДанных.Выбор; 
	СтруктураКомпановки = НастройкиКомпановкиДанных.Структура;
	ГруппировкаКомпановки  = СтруктураКомпановки.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ГруппировкаКомпановки.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	
	// Соотвествие полей на форме и полей в формируемом СКД
	СоответствтиеПолейКД = Новый Соответствие;
	СоответствтиеПолейКД.Вставить(Новый ПолеКомпоновкиДанных(ПутьКТаблице),Новый ПолеКомпоновкиДанных(""));
	СоответствтиеПолейКД.Вставить(Новый ПолеКомпоновкиДанных(""),Новый ПолеКомпоновкиДанных(""));
	
	
	//Что бы не обходить рекурсией используем массив структур
	МассивЭУ_ПолейСКД = Новый Массив;
	МассивЭУ_ПолейСКД.Добавить(Новый Структура("ЭлементУправления, ПолеСКД",ТаблицаФормы,ВыборСКД));
	// Заполняем Выбранные поля в СКД из Элементов формы
	Для Каждого Элформы_Поле Из МассивЭУ_ПолейСКД Цикл
		ЭлементФормы = Элформы_Поле.ЭлементУправления;
		ПолеСКД  = Элформы_Поле.ПолеСКД;
		
		Для Каждого ПодчиненныйЭлемент  из ЭлементФормы.ПодчиненныеЭлементы Цикл
			Если ТипЗнч(ПодчиненныйЭлемент) = Тип("ПолеФормы") Тогда
				НовоеПоле = ПолеСКД.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
				ПутьКДанным = СтрЗаменить(ПодчиненныйЭлемент.ПутьКДанным,ПутьКТаблице + ".","");
				НовоеПоле.Поле = Новый ПолеКомпоновкиДанных(ПутьКДанным);
				НовоеПоле.Использование  = ПодчиненныйЭлемент.Видимость;
				
				//Заполним соответствие
				СоответствтиеПолейКД.Вставить(Новый ПолеКомпоновкиДанных(ПодчиненныйЭлемент.ПутьКДанным),
					Новый ПолеКомпоновкиДанных(ПутьКДанным));
				СоответствтиеПолейКД.Вставить(Новый ПолеКомпоновкиДанных(ПодчиненныйЭлемент.Имя),
					Новый ПолеКомпоновкиДанных(ПутьКДанным));
				
			ИначеЕсли ТипЗнч(ПодчиненныйЭлемент) = Тип("ГруппаФормы") Тогда 
				НовоеПоле = ПолеСКД.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));	
				НовоеПоле.Заголовок =  ПодчиненныйЭлемент.Заголовок;
				Новоеполе.Использование =  ПодчиненныйЭлемент.Видимость;
				РасположениеПолей  =  РасположениеПоляКомпоновкиДанных.Авто;
				Если ПодчиненныйЭлемент.Группировка = ГруппировкаКолонок.Вертикальная Тогда
					РасположениеПолей = РасположениеПоляКомпоновкиДанных.Вертикально;
				ИначеЕсли ПодчиненныйЭлемент.Группировка = ГруппировкаКолонок.ВЯчейке Тогда	
					РасположениеПолей = РасположениеПоляКомпоновкиДанных.Вместе;
				КонецЕсли;
				
				НовоеПоле.Расположение = РасположениеПолей;
				МассивЭУ_ПолейСКД.Добавить(Новый Структура("ЭлементУправления, ПолеСКД",ПодчиненныйЭлемент,НовоеПоле));
			КонецЕсли;
			
			
		КонецЦикла;	
	КонецЦикла;
	
	// Копируем условное оформление. Копируем только те, у которых есть Соответствие между формой и СКД
	Для Каждого Элемент_УО_формы Из УсловноеОформление.Элементы Цикл
		Элемент_УО_СКД = НастройкиКомпановкиДанных.УсловноеОформление.Элементы.Добавить();
		НеДобавлятьЭлемент = Ложь; 		                        
		
		/////////////////////Заполняем поля
		Для Каждого Поле_УО_Формы ИЗ Элемент_УО_формы.Поля.Элементы Цикл
			ПолеКомпоновки = СоответствтиеПолейКД[Поле_УО_Формы.Поле];
			Если ПолеКомпоновки <> Неопределено Тогда 
				Поле_УО_СКД = Элемент_УО_СКД.Поля.Элементы.Добавить();
				Поле_УО_СКД.Поле  =  ПолеКомпоновки;
			КонецЕсли;
			
		КонецЦикла;
		Если Элемент_УО_формы.Поля.Элементы.Количество() И 
			Элемент_УО_СКД.Поля.Элементы.Количество() = 0 Тогда
			НеДобавлятьЭлемент = Истина;	
		КонецЕсли;
		Если НеДобавлятьЭлемент Тогда
			НастройкиКомпановкиДанных.УсловноеОформление.Элементы.Удалить(Элемент_УО_СКД);			
		КонецЕсли;	
		
		///////////////Заполняем Отборы
		// Используем снова массив - что бы не пользоваться рекурсией
		МассивОтборов = Новый Массив;
		МассивОтборов.Добавить(Новый Структура("ЭлементыФормы, ЭлементыСКД",Элемент_УО_формы.Отбор,Элемент_УО_СКД.Отбор));
		
		Для Каждого ЭлементОтбора из МассивОтборов Цикл
			Для Каждого ЭлементОтбораФорма ИЗ ЭлементОтбора.ЭлементыФормы.Элементы Цикл
				Если ТипЗнч(ЭлементОтбораФорма)  = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
					НовыйЭлемент = ЭлементОтбора.ЭлементыСКД.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
					НовыйЭлемент.ТипГруппы   = ЭлементОтбораФорма.ТипГруппы ;
					МассивОтборов.Добавить(Новый Структура("ЭлементыФормы, ЭлементыСКД",ЭлементОтбораФорма,НовыйЭлемент));
					
				Иначе
					ЛевоеЗначение = СоответствтиеПолейКД[ЭлементОтбораФорма.ЛевоеЗначение];
					Если ЛевоеЗначение = Неопределено Тогда						
						Продолжить;						
					КонецЕсли;
					Если ТипЗнч(ЭлементОтбораФорма.ПравоеЗначение)  = Тип("ПолеКомпоновкиДанных") Тогда
						ПравоеЗначение = СоответствтиеПолейКД[ЭлементОтбораФорма.ПравоеЗначение];
						Если ПравоеЗначение = Неопределено Тогда
							Продолжить;
						КонецЕсли;		
						
					Иначе
						ПравоеЗначение = ЭлементОтбораФорма.ПравоеЗначение;
					КонецЕсли;
					
					НовыйЭлемент = ЭлементОтбора.ЭлементыСКД.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
					НовыйЭлемент.ВидСравнения = ЭлементОтбораФорма.ВидСравнения;
					НовыйЭлемент.ПравоеЗначение = ПравоеЗначение;
					НовыйЭлемент.ЛевоеЗначение = ЛевоеЗначение;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		//////////////////////Заполняем оформление
		
		Для Каждого оформление_УО_Формы ИЗ Элемент_УО_формы.Оформление.Элементы Цикл
			 Идентификатор = Элемент_УО_формы.Оформление.ПолучитьИдентификаторПоОбъекту(оформление_УО_Формы);
			 оформление_УО_СКД = Элемент_УО_СКД.Оформление.ПолучитьОбъектПоИдентификатору(Идентификатор);
			 ЗаполнитьЗначенияСвойств(оформление_УО_СКД,оформление_УО_Формы);
		КонецЦикла;
	КонецЦикла;
	
	////Выполняем по стандарту Компановку данных в Табличный документ
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиКомпановкиДанных);
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СКД));

	НастройкиКомпановкиДанных = КомпоновщикНастроек.ПолучитьНастройки();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СКД, НастройкиКомпановкиДанных);
	//Указываем данные для отображения
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("Таблица",ЭтотОбъект[ПутьКТаблице].Выгрузить());
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, , Истина);
	
	ПроцессорВывода  =  Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ТабличныйДокумент);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных,Истина);
	
	Возврат ТабличныйДокумент;
	
КонецФункции
