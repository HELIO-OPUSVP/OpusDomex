#include "rwmake.ch"
#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M030INC   �Autor  �Helio Ferreira      � Data �  05/07/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada na inclus�o de Cadastro de Clientes       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function M030INC()

CTD->(dbSetOrder(1))
If !CTD->(dbSeek(xFilial("CTD")+"C"+SA1->A1_COD+SA1->A1_LOJA))
	If RecLock("CTD",.T.)
		CTD_FILIAL := xFilial("CTD")
		CTD_ITEM   := "C"+SA1->A1_COD+SA1->A1_LOJA
		CTD_CLASSE := "2"
		CTD_DESC01 := SA1->A1_NOME
		CTD_BLOQ   := "2"
		CTD_DTEXIS := CtoD("01/01/80")
		CTD_NORMAL := "1"
		CTD->( MsUnlock() )
	EndIf
EndIf


cAssunto  := "Assunto do email" //"End of MRP I Domex - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
cTexto    := "Texto do email" //"End of MRP I Domex - Date " + cData + "  Time: " + Time()
cPara     := "comercial@rdt.com.br"
cCC       := ""
cArquivo  := ""

//Alert(cAssunto)            

//U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)



Return
