#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO5     �Autor  �Microsiga           � Data �  08/27/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function VD3_TM()
Local _Retorno := .T.
//altera��o no fonte para compatibiliza��o com as atualiza��es
//tabela SD3 esta posicionada e n�o aceita ser chamada pelo alias de mem�ria.(M)
//provavel migra��o para MVC
If !Empty( D3_COD)
	If  D3_TM == '011'
		SG1->( dbSetOrder(1) )
		lSilk := .F.
		If SG1->( dbSeek( xFilial() +  D3_COD ) )
			While !SG1->( EOF() ) .and. SG1->G1_COD ==  D3_COD
				If Subs(SG1->G1_COMP,1,6) == '500960'
					lSilk := .T.
					Exit
				EndIf
				SG1->( dbSkip() )
			End
		EndIf
		If !lSilk
		   MsgStop("N�o � permitido utilizar a TM 011 para produtos que n�o sejam Silk.")
		   _Retorno := .F.
		EndIf
	EndIf
EndIf

Return _Retorno
