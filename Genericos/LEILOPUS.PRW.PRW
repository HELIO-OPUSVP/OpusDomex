//#INCLUDE 'PARMTYPE.CH'
#include "rwmake.ch"
//#INCLUDE 'FWBROWSE.CH'
#include "protheus.ch"
//#INCLUDE 'FWMVCDEF.CH'
#include "TbiCode.ch"
#include "TOpconn.ch"

User Function LEILOPUS()

Local nLinha   := 0
Local nColuna  := 0
Local nLargura := 350  // GetScreenRes()[1]    //299
Local nAltura  := 412  // GetScreenRes()[2]-20 //412
//Local nLCampos := 0
//Local nCCampos := 0

Local nLargBut := 130
Local nAltuBut := 20

Local cQuery 	:= ""
Local nK 		:= 0
Private aDeptos  := {}
Private aAparelhos := {Space(3)}	
Private cHora    := Time()
Private dData    := Date()
Private nVlrLance:= 0
Private cAparelho:= Space(3)
Private cNome := Space(50)
Private cDepto := Space(35)
Private cODBC     := "PROTHEUS12"
Private cServidor := "172.30.5.4"
Private nTcConn 	:= 0
Private nPorta	   := 7890             
Private nUmMinuto := 60000


TCCONTYPE("TCPIP")

nTcConn := TCLINK( "@!!@MSSQL/"+cODBC,  cServidor, nPorta)

If (nTcConn < 0 )
	Alert ("Erro de conexao!")
	Return
EndIf

TCSETCONN(nTcConn)

// TCUnLink()
cQuery := " SELECT LTRIM(RTRIM(QB_DEPTO)) + '-' + QB_DESCRIC DEPTO FROM SQB010 SQB WHERE SQB.D_E_L_E_T_ ='' AND SQB.QB_FILIAL  ='' "


If Select("TRBDP") <> 0
   TRBDP->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "TRBDP"

aDeptos := {}
AaDd(aDeptos,Space(35))
If TRBDP->( !EOF() )
	While TRBDP->(!EOF())
		AaDd(aDeptos,TRBDP->DEPTO)
		TRBDP->(DbSkip())
	EndDo
EndIf

If Select("TRBDP") <> 0
   TRBDP->( dbCloseArea() )
EndIf

For nK := 1 to 30
	AaDd(aAparelhos,STRZERO(nK,3))
Next nK

DEFINE MSDIALOG oMainWnd TITLE "Leilão Rosemberger" FROM nLinha,nColuna TO nLinha+nAltura,nColuna+nLargura  PIXEL

nLin := 10
nCol := 10

@ nLin  , nCol	SAY   oTxt1      Var 'Cod. Aparelho:'  SIZE 60,10 PIXEL
//@ nLin-3, 070  MSGET oAparelho VAR cAparelho    Picture "@R 999"     SIZE 50,09 PIXEL
@ nLin-3, 070  COMBOBOX oAparelho VAR cAparelho ITEMS aAparelhos /*Valid fCliente()*/ SIZE 100,20  VALID .T. PIXEL

nLin += 30

@ nLin  , nCol	SAY   oTxt2      Var 'Seu Nome:'       SIZE 60,10 PIXEL
@ nLin-3, 070  MSGET oNome       VAR  cNome         Picture "@!"  WHEN  VldCpoWhen("1")    SIZE 100,15 PIXEL

nLin += 30


@ nLin  , nCol	SAY   oTxt3      Var 'Departamento:'       SIZE 60,10 PIXEL
//@ nLin-3, 040  MSGET oDepto       VAR  cDepto 		         Picture "@!" WHEN VldCpoWhen("2")     SIZE 100,09 PIXEL
@ nLin-3, 070  COMBOBOX oDepto VAR cDepto ITEMS aDeptos /*Valid fCliente()*/ SIZE 100,20 WHEN VldCpoWhen("2") VALID .T. PIXEL

nLin += 30

@ nLin  , nCol	SAY   oTxt4      Var 'Valor do Lance:'       SIZE 60,10 PIXEL
@ nLin-3, 070  MSGET oVlrLance   VAR  nVlrLance          Picture "@E 999,999.99"  WHEN VldCpoWhen("3")     SIZE 55,20 PIXEL

