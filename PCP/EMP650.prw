#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EMP650    ºAutor  ³Hélio Ferreira      º Data ³  17/01/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada criado para substituir do empenho produtosº±±
±±º          ³ que não tenham saldo em estoque por seu alternativos.      º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex - PCP                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
nPosCod    :=aScan(aHeader,{|x| AllTrim(x[2])=="G1_COMP   "})
nPosQuant  :=aScan(aHeader,{|x| AllTrim(x[2])=="D4_QUANT  "})
nPosLocal  :=aScan(aHeader,{|x| AllTrim(x[2])=="D4_LOCAL  "})
nPosTrt    :=aScan(aHeader,{|x| AllTrim(x[2])=="G1_TRT    "})
nPosLote   :=aScan(aHeader,{|x| AllTrim(x[2])=="D4_NUMLOTE"})
nPosLotCTL :=aScan(aHeader,{|x| AllTrim(x[2])=="D4_LOTECTL"})
nPosDValid :=aScan(aHeader,{|x| AllTrim(x[2])=="D4_DTVALID"})
nPosPotenc :=aScan(aHeader,{|x| AllTrim(x[2])=="D4_POTENCI"})
nPosLocLz  :=aScan(aHeader,{|x| AllTrim(x[2])=="DC_LOCALIZ"})
nPosnSerie :=aScan(aHeader,{|x| AllTrim(x[2])=="DC_NUMSERI"})
nPosUM     :=aScan(aHeader,{|x| AllTrim(x[2])=="B1_UM     "})
nPosQtSegum:=aScan(aHeader,{|x| AllTrim(x[2])=="D4_QTSEGUM"})
nPos2UM    :=aScan(aHeader,{|x| AllTrim(x[2])=="B1_SEGUM  "})
nPosDescr  :=aScan(aHeader,{|x| AllTrim(x[2])=="B1_DESC   "})
*/

