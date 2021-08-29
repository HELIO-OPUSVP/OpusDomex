#Include "Protheus.ch"

/*
User Function CHKEXEC()     

dbSelectarea("P08")
dbSetOrder(1)


	Local cRotina 	:= PARAMIXB
	Local cUser	  	:= __cUserID
	Local cModUser 	:= StrZero(nModulo,2)
	Local cEmp		:= cEmpAnt
	Local cFilEmp 	:= cFilAnt
	Local cNomeUser := cUserName
	Local cMenu		:= oApp:cFileXNU
	Local dData 	:= DDataBase
	Local cTime		:= Time()
	
	dbSelectArea("P99")

		Reclock("P99",.T.)
		P99->P99_FILIAL := xFilial("P99")
		P99->P99_ID     := cUser
		P99->P99_CUSUAR := cNomeUser
		P99->P99_ACESSO := 1
		P99->P99_DTACES := dData
		P99->P99_ROTINA := cRotina
		P99->P99_EMPRES := cEmp
		P99->P99_CFILIA := cFilEmp
		P99->P99_MENU   := cMenu
		P99->P99_MODULO := cModUser
		P99->P99_PRG	:= cTime
		P99->( msUnlock() )
	
	P99->( dbCloseArea() )
  
Return .T.
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณCHKEXEC() บAutor ณHelio Ferreira/Felipe Melo บ Dataณ07/05/12 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa criado para                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
User Function CHKEXEC() // MostraFunc(OK)
Local cRotina  := Paramixb
Local aAReaGER := GetArea()


//U_MostraFunc(ProcName(),FunName())
//if subs(cRotina,1,3)=="CFG"
//	return
//endif
// Acessos pelos Menus. Grava a rotina do Menu.
//If Upper(Alltrim(Getenvserv())) <> 'TREINAMENTO'
//If !(Upper(Alltrim(Getenvserv())) $ 'TREINAMENTO/HOMOLOGACAO') 
if type('aInfCHGXNU')<>'U'
	dbSelectArea("P99")
	P99->( dbSetOrder(1) )
	If P99->( dbSeek( xFilial() + __cUserID + cRotina ) )
		Reclock("P99",.F.)
		P99->P99_ACESSO += 1
		P99->P99_DTACES := Date()
		P99->( msUnlock() )
	Else
		Reclock("P99",.T.)
		P99->P99_FILIAL := xFilial("P99")
		P99->P99_ID     := __cUserID
		P99->P99_CUSUAR := Subs(cUsuario,7,15)
		P99->P99_ACESSO := 1
		P99->P99_DTACES := Date()
		P99->P99_ROTINA := cRotina
		P99->P99_EMPRES := aInfCHGXNU[2]
		P99->P99_CFILIA := aInfCHGXNU[3]
		P99->P99_MENU   := Upper(aInfCHGXNU[5])
		P99->( msUnlock() )
	EndIf
	P99->( dbCloseArea() )
//EndIf
endif

RestArea(aAreaGER)

Return
*/