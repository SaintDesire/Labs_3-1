import xml.etree.ElementTree as ET

# Чтение файла test.txt
with open('test.txt', 'r', encoding='utf-8') as file:
    lines = file.readlines()

# Создание корневого элемента XML
root = ET.Element("streets")
root.text = '\n'

# Обработка каждой строки файла
for line in lines:
    # Разделение строки на отдельные значения
    values = line.strip().split('\t')

    # Проверка количества значений
    if len(values) >= 2:
        # Создание элемента улицы
        street = ET.SubElement(root, "street")
        street.text = '\n'

        # Создание элемента имени улицы
        name = ET.SubElement(street, "name")
        name.text = values[0]
        name.tail = '\n'

        # Создание элемента типа улицы
        type = ET.SubElement(street, "type")
        type.text = values[1]
        type.tail = '\n'

        street.tail = '\n'

# Создание объекта ElementTree и запись в файл
tree = ET.ElementTree(root)
tree.write("streets.xml", encoding="utf-8", xml_declaration=True)