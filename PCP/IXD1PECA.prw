#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IXD1PECA  �Autor  �Michel A. Sander    � Data �  28/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function IXD1PECA()

Local _Retorno := ""
Local nLoop    := 0
Local lLoop    := .T.
Local aAreaGER := GetArea()
Local aAreaSX6 := SX6->( GetArea() )

SX6->( Dbsetorder(1) )

If SX6->( dbSeek(SPACE(02)+"MV_XXETIQU") )
	While lLoop .and. nLoop < 1000
		If RecLock("SX6",.F.) .And. lLoop
		   _NextDoc        := VAL(SX6->X6_CONTEUD) 
			SX6->X6_CONTEUD := ALLTRIM(STR(_NextDoc+1))
			SX6->X6_CONTENG := ALLTRIM(STR(_NextDoc+1))
			SX6->X6_CONTSPA := ALLTRIM(STR(_NextDoc+1))
			SX6->( Msunlock() )
			lLoop    := .F.
			_Retorno := STRZERO(_NextDoc,12)
		EndIf
		nLoop ++
	End
EndIf

RestArea(aAreaSX6)
RestArea(aAreaGER)
                     
Return ( _Retorno )