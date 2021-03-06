#INCLUDE "PROTHEUS.CH"               

USER Function MATA972RDM(lAutomato)
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Salva a Integridade dos dados de Entrada                     ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Local aSave:={Alias(),IndexOrd(),Recno()}

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Define variaveis                                             ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Local	nOpc	:=	0
Local	oDlg
Local	cTitulo
Local	cText1
Local	cText2
Local	cText3
Local	aCAP		:= {"Confirma","Abandona","Par긩etros"} //"Confirma"###"Abandona"###"Par긩etros"
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

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Janela Principal                                             ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cTitulo	:=	"Arquivo Magn굏ico" //"Arquivo Magn굏ico"
cText1	:=	"Este programa gera arquivo pr?-formatado dos lan놹mentos fiscais" //"Este programa gera arquivo pr?-formatado dos lan놹mentos fiscais"
cText2	:=	"para entrega as Secretarias de Fazenda Estaduais da Guia de  " //"para entrega as Secretarias de Fazenda Estaduais da Guia de  "
cText3	:=	"Informacao e Apuracao do ICMS (GIA )." //"Informacao e Apuracao do ICMS (GIA )."

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Verifica as perguntas selecionadas                           ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Restaura area                                                ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
dbSelectArea(aSave[1])
dbSetOrder(aSave[2])
dbGoto(aSave[3])

Return

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇?袴袴袴袴袴佶袴袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튔uncao	 쿦a972Processa튍utor  쿌ndreia dos Santos  ? Data ?  19/06/00   볍?
굇勁袴袴袴袴曲袴袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
굇튒esc.     ? Faz o processamento de forma a montar os arquivos temporarios볍?
굇?          쿾ara gerar gerar o arquivo texto final.                     	볍?
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
굇튧so       ? MATA972                                                    	볍?
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
*/
USER Function Xa972Processa(lAutomato)
LOCAL aApuracao
Local cRef  := ""
Local lRet  := .F.
Local nX    := 0
Local lAglFil  := (mv_par22 == 1)   // A Vari?vel ? local para ser passada por par?metro na fun豫o a972MontTrab, que ? chamada por outras rotinas.
Local lGerCR26 := (mv_par23 == 1)
Local lGerCR27 := (mv_par24 == 1)
Local aAlias   := {}
Local cArqTrb  := ""

Default lAutomato := .F.
/*
旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
쿛arametros															    ?
쿺v_par01 - Data Inicial       ?     									?
쿺v_par02 - Data Final         ?   										?
쿺v_par03 - Tipo de GIA        ? (01-Normal/02-Substitutiva)			?
쿺v_par04 - GIA com Movimento  ? (Sim/Nao)								?
쿺v_par05 - GIA ja transmitida ? (Sim/Nao)								?
쿺v_par06 - Saldo Credor - ST  ?    									?
쿺v_par07 - Regime Tributario  ? (01-RPA/02-RES/03-RPA-DISPENSADO)     	?
쿺v_par08 - Mes de Referencia  ?      									?
쿺v_par09 - Ano de Referencia  ?      									?
쿺v_par10 - Mes Ref. Inicial   ?      									?
쿺v_par11 - Ano Ref. Inicial   ?      									?
쿺v_par12 - Livro Selecionado  ?      									?
쿺v_par13 - ICMS Fixado para o periodo?									?
쿺v_par14 - Nome do arquivo    ?										?
쿺v_par15 - Vers?o do Validador?										?
쿺v_par16 - Vers?o do Layout   ?    									?
쿺v_par17 - Drive Destino                                               ?
쿺v_par18 - Filial De                                                   ?
쿺v_par19 - Filial Ate                                                  ?
쿺v_par20 - NF Transf. Filiais                                          ?
쿺v_par21 - Seleciona Filiais?                                          ?
쿺v_par22 - Aglutina por CNPJ?                                          ?
쿺v_par23 - Gerar o registro CR=26 ?                                    ?
쿺v_par24 - Gerar o registro CR=27 ?                                    ?
읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
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
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//? Monta arquivo de Trabalho                                    ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	a972MontTrab(aApuracao,.F.,dDtIni,dDtFim,cNrLivro,nRegime,cFilDe,cFilAte,cVLayOut,lSelFil,lAglFil,lGerCR26,lGerCR27,aAlias)
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//? Grava arquivo texto                                          ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	a972GeraTxt(lAutomato)
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//? Fecha arquivo texto                                          ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If nHandle >= 0
		FClose(nHandle)
	Endif

	/* Se for HTML disponibilizo o arquivo para download	 */
	If lHtml .and. FindFunction(cFunc)
		&(cFunc+'("'+cNomeArq+'")')
	EndIf

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//? Apaga arquivos temporarios               ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Restaura indices                                             ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
RetIndex("SF3")
Ferase(cIndSF3+OrdBagExt())

