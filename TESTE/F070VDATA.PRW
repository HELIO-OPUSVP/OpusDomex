#include "protheus.ch"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F070VDATA �Autor  � OpusVP             � Data �  10/04/2016 ��� 
�������������������������������������������������������������������������͹��
���Desc.     �  Ponto de entrada para Baixar Dacao parcial                ���                               
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION F070VDATA
_aSaveArea	:= GetArea()
fa070Calc( nTxMoeda, .T. )  
RestArea(_aSaveArea)
RETURN .T.



	


/*     
lRetorno := ExecBlock("F070VDATA",.F.,.F., {nVal,nTxMoeda})

Function fA070Val(nVal,nTxMoeda,lRecalcVRec)
Local lRetorno := .T.

DEFAULT nTxMoeda := 0 
DEFAULT lRecalcVRec := .T.
Default __F070VDATA := ExistBlock("F070VDATA")
