#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GF7ALIQINT �Autor  �Marco Aurelio      � Data �  16/06/22   ���
�������������������������������������������������������������������������͹��
���Desc.     � Tratamento de Simples Nacional - Limpa C7_PICM             ���
���          � Chamado - 031578.                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������


Limpa ICMS de todos os pedidos em aberto que usam o grupo de tributa��o de c�digo 100.


*/

User Function GF7ALIQINT()

if M->F7_GRTRIB = '100'

    _cQry1 := " UPDATE SC7010 SET C7_PICM=0 "
    _cQry1 += " FROM SC7010 "
    _cQry1 += " WHERE "
    _cQry1 += " D_E_L_E_T_ ='' "
    _cQry1 += " AND C7_ENCER <> 'E' "
    _cQry1 += " AND ((C7_QUANT-C7_QUJE) > 0) "
    _cQry1 += " AND C7_CONAPRO <> 'B' "
    _cQry1 += " AND C7_RESIDUO  = '' "
    _cQry1 += " AND C7_FORNECE+C7_LOJA IN " 
    _cQry1 += "      ( "
    _cQry1 += "      SELECT A2_COD+A2_LOJA FROM SA2010 WHERE A2_GRPTRIB IN( "
    _cQry1 += "      SELECT F7_GRPCLI FROM SF7010 WHERE F7_GRTRIB = '100' AND F7_GRPCLI <> '' AND D_E_L_E_T_ ='') "
    _cQry1 += " 	 ) "

    TCSQLEXEC(_cQry1)

ENDIF

Return(M->F7_ALIQINT)
