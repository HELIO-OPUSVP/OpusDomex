User function OrcCod(cOpc)

Local aSaveArea	:= GetArea()
Local aSaveDA1	:= DA1->(GetArea())
Local aSaveSX7 	:= SX7->(GetArea())

Local cRet		:= ""

dbSelectArea("DA1")
dbSetOrder(1)
If dbSeek(xFilial()+M->CJ_TABELA+M->CK_PRODUTO)
	If cOpc	== "3"	//Se o campo for _SEUCOD
		cRet	:= DA1->DA1_SEUCOD	
	ElseIf cOpc == "4"	//Se o campo for _SEUDES
		cRet	:= DA1->DA1_MARGEM 
		ElseIf cOpc == "5"	//Se o campo for _SEUDES
		cRet	:= DA1->DA1_PRCVEN
		
		
	EndIf 	
	
EndIf                             

RestArea(aSaveDA1)
RestArea(aSaveSX7)
RestArea(aSaveArea)

Return(cRet)             

