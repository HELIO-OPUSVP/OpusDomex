#include "rwmake.ch"
#include "topconn.ch"

User Function CADSZC()

Local aCores :=  {}
AADD(aCores,{ "ZC_FILIAL==''" , 'DISABLE' } )
AADD(aCores,{ "ZC_FILIAL==''" , 'DISABLE' } )

Private cAlias := "SZC"

DbSelectArea(cAlias)
aRotina := {}

AADD(aRotina,{ "Pesquisar       ",'AxPesqui'     , 0, 1 } )
AADD(aRotina,{ "Visualizar      ",'AxVisual'     , 0, 2 } )
AADD(aRotina,{ "Incluir         ","U_SZCINCLUI"  , 0, 3 } )
AADD(aRotina,{ "Excluir         ",'U_SZCDELETA'  , 0, 5 } )
AADD(aRotina,{ "Alterar         ",'U_SZCALTERA'  , 0, 3 } )
AADD(aRotina,{ "Filtrar         ",'U_SZCFILTRO'  , 0, 3 } )
AADD(aRotina,{ "Relatório       ",'U_RESTR02'    , 0, 3 } )
AADD(aRotina,{ "Legenda         ",'U_fLegSZC'    , 0, 5 } )

cCadastro := "CADSZC - Inventário em coletores"

//SetKey(VK_F10, { || U_fReImp() } )

mBrowse( 6, 1,22,75,cAlias,,,,,,aCores              ,,,,,,,,)  //"U_CADSZCTOK()" )

//mBrowse( 6, 1,22,75,"SE2",,,,,, Fa040Legenda("SE2"),,,,,,,,IIF(ExistBlock("F080FILB"),ExecBlock("F080FILB",.f.,.f.),NIL))

//SetKey(VK_F10,Nil)

Return

User Function SZCINCLUI()
Local nOK

//     AxInclui( <cAlias>, <nReg>, <nOpc>, <aAcho>, <cFunc>, <aCpos>, <cTudoOk>, <lF3>, <cTransact>, <aButtons>, <aParam>, <aAuto>, <lVirtual>, <lMaximized>)
nOK := AxInclui(cAlias    , 0     , 3     ,        ,        ,        , "U_CADSZCTOK()" )

If nOk == 1
	
EndIf

Return

User Function fLegSZC()

BrwLegenda("","Legenda",{;
{"DISABLE"    ,"Etiqueta de Pré-NF não classificada"                                            },;  // 1
{"BR_PRETO"   ,"Etiqueta de NF classificada e em CQ"                                            },;  // 2
{"BR_AMARELO" ,"Etiqueta de NF Classificada, liberada pelo CQ e com pendência de Endereçamento" },;  // 3
{"ENABLE"     ,"Etiqueta endereçada e pronta para uso"                                          },;  // 4
{"BR_AZUL"    ,"Material já utilizado"                                                          }}) // 5

User Function SZCALTERA()

nOK := AxAltera(cAlias,0,4)

If nOk == 1
	
EndIf

Return

User Function SZCDELETA()

RegToMemory(cAlias,.F.)
AxDeleta(cAlias  , &(cAlias+"->( Recno() )")     , 5    )

Return

User Function CADSZCTOK()

Local _Retorno := .T.

Return _Retorno


User Function SZCFILTRO()
Local calias
Local oObjMBrw := Nil

//If _nVez > 1
//Captura objeto mBrowse
oObjMBrw := GetObjBrow()
//EndIf

cAlias:=Alias()
cPerg := PadR("CADSZC",10)

_cFILTER1 := ""

dbSelectArea("SZC")

_cArq     := CriaTrab(NIL,.f.)
_cKey     := Indexkey()
_nIndex   :=  RetIndex("SZC")

//If _nvez > 1
If Pergunte(cPerg,.T.)
   SZC->(Dbclearfilter())
Else
   Setmbtopfilter("SZC","")
	dbSelectarea(cAlias)
	oObjMBrw:GoTop()
   oObjMBrw:Refresh()
   Return
EndIf

_cFILTER1 := "ZC_FILIAL = '"+xFilial("SZC")+"' "

_cFILTER1 += " and ZC_DATAINV = '"+DtoS(mv_par01)+"' "
//EndIf

//Executa Filtro
Setmbtopfilter("SZC","")
MsAguarde({|| Setmbtopfilter("SZC",_cFilter1) },'Filtrando Registros...')

//IF _nVez > 1
//Atualizar mBrowse
oObjMBrw:GoTop()
oObjMBrw:Refresh()
//ENDIF
/*
IndRegua("SZC",_cArq,_cKey,,_cfilter1,"Selecionando Registros...")

_nIndex  := RetIndex("SZC")

#IFNDEF TOP
dbSetIndex(_cArq+OrdBagExt())
#ENDIF
SZC->(DbSetOrder(_nIndex+1))
dbGotop()
DLGRefresh()
*/

Return
