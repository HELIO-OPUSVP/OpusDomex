#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Rwmake.ch"
#include "Topconn.ch"
#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMACD24  ºAutor  ³Michel Sander       º Data ³  08.09.16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela de montagem da embalagem de SENF para faturamento 	  º±±
±±º          ³ 														                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMACD24()

Private oTxtOP,oGetOP,oTxtEtiq,oGetEtiq,oTxtProd,oGetProd,oTxtQtd,oGetQtd,oMark,oTxtQtdEmp,oMainEti
Private _nTamEtiq      := 21
Private _cNumEtqPA     := Space(_nTamEtiq)
Private _cProduto      := CriaVar("B1_COD",.F.)
Private _nQtd          := CriaVar("XD1_QTDATU",.F.)
Private _cLoteEti      := CriaVar("BF_LOTECTL",.F.)
Private _aCols         := {}
Private _lAuto	        := .T.
Private _lIndividual   := .T.
Private _cCodInv
Private cGetEnd        := Space(2+15+1)
Private _cProdEmp	     := Space(15)
Private _cNomCli       := Space(15)
Private _cDescric	     := Space(27)
Private _cDescEmb      := Space(27)
Private _cEmbalag	     := Space(15)
Private _cNumOp        := SPACE(11)
Private _cNumPed       := SPACE(06)
Private _nQtdEmp       := 0
Private _nQtd          := 0
Private _aDados        := {}
Private _aEnd          := {}
Private _nCont
Private _cDtaFat       := dDataBase
Private nQtdCaixa      := 0
Private cTipoSenf      := ""
Private nSaldoEmb      := 0
Private cVolumeAtu     := SPACE(17)
Private nSaldoGrupo    := 0
Private nTotalGrupo    := 0
Private nRestaGrupo    := 0
Private nPesoEmb       := 0
Private nPesoBruto     := 0
Private cLocProcDom    := GetMV("MV_XXLOCPR")
Private aEmbBip        := {}
Private aSeqBib        := {}
Private aEmbPed        := {}
Private aEmb           := {}
Private aProdEmb       := {}
Private lPesoEmb       := .F.
Private oTelaPeso
Private cGrupoesp      := "'TRUN'"  //"'TRUN','CORD'"
Private lBeginSQL      := .T.
Private cZY_SEQ        := ""
Private cNivelFat      := ""
Private lHuawei        := .F.
Private nDisponivel    := 0
Private cOpPedido      := ""
Private cOPItemPV      := ""
Private nNivUsado      := ""

dDataBase := Date()

If cUsuario == 'HELIO'
	//_cNumEtqPA := Space(_nTamEtiq)
	_cNumEtqPA := '000018961928   '
	_cDtaFat   := CtoD('29/08/16')
EndIf

Define MsDialog oTelaOP Title OemToAnsi("Revenda SENF " + DtoC(dDataBase) ) From 0,0 To 293,233 Pixel of oMainWnd PIXEL

nLin := 005
@ nLin,001 Say oTxtEtiq    Var "Num.Etiqueta" Pixel Of oTelaOP
@ nLin-2,045 MsGet oGetOP  Var _cNumEtqPA Valid VldEtiq() Size 70,10 Pixel Of oTelaOP
oTxtEtiq:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetOP:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

@ 018,001 To 065,115 Pixel Of oMainWnd PIXEL

@ 021,005 Say oTxtProdEmp  Var "Produto: "        Pixel Of oTelaOP
@ 021,035 Say oTxtProdCod  Var _cProdEmp          Pixel Of oTelaOP
@ 029,005 Say oTxtDes      Var "Descrição: "      Pixel Of oTelaOP
@ 029,035 say oTxtDescPro  Var _cDescric      Size 075,15 Pixel Of oTelaOP
oTxtDescPro:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)

nLin+= 40
@ nLin,005 Say oTxtOP Var "Num.OP: " Pixel Of oTelaOP
@ nLin,027 Say oNumOP Var _cNumOP Size 120,10 Pixel Of oTelaOP
@ nLin,077 Say oTxtQtdEmp   Var "Qtd: "+ TransForm(_nQtdEmp,"@E 999,999.99") Pixel Of oTelaOP
oNumOp:oFont:= TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
oTxtQtdEmp:oFont  := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
oTxtProdCod:oFont  := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)

nLin+= 10
@ nLin,005 Say oTxtPed Var "Pedido: " Pixel Of oTelaOP
@ nLin,023 Say oNumPed Var _cNumPed+'-'+_cNomCli Size 120,10 Pixel Of oTelaOP
oNumPed:oFont:= TFont():New('Arial',,15,,.T.,,,,.T.,.F.)

nLin+= 05
@ 070,001 To 145,115 Pixel Of oMainWnd PIXEL
nLin+= 15

@ nLin,005   Say   oTxtDtfat Var "Faturamento:" Pixel Of oTelaOp
@ nLin-1,060 MSGET oDataFat  Var _cDtaFat When .T. VALID vlddata() Size 50,10 Pixel Of oTelaOP
nLin+= 11

@ nLin,005   Say oTxtSldGrupo Var "Volumes do Pedido:" Pixel Of oTelaOP
@ nLin-1,060 MSGET oSldGrupo  Var cVolumeAtu When .F. Size 50,10 Pixel Of oTelaOP
oSldGrupo:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

nLin += 15
@ nLin,005 Say oTxtSaldoEmb  Var "Qtde. por Volume: " Pixel Of oTelaOP
@ nLin-2,060 MsGet oSaldoEmb Var nSaldoEmb When .F. Picture "@E 999,999,999" Size 50,10  Pixel Of oTelaOP
oSaldoEmb:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

