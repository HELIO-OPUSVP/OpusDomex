#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Rwmake.ch"
#include "Topconn.ch"
#include "Protheus.ch"

#DEFINE ENTER CHAR(13) + CHAR(10)

/* 
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥DOMACD39  ∫Autor  ≥Microsiga           ∫ Data ≥  10/02/19   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Rotina para pagamento da produÁ„o por PickList             ∫±±
±±∫          ≥ Realizado tratamento para pagamento de OPs da filial 02    ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function DOMACD39(__cFilial)

	Local lRet      := .T.
	Local nCol1 	:= 005
	Local nCol2 	:= 015
	Local nLin     	:= 010
	Local nP		:= 0
	Local nSkipLin 	:= 17
	Local cCSSBtN1 	:= ""
	Local nLargBut 	:= 95
	Local nAltuBut 	:= 16
	Local cQryGrps 	:= ""
	Private dData  	:= DDataBase + 1
	Private oTxt1
	Private oTxt2
	Private oTxt3
	Private oTxt31
	Private oTxt4
	Private oTxt5
	Private oData
	Private oDlg0
	Private oDlg1
	Private oDlg2
	Private oDlgT
	Private oGetDados
	Private aHeader 	:= {}
	Private aCols		:= {}
	Private aEnderecos  := {}
	Private oFontNW
	Private aGruposPrd 	:= {}
	Private cGruposPrd 	:= ""
	Private nQtdSldEnd	:= 0
	Private nSqldAend 	:= 0

	Private cLocProcDom := GetMV("MV_XXLOCPR")
	Private cLocTransf  := If(__cFilial=='01',GetMV("MV_XXLOCPR"),GetMV("MV_XLOCTRA"))

	Private cEndProDom	:= If(__cFilial=='01',"97PROCESSO"       ,"95TRANSFERENCIA"  )
	Private lImprimeETq :=.T.
	DEFINE FONT oFontNW  NAME "Arial" SIZE 0,-15 BOLD


	//Tela informaÁ„o da localizaÁ„o e quantidade para o usu·rio
	AADD(aHeader,  {    "ENDERECO"  , "ENDERECO" ,""             ,15,0,""            ,"","C","","","","",".F."})//01
	AADD(aHeader,  {    "QTDEND"  ,   "QTDEND"   ,"@E 999,999,999.9999",15,0,""      ,"","N","","","","",".T."})//02
	AADD(aCols,{'',0,.F.})


	DEFINE MSDIALOG oDlg0 TITLE OemToAnsi("Data-Pagto OP por Picklist") FROM 0,0 TO 293,233 PIXEL OF oMainWnd

	nLin += 10

	@ nLin  ,nCol2	SAY oTxt1 Var   'Data:'  SIZE 25,20 PIXEL OF oDlg0
	@ nLin-10, nCol2 + 020  MSGET oData    VAR dData    Picture "@D"  SIZE 50,20 PIXEL OF oDlg0

	nLin += 50
	@ nLin , nCol1 + 005 BUTTON oBotao1 PROMPT "-1"     ACTION Processa( {|| Botao(1) } ) SIZE 40,30 PIXEL OF oDlg0
	@ nLin , nCol1 + 065 BUTTON oBotao2 PROMPT "+1"     ACTION Processa( {|| Botao(2) } ) SIZE 40,30 PIXEL OF oDlg0


	@ 131,040 Button oBotao3 PROMPT "Ok" Size 40,13 Action Close(oDlg0) Pixel

	cCSSBtN1 := "QPushButton{font: bold 10px Arial;background-repeat: none; }"+;
		"QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }"

	oBotao1:SetCSS( cCSSBtN1 )
	oBotao2:SetCSS( cCSSBtN1 )
	oBotao3:SetCSS( cCSSBtN1 )



	//@ nLin,040 Button "Sair" Size 55,13 Action Close(oDlg0) Pixel

	ACTIVATE MSDIALOG oDlg0

	If (Upper(GetEnvServ()) == 'HOMOLOGACAO') .OR. .T.
		//Selecionar os grupos em utilizaÁ„o pelas OP's
		cQryGrps := " SELECT CASE WHEN B1_GRUPO = 'DIOE' THEN 'DIO' WHEN B1_GRUPO  = 'TRUE' THEN 'TRUN' ELSE B1_GRUPO END CODGRUPO,COUNT(*) QTD "
		cQryGrps += ENTER + " FROM " + RetSqlName("SC2") + " SC2 "
		cQryGrps += ENTER + " JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = '' AND SB1.R_E_C_D_E_L_= 0 AND SB1.B1_FILIAL ='" +  xFilial("SB1") +  "' AND SB1.B1_COD  = SC2.C2_PRODUTO " //AND C2_PEDIDO <> '' "
		cQryGrps += ENTER + " JOIN ( SELECT D4_FILIAL,D4_OP FROM SD4010 SD4 WHERE SD4.D_E_L_E_T_ ='' AND D4_FILIAL = '"+__cFilial+"' AND D4_LOCAL = '97' AND D4_QUANT > 0 "
		cQryGrps += ENTER + " GROUP BY D4_FILIAL,D4_OP ) TMPD4 ON TMPD4.D4_FILIAL =  SC2.C2_FILIAL AND SC2.C2_NUM + C2_ITEM + C2_SEQUEN  = TMPD4.D4_OP "
		cQryGrps += ENTER + " WHERE SC2.D_E_L_E_T_ ='' AND SC2.C2_FILIAL = '"+__cFilial+"' "
		cQryGrps += ENTER + " AND  SC2.C2_XXDTPRO =  '" + DTOS(dData) + "' "
		//cQryGrps += ENTER + " AND SC2.C2_XXDTPRO >=  '20200301' AND  SC2.C2_XXDTPRO <=  '" + DTOS(dData) + "' "
		cQryGrps += ENTER + " GROUP BY CASE WHEN B1_GRUPO = 'DIOE' THEN 'DIO' WHEN B1_GRUPO  = 'TRUE' THEN 'TRUN' ELSE B1_GRUPO END "
		cQryGrps += ENTER + " ORDER BY QTD DESC "

	Else
		//Selecionar os grupos em utilizaÁ„o pelas OP's
		cQryGrps := " SELECT CASE WHEN B1_GRUPO = 'DIOE' THEN 'DIO' WHEN B1_GRUPO  = 'TRUE' THEN 'TRUN' ELSE B1_GRUPO END CODGRUPO,COUNT(*) QTD "
		cQryGrps += ENTER + " FROM " + RetSqlName("SC2") + " SC2 "
		cQryGrps += ENTER + " JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = '' AND SB1.R_E_C_D_E_L_= 0 AND SB1.B1_FILIAL ='" +  xFilial("SB1") +  "' AND SB1.B1_COD  = SC2.C2_PRODUTO " //AND C2_PEDIDO <> '' "
		cQryGrps += ENTER + " WHERE SC2.D_E_L_E_T_ ='' AND SC2.C2_FILIAL = '" + xFilial("SC2") + "' "
		cQryGrps += ENTER + " AND  SC2.C2_XXDTPRO =  '" + DTOS(dData) + "' "
		//cQryGrps += ENTER + " AND SC2.C2_XXDTPRO >=  '20200301' AND  SC2.C2_XXDTPRO <=  '" + DTOS(dData) + "' "
		cQryGrps += ENTER + " GROUP BY CASE WHEN B1_GRUPO = 'DIOE' THEN 'DIO' WHEN B1_GRUPO  = 'TRUE' THEN 'TRUN' ELSE B1_GRUPO END "
		cQryGrps += ENTER + " ORDER BY QTD DESC "
	EndIf
	If Select("TMPGRP") > 0
		TMPdGRP->(DbCloseArea())
	EndIf

	TCQUERY cQryGrps NEW ALIAS "TMPGRP"

	If !TMPGRP->(EOF())
		While !TMPGRP->(EOF())

			Aadd(aGruposPrd,Alltrim(TMPGRP->CODGRUPO))

			TMPGRP->(DbSkip())
		EndDo
	Else
		U_msgcoletor("N„o existem produtos com emepnho no armazÈm 97 ‡ serem pagos nesta data")
	EndIf

	TMPGRP->(DbCloseArea())

	For nP:=1 To  Len(aGruposPrd)
		cGruposPrd  += IIF(nP==Len(aGruposPrd),"oBtng" + StrZero(nP,2), "oBtng" + StrZero(nP,2) + ",")
	Next nP

	SetPrvt(cGruposPrd)



	//Tela para selecionar o grupo que deseja separar
	//Reinicializa nLin para montagem da outra tela
	nLin := 005

	DEFINE MSDIALOG oDlgT TITLE OemToAnsi("Grupos-Pagto OP por Picklist") FROM 0,0 TO 293,233 PIXEL OF oMainWnd

	@ 00,00 SCROLLBOX oDlg1 VERTICAL BORDER SIZE 133, 118 PIXEL OF oMainWnd

	@ nLin  ,nCol2	SAY oTxt2 Var   'Data: '  + DTOC(dData) SIZE 50,15 PIXEL OF oDlg1

	nLin += 13

	cCSSBtN1 := "QPushButton{font: bold 10px Arial;background-image: url(rpo:pcoimg32.png);background-repeat: none; }"+;
		"QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }"

	For nP := 1 To Len(aGruposPrd)
		@ nLin, 10 BUTTON &("oBtng" + Strzero(nP,2)) PROMPT aGruposPrd[nP]     ACTION Processa( {||   BuscaEmpOp(__cFilial) /*U_DOMACD39()*/} ) SIZE nLargBut,nAltuBut PIXEL OF oDlg1
		&("oBtng" + Strzero(nP,2)):SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	Next nP


	//@ 131,008 Button "Ok" Size 40,13 Action Close(oDlg1) Pixel

	@ 135,040 Button oBotao1 PROMPT "Sair" Size 50,13 Action Close(oDlgT) Pixel

	cCSSBtN1 := "QPushButton{font: bold 10px Arial;background-repeat: none; }"+;
		"QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }"

	oBotao1:SetCSS( cCSSBtN1 )

	ACTIVATE MSDIALOG oDlgT


Return lRet


