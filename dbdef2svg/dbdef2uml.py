import sys
import xml.etree.ElementTree as ET
import shutil
import os

def IncludeSchema(schema):
    if len(sys.argv) < 3:
        return True
    pos = 3
    while pos < len(sys.argv):
        if sys.argv[pos] == schema:
            return True
        pos += 1
    return False

def IncludeSchemaTable(schematable):
    if len(sys.argv) < 3:
        return True
    pos = 3
    while pos < len(sys.argv):
        if sys.argv[pos] == schematable:
            return True
        pos += 1
    return False

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

    if IncludeSchema(schema) or IncludeSchemaTable(fullName):
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

    if IncludeSchema(schema) or IncludeSchemaTable(fullName):
        for fkey in table.findall("ForeignKeys/ForeignKey"):
            fkSchema = fkey.get("referencedSchema")
            fkTable = fkey.get("referencedTable")
            fkFullName = fkSchema + '.' + fkTable
            if IncludeSchema(fkSchema) or IncludeSchemaTable(fkFullName):
                f.write(fullName + ' }-- ' + fkFullName + '\n')

f.write('@enduml\n')
f.close()
