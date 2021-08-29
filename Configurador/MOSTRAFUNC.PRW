#include "rwmake.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMostraFuncบAutor  ณHelio Ferreira      บ Data ณ  04/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo criada para exibir a Documenta็ใo de Cabe็alho de   บฑฑ
ฑฑบ          ณ programas personalizados. Chamado no inicio de todas User  บฑฑ
ฑฑบ          ณ Functions.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Pelican - Uso generico                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//                       Fun็ใo  prw
User Function MostraFunc(cProcName,cFunName) // MostraFunc(OK)

Local aAreaGER := GetArea()
Local cFunc,lX6

Return

lX6 := .T.

IF TYPE('cUsuario') = "U"
	aAbreTab := {"P99"}
	RPCSetType(3)
	RpcSetEnv("01", "01",,,,,aAbreTab) //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"

	cUsuario := "SISTEMA"
	lX6 := .F.
ENDIF

//If Upper(Alltrim(Getenvserv())) <> 'TREINAMENTO'
	IF lX6 = .T.
		If Alltrim(Subs(cUsuario,7,14)) $ Alltrim(GetMV("MV_PLUSUPE"))
			//msgAlert(cDesc)
		EndIf
	Endif
	If Upper(Subs(cProcName,1,2)) == 'U_'
		cFunc := Alltrim(Subs(cProcName,3))
	Else
		cFunc := Alltrim(cProcName)
	EndIf
	
	dbSelectArea("P99")
	P99->( dbSetOrder(1) )
	
	If P99->( dbSeek( xFilial() + __cUserID + cFunc + '()' ) )
		Reclock("P99",.F.)
		P99->P99_ACESSO += 1
		P99->P99_DTACES := Date()
		If Empty(P99->P99_PRG)
			P99->P99_PRG    := RetPrg(cFunName)[1]
		EndIf
		P99->( msUnlock() )
	Else
		Reclock("P99",.T.)
		P99->P99_FILIAL := xFilial("P99")
		P99->P99_ID     := __cUserID
		P99->P99_CUSUAR := Subs(cUsuario,7,15)
		P99->P99_ACESSO := 1
		P99->P99_DTACES := Date()
		P99->P99_ROTINA := cFunc+'()'
		P99->P99_PRG    := RetPrg(cFunName)[1]
		P99->P99_EMPRES := aInfCHGXNU[2]
		P99->P99_CFILIA := aInfCHGXNU[3]
		P99->P99_MENU   := Upper(aArray[5])
		P99->( msUnlock() )
	EndIf
	
	P99->( dbCloseArea() )
//EndIf

RestArea(aAreaGER)

Return

Static Function RetPrg(cPesquisa)

Local _aRetorno := {}
Local cProg     := Alltrim(cPesquisa)

aInfoPrw := getApoInfo( cProg+'.prw' )

If !Empty(aInfoPrw)
	AADD(_aRetorno,aInfoPrw[1])
	AADD(_aRetorno,aInfoPrw[3])
Else
	aInfoPrw := getApoInfo( cProg+'.prx' )
	If !Empty(aInfoPrw)
		AADD(_aRetorno,aInfoPrw[1])
		AADD(_aRetorno,aInfoPrw[3])
	Else
		AADD(_aRetorno,'')
		AADD(_aRetorno,'BUILD_USER')
	EndIf
EndIf

Return _aRetorno



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMostraSIX บAutor  ณ Felipe A. Melo     บ Data ณ  04/10/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MostraSIX(cNomeAlias,nNumIndex,cNomePRW)

Local aAreaGER    := GetArea()

Local cP99_ID     := ""
Local cP99_ROTINA := ""
Local cNewUsuario := ""

Default cNomeAlias := ""
Default nNumIndex  := 0
Default cNomePRW   := ""

If Type('cUsuario') = "U"
	aAbreTab := {"P99"}
	RPCSetType(3)
	RpcSetEnv("01", "01",,,,,aAbreTab) //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"

	cNewUsuario := "SISTEMA"
Else
	cNewUsuario := Subs(cUsuario,7,15)
EndIf

If Upper(Alltrim(Getenvserv())) <> 'TREINAMENTO'
	dbSelectArea("P99")
	P99->( dbSetOrder(1) )
	
	cP99_ID     := Upper(AllTrim(cNomeAlias))+"-"+StrZero(nNumIndex,3)
	cP99_ROTINA := Upper(AllTrim(cNomePRW))
	
	If P99->( dbSeek( xFilial() + cP99_ID + cP99_ROTINA ) )
		If Reclock("P99",.F.)
			P99->P99_ACESSO += 1
			P99->P99_DTACES := Date()
			P99->( msUnlock() )
		EndIf
	Else
		Reclock("P99",.T.)
		P99->P99_FILIAL := xFilial("P99")
		P99->P99_ID     := cP99_ID
		P99->P99_CUSUAR := cNewUsuario
		P99->P99_ACESSO := 1
		P99->P99_DTACES := Date()
		P99->P99_ROTINA := cP99_ROTINA
		P99->P99_PRG    := "DBSETORDER"
		P99->( msUnlock() )
	EndIf
	
	P99->( dbCloseArea() )
EndIf

RestArea(aAreaGER)

Return