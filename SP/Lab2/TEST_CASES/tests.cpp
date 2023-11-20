#include "tests.h"

namespace tests
{
    // Тест 1: Проверка вставки и извлечения элемента
    BOOL test1(ht::HtHandle* htHandle)
    {
        ht::Element* insertEl = new ht::Element("test1", 6, "test1", 6);

        ht::insert(htHandle, insertEl);
        ht::Element* getEl = ht::get(htHandle, new ht::Element("test1", 6));

        // Проверяем, что извлеченный элемент соответствует вставленному
        if (
            getEl == NULL ||
            insertEl->keyLength != getEl->keyLength ||
            memcmp(insertEl->key, getEl->key, insertEl->keyLength) != 0 ||
            insertEl->payloadLength != getEl->payloadLength ||
            memcmp(insertEl->payload, getEl->payload, insertEl->payloadLength) != 0
            )
            return false;

        return true;
    }

    // Тест 2: Проверка удаления элемента
    BOOL test2(ht::HtHandle* htHandle)
    {
        ht::Element* element = new ht::Element("test2", 6, "test2", 6);

        ht::insert(htHandle, element);
        ht::removeOne(htHandle, element);

        // Проверяем, что элемент удален и не может быть извлечен
        if (ht::get(htHandle, element) != NULL)
            return false;

        return true;
    }

    // Тест 3: Проверка вставки существующего элемента
    BOOL test3(ht::HtHandle* htHandle)
    {
        ht::Element* element = new ht::Element("test3", 6, "test3", 6);

        ht::insert(htHandle, element);

        // Проверяем, что вторая вставка того же элемента завершается неудачей
        if (ht::insert(htHandle, element))
            return false;

        return true;
    }

    // Тест 4: Проверка удаления несуществующего элемента
    BOOL test4(ht::HtHandle* htHandle)
    {
        ht::Element* element = new ht::Element("test4", 6, "test4", 6);

        ht::insert(htHandle, element);
        ht::removeOne(htHandle, element);

        // Проверяем, что второе удаление того же элемента завершается неудачей
        if (ht::removeOne(htHandle, element))
            return false;

        return true;
    }

    // Тест 5: Проверка обновления элемента
    BOOL test5(ht::HtHandle* htHandle)
    {
        ht::Element* insertEl = new ht::Element("test5", 6, "test5", 6);

        ht::insert(htHandle, insertEl);
        ht::Element* updatedEl = new ht::Element("test5", 6, "updated_data", 12);
        ht::update(htHandle, insertEl, updatedEl->payload, updatedEl->payloadLength);

        // Проверяем, что элемент успешно обновлен
        ht::Element* getEl = ht::get(htHandle, updatedEl);
        if (
            getEl == NULL ||
            updatedEl->keyLength != getEl->keyLength ||
            memcmp(updatedEl->key, getEl->key, updatedEl->keyLength) != 0 ||
            updatedEl->payloadLength != getEl->payloadLength ||
            memcmp(updatedEl->payload, getEl->payload, updatedEl->payloadLength) != 0
            )
            return false;

        return true;
    }

    // Тест 6: Попытка получить несуществующий элемент
    BOOL test6(ht::HtHandle* htHandle)
    {
        ht::Element* getEl = ht::get(htHandle, new ht::Element("nonexistent_key", 15));

        // Проверяем, что попытка получения несуществующего элемента возвращает NULL
        if (getEl != NULL)
            return false;

        return true;
    }

    // Тест 7: Обработка ошибок при создании хэш-таблицы с недопустимыми параметрами
    BOOL test7()
    {
        try
        {
            ht::HtHandle* invalidHandle = ht::create(-1, 1, 100, 200, L"invalid_file.ht");
            // Если create() не выбросило исключение, тест завершается неудачей
            return false;
        }
        catch (const char* errorMessage)
        {
            // Проверяем, что сообщение об ошибке указывает на ошибку параметров
            if (strstr(errorMessage, "failed") == NULL)
                return false;
        }

        return true;
    }
}
