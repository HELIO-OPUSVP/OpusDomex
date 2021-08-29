#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCADP06    บAutor  ณHelio Ferreira      บ Data ณ  16/08/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Agendamento apontamento de OP                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CADP06()

Local aCores := {;      
{"P06_STATUS == ' '" , 'BR_AMARELO' },;
{"P06_STATUS == 'N'" , 'DISABLE'    },;
{"P06_STATUS == 'S'" , 'BR_VERDE'   } }

DbSelectArea("P06")
aRotina := {}

AADD(aRotina,{ "Pesquisar       ",'AxPesqui'     , 0, 1 } )
AADD(aRotina,{ "Visualizar      ",'AxVisual'     , 0, 2 } )
AADD(aRotina,{ "Incluir         ",'U_P06INCLUI'  , 0, 3 } )
AADD(aRotina,{ "Alterar         ",'U_P06ALTERA'  , 0, 4 } )
AADD(aRotina,{ "Excluir         ",'U_P06DELETA'  , 0, 5 } )

AADD(aRotina,{ "Legenda         ",'U_CadP06Leg'  , 0, 3 } )

cCadastro := "CADP06 - Agendamento de apontamento de OPs"

mBrowse( 6, 1,22,75,"P06",,,,,,aCores              ,,,,,,,,)  // "U_CADP06TOK()" )

//mBrowse( 6, 1,22,75,"SE2",,,,,, Fa040Legenda("SE2"),,,,,,,,IIF(ExistBlock("F080FILB"),ExecBlock("F080FILB",.f.,.f.),NIL))

//SetKey(VK_F10,Nil)

Return

User Function P06INCLUI()
Local nOK

//     AxInclui( <cAlias>, <nReg>, <nOpc>, <aAcho>, <cFunc>, <aCpos>, <cTudoOk>, <lF3>, <cTransact>, <aButtons>, <aParam>, <aAuto>, <lVirtual>, <lMaximized>)
nOK := AxInclui("P06"    , 0     , 3     ,        ,        ,        , "U_CADP06TOK()" )

If nOk == 1

EndIf

Return

User Function CadP06Leg()

BrwLegenda("","Legenda",{;
{"DISABLE"    ,"Apontamento nใo realizado por erro"                   },;  
{"ENABLE"     ,"Apontamento realizado com sucesso"                    },;  
{"BR_AMARELO" ,"Agendamento aguardando apontamento"                   }})  

Return

User Function P06ALTERA()

nOK := AxAltera("P06",P06->(Recno()),4)

If nOk == 1

EndIf

Return


User Function P06DELETA()

Return

User Function CADP06TOK()

Return .T.