Static Function BuscaEmpOp(__cFilial)

	Local lRet 			:= .T.
	Local nP	  			:= 0
	//Local nCol1 		:= 005
	Local nCol2 		:= 015
	Local nLin       	:= 010
	Local cGrupoProd 	:= ""
	Local cCodProdut 	:= SPACE(15)
	Local cDescrProd 	:= SPACE(100)
	Local nQtdSaldo  	:= 0
	Local nQtdasep   	:= 0
	Local cQryProd		:= ""
	Local cQryEnd 		:= ""
	Local nQtdEmp		:= 0
	Local aImpEtq 		:= {}
	Local ns			:= 0
	//Busca o grupo que est· sendo processado para selecionar as OP's
	For nP := 1 To Len(aGruposPrd)
		If &("oBtng" + Strzero(nP,2)):LPROCESSING //Indica qual bot„o est· sendo executado
			cGrupoProd := Alltrim(aGruposPrd[nP])
		Endif
	Next nP

	If !Empty(Alltrim(cGrupoProd))

		//Imprimir Todas as Etiquetas para o dia
		cQryOps := U_RetQry39("2"/*cTipoCon*/,cGrupoProd,dData,"",Nil ,__cFilial)
		If Select("TMPOPS") > 0
			TMPOPS->(DbCloseArea())
		Endif
		TCQUERY cQryOps NEW ALIAS "TMPOPS"
		If TMPOPS->(!EOF())

			//Validar Se a quantidade que tem no endereÁo È maior que a quantidade da primeira
			//If U_UMSGYESNO("Deseja Imprimir Etiqueta","Impress„o")
			//lImprimeETq :=.T.
			//Endif

			//Prepara impress„o das etiquetas
			cCodOpAtu := ""
			cCodProdAtu := ""
			lMensagem   := .F.
			While TMPOPS->(!EOF())
				//If lImprimeETq
				if Alltrim(cCodOpAtu) <>  Alltrim(TMPOPS->D4_OP) .And. TMPOPS->JAIMPRESSA <> "S"
					cCodOpAtu := TMPOPS->D4_OP
					If (Upper(GetEnvServ()) == 'VALIDACAO')
						cCodProdOp:= Alltrim(Posicione("SC2",1,TMPOPS->D4FILIAL+ TMPOPS->D4_OP,"C2_PRODUTO"))
						//SÛ adiciona 1 X a op para imprimir a etiqueta
						SC2->( dbSeek( xFilial() + Alltrim(cCodOpAtu) ) )
						If SC2->C2_XBLQCQ == 'S' .or. SC2->C2_XBLQCQ == 'W'
							If SC2->C2_XBLQCQ == 'S'
								If !lMensagem
									u_msgcoletor("Existem OPs bloqueadas pelo CQ para separaÁ„o de materiais")
									lMensagem := .T.
									U_WFblOpCq(Alltrim(cCodOpAtu))
								EndIf
								Reclock("SC2",.F.)
								SC2->C2_XBLQCQ := "W"
								SC2->( msUnlock() )
							EndIf
						Else
							If Right(Alltrim(TMPOPS->D4_OP),3) == "001" //cCodProdOp <> cCodProdAtu .And.
								cCodProdAtu := cCodProdOp
								If aScan(aImpEtq,{ |x| Upper(AllTrim(x[1])) == Trim(cCodOpAtu) }) == 0
									AaDd(aImpEtq,{TMPOPS->D4_OP,cCodProdOp,Alltrim(Posicione("SB1",1,xFilial("SB1") + cCodProdOp,"B1_DESC")),TMPOPS->D4FILIAL})
								EndIf
							EndIf
						EndIf
					Else
						cCodProdOp:= Alltrim(Posicione("SC2",1,TMPOPS->D4FILIAL+ TMPOPS->D4_OP,"C2_PRODUTO"))
						//SÛ adiciona 1 X a op para imprimir a etiqueta
						If Right(Alltrim(TMPOPS->D4_OP),3) == "001" //cCodProdOp <> cCodProdAtu .And.
							cCodProdAtu := cCodProdOp
							If aScan(aImpEtq,{ |x| Upper(AllTrim(x[1])) == Trim(cCodOpAtu) }) == 0
								AaDd(aImpEtq,{TMPOPS->D4_OP,cCodProdOp,Alltrim(Posicione("SB1",1,xFilial("SB1") + cCodProdOp,"B1_DESC")),TMPOPS->D4FILIAL})
							EndIf
						EndIf
					EndIf
				Endif
				//EndIf
				TMPOPS->(DbSkip())
			EndDo
		EndIf
		TMPOPS->(DbCloseArea())

		If Len(aImpEtq)	 > 0
			//Reorganiza array para impress„o
			ASORT(aImpEtq, , , { | x,y | x[1] > y[1] } )

			For ns:=1 To Len(aImpEtq)
				If lImprimeETq
					U_EtqNOP39(aImpEtq[ns][1],aImpEtq[ns][2],aImpEtq[ns][3],aImpEtq[ns][4])
				EndIf
			Next ns
		Endif

		cQryProd := U_RetQry39("1"/*cTipoCon*/,cGrupoProd,dData,"",Nil,__cFilial)

		If Select("TEMPS") > 0
			TEMPS->(DbCloseArea())
		EndIf
		TCQUERY cQryProd NEW ALIAS "TEMPS"
		nQtdReg := 0
		If !TEMPS->(EOF())
			While !TEMPS->(EOF())
				cQryEnd := " SELECT BF_PRODUTO,BF_LOCAL,BF_LOCALIZ,BF_QUANT,BF_EMPENHO "
				cQryEnd += ENTER + " FROM " + RetSqlName("SBF") + " SBF (NOLOCK) "
				cQryEnd += ENTER + " JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ ='' AND SB1.R_E_C_D_E_L_ = 0 AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.B1_COD=SBF.BF_PRODUTO AND (SB1.B1_LOCPAD=SBF.BF_LOCAL OR SBF.BF_LOCAL ='21' OR SBF.BF_LOCAL ='17' OR SBF.BF_LOCAL ='02') "
				cQryEnd += ENTER + " WHERE SBF.D_E_L_E_T_ ='' AND SBF.BF_FILIAL='" + xFilial("SBF") + "' AND SBF.BF_PRODUTO = '" + TEMPS->D4_COD + "' AND SBF.BF_QUANT > 0  "
				cQryEnd += ENTER + " ORDER BY BF_QUANT "

				If Select("TMPEND") > 0
					TMPEND->(DbCloseArea())
				EndIf
				TCQUERY cQryEnd NEW ALIAS "TMPEND"
				If !TMPEND->(EOF())
					aCols := {}
					aEnderecos := {}
					nQtdSldEnd := 0
					While !TMPEND->(EOF())
						AaDd(aCols,{Alltrim(TMPEND->BF_LOCALIZ),TMPEND->BF_QUANT,.F.})
						AaDd(aEnderecos,{Alltrim(TMPEND->BF_LOCALIZ),TMPEND->BF_QUANT})
						nQtdSldEnd += TMPEND->BF_QUANT
						TMPEND->(DbSkip())
					EndDo
				Else
					aCols := {}
					aEnderecos := {}
					AADD(aCols,{'',0,.F.})
				EndIf

				SB2->(DbSetOrder(1))
				SB2->(DbSeek(xFilial() + TEMPS->D4_COD ))
				nSqldAend := 0
				While SB2->(!EOF()) .And.SB2->B2_COD == TEMPS->D4_COD
					If SB2->B2_QACLASS > 0
						AaDd(aCols,{Alltrim(SB2->B2_LOCAL + "A ENDERECAR"),SB2->B2_QACLASS,.F.})
						nSqldAend += SB2->B2_QACLASS
					EndIf
					SB2->(Dbskip())
				EndDo

				If Select("TMPEND") > 0
					TMPEND->(DbCloseArea())
				EndIf

				nLin := 02

				cCodProdut	:= TEMPS->D4_COD
				cDescrProd	:= LEFT(Alltrim(TEMPS->B1_DESC),30)
				cDescrPro2	:= Substr(Alltrim(TEMPS->B1_DESC),31,30)
				nQtdSaldo	:= TEMPS->QTDEST
				nQtdasep 	:= (TEMPS->QTDORI - TEMPS->SUM_D3QTD)
				nQtdEmp		:= TEMPS->QTDEMP

				DEFINE MSDIALOG oDlg2 TITLE OemToAnsi("Produto-Pagto OP por Picklist") FROM 0,0 TO 293,233 PIXEL OF oMainWnd

				@ nLin  ,nCol2	SAY oTxt1 Var   'Produto: ' + cCodProdut  SIZE 100,10 PIXEL OF oDlg2
				nLin += 13

				@ nLin  ,nCol2	SAY oTxt2 Var   'DescriÁ„o:' SIZE 50,10 PIXEL OF oDlg2
				nLin += 08

				@ nLin  ,nCol2	SAY oTxt3 Var   cDescrProd 	SIZE 150,10 PIXEL OF oDlg2
				nLin += 13
				If !Empty(cDescrPro2)
					@ nLin  ,nCol2	SAY oTxt31 Var   cDescrPro2 	SIZE 150,10 PIXEL OF oDlg2
					nLin += 11
				EndIf
				iF 	nQtdSaldo < nQtdaSep  .Or.  nQtdSldEnd < nQtdaSep
					@ nLin  ,nCol2	SAY oTxt4 Var   'Qtd.Saldo: ' + Transform(nQtdSaldo,"@E 999,999,999.9999")  SIZE 150,10 COLORS CLR_RED,CLR_WHITE PIXEL OF oDlg2
					nLin += 12
				Else
					@ nLin  ,nCol2	SAY oTxt4 Var   'Qtd.Saldo: ' + Transform(nQtdSaldo,"@E 999,999,999.9999")  SIZE 150,10 PIXEL OF oDlg2
					nLin += 12
				EndIf
				@ nLin  ,nCol2	SAY oTxt4 Var   'Qtd.a separar: ' + Transform(nQtdasep,"@E 999,999,999.9999")  SIZE 150,10 PIXEL OF oDlg2
				nLin += 12


				oGetDados  := (MsNewGetDados():New( 70, 00 , 130 ,117,/*GD_UPDATE+GD_DELETE*/0,"AlwaysTrue" ,"AlwaysTrue", /*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oDlg2,aHeader,aCols))
				oGetDados:oBrowse:Refresh()
				oGetDados:oBrowse:oFont  := oFontNW
				//oGetDados:oBrowse:bChange:={||U_DEV003LOK(oGetDados)}
				nOpcSel := 0

				//@ 134,002 Button "Anterior"	Size 30,13 Action ({||nOpcSel:=1,oDlg2:Close()}) Pixel OF oDlg2
				//@ 134,040 Button "Proximo" 	Size 30,13 Action ({||nOpcSel:=2,oDlg2:Close()}) Pixel OF oDlg2
				@ 134,005 Button oBotao1 PROMPT "Coletar" 	Size 30,13 Action (ColetaProd(cCodProdut,cGrupoProd,dData,nQtdEmp,nQtdasep,aEnderecos,__cFilial)) Pixel OF oDlg2
				@ 134,045 Button oBotao3 PROMPT "Anterior" 	Size 30,13 Action (nOpcSel:=1,Close(oDlg2)) Pixel OF oDlg2
				@ 134,085 Button oBotao2 PROMPT "Proximo" 	Size 30,13 Action (nOpcSel:=2,Close(oDlg2)) Pixel OF oDlg2
				//@ 134,085 Button oBotao3 PROMPT "Sair" 	Size 30,13 Action Close(oDlg2) Pixel OF oDlg2

				cCSSBtN1 := "QPushButton{font: bold 10px Arial;background-repeat: none; }"+;
					"QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }"
				oBotao1:SetCSS( cCSSBtN1 )
				oBotao2:SetCSS( cCSSBtN1 )
				oBotao3:SetCSS( cCSSBtN1 )

				ACTIVATE MSDIALOG oDlg2

				If nOpcSel==1
					TEMPS->(DbGoTop())
					nQtdReg := nQtdReg-1
					If nQtdReg > 0
						TEMPS->(DbSkip(nQtdReg))
					EndIf
				ElseIf nOpcSel == 2 .Or. nOpcSel == 3
					nQtdReg ++
					TEMPS->(DbSkip())
				Else
					Exit
				EndIf
			EndDo
		Else
			u_msgcoletor("N„o existem dados a serem exibidos para o grupo informado")
		EndIf
	Else
		u_msgcoletor("Grupo de produtos n„o informado.")
	EndIf

Return lRet

Static Function Botao(cTipo)

	If cTipo == 1 // -1
		dData := (dData-1)
	EndIf

	If cTipo == 2 // +1
		dData := (dData+1)
	EndIf

	oData:Refresh()

Return .T.


Static Function ColetaProd(cCodProdut,cGrupoProd,dData,nQtdEmp,nQtdasep,aEnderecos,__cFilial)
	Local lRet 			:= .T.
	Local cQryOps 		:= ""
	Local cSemaforo 	:= ""
	//Local nQtEmpASep	:= 0
	Local nK			:= 0
	Local aOpsApagar 	:= {}

	Private nQtJaSepar		:= 0
	If U_Validacao()
		cSemaforo := __cFilial+cGrupoProd + cCodProdut
	else
		cSemaforo := cGrupoProd + cCodProdut
	EndIf
	If !LockByName(cSemaforo, .F., .F.)
		U_msgcoletor( "Produto j· est· sendo separado por outro usu·rio " )
		nOpcSel	:= 3
		Return nil
	EndIf

	//Inicia o Pagamento
	cQryOps := U_RetQry39("2"/*cTipoCon*/,cGrupoProd,dData,cCodProdut,Nil,__cFilial)

	If Select("TMPOPS") > 0
		TMPOPS->(DbCloseArea())
	Endif
	TCQUERY cQryOps NEW ALIAS "TMPOPS"
	If TMPOPS->(!EOF())
		//Validar Se a quantidade que tem no endereÁo È maior que a quantidade da primeira OP do produto
		//If (nQtdSldEnd + nSqldAend) >= TMPOPS->(TMPOPS->QTDORI - TMPOPS->SUM_D3QTD) .And. TMPOPS->(TMPOPS->QTDORI - TMPOPS->SUM_D3QTD) > 0
		While TMPOPS->(!EOF())
			//Adiciona as ops que passara na validaÁ„o do status
			AADD(aOpsApagar,{TMPOPS->D4_OP,(TMPOPS->QTDORI - TMPOPS->SUM_D3QTD),TMPOPS->D4FILIAL})
	
			TMPOPS->(DbSkip())
		EndDo
		/*else
			//Marcar os empenhos parar n„o aparecer no picklist atÈ regularizar o estoque.
		If TMPOPS->(TMPOPS->QTDORI - TMPOPS->SUM_D3QTD) > 0
			While TMPOPS->(!EOF())
					DbSelectArea("SD4")				 
					SD4->(DbGoTo(TMPOPS->RECNOSD4))
				If Alltrim(TMPOPS->D4_OP) == Alltrim(SD4->D4_OP)
						Reclock("SD4",.f.)
							SD4->D4_XPKLIST := "N"	
						SD4->(MsUnlock())
				Endif
					DbSelectArea("TMPOPS")
					TMPOPS->(DbSkip())
			EndDo
		EndIf
	EndIf
		*/
EndIf
TMPOPS->(DbCloseArea())

If Len(aOpsApagar) > 0
	_cProdEmp := cCodProdut
	_cDescric := Alltrim(Posicione("SB1",1,xFilial("SB1") + cCodProdut,"B1_DESC"))
	_cLocPadP := Alltrim(Posicione("SB1",1,xFilial("SB1") + cCodProdut,"B1_LOCPAD"))
	_nQtdEmp  := nQtdEmp
	nSaldoSD4 := nQtdasep

	//Carregar vari·vel de quantidade conforme regra de negÛcio
	//Se a quantidade existente no endereÁo for sucifiente para atender Todas as OPS carrega a quanidade do empenho
	//Se a quantidade do EndereÁo for menor, carrega a quantiadade desse endereÁo, e transfere atÈ a op possivel,
	//e passa para o prÛximo endereÁo atÈ zerar
	If Len(aEnderecos) > 0
		If aEnderecos[1][2] >= nSaldoSD4
			_nQtd := nSaldoSD4
			_cEnderec := aEnderecos[1][1]
			lProcEnd := .F.
		Else
			lProcEnd := .T.
		Endif

		For nK := 1 To Len(aEnderecos)
			If aEnderecos[nK][2] >= (nSaldoSD4  - nQtJaSepar)
				_cEnderec := aEnderecos[nK][1]
				_nQtd := (nSaldoSD4  - nQtJaSepar)
				PagaOpsProd(_cProdEmp,_cDescric,_nQtdEmp,_cEnderec,(nSaldoSD4  - nQtJaSepar),aOpsApagar,_cLocPadP,cCodProdut)
				Exit //Sai do For pois j· atendeu todas as OP'S
			Else
				_cEnderec := aEnderecos[nK][1]
				_nQtd := aEnderecos[nK][2]
				PagaOpsProd(_cProdEmp,_cDescric,_nQtdEmp,_cEnderec,(nSaldoSD4  - nQtJaSepar),aOpsApagar,_cLocPadP,cCodProdut)
			EndIf
		Next nK
	else
		U_MsgColetor("N„o existe saldo por endereÁo desse produto")
	EndIf
EndIf

UnLockByName(cSemaforo)
nOpcSel := 3
Close(Odlg2)
Return lRet


Static Function PagaOpsProd(_cProdEmp,_cDescric,_nQtdEmp,_cEnderec,nSaldoSD4,aOpsApagar,_cLocPadP,cCodProdut)
	Local nIncLin           := -15
	Private oTxtOP,oGetOP,oTxtEtiq,oGetEtiq,oTxtProd,oGetProd,oTxtQtd,oGetQtd,oMark,oTxtQtdEmp,oMainEti
	Private _nTamEtiq 		:= 21
	Private _cFilialOP      := xFilial()
	Private _cNumOP        	:= Space(Len(CriaVar("D3_OP",.F.)))
	Private _cEtiqueta     	:= Space(_nTamEtiq)//Space(Len(CriaVar("XD1_XXPECA",.F.)))
	Private _cProduto      	:= CriaVar("B1_COD",.F.)
	Private _nQtd          	:= CriaVar("XD1_QTDATU",.F.)
	Private _cLoteEti      	:= CriaVar("BF_LOTECTL",.F.)
	Private _aCols        	:= {}
	Private _lAuto			:= .T.
	Private _lIndividual  	:= .T.
	Private _cCodInv
	Private cGetEnd        	:= Space(2+15+1)
	Private _aDados        	:= {}
	Private _aEnd          	:= {}
	Private _nCont
	Private nFCICalc       	:= SuperGetMV("MV_FCICALC",.F.,0)
	Private aEtqLidas		:= {}
	Private nQtEtqLida		:= 0
	Private nQTransfOk:= 0
	dDataBase := Date()

	Define MsDialog oTelaOP Title OemToAnsi("Pagamento OP " + DtoC(dDataBase) ) From 0,0 To 293,233 Pixel of oMainWnd PIXEL

	nLin := 005

	@ 018+nIncLin,001 To 057+nIncLin,115 Pixel Of oMainWnd PIXEL

	@ 020+nIncLin,005 Say oTxtLabelOP  Var "Produto sugerido"                            Pixel Of oTelaOP
	@ 027+nIncLin,005 Say oTxtProdEmp  Var "CÛdigo: "+ _cProdEmp                         Pixel Of oTelaOP
	@ 027+nIncLin,077 Say oTxtQtdEmp   Var "Qtd: " + TransForm(_nQtdEmp,"@E 999,999.99") Pixel Of oTelaOP
	@ 033+nIncLin,005 Say oTxtDescric  Var "DescriÁ„o: "+ _cDescric Size 110,15          Pixel Of oTelaOP
	@ 048+nIncLin,005 Say oTxtEnderec  Var "EndereÁo: " + _cEnderec                      Pixel Of oTelaOP

	@ 130+nIncLin,005 Say oSaldoSD4    Var "Saldo: " + Alltrim(Transform(nSaldoSD4 - nQTransfOk ,"@E 999,999,999.9999")) Pixel Of oTelaOP

	oSaldoSD4:oFont   := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	oTxtLabelOP:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
	oTxtProdEmp:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
	oTxtDescric:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
	oTxtEnderec:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
	oTxtQtdEmp:oFont  := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)

	nLin+= 60
	@ nLin  +nIncLin,005 Say oTxtEnd   Var "EndereÁo "  Pixel Of oTelaOP
	@ nLin-2+nIncLin,045 MsGet oGetEnd Var cGetEnd Valid fValidEnd() Size 70,10  Pixel Of oTelaOP
	oTxtEnd:oFont:= TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
	oGetEnd:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

	nLin+= 20
	@ nLin  +nIncLin,005 Say oTxtEtiq   Var "Etiqueta " Pixel Of oTelaOP
	@ nLin-2+nIncLin,045 MsGet oGetEtiq Var _cEtiqueta  Size 70,10 Valid IIF(!Empty(Alltrim(_cEtiqueta)),IIF(ValidaEtiq(cCodProdut),ValidQtd(aOpsAPagar,_nQtd),.F.),.T.) Pixel Of oTelaOP
	oTxtEtiq:oFont:= TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
	oGetEtiq:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

	nLin+= 20
	@ nLin  +nIncLin,005 Say oTxtQtd    Var "Qtd.Bipada" Pixel Of oTelaOP
	//@ nLin-2+nIncLin,045 MsGet oGetQtd  Var _nQtd Valid ValidQtd(aOpsAPagar,_nQtd) Picture "@E 9,999,999.9999" Size 70,10  Pixel Of oTelaOP
	@ nLin-2+nIncLin,045 MsGet oGetQtd  Var nQtEtqLida When .F. Picture "@E 9,999,999.9999" Size 70,10  Pixel Of oTelaOP
	oTxtQtd:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
	oGetQtd:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

	nLin+= 20

	@ nLin,085 Button "Fechar"   Size 25,15 Action Close(oTelaOp) Pixel Of oTelaOP

	Activate MsDialog oTelaOP

