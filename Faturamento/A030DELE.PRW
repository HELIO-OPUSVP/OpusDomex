#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M020INC   �Autor  �Helio Ferreira      � Data �  05/07/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada na exclus�o de Cadastro de Clientes       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/
//Teste osmar 
//Teste Osmar 2

User Function A030DELE()

//JONAS TESTE 12345	

//JONAS TESTE 2
///JONAS 3
// MARCO - TESTE 99

MsgInfo('Passando pelo Ponto de Entrada de Exclus�o do Item Cont�bil do Cliente.')
CTD->(dbSetOrder(1))
If CTD->(dbSeek(xFilial("CTD")+"C"+SA1->A1_COD+SA1->A1_LOJA))
	If RecLock("CTD",.F.)
		MsgInfo('Item Cont�bil ' + "C"+SA1->A1_COD+SA1->A1_LOJA + ' exclu�do.')
		CTD->( dbDelete() )
		CTD->( MsUnlock() )
	Else
	   MsgStop('N�o foi poss�vel travar o registro do Item Cont�bil para exclus�o.')
	EndIf
Else
   MsgStop('N�o foi encontrado o Item Cont�bil: ' + "C"+SA1->A1_COD+SA1->A1_LOJA)
EndIf

Return
