#include "rwmake.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RESTC01B ºAutor  ³Michel A. Sander    º Data ³  08.05.2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela de consulta de documentos por produto/OP			     º±±
±±º          ³ 				                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RESTC01B(cProduto)

//Private cSlvAnexos := "\system\docs"
	Private cSlvAnexos := "\docs"
	PRIVATE oFontNW
	Private oGetDados
	Private aHeader    := {}
	Private aCols      := {}
	Private oGetEmp
	Private aHeader2   := {}
	Private aCols2     := {}
	Private cCodigoPn  := Space(16)
	Private cDescDet1  := Space(100)
	Private cDescDet2  := Space(100)
	Private cDescDet3  := Space(100)
	Private cDescDet4  := Space(100)
	Private cDescDet5  := Space(100)
	Private cDescProd  := Space(60)
	Private cDesCLien  := Space(09)
	Private cCodClien  := Space(06)
	Private cNomClien  := Space(60)
	Private cQuant     := Space(30)
	Private cSaldo     := Space(30)
	Private oTexto2
	Private oTexto3
	Private oTexto4
	Private oTexto5
	Private oTexto6
	Private oTextoC
	Private oDet1
	Private oDet2
	Private oDet3
	Private oDet4
	Private nLado:= 0
	Private cCodHuawei:= ""
	Private cRamo:= ""
	Private oTextoF

	Default cProduto   := Space(16)


	if !empty(alltrim(cProduto))
		nLado:= 1
	Else
		nLado:=fside()
	Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Dados do produto³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aHeader,  {    "Arquivo"    ,   "ITEM"    ,"@R" ,50,0,""            ,"","C","","","","",".F."})//01
	AADD(aHeader,  {    "Descrição"  ,   "DESCRI"  ,"@R" ,50,0,""            ,"","C","","","","",".T."})//02
	AADD(aCols,{"","",.F.})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Dados do empenho³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aHeader2,  {    "Num. OP  "  ,   "NUMOP"   ,"@R" ,11,0,""            ,"","C","","","","",".F."})//01
	AADD(aHeader2,  {    "Produto  "  ,   "PRODUTO" ,"@R" ,15,0,""            ,"","C","","","","",".T."})//02
	AADD(aHeader2,  {    "Descrição"  ,   "DESCRI"  ,"@R" ,60,0,""            ,"","C","","","","",".T."})//02
	AADD(aHeader2,  {    "Tipo"  	 ,   "TIPO"    ,"@R" ,02,0,""            ,"","C","","","","",".T."})//02
	AADD(aHeader2,  {    "Local"  	 ,   "LOCAL"   ,"@R" ,02,0,""            ,"","C","","","","",".T."})//02
	AADD(aHeader2,  {    "Empenho"   ,   "QTDEORI" ,"@E 999,999,999.99" ,15,2,""            ,"","N","","","","",".T."})//02
	AADD(aHeader2,  {    "Saldo"   	 ,   "QUANTID" ,"@E 999,999,999.99" ,15,2,""            ,"","N","","","","",".T."})//02
	AADD(aCols2,{"","","","","","","",.F.})

	dbSelectArea("SD4")
	dbSetOrder(2)
	dbSelectArea("SC2")
	dbSetOrder(1)

	If nLado == 1
		nX:= 590
		nY:= 1150
		nMsRigth:= 570
		nButt1:= 475
		nButt2:= 525
		nLinM:= 0

	Else
		nX:= 900
		nY:= 590
		nMsRigth:= 290
		nButt1:= 190
		nButt2:= 240
		nLinM:= 20

	Endif


	DEFINE FONT oFontNW  NAME "Arial" SIZE 0,-15 BOLD
	Define MsDialog oDlg01 Title OemToAnsi("Documentos amarrados ao produto ") From 0,0 To nX,nY Pixel of oMainWnd PIXEL

	@ 003, 008	SAY oTexto1   VAR 'Produto/OP: '  PIXEL SIZE 180,15
	oTexto1:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

	@ 002, 60 MSGET oProduto VAR cProduto  Picture "@!"  SIZE 90,12 Valid ValidaProd(cProduto) PIXEL
	oProduto:oFont := TFont():New('Courier New',,24,,.T.,,,,.T.,.F.)

	@ 003, 155	SAY oCodigoPn   VAR cCodigoPn  PIXEL SIZE 90,15
	oCodigoPn:oFont := TFont():New('Courier New',,24,,.T.,,,,.T.,.F.)

	If nLado == 1
		@ 003, 260	SAY oTexto2   VAR cDescProd  PIXEL SIZE 400,15
		oTexto2:oFont := TFont():New('Courier New',,24,,.T.,,,,.T.,.F.)
	Else
		@ 022, 008	SAY oTexto2   VAR cDescProd  PIXEL SIZE 400,15
		oTexto2:oFont := TFont():New('Courier New',,24,,.T.,,,,.T.,.F.)
	ENDIF

	@ 21+nLinM,08 say oDet1 VAR cDescDet1 Picture "@!" SIZE 700,15 PIXEL
	oDet1:oFont := TFont():New('Courier New',,20,,.T.,,,,.T.,.F.)
	@ 27+nLinM,08 say oDet2 VAR cDescDet2 Picture "@!" SIZE 700,15 PIXEL
	oDet2:oFont := TFont():New('Courier New',,20,,.T.,,,,.T.,.F.)
	@ 33+nLinM,08 say oDet3 VAR cDescDet3 Picture "@!" SIZE 700,15 PIXEL
	oDet3:oFont := TFont():New('Courier New',,20,,.T.,,,,.T.,.F.)
	@ 37+nLinM,08 say oDet4 VAR cDescDet4 Picture "@!" SIZE 700,15 PIXEL
	oDet4:oFont := TFont():New('Courier New',,20,,.T.,,,,.T.,.F.)


	//IF !EMPTY(cRamo)
		@ 043+nLinM, 08 SAY oTextoF VAR "Ramo :"+ cRamo PIXEL SIZE 180,15
		oTextoF:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	//Endif

	nLinM += 10
	@ 045+nLinM, 008	SAY oTextoC   VAR cDesClien  PIXEL SIZE 180,15
	oTextoC:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

	@ 045+nLinM, 60	SAY oTexto3   VAR cCodClien  PIXEL SIZE 500,15
	oTexto3:oFont := TFont():New('Courier New',,24,,.T.,,,,.T.,.F.)

	@ 045+nLinM, 105	SAY oTexto4   VAR cNomClien  PIXEL SIZE 500,15
	oTexto4:oFont := TFont():New('Courier New',,24,,.T.,,,,.T.,.F.)

	If nLado == 1

		@ 025+nLinM, 390	SAY oTextoX   VAR cCodHuawei  PIXEL SIZE 500,15
		oTextoX:oFont := TFont():New('Courier New',,24,,.T.,,,,.T.,.F.)

		@ 045+nLinM, 390	SAY oTexto5   VAR cQuant  PIXEL SIZE 500,15
		oTexto5:oFont := TFont():New('Courier New',,24,,.T.,,,,.T.,.F.)

		@ 045+nLinM, 480	SAY oTexto6   VAR cSaldo  PIXEL SIZE 500,15
		oTexto6:oFont := TFont():New('Courier New',,24,,.T.,,,,.T.,.F.)
	Else
		nLinM += 20
		@ 045+nLinM, 008	SAY oTexto5   VAR cQuant  PIXEL SIZE 500,15
		oTexto5:oFont := TFont():New('Courier New',,24,,.T.,,,,.T.,.F.)

		@ 045+nLinM, 098	SAY oTexto6   VAR cSaldo  PIXEL SIZE 500,15
		oTexto6:oFont := TFont():New('Courier New',,24,,.T.,,,,.T.,.F.)

	Endif


	oGetDados  := (MsNewGetDados():New( 060+nLinM, 09 , 150 ,nMsRigth,Nil ,"AlwaysTrue" ,"AlwaysTrue", /*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*"U_Ffieldok()"*/,/*superdel*/,/*delok*/,oDlg01,aHeader,aCols))

	@ 165+nLinM, 009	SAY oTextoE   VAR 'Empenhos: '  PIXEL SIZE 180,15
	oTextoE:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	oGetEmp    := (MsNewGetDados():New( 175+nLinM, 09 , 290 ,nMsRigth,Nil ,"AlwaysTrue" ,"AlwaysTrue", /*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*"U_Ffieldok()"*/,/*superdel*/,/*delok*/,oDlg01,aHeader2,aCols2))

	@ 155+nLinM,nButt1 Button "&Visualizar"  Size 45,13 Action Visualizar()    Pixel
	@ 155+nLinM,nButt2 Button "Sair"        Size 45,13 Action oDlg01:End()    Pixel

	Activate MsDialog oDlg01

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VALIDAPROD ºAutor³Michel A. Sander    º Data ³  08.05.2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação do produto/op digitado								     º±±
±±º          ³ 				                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidaProd(cProduto)
	Local lEncontrou := .F.
	Local lCodHuawei:= .F.
	Local lCodFuruka := .F.
	SB1->( dbSetOrder(1) )
	If SB1->( dbSeek( xFilial() + Subs(cProduto,1,15) ) )
		lEncontrou := .T.
		cCodigoPn := SPACE(16)
		cDescDet1 := SPACE(100)
		cDescDet2 := SPACE(100)
		cDescDet3 := SPACE(100)
		cDescDet4 := SPACE(100)
		cDescDet5 := SPACE(100)
		cDesClien := SPACE(09)
		cCodCLien := SPACE(06)
		cNomClien := SPACE(60)
		cQuant    := SPACE(30)
		cSaldo    := SPACE(30)
		oGetEmp:aCols := {}
		AADD(oGetEmp:aCols,{"","","","","","","",.F.})
		oGetEmp:Refresh()
		oTextoC:Refresh()
		oTexto3:Refresh()
		oTexto4:Refresh()
		oTexto5:Refresh()
		oTexto6:Refresh()
		oDet1:Refresh()
		oDet2:Refresh()
		oDet3:Refresh()
		oDet4:Refresh()
	Else
		SC2->( dbSetOrder(1) )
		If SC2->( dbSeek( xFilial() + Subs(cProduto,1,11) ) )
			cCodigoPn := SC2->C2_PRODUTO
			cDesClien :='Cliente: '
			cCodCLien := SC2->C2_CLIENT
			cNomClien := SC2->C2_NCLIENT
			cQuant    := "Quant.: "+AllTrim(TransForm(SC2->C2_QUANT,"@E 999,999.99"))
			cSAldo    := "Saldo: "+AllTrim(TransForm((SC2->C2_QUANT-SC2->C2_QUJE),"@E 999,999.99"))

			SA1->(dbSeek(xFilial("SA1")+SC2->C2_CLIENT))
			lCodHuawei  := If("HUAWEI" $ SA1->A1_NOME, .T., .F.)
			lCodFuruka  := If("FURUKAWA" $ SA1->A1_NOME, .T., .F.)
			cRamo:= SUBSTRING(SA1->A1_XRAMO,3,LEN(ALLTRIM(SA1->A1_XRAMO)))
			if lCodHuawei
				dbSelectArea("SC6")
				dbSetOrder(1)
				IF dbSeek(xFilial()+SC2->C2_PEDIDO+SC2->C2_ITEM)
					cCodHuawei:= "PN HUAWEI: "+AllTrim(SC6->C6_SEUCOD)
				else
					cCodHuawei:= " "
				ENDIF
			eNDIF
			if lCodFuruka
				dbSelectArea("SC6")
				dbSetOrder(1)
				IF dbSeek(xFilial()+SC2->C2_PEDIDO+SC2->C2_ITEM)
					cCodHuawei:= "PN FURUKAWA: "+AllTrim(SC6->C6_SEUCOD)
				else
					cCodHuawei:= " "
				ENDIF
			eNDIF

			SD4->(dbSetOrder(2))
			If SD4->( dbSeek( xFilial() + SC2->C2_NUM + SC2->C2_ITEM ) )
				oGetEmp:aCols := {}
				While !SD4->( EOF() ) .And. SD4->D4_FILIAL+SubStr(SD4->D4_OP,1,8) == SC2->C2_FILIAL+SC2->C2_NUM+SC2->C2_ITEM
					SB1->(dbSeek(xFilial()+SD4->D4_COD))
					AADD(oGetEmp:aCols,{SD4->D4_OP,SD4->D4_COD,SB1->B1_DESC,SB1->B1_TIPO,SD4->D4_LOCAL,SD4->D4_QTDEORI,SD4->D4_QUANT,.F.})
					SD4->( dbSkip() )
				End
				oGetEmp:oBrowse:Refresh()
			EndIf

			oTextoC:Refresh()
			oTexto3:Refresh()
			oTexto4:Refresh()
			oTexto5:Refresh()
			oTexto6:Refresh()
			if nLado
				nTamanho:= 55
			else
				nTamanho:= 100
			ENDIF

			If SB1->( dbSeek( xFilial() + SC2->C2_PRODUTO ) )
				If Empty(SB1->B1_XDESC)
					cAuxDet   := AllTrim(SB1->B1_DESCR1)+" "+AllTrim(SB1->B1_DESCR2)+" "+AllTrim(SB1->B1_DESCR3)+" "+AllTrim(SB1->B1_DESCR4)

					cDescDet1 := SubStr(cAuxDet,(nTamanho*0)+1,nTamanho)
					cDescDet2 := SubStr(cAuxDet,(nTamanho*1)+1,nTamanho)
					cDescDet3 := SubStr(cAuxDet,(nTamanho*2)+1,nTamanho)
					cDescDet4 := ""
				Else
					cDescDet1 := Substr(SB1->B1_XDESC,(nTamanho*0)+1,nTamanho)
					cDescDet2 := Substr(SB1->B1_XDESC,(nTamanho*1)+1,nTamanho)
					cDescDet3 := Substr(SB1->B1_XDESC,(nTamanho*2)+1,nTamanho)
					cDescDet4 := Substr(SB1->B1_XDESC,(nTamanho*3)+1,nTamanho)
				EndIf
				oDet1:Refresh()
				oDet2:Refresh()
				oDet3:Refresh()
				oDet4:Refresh()
				lEncontrou := .T.
			EndIf

		EndIf

	EndIf

	If lEncontrou

		cDescProd := SB1->B1_DESC
		oGetDados:aCols := {}
		If SZV->( dbSeek( xFilial() + "SB1" + SB1->B1_COD ) )
			While !SZV->( EOF() ) .and. SZV->ZV_ALIAS == 'SB1' .and. SZV->ZV_CHAVE == SB1->B1_COD
				AADD(oGetDados:aCols,{SZV->ZV_ARQUIVO,SZV->ZV_DESCRI,.F.})
				SZV->( dbSkip() )
			End
			oGetDados:oBrowse:Refresh()
		Else
			MsgInfo("Não foram encontrados documentos para este produto/OP")
			oGetDados:aCols := {}
			AADD(oGetDados:aCols,{"","",.F.})
			cDesClien := SPACE(09)
			cCodCLien := SPACE(06)
			cNomClien := SPACE(60)
			cQuant    := SPACE(30)
			cSaldo    := SPACE(30)
			oGetEmp:aCols := {}
			AADD(oGetEmp:aCols,{"","","","","","","",.F.})
			oGetEmp:Refresh()
			oTextoC:Refresh()
			oTexto3:Refresh()
			oTexto4:Refresh()
			oTexto5:Refresh()
			oTexto6:Refresh()
			oDet1:Refresh()
			oDet2:Refresh()
			oDet3:Refresh()
			oDet4:Refresh()

			// Envio de workflow para engenharia
			cAssunto := "Produto consultado sem Documento Domex"
			cTexto   := "Produto: " + SB1->B1_COD
			cPara    := 'denis.vieira@rdt.com.br;monique.garcia@rosenbergerdomex.com.br;daniel.cavalcante@rosenbergerdomex.com.br;fabiana.santos@rosenbergerdomex.com.br;tatiane.alves@rosenbergerdomex.com.br;lucimar.silveira@rosenbergerdomex.com.br'
			cCC      := 'natalia.silva@rosenbergerdomex.com.br;keila.gamt@rosenbergerdomex.com.br;leonardo.andrade@rosenbergerdomex.com.br;gabriel.cenato@rosenbergerdomex.com.br;luiz.pavret@rdt.com.br' //chamado monique 015475
			cArquivo := Nil
			U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

			MsgInfo("Workflow de aviso enviado para: '" + cPara + "'.")
		EndIf
		//oGetDados:oBrowse:Refresh()
	Else
		MsgInfo("Produto/OP não encontrado.")
		cDescProd       := ""
		oGetDados:aCols := {}
		AADD(oGetDados:aCols,{"","",.F.})
		oGetEmp:aCols := {}
		AADD(oGetEmp:aCols,{"","","","","","","",.F.})
		oGetDados:oBrowse:Refresh()
		oGetEmp:oBrowse:Refresh()
		cDesClien := SPACE(09)
		cCodCLien := SPACE(06)
		cNomClien := SPACE(60)
		cQuant    := SPACE(30)
		cSaldo    := SPACE(30)
		oTextoC:Refresh()
		oTexto3:Refresh()
		oTexto4:Refresh()
		oTexto5:Refresh()
		oTexto6:Refresh()
		oDet1:Refresh()
		oDet2:Refresh()
		oDet3:Refresh()
		oDet4:Refresh()
	EndIf

	If Len(oGetDados:aCols) == 1
		Visualizar()
	EndIf

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VISUALIZAR ºAutor³Michel A. Sander    º Data ³  08.05.2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Visualiza os documentos do produto/OP						     º±±
±±º          ³ 				                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Visualizar()

	Local cPathTmp := AllTrim( GetTempPath() )
	Local cFileDes := ""

	n := oGetDados:oBrowse:nAt
	If n > 0
		If SZV->( dbSeek( xFilial() + "SB1" + SB1->B1_COD + oGetDados:aCols[n,1] ) )
			QDH->( dbSetOrder(1) )
			If QDH->( dbSeek( xFilial() + Subs(SZV->ZV_ARQUIVO,1,16) ) )

				While !QDH->( EOF() ) .and. Alltrim(QDH->QDH_DOCTO) == Alltrim(SZV->ZV_ARQUIVO)
					QDHRecno := QDH->( Recno() )
					QDH->( dbSkip() )
				End

				QDH->( dbGoTo(QDHRecno) )

				cFileOri := cSlvAnexos + "\" + QDH->QDH_NOMDOC
				cFileDes := cPathTmp + QDH->QDH_NOMDOC

				If !File(cFileOri)
					MsgStop("Arquivo não encontrado.")
					Return
				EndIf

				If File(cFileDes)
					fErase(cFileDes)
				EndIf

				If File(cFileDes)
					Alert("Arquivo já está aberto!")
					Return
				EndIf

				COPY File &cFileOri TO &cFileDes

				ShellExecute("open",cFileDes,"","", 5 )
			Else
				MsgStop("Documento não encontrado no Controle de Documentos.")
			EndIf
		Else
			MsgStop("O arquivo não foi encontrado para exibição")
		EndIf
	Else
		MsgStop("Posicione em um arquivo para exibição")
	EndIf

