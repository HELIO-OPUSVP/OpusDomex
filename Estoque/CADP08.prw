#INCLUDE "rwmake.ch"

User Function CADP08
aFixe     := {}
cCadastro := OemtoAnsi("Controle de acesso - Cadastro x Pastas")
aRotina  := {;
{ "Pesquisar"        , "Axpesqui"      , 0 , 1},;
{ "Incluir"          , "Axinclui"      , 0 , 3},;
{ "Visualiza"        , "Axvisual"      , 0 , 2},;
{ "Alterar"          , "Axaltera"      , 0 , 4},;
{ "Excluir"          , "AxDeleta"      , 0 , 2} }

aCores   := { } 

dbSelectArea("P08")
dbSetOrder(1)

mBrowse(6,1,22,75,"P08",aFixe,,,,,aCores,,,,,)

Return

