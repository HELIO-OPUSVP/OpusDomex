#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VD3_COD   �Autor  �Helio Ferreira      � Data �  27/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function VD3_COD()
Local _Retorno := .T.

If FunName() <> 'MATA261'
	If !Empty(M->D3_COD)
		If !Empty(SD3->D3_TM)
			If SD3->D3_TM == '011'
				SG1->( dbSetOrder(1) )
				lSilk := .F.
				If SG1->( dbSeek( xFilial() + SD3->D3_COD ) )
					While !SG1->( EOF() ) .and. SG1->G1_COD == SD3->D3_COD
						If Subs(SG1->G1_COMP,1,6) == '500960'
							lSilk := .T.
							Exit
						EndIf
						SG1->( dbSkip() )
					End
				EndIf
				If !lSilk
					MsgStop("N�o � permitido utliizar a TM 011 para produtos que n�o sejam Silk.")
					_Retorno := .F.
				EndIf
			EndIf
		EndIf
	EndIf
EndIf

Return _Retorno