Return

static Function fside()
	Local oSide1
	Local oSide2
	Local nSide:= 1

	Local oFont1 := TFont():New("Arial",,050,,.T.,,,,,.F.,.F.)
	Static oDlgBtC

	Local cCSSBtN1 :="QPushButton{background-color: #f6f7fa; color: #707070; font: bold 22px Arial; }"+;
		"QPushButton:pressed {background-color: #50b4b4; color: white; font: bold 22px  Arial; }"+;
		"QPushButton:hover {background-color: #878787 ; color: white; font: bold 22px  Arial; }"

	DEFINE MSDIALOG oDlgBtC TITLE "Apresentação" FROM 000, 000  TO 400, 400 COLORS 0, 16777215 PIXEL
	@ 033, 028 BUTTON oSide1 PROMPT "Paisagem" SIZE 150, 053 OF oDlgBtC ACTION (nSide := 1, oDlgBtc:end() ) FONT oFont1 PIXEL
	oSide1:setCSS(cCSSBtN1)
	@ 110, 028 BUTTON oSide2 PROMPT "Retrato" SIZE 150, 053 OF oDlgBtC ACTION (nSide := 2, oDlgBtc:end()) FONT oFont1 PIXEL
	oSide2:setCSS(cCSSBtN1)

	ACTIVATE MSDIALOG oDlgBtC CENTERED

Return nSide

