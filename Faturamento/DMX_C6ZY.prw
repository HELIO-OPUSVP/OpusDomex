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
cQuery += "     LEFT JOIN " + RetSqlName("SZY") + " SZY ON "
cQuery += " SC6.C6_FILIAL = SZY.ZY_FILIAL AND SC6.C6_NUM = SZY.ZY_PEDIDO AND SC6.C6_ITEM = SZY.ZY_ITEM "
cQuery += " WHERE SC6.D_E_L_E_T_ = '' AND SZY.D_E_L_E_T_ = ''  " 
cQuery += " AND C6_PRODUTO <> ZY_PRODUTO "
TCSQLEXEC(cQuery) 
 
Return
