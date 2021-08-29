user function MT160PLN()
Local	aPlan  := paramixb[1]
Local aAudi := paramixb[2]

for i := 1 to len(aPlan)
	for x := 1 to len(aPlan[i])
		aPlan[i][x][8]  := aPlan[i][x][7]
		aPlan[i][x][17] := aPlan[i][x][7] - dDatabase
	next
next
return {aPlan, aAudi}

