#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VZA_QTDORI ºAutor  ³Helio Ferreira     º Data ³  05/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VZA_QTDORI()

Local _Retorno := .F.
Local aAreaGER := GetArea()
Local aAreaSZA := SZA->( GetArea() )
Local cQry := ''
Local nSaldoSD4 := 0
Local _nX := 0

/*
If !Empty(M->ZA_QTDORI)
If !Empty(M->ZA_PRODUTO)
SD4->( dbSetOrder(1) )  // Filial + Produto + OP
If SD4->( dbSeek( xFilial() + M->ZA_PRODUTO + M->ZA_OP) )
If SD4->D4_LOCAL <> GetMV("MV_LOCPROC")
If SB1->( dbSeek( xFilial() + SD4->D4_COD ) )
If SB1->B1_TIPO <> 'MO'
nQtdPG := SD4->D4_QTDEORI - SD4->D4_QUANT

cQuery := "SELECT SUM(D3_QUANT) AS SUMD3QTD FROM " + RetSqlName("SD3") + " WHERE D3_COD = '"+SD4->D4_COD+"' AND D3_XXOP = '"+SD4->D4_OP+"' AND D3_ESTORNO = '' AND D3_CF = 'DE4' AND D3_LOCAL = '"+GetMV("MV_XXLOCPR")+"' AND D_E_L_E_T_ = '' "

If Select("TEMP") <> 0
TEMP->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "TEMP"

nQtdPG += TEMP->SUMD3QTD

SZA->( dbSetOrder(1) )
nTotPerda := 0
If SZA->( dbSeek( xFilial() + M->ZA_OP + M->ZA_PRODUTO ) )
While !SZA->( EOF() ) .and. SZA->ZA_FILIAL == xFilial("SZA") .and. SZA->ZA_OP + SZA->ZA_PRODUTO == M->ZA_OP + M->ZA_PRODUTO
nTotPerda += SZA->ZA_QTDORI
nTotPerda -= (SZA->ZA_QTDORI - SZA->ZA_SALDO)
SZA->( dbSkip() )
End
EndIf

If M->ZA_QTDORI > (nQtdPG - nTotPerda)
MsgStop("Quantidade maior que o total já entregue para esta OP.")
_Retorno := .F.
EndIf
EndIf
EndIf
EndIf
Else
MsgStop("Produto não utilizado nesta ordem de Produção.")
_Retorno := .F.
EndIf
Else
MsgStop("Favor preencher o produto antes da quantidade da perda.")
_Retorno     := .F.
M->ZA_QTDORI := 0
EndIf
EndIf

If _Retorno
M->ZA_SALDO := M->ZA_QTDORI
Else
M->ZA_SALDO := 0
EndIf
*/

//////////////////////////////////////////////////////////////////////////////////////////////

Private cLocProcDom := GetMV("MV_XXLOCPR")
SB1->( dbSetOrder(1) )

if IsInCallStack("U_DOMPERDA")
	nPosProd := aScan( aHeader, {|x| Alltrim(x[2]) == "ZA_PRODUTO" } )
	nPosOP 	 := aScan( aHeader, {|x| Alltrim(x[2]) == "ZA_OP" } )
	nPosSaldo := aScan( aHeader, {|x| Alltrim(x[2]) == "ZA_SALDO" } )
	M->ZA_PRODUTO := oGetdados:aCols[oGetdados:nAt][nPosProd]	
	M->ZA_OP := oGetdados:aCols[oGetdados:nAt][nPosOP]
	M->ZA_SALDO := oGetdados:aCols[oGetdados:nAt][nPosSaldo]
EndIf

