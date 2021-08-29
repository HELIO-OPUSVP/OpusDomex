#INCLUDE "rwmake.ch"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �      � Autor � Mauricio Lima de Souza � Data �  16/01/13   ���
�������������������������������������������������������������������������͹��
���Descricao �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P10                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function DOMCVI01  


Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Local aRotAdic := {} 

Private cString := "SZ6"

SZ6->(dbSelectArea("SZ6"))
SZ6->(dbSetOrder(1))
aadd(aRotAdic,{ "Relatorio","U_DOMRVI01", 0 , 6 })
AxCadastro(cString,"Cadastro de Visita Vendedor",cVldExc,cVldAlt, aRotAdic)

Return



//Local aRotAdic := {} 
//Local bPre     := {||MsgAlert('Chamada antes da fun��o')}
//Local bOK      := {||MsgAlert('Chamada ao clicar em OK'), .T.}
//Local bTTS     := {||MsgAlert('Chamada durante transacao')}
//Local bNoTTS   := {||MsgAlert('Chamada ap�s transacao')}    
//Local aButtons := {}  //adiciona bot�es na tela de inclus�o, altera��o, visualiza��o e exclusao
////aadd(aButtons,{ "Relatorio1", {|| U_DOMRVI01}, "Relatorio1", "Relatorio1" }  )//adiciona chamada no aRotina

////AxCadastro("SZ6", "Cadastro de Visita Vendedor", /*"U_DelOk()"*/, /*"U_COK()"*/, aRotAdic, /*bPre*/, /*bOK*/, /*bTTS*/, /*bNoTTS*/, , , aButtons, , )  
//  AxCadastro("SZ6", "Cadastro de Visita Vendedor",.T.             ,.T.           , aRotAdic)
//Return(.T.)                        
//
//User Function DelOk() 	
////MsgAlert("Chamada antes do delete") 
//Return 

//User Function COK() 	
//MsgAlert("Clicou botao OK") 
//Return .t.      

//User Function Adic() 	
//MsgAlert("Rotina adicional") 
//Return



//------------------------------------------------------------------------
USER Function fZ6VISITA(l1Elem,lTipoRet)
//------------------------------------------------------------------------

Local cTitulo :=""
Local MvPar
Local MvParDef:=""
Local cCount  :='0'


local  lTipoRet := .T.
Private aCat:={}

Private RETParDef:=""
Private cGrupopar :='RETParDef'




l1Elem := If (l1Elem = Nil , .F. , .T.)

cAlias := Alias() 	 // Salva Alias Anterior

//IF lTipoRet
	MvPar:=&(Alltrim(cGrupopar))//&(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
	mvRet:=(Alltrim(cGrupopar))//Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno
//EndIF

cTitulo :='Tipo de Visita'

Aadd(aCat,'01 - A realizar' )
MvParDef+='01' 

Aadd(aCat,'02 - Cancelada pelo Cliente' )
MvParDef+='02' 

Aadd(aCat,'03 - Cancelada pela Domex' )
MvParDef+='03' 

Aadd(aCat,'04 - Cancelada Pelo Vendedor' )
MvParDef+='04' 

Aadd(aCat,'99 - Visita Realizada' )
MvParDef+='99' 

CursorArrow()

IF f_Opcoes(@MvPar,cTitulo,aCat,MvParDef,12,49,.F.,2,006)
		&MvRet := mvpar										 // Devolve Resultado
EndIF

dbSelectArea(cAlias) 								 // Retorna Alias
RETParDef:=MvParDef


MV_PAR12 :=mvpar

Return(MvParDef)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SA1_MVC   �Autor  �                    � Data �  13/01/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//USER Function SZ6_MVC()
//Local oMBrowse
//ADD OPTION aRotina TITLE "Relat�rio"    ACTION "U_DOMRVI01()"   OPERATION 2 ACCESS 0
//DEFINE FWMBROWSE oMBrowse ALIAS "SZ6" DESCRIPTION "Cadastro de Visita Vendedor"
//ACTIVATE FWMBROWSE oMBrowse     


//Return