nLin += 14
@ nLin  ,005 Say oTxtQtd    Var "Qtd.Lida " Pixel Of oTelaOP
@ nLin-2,060 MsGet oGetQtd  Var _nQtd Valid ValidQtd() When .F. Picture "@E 9,999,999" Size 50,10  Pixel Of oTelaOP
oTxtQtd:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetQtd:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

nLin += 017
@ nLin,008 Button oEtiqueta PROMPT "Fechar CAIXA" Size 100,10 Action { || U_FechaSenf(),;
																									oTxtProdCod:Refresh(),;
																									oTxtProdEmp:Refresh(),;
																									oTxtQtdEmp:Refresh(),;
																									oNumPed:Refresh(),;
																									oSaldoEmb:Refresh(),;
																									oNumOp:Refresh(),;
																									oGetQtd:Refresh(),;
																									_cNumEtqPA := Space(_nTamEtiq),;
																									oGetOp:SetFocus() } Pixel Of oTelaOp

Activate MsDialog oTelaOP

//																									oTxtDescric:=Refresh(),;
Return

Static Function VldEtiq()

Local _lRet := .T.
_cProdEmp   := ""
_cDescric   := ""
_cEmbalag   := ""
_nQtdEmp    := 0
_aDados     := {}

If Empty(_cNumEtqPA)
	Return .T.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Prepara número da etiqueta bipada							³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(AllTrim(_cNumEtqPA))==12 //EAN 13 s/ dígito verificador.
	_cNumEtqPA := "0"+_cNumEtqPA
	_cNumEtqPA := Subs(_cNumEtqPA,1,12)
EndIf

SC2->( dbSetOrder(1) )
SB1->( dbSetOrder(1) )
SBF->( dbSetOrder(2) )