If !Empty(M->ZA_QTDORI)
	//Ajustado para validar a digitação da quanitade na tela de perda.
	
	If !Empty(M->ZA_PRODUTO)
		If SB1->( dbSeek( xFilial() + M->ZA_PRODUTO ) )
			If Empty(M->ZA_OP)
				Msgstop("Favor preencher a Ordem de Produção antes do produto.")
				_Retorno := .F.
				M->ZA_PRODUTO := Space(Len(M->ZA_PRODUTO))
			Else
				SD4->( dbSetOrder(2) )
				If SD4->( dbSeek( xFilial() + M->ZA_OP ) )
					//lTemp   := .F.
					aProdPG := {}
					While !SD4->( EOF() ) .and. Rtrim(SD4->D4_OP) == Rtrim(M->ZA_OP)
						If Empty(SD4->D4_OPORIG)
							AADD(aProdPG,SD4->D4_COD)
							If SD4->D4_COD == M->ZA_PRODUTO
								If SB1->( dbSeek( xFilial() + SD4->D4_COD ) )
									
									If SB1->B1_TIPO <> 'MO' .and. SD4->D4_LOCAL <> GetMV("MV_LOCPROC")
										
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
										
										//SUMD3QTD      := SUMD3QTD - (SD4->D4_QTDEORI - SD4->D4_QUANT) // Diminuindo o que já foi consumido por apontamentos

										//Inicio - Corrige D4_QUANT zerado - Osmar Ferreira 25/11/2020							
										If SD4->D4_QUANT = 0 
												
											cQry := " Select D4_COD, ((C2_QUANT - C2_QUJE)*G1_QUANT) As SALDO "
											cQry += " From SD4010 SD4 With(Nolock) "
											cQry += " Inner join SC2010 SC2 With(Nolock) On SC2.D_E_L_E_T_ = '' And C2_FILIAL = D4_FILIAL And C2_NUM+C2_ITEM+C2_SEQUEN = D4_OP "
											cQry += " Inner Join SG1010 SG1 With(Nolock) On SG1.D_E_L_E_T_ = '' And G1_FILIAL = C2_FILIAL And G1_COD = C2_PRODUTO ANd G1_COMP = D4_COD "
											cQry += " Where SD4.D_E_L_E_T_ = '' And D4_COD = '"+SD4->D4_COD+"' And D4_QUANT = 0  And C2_QUANT > C2_QUJE And D4_OP = '"+Rtrim(SD4->D4_OP)+"'"
											
											If Select("tbSld") <> 0
												tbSld->( dbCloseArea() )
											EndIf

											dbusearea(.t.,"TOPCONN",TCGenQRY(,,cQry),"tbSld",.f.,.t.)
											nSaldoSD4 := tbSld->SALDO
											tbSld->(dbCloseArea())				
									
											RecLock("SD4",.f.)
											SD4->D4_QUANT := nSaldoSD4
											SD4->( msUnLock() )
									
										EndIf
										//Fim - Corrige D4_QUANT zerado - Osmar Ferreira 25/11/2020

										nQtdConsumoOP := SD4->D4_QTDEORI - SD4->D4_QUANT
										
										SZA->( dbSetOrder(1) )
										nTotPerda := 0
										If SZA->( dbSeek( xFilial() + M->ZA_OP + M->ZA_PRODUTO ) )
											While !SZA->( EOF() ) .and. SZA->ZA_FILIAL == xFilial("SZA") .and. SZA->ZA_OP + SZA->ZA_PRODUTO == M->ZA_OP + M->ZA_PRODUTO
												//nTotPerda += SZA->ZA_QTDORI
												nTotPerda += (SZA->ZA_QTDORI - SZA->ZA_SALDO)
												SZA->( dbSkip() )
											End
										EndIf
										
										If Empty(SUMD3QTD)
											MsgStop("Este produto ainda não foi pago para esta Ordem de Produção."+Chr(10)+"Não será possível apontar perda para este produto.")
											M->ZA_PRODUTO := Space(Len(M->ZA_PRODUTO))
										Else
											If (SUMD3QTD - nQtdConsumoOP) <= 0
												MsgStop(;
												"Este produto foi pago mas já foi consumido por apontamentos desta OP."+Chr(13)+;
												"Quantidade paga: "+Alltrim(Transform(SUMD3QTD,"@E 999,999,999.9999"))+Chr(13)+;
												"Quantidade consumida por apontamentos: "+Alltrim(Transform(nQtdConsumoOP,"@E 999,999,999.9999"))+Chr(13)+;
												"Não será possível apontar perda para este produto.")
												M->ZA_PRODUTO := Space(Len(M->ZA_PRODUTO))
												M->ZA_QUANT   := 0
											Else
												If M->ZA_QTDORI > ((SUMD3QTD- nQtdConsumoOP) + nTotPerda)
													MsgStop("Quantidade maior que o saldo disponível desta OP (qtd. pagamentos - consumos por apontamento + perdas já lançadas).")
													_Retorno := .F.
													M->ZA_QTDORI := 0
												Else
													_Retorno := .T.
												EndIf
											EndIf
										EndIf
									Else
										_Retorno := .T.
									EndIf
									//EndIf
								EndIf
							EndIf
						EndIf
						SD4->( dbSkip() )
					End
					
					If !_Retorno
						//If !lTemp
						// Verificar se o produto não é componente de algum PI que foi pago
						SG1->( dbSetOrder(1) )
						
						For _nX := 1 to Len(aProdPG)
							If SG1->( dbSeek( xFilial() + aProdPG[_nX] ) )
								While !SG1->( EOF() ) .and. SG1->G1_COD == aProdPG[_nX]
									If SG1->G1_COMP == M->ZA_PRODUTO
										
										SD3->(DbOrderNickName("USUSD30001"))  // D3_FILIAL + D3_XXOP + D3_COD   tratado
										SUMD3QTD := 0
										
										If SD3->( dbSeek( xFilial() + M->ZA_OP + '  '+ SG1->G1_COD ) )
											While !SD3->( EOF() ) .and. Subs(M->ZA_OP,1,11) + SG1->G1_COD == Subs(SD3->D3_XXOP,1,11) + SD3->D3_COD  // tratado
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
										
										If Empty(SUMD3QTD)
											MsgStop("Este produto pertence a estrutura de um PI a ser pago para a OP."+Chr(10)+"Não será possível apontar perda para este produto.")
											M->ZA_PRODUTO := Space(Len(M->ZA_PRODUTO))
										Else
											_Retorno := .T.
										EndIf
										_nX := Len(aProdPG)
										Exit
									EndIf
									SG1->( dbSkip() )
								End
							EndIf
						Next _nX
						
						// Aqui, se lTemp continuar com Falso, ou não é componente de PI, ou realmente não é utilizado na OP.
						//If lTemp
						If !_Retorno
							//MsgStop("Produto não utlizado nesta Ordem de Produção.")
							//_Retorno := .F.
							M->ZA_PRODUTO := Space(Len(M->ZA_PRODUTO))
						//Else
							//_Retorno := .T.
						EndIf
					EndIf
				Else
					MsgStop("Produto não utilizado nesta Ordem de Produção.")
					_Retorno := .F.
					M->ZA_PRODUTO := Space(Len(M->ZA_PRODUTO))
				EndIf
			EndIf
		Else
			MsgStop("Produto inválido.")
		EndIf
	Else
		Msgstop("Favor preencher o produto antes da quantidade.")
		_Retorno := .F.
	EndIf
	
	If _Retorno
		M->ZA_DESC := Posicione("SB1",1,xFilial("SB1")+M->ZA_PRODUTO,"B1_DESC")
	Else
		M->ZA_DESC := Space(Len(M->ZA_DESC))
	EndIf
	
	If _Retorno
		M->ZA_SALDO := M->ZA_QTDORI
		If IsInCallStack("U_DOMPERDA")
			oGetdados:aCols[oGetdados:nAt][nPosSaldo] := M->ZA_QTDORI
		EndIf
	Else
		M->ZA_SALDO := 0
	EndIf
Else
	If IsInCallStack("U_DOMPERDA")
		M->ZA_SALDO := M->ZA_QTDORI
		oGetdados:aCols[oGetdados:nAt][nPosSaldo] := M->ZA_QTDORI
	EndIf	
	_Retorno := .T.
EndIf

RestArea(aAreaSZA)
RestArea(aAreaGER)

Return _Retorno
