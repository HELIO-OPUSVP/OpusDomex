#include "totvs.ch"


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA650I   �Autor  �Helio Ferreira      � Data �  06/06/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada executado depois da grava��o da OP para   ���
���          � Inclus�o MANUAL DE OP/POR VENDAS                           ���
���          � executado antes da grava��o dos empenhos                   ���  
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function MTA650I()

// Sem�foro Domex para inclus�o manual de OP

/*
	If GetMV("MV_XSEMAOP") == 'S'           // JOAO - COMENTADO
		If !Empty(__XXNumSeq) // JOAO - COMENTADO
		U_FNUMSEQ(__XXNumSeq)
		MsgINfo("MTA650I() - Depois da grava��o da OP manual/vendas e libera��o do sem�foro Domex")
		// RETIRADO Vanessa Faio PE dapois da grava��o da abertura de OP manual/vendas
		EndIf   // JOAO - COMENTADO
	EndIf  // JOAO - COMENTADO
*/

Return .T.
