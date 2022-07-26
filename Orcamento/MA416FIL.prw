
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA416FIL  �Autor  �Osmar Ferreira      � Data �  26/07/22   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada � executado antes da apresenta��o         ���
���          � do Browse e utilizado como filtro do usu�rio.              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function MA416FIL()
Local cFiltro := ""              
Local cNum := "'"+SCJ->CJ_NUM+"'"

//Mas somente quanto a efetiva��o � chamada pela rotina de cadastro do or�amento
If FUnName() ==  "MATA415" 
   cFiltro := "CJ_NUM == " + cNum
EndIf

Return(cFiltro)

