//1. сериализация , изменение сериализованного объекта , и обратная десериализация 
//Пример: 
&НаКлиенте
Процедура УдалитьФорматСтрокТабличногоДокумента(Команда)
// Сериализуем наш табличный документ в объект XDTO
ОбъектXDTO = СериализаторXDTO.ЗаписатьXDTO(ТабличныйДокумент);
// Ищем списокXDTO описывающий колонки
Колонки_XDTO = ОбъектXDTO.columns;
сч = Колонки_XDTO.Количество()-1;
Пока Сч  >= 0 Цикл
    КолонкаXDTO = Колонки_XDTO[сч];
    // Если колонка имеет свой собственный ID, тогда некоторые строки на него ссылаются
    // это и есть те строки, которые имеют собственный формат
    Если ЗначениеЗаполнено(КолонкаXDTO.id) Тогда
        // удаляем эти колонки
        Колонки_XDTO.Удалить(Сч);
    КонецЕсли;
    Сч = Сч-1;
КонецЦикла;
// Десериализуем объектXDTO обратно в табличный документ
ТабличныйДокумент = СериализаторXDTO.ПрочитатьXDTO(ОбъектXDTO);
КонецПроцедуры



//2. Копирование области в пустую часть, и удаление области с собственным форматом 
//Пример: 
&НаСервере
Процедура УдалитьФорматСтрокТабличногоДокументаНаСервере()
	// Попытаемся установить у всех колонок одинаковую ширину
	// в данном случае у всех строк Табличного документа станет собственный но одинаковый 
	// формат
	ТабличныйДокумент.Область().СоздатьформатСтрок();
	// Запоминаем высоту и ширину области с данными, что бы потом удалить ненужную область
	ВысотаТаблицы = ТабличныйДокумент.ВысотаТаблицы;
	ШиринаТаблицы = ТабличныйДокумент.ШиринаТаблицы;
	// Здесь нужно взять именно область типа "прямоугольник", иначе собственные форматы строк скопируются
	// больше всего и было потрачено времени на поиск этой особенности
	ОбластьТД = ТабличныйДокумент.Область(1, 1, ВысотаТаблицы, ШиринаТаблицы);
	// Вставляем нашу область в область табличного документа без собственного формата
	// ширины колонок при этом возьмуться из общего табличного документа
	ТабличныйДокумент.ВставитьОбласть(ОбластьТД, ТабличныйДокумент.Область(ВысотаТаблицы + 1, 1));
	// удаляем изначальную область. Здесь уже обязательно нужно удалять область типа "строки"
	ТабличныйДокумент.УдалитьОбласть(ТабличныйДокумент.Область(1, , ВысотаТаблицы), ТипСмещенияТабличногоДокумента.ПоВертикали);
КонецПроцедуры
