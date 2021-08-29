#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO10    �Autor  �Microsiga           � Data �  08/05/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function VZA_PROD()
Local _Retorno      := .F.
Private cLocProcDom := GetMV("MV_XXLOCPR")
SB1->( dbSetOrder(1) )

If !Empty(M->ZA_PRODUTO)
	If SB1->( dbSeek( xFilial() + M->ZA_PRODUTO ) )
		If Empty(M->ZA_OP)
			Msgstop("Favor preencher a Ordem de Produ��o antes do produto.")
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
										MsgStop("Este produto ainda n�o foi pago para esta Ordem de Produ��o."+Chr(10)+"N�o ser� poss�vel apontar perda para este produto.")
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
					// Verificar se o produto n�o � componente de algum PI que foi pago
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
										MsgStop("Este produto pertence a estrutura de um PI a ser pago para a OP."+Chr(10)+"N�o ser� poss�vel apontar perda para este produto.")
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
					
					// Aqui, se lTemp continuar com Falso, ou n�o � componente de PI, ou realmente n�o � utilizado na OP.
					//If lTemp
					If !_Retorno
						MsgStop("Produto n�o utlizado nesta Ordem de Produ��o.")
						_Retorno := .F.
						M->ZA_PRODUTO := Space(Len(M->ZA_PRODUTO))
					Else
						_Retorno := .T.
					EndIf
				EndIf
			Else
				MsgStop("Produto n�o utilizado nesta Ordem de Produ��o.")
				_Retorno := .F.
				M->ZA_PRODUTO := Space(Len(M->ZA_PRODUTO))
			EndIf
		EndIf
	Else
		MsgStop("Produto inv�lido.")
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