Return      



/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튔uncao    쿪972Dipam 튍utor  쿌ndreia dos Santos  ? Data ?  26/06/00   볍?
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
굇튒esc.     쿒rava os registros referentes a DIPAM-B. CR=30              볍?
굇?          ?                                                            볍?
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
굇튧so       ? MATA972                                                    볍?
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
*/
Static Function a972Dipam()

cRegistro	:=	"30"													//01.Codigo de Registro
cRegistro	+=	a972Fill((cArqDipam)->CODDIP,2)							//02.Codigo da DIPI
cRegistro   +=  a972Fill((cArqDipam)->MUNICIP,5)						//03.Codigo do Municipio
cRegistro	+=	a972Fill(Num2Chr((cArqDipam)->VALOR,15,2),15)			//04.Codigo do Municipio

a972Grava( cRegistro )

Return(.T.)
/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튔uncao    쿪972Expot 튍utor  쿐duardo Jose Zanardo? Data ?  08/02/02   볍?
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
굇튒esc.     쿒rava os registros referentes a exportacao CR=31            볍?
굇?          ?                                                            볍?
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
굇튧so       ? MATA972                                                    볍?
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
*/
Static Function a972Expot()

cRegistro	:=	"31"												//01.Codigo de Registro
cRegistro	+=	a972Fill((cArqExpt)->RE,15)							//02.Registro de Importacao

a972Grava( cRegistro )

Return(.T.)

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튔uncao    쿪972TmpIE ? Autor 쿞ergio S. Fuzinaka  ? Data ?  26/05/03   볍?
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
굇튒esc.     쿒rava os registros referentes a IE CR=25, somente movimenta-볍?
굇?          쿬ao de transferencia ( F3->TRFICM > 0 )                     볍?
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
굇튧so       쿘ATA972                                                     볍?
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튔uncao    쿪972TmIeST ? Autor 쿏iego Dias          ? Data ?  28/07/16  볍?
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
굇튒esc.     쿒rava os registros referentes a IE Substituto CR=26         볍?
굇?          ?                                                            볍?
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
굇튧so       쿘ATA972                                                     볍?
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튔uncao    쿪972TmIeSD ? Autor 쿏iego Dias          ? Data ?  28/07/16  볍?
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
굇튒esc.     쿒rava os registros referentes a IE Substitu?do CR=27        볍?
굇?          ?                                                            볍?
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
굇튧so       쿘ATA972                                                     볍?
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇?袴袴袴袴佶袴袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튔unction쿌972RetMun  튍utor  쿒ustavo G. Rueda    ? Data ?  28/09/2004 볍?
굇勁袴袴袴曲袴袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
굇튒esc.   쿣erifica se existe integracao com o TMS, e caso exista retorna볍?
굇?        ? o codigo do municipio da tabela DUE ou DUL. Caso contrario   볍?
굇?        ? retorno do cadastro de cliente posicionado anteriormente.    볍?
굇勁袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
굇튡aramet.쿐xpC -> Indica o alias da tabela SF3 a ser utilizada.         볍?
굇?        쿐xpL -> Integracao com o TMS.                                 볍?
굇勁袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
굇튧so     ? MATA972                                                      볍?
굇훤袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
*/
Static Function A972RetMun (cAliasSf3, lTms, cMvUF, cMVCODDP, cMVCODMUN, lA1CODMUN, cCodMunX )
Local		cCod_Mun 	 :=	""
Local		aArea		 :=	GetArea ()
Local		aCodMun	 := {}

If lTms
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//? Integracao com TMS                                 ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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
//Alterado para quando n?o houver integra豫o com TMS, traga o c?digo de municipio, para n?o apresentar erro na valida豫o.
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

