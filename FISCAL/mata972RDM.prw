#INCLUDE "PROTHEUS.CH"               

USER Function MATA972RDM(lAutomato)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a Integridade dos dados de Entrada                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aSave:={Alias(),IndexOrd(),Recno()}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local	nOpc	:=	0
Local	oDlg
Local	cTitulo
Local	cText1
Local	cText2
Local	cText3
Local	aCAP		:= {"Confirma","Abandona","Parƒmetros"} //"Confirma"###"Abandona"###"Parƒmetros"
Local	cTipoNf		:= ""
Local	aD1Imp		:= {}
Local	aD2Imp		:= {}
Local	nScanPis	:= 0
Local	nPosPis		:= 0
Local	nScanCof	:= 0
Local	nPosCof		:= 0
Local	cCampoCof	:= ""
Local	cCampoPis	:= ""

Default lAutomato := .F.

Private cPerg	:= "MTA972"
Private lEnd	:= .F.
Private cArqCabec
Private cArqCFO
Private cArqInt
Private cArqZFM
Private cArqOcor
Private cArqIE
Private cArqIeSt
Private cArqIeSd
Private cArqDIPAM
Private cCredAcum
Private cArqExpt
Private cIndSF3  := ""
Private nTipoReg := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Janela Principal                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTitulo	:=	"Arquivo Magn‚tico" //"Arquivo Magn‚tico"
cText1	:=	"Este programa gera arquivo pr‚-formatado dos lan‡amentos fiscais" //"Este programa gera arquivo pr‚-formatado dos lan‡amentos fiscais"
cText2	:=	"para entrega as Secretarias de Fazenda Estaduais da Guia de  " //"para entrega as Secretarias de Fazenda Estaduais da Guia de  "
cText3	:=	"Informacao e Apuracao do ICMS (GIA )." //"Informacao e Apuracao do ICMS (GIA )."

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lAutomato
	Pergunte("MTA972",.T.)
EndIf

