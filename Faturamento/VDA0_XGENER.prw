#include "totvs.ch"
#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VDA0_XGENER � Autor  � Osmar Ferreira        �  11/08/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o do campo tabela generica (Sim/N�o)               ���
���          � no cadastro de tabela de pre�o (DA0)                       ���
�������������������������������������������������������������������������͹��
���Uso       � Rosenberger                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function VDA0_XGENER()
Local _Retorno := .T.
Local aAreaGER := GetArea()
Local aAreaDA0 := DA0->( GetArea() )

If M->DA0_XGENER == 'S' 
   If M->DA0_CODTAB <> '001' .And. M->DA0_CODTAB <> '002'
      msgAlert('Somente as tabelas 001 e 002 podem ser do tipo GENERICA!!')
      _Retorno := .F.
   EndIf
EndIf

RestArea( aAreaDA0 )
RestArea( aAreaGER )
Return _Retorno
