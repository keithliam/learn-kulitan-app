start = [
  'g',
  'k',
  'ng',
  't',
  'd',
  'n',
  'l',
  'm',
  'p',
  's',
  'b',
  'w',
  'y',
  'j'
]

mid = [
  'a',
  'á',
  'â',
  'aa',
  'i',
  'í',
  'î',
  'ii',
  'ia',
  'iu',
  'u',
  'ú',
  'û',
  'ua',
  'uu',
  'ui',
  'e',
  'o'
]

end = [
  'g',
  'k',
  'ng',
  't',
  'd',
  'n',
  'l',
  'm',
  'p',
  's',
  'b',
]

masterList = []

for s in start:
  for m in mid:
    for e in end:
      masterList.append(str(s) + str(m) + str(e))
    masterList.append(str(s) + str(m))

masterList += mid
masterList += ['íng', 'iing', 'queng', 'qng', 'qing', 'qe', 'q', 'ee', 'oo']

# string lengths
six = [glyph for glyph in masterList if len(glyph) == 6]
five = [glyph for glyph in masterList if len(glyph) == 5]
four = [glyph for glyph in masterList if len(glyph) == 4]
three = [glyph for glyph in masterList if len(glyph) == 3]
two = [glyph for glyph in masterList if len(glyph) == 2]
one = [glyph for glyph in masterList if len(glyph) == 1]

midEnd = []
mid.remove('ui')
mid.remove('ua')
mid.remove('iu')
mid.remove('ia')
for m in mid:
  for e in end:
    midEnd.append(str(m) + str(e))

def writeFile(file, arr, name):
  file.write('HashSet ' + name + ' = HashSet.from([\n')
  for s in arr:
    file.write("\t'" + s + "',\n")
  file.write(']);\n\n')
    
with open('kulitan_combinations.dart', 'w') as file:
  file.write("import 'dart:collection' show HashSet;\n\n")
  writeFile(file, one, 'one')
  writeFile(file, two, 'two')
  writeFile(file, three, 'three')
  writeFile(file, four, 'four')
  writeFile(file, five, 'five')
  writeFile(file, six, 'six')
  writeFile(file, mid, 'mid')
  writeFile(file, midEnd, 'midEnd')
  file.close()

print('Done writing all ' + str(len(masterList) + len(m) + len(midEnd)) + ' combinations to dart file.\n')