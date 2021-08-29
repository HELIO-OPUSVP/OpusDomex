#include "rwmake.ch"
#include "topconn.ch"
#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCADSZ9()  บAutor  ณHelio Ferreira     บ Data ณ  10/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cadastro de Regiใo para transportadoras.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RCADSZ9()
aFixe     := {}
cCadastro := OemtoAnsi("Cadastro de Regi๕es para Fretes")

aRotina  := {;
{ "Pesquisar"        , "Axpesqui"      , 0 , 1},;
{ "Incluir"          , "Axinclui"      , 0 , 3},;
{ "Visualiza"        , "Axvisual"      , 0 , 2},;
{ "Alterar"          , "Axaltera"      , 0 , 4},;
{ "Excluir"          , "AxDeleta"      , 0 , 2} }

aCores   := { } 

mBrowse(6,1,22,75,"SZ9",aFixe,,,,,aCores,,,,,)

Return
