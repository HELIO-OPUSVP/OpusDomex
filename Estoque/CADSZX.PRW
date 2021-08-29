#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCADSZX    บAutor  ณMicrosiga           บ Data ณ  13/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Solicita็ใo de materiais de consumo                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CADSZX()

Local aCores := {;
{'ZX_SALDO==0' , 'DISABLE'    },;
{'ZX_SALDO<>0' , 'BR_VERDE'   } }

Private cLocProcDom := GetMV("MV_XXLOCPR")   // Local de Processos Domex

DbSelectArea("SZX")
aRotina := {}

AADD(aRotina,{ "Pesquisar       ",'AxPesqui'     , 0, 1 } )
AADD(aRotina,{ "Visualizar      ",'AxVisual'     , 0, 2 } )
AADD(aRotina,{ "Incluir         ",'U_SZXINCLUI'  , 0, 3 } )
//AADD(aRotina,{ "Incluir       ",'AxInclui'     , 0, 3 } )
AADD(aRotina,{ "Excluir         ",'U_SZXDELETA'  , 0, 5 } )

If Upper(Subs(cUsuario,7,5)) == 'HELIO' .or. Upper(Subs(cUsuario,7,5)) == 'DENIS'
	AADD(aRotina,{ "Alterar      ",'U_SZXALTERA'  , 0, 3 } )
	AADD(aRotina,{ "Reimprimir   ",'U_SZXREIMP'   , 0, 3 } )
EndIf

//AADD(aRotina,{ "Relat๓rio       ",'U_fLegenda'   , 0, 4 } )
AADD(aRotina,{ "Legenda         ",'U_fLegenda'   , 0, 5 } )

//           { "Reimpressao     ",'U_fReImp'     , 0, 2 },;
//           { "Teste Impressora",'MSCBTestePort', 0, 2 },;

cCadastro := "CADSZX - Solicita็ใo de Materiais de Consumo "

//SetKey(VK_F10, { || U_fReImp() } )

mBrowse( 6, 1,22,75,"SZX",,,,,,aCores              ,,,,,,,,)  // "U_CADSZXTOK()" )

//mBrowse( 6, 1,22,75,"SE2",,,,,, Fa040Legenda("SE2"),,,,,,,,IIF(ExistBlock("F080FILB"),ExecBlock("F080FILB",.f.,.f.),NIL))

//SetKey(VK_F10,Nil)

Return

User Function SZXINCLUI()
Local nOK

//     AxInclui( <cAlias>, <nReg>, <nOpc>, <aAcho>, <cFunc>, <aCpos>, <cTudoOk>, <lF3>, <cTransact>, <aButtons>, <aParam>, <aAuto>, <lVirtual>, <lMaximized>)
nOK := AxInclui("SZX"    , 0     , 3     ,        ,        ,        , "U_CADSZXTOK()" )

If nOk == 1
	If MsgYesNo("Deseja imprimir a etiqueta?")
		Etiqueta()
	EndIf
EndIf

Return 

//----------------------------------------------------------

//User Function fReImp()

//Return

//------------------------------------------------------------


//User Function fLegenda()

/*
1 (vermelha) Etiqueta de Pr้-NF nใo classificada

2 (preta)    Etiqueta de NF classificada e em CQ

3 (amarela)  Etiqueta de NF Classificada, liberada pelo CQ e com pend๊ncia de Endere็amento

4 (verde)    Etiqueta endere็ada e pronta para uso

5 (cinza)    Material jแ utilizado
*/

BrwLegenda("","Legenda",{;
{"DISABLE"    ,"Etiqueta de Pr้-NF nใo classificada"                                            },;  // 1
{"BR_PRETO"   ,"Etiqueta de NF classificada e em CQ"                                            },;  // 2
{"BR_AMARELO" ,"Etiqueta de NF Classificada, liberada pelo CQ e com pend๊ncia de Endere็amento" },;  // 3
{"ENABLE"     ,"Etiqueta endere็ada e pronta para uso"                                          },;  // 4
{"BR_AZUL"    ,"Material jแ utilizado"                                                          }}) // 5


/*{"BR_AMARELO","Reimpressa"   },;  // 2*/
//SX3-->1=Impresso;2=Reimpresso;3=Nao Impresso;4=Excluido;5=Avulsa;6=Armazenado;7=Consumido

//Return

User Function INIZX_DOC()

Return "000001"