nLin += 30

@ nLin  , nCol	SAY   oTxt5      Var 'Data do Lance:'       SIZE 60,10 PIXEL
@ nLin-3, 070  MSGET oData      VAR dData         Picture "@D" WHEN .F.        SIZE 50,09 PIXEL

nLin += 20
@ nLin  , nCol SAY   oTxt6      Var 'Hora do Lance:'       SIZE 60,10 PIXEL
@ nLin-3, 070  MSGET oHora  VAR cHora         Picture "@R 99:99:99"  When .F. SIZE 40,09 PIXEL

nLin += 20
//@ nLin  , nCol	SAY oTxt3 Var 'Cliente:'    SIZE 30,10 PIXEL
//@ nLin-3, 040  COMBOBOX oCombo1  VAR cCliente ITEMS aClientes Valid fCliente()   SIZE 55,10 VALID .T. PIXEL

oTxt1:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
oTxt2:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
oTxt3:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
oTxt4:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
oTxt5:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
oTxt6:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)

//oTxt3:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)

//@ nLin-45  , nCol + 090 BUTTON "+1"     ACTION Processa( {|| Botao(1) } ) SIZE 20,20 PIXEL
//@ nLin-45  , nCol + 115 BUTTON "+10"    ACTION Processa( {|| Botao(2) } ) SIZE 20,20 PIXEL
//@ nLin-45  , nCol + 140 BUTTON "+60"    ACTION Processa( {|| Botao(9) } ) SIZE 20,20 PIXEL

//@ nLin-14  , nCol + 090 BUTTON "-1"     ACTION Processa( {|| Botao(3) } ) SIZE 20,20 PIXEL
//@ nLin-14  , nCol + 115 BUTTON "-10"    ACTION Processa( {|| Botao(4) } ) SIZE 20,20 PIXEL
//@ nLin-14  , nCol + 140 BUTTON "-60"    ACTION Processa( {|| Botao(10) } ) SIZE 20,20 PIXEL

DEFINE TIMER oTimer INTERVAL (nUmMinuto*1) ACTION (ProcRun())  OF oMainWnd // 60000 = 60 segundos
		
ACTIVATE TIMER oTimer

	

//oTimer:= TTimer():New((nTimeOut-nTimeMsg),{|| MsgTimer(nTimeMsg,oDlg1) },oDlg1) // Ativa timer
	
//oTimer:Activate()

nCol01    := 10
nCol02    := 20
nSkipBut  := 25

nLin += 05

//@ nLin, nCol01 MSGET oConflance   VAR "cEntrad1"    Picture "@R 99:99" WHEN .F. SIZE 05,nAltuBut-3 PIXEL
@ nLin, nCol02 BUTTON "CONFIRMAR LANCE" ACTION Processa( {|| GravaLance() } ) SIZE nLargBut,nAltuBut PIXEL //OF oScroll

//nLin += nSkipBut

//@ nLin, nCol01 MSGET oSaida   VAR cSaida2    Picture "@R 99:99" WHEN .F. SIZE 05,nAltuBut-3 PIXEL
//@ nLin, nCol02 BUTTON "SAIR"  ACTION Processa( {|| Return()} ) SIZE nLargBut,nAltuBut PIXEL //OF oScroll

/*
nLin += nSkipBut

@ nLin, nCol01 MSGET oSaida1   VAR cSaida1    Picture "@R 99:99" WHEN .F. SIZE 05,nAltuBut-3 PIXEL
@ nLin, nCol02 BUTTON "SAÍDA para almoço"  ACTION Processa( {|| Botao(6) } ) SIZE nLargBut,nAltuBut PIXEL //OF oScroll

nLin += nSkipBut

@ nLin, nCol01 MSGET oEntrad2   VAR cEntrad2    Picture "@R 99:99" WHEN .F. SIZE 05,nAltuBut-3 PIXEL
@ nLin, nCol02 BUTTON "RETORNO do almoço"  ACTION Processa( {|| Botao(7) } ) SIZE nLargBut,nAltuBut PIXEL //OF oScroll
*/

