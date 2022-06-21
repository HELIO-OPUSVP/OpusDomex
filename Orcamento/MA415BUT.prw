
#include "Protheus.ch"


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA415BUT  �Autor  �Osmar Ferreira      � Data �  07/06/2022 ���
�������������������������������������������������������������������������͹��
���Desc.     � Adiciona bot�es na atualiza��o de Or�amentos de Vendas     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function MA415BUT()
Local aBotoes := {}

If U_Validacao("OSMAR")
   Aadd(aBotoes , {'AREA_MDI' ,{|| U_AORCAM01() }	,"Importa��o Planilha"	,"Importar Itens"	} )
   Aadd(aBotoes , {'AREA_MDI' ,{|| U_VLDMRGOR(.T.,.F.) }	,"Validar Margem"	,"Validar Margem"	} )
EndIf	
	
Return( aBotoes )