Return

//--------------------------------------------------------------------

Static Function fTelaEti()
	Private _lReturn:=.T.

	_cNumEti  :=XD1->XD1_XXPECA
	_cProdEti :=XD1->XD1_COD
	_nQtdEti  :=XD1->XD1_QTDATU
	_cEndeEti :=XD1->XD1_LOCALI
	_cDescEti :=""

	SB1->(dbSetOrder(1))
	SB1->(dbGotop())
	If SB1->(dbSeek(xFilial("SB1")+XD1->XD1_COD))
		_cDescEti := SB1->B1_DESC
	EndIf

	SB2->( dbSetOrder(1) )
	If !SB2->( dbSeek( xFilial() + XD1->XD1_COD + XD1->XD1_LOCAL ) )
		U_MsgColetor("SB2 n„o encontrado.")
	EndIf

	Define MsDialog oTelaEti Title OemToAnsi("CorreÁ„o Etiqueta") From 0,0 To 293,233 Pixel of oMainEti PIXEL

	nLin := 005
	@ nLin,005 Say oTxtEti     Var "Etiqueta " Pixel Of oTelaEti
	@ nLin-2,045 MsGet oGetEti Var _cNumEti When .F. Size 70,10 Pixel Of oTelaEti

	oTxtEti:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
	oGetEti:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

	@ 018,001 To 057,115 Pixel Of oMainEti PIXEL

	@ 020,005 Say oTxtLabel    Var "Dados da Etiqueta" Pixel Of oTelaEti
	@ 027,005 Say oTxtProdEti  Var "CÛdigo: "   + _cProdEti Pixel Of oTelaEti
	@ 027,077 Say oTxtQtdEti   Var "Qtd: "      + TransForm(_nQtdEti,"@E 999,999.99") Pixel Of oTelaEti
	@ 033,005 Say oTxtDescEti  Var "DescriÁ„o: "+ _cDescEti Size 110,15 Pixel Of oTelaEti
	@ 048,005 Say oTxtEndeEti  Var "EndereÁo: " + _cEndeEti Pixel Of oTelaEti

	oTxtLabel  :oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
	oTxtProdEti:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
	oTxtDescEti:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
	oTxtEndeEti:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
	oTxtQtdEti :oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)

	nLin+= 60
	@ nLin  ,005 Say oTxtQtdEti    Var "Quantidade " Pixel Of oTelaEti
	@ nLin-2,045 MsGet oGetQtdEti  Var _nQtdEti Valid fQtdEti() Picture "@E 9,999,999.99" Size 70,10  Pixel Of oTelaEti
	oTxtQtdEti:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
	oGetQtdEti:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

	nLin+= 20
	@ nLin,070 Button "Cancelar" Size 40,15 Action Close(oTelaEti) Pixel Of oTelaEti

	Activate MsDialog oTelaEti

Return(_lReturn)

//--------------------------------------------------------------------

Static Function fQtdEti()
	Close(oTelaEti)
	If _nQtdEti >0
		If _nQtdEti <= SB2->B2_QATU
			DbSelectArea("XD1")
			Reclock("XD1",.F.)
			XD1->XD1_QTDATU := _nQtdEti
			XD1->XD1_OCORRE := "4"
			XD1->( MsUnlock() )
		Else
			U_MsgColetor("N„o foi possÌvel realizar o ajuste .Saldo atual :"+TransForm(SB2->B2_QATU,"@E 999,999.99")+".")
			_cEtiqueta := Space(_nTamEtiq)
			oGetEtiq:Refresh()
			_lReturn   :=.F.
		EndIf
	Else
		U_MsgColetor("Informe uma quantidade v·lida.")
	EndIf
Return

//---------------------------------------------------------