While .T.
	nOpc	:=	0
	DEFINE MSDIALOG oDlg TITLE OemtoAnsi(cTitulo) FROM  165,115 TO 315,525 PIXEL OF oMainWnd
	@ 03, 10 TO 43, 195 LABEL "" OF oDlg  PIXEL
	@ 10, 15 SAY OemToAnsi(cText1) SIZE 180, 8 OF oDlg PIXEL
	@ 20, 15 SAY OemToAnsi(cText2) SIZE 180, 8 OF oDlg PIXEL
	@ 30, 15 SAY OemToAnsi(cText3) SIZE 180, 8 OF oDlg PIXEL
	DEFINE SBUTTON FROM 50, 112 TYPE 5 ACTION (nOpc:=3,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 50, 141 TYPE 1 ACTION (nOpc:=1,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 50, 170 TYPE 2 ACTION (nOpc:=2,oDlg:End()) ENABLE OF oDlg

	If !lAutomato
		ACTIVATE MSDIALOG oDlg
		Pergunte(cPerg,.f.)
		Do Case
			Case nOpc==1
				Processa({||U_Xa972Processa()},,,@lEnd)
			Case nOpc==3
				Pergunte(cPerg,.t.)
				Loop
		EndCase
	Else
		Processa({||U_Xa972Processa(lAutomato)},,,@lEnd)
	EndIf

	Exit
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura area                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(aSave[1])
dbSetOrder(aSave[2])
dbGoto(aSave[3])

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao	 ³Xa972ProcessaºAutor  ³Andreia dos Santos  º Data ³  19/06/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faz o processamento de forma a montar os arquivos temporariosº±±
±±º          ³para gerar gerar o arquivo texto final.                     	º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA972                                                    	º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function Xa972Processa(lAutomato)
LOCAL aApuracao
Local cRef  := ""
Local lRet  := .F.
Local nX    := 0
Local lAglFil  := (mv_par22 == 1)   // A Variável é local para ser passada por parâmetro na função a972MontTrab, que é chamada por outras rotinas.
Local lGerCR26 := (mv_par23 == 1)
Local lGerCR27 := (mv_par24 == 1)
Local aAlias   := {}
Local cArqTrb  := ""

Default lAutomato := .F.
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Parametros															    ³
³mv_par01 - Data Inicial       ?     									³
³mv_par02 - Data Final         ?   										³
³mv_par03 - Tipo de GIA        ? (01-Normal/02-Substitutiva)			³
³mv_par04 - GIA com Movimento  ? (Sim/Nao)								³
³mv_par05 - GIA ja transmitida ? (Sim/Nao)								³
³mv_par06 - Saldo Credor - ST  ?    									³
³mv_par07 - Regime Tributario  ? (01-RPA/02-RES/03-RPA-DISPENSADO)     	³
³mv_par08 - Mes de Referencia  ?      									³
³mv_par09 - Ano de Referencia  ?      									³
³mv_par10 - Mes Ref. Inicial   ?      									³
³mv_par11 - Ano Ref. Inicial   ?      									³
³mv_par12 - Livro Selecionado  ?      									³
³mv_par13 - ICMS Fixado para o periodo?									³
³mv_par14 - Nome do arquivo    ?										³
³mv_par15 - Versão do Validador?										³
³mv_par16 - Versão do Layout   ?    									³
³mv_par17 - Drive Destino                                               ³
³mv_par18 - Filial De                                                   ³
³mv_par19 - Filial Ate                                                  ³
³mv_par20 - NF Transf. Filiais                                          ³
³mv_par21 - Seleciona Filiais?                                          ³
³mv_par22 - Aglutina por CNPJ?                                          ³
³mv_par23 - Gerar o registro CR=26 ?                                    ³
³mv_par24 - Gerar o registro CR=27 ?                                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
PRIVATE dDtIni		:= mv_par01
PRIVATE dDtFim		:= mv_par02
PRIVATE nTipoGia	:= mv_par03
PRIVATE nMoviment	:= mv_par04
PRIVATE nTransmit	:= mv_par05
PRIVATE nSaldoST	:= mv_par06
PRIVATE nRegime		:= mv_par07
PRIVATE nMes		:= mv_par08
PRIVATE nAno		:= mv_par09
PRIVATE nMesIni		:= mv_par10
PRIVATE nAnoIni		:= mv_par11
PRIVATE cNrLivro	:= mv_par12
PRIVATE nICMSFIX	:= mv_par13
Private cVValid   	:= mv_par15
Private cNomeArq	:= ALLTRIM(mv_par14)+".PRF"
Private cVLayOut  	:= mv_par16
Private nHandle
Private lSelFil   	:= ( mv_par21 == 1 )
Private cLib		:= ''
Private nRemType 	:= GetRemoteType(@cLib)
Private lHtml		:= 'HTML' $ cLib
Private cFunc		:= 'CPYS2TW'
Private cFilDe  	:= mv_par18
Private cFilAte 	:= mv_par19
Private nGeraTransp := mv_par20

If Empty(cFilDe) .And. Empty(cFilAte)
	cFilDe  := cFilAnt
	cFilAte := cFilAnt
EndIf

cRef := strzero(nAno,4)+strzero(nMes,2)
Do Case
		Case ( cRef >= "201703" .or. ( Month(dDtIni) == 3 .and. Year(dDtIni) == 2017 ) .or. ( Month(dDtFim) == 3 .and. Year(dDtFim) == 2017 ) ) .and. cPaisLoc == 'BRA'
			//BannerTAF()
			//Return .F.
	      	lRet := .T.
		Case nRegime == 2
			If cRef <= "200012"
				lRet := .T.
			EndIf
		Case nRegime == 4
			If cRef >= "200007"
				lRet := .T.
			EndIF
		Case cRef >= "200007" .and. cRef <= Substr(DTOS(date()),1,6)	
				lRet := .T.
		OtherWise
				MsgInfo('STR0019 ERRO DATA REFERENCIA')
EndCase

If lRet
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta arquivo de Trabalho                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	a972MontTrab(aApuracao,.F.,dDtIni,dDtFim,cNrLivro,nRegime,cFilDe,cFilAte,cVLayOut,lSelFil,lAglFil,lGerCR26,lGerCR27,aAlias)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava arquivo texto                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	a972GeraTxt(lAutomato)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Fecha arquivo texto                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nHandle >= 0
		FClose(nHandle)
	Endif

	/* Se for HTML disponibilizo o arquivo para download	 */
	If lHtml .and. FindFunction(cFunc)
		&(cFunc+'("'+cNomeArq+'")')
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apaga arquivos temporarios               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 To Len(aAlias)
		cArqTrb := aAlias[nX]
		If File(cArqTrb+GetDBExtension())
			dbSelectArea(cArqTrb)
			dbCloseArea()
			Ferase(cArqTrb+GetDBExtension())
			Ferase(cArqTrb+OrdBagExt())
		Endif
	Next

Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura indices                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("SF3")
Ferase(cIndSF3+OrdBagExt())

Return      



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³a972Dipam ºAutor  ³Andreia dos Santos  º Data ³  26/06/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava os registros referentes a DIPAM-B. CR=30              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA972                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function a972Dipam()

cRegistro	:=	"30"													//01.Codigo de Registro
cRegistro	+=	a972Fill((cArqDipam)->CODDIP,2)							//02.Codigo da DIPI
cRegistro   +=  a972Fill((cArqDipam)->MUNICIP,5)						//03.Codigo do Municipio
cRegistro	+=	a972Fill(Num2Chr((cArqDipam)->VALOR,15,2),15)			//04.Codigo do Municipio

a972Grava( cRegistro )

Return(.T.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³a972Expot ºAutor  ³Eduardo Jose Zanardoº Data ³  08/02/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava os registros referentes a exportacao CR=31            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA972                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function a972Expot()

cRegistro	:=	"31"												//01.Codigo de Registro
cRegistro	+=	a972Fill((cArqExpt)->RE,15)							//02.Registro de Importacao

a972Grava( cRegistro )

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³a972TmpIE º Autor ³Sergio S. Fuzinaka  º Data ³  26/05/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava os registros referentes a IE CR=25, somente movimenta-º±±
±±º          ³cao de transferencia ( F3->TRFICM > 0 )                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³MATA972                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function a972TmpIE(cAlias)

Local cIE := ""
Local aSA1 := {}
Local aSA2 := {}
local lDevBen	:= .F.
Local cTab		:= ''

If (cAlias)->F3_TRFICM > 0	//Houve transferencia de Credito ou Debito

	lDevBen := (cAlias)->F3_TIPO $ "DB"

	If Left((cAlias)->F3_CFO,1) >= "5"
		cTab := Iif(lDevBen,'A2','A1')
	Else
		cTab := Iif(lDevBen,'A1','A2')
	EndIF

	If cTab == 'A1'
		aSA1 := SA1->(GetArea())
		SA1->(dbSetOrder(1))
		SA1->(msSeek(xFilial("SA1")+(cAlias)->F3_CLIEFOR+(cAlias)->F3_LOJA,.F.))
		cIE := Alltrim(SA1->A1_INSCR)
		RestArea(aSA1)
	Else
		aSA2 := SA2->(GetArea())
		SA2->(dbSetOrder(1))
		SA2->(msSeek(xFilial("SA2")+(cAlias)->F3_CLIEFOR+(cAlias)->F3_LOJA,.F.))
		cIE := Alltrim(SA2->A2_INSCR)
		RestArea(aSA2)
	EndIF
	If (cArqIE)->(msseek(PADR((cAlias)->F3_CFO,5,' ')+cIE))
		RecLock((cArqIE),.F.)
		(cArqIE)->IE 		:= cIE
		(cArqIE)->VALOR += (cAlias)->F3_TRFICM
	Else
		RecLock((cArqIE),.T.)
		(cArqIE)->SUBITEM	:= (cAlias)->F3_CFO
		(cArqIE)->IE 		:= cIE
		(cArqIE)->VALOR		:= (cAlias)->F3_TRFICM
	Endif
	MsUnlock()
Endif

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³a972TmIeST º Autor ³Diego Dias          º Data ³  28/07/16  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava os registros referentes a IE Substituto CR=26         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³MATA972                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function a972TmIeST(cAlias)

Local cIE := ""
Local aSA1 := {}
Local aSA2 := {}
local lDevBen	:= .F.

lDevBen := (cAlias)->F3_TIPO $ "DB"

If	lDevBen
	aSA2 := SA2->(GetArea())
	SA2->(dbSetOrder(1))
	SA2->(msSeek(xFilial("SA2")+(cAlias)->F3_CLIEFOR+(cAlias)->F3_LOJA,.F.))
	cIE := Alltrim(SA2->A2_INSCR)
	RestArea(aSA2)
Else
	aSA1 := SA1->(GetArea())
	SA1->(dbSetOrder(1))
	SA1->(msSeek(xFilial("SA1")+(cAlias)->F3_CLIEFOR+(cAlias)->F3_LOJA,.F.))
	cIE := Alltrim(SA1->A1_INSCR)
	RestArea(aSA1)
EndIF

RecLock((cArqIeST),.T.)
(cArqIeST)->SUBITEM	:= (cAlias)->F3_CFO
(cArqIeST)->IE 		:=	cIE
(cArqIeST)->NF 		:=	Strzero(Val((cAlias)->F3_NFISCAL),09)
(cArqIeST)->Dataini	:=	AnoMes(dDtIni)
(cArqIeST)->DataFim	:=	AnoMes(dDtFim)
(cArqIeST)->VALOR 	:= (cAlias)->F3_VALCONT

MsUnlock()
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³a972TmIeSD º Autor ³Diego Dias          º Data ³  28/07/16  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava os registros referentes a IE Substituído CR=27        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³MATA972                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function a972TmIeSD(cAlias)

Local cIE := ""
Local aSA1 := {}
Local aSA2 := {}
local lDevBen	:= .F.

lDevBen := (cAlias)->F3_TIPO $ "DB"

If	lDevBen
	aSA1 := SA1->(GetArea())
	SA1->(dbSetOrder(1))
	SA1->(msSeek(xFilial("SA1")+(cAlias)->F3_CLIEFOR+(cAlias)->F3_LOJA,.F.))
	cIE := Alltrim(SA1->A1_INSCR)
	RestArea(aSA1)
Else
	aSA2 := SA2->(GetArea())
	SA2->(dbSetOrder(1))
	SA2->(msSeek(xFilial("SA2")+(cAlias)->F3_CLIEFOR+(cAlias)->F3_LOJA,.F.))
	cIE := Alltrim(SA2->A2_INSCR)
	RestArea(aSA2)
EndIF

RecLock((cArqIeSD),.T.)
(cArqIeSD)->SUBITEM	:= (cAlias)->F3_CFO
(cArqIeSD)->IE 		:=	cIE
(cArqIeSD)->NF 		:=	Strzero(Val((cAlias)->F3_NFISCAL),09)
(cArqIeSD)->VALOR 	:= (cAlias)->F3_VALCONT

MsUnlock()

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunction³A972RetMun  ºAutor  ³Gustavo G. Rueda    º Data ³  28/09/2004 º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.   ³Verifica se existe integracao com o TMS, e caso exista retornaº±±
±±º        ³ o codigo do municipio da tabela DUE ou DUL. Caso contrario   º±±
±±º        ³ retorno do cadastro de cliente posicionado anteriormente.    º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParamet.³ExpC -> Indica o alias da tabela SF3 a ser utilizada.         º±±
±±º        ³ExpL -> Integracao com o TMS.                                 º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso     ³ MATA972                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A972RetMun (cAliasSf3, lTms, cMvUF, cMVCODDP, cMVCODMUN, lA1CODMUN, cCodMunX )
Local		cCod_Mun 	 :=	""
Local		aArea		 :=	GetArea ()
Local		aCodMun	 := {}

If lTms
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Integracao com TMS                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCodMun := TMSInfSol((cAliasSf3)->F3_FILIAL,(cAliasSf3)->F3_NFISCAL,(cAliasSf3)->F3_SERIE,(cAliasSf3)->F3_CLIEFOR,(cAliasSf3)->F3_LOJA,.T.)
	If Substr((cAliasSF3)->F3_CFO,1,1) >= "5"
		If Len(aCodMun) > 0
			//-- SIGATMS: para remetente SP e CFOP interestadual.
			If aCodMun[8] == cMvUF
				cCod_Mun := aCodMun[11]
			Else
				cCod_Mun := StrZero(val(CMVCODDP),5,0)
			EndIf
		EndIf
	EndIf
EndIf
//Alterado para quando não houver integração com TMS, traga o código de municipio, para não apresentar erro na validação.
If Empty(cCod_Mun)
	SA1->(msseek(xFilial("SA1")+(cAliasSf3)->F3_CLIEFOR+(cAliasSf3)->F3_LOJA,.F.))
	If (cCodMunX<>"X") .And. !(SA1->(Eof ())) //GetNewPar ("MV_CODMUN", "X")
		If (SA1->(FieldPos(AllTrim(cMVCODMUN)))>0)
			cCod_Mun	:=	SA1->(FieldGet (FieldPos(cMVCODMUN)))
		Else
			cCod_Mun	:=	""
		EndIf
	Else
		cCod_Mun	:=	""
	EndIf
	//
	If lA1CODMUN .And. (Empty (cCod_Mun)) .And. !(SA1->(Eof ()))
		cCod_Mun	:=	SA1->A1_COD_MUN
	EndIf
EndIf
RestArea (aArea)
Return (cCod_Mun)

