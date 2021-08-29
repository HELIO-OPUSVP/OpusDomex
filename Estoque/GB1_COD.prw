#include "rwmake.ch"
#include "totvs.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GB1_COD   �Autor  �Helio Ferreira      � Data �  01/03/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho para preenchimento de campos diversos confirme     ���
���          � regras cadastradas no ZZ3                                  ���
�������������������������������������������������������������������������͹��
���Uso       � DOMEX                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function GB1_COD()
Local _Retorno  := M->B1_COD
Local oModel    := FWModelActive()

Private _Codigo := M->B1_COD      

ZZ3->( dbGoTop() )
While !ZZ3->( EOF() )
	If &(ZZ3->ZZ3_REGRA)
		//&('M->'+ZZ3->ZZ3_CAMPO) := &(ZZ3->ZZ3_CONTEUDO)
		oModel:SetValue('SB1MASTER',ZZ3->ZZ3_CAMPO,&(ZZ3->ZZ3_CONTEUDO))
	EndIf
	ZZ3->( dbSkip() )
End

Return _Retorno
