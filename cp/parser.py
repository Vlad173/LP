gedcom = open('tree.ged', 'r' )
prolog = open('family.pl', 'w')
name = dict()

for line in gedcom:
	if "INDI" in line:
		ID = line [5:10]
	elif "NAME" in line:
		full_name = line [7:-2]
		full_name = full_name.replace('/', '')
	elif "_UID" in line:
		name[ID] = full_name
	elif "WIFE" in line:
		mother = line [10:15]
	elif "CHIL" in line:
		child = line [10:15] 
		prolog.write("mother('" + name[mother] + "', '" + name[child] + "').\n") 
# I go over the file for the second time so that the predicates went in order
gedcom.seek(0) 
for line in gedcom:
	if "HUSB" in line:
		father = line [10:15]
	elif "CHIL" in line:
		child = line [10:15] 
		prolog.write("father('" + name[father] + "', '" + name[child] + "').\n")

for key in name:
	prolog.write("sex('" + name[key] + "', '" + sex[key] + "').\n")

gedcom.close()
prolog.close()
