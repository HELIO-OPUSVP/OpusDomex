
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RDM_A650LGVEN�Autor  �Microsiga           � Data �  10/21/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function A650LGVEN()

Local lVermelha  :=.T. 
Local cPedido    := SC6->C6_NUM
Local aAreaSC5   := SC5->(GetArea())

If Substr(Alltrim(cPedido),1,2) =="OF"
	
	DbSelectArea("SC5")
	SC5->(dbSetOrder(1))
	If SC5->(dbSeek(xFilial("SC5")+SC6->C6_NUM))
		// Customizacao do usu�rio (retornar branco ou "X" atrav�s de express�o ADVPL para a condi��o para a legenda vermelha)
		// No exemplo abaixo, considera legenda vermelha (bloqueado para gera��o de OP) os pedidos de venda do cliente "C00003"
		If C5_FECHADO =="2"
			lVermelha  :="If(.F.,' ','X')"
		EndIf
	EndIf
EndIF
RestArea(aAreaSC5)
  
Return (lVermelha)