#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "totvs.ch"
#INCLUDE "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DMX_C6ZY   �Autor  �Microsiga          � Data �  01/07/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza Cod do Produto no SZY quando for diferente do SC6 ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DMX_C6ZY()

cQuery := ""
cQuery += " UPDATE " + RetSqlName("SZY") + "  SET ZY_PRODUTO=C6_PRODUTO,ZY_DESC=C6_DESCRI "
cQuery += " FROM " + RetSqlName("SC6") + " SC6 " 
cQuery += "     LEFT JOIN " + RetSqlName("SZY") + " SZY ON C6_NUM+C6_ITEM=ZY_PEDIDO+ZY_ITEM " 	 
cQuery += " WHERE SC6.D_E_L_E_T_ = '' AND SZY.D_E_L_E_T_ = ''  AND ZY_FILIAL = '"+xFilial("SZY")+"' " 
cQuery += " AND C6_PRODUTO <> ZY_PRODUTO "
cQuery += " AND C6_FILIAL = '"+xFilial("SC6")+"'"
TCSQLEXEC(cQuery) 

Return
