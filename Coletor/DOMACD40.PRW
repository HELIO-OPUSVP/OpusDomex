#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Rwmake.ch"
#include "Topconn.ch"
#include "Protheus.ch"

#DEFINE ENTER CHAR(13) + CHAR(10)
/*

Re-Impres.Etq.PickList

*/
User Function DOMACD40
    Local lRet      := .T.
	Local nLin     	:= 010	
	Local cCSSBtN1 	:= ""	
	Private dData  	:= DDataBase + 1
    Private cCodProd := SPACE(15)	
	Private oTxt1
	Private oTxt2F
	Private oTxt3
	Private oTxt31
	Private oTxt4
	Private oTxt5
	Private oData    
	Private oDlg0
	Private oDlg1
	Private oDlg2
	Private oDlgT
	Private oDlgOp
	Private oDlgOp1

	Private cEtiqueta := SPACE(100)
	Private oEtiqueta
	Private oGetDados
	Private aHeader 	:= {}
	Private aCols		:= {}
	Private oFontNW
	Private aGruposPrd 	:= {}
	Private cGruposPrd 	:= ""
	Private nQtdSldEnd	:= 0
	Private cLocProcDom    	:= GetMV("MV_XXLOCPR")
	Private cLocTransf  := If(xFilial("SC2")=='01',GetMV("MV_XXLOCPR"),GetMV("MV_XLOCTRA"))
	Private cEndProDom	:= If(xFilial("SC2")=='01',"97PROCESSO"       ,"95TRANSFERENCIA"  )

	DEFINE FONT oFontNW  NAME "Arial" SIZE 0,-15 BOLD

	DEFINE MSDIALOG oDlg0 TITLE OemToAnsi("Reimpressão Etiquetas Picklist") FROM 0,0 TO 293,233 PIXEL OF oMainWnd
	nLin += 25
    @ nLin ,  010 BUTTON oBotao1 PROMPT "Etiqueta da OP"    ACTION Processa( {|| ReImpEtqOPs() } ) SIZE 95,16 PIXEL OF oDlg0
    nLin += 25
    @ nLin ,  010 BUTTON oBotao2 PROMPT "Etiqueta Produto"  ACTION Processa( {|| ReImpEtqPrd() } ) SIZE 95,16 PIXEL OF oDlg0
	
	cCSSBtN1 := "QPushButton{font: bold 10px Arial;background-repeat: none; }"+;
							"QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }"
	oBotao1:SetCSS( cCSSBtN1 )
    oBotao2:SetCSS( cCSSBtN1 )

	nLin += 50
    @ nLin,010 BUTTON oBotao3 PROMPT  "Sair" Size 95,16 Action Close(oDlg0) Pixel
    

	ACTIVATE MSDIALOG oDlg0

Return lRet

