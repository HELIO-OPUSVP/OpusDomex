#include "totvs.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT500APO  �Autor  �Marco Aur�lio       � Data �  14/06/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada que roda depois da elimina��o de res�duos ���
���          � de Pedidos de Venda                                        ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function MT500APO()
Local cQryResid

//�������������������������������������������������������������������������������}
//�Atualiza Itens com Residuo                                                    �
//�������������������������������������������������������������������������������}
cQryResid := " UPDATE " + RetSqlName("SZY") + " SET ZY_BLQ = 'R' "
cQryResid += " FROM "+RetSqlName("SC6")+" SC6 LEFT JOIN " +RetSqlName("SZY")+" SZY ON C6_NUM+C6_ITEM = ZY_PEDIDO+ZY_ITEM "
cQryResid += " WHERE SC6.D_E_L_E_T_ = '' AND SZY.D_E_L_E_T_ = '' "
cQryResid += " AND  C6_BLQ = 'R' AND ZY_BLQ = '' "
cQryResid += " AND ZY_NOTA = '' "

TCSQLEXEC(cQryResid)

Return
