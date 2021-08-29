#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NEXTDOC   �Autor  �Helio Ferreira      � Data �  05/08/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function NEXTDOC()
Local _Retorno := 'D'+Space(9)   // 'D'+Space(6)  mls    24/11/2014
Local nLoop    := 0
Local lLoop    := .T.
Local aAreaGER := GetArea()
Local aAreaSX6 := SX6->( GetArea() )

SX6->( Dbsetorder(1) )

If SX6->( dbSeek(xFilial("SD3")+"MV_XXNEXTD") )
	While lLoop .and. nLoop < 1000
		If RecLock("SX6",.F.) .And. lLoop
			_NextDoc        := Alltrim(SX6->X6_CONTEUD)
			SX6->X6_CONTEUD := SOMA1(_NextDoc)
			SX6->( Msunlock() )
			
			lLoop    := .F.
			_Retorno := 'D'+_NextDoc
		EndIf
		nLoop ++
	End
EndIf

RestArea(aAreaSX6)
RestArea(aAreaGER)
                     
If Alltrim(_Retorno) == 'D'
   MsgYesNo('Parametro MV_XXNEXTD n�o criado!')
   _Retorno := ''
EndIf

Return _Retorno
