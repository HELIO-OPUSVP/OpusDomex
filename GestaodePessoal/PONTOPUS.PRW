//#INCLUDE 'PARMTYPE.CH'
#include "rwmake.ch"
//#INCLUDE 'FWBROWSE.CH'
#include "protheus.ch"
//#INCLUDE 'FWMVCDEF.CH'
#include "TbiCode.ch"
#include "TOpconn.ch"

User Function PONTOPUS(cMatricula)

Local nLinha   := 0
Local nColuna  := 0
Local nLargura := 350  // GetScreenRes()[1]    //299
Local nAltura  := 412  // GetScreenRes()[2]-20 //412
Local nLCampos := 0
Local nCCampos := 0

Local nLargBut := 130
Local nAltuBut := 20


Local cNomeConsult := ""
Local cQuery 	  := ""

Private _cFilial   := '0101'
Private cHora    := Subs(StrTran(Time(),':',''),1,4)
Private dData    := Date()
Private cEntrad1 := '  :  '
Private cSaida1  := '  :  '
Private cEntrad2 := '  :  '
Private cSaida2  := '  :  '
Private cNome := Space(50)
Private cODBC     := "TOTVSPRO"
Private cServidor := "localhost"
Private nTcConn 	:= 0
Private nPorta	   := 7898
Private nUmMinuto := 60000
Private cCpf	  := Space(11)

Default cMatricula := SPACE(6) // "" // "010625" Leandra

If Date() > StoD('20200501')
	Return
EndIf

//apMsgStop(GetCredential())



//If Empty(cMatricula)
//	apMsgStop("Matricula não informada")
//	Return
//EndIf

TCCONTYPE("TCPIP")

nTcConn := TCLINK( "@!!@MSSQL/"+cODBC,  cServidor, nPorta)

If (nTcConn < 0 )
	Alert ("Erro de conexao!")
	Return
EndIf

TCSETCONN(nTcConn)

// TCUnLink()



DEFINE MSDIALOG oMainWnd TITLE "Marcação de Ponto Rosemberger" FROM nLinha,nColuna TO nLinha+nAltura,nColuna+nLargura  PIXEL

nLin := 50
nCol := 10
@ nLin  , nCol	SAY   oTxt1      Var 'Cpf:'  SIZE 30,10 PIXEL
@ nLin-3, 040  MSGET oCpf VAR cCpf    Picture "@E" WHEN .T.        		SIZE 100,29 PIXEL

DEFINE TIMER oTimer INTERVAL (nUmMinuto*1) ACTION (ProcRun())  OF oMainWnd // 60000 = 60 segundos

ACTIVATE TIMER oTimer

//cMatricula := "000000"+cMatricula
//cMatricula := Right(cMatricula,6)


cQuery := "SELECT RA_NOME FROM SRA010 WHERE RA_CPF = '"+Alltrim(cCpf)+"' AND D_E_L_E_T_ = '' AND RA_SITFOLH <> 'D' "

If Select("QSRA") <> 0
	QSRA->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QSRA"

If QSRA->( EOF() )
	apMsgStop("Cpf " + cCpf + " inválido.")
	Return
Else
	cNome := QSRA->RA_NOME
	cMatricula := QSRA->RA_MAT
EndIf

// 1E
cQuery := "SELECT P8_HORA FROM SP8010 WHERE P8_FILIAL = '"+_cFilial+"' AND P8_MAT = '"+cMatricula+"' AND P8_DATA = '"+DtoS(dData)+"' AND P8_TPMARCA = '1E' AND D_E_L_E_T_ = '' "

If Select("QSP8") <> 0
	QSP8->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QSP8"

If !QSP8->( EOF() )
	cEntrad1 := QSP8->P8_HORA
EndIf

// 2S
cQuery := "SELECT P8_HORA FROM SP8010 WHERE P8_FILIAL = '"+_cFilial+"' AND P8_MAT = '"+cMatricula+"' AND P8_DATA = '"+DtoS(dData)+"' AND P8_TPMARCA = '2S' AND D_E_L_E_T_ = '' "

If Select("QSP8") <> 0
	QSP8->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QSP8"

If !QSP8->( EOF() )
	cSaida1 := QSP8->P8_HORA
EndIf

