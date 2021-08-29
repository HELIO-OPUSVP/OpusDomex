#include "totvs.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TRATASE1  ºAutor  ³Helio e Marco       º Data ³  28/06/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Transfere Titulo para CObranca Descontada - BCO ITAU      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TRATASE1(cNota, cSerie,cCliente,cLoja)

SE1->( dbSetOrder(1) )
SD2->( dbSetOrder(3) )
SF2->( dbSetOrder(1) )
SC5->( dbSetOrder(1) )

If SF2->( dbSeek( xFilial() + cNota + cSerie ) )
	If SD2->( dbSeek( xFilial() + SF2->F2_DOC + SF2->F2_SERIE ) )
		If SC5->( dbseek( xFilial() + SD2->D2_PEDIDO ) )
			If !Empty(SC5->C5_XAUTCC)
				If SE1->( dbSeek( xFilial() + SF2->F2_PREFIXO + SF2->F2_DUPL ) )
					While !SE1->( EOF() ) .and. SE1->E1_FILIAL == xFilial("SE1") .and. SE1->E1_PREFIXO == SF2->F2_PREFIXO .and. SE1->E1_NUM == SF2->F2_DUPL
						If Alltrim(SE1->E1_TIPO) == 'NF'
							Reclock("SE1",.F.)   
								SE1->E1_PORTADO := "341"
								SE1->E1_AGEDEP	 := "1529" 
								SE1->E1_CONTA   := "01594-1"
								SE1->E1_MOVIMEN := ddatabase
								SE1->E1_SITUACA := '3' 						
								SE1->E1_VENCTO  := SC5->C5_XDTAUT + 30
								SE1->E1_VENCREA := DataValida(SE1->E1_VENCTO,.T.)
							SE1->( msUnlock() )
						EndIf
						SE1->( dbskip() )
					End
				EndIf
			EndIf
		EndIf
	EndIf
EndIf

Return
