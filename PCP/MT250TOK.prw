#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT250TOK  �Autor  �Helio Ferreira      � Data �  07/03/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Tudo OK do MATA250 (Apontamento de Produ��o Mod I)         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function MT250TOK()   // A250ITOK
Local _Retorno := .T.
Local aAreaGER := GetArea()
Local aAreaSC2 := SC2->( GetArea() )

SC2->( dbSetOrder(1) )
SC2->( dbSeek( xFilial() + M->D3_OP ) )                     



If _Retorno
	If Type("lAutoMt250") == 'U'
		_Retorno := U_VD3_QUANT()
	Else
		If !lAutoMt250
			_Retorno := U_VD3_QUANT()
		EndIF
	EndIf
EndIf

If _Retorno
   If GetMV("MV_XSEMAOP") == 'S'           // JOAO - COMENTADO
	   Public __XXNumSeq := U_INUMSEQ("MT250TOK() - Apontamento de Produ��o OP: " + M->D3_OP ) //JOAO - COMENTADO
	EndIf
	//joaoU_AGLUTSD4(M->D3_OP)
Else
	M->D3_QUANT := 0
EndIf

RestArea(aAreaSC2)
RestArea(aAreaGER)

Return _Retorno