// 1S
cQuery := "SELECT P8_HORA FROM SP8010 WHERE P8_FILIAL = '"+_cFilial+"' AND P8_MAT = '"+cMatricula+"' AND P8_DATA = '"+DtoS(dData)+"' AND P8_TPMARCA = '1S' AND D_E_L_E_T_ = '' "

If Select("QSP8") <> 0
	QSP8->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QSP8"

If !QSP8->( EOF() )
	cEntrad2 := QSP8->P8_HORA
EndIf

// 2E
cQuery := "SELECT P8_HORA FROM SP8010 WHERE P8_FILIAL = '"+_cFilial+"' AND P8_MAT = '"+cMatricula+"' AND P8_DATA = '"+DtoS(dData)+"' AND P8_TPMARCA = '2E' AND D_E_L_E_T_ = '' "

If Select("QSP8") <> 0
	QSP8->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QSP8"

If !QSP8->( EOF() )
	cSaida2 := QSP8->P8_HORA
EndIf


DEFINE MSDIALOG oMainWnd TITLE "Marcação de Ponto Rosemberger" FROM nLinha,nColuna TO nLinha+nAltura,nColuna+nLargura  PIXEL

nLin := 10
nCol := 10
@ nLin  , nCol	SAY   oTxt1      Var 'Cpf:'  SIZE 30,10 PIXEL
@ nLin-3, 040  MSGET oCpf VAR cCpf    Picture "@E" WHEN .T.        		SIZE 100,09 PIXEL

nLin += 20

@ nLin  , nCol	SAY   oTxt1      Var 'Matrícula:'  SIZE 30,10 PIXEL
@ nLin-3, 040  MSGET oMatricula VAR cMatricula    Picture "@!" WHEN .F.        SIZE 50,09 PIXEL

nLin += 20

@ nLin  , nCol	SAY   oTxt2      Var 'Nome:'       SIZE 30,10 PIXEL
@ nLin-3, 040  MSGET oNome      VAR cNome         Picture "@!" WHEN .F.        SIZE 100,09 PIXEL

nLin += 20

@ nLin  , nCol	SAY   oTxt3      Var 'Data:'       SIZE 30,10 PIXEL
@ nLin-3, 040  MSGET oData      VAR dData         Picture "@D" WHEN .F.        SIZE 50,09 PIXEL

nLin += 20
@ nLin  , nCol SAY   oTxt4      Var 'Hora:'       SIZE 30,10 PIXEL
@ nLin-3, 040  MSGET oHoraIni   VAR cHora         Picture "@R 99:99"  When .F. SIZE 40,09 PIXEL

oTxt1:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
oTxt2:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
oTxt3:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
oTxt4:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)

DEFINE TIMER oTimer INTERVAL (nUmMinuto*1) ACTION (ProcRun())  OF oMainWnd // 60000 = 60 segundos

ACTIVATE TIMER oTimer

//oTimer:= TTimer():New((nTimeOut-nTimeMsg),{|| MsgTimer(nTimeMsg,oDlg1) },oDlg1) // Ativa timer

//oTimer:Activate()

nCol01    := 10
nCol02    := 40
nSkipBut  := 25

nLin += 20

@ nLin, nCol01 MSGET oEntrad1   VAR cEntrad1    Picture "@R 99:99" WHEN .F. SIZE 05,nAltuBut-3 PIXEL
@ nLin, nCol02 BUTTON "ENTRADA" ACTION Processa( {|| Botao("1E",cMatricula) } ) SIZE nLargBut,nAltuBut PIXEL //OF oScroll

nLin += nSkipBut

@ nLin, nCol01 MSGET oSaida2   VAR cSaida2    Picture "@R 99:99" WHEN .F. SIZE 05,nAltuBut-3 PIXEL
@ nLin, nCol02 BUTTON "SAÍDA"  ACTION Processa( {|| Botao("2S",cMatricula) } ) SIZE nLargBut,nAltuBut PIXEL //OF oScroll

nLin += nSkipBut

@ nLin, nCol01 MSGET oSaida1   VAR cSaida1    Picture "@R 99:99" WHEN .F. SIZE 05,nAltuBut-3 PIXEL
oSaida1:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
@ nLin, nCol02 BUTTON "SAÍDA para almoço"  ACTION Processa( {|| Botao("1S",cMatricula) } ) SIZE nLargBut,nAltuBut PIXEL //OF oScroll

