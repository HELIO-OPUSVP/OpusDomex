#include "rwmake.ch"
#include "totvs.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO5     ºAutor  ³Microsiga           º Data ³  10/16/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                            '                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EtiqPagam(cOPParam,lSInterfac,_nQtdPg)

Private nLargBut    := 60
Private nAltuBut    := 13
Private cOP         := If(cOPParam == 'SZD' .or. cOPParam==Nil,Space(12),Subs(cOPParam,1,11))
Private nQtd        := 0
Private lWhenGetOP  := If(cOPParam == 'SZD',.T.,.F.)
Private cLocProcDom := GetMV("MV_XXLOCPR")
Default lSInterfac := .F.
Default _nQtdPg := 0

If !Empty(cOP)
	aAreaSC2 := SC2->( GetArea() )
	SC2->( dbSetOrder(1) )
	If SC2->( dbSeek( xFilial() + cOP ) )
		nQtd := SC2->C2_QUANT
	EndIf
	RestArea(aAreaSC2)
EndIf
If !lSInterfac
	DEFINE MSDIALOG oDlg TITLE "Comprovante de pagamento de OP " FROM 0,0 To 293,233 PIXEL of oMainWnd PIXEL

	nLin := 15
	@ nLin, 020	SAY oTexto1 Var 'Ordem de Produção:'    SIZE 130,10 PIXEL
	oTexto1:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

	nLin += 15
	@ nLin, 020 MSGET oOP VAR cOP  Picture "@!"  SIZE 85,12 Valid ValidaOP() WHEN lWhenGetOP PIXEL
	oOP:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)

	nLin += 40
	@ nLin, 020	SAY oTexto2 Var 'Quantidade:'    SIZE 130,10 PIXEL
	oTexto2:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)  //  TFont():New('Arial',,25,,.T.,,,,.T.,.F.)

	nLin += 15
	@ nLin, 020 MSGET oQtd VAR nQtd  Picture "@E 999,999"  SIZE 85,12 Valid ValidaQtd() PIXEL
	oQtd:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)


	//@ nLin, 055 COMBOBOX oCombo1  VAR cUsuario ITEMS aUsuarios    SIZE 45,10 VALID .T. PIXEL
	//oCombo1:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

	nLin += 25
	@ nLin, 140 BUTTON "Sair" ACTION Processa( {|| oDlg:End() } ) SIZE nLargBut,nAltuBut PIXEL OF oDlg

	ACTIVATE MSDIALOG oDlg  // ON INIT EnchoiceBar( oDlgMenu01,{|| nOpca := 0,oDlgMenu01:End()},{|| nOpca := 0,oDlgMenu01:End()} ) //CENTER
else
	nQtd := _nQtdPg
	ValidaQtd()
ENDIF

Return

Static Function ValidaOP()
Local _Retorno := .F.
SC2->( dbSetOrder(1) )

If !Empty(cOP)
	If SC2->( dbSeek( xFilial() + Subs(cOP,1,11) ) )
		If Empty(SC2->C2_DATRF)
			_Retorno := .T.
			nQtd     := SC2->C2_QUANT
		Else
			U_MsgColetor("Ordem de Produção encerrada.")
		EndIf
	Else
		U_MsgColetor("Ordem de Produção não encontrada.")
	EndIf
Else
	_Retorno := .T.
EndIf

Return _Retorno


Static Function ValidaQtd()
Local _Retorno := .T.

SC2->( dbSetOrder(1) )

