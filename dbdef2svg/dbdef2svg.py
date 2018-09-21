import sys
import xml.etree.ElementTree as ET
import shutil
import os

tree = ET.parse(sys.argv[1])
root = tree.getroot()
outputPath = sys.argv[2]
print("Recreating directory " + outputPath)
if os.path.exists(outputPath):
    shutil.rmtree(outputPath)
os.mkdir(outputPath)

for table in root.findall('Table'):
    schema = table.get("schema")
    name = table.get("name")
    fullName = '[' + schema + '].[' + name + ']'
    fileName = schema + '.' + name + '.gv'
    print("Creating " + outputPath + "/" + fileName)
    f = open(outputPath + "/" + fileName, "w")
    f.write('digraph G {\n')
    for fkey in table.findall("ForeignKeys/ForeignKey"):
        fkSchema = fkey.get("referencedSchema")
        fkTable = fkey.get("referencedTable")
        fkFullName = '[' + fkSchema + '].[' + fkTable + ']'
        f.write('"' + fullName + '" -> "' + fkFullName + '"\n')

    for selfFk in root.findall('.//ForeignKey[@referencedTable="' + name + '"]/../..'):
        selfFkFullName = '[' + selfFk.get("schema") + '].[' + selfFk.get("name") + ']'
        f.write('"' + selfFkFullName + '" -> "' + fullName + '"\n')

    for fkey in table.findall("ForeignKeys/ForeignKey"):
        fkSchema = fkey.get("referencedSchema")
        fkTable = fkey.get("referencedTable")
        fkFullName = '[' + fkSchema + '].[' + fkTable + ']'
        svgPath = fkSchema + "." + fkTable + ".svg"
        f.write('"' + fkFullName + '" [href="' + svgPath + '"]\n')

    for selfFk in root.findall('.//ForeignKey[@referencedTable="' + name + '"]/../..'):
        svgPath = selfFk.get("schema") + "." + selfFk.get("name") + ".svg"
        selfFkFullName = '[' + selfFk.get("schema") + '].[' + selfFk.get("name") + ']'
        f.write('"' + selfFkFullName + '" [href="' + svgPath + '"]\n')
        
    f.write('}\n')
    f.close()