nLin += nSkipBut

@ nLin, nCol01 MSGET oEntrad2   VAR cEntrad2    Picture "@R 99:99" WHEN .F. SIZE 05,nAltuBut-3 PIXEL
oEntrad2:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)

@ nLin, nCol02 BUTTON "RETORNO do almoço"  ACTION Processa( {|| Botao("2E",cMatricula) } ) SIZE nLargBut,nAltuBut PIXEL //OF oScroll

ACTIVATE MSDIALOG oMainWnd   //ON INIT EnchoiceBar( oMainWnd,{|| oMainWnd:End()},{|| oMainWnd:End()} )

Return

Static Function Botao(cTPMARCA,cMatricula)
Local cTmpCli := ""
Local nIncMin := 10

If cTPMARCA == "1E"
	cEntrad1 := cHora
EndIf

If cTPMARCA == "2S"
	cSaida1  := cHora
EndIf

If cTPMARCA == "1S"
	cEntrad2 := cHora
EndIf

If cTPMARCA == "2E"
	cSaida2  := cHora
EndIf

//Startjob("U_PontJob",getenvserver(),.F.,cTPMARCA, cMatricula, dData, cHora )
U_PontJob(cTPMARCA, cMatricula, dData, cHora )

Return


User Function PontJob(cTPMARCA,cMatricula, dData, cHora)
Local cQuery := ""
Local cPaponta := ""

//RPCSetType(3)
//RPcSetEnv ( "01", _cFilial )

//Private cPaponta 	:= "" //Substr(GETMV("MV_PONMES"),1,8) + Substr(GETMV("MV_PONMES"),10,8)
//Private cIniFimP 	:= GetMv("MV_PAPONTA")
Private cOrdemApt := ""
//Private dPerIni   := STOD(Substr(GETMV("MV_PONMES"),01,8))
//Private dPerFim	:= STOD(Substr(GETMV("MV_PONMES"),10,8))
Private aRecsMarcAutDele	:= {}
Private aOrdemM30 := {"16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15"}
Private aOrdemM31 := {"16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15"}

cQuery := "SELECT RA_SITFOLH FROM SRA010 WHERE RA_FILIAL = '"+_cFilial+"' AND RA_MAT = '"+cMatricula+"' AND D_E_L_E_T_ = '' "

If Select("QSRA") <> 0
	QSRA->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QSRA"

If QSRA->( EOF() )
	Return
EndIf

If QSRA->RA_SITFOLH == 'D'
	Return
EndIf

QSRA->( dbCloseArea() )

If Day(dData) >= 16
	nMesIni := Month(dData)
	nAnoIni := Year(dData)
	dDtFim  := LastDay(dData)+1
	nMesFim := Month(dDtFim)
	nAnoFim := Year(dDtFim)
	dDataRef := dData
Else
	dDtAnt  := FirstDay(dData)-1
	nMesIni := Month(dDtAnt)
	nAnoIni := Year(dDtAnt)
	nMesFim := Month(dData)
	nAnoFim := Year(dData)
	dDataRef := FirstDay(dData)-1
EndIf

cPaponta := StrZero(nAnoIni,4) + StrZero(nMesIni,2) + '16' + StrZero(nAnoFim,4) + StrZero(nMesFim,2) + '15'


//If  Substr(DTOC(LastDay(dPerIni)),1,2)  == "31"
If Day(LastDay(dDataRef)) == 31
	cOrdemApt := Strzero(ASCAN(aOrdemM31, Substr(DTOC(dData),1,2) ),2)
Else
	cOrdemApt := Strzero(ASCAN(aOrdemM30, Substr(DTOC(dData),1,2) ),2)
Endif

//DbSelectArea("SP8")
//SP8->( dbSetOrder(1) )         //P8_FILIAL, P8_MAT, P8_ORDEM, P8_DATA, P8_HORA, R_E_C_N_O_, D_E_L_E_T_

cQuery := "SELECT R_E_C_N_O_ FROM SP8010 WHERE P8_FILIAL = '"+_cFilial+"' AND P8_MAT = '"+cMatricula+"' AND P8_ORDEM = '"+cOrdemApt+"' AND P8_DATA = '"+DtoS(dData)+"' AND D_E_L_E_T_ = '' "  // P8_TPMARCA