User Function EMP650()

	Local nPG1_COMP  := aScan(aHeader,{|x| AllTrim(x[2])=="G1_COMP"  })
	Local nPD4_QUANT := aScan(aHeader,{|x| AllTrim(x[2])=="D4_QUANT" })
	Local nPD4_LOCAL := aScan(aHeader,{|x| AllTrim(x[2])=="D4_LOCAL" })
	//Local nPD4_OPORI := aScan(aHeader,{|x| AllTrim(x[2])=="D4_OPORIG"})
	//Local nPD4_LOTE  := aScan(aHeader,{|x| AllTrim(x[2])=="D4_LOTECTL"})

	Local aAreaGER  := GetArea()
	Local aAreaSA1  := SA1->( GetArea() )
	Local aAreaSB1  := SB1->( GetArea() )
	Local aAreaSB2  := SB2->( GetArea() )
	Local cTexto    := ""
	Local x, y
	
	PRIVATE nSalDisp2 := 0 //MLS ERRO CHAMADO 032345

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Liberção do Semáforo Domex da Inclusão de OP por vendas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If GetMV("MV_XSEMAOP") == 'S'
		If Type("__XXNumSeq") == "U"
			Public __XXNumSeq := ""
		EndIf
		If Empty(__XXNumSeq)
			Public __XXNumSeq := U_INUMSEQ("EMP650() - Gravação de Empenho da OP: " + SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN)
			// OK Vanessa Faio PE antes da abertura da tela de ajuste de empenho
			//MsgInfo("EMP650()-Antes da abertura da tela de ajuste de empenho na inclusao de OP manual/vendas - Inclusão do Semáforo Domex")
		EndIf
	EndIf

	Private cLocProcDom := GetMV("MV_XXLOCPR")   // Local de Processos Domex

	If Type("cOPEMP650") == 'U'
		Public cOPEMP650 := ""
	EndIf

	If !GetMV("MV_XXEM650")
		Return
	EndIf

	SA1->( dbSetOrder(1) )
	SB1->( dbSetOrder(1) )
	SB2->( dbSetOrder(1) )

	For x := 1 to Len(aCols)
		If !aCols[x,Len(aHeader)+1]
			//  Produtos Alternativos
			//If SA1->( dbSeek( xFilial() + SC2->C2_CLIENT ) )
			//If SA1->A1_XXPROAL <> 'N'
			If SB1->( dbSeek( xFilial() + aCols[x,nPG1_COMP] ) )
				If !Empty(SB1->B1_ALTER) //.or. !Empty(SB1->B1_XXALTER)
					If SB2->( dbSeek( xFilial() + aCols[x,nPG1_COMP] ) )
				   /**/
						nSalDisp1 := 0
						While !SB2->( EOF() ) .and. SB2->B2_FILIAL == xFilial("SB2") .and. SB2->B2_COD == aCols[x,nPG1_COMP]
							nSalDisp1 += (SB2->B2_QATU - SB2->B2_QEMP)
							SB2->( dbSkip() )
						End

						If nSalDisp1 < aCols[x,nPD4_QUANT]
							// Não tem saldo suficiente do produto principal
							// Verificando o Alternativo 1
							If !Empty(SB1->B1_ALTER)
								If SB2->( dbSeek( xFilial() + SB1->B1_ALTER ) )
									nSalDisp2 := 0
									While !SB2->( EOF() ) .and. SB2->B2_FILIAL == xFilial("SB2") .and. SB2->B2_COD == SB1->B1_ALTER
										nSalDisp2 += (SB2->B2_QATU - SB2->B2_QEMP)
										SB2->( dbSkip() )
									End
									If nSalDisp2 >= aCols[x,nPD4_QUANT]
										cTexto := "O produto " + Alltrim(aCols[x,nPG1_COMP]) + " tem saldo de "+Alltrim(Transform(nSalDisp1,"@E 999,999,999.9999"))
										cTexto += " e não é suficiete para atender esta OP (c/ necessidade de "+Alltrim(Transform(aCols[x,nPD4_QUANT],"@E 999,999,999.9999"))+")." + Chr(13)
										cTexto += "Deseja utilizar o produto alternativo " + Alltrim(SB1->B1_ALTER) + " que tem saldo suficiente de "
										cTexto += Alltrim(Transform(nSalDisp2,"@E 999,999,999.9999"))+"?"
										If MsgYesNo( cTexto ,'')
											//Grava log
											RecLock("ZZL",.T.)
											ZZL->ZZL_FILIAL := xFilial("ZZL")
											ZZL->ZZL_DATA   := Date()
											ZZL->ZZL_OP     := SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN
											ZZL->ZZL_COD    := aCols[x,nPG1_COMP] 
											ZZL->ZZL_ALTER  := SB1->B1_ALTER
											ZZL->ZZL_OBS    := "Sld. Princ. "+ Alltrim(Transform(nSalDisp1,"@E 999,999,999.9999")) + "  Sld. Alter. " + Alltrim(Transform(nSalDisp2,"@E 999,999,999.9999"))
											ZZL->( MsUnLock() )
											//Muda empenho
											aCols[x,nPG1_COMP] := SB1->B1_ALTER
										EndIf
									Else
										//Quando o saldo do principal não é suficiente e do alternativo também não
										If MsgYesNo("O produto " + Alltrim(aCols[x,nPG1_COMP]) + " tem saldo de "+Alltrim(Transform(nSalDisp1,"@E 999,999,999.9999"))+" e não é suficiente para atender a OP ("+Alltrim(Transform(aCols[x,nPD4_QUANT],"@E 999,999,999.9999"))+")." + Chr(13) + "O produto alternativo " + Alltrim(SB1->B1_ALTER) + " tem saldo de "+Alltrim(Transform(nSalDisp2,"@E 999,999,999.9999"))+" e também não é suficiente." + Chr(13) + " Deseja utilizar o Produto Alternativo?",'')
											//Grava log
											RecLock("ZZL",.T.)
											ZZL->ZZL_FILIAL := xFilial("ZZL")
											ZZL->ZZL_DATA   := Date()
											ZZL->ZZL_OP     := SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN
											ZZL->ZZL_COD    := aCols[x,nPG1_COMP] 
											ZZL->ZZL_ALTER  := SB1->B1_ALTER
											ZZL->ZZL_OBS    := "Sld. Princ. "+ Alltrim(Transform(nSalDisp1,"@E 999,999,999.9999")) + "  Sld. Alter. " + Alltrim(Transform(nSalDisp2,"@E 999,999,999.9999"))
											ZZL->( MsUnLock() )
											//Muda empenho										
											aCols[x,nPG1_COMP] := SB1->B1_ALTER
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
					/**/
					EndIf
				Else
					If SB1->( dbSeek( xFilial() + aCols[x,nPG1_COMP] ) )
						If SB1->B1_TIPO <> 'PI'
							// Alterado por MICHEL A. SANDER em 03.07.2014
							// Verifica Componente sem movimentação de estoque
							lNotSB2 := .F.
							If !SB2->( dbSeek( xFilial() + aCols[x,nPG1_COMP] ) )
								lNotSB2 := .T.
							EndIf

							If SB2->( dbSeek( xFilial() + aCols[x,nPG1_COMP] ) )  .Or. lNotSB2		// Passa a verificar componente sem movimentação de estoque
								nSalDisp1 := 0
								aSalDisp1 := {}
								While !SB2->( EOF() ) .and. SB2->B2_FILIAL == xFilial("SB2") .and. SB2->B2_COD == aCols[x,nPG1_COMP]
									nSalDisp1 += (SB2->B2_QATU - SB2->B2_QEMP)
									If !Empty(SB2->B2_QATU - SB2->B2_QEMP)
										AADD(aSalDisp1, {SB2->B2_LOCAL,SB2->B2_QATU - SB2->B2_QEMP } )
									EndIf
									SB2->( dbSkip() )
								End

								If nSalDisp1 < aCols[x,nPD4_QUANT]
									Reclock("SZN",.T.)
									SZN->ZN_FILIAL := xFilial("SZN")
									SZN->ZN_TIPO   := '001'
									SZN->ZN_DATA   := Date()
									SZN->ZN_TEXTO  := aCols[x,nPG1_COMP] + SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN + Transform(aCols[x,nPD4_QUANT],"@E 999,999,999,999.9999")
									SZN->( msUnlock() )

									// Alterado por MICHEL A. SANDER em 03.07.2014
									// Verifica Componente sem movimentação de estoque ou se não existe saldo suficiente
									cTexto := IIf( lNotSB2, "Produto sem movimento de estoque "        + Alltrim(aCols[x,nPG1_COMP]) + ".",;
										"Não existe saldo suficiente do produto: " + Alltrim(aCols[x,nPG1_COMP]) + "." )

									cTexto += Chr(13) + "Necessidade da OP: " + Transform(aCols[x,nPD4_QUANT],"@E 999,999,999,999.9999")
									If !Empty(aSalDisp1)
										cTexto += Chr(13)
										For Y := 1 to Len(aSalDisp1)
											cTexto += Chr(13) + "Local: " + aSalDisp1[Y,1] + "   Qtd: " + Transform(aSalDisp1[Y,2],"@E 999,999,999.999")
										Next x
									EndIf
									If !Empty(aSalDisp1)
										cTexto += Chr(13)
									EndIf
									cTexto += Chr(13) + "Disponibilidade total: " + Transform(nSalDisp1,"@E 999,999,999.999")

									If cOPEMP650 <> Subs(SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN,1,11)
										cOPEMP650 := Subs(SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN,1,11)
										//MsgStop("Existe falta de materiais para a OP: " + cOPEMP650 + ".")
									EndIf

									//MsgStop(cTexto)
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			//EndIf
			//EndIf

			// Armazém de Processos 97
			If SB1->( dbSeek( xFilial() + aCols[x,nPG1_COMP] ) )//aCols[x,nPD4_COD]- Pesquisa pelo código do componente na estrutura.
				If aCols[x,nPD4_LOCAL] <> GetMV("MV_LOCPROC")   // Local de Processos padrão
					If aCols[x,nPD4_LOCAL] <> cLocProcDom
						If SB1->B1_TIPO <> 'MO' .and. SB1->B1_TIPO <> 'SI'
							// Identificando produtos de Silk
							//SG1->( dbSetOrder(1) )
							//lSilk := .F.
							//If SG1->( dbSeek( xFilial() + aCols[x,nPG1_COMP] ) )
							//	While !SG1->( EOF() ) .and. SG1->G1_COD == aCols[x,nPG1_COMP]
							//		If Subs(SG1->G1_COMP,1,6) == '500960'
							//			lSilk := .T.
							//			Exit
							//		EndIf
							//		SG1->( dbSkip() )
							//	End
							//EndIf

							//If !lSilk
							//If msgNoYes("Deseja abrir os empenhos no armazém 97?")
							aCols[x,nPD4_LOCAL] := cLocProcDom
							//EndIf
							//EndIf
						EndIf
					EndIf
				EndIf
			EndIf

			//If Rastro(aCols[x,nPG1_COMP])
			//   aCols[x,nPD4_LOTE] := U_RetLotC6(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
			//EndIf
		EndIf
	Next x

	RestARea(aAreaSA1)
	RestARea(aAreaSB1)
	RestARea(aAreaSB2)
	RestArea(aAreaGER)


Return
