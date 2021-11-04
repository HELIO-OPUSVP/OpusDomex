#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Rwmake.ch"
#include "Topconn.ch"
#include "Protheus.ch"

/*====================================
PROGRAMA SUBSTITUÌDO PELO DOMACD19
/*====================================
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMACD17  ºAutor  ³Michel Sander       º Data ³  09/04/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ embalagens 																  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMACD17()

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
	Private nQtdCaixa      := 0
	Private nSaldoEmb      := 0
	Private cSaldoGrupo    := SPACE(17)
	Private nSaldoGrupo    := 0
	Private nTotalGrupo    := 0
	Private nRestaGrupo    := 0
	Private nPesoEmb       := 0
	Private nPesoBruto     := 0
	Private cLocProcDom    := GetMV("MV_XXLOCPR")
	Private aEmbBip        := {}
	Private aEmbPed        := {}
	Private aEmb           := {}
	Private aProdEmb       := {}
	Private lPesoEmb       := .F.
	Private oTelaPeso

	dDataBase := Date()

	Define MsDialog oTelaOP Title OemToAnsi("Embalagens " + DtoC(dDataBase) ) From 0,0 To 293,233 Pixel of oMainWnd PIXEL

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
	@ 070,001 To 138,115 Pixel Of oMainWnd PIXEL
	nLin+= 12
	@ nLin,005 Say oTxtEmbalag  Var "Embalagem: " Pixel Of oTelaOp
	@ nLin,035 Say oTxtCodEmb   Var _cEmbalag 	 Pixel Of oTelaOP
	nLin+= 10
	@ nLin,005 SAY oTxtDescEmb Var _cDescEmb 		 Pixel Of oTelaOp
	oTxtDescEmb:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
	oTxtCodEmb:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)

	nLin+= 12
	@ nLin,005   Say oTxtSldGrupo Var "Volumes do Pedido:" Pixel Of oTelaOP
	@ nLin-1,060 MSGET oSldGrupo  Var cSaldoGrupo When .F. Size 50,10 Pixel Of oTelaOP
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

	nLin+= 16
	@ nLin,077 Button oEtiqueta PROMPT "Etiqueta" Size 35,10 //Action oTelaOp:End() //Pixel Of oTelaOP //Processa({ || U_CalPesoEmb(SC2->C2_PEDIDO,SC2->C2_PRODUTO), ImpNivel3()}) Pixel Of oTelaOp

	Activate MsDialog oTelaOP

Return

Static Function VldEtiq()

	Local _lRet :=.T.
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

		XD2->(dbSetOrder(1))
		If XD2->(dbSeek(xFilial("XD2")+XD1->XD1_XXPECA))

			_cNumOp   := XD1->XD1_OP

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza etiqueta bipada										³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aScan(aEmbBip,_cNumEtqPA) == 0

				If SC2->(dbSeek(xFilial("SC2")+XD1->XD1_OP))

					SA1->(dbSeek(xFilial("SA1")+SC2->C2_CLIENT))
					SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifica pedido de venda										³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !Empty(_cNumPed)
						If ( SC2->C2_PEDIDO <> _cNumPed ) .And. !Empty(_cNumPed)
							U_MsgColetor("Pedido diferente da coleta atual.")
							_cNumEtqPA := Space(_nTamEtiq)
							oGetOp:Refresh()
							oGetOp:SetFocus()
							Return(.F.)
						EndIf
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifica se coleta o mesmo produto para calculo peso	³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If aScan(aProdEmb,SC2->C2_PRODUTO) == 0
						AADD(aProdEmb,SC2->C2_PRODUTO)
					EndIf

					_nQtdEmp := SC2->C2_QUANT
					SC6->(dbSetOrder(7))
					If !SC6->(dbSeek(xFilial("SC6")+SC2->C2_NUM+SC2->C2_ITEM))
						U_MsgColetor("Não existem pedidos para esse item.")
						_cNumEtqPA := Space(_nTamEtiq)
						oGetOp:Refresh()
						oGetOp:SetFocus()
						Return(.F.)
					Else

						If SC6->C6_PRODUTO == SC2->C2_PRODUTO

							cGrupoItem := SB1->B1_GRUPO
							cOpPedido  := SC6->C6_NUM

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Acumula o total dos grupos do pedido				  ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If aScan(aEmbPed,{ |x| x[1] == cGrupoItem }) == 0

								nSomaCaixa := 0
								nQtdPed    := 0

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Calcula a quantidade de volumes						 ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								cAliasSC6 := GetNextAlias()
								cWhere    := "%B1_GRUPO = '"+cGrupoItem+"' AND G1_XXEMBNI = '2' AND "+"C6_NUM ='"+cOpPedido+"'%"
								cWhereXD1 := "%SUBSTRING(XD1_PVSEP,1,6) ='"+cOpPedido+"' AND XD1_NIVEMB='2'%"

								BeginSQL Alias cAliasSC6
							
								SELECT G1_COD, G1_QUANT, C6_QTDVEN C6_QUANT, (C6_QTDVEN*G1_QUANT) C6_VOLUMES,
										(SELECT COUNT(*) NQTDECAIXA FROM %table:XD1% XD1 (NOLOCK) 
										WHERE %Exp:cWhereXD1%
										AND XD1.D_E_L_E_T_='' 
										AND XD1_COD=G1_COD) XD1_NQTDECAIXA
										From %table:SC6% SC6 (NOLOCK) 
										JOIN %table:SG1% SG1 (NOLOCK) 
										ON G1_COD = C6_PRODUTO 
										JOIN %table:SB1% SB1 (NOLOCK) 
										ON B1_COD = C6_PRODUTO
										WHERE SG1.%NotDel%
												And SC6.%NotDel% 
												And SB1.%NotDel% 
												And %Exp:cWhere%
												ORDER BY G1_COD 
								EndSQL

								Do While (cAliasSC6)->(!Eof())
									SB1->(dbSeek(xFilial("SB1")+(cAliasSC6)->G1_COD))
									nSomaCaixa += If( Int((cAliasSC6)->C6_VOLUMES) <> (cAliasSC6)->C6_VOLUMES, Int((cAliasSC6)->C6_VOLUMES)+1, (cAliasSC6)->C6_VOLUMES )
									nSomaCaixa -= (cAliasSC6)->XD1_NQTDECAIXA
									nQtdPed    += (cAliasSC6)->C6_QUANT
									(cAliasSC6)->(dbSkip())
								EndDo

								(cAliasSC6)->(dbCloseArea())

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Verifica se existe apontamento suficiente para montar embalagem nivel 3 ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								cAliasXD1 := GetNextAlias()
								cWhere1   := "%''%"
								cWhere2   := "%'2'%"
								cWhere3   := "%'4'%"
								cWhereSC6 := "%'"+cOpPedido+"'%"

								BeginSQL Alias cAliasXD1
							
								SELECT COUNT(*) NQTDECAIXA FROM %table:XD1% (NOLOCK) XD1 
										WHERE XD1_NIVEMB = %exp:cWhere2%
										AND XD1_PVSEP    = %exp:cWhere1%
										AND XD1_OCORRE   = %exp:cWhere3%
										AND XD1.%NotDel% 
										AND SUBSTRING(XD1_OP,1,8) IN ( SELECT C6_NUMOP+C6_ITEMOP C6_OP 
																	FROM %table:SC6% SC6 (NOLOCK) JOIN %table:SB1% SB1 (NOLOCK) 
																	ON B1_FILIAL=C6_FILIAL AND B1_COD=C6_PRODUTO
																	WHERE SC6.%NotDel%
																		 AND SB1.%NotDel% 
																		 AND C6_NUM = %exp:cWhereSC6% 
																		 AND C6_NUMOP <> %exp:cWhere1% )
								EndSQL

								nDisponivel := (cAliasXD1)->NQTDECAIXA
								(cAliasXD1)->(dbCloseArea())

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Verifica embalagem que será usada para o produto		³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								aEmb := U_RetEmbZW(cGrupoItem, nSomaCaixa, "3", SA1->A1_COD, SA1->A1_LOJA)
								If Empty(aEmb[1,1])
									U_MsgColetor("Grupo de produtos sem embalagens definida.")
									_cNumEtqPA := Space(_nTamEtiq)
									oGetOp:Refresh()
									oGetOp:SetFocus()
									Return(.F.)
								EndIf

								If nDisponivel < aEmb[1,2]
									U_MsgColetor("Não existem caixas  suficientes do pedido   para     montagem da embalagem.")
									_cNumEtqPA := Space(_nTamEtiq)
									oGetOp:Refresh()
									oGetOp:SetFocus()
									Return(.F.)
								Endif

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//Calcula a quantidade de volumes do pedido										 ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								AADD(aEmbPed,{ cGrupoItem, nSomaCaixa })
								nSaldoGrupo := (nSomaCaixa / aEmb[1,2])		// Calcula a quantidade de volumes do pedido
								If Int(nSaldoGrupo) <> nSaldoGrupo
									nSaldoGrupo := Int(nSaldoGrupo)+1
								EndIf

								nTotalGrupo := nSaldoGrupo
								nSaldoGrupo := 1
								cSaldoGrupo := PADL(AllTrim(Str(nSaldoGrupo))+"/"+AllTrim(Str(nTotalGrupo)),18)
								oSldGrupo:Refresh()

							EndIf

						Else

							U_MsgColetor("Produto do Pedido de Venda: "+SC6->C6_NUM+" item: "+ SC6->C6_ITEM + " Produto: " + SC6->C6_PRODUTO + " diferente do produto da OP: "+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+" Produto: " + SC2->C2_PRODUTO)
							_cNumEtqPA := Space(_nTamEtiq)
							oGetOp:Refresh()
							oGetOp:SetFocus()
							Return(.F.)

						EndIf

					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Atualiza dados para o coletor									³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
					nSaldoEmb := aEmb[1,2]
					_cEmbalag := aEmb[1,1]
					nPesoEmb  := aEmb[1,3]
					_cNomCli  := "  "+SUBSTR(SA1->A1_NOME,1,15)
					_cNumPed  := SC2->C2_PEDIDO
					_cProdEmp := SB1->B1_COD
					_cDescric := SB1->B1_DESC
					SB1->(dbSeek(xFilial("SB1")+aEmb[1,1]))
					_cDescEmb := SUBSTR(SB1->B1_DESC,1,27)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Coleta etiqueta bipada											³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					_nQtd     += 1
					nQtdCaixa += XD1->XD1_QTDATU
					AADD(aEmbBip,_cNumEtqPA)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Imprime etiqueta nivel 3										³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If _nQtd == nSaldoEmb

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Abre digitação do peso											³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						oGetQtd:Refresh()
						nPesoBruto := U_CalPesoEmb(SC2->C2_PEDIDO,SC2->C2_PRODUTO)

						If lPesoEmb

							If ImpNivel3()

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Atualiza separacao do pedido									³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								AtuSepEmb(SC2->C2_PEDIDO,SC2->C2_ITEMPV)

								aEmbBip     := {}
								nSaldoEmb   := 0
								nSaldoGrupo += 1
								cSaldoGrupo := PADL(AllTrim(Str(nSaldoGrupo))+"/"+StrZero(nTotalGrupo,2),17)
								If nSaldoGrupo == nTotalGrupo
									cSaldoGrupo := SPACE(20)
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

							EndIf

						EndIf

						_nQtd       := 0

					EndIf

					oTxtProdCod:Refresh()
					oTxtProdEmp:Refresh()
					oTxtQtdEmp:Refresh()
//		      oTxtDescric:=Refresh()
					oTxtEmbalag:Refresh()
					oTxtDescEmb:Refresh()
					oNumPed:Refresh()
					oSaldoEmb:Refresh()
					oNumOp:Refresh()
					oGetQtd:Refresh()
					_cNumEtqPA := Space(_nTamEtiq)
					oGetOp:SetFocus()

				EndIf
			Else
				_cNumEtqPA := Space(_nTamEtiq)
				oGetOp:Refresh()
				oGetOp:SetFocus()
				_lRet:=.F.
			EndIf

		Else
			U_MsgColetor("Esta etiqueta não pertence a embalagem nível 2.")
			_cNumEtqPA := Space(_nTamEtiq)
			oGetOp:Refresh()
			oGetOp:SetFocus()
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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SomaCxEstrut ºAutor  ³Michel Sander   º Data ³  09/29/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calcula a quantidade de embalagens				              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SomaCxEstrut(cCodEstru,nQtd,cNiv)

	Local __nVolume := 0

	SG1->(dbSetOrder(1))
	SG1->(dbSeek(xFilial("SG1")+cCodEstru))
	Do While SG1->(!EOf()) .And. SG1->G1_FILIAL+SG1->G1_COD == xFilial("SG1")+cCodEstru
		If SG1->G1_XXEMBNI == cNiv
			__nVolume := (nQtd * SG1->G1_QUANT)
			If Int(__nVolume) <> __nVolume
				__nVolume := Int(__nVolume)+1
			Endif
			Exit
		EndIf
		SG1->(dbSkip())
	EndDo

Return ( __nVolume )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SeparaEmb  ºAutor  ³Michel Sander     º Data ³  09/29/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca os produtos já separados para o pedido    	         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SeparaEmb(cPedSepara,cProdSepara,cNivelSep)

	LOCAl cSQL 	  	 := ""
	LOCAL cIndexQry := RetSQLName("XD1")+"1"
	LOCAL nSepara   := 0

	cSQL := "SELECT COUNT(*) NQTDECAIXA FROM "+RetSQLName("XD1")+" WITH(INDEX("+cIndexQry+")) WHERE "
	cSQL += "SUBSTRING(XD1_PVSEP,1,6) ='"+cPedSepara+"' AND "
	cSQL += "XD1_COD='"+cProdSepara+"' AND "
	cSQL += "XD1_NIVEMB='"+cNivelSep+"' AND "
	cSQL += "D_E_L_E_T_=''"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"SEP",.F.,.T.)
	nSepara := SEP->NQTDECAIXA
	SEP->(dbCloseArea())

Return ( nSepara )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VerifCxDispºAutor  ³Michel Sander     º Data ³  09/29/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica embalagens nivel 2 disponiveis para montagem 	  ±±
±±º          ³ de caixas nivel 3                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VerifCxDisp(cPedSepara,cNivelSep)

	LOCAl cSQL 	  	 := ""
	LOCAL nSepara   := 0

	cSQL := "SELECT COUNT(*) NQTDECAIXA FROM "+RetSQLName("XD1")+" (NOLOCK) WHERE D_E_L_E_T_ = '' AND XD1_PVSEP='' AND XD1_NIVEMB='"+cNivelSep+"' AND "
	cSQL += "XD1_COD IN (SELECT C6_PRODUTO FROM "+RetSQLName("SC6")+" JOIN "+RetSQLName("SB1")+" ON B1_FILIAL="+xFilial("SB1")+" AND   C6_FILIAL="+xFilial("SC6")+" AND B1_COD=C6_PRODUTO WHERE "
	cSQL += RetSQLName("SC6")+".D_E_L_E_T_='' AND "
	cSQL += RetSQLName("SB1")+".D_E_L_E_T_='' AND "
	cSQL += "C6_NUM = '"+cPedSepara+"') AND "
	cSQL += "XD1_OCORRE = '4'"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"SEP",.F.,.T.)
	nSepara := SEP->NQTDECAIXA
	SEP->(dbCloseArea())

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

Static Function AtuSepEmb(cPedSepara, cItemSepara)

	For nQ := 1 to Len(aEmbBip)

		If XD1->(dbSeek(xFilial("XD1")+aEmbBip[nQ]))

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza Separação												³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Reclock("XD1",.F.)
			XD1->XD1_PVSEP  := cPedSepara+cItemSepara
			XD1->(MsUnlock())

		EndIf

	Next

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RetEmbZW ºAutor  ³Michel Sander       º Data ³  09/29/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca a embalagem nivel 3 que será usada				         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RetEmbZW(cGrupEmb, nQtEmb, cNivEmb, cCliEmb, cLojEmb)

	LOCAL __CODEMB  := ""
	LOCAL __QTDEATE := 0
	LOCAL __PESO    := 0

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
					AADD(aEMB,{SZW->ZW_CODEMB, nQTEmb, SZW->ZW_PESO})
				EndIf
				__CODEMB  := SZW->ZW_CODEMB
				__QTDEATE := SZW->ZW_QTDEATE
				__PESO    := SZW->ZW_PESO
				SZW->(dbSkip())
			Enddo
			If Empty(aEMB)
				AADD(aEMB,{__CODEMB,	__QTDEATE, __PESO})
			EndIf
		Else
			AADD(aEMB, {__CODEMB,	__QTDEATE, __PESO})
		EndIf
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Busca a embalagem por cliente							  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do While SZW->(!Eof()) .And. SZW->ZW_FILIAL+SZW->ZW_GRUPO+SZW->ZW_CLIENTE+SZW->ZW_LOJA+SZW->ZW_NIVEL == xFilial("SZW")+cGrupEmb+cCLiEmb+cLojEmb+cNivEmb
			If nQTEmb >= SZW->ZW_QTDEDE .And. nQTEmb <= SZW->ZW_QTDEATE
				AADD(aEMB,{SZW->ZW_CODEMB, nQTEmb, SZW->ZW_PESO})
			EndIf
			__CODEMB  := SZW->ZW_CODEMB
			__QTDEATE := SZW->ZW_QTDEATE
			__PESO    := SZW->ZW_PESO
			SZW->(dbSkip())
		Enddo
		If Empty(aEMB)
			AADD(aEMB,{__CODEMB,	__QTDEATE, __PESO})
		EndIf
	EndIf

Return ( aEMB )

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

User Function CalPesoEmb(cPedPeso,cProdPeso)

	LOCAL nOpcPeso := 0

	Define MsDialog oTelaPeso Title OemToAnsi("Peso da Embalagem") From 20,20 To 180,200 Pixel of oMainWnd PIXEL
	nLin := 025
	@ nLin,005 Say oTxtPeso     Var "Peso" Pixel Of oTelaPeso
	@ nLin-2,025 MsGet oGetPeso Var nPesoBruto Valid nPesoBruto > 0 When .T. Picture "@E 99,999,999.9999" Size 60,10 Pixel Of oTelaPeso
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

	LOCAL cGrupo   := Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_GRUPO")
	LOCAL cCodCli  := Posicione("SA1",1,xFilial("SA1")+SC2->C2_CLIENT,"A1_COD")
	LOCAl cLojCli  := Posicione("SA1",1,xFilial("SA1")+SC2->C2_CLIENT,"A1_LOJA")
	cProxNiv := "3"
	If !SZG->(dbSeek(xFilial("SZG")+cCodCli+cLojCli+cGrupo))
		Aviso("Atenção","Não existe layout de etiqueta amarrado para esse Cliente x Grupo de produto.",{"Ok"})
		cTxtMsg  := " Não existe layout de etiqueta amarrado para esse Cliente x Grupo de produto." + Chr(13)
		cTxtMsg  += " Produto = " + SC2->C2_PRODUTO + Chr(13)
		cTxtMsg  += " Cliente = " + SC2->C2_CLIENT  + Chr(13)
		cAssunto := "Amarração Cliente x Grupo de Produto x Layout de Etiqueta"
		cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
		cPara    := 'denis.vieira@rdt.com.br;fabiana.santos@rdt.com.br;tatiane.alves@rosenbergerdomex.com.br;monique.garcia@rosenbergerdomex.com.br;daniel.cavalcante@rosenbergerdomex.com.br'
		cCC      := 'natalia.silva@rosenbergerdomex.com.br;keila.gamt@rosenbergerdomex.com.br;leonardo.andrade@rosenbergerdomex.com.br;gabriel.cenato@rosenbergerdomex.com.br;luiz.pavret@rdt.com.br' //chamado monique 015475
		cArquivo := Nil
		U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
		Return .T.
	EndIf

	__mv_par02 := XD1->XD1_OP
	__mv_par03 := Nil
	__mv_par04 := nQtdCaixa
	__mv_par05 := 1
	If !U_VALIDACAO()
		__mv_par06 := SZG->ZG_LAYOUT  // TRATADO
	Else
		__mv_par06 := SZG->ZG_LAYVALI
	EndIf
	lColetor   := .T.

	Do Case
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³LAYOUT 01 - HUAWEI UNIFICADA												   	³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case __mv_par06 == "01"
		lRotValid :=  U_DOMETQ04(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.F.,nPesoBruto,lColetor) 			// Validações de Layout 01
		If !lRotValid
			U_MsgColetor("A etiqueta não será impressa. Verifique os problemas com o  layout da etiqueta e repita a operação.")
			Return ( .F. )
		Else
			__mv_par02 := XD1->XD1_OP
			__mv_par03 := Nil
			__mv_par04 := nQtdCaixa
			__mv_par05 := 1
			If !U_VALIDACAO()
				__mv_par06 := SZG->ZG_LAYOUT  // TRATADO
			Else
				__mv_par06 := SZG->ZG_LAYVALI
			EndIf
			cRotina   := "U_DOMETQ04(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.T.,nPesoBruto,lColetor)"		// Impressão de Etiqueta Layout 01
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³LAYOUT 02 - 																			 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case __mv_par06 == "02"
		lRotValid :=  U_DOMETQ03(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.F.,nPesoBruto,lColetor) 			// Validações de Layout 02
		If !lRotValid
			U_MsgColetor("A etiqueta não será impressa. Verifique os problemas com o  layout da etiqueta e repita a operação.")
			Return ( .F. )
		Else
			__mv_par02 := XD1->XD1_OP
			__mv_par03 := Nil
			__mv_par04 := nQtdCaixa
			__mv_par05 := 1
			If !U_VALIDACAO()
				__mv_par06 := SZG->ZG_LAYOUT  // TRATADO
			Else
				__mv_par06 := SZG->ZG_LAYVALI
			EndIf
			cRotina := "U_DOMETQ03(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.T.,nPesoBruto,lColetor)" 	// Impressão de Etiqueta Layout 02
		EndIf
	Case __mv_par06 == "03"
		cRotina := "U_DOMETQ05(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.T.,nPesoBruto,lColetor)" //Layout 03
	Case __mv_par06 == "04"
		cRotina := "U_DOMETQ06(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.T.,nPesoBruto,lColetor)" //Layout 04 - Por Michel A. Sander
	Case __mv_par06 == "05"
		cRotina := "U_DOMETQ07(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.T.,nPesoBruto,lColetor)" //Layout 05 - Por Michel A. Sander
	Case __mv_par06 == "06"
		cRotina := "U_DOMETQ08(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.T.,nPesoBruto,lColetor)" //Layout 06 - Por Michel A. Sander
	Case __mv_par06 == "07"
		cRotina := "U_DOMETQ09(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.T.,nPesoBruto,lColetor)" //Layout 07 - Por Michel A. Sander
	Case __mv_par06 == "10"
		cRotina := "U_DOMETQ10(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.T.,nPesoBruto,lColetor)" //Layout 10 - Por Michel A. Sander
	Case __mv_par06 == "11"
		cRotina := "U_DOMETQ11(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.T.,nPesoBruto,lColetor)" //Layout 11 - Por Michel A. Sander
	Case __mv_par06 == "12"
		cRotina := "U_DOMETQ12(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.T.,nPesoBruto,lColetor)" //Layout 12 - Por MLS
	Case __mv_par06 == "13"
		cRotina := "U_DOMETQ13(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.T.,nPesoBruto,lColetor)" //Layout 13 - Por Michel A. Sander
	Case __mv_par06 == "14"
		cRotina := "U_DOMETQ14(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.T.,nPesoBruto,lColetor)" //Layout 13 - Por Michel A. Sander
	Case __mv_par06 == "31"
		cRotina := "U_DOMETQ31(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.T.,nPesoBruto,lColetor)" //Layout 31 - Por Michel A. Sander
	Case __mv_par06 == "36"
		cRotina := "U_DOMETQ36(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.T.,nPesoBruto,lColetor)" //Layout 36 - Por Michel A. Sander
	EndCase

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Executa rotina de impressao									³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//lRetEtq := &(cRotina)		// suspensao temporaria da impressao até que se defina o layout nivel 3 em 29.10.2015
	lRetEtq := .T.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Reinicia variáveis da tela										³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Return ( .T. )