Static Function ValidaEtiq(cCodProdut)
	Local _Retorno := .F.
	Local _lLote   := .F.
	Local _lEnd    := .F.

	XD1->( dbSetOrder(1) )
	SB1->( dbSetOrder(1) )
	SD4->( dbSetOrder(1) )

	If Len(AllTrim(_cEtiqueta))==12 //EAN 13 s/ dÌgito verificador.
		_cEtiqueta := "0"+_cEtiqueta
		_cEtiqueta := Subs(_cEtiqueta,1,12)
	EndIf

	If Len(AllTrim(_cEtiqueta))==20 //CODE 128 c/ dÌgito verificador.
		_cEtiqueta := Subs(AllTrim(_cEtiqueta),8,12)
	EndIf
	oGetEtiq:Refresh()
	If !Empty(_cEtiqueta)
		XD1->( dbSetOrder(1) )
		If XD1->( dbSeek( xFilial("XD1") + _cEtiqueta ) )
			If Subs(XD1->XD1_LOCAL+XD1->XD1_LOCALI+Space(17),1,17) <> Subs(cGetEnd+Space(17),1,17)
				U_MsgColetor("EndereÁo selecionado diferente da Etiqueta.")
				Return .F.
			EndIf
			If (Upper(GetEnvServ()) == 'VALIDACAO')
				If Alltrim(XD1->XD1_COD) <> Alltrim(cCodProdut)
					U_MsgColetor("Produto da Etiqueta n„o corresponde ao produto a ser separado!")
					Return .F.
				EndIf
			EndIf	
			//Tratamento para etiqueta avulsa.
			If Empty(XD1->(XD1_DOC+XD1_SERIE+XD1_FORNEC+XD1_LOJA)) .or. .T.
				Do Case
				Case XD1->XD1_OCORRE == '5'
					If U_uMsgYesNo('Etiqueta zerada. Deseja corrigir?')
						fTelaEti()
					Else
						_cEtiqueta  := Space(_nTamEtiq)
						oGetEtiq:Refresh()
						_Retorno := .F.
					EndIf
				Case XD1->XD1_OCORRE == '4'
					_Retorno := .T.
				Case XD1->XD1_QTDATU == 0
					U_MsgColetor('N„o existe saldo para esta etiqueta')
					_cEtiqueta  := Space(_nTamEtiq)
					oGetEtiq:Refresh()
					_Retorno    := .F.
				OtherWise
					U_MsgColetor('Status de Etiqueta desconhecido.')
					_cEtiqueta  := Space(_nTamEtiq)
					oGetEtiq:Refresh()
					_Retorno := .F.
				EndCase

				If !Empty(XD1->XD1_LOTECTL)
					If _Retorno
						If SB1->( dbSeek( xFilial() + XD1->XD1_COD ) )
							lSD4OK := .T.
							If lSD4OK
								_lOkProc := .T.
								If _lOkProc
									//Verifica o saldo no endereÁo+lote.
									_lSaldoEnd:=.T.
									If !_lSaldoEnd
										U_MsgColetor("Saldo do endereÁo/lote menor que a quantidade/lote da embalagem.")
										Return .F.
									Else
										_nQtd := If(XD1->XD1_QTDATU >= nSaldoSD4,nSaldoSD4,XD1->XD1_QTDATU)
									EndIf
								EndIf
							Else
								U_MsgColetor('Este produto sÛ existe como PI para esta OP.')
								_Retorno := .F.
							EndIf

						Else
							U_MsgColetor('Cadastro Produto '+XD1->XD1_COD+' n„o encontrado.')
							_Retorno := .F.
						EndIf
					EndIf
				Else
					U_MsgColetor("Etiqueta inv·lida por estar sem n˙mero de lote.")
					_Retorno := .F.
				EndIf
			Else
				dbSelectArea("SD1")
				SD1->( dbSetOrder(1) )
				If SD1->( dbSeek( xFilial() + XD1->XD1_DOC + XD1->XD1_SERIE + XD1->XD1_FORNEC + XD1->XD1_LOJA + XD1->XD1_COD + XD1->XD1_ITEM ) )
					If !Empty( SD1->D1_TES )
						dbSelectArea("SF4")
						SF4->( dbSetOrder(1) )
						If SF4->( dbSeek( xFilial("SF4") + SD1->D1_TES ) )
							If SF4->F4_ESTOQUE == 'S'
								If XD1->XD1_OCORRE == '1'
									U_MsgColetor('A Nota Fiscal de Entrada deste material n„o foi classificada.')
									_cEtiqueta  := Space(_nTamEtiq)
									oGetEtiq:Refresh()
									_Retorno := .F.
								Else
									If XD1->XD1_OCORRE == '2'
										U_MsgColetor('Etiqueta de material com pendÍncia de liberaÁ„o pelo CQ.')
										_cEtiqueta  := Space(_nTamEtiq)
										oGetEtiq:Refresh()
										_Retorno := .F.
									Else
										If XD1->XD1_OCORRE == '3'
											U_MsgColetor('Etiqueta n„o endereÁada.')
											_cEtiqueta  := Space(_nTamEtiq)
											oGetEtiq:Refresh()
											_Retorno := .F.
										Else
											If XD1->XD1_OCORRE == '5'
												U_MsgColetor('Etiqueta de material j· utilizado.')
												_cEtiqueta  := Space(_nTamEtiq)
												oGetEtiq:Refresh()
												_Retorno := .F.
											Else
												If XD1->XD1_OCORRE $ ('4')
													_Retorno := .T.
												Else
													U_MsgColetor('Status de Etiqueta desconhecido.')
													_cEtiqueta  := Space(_nTamEtiq)
													oGetEtiq:Refresh()
													_Retorno := .F.
												EndIf
											EndIf
										EndIf
									EndIf
								EndIf

								If !Empty(XD1->XD1_LOTECTL)
									If _Retorno
										If Rastro(XD1->XD1_COD)
											_lLote :=.T.
										EndIf

										If Localiza(XD1->XD1_COD)
											_lEnd :=.T.
										EndIf

										If _lLote .and. _lEnd

											If XD1->XD1_QTDATU == 0
												U_MsgColetor('N„o existe saldo para esta etiqueta')
												_cEtiqueta  := Space(_nTamEtiq)
												oGetEtiq:Refresh()
												_Retorno    := .F.
											Else
												If SB1->( dbSeek( xFilial() + XD1->XD1_COD ) )
													If SD4->( dbSeek( xFilial() + XD1->XD1_COD + _cNumOP) )

														SD3->(DbOrderNickName("USUSD30001"))
														SUMD3QTD := 0

														If SD3->( dbSeek( xFilial() + SD4->D4_OP + SD4->D4_COD ) )
															While !SD3->( EOF() ) .and. SD4->D4_OP + SD4->D4_COD == SD3->D3_XXOP + SD3->D3_COD  // tratado
																If Empty(SD3->D3_ESTORNO) .and. SD3->D3_LOCAL == cLocProcDom
																	If SD3->D3_CF == 'DE4'
																		SUMD3QTD += SD3->D3_QUANT
																	EndIf
																	If SD3->D3_CF == 'RE4'
																		SUMD3QTD -= SD3->D3_QUANT
																	EndIf
																EndIf
																SD3->( dbSkip() )
															End
														EndIf


														If (SD4->D4_QUANT - SUMD3QTD) <= 0
															U_MsgColetor('O saldo do empenho deste produto '+Alltrim(SD4->D4_COD)+' est· zerado para esta OP.')
															_cEtiqueta := Space(_nTamEtiq)
															oGetEtiq:Refresh()
															_Retorno   := .F.
														Else
															// Verifica se o saldo do SB2 est· no endereÁo bipado
															//nSaldoSD4 := SD4->D4_QUANT - SUMD3QTD mls
															nSaldoSD4 := SD4->D4_QTDEORI - SUMD3QTD //mls

															SD4->(dbSetOrder(2))
															SD4->(dbGotop())
															If SD4->( dbSeek( xFilial() + _cNumOP + XD1->XD1_COD))

																_lOkProc :=.T.    //Verifica se a quantidade informada na etiqueta È maior que o saldo atual.
																SB2->( dbSetOrder(1) )
																If SB2->( dbSeek( xFilial() + XD1->XD1_COD + XD1->XD1_LOCAL ) )
																	If SB2->B2_QATU < XD1->XD1_QTDATU

																		//_lOkProc:=fTelaEti()
																		U_MsgColetor("Saldo fÌsico "+Alltrim(Transform(SB2->B2_QATU,"@E 999,999,999.9999"))+" menor que o saldo da etiqueta.")
																		_lOkProc := .F.

																	EndIf
																EndIf

																If _lOkProc

																	//Verifica o saldo no endereÁo+lote.
																	_lSaldoEnd:=.F.

																	SBF->(dbSetOrder(2))
																	SBF->(dbGotop())
																	If SBF->(dbSeek(xFilial("SBF")+XD1->XD1_COD+XD1->XD1_LOCAL))
																		While xFilial("SBF")+XD1->XD1_COD+XD1->XD1_LOCAL == SBF->(BF_FILIAL+BF_PRODUTO+BF_LOCAL)

																			If AllTrim(SBF->BF_LOCALIZ) == AllTrim(SubStr(cGetEnd,3))
																				If (SBF->BF_QUANT-SBF->BF_EMPENHO) >= XD1->XD1_QTDATU
																					SB8->( dbSetOrder(3) )
																					SB8->( dbGotop() )
																					If SB8->(dbSeek(xFilial()+XD1->XD1_COD+XD1->XD1_LOCAL+SBF->BF_LOTECTL))
																						If SB8->B8_SALDO >= XD1->XD1_QTDATU
																							_lSaldoEnd :=.T.
																							Exit
																						EndIf
																					EndIf
																				EndIf
																			EndIf

																			SBF->(dbSkip())
																		End
																	EndIf

																	If! _lSaldoEnd
																		U_MsgColetor("Saldo do endereÁo insuficiente.")
																		Return .F.
																	Else
																		_nQtd:=If(XD1->XD1_QTDATU >= (SD4->D4_QUANT - SUMD3QTD),SD4->D4_QUANT - SUMD3QTD,XD1->XD1_QTDATU)
																	EndIf
																EndIf
															EndIf
														EndIf
													Else
														U_MsgColetor('N„o existe empenho deste produto para esta OP.')
														_Retorno := .F.
													EndIf
												EndIf
											EndIf
										Else
											U_MsgColetor('OperaÁ„o n„o permitida Produto '+XD1->XD1_COD+' n„o controla Lote / EndereÁo.')
											_cEtiqueta  := Space(_nTamEtiq)
											oGetEtiq:Refresh()
											_Retorno := .F.
										EndIf
									EndIf
								Else
									U_MsgColetor("Etiqueta inv·lida por estar sem n˙mero de lote.")
									_Retorno := .F.
								EndIf
							Else
								U_MsgColetor('Nota Fiscal nao movimenta o Estoque '+XD1->XD1_DOC+'.')
							EndIf
						EndIf
					Else
						U_MsgColetor('Nota Fiscal nao Classificada '+XD1->XD1_DOC+'.')
					EndIf
				Else
					U_MsgColetor('Numero de Nota Fiscal gravada na etiqueta n„o encontrada no arquivo de Notas. N„o ser· possÌvel utilizar este material.')
					_cEtiqueta  := Space(_nTamEtiq)
					oGetEtiq:Refresh()
					_Retorno := .F.
				EndIf
			EndIf
		Else
			U_MsgColetor('CÛdido de Etiqueta inv·lido.')
			_cEtiqueta  := Space(_nTamEtiq)
			oGetEtiq:Refresh()
			_Retorno := .F.
		EndIf
		//oGetEtiq:SetFocus()
	Else
		_Retorno := .T.
	EndIf

Return _Retorno



Static Function fValidEnd()
	Local _Retorno := .T.

	//nSaldoSD4 := 0

	If !Empty(cGetEnd)
		SBE->( dbSetOrder(1) )
		If SBE->( dbSeek( xFilial("SBE") + Subs(cGetEnd,1,17) ) )
			If SBE->BE_STATUS == '3'
				U_MsgColetor('EndereÁo bloqueado para uso.')
				_Retorno := .F.
			EndIf
		Else
			U_MsgColetor('EndereÁo inv·lido.')
			_Retorno := .F.
		EndIf
	EndIf

Return _Retorno