If XD1->(dbSeek(xFilial("XD1")+_cNumEtqPA))
	
	SB1->(dbSeek(xFilial("SB1")+XD1->XD1_COD))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica separação												³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(XD1->XD1_PVSEP)
		U_MsgColetor("Esta embalagem já está separada para o pedido/item "+XD1->XD1_PVSEP)
		_cNumEtqPA := Space(_nTamEtiq)
		oGetOp:Refresh()
		oGetOp:SetFocus()
		Return(.F.)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o item pertence a SENF							³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// Nova funcionalidade para permitir faturamento de PA para estoque como SENF 
	// Michel Sander em 27.02.2019
	If GetMv("MV_XPAEXP")
	   cCondicao := "SB1->B1_TIPO $ 'PR*PI*PA'"
	   cNivUsado := XD1->XD1_NIVEMB
	Else
	   cCondicao := "XD1->XD1_NIVEMB == '1' .And. SB1->B1_TIPO $ 'PR*PI*PA'"
		cNivUsado := "1"
	EndIf
	
	If &cCondicao
		                      
		cTipoSenf := SB1->B1_TIPO
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza etiqueta bipada										³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If aScan(aEmbBip,{ |aVet| aVet[1] == _cNumEtqPA }) == 0
	
			SC6->(dbSetOrder(1))
			If SC6->(dbSeek(xFilial("SC2")+XD1->XD1_PVSENF))
				If SC6->C6_PRODUTO <> XD1->XD1_COD
					U_MsgColetor("Item de SENF diferente da etiqueta.")
					_cNumEtqPA := Space(_nTamEtiq)
					oGetOp:Refresh()
					oGetOp:SetFocus()
					Return(.F.)
				EndIf
	
				SA1->(dbSeek(xFilial("SA1")+SC6->C6_CLI))
				SB1->(dbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica pedido de venda										³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !Empty(_cNumPed)
					If ( SC6->C6_NUM <> _cNumPed ) .And. !Empty(_cNumPed)
						U_MsgColetor("SENF diferente da coleta atual.")
						_cNumEtqPA := Space(_nTamEtiq)
						oGetOp:Refresh()
						oGetOp:SetFocus()
						Return(.F.)
					EndIf
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifica se trocou de pedido entre volumes				³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
					If nTotalGrupo > 0
						cVolumeAtu := SPACE(20)
						nTotalGrupo := 0
						aEmbPed     := {}
						aEmb        := {}
					EndIf
					
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica se coleta o mesmo produto para calculo peso	³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If aScan(aProdEmb,SC6->C6_PRODUTO) == 0
					AADD(aProdEmb,SC6->C6_PRODUTO)
				EndIf
				
				_nQtdEmp   := SC6->C6_QTDVEN
				cGrupoItem := SB1->B1_GRUPO
				cOpPedido  := SC6->C6_NUM
				cOPItemPV  := SC6->C6_ITEM
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Nivel de Embalagem para Faturamento			 		  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cNivelFat := "2"
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Acumula o total dos grupos do pedido				  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If aScan(aEmbPed,{ |x| x[1] == cGrupoItem }) == 0
					
					nTotCx2PV  := 0
					nCx2SepPv  := 0
					nQtdPed    := 0
					
					// Inserido por Michel Sander em 19.02.16 para calcular os volumens baseado na previsao de faturamento
					SZY->(dbSetOrder(1))
					If !SZY->(dbSeek(xFilial("SZY")+SC6->C6_NUM))  // arrumar: olhar quais produtos estão nessa caixa e ver se te programação SZY somente para estes produtos
						U_MsgColetor("Não existe programação de faturamento para esse produto.")
						_cNumEtqPA := Space(_nTamEtiq)
						oGetOp:Refresh()
						oGetOp:SetFocus()
						Return(.F.)
					Else
						lDataFat  := .F.
						cPedAuxZY := AllTrim(SZY->ZY_PEDIDO )
						Do While SZY->(!Eof()) .And. SZY->ZY_PEDIDO == SC6->C6_NUM
							If SZY->ZY_PRVFAT == _cDtaFat .and. SZY->ZY_ITEM == SC6->C6_ITEM
								lDataFat := .T.
								Exit
							EndIf
							SZY->(dbSkip())
						EndDo
						If !lDataFat
							U_MsgColetor("Não existe programação de faturamento do Pedido/Item "+cPedAuxZY+" para '"+DtoC(_cDtaFat)+"'.")
							_cNumEtqPA := Space(_nTamEtiq)
							oGetOp:Refresh()
							oGetOp:SetFocus()
							Return(.F.)
						EndIf
					EndIf
					
					// Inserido por Michel Sander em 19.02.16 para calcular os volumens baseado na previsao de faturamento
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Calcula a quantidade de volumes pela previsao 	 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cAliasSZY := GetNextAlias()
					If !Empty(cGrupoItem)
						cWhere    := "%B1_GRUPO ='"+cGrupoItem+"' AND "+"ZY_PEDIDO ='"+cOpPedido+"'%"
					Else
						cWhere    := "%ZY_PEDIDO ='"+cOpPedido+"'%"
					EndIf

					cWhereSZY   := "%ZY_PRVFAT ='"+Dtos(_cDtaFat)+"' AND ZY_NOTA = ''%"
					
					If lBeginSQL
						BeginSQL Alias cAliasSZY
								SELECT ZY_PEDIDO, ZY_ITEM, ZY_SEQ, ZY_PRVFAT, (ZY_QUANT-ZY_QUJE) ZY_QUANT, (ZY_QUANT-ZY_QUJE) ZY_VOLUMES
								From %table:SZY% SZY (NOLOCK)
								JOIN %table:SB1% SB1 (NOLOCK)
								ON B1_FILIAL = '  ' AND B1_COD = ZY_PRODUTO
								WHERE SZY.%NotDel%
								And SB1.%NotDel%
								And %Exp:cWhere%
								And %Exp:cWhereSZY%
								ORDER BY ZY_PRODUTO
						EndSQL
					Else
						cQuery := "SELECT ZY_PEDIDO, ZY_ITEM, ZY_SEQ, ZY_PRVFAT, (ZY_QUANT-ZY_QUJE) ZY_QUANT, (ZY_QUANT-ZY_QUJE) ZY_VOLUMES "
						cQuery += "			From SZY010 SZY (NOLOCK) "                                                      + Chr(13)
						cQuery += "			JOIN SB1010 SB1 (NOLOCK) "                                                      + Chr(13)
						cQuery += "			ON B1_COD = ZY_PRODUTO   "                                                      + Chr(13)
						cQuery += "			WHERE	SZY.D_E_L_E_T_ = '' "                                                 	  + Chr(13)
						cQuery += "					And SB1.D_E_L_E_T_ = '' "                                                 + Chr(13)
						cQuery += "					And " + StrTran(cWhere    ,'%','')                                        + Chr(13)
						cQuery += "					And " + StrTran(cWhereSZY ,'%','')                                        + Chr(13)
						cQuery += "					ORDER BY ZY_PRODUTO "                                                     + Chr(13)
						TCQUERY cQuery new alias &(cAliasSZY)
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Validando apenas uma progrmação de fatuamento para cada item de PV
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aTemp := {}
					
					Do While (cAliasSZY)->(!Eof())
						If aScan(aTemp, (cAliasSZY)->(ZY_PEDIDO+ZY_ITEM+ZY_PRVFAT) ) == 0
							AADD(aTemp,(cAliasSZY)->(ZY_PEDIDO+ZY_ITEM+ZY_PRVFAT) )
						Else
							U_MsgColetor("Existem duas previsões de faturamento para o mesmo item de Pedido com esta data")
							_cNumEtqPA := Space(_nTamEtiq)
							oGetOp:Refresh()
							oGetOp:SetFocus()
							Return(.F.)
						EndIf
						(cAliasSZY)->(dbSkip())
					EndDo
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Validação entre Previsão de Faturamento e Pedido de vendas  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cQuery := "SELECT ZY_PEDIDO, ZY_ITEM, SUM(ZY_QUANT) AS ZY_QUANT FROM "+RetSQLName("SZY")+" (NOLOCK) WHERE "
					cQuery += "ZY_PEDIDO ='"+cOpPedido+"' AND D_E_L_E_T_ = '' GROUP BY ZY_PEDIDO, ZY_ITEM ORDER BY ZY_ITEM "
					If Select("QUERYSZY") <> 0
						QUERYSZY->( dbCloseArea() )
					EndIf
					TCQUERY cQuery NEW ALIAS 'QUERYSZY'
					nTemp1 := 0
					nTemp2 := 0
					While !QUERYSZY->( EOF() )
						nTemp1++
						QUERYSZY->(dbSkip())
					End
					cAliasSC6 := SC6->(GetArea())
					SC6->( dbSetOrder(1) )
					If SC6->( dbSeek( xFilial() + cOpPedido ) )
						While !SC6->( EOF() ) .and. SC6->C6_NUM == cOpPedido
							nTemp2++
							SC6->( dbSkip() )
						End
					EndIf
					RestArea(cAliasSC6)
					If nTemp1 <> nTemp2
						U_MsgColetor("Número de Itens do Pedido de Vendas ("+Alltrim(Str(nTemp2))+") diferente da Previsão de Faturamento ("+Alltrim(Str(nTemp1))+").")
						_cNumEtqPA := Space(_nTamEtiq)
						oGetOp:Refresh()
						oGetOp:SetFocus()
						Return(.F.)
					EndIf
					cAliasSC6 := SC6->(GetArea())
					QUERYSZY->( dbGoTop() )
					While !QUERYSZY->( EOF() )
						If SC6->( dbSeek( xFilial() + QUERYSZY->ZY_PEDIDO + QUERYSZY->ZY_ITEM ) )
							If QUERYSZY->ZY_QUANT <> SC6->C6_QTDVEN
								U_MsgColetor("Quantidade do Pedido diferente da Previsão de Faturamento. Pedido/Item: " + QUERYSZY->ZY_PEDIDO + '/' + QUERYSZY->ZY_ITEM+'.')
								_cNumEtqPA := Space(_nTamEtiq)
								oGetOp:Refresh()
								oGetOp:SetFocus()
								RestArea(cAliasSC6)
								Return(.F.)
							EndIf
						Else
							U_MsgColetor("Não foi encontrada Previsão de Faturamento para o Pedido/Item: " + QUERYSZY->ZY_PEDIDO + '/' + QUERYSZY->ZY_ITEM+'.')
							_cNumEtqPA := Space(_nTamEtiq)
							oGetOp:Refresh()
							oGetOp:SetFocus()
							RestArea(cAliasSC6)
							Return(.F.)
						EndIf
						QUERYSZY->( dbSkip() )
					End
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Desconta caixas separadas								  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					SC6->( dbSetOrder(1) )
					cAliasSC6 := SC6->(GetArea())
					(cAliasSZY)->( dbGoTop() )
					aVetGeral := {}
					cZY_SEQ   := ""
					
					Do While (cAliasSZY)->(!Eof())
						
						If Alltrim((cAliasSZY)->ZY_PEDIDO) == Alltrim(cOpPedido) .AND. Alltrim((cAliasSZY)->ZY_ITEM) == Alltrim(cOPItemPV)
							cZY_SEQ := (cAliasSZY)->ZY_SEQ
						EndIf
						
						SC6->( dbSeek( xFilial() + (cAliasSZY)->ZY_PEDIDO + (cAliasSZY)->ZY_ITEM ) )
						nDisponiveis := U_Disp2SNF(Alltrim((cAliasSZY)->ZY_PEDIDO + (cAliasSZY)->ZY_ITEM),cNivUsado,(cAliasSZY)->ZY_PEDIDO + (cAliasSZY)->ZY_ITEM)
						nSeparadas   := U_Separa2SNF((cAliasSZY)->ZY_PEDIDO, (cAliasSZY)->ZY_ITEM,cNivUsado)
						
						// aVetGeral 	1 - Numero do Pedido
						//					2 - Codigo do Item do Pedido
						//					3 - Quantidade do Item do Pedido
						//					4 - Quantidade de Volumes Calculado para Expedicao
						//					5 - Número de caixas separadas
						//					6 - Numero de caixas Disponíveis
						AADD(aVetGeral,{(cAliasSZY)->ZY_PEDIDO,(cAliasSZY)->ZY_ITEM, (cAliasSZY)->ZY_QUANT, (cAliasSZY)->ZY_VOLUMES, nSeparadas , nDisponiveis  })
						
						(cAliasSZY)->(dbSkip())
					EndDo
					RestArea(cAliasSC6)
					
					nQtdPed := 0
					For _nxy := 1 to Len(aVetGeral)
						nQtdPed    += aVetGeral[_nxy,3] // ZY_QUANT
					Next _nxy
					
					nCx2SepPv  := 0
					For _nxy := 1 to Len(aVetGeral)
						nCx2SepPv  += aVetGeral[_nxy,5] // caixas separadas
					Next
					
					nDisponivel := 0
					For _nxy := 1 to Len(aVetGeral)
						nDisponivel += aVetGeral[_nxy,6] // caixinhas disponíveis
					Next
					
					nTotCx2PV := 0
					For _nxy := 1 to Len(aVetGeral)
					    nInteiro   := Int(aVetGeral[_nxy,4])
					    nResto     := aVetGeral[_nxy,4] - Int(aVetGeral[_nxy,4])
					    nVolUso    := 0
					    If nResto >= 0.0001 .And. nResto <= 0.0009
					       nVolUso := nInteiro
					    Else
					       nVolUso := ( nInteiro + 1) 
					    EndIf   
					
						nTemp      := If( Int(aVetGeral[_nxy,4]) <> aVetGeral[_nxy,4], nVolUso, aVetGeral[_nxy,4] ) // ZY_VOLUMES
						nTotCx2PV  += nTemp
					Next _nxy
					
					If Empty(cZY_SEQ)
						U_MsgColetor("Sequencia não localizada.")
						_cNumEtqPA := Space(_nTamEtiq)
						oGetOp:Refresh()
						oGetOp:SetFocus()
						(cAliasSZY)->(dbCloseArea())
						Return(.F.)
					EndIf
					
					(cAliasSZY)->(dbCloseArea())
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifica embalagem que será usada para o produto		³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aEmb := {}
					AADD(aEmb, { XD1->XD1_EMBALA, XD1->XD1_QTDATU, Posicione("SB1",1,xFilial("SB1")+XD1->XD1_EMBALA,"B1_PESO") } )
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//Calcula a quantidade de volumes do pedido										  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					AADD(aEmbPed,{ cGrupoItem, (nTotCx2PV - nCx2SepPv) })
					
					nTotalGrupo := 0
					nSaldoGrupo := nTotCx2PV
					While !Empty(nSaldoGrupo)
						nTemp := XD1->XD1_QTDATU
						nTotalGrupo++
						nSaldoGrupo -= nTemp
						If nSaldoGrupo < 0
							nSaldoGrupo := 0
						EndIf
					End
					
					nSaldoGrupo := U_Separa2SNF(SC6->C6_NUM,'', cNivelFat ,'6')+1
					cVolumeAtu  := PADL(AllTrim(Str(nSaldoGrupo))+"/"+AllTrim(Str(nTotalGrupo)),18)
					oSldGrupo:Refresh()
					
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Atualiza dados para o coletor									³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SB1->(dbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
				nSaldoEmb := aEmb[1,2]
				_cEmbalag := aEmb[1,1]
				nPesoEmb  := aEmb[1,3]
				_cNomCli  := "  "+SUBSTR(SA1->A1_NOME,1,15)
				_cNumPed  := SC6->C6_NUM
				_cProdEmp := SB1->B1_COD
				_cDescric := SB1->B1_DESC
				SB1->(dbSeek(xFilial("SB1")+aEmb[1,1]))
				_cDescEmb := SUBSTR(SB1->B1_DESC,1,27)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Coleta etiqueta bipada											³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				_nQtd     += 1
				nQtdCaixa += XD1->XD1_QTDATU
				AADD(aEmbBip,{_cNumEtqPA,SC6->C6_NUM,SC6->C6_ITEM})
				AADD(aSeqBib,cZY_SEQ)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Imprime etiqueta nivel 3										³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If _nQtd == nDisponivel
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Abre digitação do peso											³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					oGetQtd:Refresh()
					nPesoBruto := U_CalPSNF(SC6->C6_NUM,SC6->C6_PRODUTO)
					cGeraSenf  := SC6->C6_NUM
					nPesoSenf  := nPesoBruto
					
					If lPesoEmb
						
						If ImpNivel3()
							
							Reclock("XD1",.F.)
							XD1->XD1_VOLUME := ALLTRIM(cVolumeAtu)
							XD1->XD1_PVSEP  := cGeraSenf
							XD1->XD1_PESOB  := nPesoSenf   
							XD1->XD1_PVSENF := cGeraSenf
							XD1->XD1_ULTNIV := "S"
							XD1->(MsUnlock())

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Atualiza separacao do pedido									³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							AtuSepEmb(cOpPedido,cOPItemPV)
							
							aEmbBip     := {}
							aSeqBib     := {}
							nSaldoEmb   := 0
							nSaldoGrupo += 1
							cVolumeAtu := PADL(AllTrim(Str(nSaldoGrupo))+"/"+Alltrim(Str(nTotalGrupo)),17)
							If nSaldoGrupo == nTotalGrupo
								cVolumeAtu  := SPACE(20)
								nTotalGrupo := 0
								aEmbPed     := {}
								aEmb        := {}
							EndIf
							nPesoBruto  := 0
							nQtdCaixa   := 0
							_nQtdEmp    := 0
							_cEmbalag   := ""
							_cNomCli    := ""
							_cProdEmp   := SPACE(27)
							_cDescric   := SPACE(27)
							_cDescEmb   := SPACE(27)
							_cNumOp     := SPACE(11)
							_nQtdEmp    := 0
							_cNumPed    := SPACE(06)
							nDisponivel := 0
							cTipoSenf   := ""							
							
						EndIf
						
					EndIf
					
					_nQtd       := 0
					
				EndIf
				
				oTxtProdCod:Refresh()
				oTxtProdEmp:Refresh()
				oTxtQtdEmp:Refresh()
//				oTxtDescric:=Refresh()
				oNumPed:Refresh()
				oSaldoEmb:Refresh()
				oNumOp:Refresh()
				oGetQtd:Refresh()
				_cNumEtqPA := Space(_nTamEtiq)
				oGetOp:SetFocus()
				
			Else
			
				U_MsgColetor("Item de SENF não encontrado no pedido.")
				_cNumEtqPA := Space(_nTamEtiq)
				oGetOp:Refresh()
				oGetOp:SetFocus()
				cTipoSenf := ""
				_lRet:=.F.
			
			EndIf

		Else

			_cNumEtqPA := Space(_nTamEtiq)
			oGetOp:Refresh()
			oGetOp:SetFocus()
			cTipoSenf := ""
			_lRet:=.F.

		EndIf
		
	Else
		
		U_MsgColetor("Tipo de produto "+SB1->B1_TIPO+" não pertence a SENF.")
		_cNumEtqPA := Space(_nTamEtiq)
		oGetOp:Refresh()
		oGetOp:SetFocus()
		cTipoSenf := ""
		_lRet:=.F.

	EndIf

Else
	
	U_MsgColetor("Etiqueta não encontrada.")
	_cNumEtqPA := Space(_nTamEtiq)
	oGetOp:Refresh()
	oGetOp:SetFocus()
	_lRet:=.F.
	
EndIf

If Empty(_cNumEtqPA)
	_lRet := .T.
Else
EndIf

oTelaOP:Refresh()

Return(_lRet)

Static Function VldData()

// Tratamento para Permitir Faturamento em até 1 dia Util anterior - 30/10/17
_nDias := 1 	

if Dow(dDataBase) == 2  // Se for Segunda, retorna 3 dias
	_nDias := 3
elseif Dow(dDataBase) == 1  // Se for Domingo, retorna 2 dias
	_nDias := 2
else  // Qualquer outro dia, retorna 1 dia
	_nDias := 1
endif


If _cDtaFat < (dDataBase -_nDias) 
//	U_MsgColetor("Data de faturamento não deve ser menor que a data atual.")
	U_MsgColetor("Data de faturamento não deve ser menor que 1 dia útil Anterior.")		
	Return(.f.)

Else
	return(.t.)
endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SeparaEmb  ºAutor  ³Michel Sander     º Data ³  09/29/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca os produtos já separados para o pedido    	        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Separa2SNF(cPedido, cItem, cNivelSep, cOcorrencia)

LOCAl cSQL 	  	 := ""
LOCAL cIndexQry := RetSQLName("XD1")+"6"
LOCAL nSepara   := 0
Local cAliasTmp := GetNextAlias()
Local cIndice   := "%WITH(INDEX(" + cIndexQry + "))%"
Local aAreaGER  := GetArea()
Local aAreaSB1  := SB1->( GetArea() )
Local aAreaSC6  := SC6->( GetArea() )

Local cWhere

Default cOcorrencia := '4'

SC6->( dbSetOrder(1) )
SB1->( dbSetOrder(1) )

SC6->( dbSeek( xFilial() + cPedido + cItem ) )
SB1->( dbSeek( xFilial() + SC6->C6_PRODUTO ) )

cWhere := "%XD1_FILIAL = '"+xFilial("XD1")+"' AND SUBSTRING(XD1_PVSEP,1,"+Alltrim(Str(Len(cPedido+cItem)))+") = '"+cPedido+cItem+"' AND XD1_OCORRE ='"+cOcorrencia+"' AND XD1_NIVEMB ='"+cNivelSep+"' AND XD1_ZYNOTA = '' AND D_E_L_E_T_= '' %"

If lBeginSQL
	BeginSQL Alias cAliasTmp
		SELECT COUNT(*) NQTDECAIXA FROM %table:XD1% (NOLOCK) %exp:cIndice% WHERE %exp:cWhere%
	EndSQL
Else
	cSQL := "SELECT COUNT(*) NQTDECAIXA FROM "+RetSQLName("XD1")+" WITH(INDEX("+cIndexQry+")) WHERE "
	cSQL += Subs(Subs(cWhere,2),1,Len(alltrim(cWhere))-2)
	TCQUERY cSql NEW ALIAS &(cAliasTmp)
EndIf

nSepara := (cAliasTmp)->NQTDECAIXA
(cAliasTmp)->(dbCloseArea())

RestArea(aAreaSB1)
RestArea(aAreaSC6)
RestArea(aAreaGER)

Return ( nSepara )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Disp2SNF   ºAutor  ³Michel Sander     º Data ³  09/29/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca os produtos disponíveis	       			     	         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Disp2SNF(cOP,cNivelSep,cPVSENF)

LOCAl cSQL 	  	 := ""
LOCAL cIndexQry := RetSQLName("XD1")+"6"
LOCAL nSepara   := 0
Local cAliasTmp := GetNextAlias()
Local cIndice   := "%WITH(INDEX(" + cIndexQry + "))%"
Local cWhere    := "%XD1_FILIAL = '"+xFilial("XD1")+"' AND XD1_PVSEP  = '' AND XD1_OCORRE ='4' AND XD1_NIVEMB ='"+cNivelSep+"' AND XD1_OP = '"+cOP+"001' AND D_E_L_E_T_= '' %"

If !Empty(cPVSENF)
	cWhere := "%XD1_FILIAL = '"+xFilial("XD1")+"' AND XD1_PVSEP  = '' AND XD1_OCORRE ='4' AND XD1_NIVEMB ='"+cNivelSep+"' AND XD1_PVSENF='"+cPVSENF+"' AND D_E_L_E_T_= ''%"
EndIf

If lBeginSQL
	BeginSQL Alias cAliasTmp
		SELECT COUNT(*) NQTDECAIXA FROM %table:XD1% (NOLOCK) %exp:cIndice% WHERE %exp:cWhere%
	EndSQL
Else
	cSQL := "SELECT COUNT(*) NQTDECAIXA FROM "+RetSQLName("XD1")+" WITH(INDEX("+cIndexQry+")) WHERE "
	cSQL += "XD1_FILIAL = '"+xFilial("XD1")+"' AND "
	cSQL += "XD1_PVSEP  = ''                   AND "
	cSQL += "XD1_OCORRE = '4'                  AND "
	cSQL += "XD1_NIVEMB = '"+cNivelSep+"'      AND "
	If !Empty(cPVSENF)
	   cSQL += "XD1_PVSENF='"+cPVSENF+"' AND "
	Else
		cSQL += "XD1_OP     = '"+cOP+"001'         AND "
   EndIf
	cSQL += "D_E_L_E_T_ = ''                       "
	TCQUERY cSQL NEW ALIAS &(cAliasTmp)
EndIf

nSepara := (cAliasTmp)->NQTDECAIXA
(cAliasTmp)->(dbCloseArea())

Return ( nSepara )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AtuSepEmb ºAutor  ³Michel Sander     º Data ³  09/29/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza a separação para o pedido de venda  		         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AtuSepEmb()

For nQ := 1 to Len(aEmbBip)
	
	If XD1->(dbSeek(xFilial("XD1")+aEmbBip[nQ,1]))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza Separação												³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Reclock("XD1",.F.)
		XD1->XD1_PVSEP  := aEmbBip[nQ,2]+aEmbBip[nQ,3]
		XD1->XD1_ZYSEQ  := aSeqBib[nQ]
		XD1->(MsUnlock())
		
	EndIf
	
Next

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RetSNF2ZW ºAutor  ³Michel Sander       º Data ³  09/29/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca a embalagem nivel 3 que será usada				         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RetSNF2ZW(cGrupEmb, nQtEmb, cNivEmb, cCliEmb, cLojEmb)

LOCAL __CODEMB  := ""
LOCAL __QTDEATE := 0
LOCAL __PESO    := 0
LOCAL aEMBTmp   := {}

SZW->(dbSetOrder(2))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca a embalagem por grupo e por cliente	primeiro³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !SZW->(dbSeek(xFilial("SZW")+cGrupEmb+cCLiEmb+cLojEmb+cNivEmb))
	If SZW->(dbSeek(xFilial("SZW")+cGrupEmb+SPACE(06)+SPACE(02)+cNivEmb))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Busca a embalagem por grupo em seguida				  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do While SZW->(!Eof()) .And. SZW->ZW_FILIAL+SZW->ZW_GRUPO+SZW->ZW_CLIENTE+SZW->ZW_LOJA+SZW->ZW_NIVEL == xFilial("SZW")+cGrupEmb+SPACE(06)+SPACE(02)+cNivEmb
			If nQTEmb >= SZW->ZW_QTDEDE .And. nQTEmb <= SZW->ZW_QTDEATE
				AADD(aEMBTmp,{SZW->ZW_CODEMB, nQTEmb, SZW->ZW_PESO})
			EndIf
			__CODEMB  := SZW->ZW_CODEMB
			__QTDEATE := SZW->ZW_QTDEATE
			__PESO    := SZW->ZW_PESO
			SZW->(dbSkip())
		Enddo
		If Empty(aEMBTmp)
			AADD(aEMBTmp,{__CODEMB,	__QTDEATE, __PESO})
		EndIf
	Else
		AADD(aEMBTmp, {__CODEMB,	__QTDEATE, __PESO})
	EndIf
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Busca a embalagem por cliente							  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Do While SZW->(!Eof()) .And. SZW->ZW_FILIAL+SZW->ZW_GRUPO+SZW->ZW_CLIENTE+SZW->ZW_LOJA+SZW->ZW_NIVEL == xFilial("SZW")+cGrupEmb+cCLiEmb+cLojEmb+cNivEmb
		If nQTEmb >= SZW->ZW_QTDEDE .And. nQTEmb <= SZW->ZW_QTDEATE
			AADD(aEMBTmp,{SZW->ZW_CODEMB, nQTEmb, SZW->ZW_PESO})
		EndIf
		__CODEMB  := SZW->ZW_CODEMB
		__QTDEATE := SZW->ZW_QTDEATE
		__PESO    := SZW->ZW_PESO
		SZW->(dbSkip())
	Enddo
	If Empty(aEMBTmp)
		AADD(aEMBTmp,{__CODEMB,	__QTDEATE, __PESO})
	EndIf
EndIf

Return ( aEMBTmp )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CalPesoEmb ºAutor  ³Michel Sander     º Data ³  09/29/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela para digitação do peso								         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CalPSNF(cPedPeso,cProdPeso)

LOCAL nOpcPeso := 0

Define MsDialog oTelaPeso Title OemToAnsi("Peso da Embalagem") From 20,20 To 180,200 Pixel of oMainWnd PIXEL
nLin := 025
@ nLin,005 Say oTxtPeso     Var "Peso" Pixel Of oTelaPeso
@ nLin-2,025 MsGet oGetPeso Var nPesoBruto Valid nPesoBruto > 0 When .T. Picture "@E 99,999,999.9" Size 60,10 Pixel Of oTelaPeso
oTxtPeso:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetPeso:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
nLin+= 010
@ nLin,025 Button oBotPeso PROMPT "Confirma" Size 35,15 Action {|| nOpcPeso:=1,oTelaPeso:End()} Pixel Of oTelaPeso
Activate MsDialog oTelaPeso

If nOpcPeso == 1
	If Len(aProdEmb) == 1
		If SB1->(dbSeek(xFilial("SB1")+cProdPeso))
			If SB1->B1_XXPESOK == "2" .Or. Empty(SB1->B1_XXPESOK)
				nPesTotal := ( (nPesoBruto - nPesoEmb) / nQtdCaixa )
				Reclock("SB1",.F.)
				SB1->B1_XXPESOK := "3"
				SB1->B1_PESBRU  := nPesTotal
				SB1->(MsUnlock())
			ElseIf SB1->B1_XXPESOK == "3"
				nPesTotal := ( (nPesoBruto - nPesoEmb) / nQtdCaixa )
				If (SB1->B1_PESBRU * 0.05) < Abs(SB1->B1_PESBRU - nPesTotal)
					Reclock("SB1",.F.)
					SB1->B1_XXPESOK := "1"
					SB1->B1_PESBRU  := nPesTotal
					SB1->(MsUnlock())
				Else
					Reclock("SB1",.F.)
					SB1->B1_PESBRU  := nPesTotal
					SB1->(MsUnlock())
				EndIf
			EndIf
		EndIf
	EndIf
	lPesoEmb := .T.
Else
	lPesoEmb := .F.
EndIf

Return ( nPesoBruto )

//---------------------------------------------------------

Static Function AlertC(cTexto)
Local aTemp := U_QuebraString(cTexto,20)
Local cTemp := ''
Local lRet  := .T.

For x := 1 to Len(aTemp)
	cTemp += aTemp[x] + Chr(13)
Next x

cTemp += 'Continuar?'

While !apMsgNoYes( cTemp )
	lRet:=.F.
End

Return(lRet)

//-----------------------------------------------------------

Static Function ValidQtd()

Local _Retorno      := .T.

Return _Retorno

//-----------------------------------------------------------

Static Function ImpNivel3()

LOCAL lRetEtq := .T.
LOCAL cCondImp := ""

If GetMv("MV_XPAEXP")
	cCondImp := "cTipoSenf $ 'PR*PI*PA'"
Else
   cCondImp := "cTipoSenf $ 'PR*PI'"
EndIf

If &cCondImp 
	
	If lHuawei
		
		cProxNiv   := cNivelFat
		__mv_par02 := XD1->XD1_OP
		__mv_par03 := Nil
		__mv_par04 := nQtdCaixa
		__mv_par05 := 1
		__mv_par06 := "01"
		lColetor   := .T.
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³LAYOUT 01 - HUAWEI UNIFICADA												   	³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lRotValid :=  U_DOMETQ04(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.F.,nPesoBruto,lColetor) 			// Validações de Layout 01
		If !lRotValid
			U_MsgColetor("A etiqueta não será impressa. Verifique os problemas com o  layout da etiqueta e repita a operação.")
			Return ( .F. )
		Else
			cRotina   := "U_DOMETQ04(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.T.,nPesoBruto,lColetor)"		// Impressão de Etiqueta Layout 01
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Executa rotina de impressao									³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lRetEtq := &(cRotina)		// suspensao temporaria da impressao até que se defina o layout nivel 3 em 29.10.2015
		lRetEtq := .T.
		
	Else
		
		//If cTipoSenf == "PR"
		   cProxNiv := "2"
		//Else   
		//   cProxNiv := cNivelFat
		//EndIf
		   
		__mv_par02 := XD1->XD1_OP
		__mv_par03 := _cNumPed
		__mv_par04 := nQtdCaixa
		__mv_par05 := 1
		__mv_par06 := "90"
		cVolumeAtu := Alltrim(cVolumeAtu)
		lColetor   := .T.
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³LAYOUT 90 - Etiqueta Nivel 3												   	³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lRotValid :=  U_DOMETQ90(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.F.,nPesoBruto,cVolumeAtu,lColetor)
		If !lRotValid
			U_MsgColetor("A etiqueta não será impressa. Verifique os problemas com o  layout da etiqueta e repita a operação.")
			Return ( .F. )
		Else
			__mv_par02 := XD1->XD1_OP
			__mv_par03 := _cNumPed
			__mv_par04 := nQtdCaixa
			__mv_par05 := 1
			__mv_par06 := "90"
			cRotina   := "U_DOMETQ90(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.T.,nPesoBruto,cVolumeAtu,lColetor)"		// Impressão de Etiqueta Layout 90 - Nivel 3
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Executa rotina de impressao									³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lRetEtq := &(cRotina)		// suspensao temporaria da impressao até que se defina o layout nivel 3 em 29.10.2015
		lRetEtq := .T.
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Reinicia variáveis da tela										³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	EndIf
	
EndIf

Return ( lRetEtq )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FechaSenfºAutor  ³Michel Sander     º Data   ³  08.09.16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para fechamento da caixa do item coletado	        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FechaSenf()

LOCAL cGeraSenf  := ""
LOCAL nPesoSenf  := 0

If Len(aEmbBip) > 0 
					
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Abre digitação do peso											³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	nPesoBruto := U_CalPSNF(SC6->C6_NUM,SC6->C6_PRODUTO)
	cGeraSenf  := SC6->C6_NUM
	nPesoSenf  := nPesoBruto
	
	If lPesoEmb
		
		If ImpNivel3()
			
			Reclock("XD1",.F.)
			XD1->XD1_VOLUME := ALLTRIM(cVolumeAtu)
			XD1->XD1_PVSEP  := cGeraSenf
			XD1->XD1_PESOB  := nPesoSenf   
			XD1->XD1_PVSENF := cGeraSenf
			XD1->XD1_ULTNIV := "S"
			XD1->(MsUnlock())

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza separacao do pedido									³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			AtuSepEmb(cOpPedido,cOPItemPV)
			
			aEmbBip     := {}
			aSeqBib     := {}
			nSaldoEmb   := 0
			nSaldoGrupo += 1
			cVolumeAtu := PADL(AllTrim(Str(nSaldoGrupo))+"/"+Alltrim(Str(nTotalGrupo)),17)
			If nSaldoGrupo == nTotalGrupo
				cVolumeAtu  := SPACE(20)
				nTotalGrupo := 0
				aEmbPed     := {}
				aEmb        := {}
			EndIf
			nPesoBruto  := 0
			nQtdCaixa   := 0
			_nQtdEmp    := 0
			_cEmbalag   := ""
			_cNomCli    := ""
			_cProdEmp   := SPACE(27)
			_cDescric   := SPACE(27)
			_cDescEmb   := SPACE(27)
			_cNumOp     := SPACE(11)
			_nQtdEmp    := 0
			_cNumPed    := SPACE(06)
			nDisponivel := 0
			cTipoSenf   := ""							
			lPesoEmb    := .F.
			cOPItemPV   := ""
			cOpPedido   := ""
						
		EndIf
		
	EndIf
	
	_nQtd := 0

Else
	
	U_MsgColetor("Não houve coleta de etiquetas.")
	_cNumEtqPA := Space(_nTamEtiq)
	oGetOp:Refresh()
	oGetOp:SetFocus()
	Return(.F.)

EndIf

Return ( .T. )
