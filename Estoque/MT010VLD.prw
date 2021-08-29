//------------------------------------------------------------------------------------//
//Empresa...:
//Funcao....:
//Autor.....:
//Data......:
//Uso.......:
//Versao....:
//------------------------------------------------------------------------------------//
            
#INCLUDE "FIVEWIN.CH"
#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"

*----------------------------------------------------------------------------*
User Function MT010VLD() 
Local lRet := .F.	//-- Rotina de customização do usuário


MSGALERT(M->B1_COD)

M->B1_DESC_I  :=''
M->B1_VM_I    :=''
M->B1_DESC_GI :=''
M->B1_VM_GI   :=''
M->B1_DESC_P  :=''
M->B1_VM_P    :=''
M->B1_CODOBS  :=''
M->B1_OBS     :=''
M->B1_CODPROC :=''
M->B1_VM_PROC :=''

lRet := .T.

Return lRet