Static Function ReImpEtqOps()
	Local lRet := .T.
    Local nCol1 	:= 005
	Local nCol2 	:= 015
	Local nLin 	 	:= 010
	Local nP		:= 0
	Local nSkipLin 	:= 17
	Local nLargBut 	:= 90
	Local nAltuBut 	:= 16
	Local cQryGrps 	:= ""
			

   	DEFINE MSDIALOG oDlg1 TITLE OemToAnsi("Data-Pagto OP por Picklist") FROM 0,0 TO 293,233 PIXEL OF oMainWnd

	nLin += 10

	@ nLin  ,nCol2	SAY oTxt1 Var   'Data:'  SIZE 25,20 PIXEL OF oMainWnd
	@ nLin-10, nCol2 + 020  MSGET oData    VAR dData    Picture "@D"  SIZE 50,20 PIXEL OF oDlg1

	nLin += 50
	@ nLin , nCol1 + 005 BUTTON oBotao1 PROMPT "-1"     ACTION Processa( {|| Botao(1) } ) SIZE 40,30 PIXEL OF oDlg1
	@ nLin , nCol1 + 065 BUTTON oBotao2 PROMPT "+1"     ACTION Processa( {|| Botao(2) } ) SIZE 40,30 PIXEL OF oDlg1


	@ 131,040 Button oBotao3 PROMPT "Ok" Size 40,13 Action Close(oDlg1) Pixel
	
	cCSSBtN1 := "QPushButton{font: bold 10px Arial;background-repeat: none; }"+;
							"QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }"
	
	oBotao1:SetCSS( cCSSBtN1 )
	oBotao2:SetCSS( cCSSBtN1 )
	oBotao3:SetCSS( cCSSBtN1 )


	
	//@ nLin,040 Button "Sair" Size 55,13 Action Close(oDlg0) Pixel

	ACTIVATE MSDIALOG oDlg1

	
	//Selecionar os grupos em utilização pelas OP'
	cQryGrps := " SELECT CASE WHEN B1_GRUPO = 'DIOE' THEN 'DIO' WHEN B1_GRUPO  = 'TRUE' THEN 'TRUN' ELSE B1_GRUPO END CODGRUPO,COUNT(*) QTD "
	cQryGrps += ENTER + " FROM " + RetSqlName("SC2") + " SC2 "
	cQryGrps += ENTER + " JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = '' AND SB1.R_E_C_D_E_L_= 0 AND SB1.B1_FILIAL ='" +  xFilial("SB1") +  "' AND SB1.B1_COD  = SC2.C2_PRODUTO AND C2_PEDIDO <> '' "
	cQryGrps += ENTER + " WHERE SC2.D_E_L_E_T_ ='' AND SC2.C2_FILIAL = '" + xFilial("SC2") + "' "
	cQryGrps += ENTER + " AND SC2.C2_XXDTPRO =  '" + DTOS(dData) + "' "
	cQryGrps += ENTER + " GROUP BY CASE WHEN B1_GRUPO = 'DIOE' THEN 'DIO' WHEN B1_GRUPO  = 'TRUE' THEN 'TRUN' ELSE B1_GRUPO END "
	cQryGrps += ENTER + " ORDER BY QTD DESC "
	If Select("TMPGRP") > 0
		TMPGRP->(DbCloseArea())
	EndIf
	TCQUERY cQryGrps NEW ALIAS "TMPGRP"
	If !TMPGRP->(EOF())
		While !TMPGRP->(EOF())
		   Aadd(aGruposPrd,Alltrim(TMPGRP->CODGRUPO))
			TMPGRP->(DbSkip())
		EndDo
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

	@ 00,00 SCROLLBOX oScroll1 VERTICAL BORDER SIZE 133,118 PIXEL OF oDlgT

	@ nLin  ,nCol2	SAY oTxt2 Var   'Data: '  + DTOC(dData) SIZE 50,15 PIXEL OF oScroll1

	nLin += 13

	cCSSBtN1 := "QPushButton{font: bold 10px Arial;background-image: url(rpo:pcoimg32.png);background-repeat: none; }"+;
		"QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }"

	For nP := 1 To Len(aGruposPrd)
		@ nLin, 05 BUTTON &("oBtng" + Strzero(nP,2)) PROMPT aGruposPrd[nP]     ACTION Processa( {||   BuscaEmpOp() /*U_DOMACD39()*/} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll1
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

Static Function BuscaEmpOp()
	Local lRet 			:= .T.
	Local nP	  		:= 0
	Local nSkipLin 	:= 17
	Local nLargBut 	:= 95
	Local nAltuBut 	:= 16	
	Local cGrupoProd 	:= ""
	Local aImpEtq := {}
	//Busca o grupo que está sendo processado para selecionar as OP's
	For nP := 1 To Len(aGruposPrd)
		If &("oBtng" + Strzero(nP,2)):LPROCESSING //Indica qual botão está sendo executado
			cGrupoProd := Alltrim(aGruposPrd[nP])
		Endif
	Next nP

	If !Empty(Alltrim(cGrupoProd))

		//Imprimir Todas as Etiquetas para o dia
		//U_RetQry39 - parametro 1 = 1-Produtos,2=Ops,3=Reimpressão
		cQryOps := U_RetQry39("3"/*cTipoCon*/,cGrupoProd,dData,"","",xfilial("SC2"))
		If Select("TMPOPS") > 0
			TMPOPS->(DbCloseArea())
		Endif
		TCQUERY cQryOps NEW ALIAS "TMPOPS"	
		If TMPOPS->(!EOF())
			
			lImprimeETq :=.T.
			
			//Prepara impressão das etiquetas			
			cCodOpAtu := ""
			While TMPOPS->(!EOF())			
				If lImprimeETq
					if Alltrim(cCodOpAtu) <>  Alltrim(TMPOPS->D4_OP)
						cCodOpAtu := TMPOPS->D4_OP
						cCodProdOp := Alltrim(Posicione("SC2",1,XFILIAL("SC2") + TMPOPS->D4_OP,"C2_PRODUTO"))
						AaDd(aImpEtq,{TMPOPS->D4_OP,cCodProdOp,Alltrim(Posicione("SB1",1,xFilial("SB1") + cCodProdOp,"B1_DESC"))})
					Endif				
				EndIf			
				TMPOPS->(DbSkip())
			EndDo			
		EndIf
		TMPOPS->(DbCloseArea())
		
		//Gera Informações das OP's para selecionar a re-impressão.
		cOpsAImpr := ""
		For nP:=1 To  Len(aImpEtq)
			If nP <= 99
				cOpsAImpr  += IIF(nP==Len(aImpEtq),"oBtnOp" + StrZero(nP,2), "oBtnOp" + StrZero(nP,2) + ",")
			else
				cOpsAImpr  += IIF(nP==Len(aImpEtq),"oBtnOp" + StrZero(nP,3), "oBtnOp" + StrZero(nP,3) + ",")
			EndIf

		Next nP

		SetPrvt(cOpsAImpr)



		//Tela para selecionar o grupo que deseja separar
		//Reinicializa nLin para montagem da outra tela
		nLin := 005
		nCol2 := 015
		DEFINE MSDIALOG oDlgOP TITLE OemToAnsi("OP's a re-imprimir") FROM 0,0 TO  293,233 PIXEL OF oMainWnd

		@ 01,01 SCROLLBOX oScroll2 VERTICAL BORDER SIZE 133,118 PIXEL OF oDlgOP
		
		@ nLin  ,nCol2	SAY oTxt2 Var   'Data: '  + DTOC(dData) SIZE 50,15 PIXEL OF oScroll2
		nLin += 13

		cCSSBtN1 := "QPushButton{font: bold 10px Arial;background-image: url(rpo:pcoimg32.png);background-repeat: none; }"+;
			"QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }"
		For nP := 1 To Len(aImpEtq)
			if np <= 99
				@ nLin, 10 BUTTON &("oBtnOp" + Strzero(nP,2)) PROMPT aImpEtq[nP][1]     ACTION Processa( {||   ImpETQOP(aImpEtq) /*U_DOMACD39()*/} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll2
				&("oBtnOp" + Strzero(nP,2)):SetCSS( cCSSBtN1 )
				nLin += nSkipLin
			else
				@ nLin, 10 BUTTON &("oBtnOp" + Strzero(nP,3)) PROMPT aImpEtq[nP][1]     ACTION Processa( {||   ImpETQOP(aImpEtq) /*U_DOMACD39()*/} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll2
				&("oBtnOp" + Strzero(nP,3)):SetCSS( cCSSBtN1 )
				nLin += nSkipLin	
			EndiF
		Next nP
	 	
		//@ 131,008 Button "Ok" Size 40,13 Action Close(oDlg1) Pixel

		@ 135,040 Button oBotao2 PROMPT "Sair" Size 50,13 Action Close(oDlgOP) Pixel

		cCSSBtN1 := "QPushButton{font: bold 10px Arial;background-repeat: none; }"+;
					"QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }"
		
		oBotao2:SetCSS( cCSSBtN1 )
		ACTIVATE MSDIALOG oDlgOP
	EndIf	
Return lRet 

Static Function ImpEtqOP(aImpEtq)
	Local lRet := .T.
	Local nP := 0
	//Busca o grupo que está sendo processado para selecionar as OP's
	For nP := 1 To Len(aImpEtq)
		If nP <= 99
			If &("oBtnOp" + Strzero(nP,2)):LPROCESSING //Indica qual botão está sendo executado
				U_EtqNOP39(aImpEtq[nP][1],aImpEtq[nP][2],aImpEtq[nP][3],xFilial("SC2"))
			Endif
		else
			If &("oBtnOp" + Strzero(nP,3)):LPROCESSING //Indica qual botão está sendo executado
				U_EtqNOP39(aImpEtq[nP][1],aImpEtq[nP][2],aImpEtq[nP][3],xFilial("SC2"))
			Endif
		EndIf
	Next nP
Return lRet

Static Function ReImpEtqPrd()
    Local nCol1 	:= 005
	Local nCol2 	:= 015
	Local nLin     	:= 010
	Local cCSSBtN1 	:= ""
	Local lRet := .T.

    DEFINE MSDIALOG oDlg1 TITLE OemToAnsi("Reimpressão Etiqueta Produto") FROM 0,0 TO 293,233 PIXEL OF oMainWnd

    nLin += 10

    @ nLin  ,nCol2	SAY oTxt1 Var   'Data:'  SIZE 25,20 PIXEL OF oDlg1
    @ nLin-10, nCol2 + 020  MSGET oData    VAR dData    Picture "@D"  SIZE 50,20 PIXEL OF oDlg1

    nLin += 40

    @ nLin  ,nCol2	SAY oTxt2 Var   'Etiqueta:'  SIZE 25,20 PIXEL OF oDlg1
    @ nLin-10, nCol2 + 020  MSGET oEtiqueta    VAR cEtiqueta    Picture "@E"  SIZE 50,20 PIXEL OF oDlg1

    nLin += 40
    lOkImrpiss := .F.
    @ nLin , nCol1 + 005 BUTTON oBotao1 PROMPT "-1 Dia"     ACTION Processa( {|| Botao(1) } ) SIZE 40,30 PIXEL OF oDlg1
    @ nLin , nCol1 + 065 BUTTON oBotao2 PROMPT "+1 Dia"     ACTION Processa( {|| Botao(2) } ) SIZE 40,30 PIXEL OF oDlg1


    @ 131,040 Button oBotao3 PROMPT "Ok" Size 40,13 Action Processa( {|| lOkImrpiss := ReimprEtq(),Close(oDlg0)  } ) Pixel OF oDlg1
    
    cCSSBtN1 := "QPushButton{font: bold 10px Arial;background-repeat: none; }"+;
                            "QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }"
    
    oBotao1:SetCSS( cCSSBtN1 )
    oBotao2:SetCSS( cCSSBtN1 )
    oBotao3:SetCSS( cCSSBtN1 )



//@ nLin,040 Button "Sair" Size 55,13 Action Close(oDlg0) Pixel

ACTIVATE MSDIALOG oDlg1




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


Static Function ReimprEtq()
Local cQrySD3 := ""
Local lRet    := .T.

If Len(AllTrim(cEtiqueta))==12 //EAN 13 s/ dígito verificador.
	cEtiqueta := "0"+cEtiqueta
	cEtiqueta := Subs(cEtiqueta,1,12)
EndIf

If Len(AllTrim(cEtiqueta))==20 //CODE 128 c/ dígito verificador.
	cEtiqueta := Subs(AllTrim(cEtiqueta),8,12)
EndIf
oEtiqueta:Refresh()

XD1->( dbSetOrder(1) )
If XD1->( dbSeek( xFilial("XD1") + cEtiqueta ) )		
	cQrySD3 := " SELECT D3_COD,D3_XXOP,SUM(D3_QUANT) D3_QUANT,B1_DESC"
	cQrySD3 += ENTER + " FROM " + RetSqlName("SD3") + " SD3 (NOLOCK) "
	cQrySD3 += ENTER + " JOIN " + RetSqlName("SB1") + " SB1 (NOLOCK) ON SB1.D_E_L_E_T_ ='' AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.B1_COD = SD3.D3_COD "
	cQrySD3 += ENTER + " JOIN " + RetSqlName("SC2") + " SC2 (NOLOCK) ON SC2.D_E_L_E_T_ ='' AND SC2.C2_FILIAL = SD3.D3_FILIAL AND SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN = D3_XXOP AND C2_XXDTPRO = '" + DTOS(dData) + "' " 
	cQrySD3 += ENTER + " WHERE SD3.D_E_L_E_T_ ='' AND D3_FILIAL = '" + xFilial("SD3") + "' AND  D3_XXOP <> ''  AND D3_CF = 'DE4'  "
	cQrySD3 += ENTER + " AND D3_TM = '499' "
	cQrySD3 += ENTER + " AND D3_ESTORNO = '' "  
	cQrySD3 += ENTER + " AND D3_LOCAL= '" + Alltrim(cLocProcDom) + "' "
	cQrySD3 += ENTER + " AND D3_COD = '" + Alltrim(XD1->XD1_COD) + "' "
	cQrySD3 += ENTER + " GROUP BY  D3_COD,D3_XXOP,B1_DESC
	//cQrySD3 += ENTER + " AND D3_EMISSAO = '" +  DTOS(DDATABASE) + "' "

	If Select("TMPD3") >0 
		TMPD3->(DbCloseArea())
	EndIf		
	TCQUERY cQrySD3 NEW ALIAS "TMPD3"
	lImprime := .T.
	nTotReg := 0
	nCont := 0
	If TMPD3->(!Eof())
		
		While TMPD3->(!EOF())
			nTotReg ++
			TMPD3->(DbSkip())
		EndDo
		
		TMPD3->(DbGoTop())

		While TMPD3->(!EOF())
			nCont ++
			IncProc("Reimprimindo Etiqueta do Produto")	
			
			IF lImprime 
				cEtqGerada:= U_EtPgOP39(TMPD3->D3_XXOP,TMPD3->D3_COD,TMPD3->B1_DESC,TMPD3->D3_QUANT,.F.,nCont,nTotReg,xFilial("SC2"),.T.)
				If !Empty(Alltrim(cEtqGerada))
					//Ajustar a etiqueta do Movimento e cancelar a eiqueta anterior
					cQryXD1 := " SELECT XD1_XXPECA  "
					cQryXD1 += " FROM XD1010 XD1 "
					cQryXD1 += " WHERE XD1.D_E_L_E_T_ ='' AND XD1_FILIAL = '" + xFilial("XD1") + "' "
					cQryXD1 += " AND XD1_COD ='" + TMPD3->D3_COD  + "' "
					cQryXD1 += " AND XD1_OP = '" + TMPD3->D3_XXOP + "' "
					cQryXD1 += " AND XD1_QTDATU =" + Alltrim(Str(TMPD3->D3_QUANT)) + " AND XD1_LOCAL = '97' "
					cQryXD1 += " AND XD1_XXPECA <'" + Alltrim(cEtqGerada) + "' AND XD1_OCORRE <> '5' AND XD1_OCORRE = '8' "							
					If Select("TBXD1") > 0
						TBXD1->(DbCloseArea())
					EndIf
					TCQUERY cQryXD1 NEW ALIAS "TBXD1"					
					IF TBXD1->(!EOF())
						XD1->(DbGoTop())
						If XD1->( dbSeek( xFilial("XD1") + TBXD1->XD1_XXPECA  ) )	
							RecLock("XD1",.F.)
								XD1->XD1_OCORRE := "5" // Cancela a Etiqueta
							XD1->(MsUnlock())
						Endif				
					EndIf
					If Select("TBXD1") > 0
						TBXD1->(DbCloseArea())
					EndIf
 					/*
					 TMPD3->(DbGoTo(TMPD3->RECSD3))
					If Alltrim(TMPD3->D3_XXOP) == Alltrim(SD3->D3_XXOP)
						RecLock("SD3",.F.)
							SD3->D3_XXPECA := cEtqGerada
						SD3->(MsUnLock())
					EndIf*/
				EndIf
			Endif
			TMPD3->(DbSkip())
		EndDo
	else
		U_MsgColetor("Não foi encontrado transferência para esse produto : " + XD1->XD1_COD)	
	Endif
	TMPD3->(DbCloseArea())
else
	//Etiqueta não encontrada
	U_MsgColetor("Etiqueta não encontrada : " + cEtiqueta)
	lRet := .F.
EndIf

Return lRet
