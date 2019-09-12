import sys
import xml.etree.ElementTree as ET
import shutil
import os

tree = ET.parse(sys.argv[1])
root = tree.getroot()
outputPath = sys.argv[2]
print("Creating " + outputPath)
fileName = outputPath

f = open(outputPath, "w")
f.write('@startuml\n')

for table in root.findall('Table'):
    schema = table.get("schema")
    name = table.get("name")
    fullName = schema + '.' + name

    f.write('entity ' + fullName + ' {\n')

    for pkey in table.findall("PrimaryKey/Field"):
        f.write('  + ' + pkey.get('name') + ' [PK]\n')

    f.write('  --\n')

    for fkey in table.findall("Fields/Field"):
        found = table.find("PrimaryKey/Field[@name='" + fkey.get('name') + "']")
        if found is None:
            f.write('  ' + fkey.get('name') + '\n')

    f.write('}\n')

for table in root.findall('Table'):
    schema = table.get("schema")
    name = table.get("name")
    fullName = schema + '.' + name

    for fkey in table.findall("ForeignKeys/ForeignKey"):
        fkSchema = fkey.get("referencedSchema")
        fkTable = fkey.get("referencedTable")
        fkFullName = fkSchema + '.' + fkTable
        f.write(fullName + ' }-- ' + fkFullName + '\n')

f.write('@enduml\n')
f.close()