If !Empty(nQtd)
	If !Empty(cOP)
		cNumOP := Subs(cOP,1,11)
		If SC2->( dbSeek( xFilial() + cNumOP ) )
			If Empty(SC2->C2_DATRF)
				//cRaizOP := Subs(cOP,1,6)
				//If SC2->( dbSeek( xFilial() + cOP ) )
				//While !SC2->( EOF() ) .and. SC2->C2_NUM == cRaizOP
				cNumOPSC2 := Subs(SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN,1,11)
				
				// Calculando o total já apontado para esta OP
				SD3->( dbSetOrder(1) )
				
				//nTotApto := 0
				//If SD3->( dbSeek( xFilial() + cNumOPSC2 ) )
				//	While !SD3->( EOF() ) .and. SD3->D3_OP == cNumOPSC2
				//		If SD3->D3_ESTORNO == '' .and. (SD3->D3_CF == 'PR0' .OR. SD3->D3_CF == 'PR1')
				//			nTotApto += SD3->D3_QUANT
				//		EndIf
				//		SD3->( dbSkip() )
				//	End
				//EndIf
				
				SD4->( dbSetOrder(2) )
				SB1->( dbSetOrder(1) )
				If SD4->( dbSeek( xFilial() + cNumOPSC2 ) )
					
					While !SD4->( EOF() ) .and. Subs(SD4->D4_OP,1,11) == cNumOPSC2 .and. _Retorno
						If SD4->D4_LOCAL <> GetMv("MV_LOCPROC") .and. SD4->D4_LOCAL <> "96"
							If SB1->( dbSeek( xFilial() + SD4->D4_COD	) )
								If SB1->B1_TIPO <> 'MO' .and. Alltrim(SB1->B1_GRUPO) <> 'FO' .and. Alltrim(SB1->B1_GRUPO) <> 'FOFS'
									// Validando se o produto não é de uma OP filha
									cOPProdPI      := SD4->D4_OPORIG
									//bProdPI      := .F.
									//aAreaSC2Temp := SC2->( GetArea() )
									//cRaizOP      := SC2->C2_NUM
									//SC2->( dbSeek( xFilial() + cRaizOP ) )
									//While !SC2->( EOF() ) .and. SC2->C2_NUM == cRaizOP
									//	If SC2->C2_PRODUTO == SD4->D4_COD
									//		bProdPI := .T.
									//		Exit
									//	EndIf
									//	SC2->( dbSkip() )
									//End
									//RestArea(aAreaSC2Temp)
									
									If Empty(cOPProdPI)
										SZD->( dbSetOrder(1) )
										nQtdSZD := 0
										If SZD->( dbSeek( xFilial() + Subs(SD4->D4_OP,1,11) ) )
											While !SZD->( EOF() ) .and. SZD->ZD_OP == Subs(SD4->D4_OP,1,11)
												nQtdSZD += SZD->ZD_QTDPG
												SZD->( dbSkip() )
											End
										EndIf
										
										If nQtdSZD == SC2->C2_QUANT
											U_MsgColetor("Etiqueta(s) para o total da OP já emitida(s).")
											_Retorno := .F.
											
											SZD->( dbSetOrder(1) )
											If SZD->( dbSeek( xFilial() + Subs(SD4->D4_OP,1,11) ) )
												While !SZD->( EOF() ) .and. SZD->ZD_OP == Subs(SD4->D4_OP,1,11)
													U_MsgColetor("Já foi emitida a etiqueta numero " + SZD->ZD_CODIGO + " com quantidade " + Alltrim(Transform(SZD->ZD_QTDPG,"@E 999,999")) + " para esta OP.")
													SZD->( dbSkip() )
												End
											EndIf
										Else
											If nQtdSZD > SC2->C2_QUANT
												U_MsgColetor("Erro. Quantidade de etiqueta emitida maior que o total da OP.")
											EndIf
											
											//SD3->(DbOrderNickName("USUSD30001"))  // D3_FILIAL + D3_XXOP + D3_COD   tratado
											//SUMD3QTD1 := 0
											
											//If SD3->( dbSeek( xFilial() + SD4->D4_OP + SD4->D4_COD ) )
											//	  While !SD3->( EOF() ) .and. SD4->D4_OP + SD4->D4_COD == SD3->D3_XXOP + SD3->D3_COD  // tratado
											//		  If Empty(SD3->D3_ESTORNO) .and. SD3->D3_LOCAL == cLocProcDom
											//			If SD3->D3_CF == 'DE4'
											//				SUMD3QTD1 += SD3->D3_QUANT
											//			EndIf
											//			If SD3->D3_CF == 'RE4'
											//				SUMD3QTD1 -= SD3->D3_QUANT
											//			EndIf
											//		EndIf
											//		SD3->( dbSkip() )
											//	  End
											//EndIf
											
											cQuery := " SELECT SUM(CASE WHEN D3_TM > '500' THEN -D3_QUANT ELSE +D3_QUANT END) AS D3PAGOP "
											cQuery += " FROM SD3010 SD3                                                                  "
											cQuery += "	WHERE D3_FILIAL = '01'                                                           "
											cQuery += " AND   D3_XXOP    = '"+SD4->D4_OP+"'                                              "
											cQuery += "	AND   D3_COD     = '"+SD4->D4_COD+"'                                             "
											cQuery += " AND   D3_LOCAL   = '"+cLocProcDom+"'                                             "
											cQuery += "	AND   (D3_CF      IN ('DE4','RE4') OR D3_DOC = 'INVENT')                         " //<-------
											cQuery += "	AND   D3_ESTORNO = ''                                                            "
											cQuery += "	AND   D_E_L_E_T_ = ''                                                            "
											
											If Select("QSD3") <> 0
												QSD3->( dbCloseArea() )
											EndIf
											
											TCQUERY cQuery NEW ALIAS "QSD3"
											
											SUMD3QTD1 := QSD3->D3PAGOP
											
											nTotNecessidade   := (nQtd + nQtdSZD) * (SD4->D4_QTDEORI / SC2->C2_QUANT)
											ntotPago          := SUMD3QTD1
											If nTotNecessidade > ntotPago
												U_MsgColetor("Emissão da etiqueta não permitida." + Chr(13) + "O Produto " + Alltrim(SD4->D4_COD) + " teve "+Alltrim(Transform(ntotPago,"@E 999,999,999.9999"))+" pago para esta OP e sua necessidade é de " + Alltrim(Transform(nTotNecessidade,"@E 999,999,999.9999")) + "." )
												
												SZD->( dbSetOrder(1) )
												If SZD->( dbSeek( xFilial() + Subs(SD4->D4_OP,1,11) ) )
													While !SZD->( EOF() ) .and. SZD->ZD_OP == Subs(SD4->D4_OP,1,11)
														U_MsgColetor("Já foi emitida a etiqueta numero " + SZD->ZD_CODIGO + " com quantidade " + Alltrim(Transform(SZD->ZD_QTDPG,"@E 999,999")) + " para esta OP.")
														SZD->( dbSkip() )
													End
												EndIf
												
												_Retorno := .F.
											EndIf
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
						SD4->( dbSkip() )
					End
				Else
					U_MsgColetor("Não foram encontrados empenhos para a OP: " + cNumOPSC2 )
				EndIf
				//	SC2->( dbSkip() )
				//End
				//EndIf
			Else
				U_MsgColetor("Ordem de Produção encerrada.")
			EndIf
		Else
			U_MsgColetor("Ordem de Produção não encontrada.")
		EndIf
	Else
		_Retorno := .T.
	EndIf
	
	If _Retorno
		cQuery := "SELECT MAX(ZD_CODIGO) AS ZD_CODIGO FROM " + RetSqlName("SZD") + " WHERE D_E_L_E_T_ = '' "
		If Select("TEMP") <> 0
			TEMP->( dbCloseArea() )
		EndIf
		TCQUERY cQuery NEW ALIAS "TEMP"
		
		Reclock("SZD",.T.)
		SZD->ZD_FILIAL  := xFilial("SZD")
		SZD->ZD_CODIGO  := StrZero(Val(TEMP->ZD_CODIGO)+1,6)
		SZD->ZD_OP      := cOP
		SZD->ZD_QTDPG   := nQtd
		SZD->ZD_USUARIO := If(lWhenGetOP,Subs(cUsuario,7,15),cUsuario)
		SZD->ZD_DATA    := Date()
		SZD->ZD_HORA    := Time()
		SZD->( msUnlock() )
		
		If Subs(cUsuario,7,5) == 'HELIO'
			If MsgYesNo("Imprimir a etiqueta?")
				//U_EtiqPGOP()
				If !lWhenGetOP
					U_MsgColetor(/*"Etiqueta Impressa."*/ "Pagamento Finalizado")
				EndIf
			EndIf
		Else
			//U_EtiqPGOP()
			If !lWhenGetOP
				U_MsgColetor(/*"Etiqueta Impressa."*/ "Pagamento Finalizado")
			EndIf
		EndIf
	EndIf
