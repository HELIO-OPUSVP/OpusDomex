// José Osmar Ferreira
// Função chamado pelo gatilho C6_PRODUTO (014/015)
// preenche os campos C6_SEUCOD e C6_SEUDES
// Estava toda comentada, em 02/03/2020 apenas habilitei e testei. 
//
User function SeuCodes(cOpc)

	Local aSaveArea		:= GetArea()
	Local aSaveDA1  	:= DA1->(GetArea())
	Local aSaveSX7 		:= SX7->(GetArea())
	Local cRet		   	:= ""
	Local aAreaSA7    	:= SA7->( GetArea() )
	Local nPC6_PRODUTO 	:= aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "C6_PRODUTO" })

	DA1->( dbSetOrder(1) )
	If !Empty(M->C5_TABELA)
		If DA1->( dbSeek(xFilial() + M->C5_TABELA + aCols[n,nPC6_PRODUTO]) )
			If cOpc	== "1"	   //Se o campo for _SEUCOD
				cRet	:= DA1->DA1_SEUCOD
			ElseIf cOpc == "2"	//Se o campo for _SEUDES
				cRet	:= DA1->DA1_SEUDES
			ElseIf cOpc == "3"	//Se o campo for _SEUDES
				cRet	:= DA1->DA1_PRCVEN
			EndIf
		Endif
	EndIf

	RestArea(aAreaSA7)
	RestArea(aSaveDA1)
	RestArea(aSaveSX7)
	RestArea(aSaveArea)

Return(cRet)