Static Function Etiqueta()
Local _cPorta    := "LPT1"
Local _aAreaGER  := GetArea()

Reclock("SZX",.F.)
SZX->ZX_DATA := DATE()
SZX->ZX_HORA := Time()
SZX->( msUnlock() )

MSCBPrinter("TLP 2844",_cPorta,,,.F.)
MSCBBegin(1,6)

//If SZX->ZE_TIPO == 'P'
//   MSCBSay(28,01,"PAGAMENTO: PERDA PRODUวรO","N","3","1,1")
//EndIf

//If SZX->ZE_TIPO == 'F'
MSCBSay(28,01,"PAGAMENTO: MATERIAL CONSUMO","N","3","1,1")
//EndIf

//If SZX->ZE_TIPO == 'C'
//   MSCBSay(28,01,"PAGAMENTO: MATERIAL CONSUMO","N","3","1,1")
//EndIf

//If SZX->ZE_TIPO == 'E'
//   MSCBSay(28,01,"PAGAMENTO: ENGENHARIA","N","3","1,1")
//EndIf

n := 3
// 01
MSCBSay(28,01+n,"DATA:"+DtoC(SZX->ZX_DATA)+" HORA:"+SZX->ZX_HORA+Space(10)+Transform(SZX->ZX_SALDO,"@E 999,999.99"),"N","2","1,1")
//03
MSCBSay(28,03+n,"SOLICIT.:"+Subs(SZX->ZX_NOME,1,10)+" QTD:"+Alltrim(Transform(SZX->ZX_SALDO,"@E 999,999.99")),"N","2","1,1")
//05
MSCBSay(28,05+n,"PRODUTO: "+Alltrim(SZX->ZX_PRODUTO)+" "+StrTran(SZX->ZX_DESC,'"',""),"N","2","1,1")

//MSCBSayBar - Imprime c๓digo de barras ( nXmm nYmm cConteudo cRota็ใo cTypePrt [ nAltura ] [ *lDigver ] [ lLinha ] [ *lLinBaixo ] [ cSubSetIni ]      [ nLargura ] [ nRelacao ] [ lCompacta ] [ lSerial ] [ cIncr ] [ lZerosL ] )
//07
MSCBSayBar(31,07+n,SZX->ZX_DOCUMEN,"N","MB07",10 ,.F.,.T.,.F.,,3,1  ,Nil,Nil,Nil,Nil)
//18
//MSCBSay(46,18+n,"OP: "+SZX->ZE_OP,"N","2","1,1")

MSCBEnd()

MSCBClosePrinter()

RestArea(_aAreaGER)


/*
MSCBPrinter("TLP 2844",_cPorta,,,.F.)
MSCBBegin(1,6)
MSCBSay(28,01,"ALMOXARIFADO :"+SBE->BE_LOCAL,"N","2","1,1")
MSCBSay(28,03,"ENDERECO :"+SBE->BE_LOCALIZ,"N","2","1,1")
MSCBSayBar(27,06,SBE->BE_LOCAL+SubStr(SBE->BE_LOCALIZ,1,13),"N","MB07",10,.F.,.T.,.F.,,2,1,Nil,Nil,Nil,Nil)
MSCBEnd()
MSCBClosePrinter()
*/

Return

User Function SZXALTERA()

nOK := AxAltera("SZE",0,4)

If nOk == 1
	Reclock("SZE",.F.)
	SZE->ZE_DATA := DATE()
	SZE->ZE_HORA := Time()
	SZE->( msUnlock() )
	
	If MsgYesNo("Deseja imprimir a etiqueta?")
		Etiqueta()
	EndIf
EndIf

Return

User Function SZXREIMP()

If MsgYesNo("Deseja imprimir a etiqueta?")
	Etiqueta()
EndIf

Return

User Function SZXDELETA()

If SZX->ZX_SALDO == 0
	MsgStop("Perda com pagamento jแ efetuado. Nใo serแ possํvel excluir este apontamento.")
Else
	If SZX->ZX_QTDORI <> SZX->ZX_SALDO
		MsgStop("Perda com pagamento parcial jแ efetuado. Nใo serแ possํvel excluir este apontamento.")
	Else
		RegToMemory("SZE",.F.)
		AxDeleta("SZX"  , SZX->( Recno() )     , 5    )
	EndIf
EndIf

Return

User Function CADSZXTOK()
Local _Retorno := .T.
Local aAreaGER := GetArea()


RestArea(aAreaGER)

Return _Retorno
