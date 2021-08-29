#include "rwmake.ch"

User Function GQREENTR()

Local _aAreaGER   := GetArea()
Local _aAreaSD1   := SD1->( GetArea() )
Local _aAreaSF4   := SF4->( GetArea() )
Local _aAreaSB1   := SB1->( GetArea() )
Local _aAreaSD7   := SD7->( GetArea() )
Local _aAreaSDA   := SDA->( GetArea() )
Local _aAreaSBE   := SBE->( GetArea() )
Local _aAreaSDB   := SDB->( GetArea() )
Local _aAreaXD1   := XD1->( GetArea() )
Local _aAreaSC2   := SC2->( GetArea() )
Local _aAreaSG1   := SG1->( GetArea() )
Local _aAreaSD3   := SD3->( GetArea() )
Local _aAreaSD4   := SD4->( GetArea() )

Private lMsHelpAuto := .T.
Private lMsErroAuto := .F.

// Apontamento automático de OP de silk



RETURN




SD1->( dbSetOrder(1) )  // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM

SD1->( dbSeek( xFilial() + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA ) )

While !SD1->( EOF() ) .and. SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA == SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA
	aEmpenhos := {}
	SC2->( dbSetOrder(1) )
	SD4->( dbSetOrder(2) )
	If !Empty(SD1->D1_TES)
		If !Empty(SD1->D1_OP)
			If SC2->( dbSeek( xFilial() + Subs(SD1->D1_OP,1,11) ) )
				If SB1->( dbSeek( xFilial() + SC2->C2_PRODUTO ) )
					If SD4->( dbSeek( xFilial() + Subs(SD1->D1_OP,1,11) ) )
						lTotal := .T.
						While !SD4->( EOF() ) .and. Subs(SD4->D4_OP,1,11) == Subs(SD1->D1_OP,1,11)
							AADD(aEmpenhos,{SD4->D4_COD, SD4->D4_QTDEORI, SD4->D4_QUANT})
							If !Empty(SD4->D4_QUANT)
								lTotal := .F.
							EndIf
							SD4->( dbSkip() )
						End
						
						If !Empty(aEmpenhos)
							nPercent := 100
							
							If !lTotal
								For x := 1 to Len(aEmpenhos)
									If (((aEmpenhos[x,2] - aEmpenhos[x,3]) / aEmpenhos[x,2]) * 100) < nPercent
										nPercent := ((aEmpenhos[x,2] - aEmpenhos[x,3]) / aEmpenhos[x,2]) * 100
									EndIf
								Next x
							EndIf
							
							nPerApont := nPercent - ((SC2->C2_QUJE / SC2->C2_QUANT) * 100)
							nQtdApont := (nPerApont / 100) * SC2->C2_QUANT
							
							If !Empty(nQtdApont)
								cTM         := "010"
								//_cDocumento := U_NEXTDOC()
								_aCampos    := {}
								
								//Aadd(_aCampos,{"D3_UM     " , _UM                           , NIL })
								//Aadd(_aCampos,{"D3_DOC    " , _cDocumento                   , NIL })
								//Aadd(_aCampos,{"D3_EMISSAO" , DDATABASE                       , NIL })
								
								Aadd(_aCampos,{"D3_TM     " , cTM                             , NIL })
								Aadd(_aCampos,{"D3_OP     " , Subs(SD1->D1_OP,1,11)           , NIL })
								Aadd(_aCampos,{"D3_LOCAL  " , SC2->C2_LOCAL                   , NIL })
								Aadd(_aCampos,{"D3_COD    " , SC2->C2_PRODUTO                 , NIL })
								Aadd(_aCampos,{"D3_QUANT  " , nQtdApont                       , NIL })
								Aadd(_aCampos,{"D3_PARCTOT" , 'P'                             , NIL })
								
								Private lMsHelpAuto    := .T.
								Private lMsErroAuto    := .F.
								
								If SB1->B1_NUMCQPR == 0
									Reclock("SB1",.F.)
									SB1->B1_NUMCQPR := 1
									SB1->( msUnlock() )
								EndIf
								
								nBkpModulo := nModulo
								nModulo    := 4
								
								MSExecAuto({|x,y| mata250(x,y)},_ACAMPOS,3)  // 3-Inclusao   // MATA250() - Apontamento de Produção
								
								If lMsErroAuto
								//MsgStop("Erro no apontamento de produção automático.")
								//Mostraerro()
								cAssunto := 'Erro no apontamento automático de OP: ' + Subs(SD1->D1_OP,1,11)
								cTexto   := 'Erro no apontamento automático da OP: ' + Subs(SD1->D1_OP,1,11) + '<br>' + 'Quantidade: ' + Transform(nQtdApont,'@E 999,999,999.9999')
								cPara    := 'helio@opusvp.com.br;denis.vieira@rdt.com.br;vanessa.faio@rdt.com.br'
								cCC      := ''
								cArquivo := Nil
								U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
								Else
								//MsgStop("Apontamento automático de produção realizado com sucesso.")
								cAssunto := 'Apontamento automático de OP: ' + Subs(SD1->D1_OP,1,11)
								cTexto   := 'Apontamento automático da OP: ' + Subs(SD1->D1_OP,1,11) + '<br>' + 'Quantidade: ' + Transform(nQtdApont,'@E 999,999,999.9999')
								cPara    := 'helio@opusvp.com.br;denis.vieira@rdt.com.br;vanessa.faio@rdt.com.br'
								cCC      := ''
								cArquivo := Nil
								U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
								EndIf

								nModulo := nBkpModulo
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	
	SD1->( dbSkip() )
End

RestArea(_aAreaSG1)
RestArea(_aAreaSC2)
RestArea(_aAreaSD3)
RestArea(_aAreaSD4)
RestArea(_aAreaSB1)
RestArea(_aAreaSD7)
RestArea(_aAreaSDA)
RestArea(_aAreaSBE)
RestArea(_aAreaSDB)
RestArea(_aAreaXD1)
RestArea(_aAreaSF4)
RestArea(_aAreaSD1)
RestArea(_aAreaGER)

Return
