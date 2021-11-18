#Include "Protheus.ch"

//User Function CALLCHGXNU()// MostraFunc(OK)

//cNewMenu := ExecBlock("CALLCHGXNU",.F.,.F.,{__cUserId,cEmpAnt,cFilAnt,nModulo,cArqMenu})

//Local aAReaGER := GetArea()
//Local aArray   := PARAMIXB
//Local cID      := aArray[1]
//Local cEmpresa := aArray[2]
//Local cFilTmp  := aArray[3]
//Local cMenu    := aArray[5]

//U_MostraFunc(ProcName(),FunName())
//Public aInfCHGXNU := aClone(PARAMIXB)

/*
DbSelectArea("P99")
                                   
//If Select("SX2") <> 0 //.and. Upper(Alltrim(Getenvserv())) <> 'TREINAMENTO'
	P99->( dbSetOrder(2) )
	If P99->( dbSeek( xFilial() + cID + cEmpresa + cFilTmp + Alltrim(cMenu) ) )
		Reclock("P99",.F.)
		P99->P99_ACESSO += 1
		P99->P99_DTACES := Date()
		P99->( msUnlock() )
	Else
		Reclock("P99",.T.)
		P99->P99_FILIAL := xFilial("P99")
		P99->P99_ID     := cID
		P99->P99_CUSUAR := Subs(cUsuario,7,15)
		P99->P99_ACESSO := 1
		P99->P99_DTACES := Date()
		P99->P99_ROTINA := cRotina
		P99->P99_EMPRES := cEmpresa
		P99->P99_CFILIA := cFilTmp
		P99->P99_MENU   := Upper(cMenu)
		P99->( msUnlock() )
	EndIf
	P99->( dbCloseArea() )
//EndIf
*/
//RestArea(aAreaGER)

//Return aArray[5]
//
