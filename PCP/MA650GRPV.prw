#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA650GRPV ºAutor  ³Helio Ferreira      º Data ³  02/09/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada já existente no projeto e sem documentaçãoº±±
±±º          ³                                                            º±±
±±º          ³ Roda na geração de OP por vendas para gravações no SC6,    º±±
±±º          ³ estando posicionado no SC2                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MA650GRPV()
	Local aArea    := GetArea()
	Local aAreaSC6 := SC6->(GetArea())
	Local aAreaSC2 := SC2->(GetArea())
	Local aAreaSA1 := SA1->(GetArea())
	Local aAreaSC5 := SC5->(GetArea())
	Local aCustos

	/*
	AADD(aPedOP,{cNumOp})
	AADD(aPedOP1,{cNumOp,cItemOP,cSeqC2})
	// Chama ponto de entrada para gravacao no SC6
	If lPEGrava
	ExecBlock('MA650GRPV',.F.,.F.,)
	EndIf
	*/                                                                           

	SC5->( dbSetOrder(1) )
	If !Empty(SC2->C2_PEDIDO)
		If SC5->( dbSeek( xFilial() + SC2->C2_PEDIDO ) )
			If !Reclock("SC5",.F.)
				MsgStop("Pedido de Vendas da OP sendo alterado por outro usuário. Não será possível amarrar o lote da OP ao Pedido de Vendas.")
			EndIf
			SC5->( msUnlock() )
		EndIf
	EndIf

	//If Alltrim(cSeqC2) == '001'
	Reclock("SC6",.F.)
	SC6->C6_LOTECTL := cNumOp+cItemOP//+"01" // Subs(cSeqC2,2,2)   // U_RETLOTC6(cNumOp)
	If SC6->C6_LOCAL == '13'
		SC6->C6_LOCALIZ := "13PRODUCAO"
	EndIf
	SC6->( msUnlock() )
	//EndIf

	SC2->(dbSetOrder(1))
	SC5->(dbSetOrder(1))
	If SC5->(dbSeek(xFilial("SC5")+SC6->C6_NUM))
		If U_VALIDACAO("HELIO")
			If SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
				If SC2->(dbSeek(xFilial()+cNumOp+cItemOp))
					While SC2->(!EOF()) .and. SC2->C2_FILIAL+SC2->C2_NUM+SC2->C2_ITEM == xFilial("SC2")+cNumOp+cItemOp
						If Reclock("SC2",.F.)
							SC2->C2_CLIENT  := SA1->A1_COD
							If SC2->( FieldPos("C2_XLOJA") ) > 0
								SC2->C2_XLOJA   := SA1->A1_LOJA
							EndIf
							SC2->C2_NCLIENT := SA1->A1_NOME
							SC2->(msUnlock())
						Endif
						SC2->(dbSkip())
					Enddo
				Endif
			Endif
		Else
			If SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE))
				If SC2->(dbSeek(xFilial("SC2")+cNumOp+cItemOp))
					While SC2->(!EOF()) .and. SC2->C2_FILIAL+SC2->C2_NUM+SC2->C2_ITEM == xFilial("SC2")+cNumOp+cItemOp
						If Reclock("SC2",.F.)
							SC2->C2_CLIENT := SA1->A1_COD
							SC2->C2_NCLIENT := SA1->A1_NOME
							SC2->(msUnlock())
						Endif
						SC2->(dbSkip())
					Enddo
				Endif
			Endif
		EndIf
	Endif

	RestArea(aAreaSA1)
	RestArea(aAreaSC5)
	RestArea(aAreaSC2)
	RestArea(aAreaSC6)
	RestArea(aArea)


	aCustos   := U_CustEmp(SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN)

	nCusMedio := aCustos[1]
	cStatus   := aCustos[2]

	If U_VALIDACAO("MAURICIO")
		IF nCusMedio <=999999 //MLS TEMPORARIO ESTOURO CUSTO
			RecLock("SC2",.F.)
			SC2->C2_XCUSUNI := nCusMedio
			SC2->C2_XSTACUS := cStatus
			SC2->(MsUnlock())
		ENDIF
		RecLock("SC2",.F.)
		SC2->C2_XCUSUNI := nCusMedio
		SC2->C2_XSTACUS := cStatus
		SC2->(MsUnlock())
	ENDIF

Return Nil
