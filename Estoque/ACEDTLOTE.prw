#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ACEDTLOTE �Autor  �Helio Ferreira      � Data �  26/07/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina criada para mudar a data de validade de todos os    ���
���          � lotes para 31/12/2049.                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/


User Function ACEDTLOTE()

MsgRun("Aguarde...","Processando...",{|| Processando() })

Return


Static Function Processando()

cQuery := "UPDATE " + RetSqlName("SD5") + " SET D5_DTVALID = '20491231' WHERE D5_DTVALID <> '20491231' "
TCSQLEXEC(cQuery)

cQuery := "UPDATE " + RetSqlName("SB8") + " SET B8_DTVALID = '20491231' WHERE B8_DTVALID <> '20491231' "
TCSQLEXEC(cQuery)

Return