If Select("QSP8") <> 0
	QSP8->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QSP8"

//If SP8->( dbSeek( xFilial("SP8") + Alltrim(cMatricula) + cOrdemApt +  DtoS(dData)  + cHora ))
If !QSP8->( EOF() )
	//Reclock("SP8",.F.)
	MsgInfo("Marcação já realizada anteriormente. Não é permitido realizar alteração de marcações por esta rotina.")
Else
	
	cQuery := "INSERT INTO SP8010 "
	cQuery += "("
	cQuery += "P8_FILIAL,
	cQuery += "P8_MAT,
	cQuery += "P8_DATA,
	cQuery += "P8_CC,
	cQuery += "P8_ORDEM,
	cQuery += "P8_FLAG,
	cQuery += "P8_TURNO
	cQuery += "P8_HORA
	cQuery += "P8_TPMARCA
	cQuery += "P8_PAPONTA
	cQuery += "P8_DATAAPO
	cQuery += "P8_TIPOREG
	cQuery += "P8_MOTIVRG
	cQuery += "R_E_C_N_O_
	cQuery += ") "
	
	cQuery += "VALUES "
	
	cQuery := "SELECT RA_MAT, RA_CC, RA_TNOTRAB FROM SRA010 WHERE RA_MAT = '"+cMatricula+"' AND D_E_L_E_T_ = '' "
	
	If Select("QSRA") <> 0
		QSRA->( dbCloseArea() )
	EndIf
	
	TCQUERY cQuery NEW ALIAS "QSRA"
	
	cQuery += "("
	cQuery += "'" + _cFilial          + "',"
	cQuery += "'" + QSRA->RA_MAT      + "',"
	cQuery += "'" + DtoS(dData)       + "',"
	cQuery += "'" + QSRA->RA_CC       + "'," // "P8_CC,
	cQuery += "'" + cOrdemApt         + "'," // "P8_ORDEM,
	cQuery += "'" + "M"               + "'," // "P8_FLAG,
	cQuery += "'" + QSRA->RA_TNOTRAB  + "'," // "P8_TURNO
	cQuery += "'" + Substr(cHora,1,2) + "." + Substr(cHora,3,2) + "'," // "P8_HORA
	cQuery += "'" + cTPMARCA          + "'," // "P8_TPMARCA
	cQuery += "'" + cPaponta          + "'," // "P8_PAPONTA
	cQuery += "'" + DtoS(dData)       + "'," // "P8_DATAAPO
	cQuery += "'I',"                         // "P8_TIPOREG
	cQuery += "'INCLUSAO MANUAL',"           // "P8_MOTIVRG
	cQuery += "(SELECT MAX(R_E_C_N_O_)+1 AS R_E_C_N_O_ FROM SP8010) "
	cQuery += ") "
	
	QSRA->( dbCloseArea() )
	
	TCSQLEXEC(cQuery)
	
	/*
	Reclock("SP8",.T.)
	SP8->P8_FILIAL  := SRA->RA_FILIAL
	SP8->P8_MAT	    := SRA->RA_MAT
	SP8->P8_DATA    := dData
	SP8->P8_CC      := SRA->RA_CC
	SP8->P8_ORDEM   := cOrdemApt
	SP8->P8_FLAG    := "M"
	SP8->P8_TURNO   := SRA->RA_TNOTRAB
	SP8->P8_HORA	 := Val(Substr(cHora,1,2) + "." + Substr(cHora,3,2))
	SP8->P8_TPMARCA := cTPMARCA
	SP8->P8_PAPONTA := cPaponta
	SP8->P8_DATAAPO := DDATABASE
	SP8->P8_TIPOREG := "I"
	SP8->P8_MOTIVRG := "INCLUSAO MANUAL"
	*/
	
	//SP8->P8_DATAALT := DDATABASE
	//SP8->P8_HORAALT := TIME()
	//SP8->P8_USUARIO := RetCodUsr()
EndIf

//SP8->( msUnlock() )

Return

Static Function ProcRun()

cHora    := Subs(StrTran(Time(),':',''),1,4)
dData    := Date()
oHoraIni:Refresh()
oData:Refresh()

Return
