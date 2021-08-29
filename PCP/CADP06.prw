#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CADP06   บAutor ณMichel Sander        บ Data ณ  11.04.17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Agendamento de Ops para apontamento							     บฑฑ
ฑฑบ          ณ 											                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ DOMEX			                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
                            
User Function CADP06()

Local aCores :=  {}

AADD(aCores,{ "P06_STATUS=='S'" , 'ENABLE' } )
AADD(aCores,{ "P06_STATUS=='N'" , 'DISABLE' } )
AADD(aCores,{ "P06_STATUS==' '" , 'BR_AMARELO' } )

Private cAlias := "P06"
PRIVATE cCadastro := "CADP06 - Agendamento para apontamento de Ordens de Produ็ใo"

DbSelectArea(cAlias)
aRotina := {}

AADD(aRotina,{ "Pesquisar       ",'AxPesqui'     , 0, 1 } )
AADD(aRotina,{ "Visualizar      ",'AxVisual'     , 0, 2 } )
AADD(aRotina,{ "Incluir         ","U_P06INCLUI"  , 0, 3 } )
AADD(aRotina,{ "Excluir         ",'U_P06DELETA'  , 0, 5 } )
AADD(aRotina,{ "Alterar         ",'U_P06ALTERA'  , 0, 3 } )
AADD(aRotina,{ "Filtrar         ",'U_P06FILTRO'  , 0, 3 } )
AADD(aRotina,{ "Legenda         ",'U_fLegP06'    , 0, 5 } )

//SetKey(VK_F10, { || U_fReImp() } )

mBrowse( 6, 1,22,75,cAlias,,,,,,aCores              ,,,,,,,,)  //"U_CADP06TOK()" )

//mBrowse( 6, 1,22,75,"SE2",,,,,, Fa040Legenda("SE2"),,,,,,,,IIF(ExistBlock("F080FILB"),ExecBlock("F080FILB",.f.,.f.),NIL))

//SetKey(VK_F10,Nil)

Return

User Function P06INCLUI()
Local nOK

//     AxInclui( <cAlias>, <nReg>, <nOpc>, <aAcho>, <cFunc>, <aCpos>, <cTudoOk>, <lF3>, <cTransact>, <aButtons>, <aParam>, <aAuto>, <lVirtual>, <lMaximized>)
nOK := AxInclui(cAlias    , 0     , 3     ,        ,        ,        , "U_CADP06TOK()" )

If nOk == 1
	
EndIf

Return

User Function fLegP06()

BrwLegenda("","Legenda",{;
{"DISABLE"    ,"Erro de Apontamento"                                            },;  // 1
{"ENABLE"     ,"Apontamento OK"                                                 },;
{"BR_AMARELO" ,"Aguardando Apontamento"                                         }})

Return

User Function P06ALTERA()

nOK := AxAltera(cAlias,0,4)

If nOk == 1
	
EndIf

Return

User Function P06DELETA()

RegToMemory(cAlias,.F.)
AxDeleta(cAlias  , &(cAlias+"->( Recno() )")     , 5    )

Return

User Function CADP06TOK()

Local _Retorno := .T.

Return _Retorno

User Function P06FILTRO()

Local calias
Local oObjMBrw := Nil

oObjMBrw := GetObjBrow()
cAlias   := Alias()
cPerg    := PadR("CADP06",10)

_cFILTER1 := ""

dbSelectArea("P06")

_cArq     := CriaTrab(NIL,.f.)
_cKey     := Indexkey()
_nIndex   :=  RetIndex("P06")

If Pergunte(cPerg,.T.)
   P06->(Dbclearfilter())
Else
   Setmbtopfilter("P06","")
	dbSelectarea(cAlias)
	oObjMBrw:GoTop()
   oObjMBrw:Refresh()
   Return
EndIf

_cFILTER1 := "P06_FILIAL = '"+xFilial("P06")+"' "
_cFILTER1 += "AND P06_OP = '"+DtoS(mv_par01)+"' "

//Executa Filtro
Setmbtopfilter("P06","")
MsAguarde({|| Setmbtopfilter("P06",_cFilter1) },'Filtrando Registros...')

oObjMBrw:GoTop()
oObjMBrw:Refresh()

Return