ACTIVATE MSDIALOG oMainWnd   //ON INIT EnchoiceBar( oMainWnd,{|| oMainWnd:End()},{|| oMainWnd:End()} )

Return

Static Function GravaLance()
Local lRet := .F.

If !Empty(Alltrim(cAparelho)) .And. !Empty(Alltrim(cNome)) .And. !Empty(Alltrim(cDepto)) .And. nVlrLance > 0

	Startjob("U_LanceJob",getenvserver(),.F.,cAparelho,cNome,cDepto,nVlrLance,dData,cHora)
	nVezesAnalise := 5000
	lContinua	:= .T.
	nCont := 0
	
	While lContinua .And. nCont <= nVezesAnalise 
		nCont ++
		cQryAnalis := "SELECT * FROM ZZO010 ZZO WHERE ZZO.ZZO_APAREL = '" + STRZERO(Val(cAparelho),3) + "' "		
		cQryAnalis += " AND ZZO.ZZO_NOME = '" + Alltrim(cNome)+"'  AND ZZO.ZZO_VLANCE = " + Alltrim(Str(nVlrLance)) +  " 
		cQryAnalis += " AND ZZO.ZZO_DATA = '" + DTOS(dData) + "' AND ZZO.ZZO_HORA = '" + cHora + "' "
		
		If Select("TZZO") > 0
			TZZO->(DbCloseArea())
		EndIf 
		TCQUERY cQryAnalis NEW ALIAS "TZZO"
		If TZZO->(!EOF())
			lRet := .T.
			lContinua := .F.
		EndIf
		If Select("TZZO") > 0
			TZZO->(DbCloseArea())
		EndIf 		
	EndDo
	If !lRet
		MsgStop("Ocorreu inconsistência na gravação dos Dados!")
	else
		MsgAlert("Gravação do lance Finalizada Com Sucesso! Boa Sorte")
		cAparelho:= Space(3)
		cNome	:= Space(100) 
		cDepto 	:= Space(35)
		nVlrLance:= 0
		dData	:= Date()
		cHora	:= Time()

		oAparelho:Refresh()
		oNome:ReFresh()
		oDepto:Refresh()
		oVlrLance:Refresh()
		oData:Refresh()
		oHora:Refresh()		
	EndIf
else
	MsgStop("Favor Preencher Todos os Campos, para gração do lance!")
	lRet := .F.
Endif

Return lRet


User Function LanceJob(cAparelho,cNome,cDepto,nVlrLance,dData,cHora)

RPCSetType(3)
RPcSetEnv ( "01", "01" )


DbSelectArea("ZZO")
ZZO->( dbSetOrder(1) )
cCodZZO := GetSxENum("ZZO","ZZO_CODIGO")  

While ZZO->(DbSeek(xFilial("ZZO") + cCodZZO))
	ConfirmSx8()
	cCodZZO := GetSx8Num("ZZO", "ZZO_CODIGO")
End

If	Reclock("ZZO",.T.)    
	ZZO->ZZO_FILIAL := xFilial()
	ZZO->ZZO_CODIGO := cCodZZO
	ZZO->ZZO_APAREL	:= StrZero(Val(cAparelho),3)
	ZZO->ZZO_NOME   := cNome	
	ZZO->ZZO_DEPTO  := left(cDepto,3)
	ZZO->ZZO_NDEPTO := Substr(cDepto,5)
	ZZO->ZZO_VLANCE := nVlrLance
	ZZO->ZZO_DATA	:= dData
	ZZO->ZZO_HORA	:= cHora
	
	ZZO->( msUnlock() )		
EndIf	

                                                                                   
Return


Static Function VldCpoWhen(cTipo)
Local lRet := .F.

If cTipo == "1"
	If !Empty(Alltrim(cAparelho)) 
		lRet := .T.
	EndIf

ElseIf cTipo=="2"
	If !Empty(Alltrim(cNome))
		lRet := .T.
	EndIf
	
ElseIf cTipo== "3"
	If !Empty(Alltrim(cDepto))
		lRet := .T.
	EndIf
EndIf

Return lRet

Static Function ProcRun()
cHora    := Time() 
dData    := Date()
oHora:Refresh()
oData:Refresh()
Return
