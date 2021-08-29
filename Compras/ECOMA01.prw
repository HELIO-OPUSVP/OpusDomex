#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ECOMA01  � Autor � Michel Sander         � Data �18/07/2014���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida��o no campo C1_FORNECE para verificar bloqueio      ���
���			 � de compras															     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � DOMEX				                                            ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function ECOMA01()

LOCAL __lOk   := .T.                                                                         
LOCAL _nPosFor := ASCAN(aHeader,{ |x| x[2] == "C1_FORNECE" })
LOCAL _nPosCod := ASCAN(aHeader,{ |x| x[2] == "C1_PRODUTO" })
LOCAL _cSQL    := ""
LOCAL aArea    := GetArea()

cSQL := "SELECT A5_MSBLQL FROM " + RETSQLNAME("SA5") + " WHERE "
cSQL += "A5_FILIAL = '"+xFilial("SA5")+"' AND "
cSQL += "A5_FORNECE= '"+aCols[n][16]+"' AND "
cSQL += "A5_PRODUTO= '"+aCols[n][02]+"' AND "
cSQL += "D_E_L_E_T_ = ''"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"TMP",.F.,.T.)

If TMP->A5_MSBLQL == "1"
   Aviso("Aten��o","O Produto "+aCols[n][02]+" possui bloqueio de compras para esse fornecedor. Por favor utilizar outro fornecedor",{"Ok"})
   __lOk := .F.
EndIf

TMP->(dbCloseArea())
RestArea(aArea)

Return( __lOk )