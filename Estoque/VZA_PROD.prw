#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO10    ºAutor  ³Microsiga           º Data ³  08/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VZA_PROD()
Local _Retorno      := .F.
Private cLocProcDom := GetMV("MV_XXLOCPR")
SB1->( dbSetOrder(1) )

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
									
									If Empty(SUMD3QTD)
										MsgStop("Este produto ainda não foi pago para esta Ordem de Produção."+Chr(10)+"Não será possível apontar perda para este produto.")
										_Retorno := .F.
										M->ZA_PRODUTO := Space(Len(M->ZA_PRODUTO))
									Else
										_Retorno := .T.
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
						MsgStop("Produto não utlizado nesta Ordem de Produção.")
						_Retorno := .F.
						M->ZA_PRODUTO := Space(Len(M->ZA_PRODUTO))
					Else
						_Retorno := .T.
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
	_Retorno := .T.
EndIf

If _Retorno
	M->ZA_DESC := Posicione("SB1",1,xFilial("SB1")+M->ZA_PRODUTO,"B1_DESC")
Else
	M->ZA_DESC := Space(Len(M->ZA_DESC))
EndIf

Return _Retorno
