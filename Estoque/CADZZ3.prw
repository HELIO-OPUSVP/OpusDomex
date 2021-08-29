#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCADZZ3    บAutor  ณH้lio Ferreira       บ Data ณ  03/01/18  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cadastro de Regras de campo do Configurador de Produtos    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ DOMEX                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CADZZ3()

Local aCores :=  {}
Private cAlias := "ZZ3"

AADD(aCores,{ "ZZ3_FILIAL==''" , 'DISABLE' } )
AADD(aCores,{ "ZZ3_FILIAL==''" , 'DISABLE' } )

DbSelectArea(cAlias)
aRotina := {}

AADD(aRotina,{ "Pesquisar       ",'AxPesqui'            , 0, 1 } )
AADD(aRotina,{ "Visualizar      ",'AxVisual'            , 0, 2 } )
AADD(aRotina,{ "Incluir         ","U_"+cAlias+"INCLUI"  , 0, 3 } )
AADD(aRotina,{ "Alterar         ","U_"+cAlias+"ALTERA"  , 0, 4 } )
AADD(aRotina,{ "Excluir         ","U_"+cAlias+"DELETA"  , 0, 5 } )
AADD(aRotina,{ "Filtrar         ","U_"+cAlias+"FILTRO"  , 0, 3 } )
AADD(aRotina,{ "Legenda         ","U_fLeg"+cAlias       , 0, 7 } )

cCadastro := "CAD"+cAlias+"() - Inventแrio em coletores"

//SetKey(VK_F10, { || U_fReImp() } )

mBrowse( 6, 1,22,75,cAlias,,,,,,aCores              ,,,,,,,,)  //"U_CADZZ3TOK()" )

//mBrowse( 6, 1,22,75,"SE2",,,,,, Fa040Legenda("SE2"),,,,,,,,IIF(ExistBlock("F080FILB"),ExecBlock("F080FILB",.f.,.f.),NIL))

//SetKey(VK_F10,Nil)

Return

User Function ZZ3INCLUI()
Local nOK

//     AxInclui( <cAlias>, <nReg>, <nOpc>, <aAcho>, <cFunc>, <aCpos>, <cTudoOk>, <lF3>, <cTransact>, <aButtons>, <aParam>, <aAuto>, <lVirtual>, <lMaximized>)
nOK := AxInclui(cAlias    , 0     , 3     ,        ,        ,        , "U_CAD"+cAlias+"TOK()" )

If nOk == 1
	
EndIf

Return

User Function fLegZZ3()

BrwLegenda("","Legenda",{;
{"DISABLE"    ,"Etiqueta de Pr้-NF nใo classificada"                                            },;  // 1
{"BR_PRETO"   ,"Etiqueta de NF classificada e em CQ"                                            },;  // 2
{"BR_AMARELO" ,"Etiqueta de NF Classificada, liberada pelo CQ e com pend๊ncia de Endere็amento" },;  // 3
{"ENABLE"     ,"Etiqueta endere็ada e pronta para uso"                                          },;  // 4
{"BR_AZUL"    ,"Material jแ utilizado"                                                          }}) // 5

User Function ZZ3ALTERA()

Local nReg := (cAlias)->(Recno())

//AxAltera( <cAlias>, <nReg>, <nOpc>, <aAcho>, <aCpos>, <nColMens>, <cMensagem>, <cTudoOk>, <cTransact>, <cFunc>, <aButtons>, <aParam>, <aAuto>, <lVirtual>, <lMaximized>)
nOK := AxAltera(cAlias,nReg,4)

If nOk == 1
	
EndIf

Return

User Function ZZ3DELETA()

RegToMemory(cAlias,.F.)
AxDeleta(cAlias  , &(cAlias+"->( Recno() )")     , 5    )

Return

User Function CADZZ3TOK()

Local _Retorno := .T.

Return _Retorno


User Function ZZ3FILTRO()
Local calias
Local oObjMBrw := Nil

//If _nVez > 1
//Captura objeto mBrowse
oObjMBrw := GetObjBrow()

cAlias:=Alias()
cPerg := PadR("CAD"+cAlias,10)

_cFILTER1 := ""

dbSelectArea(cAlias)

_cArq     := CriaTrab(NIL,.f.)
_cKey     := Indexkey()
_nIndex   :=  RetIndex(cAlias)

If Pergunte(cPerg,.T.)
   &(cAlias)->(Dbclearfilter())
Else
   Setmbtopfilter(cAlias,"")
	dbSelectarea(cAlias)
	oObjMBrw:GoTop()
   oObjMBrw:Refresh()
   Return
EndIf

_cFILTER1 := "ZZ3_FILIAL = '"+xFilial(cAlias)+"' "

_cFILTER1 += " and ZC_DATAINV = '"+DtoS(mv_par01)+"' "

//Executa Filtro
Setmbtopfilter(cAlias,"")
MsAguarde({|| Setmbtopfilter(Alias,_cFilter1) },'Filtrando Registros...')

//Atualizar mBrowse
oObjMBrw:GoTop()
oObjMBrw:Refresh()

Return
