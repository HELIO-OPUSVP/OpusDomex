#include "rwmake.ch"
#include "topconn.ch"
#include "totvs.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCADSZ9()  �Autor  �Helio Ferreira     � Data �  10/03/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de Regi�o para transportadoras.                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function RCADSZ9()
aFixe     := {}
cCadastro := OemtoAnsi("Cadastro de Regi�es para Fretes")

aRotina  := {;
{ "Pesquisar"        , "Axpesqui"      , 0 , 1},;
{ "Incluir"          , "Axinclui"      , 0 , 3},;
{ "Visualiza"        , "Axvisual"      , 0 , 2},;
{ "Alterar"          , "Axaltera"      , 0 , 4},;
{ "Excluir"          , "AxDeleta"      , 0 , 2} }

aCores   := { } 

mBrowse(6,1,22,75,"SZ9",aFixe,,,,,aCores,,,,,)

Return
