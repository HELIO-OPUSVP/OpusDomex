#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VDA1_XAPROV �Autor  �Osmar Ferreira    � Data �  02/12/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     �  Valida o usu�rio que pode aprovar / reprovar o pre�o      ���
���          �  a aprova��o/reprova��o s� pode ser feita pelo vendedor    ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function VDA1_XAPROV()
Local aAreaSA3 := SA3->( GetArea() )
Local lRet := .t.

//Verifica se o usu�rio � um vendedor
//SA3->( dbSetOrder(07) )
//If SA3->(dbSeek(xFilial() + __cUserID))
//    lRet := .t.
//Else
//    MsgInfo("A aprova��o ou reprova��o do pre�o s� pode ser feita pelo vendedor!!")
//    lRet := .f.
//EndIf        

RestArea(aAreaSA3)

Return(lRet)
