#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA010MNU �Autor  �Helio Ferreira      � Data �  30/03/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Bot�o no browse de apontamento de produ��o para estorno    ���
���          � de apontamentos personalizados gerados pela PRODDOMEX.prw. ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function MT250MNU()

aAdd(aRotina,{"Estorno Prod. Domex", "U_ESTPRODOM()" , 0 , 4, 0, nil} )

Return