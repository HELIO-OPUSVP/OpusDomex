#Include "protheus.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MRSXML02  �Autor  �Marco Aurelio Silva � Data �  21/10/15   ���
�������������������������������������������������������������������������͹��
���Prog.ORI  �SD1140E   �Autor  �Felipe Aurelio      � Data �  11/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gestor de XML - Trata Exclusao de Pre-Nota                 ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��       
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
 
// Deve ser chamada no PE SD1140E(Exclusao de Pre NF) , como no exemplo abaixo:

	User Function SD1140E()
 		u_MRSXML02()
	Return


*/


User Function MRSXML02()


Local cTab1   := AllTrim(GetMV("MX_MRALS01"))
Local cAls1   := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
Local lGrvMsg := .T.
Local cStatus := "5"
Local cMensag := ""
Local cChvNfe := ""

Local cQuery  := ""

SF1->(DbSetOrder(1))
If SF1->(DbSeek(SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA))
	If !Empty(SF1->F1_CHVNFE)

		cChvNfe := AllTrim(SF1->F1_CHVNFE)
		cChvNfe := StrTran(cChvNfe,"e","")
		cChvNfe := StrTran(cChvNfe,"E","")

		cMensag := "DOCUMENTO EXCLUIDO DO SISTEMA! - NUMERO DOC: "+SD1->D1_DOC + " / " + SD1->D1_SERIE
		U_MRSXML01(lGrvMsg,cStatus,cMensag,cChvNfe)

	Endif
EndIf

Return