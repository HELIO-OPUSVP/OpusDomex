#include "totvs.ch"
#include "topconn.ch"


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GZZ3CAMPO �Autor  �Helio Ferreira      � Data �  05/03/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatinho usado no campo ZZ3_CAMPO para retornar a sequencia ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function GZZ3CAMPO()
Local _Retorno

cQuery := "SELECT MAX(ZZ3_SEQUEN) AS MAXSEQUEN FROM " + RetSqlName("ZZ3") + " WHERE ZZ3_CAMPO = '"+M->ZZ3_CAMPO+"' AND D_E_L_E_T_ = '' "

If Select("TEMP") <> 0
   TEMP->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "TEMP"

_Retorno := TEMP->MAXSEQUEN

_Retorno := Val(_Retorno)

_Retorno++

_Retorno := StrZero(_Retorno,3)

Return _Retorno
