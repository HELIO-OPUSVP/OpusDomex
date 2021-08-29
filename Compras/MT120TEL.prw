#include "rwmake.ch"
#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT120TEL  �Autor  �Marcos Rezende      � Data �  09/24/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cria o Campo de tipo de pedido no cabe�alho de PC          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT120TEL()
Local oNewDialog 	:= PARAMIXB[1]
Local aPosGet 		:= PARAMIXB[2]
Local aObj 			:= PARAMIXB[3]                             

Local nOpcx 		:= PARAMIXB[4]   

Public _cTPPC 		:= Space(02)
Public _DOMOpcx 	:= nOpcx    //mantem esta variavel para ser utilizada na valida��o de linha
_cTPPC := IIf(nOpcX == 4 .OR. nOpcX == 2, sc7->C7_XTPPC, Space(2))

//@ 044,aPosGet[1,6] SAY "Tipo do Pedido: " OF oNewDialog PIXEL SIZE 060,006
//@ 043,aPosGet[1,7] MSGET _cTPPC PICTURE PesqPict("SC7","C7_XTPPC") F3 CpoRetF3('C7_XTPPC','XTPPC') OF oNewDialog PIXEL SIZE 040,003
 
@ 055,aPosGet[1,6] SAY "Tipo do Pedido: " OF oNewDialog PIXEL SIZE 060,006
@ 048,aPosGet[1,7] MSGET _cTPPC PICTURE PesqPict("SC7","C7_XTPPC") F3 CpoRetF3('C7_XTPPC','XTPPC') OF oNewDialog PIXEL SIZE 040,003

Return(.T.)

