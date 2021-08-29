#include "rwmake.ch"
#include "totvs.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RPCSETENV �Autor  �Helio Ferreira      � Data �  27/10/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Fun��o gen�ria para rodar o RpcSetEnv com MsgRun()        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function RPCSETENV(cID)

Default cID := "000000"

MsgRun("RpcSetEnv()... Aguarde...","RpcSetEnv()... Usu�rio ("+cID+")",{|| ProcRPC(cID) })

Return

Static Function ProcRPC(cID)

If Type("cUsuario") == "U"
   aAbreTab := {}
   RpcSetEnv("01","01",,,,,aAbreTab) //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
   SetUserDefault(cID)
EndIf

Return
