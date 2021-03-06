#include "rwmake.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FCONF01   �Autor  �Helio Ferreira      � Data �  05/04/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o Configurator 001 - Retorna a metragem do BS_DESPRD  ���
���          � em valor                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function FCONF01(cFamilia,cItem,cConteudo)
Local _Retorno := ""
Local aAreaGER := GetArea()
Local aAreaSBS := SBS->( GetArea() )

cFamilia  := cFamilia  + Space(Len(SBS->BS_BASE)   - Len(cFamilia)  )
cItem     := cItem     + Space(Len(SBS->BS_ID)     - Len(cItem)     )
cConteudo := cConteudo + Space(Len(SBS->BS_CODIGO) - Len(cConteudo) )

SBS->( dbSetOrder(1) )
If SBS->( dbSeek( xFilial() + cFamilia + cItem + cConteudo ) )
	
	
	_Retorno := StrTran(SBS->BS_DESCPRD,"#","")
	_Retorno := StrTran(SBS->BS_DESCPRD,"M","")
	_Retorno := StrTran(SBS->BS_DESCPRD,",",".")
	_Retorno := Val(_Retorno)
	
EndIf

RestArea(aAreaSBS)
RestArea(aAreaGER)

Return _Retorno
