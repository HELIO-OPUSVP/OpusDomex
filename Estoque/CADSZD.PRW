#include "rwmake.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCADSZD    บAutor  ณHelio Ferreira      บ Data ณ  17/10/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cadastro de comprovante de pagamentos de OP                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CADSZD()

Local aCores := {}

//{;
//{'ZA_SALDO==0' , 'DISABLE'    },;
//{'ZA_SALDO<>0' , 'BR_VERDE'   } }

DbSelectArea("SZD")
aRotina := {}

AADD(aRotina,{ "Pesquisar       ",'AxPesqui'     , 0, 1 } )
AADD(aRotina,{ "Visualizar      ",'AxVisual'     , 0, 2 } )
AADD(aRotina,{ "Incluir         ",'U_EtiqPagam'  , 0, 3 } )
AADD(aRotina,{ "Reimprimir      ",'U_EtiqPGOP'   , 0, 3 } )
//AADD(aRotina,{ "Legenda       ",'U_fLegenda'   , 0, 5 } )
//           { "Reimpressao     ",'U_fReImp'     , 0, 2 },;
//           { "Teste Impressora",'MSCBTestePort', 0, 2 },;

cCadastro := "CADSZD - Comprovante de pagamento de OP"

//SetKey(VK_F10, { || U_fReImp() } )

mBrowse( 6, 1,22,75,"SZD",,,,,,aCores,,,,,,,,)

Return


//User Function fLegenda()

/*
1 (vermelha) Etiqueta de Pr้-NF nใo classificada

2 (preta)    Etiqueta de NF classificada e em CQ

3 (amarela)  Etiqueta de NF Classificada, liberada pelo CQ e com pend๊ncia de Endere็amento

4 (verde)    Etiqueta endere็ada e pronta para uso

5 (cinza)    Material jแ utilizado
*/

BrwLegenda("","Legenda",{ ;
{"DISABLE"    ,"Etiqueta de Pr้-NF nใo classificada"                                            },;  // 1
{"BR_PRETO"   ,"Etiqueta de NF classificada e em CQ"                                            },;  // 2
{"BR_AMARELO" ,"Etiqueta de NF Classificada, liberada pelo CQ e com pend๊ncia de Endere็amento" },;  // 3
{"ENABLE"     ,"Etiqueta endere็ada e pronta para uso"                                          },;  // 4
{"BR_AZUL"    ,"Material jแ utilizado"                                                          }}) // 5

/*{"BR_AMARELO","Reimpressa"   },;  // 2*/
//SX3-->1=Impresso;2=Reimpresso;3=Nao Impresso;4=Excluido;5=Avulsa;6=Armazenado;7=Consumido

//Return

User Function INIZD_CODIGO()

Return "000001"

Static Function Etiqueta()
Local _cPorta    := "LPT1"
Local _aAreaGER  := GetArea()

Reclock("SZA",.F.)
SZA->ZA_DATA := DATE()
SZA->ZA_HORA := Time()
SZA->( msUnlock() )

MSCBPrinter("TLP 2844",_cPorta,,,.F.)
MSCBBegin(1,6)

MSCBSay(28,01,"DATA:"+DtoC(SZA->ZA_DATA)+" HORA:"+SZA->ZA_HORA+Space(10)+Transform(SZA->ZA_SALDO,"@E 999,999.99"),"N","2","1,1")

MSCBSay(28,03,"OPERA.:"+SZA->ZA_OPERADO+" QTD:"+Transform(SZA->ZA_SALDO,"@E 999,999.99"),"N","2","1,1")

MSCBSay(28,05,"PRODUTO: "+Alltrim(SZA->ZA_PRODUTO)+" "+Alltrim(SZA->ZA_DESC),"N","2","1,1")

//MSCBSayBar - Imprime c๓digo de barras ( nXmm nYmm cConteudo cRota็ใo cTypePrt [ nAltura ] [ *lDigver ] [ lLinha ] [ *lLinBaixo ] [ cSubSetIni ]      [ nLargura ] [ nRelacao ] [ lCompacta ] [ lSerial ] [ cIncr ] [ lZerosL ] )

MSCBSayBar(31,07,SZA->ZA_DOCUMEN,"N","MB07",10 ,.F.,.T.,.F.,,3,1  ,Nil,Nil,Nil,Nil)

MSCBSay(46,18,"OP: "+SZA->ZA_OP,"N","2","1,1")

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
