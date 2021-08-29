#Include "protheus.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MRSXML03  �Autor  �Marco Aurelio Silva � Data �  21/10/15   ���
�������������������������������������������������������������������������͹��
���Prog.ORI  �ACOMA003  �Autor  �Felipe Aurelio      � Data �  11/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gestor de XML - Schedule/JOB para Baixar Emails            ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��            
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
Deve-se configurar JOB e chamar esta rotina. 

*/

User Function MRSXML03()

Local lEhJob := .T.

RpcSetType(3)
RpcSetEnv("01","01")
SetUserDefault("000000")

//Chama rotina que baixa e-mails (XML Pre Nota Entrada) e grava protheus
U_GXNBxa(lEhJob)

// Finaliza a abertura dos dicion�rios
RpcClearEnv()

Return