Static Function ValidQtd(aOpsApagar,_nQtd)
	Local _Retorno  := .T.
	Local _nQtdOP 	:= 0
	Local nk		:= 0
	Local nR		:= 0
	Local nP		:= 0
	Local ___x		:= 0
	Local nQtdOpsPgs:= 0
	Local nQEtqLidas:= 0
	Private lMsHelpAuto := .T.
	Private lMsErroAuto := .F.

	_cLote :=""
	//ConOut("Inicio do ValidaOp DOMACD05 " + Time())
	If _nQtd > 0
		If Rastro(XD1->XD1_COD)   //Rastro(SD7->D7_PRODUTO,'S') Sub lote
			_cLote := If(Empty(XD1->XD1_LOTECTL),"LOTE1308",XD1->XD1_LOTECTL)
		Else
			U_MsgColetor("Erro. Produto sem controle de lote!")
			Return .F.
		EndIf

		//Salvar as etiquetas que ser„o utilizadas
		AaDd(aEtqLidas,{XD1->XD1_XXPECA,XD1->XD1_QTDATU,XD1->(Recno())})

		nQtEtqLida += XD1->XD1_QTDATU

		//Se  a quantidade de Etiquetas Lidas for maior ou igual a quantidade do Empenho inicia a transferÍncia
		If nQtEtqLida >= nSaldoSD4
			For nR:= 1 To Len(aOpsApagar)

				_cNumOP	:= Alltrim(aOpsApagar[nR][1])
				
				_cFilialOP := aOpsApagar[nR][3]
				
				nQTransfOk := 0
				_nQtdOp := aOpsApagar[nR][2]

				nQEtqLidas := Len(aEtqLidas) //Conta Quantidade de Etiquetas no array

				//Ordena as etiquetas lidas da maior para a menor.
				//ASORT(aEtqLidas, , , { | x,y | x[2] > y[2] } )

				For nK:=1 To Len(aEtqLidas)

					//Posiciona a XD1 na primeira etiqueta que ser· utilizada no produto.
					XD1->(DbGoTo(aEtqLidas[nK][3]))

					//Valida se est· posicionado na etiqueta correta
					If AlltriM(XD1->XD1_XXPECA) == Alltrim(aEtqLidas[nK][1]) .And. aEtqLidas[nK][2] > 0	.And. _nQtdOp > 0	.And. aOpsApagar[nR][2] > 0	.And. (aOpsApagar[nR][2] - nQTransfOk) > 0
						If  XD1->XD1_QTDATU >= aOpsApagar[nR][2] - nQTransfOk
							_nQtdOp := aOpsApagar[nR][2] - nQTransfOk
						else
							_nQtdOp := XD1->XD1_QTDATU
						EndIf

						SD4->( dbSetOrder(1) )
						If SD4->(  dbSeek( _cFilialOP + XD1->XD1_COD +_cNumOP ) )
							lSD4_OK := .F.
							While _cFilialOP + Subs(_cNumOP,1,11) == SD4->D4_FILIAL + Subs(SD4->D4_OP,1,11)
								If SD4->D4_LOCAL == cLocProcDom .and. Empty(SD4->D4_OPORIG)
									lSD4_OK := .T.
									Exit
								EndIf
								SD4->(dbSkip())
							End
							If !lSD4_OK
								U_MsgColetor('Erro na localizaÁ„o do empenho.')
								loop
							EndIf

							SD3->(DbOrderNickName("USUSD30001"))  // D3_FILIAL + D3_XXOP + D3_COD
							SUMD3QTD := 0

							If SD3->( dbSeek( xFilial() + SD4->D4_OP + SD4->D4_COD ) )
								While !SD3->( EOF() ) .and. SD4->D4_OP + SD4->D4_COD == SD3->D3_XXOP + SD3->D3_COD  // tratado
									If Empty(SD3->D3_ESTORNO) .and. SD3->D3_LOCAL == cLocTransf
										If SD3->D3_CF == 'DE4'
											SUMD3QTD += SD3->D3_QUANT
										EndIf
										If SD3->D3_CF == 'RE4'
											SUMD3QTD -= SD3->D3_QUANT
										EndIf
									EndIf
									SD3->( dbSkip() )
								End
							EndIf
							If _nQtdOP <= (SD4->D4_QTDEORI - SUMD3QTD)  //MLS
								If SD4->D4_LOCAL <> cLocProcDom
									U_MsgColetor("N„o È possÌvel pagar produtos empenhados em almoxarifado diferente de 97")
								Else
									If SB1->( dbSeek( xFilial() + XD1->XD1_COD ) )

										_aAuto := {}

										SD3->( dbSetOrder(2))

										For ___x := 1 to 100
											Private _cDoc	        := U_NEXTDOC() //GetSxENum("SD3","D3_DOC",1)
											If !SD3->( dbSeek(xFilial() + _cDoc) )
												Exit
											EndIf
										Next ___x

										_cDoc :=_cDoc+SPACE(09)     //DOCUMENTO 9 DIGITOS
										_cDoc :=SUBSTR(_cDoc,1,9)


										aadd(_aAuto,{_cDoc,dDataBase})

										/*
										Prod.Orig. D3_COD      C        15       0
										Desc.Orig. D3_DESCRI   C        30       0
										UM Orig.   D3_UM       C         2       0
										Armazem Or D3_LOCAL    C         2       0
										Endereco O D3_LOCALIZ  C        15       0
										Prod.Desti D3_COD      C        15       0
										Desc.Desti D3_DESCRI   C        30       0
										UM Destino D3_UM       C         2       0
										Armazem De D3_LOCAL    C         2       0
										Endereco D D3_LOCALIZ  C        15       0
										Numero Ser D3_NUMSERI  C        20       0
										Lote       D3_LOTECTL  C        10       0
										Sub-Lote   D3_NUMLOTE  C         6       0
										Validade   D3_DTVALID  D         8       0
										Potencia   D3_POTENCI  N         6       2
										Quantidade D3_QUANT    N        11       4
										Qt 2aUM    D3_QTSEGUM  N        12       2
										Estornado  D3_ESTORNO  C         1       0
										Sequencia  D3_NUMSEQ   C         6       0
										Lote Desti D3_LOTECTL  C        10       0
										Validade D D3_DTVALID  D         8       0
										Item Grade D3_ITEMGRD  C         3       0
										Per. Imp.  D3_PERIMP   N         8       4
										*/

										CriaSB2(XD1->XD1_COD, cLocTransf)

										_aItem := {}
										aadd(_aItem,XD1->XD1_COD)            //Produto Origem
										aadd(_aItem,SB1->B1_DESC)            //Descricao Origem
										aadd(_aItem,SB1->B1_UM)  	         //UM Origem
										aadd(_aItem,XD1->XD1_LOCAL)          //Local Origem
										aadd(_aItem,XD1->XD1_LOCALIZ)		 //Endereco Origem
										aadd(_aItem,XD1->XD1_COD)            //Produto Destino
										aadd(_aItem,SB1->B1_DESC)            //Descricao Destino
										aadd(_aItem,SB1->B1_UM)  	         //UM destino
										aadd(_aItem,cLocTransf)              //Local Destino
										aadd(_aItem,cEndProDom)	         	 //Endereco Destino
										aadd(_aItem,"")                      //Numero Serie Destino
										aadd(_aItem,XD1->XD1_LOTECTL)	     //Lote Origem
										aadd(_aItem,"")         	         //Sub Lote Origem
										aadd(_aItem,StoD("20491231"))	     //Validade Lote Origem
										aadd(_aItem,0)		                 //Potencia
										aadd(_aItem,_nQtdOP)            	 //Quantidade
										aadd(_aItem,0)		                 //Quantidade 2a. unidade
										aadd(_aItem,"")   	                 //ESTORNO
										aadd(_aItem,"")         	         //NUMSEQ
										aadd(_aItem,U_RETLOTC6(SD4->D4_OP))  //Lote Destino
										aadd(_aItem,StoD("20491231"))	     //Validade Lote Destino
										aadd(_aItem,"")		                 //D3_ITEMGRD
										If nFCICalc == 1
											aadd(_aItem,0)                   //D3_PERIMP
										ENDIF
										If GetVersao(.F.,.F.) == "12"
											//aAdd(_aItem,"")   //D3_IDDCF
											aAdd(_aItem,"")   //D3_OBSERVACAO                                                                     l
										EndIf
										aadd(_aAuto,_aItem)

										lMsErroAuto := .F.


										PRIVATE cCusMed   := GetMv("MV_CUSMED")
										PRIVATE cCadastro := "Transferencias"
										PRIVATE aRegSD3	:= {}
										PRIVATE nPerImp   := CriaVar("D3_PERIMP")
										//ConOut("Antes do a260Processa" + Time())
										a260Processa(XD1->XD1_COD,XD1->XD1_LOCAL,_nQtdOP,_cDoc,dDataBase,0,,XD1->XD1_LOTECTL,StoD("20491231"),,XD1->XD1_LOCALIZ,XD1->XD1_COD,cLocTransf,cEndProDom,.F.,Nil,Nil,"MATA260",,,,,,,,,,,,,,,,,U_RETLOTC6(SD4->D4_OP),StoD("20491231"))
										//ConOut("Depois do a260Processa" + Time())

										If lMsErroAuto .and. .F.
											//MostraErro("\UTIL\LOG\Transferencia_Pagamento\error_log_pagamento_op_data_"+DtoS(Date())+"_hora_"+ Time()+ "_op_" + SD4->D4_OP +".TXT")
											//DisarmTransaction()
											If U_uMsgYesNo("Erro no pagamento (tranferÍncia) para o "+cLocTransf+". Deseja mostrar o erro?")
												MostraErro()
											Else
												MostraErro("\UTIL\LOG\Transferencia_Pagamento\")
											EndIf
										Else
											SD3->( dbSetOrder(2) )  // D3_FILIAL + D3_DOC
											If SD3->( dbSeek( xFilial() + _cDoc ) )
												While !SD3->( EOF() ) .and. ALLTRIM(SD3->D3_DOC) == ALLTRIM(_cDoc)    //MLS ALTERADO MOTIVO DOCUMENTO COM 9 DIGITOS
													If SD3->D3_CF == 'RE4' .or. SD3->D3_CF == 'DE4'
														If SD3->D3_COD == XD1->XD1_COD
															If SD3->D3_EMISSAO == dDataBase
																If SD3->D3_QUANT == _nQtdOP
																	If Empty(SD3->D3_XXOP)
																		Reclock("SD3",.F.)
																		SD3->D3_XXPECA  := XD1->XD1_XXPECA
																		SD3->D3_XXOP    := SD4->D4_OP
																		SD3->D3_USUARIO := cUsuario
																		SD3->D3_HORA    := Time()
																		SD3->( msUnlock() )
																	EndIf
																EndIf
															EndIf
														EndIf
													EndIf
													SD3->( dbSkip() )
												End

												Reclock("XD1",.F.)
												XD1->XD1_QTDATU := XD1->XD1_QTDATU - _nQtdOP
												nSaldoSD4       := nSaldoSD4 - _nQtdOP

												If XD1->XD1_QTDATU <= 0
													XD1->XD1_OCORRE := '5'
													aEtqLidas[nK][2] := 0
												EndIf

												XD1->( msUnlock() )

												nQTransfOk += _nQtdOP
												aEtqLidas[nK][2] := aEtqLidas[nK][2] - _nQtdOP
												//Se j· pagou tudo dessa OP  vai para o proxima OP.
												If  nQTransfOk == aOpsApagar[nR][2] //.Or. nQEtqLidas == nK
													//Se finalizou a TransferÍncia das quantidades da OP Imprime Etiqueta
													nQtdOpsPgs ++
													//Zerar quantidade no Array para n„o imprimir etiqueta em branco ou pagar novamente com valor zerado
													lImprime := .T.
													If aOpsApagar[nR][2] > 0 .And. lImprime
														U_EtPgOP39(_cNumOP,XD1->XD1_COD,SB1->B1_DESC,nQTransfOk,.f./*lparcial*/,nR,Len(aOpsApagar),_cFilialOP)
														lSilk	  := (SB1->B1_XSILK=="S") //Verfica se È Silk


														//Se o produto for silk imprime etiqueta do PN
														If lSilk
															aAreaSb1A := SB1->(GetArea())
															aAreaSC2A := SC2->(GetArea())

															cPnOpSilk := Alltrim(Posicione("SC2",1,SD4->D4_FILIAL + SD4->D4_OP,"C2_PRODUTO"))
															cDescSilk := Alltrim(Posicione("SB1",1,XFILIAL("SB1") + cPnOpSilk,"B1_DESC"))

															U_EtqPSilk(_cNumOP,cPnOpSilk,cDescSilk,nQTransfOk,.f./*lparcial*/,SD4->D4_FILIAL)

															RestArea(aAreaSC2A)
															RestArea(aAreaSb1A)
														EndIf
													EndIf

													aOpsApagar[nR][2] := 0
													if aEtqLidas[nK][2] <= 0
														aEtqLidas[nK][2] := 0
														//Else
														//	aEtqLidas[nK][2] := aEtqLidas[nK][2] - nQTransfOk
													EndIf
													//Exit
												else
													//aOpsApagar[nR][2] -= nQTransfOk
													//aEtqLidas[nK][2] -= nQTransfOk
													Loop
												EndIf
											Else
												If lMsErroAuto
													If U_uMsgYesNo("Erro no pagamento (tranferÍncia) para o "+cLocTransf+". Deseja mostrar o erro?")
														MostraErro()
													Else
														MostraErro("\UTIL\LOG\Transferencia_Pagamento\")
													EndIf
												Else
													U_MsgColetor("Erro no pagamento (tranferÍncia) para o "+cLocTransf+". Deseja mostrar o erro?")
												EndIf
											EndIf
										EndIf
									EndIf
								EndIf
							EndIf
						Else
							U_MsgColetor('N„o foi encontrado empenho deste produto ' + XD1->XD1_COD + ' para esta OP.' + _cNumOP )
							_Retorno := .F.
						EndIf						
					EndIf
				Next nK
			Next nR
			//ApÛs finalizar todas as tranferÍcia do Produto Emite alerta das quantidades de Ops a pagar e Ops Pagas

			U_MsgColetor("TransferÍncia realizada com sucesso," + ENTER + " Qtd.Ops.‡ Pagar : " + STRZERO(Len(aOpsApagar),3) + ENTER + " Qtd.Ops Transferidas " + STRZERO(nQtdOpsPgs,3),3)
			//Determina quais OPs n„o foram Pagas.
			aOpsNaoPgs := {}
			For nR:=1 To Len(aOpsApagar)
				If aOpsApagar[nR][2] > 0
					AaDd(aOpsNaoPgs ,{aOpsApagar[nR][1],aOpsApagar[nR][2]})
				EndIf
			Next
			If Len(aOpsNaoPgs) > 0
				cTxtMsg  := " Os Ops abaixo n„o foram transferidos por falta de saldo no estque:" + Chr(13)
				For nP := 1 To Len(aOpsNaoPgs)
					SC2->(DbSetOrder(1))
					SC2->(DbSeek(xFilial("SC2") + aOpsNaoPgs[nP][1]))
					cTxtMsg  += " OP: " + aOpsNaoPgs[nP][1] + Chr(13)
					cTxtMsg  += " Produto : " + SC2->C2_PRODUTO + Chr(13)
					cTxtMsg  += " DescriÁ„o : " + POSICIONE("SB1",1,XFILIAL("SB1") + SC2->C2_PRODUTO, "B1_DESC")  + Chr(13)
					cTXTMsg  += " Quantidade: " + Transform(aOpsNaoPgs[nP][2],"@E 999,999,999.999")
				Next nP
				cAssunto := "Pagamento de OP por PickList - N„o Transferidos"
				cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
				cPara    := 'jackson.santos@opusvp.com.br'
				cCC      := ''//'natalia.silva@rosenbergerdomex.com.br;keila.gamt@rosenbergerdomex.com.br;leonardo.andrade@rosenbergerdomex.com.br;gabriel.cenato@rosenbergerdomex.com.br' //chamado monique 015475
				cArquivo := Nil
				U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
			EndIf
			oTelaOP:End()
		else
			///U_MsgColetor("Saldo em estoque menor que a quantidade empenhada." + ENTER + "N√O SER¡ POSSIVEL REALIZAR A TRANSFER NCIA")
			//Continua Lendo AtÈ atingir a quantidade necess·ria.
			_nQtd := 0
			_nQtdOP := 0
			_cEtiqueta     := Space(_nTamEtiq)
			oGetEtiq:Refresh()
			oGetEtiq:SetFocus()
		EndIf

	Else
		_nQtd := 0
		_nQtdOP := 0
		_cEtiqueta     := Space(_nTamEtiq)
		oGetEtiq:Refresh()
		oGetEtiq:SetFocus()
	EndIf
//ConOut("Fim do ValidaOp DOMACD05 " + Time())
Return _Retorno

User Function RetQry39(cTipoCon,cGrupoProd,dData,cCodProdut,cNumOpCon,__cFilial)
	Local cRet := ""
	Default cTipoCon := '1' //1-Produto,2-OP's
	Default cNumOpCon := ""
	//If (Upper(GetEnvServ()) == 'HOMOLOGACAO') .OR. .T.

	If cTipoCon == '1'
		cRet :=         " SELECT EMPOP.*,ISNULL(SB2.B2_QATU,0) QTDEST , ISNULL(B2_RESERVA + B2_QEMP + B2_QEMPSA,0) RESERVAS FROM ( "
		cRet += ENTER + " SELECT D4FILIAL,ENDERECO,D4_COD,B1_DESC,B1_TIPO,B1_UM,B1_LOCPAD,SUM(QTDORI) QTDORI,SUM( QTDEMP) QTDEMP,SUM(SUM_D3QTD) SUM_D3QTD FROM ("
		cRet += ENTER + " SELECT D4_FILIAL D4FILIAL,TMPBF.BF_LOCALIZ ENDERECO,D4_COD,D4_OP,D4_LOCAL,SUM(D4_QTDEORI) QTDORI,SUM(D4_QUANT) QTDEMP,"
		cRet += ENTER + " SUM_D3QTD = ISNULL((SELECT SUM(CASE WHEN D3_CF='RE4' THEN -D3_QUANT ELSE +D3_QUANT END) FROM " + RetSqlName("SD3") + " SD3 (NOLOCK) "
		cRet += ENTER + " 									WHERE D3_XXOP    = D4_OP "
		cRet += ENTER + " 									AND   D3_COD     = D4_COD "
		cRet += ENTER + " 									AND   D3_LOCAL   = '"+cLocTransf+"' "
		cRet += ENTER + " 									AND   D3_ESTORNO = '' "
		cRet += ENTER + " 									AND   D3_CF      IN ('DE4','RE4') "
		cRet += ENTER + " 									AND   D3_FILIAL  =  '"+xFilial("SD3")+"' "
		cRet += ENTER + " 									AND   D4_FILIAL  =  '"+__cFilial+"' "
		cRet += ENTER + " 									AND   SD3.D_E_L_E_T_ = ''  ),0) "
		cRet += ENTER + " FROM " + RetSqlName("SD4") + " SD4 "
		cRet += ENTER + " JOIN(  "
		cRet += ENTER + " 	SELECT C2_FILIAL,C2_NUM+C2_ITEM+C2_SEQUEN OP FROM " + RetSqlName("SC2") + " SC2 (NOLOCK) "
		cRet += ENTER + " 	JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ ='' AND SB1.R_E_C_D_E_L_ = 0 AND SB1.B1_FILIAL ='" + xFilial("SB1") + "' AND SB1.B1_COD = SC2.C2_PRODUTO "
		cRet += ENTER + " 	WHERE SC2.D_E_L_E_T_ = '' AND SC2.R_E_C_D_E_L_= 0 AND SC2.C2_FILIAL = '"+__cFilial+"' "
		If (Upper(GetEnvServ()) == 'VALIDACAO')
		   cRet += ENTER + " 	 AND SC2.C2_XBLQCQ NOT IN ('S','W') "
		EndIf
		cRet += ENTER + " 	 AND SC2.C2_XXDTPRO =  '" + DTOS(dData) + "' "
		cRet += ENTER + " 	 AND SC2.C2_DATRF ='' "
		cRet += ENTER + " 	 AND CASE WHEN SB1.B1_GRUPO = 'DIOE' THEN 'DIO' WHEN SB1.B1_GRUPO  = 'TRUE' THEN 'TRUN' ELSE SB1.B1_GRUPO END = '" +  cGrupoProd + "' "
		//cRet += ENTER + " 	 AND SB1.B1_GRUPO = '" +  cGrupoProd + "' "
		cRet += ENTER + "	 AND (LEFT(SB1.B1_COD,3) <> 'DMS'  OR (LEFT(SB1.B1_COD,3) = 'DMS' AND SC2.C2_SEQUEN = '001')) "
		cRet += ENTER + " 	 GROUP BY C2_FILIAL,C2_NUM+C2_ITEM+C2_SEQUEN "
		cRet += ENTER + " 	 ) SC2T ON SC2T.OP = SD4.D4_OP  AND SC2T.C2_FILIAL = SD4.D4_FILIAL"
		cRet += ENTER + " JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = '' AND SB1.R_E_C_D_E_L_= 0 AND SB1.B1_FILIAL ='" + xFilial("SB1") + "' AND SB1.B1_COD  = SD4.D4_COD "
		cRet += ENTER + " LEFT JOIN ( "
		cRet += ENTER + " 	SELECT BF_FILIAL,BF_PRODUTO,MIN(BF_LOCALIZ)BF_LOCALIZ,BF_LOCAL,MAX(BF_QUANT) QTD "
		cRet += ENTER + " 	FROM " + RetSqlName("SBF") + " SBF WHERE SBF.BF_FILIAL = '"+xFilial("SBF")+"' "
		cRet += ENTER + " 	GROUP BY BF_FILIAL,BF_PRODUTO,BF_LOCAL "
		cRet += ENTER + "  	) TMPBF ON TMPBF.BF_PRODUTO = SD4.D4_COD AND SB1.B1_LOCPAD = TMPBF.BF_LOCAL "
		cRet += ENTER + "      AND TMPBF.BF_FILIAL = '"+xFilial("SBF")+"' "
		cRet += ENTER + "      AND SD4.D4_FILIAL   = '"+__cFilial+"' "
		cRet += ENTER + " WHERE SD4.D_E_L_E_T_ ='' AND SD4.R_E_C_D_E_L_ = 0 AND SD4.D4_QUANT > 0 AND SD4.D4_XPKLIST <> 'N' "
		cRet += ENTER + " AND SD4.D4_FILIAL = '"+__cFilial+"' AND SD4.D4_LOCAL = '" + cLocProcDom + "' AND SD4.D4_OPORIG = '' "
		cRet += ENTER + " AND SB1.B1_TIPO NOT IN ('MO','PA') AND LEFT(SB1.B1_COD,3) <> 'DMS' AND SB1.B1_GRUPO NOT IN ('FO','FOFS')  "
		cRet += ENTER + " GROUP BY D4_FILIAL,TMPBF.BF_LOCALIZ,D4_COD,D4_OP,D4_LOCAL "
		cRet += ENTER + " ) TMP01 "
		cRet += ENTER + " JOIN " + RetSQlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = '' AND SB1.R_E_C_D_E_L_= 0 AND SB1.B1_FILIAL ='" + xFilial("SB1") + "' AND SB1.B1_COD  = TMP01.D4_COD "
		cRet += ENTER + " GROUP BY D4FILIAL,ENDERECO,D4_COD,B1_DESC,B1_TIPO,B1_UM,B1_LOCPAD "
		cRet += ENTER + " ) EMPOP  "
		cRet += ENTER + " JOIN " + RetSqlName("SB2") + " SB2 ON SB2.D_E_L_E_T_ = '' AND SB2.R_E_C_D_E_L_= 0 AND SB2.B2_FILIAL = '" + xFilial("SB2") + "' "
		cRet += ENTER + " AND EMPOP.D4FILIAL = '"+__cFilial+"' AND EMPOP.D4_COD = SB2.B2_COD AND (SB2.B2_LOCAL  =EMPOP.B1_LOCPAD OR SB2.B2_LOCAL = '21' OR SB2.B2_LOCAL = '17' OR SB2.B2_LOCAL = '02') "
		cRet += ENTER + " WHERE EMPOP.SUM_D3QTD < EMPOP.QTDORI "
		cRet += ENTER + " ORDER BY EMPOP.D4FILIAL,EMPOP.ENDERECO,EMPOP.QTDEMP DESC"
	ENDIF
	If cTipoCon == '2' .Or. cTipoCon == "3"
		cRet := ENTER + " SELECT D4_FILIAL D4FILIAL,TMPBF.BF_LOCALIZ ENDERECO,D4_COD,D4_OP,D4_LOCAL,SC2T.JAIMPRESSA,SUM(D4_QTDEORI) QTDORI,SUM(D4_QUANT) QTDEMP,SD4.R_E_C_N_O_ RECNOSD4,"
		cRet += ENTER + " SUM_D3QTD = ISNULL((SELECT SUM(CASE WHEN D3_CF='RE4' THEN -D3_QUANT ELSE +D3_QUANT END) FROM " + RetSqlName("SD3") + " SD3 (NOLOCK) "
		cRet += ENTER + " 									WHERE D3_XXOP    = D4_OP "
		cRet += ENTER + " 									AND   D3_COD     = D4_COD "
		cRet += ENTER + " 									AND   D3_LOCAL   = '"+cLocTransf+"' "
		cRet += ENTER + " 									AND   D3_ESTORNO = '' "
		cRet += ENTER + " 									AND   D3_CF      IN ('DE4','RE4') "
		cRet += ENTER + " 									AND   D3_FILIAL  =  '"+xFilial("SD3")+"' "
		cRet += ENTER + " 									AND   D4_FILIAL  =  '"+__cFilial+"' "
		cRet += ENTER + " 									AND   SD3.D_E_L_E_T_ = ''  ),0) "
		cRet += ENTER + " FROM " + RetSqlName("SD4") + " SD4 "
		cRet += ENTER + " JOIN(  "
		cRet += ENTER + " 	SELECT C2_FILIAL,C2_NUM+C2_ITEM+C2_SEQUEN OP,C2_XETQIMP JAIMPRESSA FROM " + RetSqlName("SC2") + " SC2 (NOLOCK) "
		cRet += ENTER + " 	JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ ='' AND SB1.R_E_C_D_E_L_ = 0 AND SB1.B1_FILIAL ='" + xFilial("SB1") + "' AND SB1.B1_COD = SC2.C2_PRODUTO "
		cRet += ENTER + " 	WHERE SC2.D_E_L_E_T_ = '' AND SC2.R_E_C_D_E_L_= 0 AND SC2.C2_FILIAL = '"+__cFilial+"' "
		//cRet += ENTER + " 	 AND SC2.C2_XXDTPRO >=  '20200301' AND SC2.C2_XXDTPRO <=  '" + DTOS(dData) + "' "
		cRet += ENTER + " 	 AND SC2.C2_XXDTPRO =  '" + DTOS(dData) + "' "
		cRet += ENTER + " 	 AND SC2.C2_DATRF ='' "
		If Empty(cCodProdut) .And. cTipoCon <> "3"
			cRet += ENTER + " 	 AND SC2.C2_XETQIMP <> 'S' "
		EndiF
		cRet += ENTER + " 	 AND CASE WHEN SB1.B1_GRUPO = 'DIOE' THEN 'DIO' WHEN SB1.B1_GRUPO  = 'TRUE' THEN 'TRUN' ELSE SB1.B1_GRUPO END = '" +  cGrupoProd + "' "
		//cRet += ENTER + " 	 AND SB1.B1_GRUPO = '" +  cGrupoProd + "' "
		cRet += ENTER + "	 AND (LEFT(SB1.B1_COD,3) <> 'DMS'  OR (LEFT(SB1.B1_COD,3) = 'DMS' AND SC2.C2_SEQUEN = '001')) "
		cRet += ENTER + " 	 GROUP BY C2_FILIAL,C2_NUM+C2_ITEM+C2_SEQUEN,C2_XETQIMP "
		cRet += ENTER + " 	 ) SC2T ON SC2T.OP = SD4.D4_OP AND SC2T.C2_FILIAL = SD4.D4_FILIAL "
		cRet += ENTER + " JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = '' AND SB1.R_E_C_D_E_L_= 0 AND SB1.B1_FILIAL ='" + xFilial("SB1") + "' AND SB1.B1_COD  = SD4.D4_COD "
		cRet += ENTER + " LEFT JOIN ( "
		cRet += ENTER + " 	SELECT BF_FILIAL,BF_PRODUTO,MIN(BF_LOCALIZ)BF_LOCALIZ,BF_LOCAL,MAX(BF_QUANT) QTD "
		cRet += ENTER + " 	FROM " + RetSqlName("SBF") + " SBF WHERE SBF.BF_FILIAL = '"+xFilial("SBF")+"' "
		cRet += ENTER + " 	GROUP BY BF_FILIAL,BF_PRODUTO,BF_LOCAL "
		cRet += ENTER + "  	) TMPBF ON TMPBF.BF_PRODUTO = SD4.D4_COD AND SB1.B1_LOCPAD = TMPBF.BF_LOCAL "
		cRet += ENTER + "      AND TMPBF.BF_FILIAL = '"+xFilial("SBF")+"' "
		cRet += ENTER + "      AND SD4.D4_FILIAL   = '"+__cFilial+"' "
		cRet += ENTER + " WHERE SD4.D_E_L_E_T_ ='' AND SD4.R_E_C_D_E_L_ = 0 AND SD4.D4_QUANT > 0 AND SD4.D4_XPKLIST <> 'N' "
		cRet += ENTER + " AND SD4.D4_FILIAL = '"+__cFilial+"' AND SD4.D4_OPORIG = '' "
		cRet += ENTER + " AND SB1.B1_TIPO NOT IN ('MO','PA') AND LEFT(SB1.B1_COD,3) <> 'DMS' AND SB1.B1_GRUPO NOT IN ('FO','FOFS') "
		If !Empty(cCodProdut)
			cRet += ENTER + " AND SB1.B1_COD = '" +  cCodProdut + "' "
		EndIf
		cRet += ENTER + " AND SD4.D4_LOCAL = '" + cLocProcDom + "' "
		cRet += ENTER + " GROUP BY D4_FILIAL,TMPBF.BF_LOCALIZ,D4_COD,D4_OP,D4_LOCAL,SC2T.JAIMPRESSA,SD4.R_E_C_N_O_ "
	EndIf
	//Else
	//	If cTipoCon == '1'
	//		cRet :=         " SELECT EMPOP.*,ISNULL(SB2.B2_QATU,0) QTDEST , ISNULL(B2_RESERVA + B2_QEMP + B2_QEMPSA,0) RESERVAS FROM ( "
	//		cRet += ENTER + " SELECT ENDERECO,D4_COD,B1_DESC,B1_TIPO,B1_UM,B1_LOCPAD,SUM(QTDORI) QTDORI,SUM( QTDEMP) QTDEMP,SUM(SUM_D3QTD) SUM_D3QTD FROM ("
	//		cRet += ENTER + " SELECT D4_FILIAL,TMPBF.BF_LOCALIZ ENDERECO,D4_COD,D4_OP,D4_LOCAL,SUM(D4_QTDEORI) QTDORI,SUM(D4_QUANT) QTDEMP,"
	//		cRet += ENTER + " SUM_D3QTD = ISNULL((SELECT SUM(CASE WHEN D3_CF='RE4' THEN -D3_QUANT ELSE +D3_QUANT END) FROM " + RetSqlName("SD3") + " SD3 (NOLOCK) "
	//		cRet += ENTER + " 									WHERE D3_XXOP    = D4_OP "
	//		cRet += ENTER + " 									AND   D3_COD     = D4_COD "
	//		cRet += ENTER + " 									AND   D3_LOCAL   = '"+cLocTransf+"' "
	//		cRet += ENTER + " 									AND   D3_ESTORNO = '' "
	//		cRet += ENTER + " 									AND   D3_CF      IN ('DE4','RE4') "
	//		cRet += ENTER + " 									AND   D3_FILIAL  =  '"+xFilial("SD3")+"' "
	//		cRet += ENTER + " 									AND   D4_FILIAL  =  '"+__cFilial+"' "
	//		cRet += ENTER + " 									AND   SD3.D_E_L_E_T_ = ''  ),0) "
	//		cRet += ENTER + " FROM " + RetSqlName("SD4") + " SD4 "
	//		cRet += ENTER + " JOIN(  "
	//		cRet += ENTER + " 	SELECT C2_NUM+C2_ITEM+C2_SEQUEN OP FROM " + RetSqlName("SC2") + " SC2 (NOLOCK) "
	//		cRet += ENTER + " 	JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ ='' AND SB1.R_E_C_D_E_L_ = 0 AND SB1.B1_FILIAL ='" + xFilial("SB1") + "' AND SB1.B1_COD = SC2.C2_PRODUTO "
	//		cRet += ENTER + " 	WHERE SC2.D_E_L_E_T_ = '' AND SC2.R_E_C_D_E_L_= 0 AND SC2.C2_FILIAL = '" + xFilial("SC2") + "' "
	//		//cRet += ENTER + " 	 AND SC2.C2_XXDTPRO >=  '20200301' AND SC2.C2_XXDTPRO <=  '" + DTOS(dData) + "' "
	//		cRet += ENTER + " 	 AND SC2.C2_XXDTPRO =  '" + DTOS(dData) + "'  "
	//		If !Empty(cNumOpCon)
	//			cRet += ENTER + " 	 AND SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN  =  '" + cNumOpCon + "'  "
	//		EndIf
	//		cRet += ENTER + " 	 AND SC2.C2_DATRF ='' "
	//		cRet += ENTER + " 	 AND CASE WHEN SB1.B1_GRUPO = 'DIOE' THEN 'DIO' WHEN SB1.B1_GRUPO  = 'TRUE' THEN 'TRUN' ELSE SB1.B1_GRUPO END = '" +  cGrupoProd + "' "
	//		//cRet += ENTER + " 	 AND SB1.B1_GRUPO = '" +  cGrupoProd + "' "
	//		cRet += ENTER + "	 AND (LEFT(SB1.B1_COD,3) <> 'DMS'  OR (LEFT(SB1.B1_COD,3) = 'DMS' AND SC2.C2_SEQUEN = '001')) "
	//		cRet += ENTER + " 	 GROUP BY C2_NUM+C2_ITEM+C2_SEQUEN "
	//		cRet += ENTER + " 	 ) SC2T ON SC2T.OP = SD4.D4_OP "
	//		cRet += ENTER + " JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = '' AND SB1.R_E_C_D_E_L_= 0 AND SB1.B1_FILIAL ='" + xFilial("SB1") + "' AND SB1.B1_COD  = SD4.D4_COD "
	//		cRet += ENTER + " JOIN ( "
	//		cRet += ENTER + " 	SELECT BF_PRODUTO,MIN(BF_LOCALIZ)BF_LOCALIZ,BF_LOCAL,MAX(BF_QUANT) QTD "
	//		cRet += ENTER + " 	FROM " + RetSqlName("SBF") + " SBF WHERE SBF.BF_FILIAL = '01' "
	//		cRet += ENTER + " 	GROUP BY BF_PRODUTO,BF_LOCAL "
	//		cRet += ENTER + "  	) TMPBF ON TMPBF.BF_PRODUTO = SD4.D4_COD AND SB1.B1_LOCPAD = TMPBF.BF_LOCAL "
	//		cRet += ENTER + " WHERE SD4.D_E_L_E_T_ ='' AND SD4.R_E_C_D_E_L_ = 0 AND SD4.D4_QUANT > 0 AND SD4.D4_XPKLIST <> 'N' "
	//		cRet += ENTER + " AND SD4.D4_FILIAL  ='" + xFilial("SD4") + "' AND SD4.D4_LOCAL = '" + cLocProcDom + "' AND SD4.D4_OPORIG = '' "
	//		cRet += ENTER + " AND SB1.B1_TIPO NOT IN ('MO','PA') AND LEFT(SB1.B1_COD,3) <> 'DMS' AND SB1.B1_GRUPO NOT IN ('FO','FOFS')  "
	//		cRet += ENTER + " GROUP BY D4_FILIAL,TMPBF.BF_LOCALIZ,D4_COD,D4_OP,D4_LOCAL "
	//		cRet += ENTER + " ) TMP01 "
	//		cRet += ENTER + " JOIN " + RetSQlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = '' AND SB1.R_E_C_D_E_L_= 0 AND SB1.B1_FILIAL ='" + xFilial("SB1") + "' AND SB1.B1_COD  = TMP01.D4_COD "
	//		cRet += ENTER + " GROUP BY ENDERECO,D4_COD,B1_DESC,B1_TIPO,B1_UM,B1_LOCPAD "
	//		cRet += ENTER + " ) EMPOP  "
	//		cRet += ENTER + " JOIN " + RetSqlName("SB2") + " SB2 ON SB2.D_E_L_E_T_ = '' AND SB2.R_E_C_D_E_L_= 0 AND SB2.B2_FILIAL = '" + xFilial("SB2") + "' AND EMPOP.D4_COD = SB2.B2_COD AND (SB2.B2_LOCAL  =EMPOP.B1_LOCPAD OR SB2.B2_LOCAL = '21' OR SB2.B2_LOCAL = '17' OR SB2.B2_LOCAL = '02') "
	//		cRet += ENTER + " WHERE EMPOP.SUM_D3QTD < EMPOP.QTDORI "
	//		cRet += ENTER + " ORDER BY EMPOP.ENDERECO,EMPOP.QTDEMP DESC"
	//	ENDIF
	//	If cTipoCon == '2' .Or. cTipoCon == "3"
	//		cRet := ENTER + " SELECT D4_FILIAL,TMPBF.BF_LOCALIZ ENDERECO,D4_COD,D4_OP,D4_LOCAL,SC2T.JAIMPRESSA,SUM(D4_QTDEORI) QTDORI,SUM(D4_QUANT) QTDEMP,SD4.R_E_C_N_O_ RECNOSD4,"
	//		cRet += ENTER + " SUM_D3QTD = ISNULL((SELECT SUM(CASE WHEN D3_CF='RE4' THEN -D3_QUANT ELSE +D3_QUANT END) FROM " + RetSqlName("SD3") + " SD3 (NOLOCK) "
	//		cRet += ENTER + " 									WHERE D3_XXOP    = D4_OP "
	//		cRet += ENTER + " 									AND   D3_COD     = D4_COD "
	//		cRet += ENTER + " 									AND   D3_LOCAL   = '"+cLocTransf+"' "
	//		cRet += ENTER + " 									AND   D3_ESTORNO = '' "
	//		cRet += ENTER + " 									AND   D3_CF      IN ('DE4','RE4') "
	//		cRet += ENTER + " 									AND   D3_FILIAL  =  '"+xFilial("SD3")+"' "
	//		cRet += ENTER + " 									AND   D4_FILIAL  =  '"+__cFilial+"' "
	//		cRet += ENTER + " 									AND   SD3.D_E_L_E_T_ = ''  ),0) "
	//		cRet += ENTER + " FROM " + RetSqlName("SD4") + " SD4 "
	//		cRet += ENTER + " JOIN(  "
	//		cRet += ENTER + " 	SELECT C2_NUM+C2_ITEM+C2_SEQUEN OP,C2_XETQIMP JAIMPRESSA FROM " + RetSqlName("SC2") + " SC2 (NOLOCK) "
	//		cRet += ENTER + " 	JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ ='' AND SB1.R_E_C_D_E_L_ = 0 AND SB1.B1_FILIAL ='" + xFilial("SB1") + "' AND SB1.B1_COD = SC2.C2_PRODUTO "
	//		cRet += ENTER + " 	WHERE SC2.D_E_L_E_T_ = '' AND SC2.R_E_C_D_E_L_= 0 AND SC2.C2_FILIAL = '" + xFilial("SC2") + "' "
	//		//cRet += ENTER + " 	 AND SC2.C2_XXDTPRO >=  '20200301' AND SC2.C2_XXDTPRO <=  '" + DTOS(dData) + "' "
	//		cRet += ENTER + " 	 AND SC2.C2_XXDTPRO =  '" + DTOS(dData) + "' "
	//		cRet += ENTER + " 	 AND SC2.C2_DATRF ='' "
	//		If Empty(cCodProdut) .And. cTipoCon <> "3"
	//			cRet += ENTER + " 	 AND SC2.C2_XETQIMP <> 'S' "
	//		EndiF
	//		cRet += ENTER + " 	 AND CASE WHEN SB1.B1_GRUPO = 'DIOE' THEN 'DIO' WHEN SB1.B1_GRUPO  = 'TRUE' THEN 'TRUN' ELSE SB1.B1_GRUPO END = '" +  cGrupoProd + "' "
	//		//cRet += ENTER + " 	 AND SB1.B1_GRUPO = '" +  cGrupoProd + "' "
	//		cRet += ENTER + "	 AND (LEFT(SB1.B1_COD,3) <> 'DMS'  OR (LEFT(SB1.B1_COD,3) = 'DMS' AND SC2.C2_SEQUEN = '001')) "
	//		cRet += ENTER + " 	 GROUP BY C2_NUM+C2_ITEM+C2_SEQUEN,C2_XETQIMP "
	//		cRet += ENTER + " 	 ) SC2T ON SC2T.OP = SD4.D4_OP "
	//		cRet += ENTER + " JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = '' AND SB1.R_E_C_D_E_L_= 0 AND SB1.B1_FILIAL ='" + xFilial("SB1") + "' AND SB1.B1_COD  = SD4.D4_COD "
	//		cRet += ENTER + " JOIN ( "
	//		cRet += ENTER + " 	SELECT BF_PRODUTO,MIN(BF_LOCALIZ)BF_LOCALIZ,BF_LOCAL,MAX(BF_QUANT) QTD "
	//		cRet += ENTER + " 	FROM " + RetSqlName("SBF") + " SBF WHERE SBF.BF_FILIAL = '01' "
	//		cRet += ENTER + " 	GROUP BY BF_PRODUTO,BF_LOCAL "
	//		cRet += ENTER + "  	) TMPBF ON TMPBF.BF_PRODUTO = SD4.D4_COD AND SB1.B1_LOCPAD = TMPBF.BF_LOCAL "
	//		cRet += ENTER + " WHERE SD4.D_E_L_E_T_ ='' AND SD4.R_E_C_D_E_L_ = 0 AND SD4.D4_QUANT > 0 AND SD4.D4_XPKLIST <> 'N' "
	//		cRet += ENTER + " AND SD4.D4_FILIAL  ='" + xFilial("SD4") + "' AND SD4.D4_OPORIG = '' "
	//		cRet += ENTER + " AND SB1.B1_TIPO NOT IN ('MO','PA') AND LEFT(SB1.B1_COD,3) <> 'DMS' AND SB1.B1_GRUPO NOT IN ('FO','FOFS') "
	//		If !Empty(cCodProdut)
	//			cRet += ENTER + " AND SB1.B1_COD = '" +  cCodProdut + "' "
	//		EndIf
	//		cRet += ENTER + " AND SD4.D4_LOCAL = '" + cLocProcDom + "' "
	//		cRet += ENTER + " GROUP BY D4_FILIAL,TMPBF.BF_LOCALIZ,D4_COD,D4_OP,D4_LOCAL,SC2T.JAIMPRESSA,SD4.R_E_C_N_O_ "
	//		//cRet += ENTER + " ORDER BY D4_FILIAL,TMPBF.BF_LOCALIZ "
	//	EndIf
	//EndIf
Return cRet

// Impress„o etiqueta Produto
User Function EtPgOP39(cNumOp,cCodProd,cDescProd,nQtdProd,lParcial,nSeqEtq,nQtdTotEtq,cFilialOP)
	Local _cPorta    := "LPT1"
	Local _aAreaGER  := GetArea()
    /* GravaÁ„o do XD1 comenantada atÈ finalizar os testes*/
	Local _cProxPeca := U_IXD1PECA()



	Reclock("XD1",.T.)
	XD1->XD1_FILIAL  :=  xFilial("XD1")
	XD1->XD1_XXPECA  := _cProxPeca
	XD1->XD1_FORNEC  := Space(06)
	XD1->XD1_LOJA    := Space(02)
	XD1->XD1_DOC     := Space(06)
	XD1->XD1_SERIE   := Space(03)
	XD1->XD1_ITEM    := StrZero(Recno(),4)
	XD1->XD1_COD     := cCodProd
	XD1->XD1_LOCAL   := cLocTransf
	XD1->XD1_TIPO    := Posicione("SB1",1,xFilial("SB1")+cCodProd,"B1_TIPO")
	XD1->XD1_LOTECT  := U_RETLOTC6(cNumOp)
	XD1->XD1_DTDIGI  := dDataBase
	XD1->XD1_FORMUL  := ""
	XD1->XD1_LOCALI  := cEndProDom
	XD1->XD1_USERID  := __cUserId

	If cFilialOP == '01'
		XD1->XD1_OCORRE := "8"  // Status 8 È o Status de etiqueta de material para recebimento na tela de Roteiro
	EndIf

	If cFilialOP == '02'
		XD1->XD1_OCORRE := "4"
	EndIf

	XD1->XD1_QTDORI  := nQtdProd
	XD1->XD1_QTDATU  := nQtdProd
	XD1->XD1_OP      := cNumOp
	XD1->( MsUnlock() )


	MSCBPrinter("TLP 2844",_cPorta,,,.F.)
	MSCBBegin(1,6)
	MSCBSay(28,01,"Produto: "+cCodProd + " - " + Alltrim(Str(nSeqEtq)) + "/" + Alltrim(Str(nQtdTotEtq)),"N","2","1,1")
	MSCBSay(28,05,"Descr:"+cDescProd,"N","2","1,1")
	//      C  L
	MSCBSay(28,18," QTD: "                           ,"N","2","1,1")
	MSCBSay(35,18,Transform(nQtdProd,"@E 9999.99"),"N","4","1,1")

	MSCBSay(50,18,"OP: " + cNumOp     ,"N","2","1,1")

	// Fil: 02
	MSCBSay(50,21,"Fil:"            ,"N","2","1,1")
	MSCBSay(60,21,cFilialOP ,"N","4","1,1")

	If lParcial
		MSCBSay(28,19,"PAGAMENTO PARCIAL","N","2","1,1")
	EndIf

	MSCBSayBar(30,09,AllTrim(XD1->XD1_XXPECA),"N","MB04",6.36,.F.,.T.,.F.,,3,Nil,Nil,Nil,Nil,Nil)

	MSCBEnd()
	MSCBClosePrinter()
	RestArea(_aAreaGER)

Return




User Function EtqNOP39(cNumOp,cCodProd,cDescProd,cFilialOP)
	Local _cPorta    := "LPT1"
	Local _aAreaGER  := GetArea()

	MSCBPrinter("TLP 2844",_cPorta,,,.F.)
	MSCBBegin(1,6)

	MSCBSay(30,1,"OP: " + cNumOp                         ,"N","4","1,1")

	// Produto + Filial : 02
	MSCBSay(28,05,"Produto:"+cCodProd + '   Fil:' ,"N","2","1,1")
	MSCBSay(70,04,cFilialOP                       ,"N","4","1,1")

	//MSCBSay(46,18,"Descr: "+cDescProd,"N","2","1,1")

	MSCBSayBar(28,09,cNumOp,"N","MB07",10 ,.F.,.T.,.F.,,2,1  ,Nil,Nil,Nil,Nil)

	MSCBEnd()
	MSCBClosePrinter()
	//Alimenta Flag deimpress„o
	DbSelectArea("SC2")
	SC2->(DbSetOrder(1))
	If SC2->(DbSeek(cFilialOP + Alltrim(cNumOp)))
		Reclock("SC2",.f.)
		SC2->C2_XETQIMP := "S"
		SC2->(MsUnlock())
	EndIf
	RestArea(_aAreaGER)
Return


User Function EtqPSilk(cNumOp,cCodProd,cDescProd,nQtdProd,lParcial,cFilialOP)
	Local _cPorta    := "LPT1"
	Local _aAreaGER  := GetArea()

	MSCBPrinter("TLP 2844",_cPorta,,,.F.)
	MSCBBegin(1,6)
	MSCBSay(28,01,"SILK","N","2","1,1")
	MSCBSay(50,01,"OP: "+cNumOp        ,"N","2","1,1")
	//MSCBSay(50,01,"Fil.:" + cFilialOP  ,"N","2","1,1")
	MSCBSay(28,04,"Produto: "+cCodProd ,"N","2","1,1")
	MSCBSay(28,08,"Descr:"+cDescProd   ,"N","2","1,1")
	//      C  L
	//MSCBSay(35,18,Transform(nQtdProd,"@E 9,999"),"N","4","1,1")
	MSCBSayBar(37,12,AllTrim(cCodProd),"N","MB07",6.36,.F.,.T.,.F.,,0.5,Nil,Nil,Nil,Nil,Nil)

	MSCBEnd()
	MSCBClosePrinter()
	RestArea(_aAreaGER)

Return


//--------------------------------------------------------------------
/*
Static Function ValidaOP(_cNumOP)
	Local _lRet :=.T.
	_cProdEmp   := ""
	_cDescric   := ""
	_cEnderec   := ""
	_nQtdEmp    := 0
	_aDados     := {}

	If Empty(_cNumOP)
		Return .T.
	EndIf

	SC2->( dbSetOrder(1) )
	SB1->( dbSetOrder(1) )
	SBF->( dbSetOrder(2) )

	If SC2->(dbSeek(xFilial("SC2")+_cNumOP))
		If SC2->C2_QUANT <> SC2->C2_QUJE .or. (dDataBase <= CtoD("12/02/2016") .and. Empty(SC2->C2_DATRF))
			If SC2->C2_QUANT == SC2->C2_QUJE
				U_MsgColetor("Denis, campo C2_DATRF: " + DtoC(SC2->C2_DATRF))
			EndIf
			SD4->(dbSetOrder(2))
			If SD4->(dbSeek(xFilial("SD4")+_cNumOP))
				While xFilial("SD4")+_cNumOP == SD4->D4_FILIAL+SD4->D4_OP
					If SD4->D4_LOCAL == cLocProcDom .and. Empty(SD4->D4_OPORIG)
						If SB1->( dbSeek( xFilial() + SD4->D4_COD ) )

							SD3->(DbOrderNickName("USUSD30001"))  // D3_FILIAL + D3_XXOP + D3_COD   tratado
							SUMD3QTD := 0

							If SD3->( dbSeek( xFilial() + SD4->D4_OP + SD4->D4_COD ) )
								While !SD3->( EOF() ) .and. SD4->D4_OP + SD4->D4_COD == SD3->D3_XXOP + SD3->D3_COD  // tratado
									If Empty(SD3->D3_ESTORNO) .and. SD3->D3_LOCAL == cLocProcDom
										If SD3->D3_CF == 'DE4'
											SUMD3QTD += SD3->D3_QUANT
										EndIf
										If SD3->D3_CF == 'RE4'
											SUMD3QTD -= SD3->D3_QUANT
										EndIf
									EndIf
									SD3->( dbSkip() )
								End
							EndIf

							If (SD4->D4_QUANT - SUMD3QTD) > 0
								If SBF->(dbSeek(xFilial("SBF")+SD4->D4_COD+SB1->B1_LOCPAD))
									While !SBF->( EOF() ) .and. SD4->D4_COD+SB1->B1_LOCPAD == SBF->BF_PRODUTO+SBF->BF_LOCAL
										If SD4->D4_QUANT > 0
											aadd(_aDados,{SB1->B1_COD,SB1->B1_DESC,SBF->BF_LOCALIZ,SD4->D4_QUANT})
										EndIf
										SBF->( dbSkip() )
									End
								EndIf
								//EndIf
							EndIf
						EndIf
					EndIf
					SD4->(dbSkip())
				End
			EndIf
		Else
			U_MsgColetor("OP j· encerrada.")
			_lRet:=.F.
		EndIf
	Else
		U_MsgColetor("OP n„o encontrada.")
		_lRet:=.F.
	EndIf

	aSort (_aDados,,,{|x, y| x[2] < y[2]} )

	If Empty(_cNumOP)
		_lRet := .T.
	EndIf

	_cProdEmp   := "OP'S PAGAS"
	_cDescric   := "Todos os empenhos foram atendidos."
	_cEnderec   := ""
	_nQtdEmp    := 0

	If Len(_aDados)> 0
		_cProdEmp   := _aDados[1][1]
		_cDescric   := _aDados[1][2]
		_cEnderec   := _aDados[1][3]
		_nQtdEmp    := _aDados[1][4]
	Else
		SZD->( dbSetOrder(1) )  //
		If SZD->( dbSeek( xFilial() + Subs(_cNumOP,1,11) ) )
			nTemp := 0
			While !SZD->( EOF() ) .and. Subs(SZD->ZD_OP,1,11) == Subs(_cNumOP,1,11)
				nTemp += SZD->ZD_QTDPG
				SZD->( dbSkip() )
			End
			U_MsgColetor("Ordem de ProduÁ„o j· atendida. Foi emitida etiqueta de Comprovante de Pagamento para produÁ„o de " + Alltrim(Transform(nTemp,"@E 999,999,999.9999"))+".")
		Else
			U_MsgColetor("Ordem de ProduÁ„o j· atendida. Etiqueta de Comprovante de Pagamento N√O impressa.")
		EndIf
	EndIf

	//oTelaOP:Refresh()

Return(_lRet)
*/