EndIf

If !lWhenGetOP
	oDlg:End()
Else
	cOP         := Space(12)
	nQtd        := 0
	oOP:SetFocus()
EndIf

Return .T.


User Function EtiqPGOP()
Local _cPorta    := "LPT1"
Local _aAreaGER  := GetArea()

MSCBPrinter("TLP 2844",_cPorta,,,.F.)
MSCBBegin(1,6)

MSCBSay(28,01,"DATA: "+DtoC(SZD->ZD_DATA)+" HORA: "+SZD->ZD_HORA  ,"N","2","1,1")

MSCBSay(28,03,"OPERA.:"+SZD->ZD_USUARIO,"N","2","1,1")
//      C  L
MSCBSay(58,07," QTD: "                           ,"N","2","1,1")

MSCBSay(65,07,Transform(SZD->ZD_QTDPG,"@E 9,999"),"N","4","1,1")

MSCBSay(46,18,"OP: "+SZD->ZD_OP,"N","2","1,1")

//MSCBSayBar - Imprime código de barras ( nXmm nYmm cConteudo cRotação cTypePrt [ nAltura ] [ *lDigver ] [ lLinha ] [ *lLinBaixo ] [ cSubSetIni ]      [ nLargura ] [ nRelacao ] [ lCompacta ] [ lSerial ] [ cIncr ] [ lZerosL ] )

MSCBSayBar(31,07,SZD->ZD_CODIGO,"N","MB07",10 ,.F.,.T.,.F.,,3,1  ,Nil,Nil,Nil,Nil)

//MSCBSay(46,18,"OP: "+SZA->ZA_OP,"N","2","1,1")

MSCBEnd()

MSCBClosePrinter()

RestArea(_aAreaGER)

/*
MSCBPrinter("TLP 2844",_cPorta,,,.F.)
MSCBBegin(1,6)
MSCBSay(28,01,"ALMOXARIFADO :"+SBE->BE_LOCAL,"N","2","1,1")
MSCBSay(28,03,"ENDERECO :"+SBE->BE_LOCALIZ,"N","2","1,1")
MSCBSayBar(27,06,SBE->BE_LOCAL+SubStr(SBE->BE_LOCALIZ,1,13),"N","MB07",10,.F.,.T.,.F.,,2,1,Nil,Nil,Nil,Nil)
MSCBEnd()
MSCBClosePrinter()
*/

Return

Static Function AlertC(cTexto)
Local aTemp := U_QuebraString(cTexto,20)
Local cTemp := ''
Local lRet  := .T.

For x := 1 to Len(aTemp)
	cTemp += aTemp[x] + Chr(13)
Next x

cTemp += 'Continuar?'

If !apMsgNoYes( cTemp )
	lRet := .F.
EndIf

Return(lRet)
