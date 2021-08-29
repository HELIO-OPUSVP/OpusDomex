#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function AGEFP04D()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o   ³AGEFP01  ³ Autor ³ Mauricio Lima de Souza  ³ Data ³11/12/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Consulta Consumo Mensal                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ OMAMORI                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
//Teste Osmar
//cEmpresa       := "OMAMORI"
//aEmpresa       := {"OMAMORI","OMAMORI"}
cEmpresa       := ""
aEmpresa       := {"",""}

cExibeTerceiro := "Nao"
aExibeTerceiro := {"Sim","Nao"}

cExporta       := "Sim"
aExporta       := {"Sim","Nao"}

cSB2SB9        :="CM"
aSB2SB9        := {"CM","FECHAMENTO"}

_cNomeCampo		    := ""
aAGE1Campos		    := {}
_dDataMovimento     := Ctod("  /  /  ")
_dDeDataCompra      := Ctod("  /  /  ")
_dAteDataCompra     := Ctod("  /  /  ")
_cTipoConsidera     := "PA PI PR MP RV                                                                    "
_cTipoNaoConsidera  := "                                                                                  "
_cMatPrimaProprio	:= "S"
_cPA_PIConsidera    := "N"
_nTotal	     	    := 0
_nCrtica1	        := 0
_nPadrao1	        := 0
_nPadrao2	        := 0
_nPadrao3	        := 0
_nPadrao4	        := 0
_nPadrao5	        := 0
_nSEMPadrao	        := 0
cALMOX              := "01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 19 20 21 29 30 31 33 41 50 51 61 91 92 93 97 98 99                                                        "

cTPEST   :="ALL"
aTPEST   := {"ALL","Processo"}
// cNOMEARQ :="MASTER_"


// Variaveis totalizadoras do relatorio
QTDE0030   := 0
QTDE3160   := 0
QTDE6190   := 0
QTDE91180  := 0
QTDE181360 := 0
QTDE361540 := 0
QTDE540    := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Interface                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_dDataMovimento:=DATE()
/*
@ 201,195 To 429,605 Dialog mkwdlg Title OemToAnsi("Aging Inventory com Quantidade ")

@ 10,009 Say OemToAnsi("Informe data final do Periodo")  Size 082,08
//@ 20,009 Say OemToAnsi("Considera Material de Terceiro") Size 091,10
@ 30,009 Say OemToAnsi("Considerar TIPOS ")              Size 082,08
//@ 40,009 Say OemToAnsi("Exporta Arquivos")               Size 082,08
@ 40,009 Say OemToAnsi("Custo Medio/Fechamento")         Size 082,08
@ 50,009 Say OemToAnsi("Considerar Almoxarifado ")       Size 082,08
//@ 50,009 Say OemToAnsi("Ponto de Estoque ")              Size 082,08
//@ 60,009 Say OemToAnsi("ARQUIVO C:\TEMP\ ")       Size 082,08


@ 10,100 Get _dDataMovimento     Size 76,10
//@ 20,100 ComboBox cExibeTerceiro Items aExibeTerceiro    Size 76,10
@ 30,100 Get _cTipoConsidera        Size 76,10
//@ 40,100 ComboBox cExporta Items aExporta   Size 76,10
@ 40,100 ComboBox cSB2SB9 Items aSB2SB9   Size 76,10
@ 50,100 Get cALMOX                       SIZE 76,10
//@ 50,100 ComboBox cTPEST Items aTPEST    Size 76,10
//@ 50,100 Get cNOMEARQ                      SIZE 76,10

@ 90,107 BmpButton Type 1 Action Confirma()
@ 90,152 BmpButton Type 2 Action Close(mkwdlg)
Activate Dialog mkwdlg
*/

Confirma()

Return()

Static Function Confirma()

//IF cTPEST=="ALL"
//cALMOX              := "05 21 22 23 24 25 40 41 52 53 54 98 99 DM DV NC RP SC SN TC TS                                                                                                           "
//  cALMOX              := "05 21 22 23 24 25 41 52 53 54 98 DM DV NC RP SC SN TC TS                                                                                                           "
// ELSE
// cALMOX              := "99                                                                                                                                                                       "
//ENDIF

CriaTmp()

_nTotal		:= 0
_nCrtica1	:= 0
_nPadrao1	:= 0
_nPadrao2	:= 0
_nPadrao3	:= 0
_nPadrao4	:= 0
_nPadrao5	:= 0

_nSEMPadrao	:= 0

// Inicia processo para capturar saldo no periodo informado

//Processa( {|| BuscaSB9Saldo() },"Busca Saldos no Periodo" )
BuscaSB9Saldo()
dbSelectArea("TMPSB91")
dbGotop()
If eof()
	//MsgBox("Nao foi encontrado saldos de fechamento no periodo informado")
	FechaArquivo()
	IF SELECT("WEEK1") >0
		WEEK1->(DbCloseArea())
		//	MSGALERT("GERADO WEEK1.DBF")
	ENDIF
	
	Return()
Endif
DbSelectArea("QUERY1")
DbCloseArea()

// PROCESSA Da data informada a 30 DIAS

_dDeDataCompra	:= _dDataMovimento
_dAteDataCompra := _dDeDataCompra - 30
BuscaSD1Entrada("QTDE00_30")
SD3Query("QTDE00_30")

// PROCESSA de 31 a 60 DIAS

_dDeDataCompra	:= _dAteDataCompra - 1
_dAteDataCompra := _dAteDataCompra - 30
BuscaSD1Entrada("QTDE31_60")
SD3Query("QTDE31_60")

// PROCESSA de 61 a 90 DIAS

_dDeDataCompra	:= _dAteDataCompra - 1
_dAteDataCompra := _dAteDataCompra - 30
BuscaSD1Entrada("QTDE61_90")
SD3Query("QTDE61_90")

//PROCESSA de 91 a 240 DIAS  // PROCESSA de 91 a 180 DIAS

_dDeDataCompra	:= _dAteDataCompra - 1
//_dAteDataCompra := _dAteDataCompra - 90
_dAteDataCompra := _dAteDataCompra - 150
BuscaSD1Entrada("QTDE91_180")
SD3Query("QTDE91_180")

//PROCESSA de 240 a 360 DIAS // PROCESSA de 181 a 360 DIAS
_dDeDataCompra	:= _dAteDataCompra - 1
//_dAteDataCompra := _dAteDataCompra - 180
_dAteDataCompra := _dAteDataCompra - 120
BuscaSD1Entrada("QTDE81_360")
SD3Query("QTDE81_360")

// PROCESSA de 361 a 540 DIAS
_dDeDataCompra	:= _dAteDataCompra - 1
_dAteDataCompra := _dAteDataCompra - 180
BuscaSD1Entrada("QTDE61_540")
SD3Query("QTDE61_540")

// PROCESSA de 540 em diante
_dDeDataCompra	:= _dAteDataCompra - 1
_dAteDataCompra := _dAteDataCompra - 2500
BuscaSD1Entrada("QTDE540")
SD3Query("QTDE540")

SB9SemEntrada()
Distribui()
GeraMaster()
S2OMAENT()
GeraTipo()
GeraGrupo()

cQUERY1 :=" DELETE  FROM MASTER2 "
TCSQLEXEC(cQUERY1)

dbSelectArea('MASTER')
dbGoTop()

DO WHILE !MASTER->(EOF())
	
	//	cQUERY2 :=" INSERT INTO MASTER1(CODIGO,QT360,VL360,QT540,VL540,SALDO)  "
	//	cQUERY2 +=" VALUES ('"+MASTER->CODIGO+"',"+STR(MASTER->QTD361_540)+","+STR(MASTER->VLR361_540)+","+STR(MASTER->QTD540)+","+STR(MASTER->VLR540)+","+STR(MASTER->SALDO)+") "
	
	cQUERY2 :=" INSERT INTO MASTER2(CODIGO,SALDO,QT_0_30,VL_0_30,QT_31_60,VL_31_60,QT_61_90,VL_61_90,QT_91_240,VL_91_240,QT_240_360,VL_240_360,QT_361_540,VL_361_540,QT_540,VL_540)  "
	cQUERY2 +=" VALUES ('"+MASTER->CODIGO+"',"+STR(MASTER->SALDO)+","
	cQUERY2 +=STR(MASTER->QTD00_30)  +","
	cQUERY2 +=STR(MASTER->VLR00_30)  +","
	cQUERY2 +=STR(MASTER->QTD31_60)  +","
	cQUERY2 +=STR(MASTER->VLR31_60)  +","
	cQUERY2 +=STR(MASTER->QTD61_90)  +","
	cQUERY2 +=STR(MASTER->VLR61_90)  +","
	cQUERY2 +=STR(MASTER->QTD91_180) +","
	cQUERY2 +=STR(MASTER->VLR91_180) +","
	cQUERY2 +=STR(MASTER->QTD181_360)+","
	cQUERY2 +=STR(MASTER->VLR181_360)+","
	cQUERY2 +=STR(MASTER->QTD361_540)+","
	cQUERY2 +=STR(MASTER->VLR361_540)+","
	cQUERY2 +=STR(MASTER->QTD540)+","
	cQUERY2 +=STR(MASTER->VLR540)+") "
	
	TCSQLEXEC(cQUERY2)
	dbSkip()
ENDDO

/*
@ 01,1 TO 500,790 DIALOG oDlg3 TITLE " Aging Inventory        Quantidade de registros = " + StrZero(_nTotal,5)
oFont := CreatFontw("Courier New",0,-12)
@ 02,3 TO 230,395 BROWSE "MASTER" FIELDS aAGE1Campos OBJECT oBrw
//oBrw:oBrowse:oFont := oFonte

@ 235,200 BUTTON "_WEEK"      SIZE 30,15 ACTION Imp1WEEK()
@ 235,280 BUTTON "Ger.Master" SIZE 30,15 ACTION GerMdbf()
@ 235,320 BUTTON "Sair"       SIZE 30,15 ACTION Close(oDlg3)
@ 235,360 BUTTON "_Impressao" SIZE 30,15 ACTION Imp1MASTER()
ACTIVATE DIALOG oDlg3 CENTERED
*/

If cExporta == "Sim"
	//dbSelectArea('MASTER')
	//copy to MASTER.dbf
	//MsgBox("Foi gerado arquivo com detalhes de nome \SIGAADV\MASTER.DBF")
Endif

FechaArquivo()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CriaTmp   ³ Autor ³ MAURICIO LIMA DE SOUZA            ³ Data ³10/01/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Cria Arquivo Temporario                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CriaTmp()

aAGE1Campos := {}

aAdd( aAGE1Campos, { "CODIGO"  ,"Codigo"     , "" } )
aAdd( aAGE1Campos, { "NOME"    ,"Descricao"  , "" } )
aAdd( aAGE1Campos, { "TIPO"    ,"Tipo"       , "" } )
aAdd( aAGE1Campos, { "GRUPO"   ,"Grupo"      , "" } )

IF cSB2SB9=='CM'
	aAdd( aAGE1Campos, { "C_UNIT"  ,"Custo SB2","@E 99,999,999.99"} )
ELSE
	aAdd( aAGE1Campos, { "C_UNIT"  ,"Custo SB9","@E 99,999,999.99"} )
ENDIF

aAdd( aAGE1Campos, { "SALDO"  ,"QTD Saldo na Data","@E 99,999,999.99"} )

nITEM :=1
lLOOP :=.T.
DO WHILE lLOOP ==.T.
	cPest := SUBSTR(cALMOX,nITEM,2)
	IF !EMPTY(SUBSTR(cALMOX,nITEM,2))
		cPest :='"PE'+(cPest)+'"'
		cVLPE :='"VLR'+substr(cPest,2,4)+'"'
		aAdd( aAGE1Campos, {  &(cPest)  ,"QTD "+&(cPest),"@E 99,999,999.99"} )//MLS
		aAdd( aAGE1Campos, {  &(cVLPE)  ,       &(cVLPE),"@E 99,999,999.99"} )//MLS
	ELSE
		lLOOP :=.F.
	ENDIF
	nITEM :=nITEM+3
ENDDO

aAdd( aAGE1Campos, { "C_TOTAL"    ,"R$ Valor Saldo","@E 99,999,999.99"} )
aAdd( aAGE1Campos, { "SOMAENT"     ,"R$ Soma Entrada","@E 99,999,999.99"} )

aAdd( aAGE1Campos, { "QTD00_30"    ,"Saldo 0/30 Dias","@E 999,999.99"} )
aAdd( aAGE1Campos, { "QTD31_60"    ,"Saldo 31/60 Dias","@E 999,999.99"} )
aAdd( aAGE1Campos, { "QTD61_90"    ,"Saldo 61/90 Dias","@E 999,999.99"} )
aAdd( aAGE1Campos, { "QTD91_180"   ,"Saldo 91/180 Dias","@E 999,999.99"} )
aAdd( aAGE1Campos, { "QTD181_360"  ,"Saldo 181/360 Dias ","@E 999,999.99"} )
aAdd( aAGE1Campos, { "QTD361_540"  ,"Saldo 361/540 Dias ","@E 999,999.99"} )
aAdd( aAGE1Campos, { "QTD540"      ,"Saldo 450 Dias em diante","@E 999,999.99"} )

aAdd( aAGE1Campos, { "VLR00_30"    ,"Valor 0/30 Dias","@E 999,999.99"} )
aAdd( aAGE1Campos, { "VLR31_60"    ,"Valor 31/60 Dias","@E 999,999.99"} )
aAdd( aAGE1Campos, { "VLR61_90"    ,"Valor 61/90 Dias","@E 999,999.99"} )
aAdd( aAGE1Campos, { "VLR91_180"   ,"Valor 91/180 Dias","@E 999,999.99"} )
aAdd( aAGE1Campos, { "VLR181_360"  ,"Valor 181/360 Dias ","@E 999,999.99"} )
aAdd( aAGE1Campos, { "VLR361_540"  ,"Valor 361/540 Dias ","@E 999,999.99"} )
aAdd( aAGE1Campos, { "VLR540"      ,"Valor 450 Dias em diante","@E 999,999.99"} )

aAGE1  := {}

aAdd( aAGE1, { "CODIGO"    ,"C"  ,15,0 } )
aAdd( aAGE1, { "NOME"      ,"C"  ,50,0 } )
aAdd( aAGE1, { "TIPO"      ,"C"  ,2,0  } )
aAdd( aAGE1, { "GRUPO"     ,"C"  ,4,0  } )
aAdd( aAGE1, { "SALDO"     ,"N"  ,13,3 } )
aAdd( aAGE1, { "C_UNIT"  ,"N"  ,16,4 } ) //valor unitario
aAdd( aAGE1, { "C_TOTAL"  ,"N"  ,16,4 } ) //valor total item

aAdd( aAGE1, { "SOMAENT"   ,"N"  ,16,4 } )

aAdd( aAGE1, { "QTDE00_30"    ,"N"  ,16,4 } )
aAdd( aAGE1, { "QTDE31_60"    ,"N"  ,16,4 } )
aAdd( aAGE1, { "QTDE61_90"    ,"N"  ,16,4 } )
aAdd( aAGE1, { "QTDE91_180"   ,"N"  ,16,4 } )
aAdd( aAGE1, { "QTDE81_360"    ,"N"  ,16,4 } )
aAdd( aAGE1, { "QTDE61_540"    ,"N"  ,16,4 } )
aAdd( aAGE1, { "QTDE540"       ,"N"  ,16,4 } )

aAdd( aAGE1, { "QTD00_30"     ,"N"  ,16,4 } )
aAdd( aAGE1, { "QTD31_60"     ,"N"  ,16,4 } )
aAdd( aAGE1, { "QTD61_90"     ,"N"  ,16,4 } )
aAdd( aAGE1, { "QTD91_180"    ,"N"  ,16,4 } )
aAdd( aAGE1, { "QTD181_360"   ,"N"  ,16,4 } )
aAdd( aAGE1, { "QTD361_540"   ,"N"  ,16,4 } )
aAdd( aAGE1, { "QTD540"       ,"N"  ,16,4 } )

aAdd( aAGE1, { "VLR00_30"     ,"N"  ,16,4 } )
aAdd( aAGE1, { "VLR31_60"     ,"N"  ,16,4 } )
aAdd( aAGE1, { "VLR61_90"     ,"N"  ,16,4 } )
aAdd( aAGE1, { "VLR91_180"    ,"N"  ,16,4 } )
aAdd( aAGE1, { "VLR181_360"   ,"N"  ,16,4 } )
aAdd( aAGE1, { "VLR361_540"   ,"N"  ,16,4 } )
aAdd( aAGE1, { "VLR540"       ,"N"  ,16,4 } )

//Pontos de estoque
nITEM :=1
lLOOP :=.T.
DO WHILE lLOOP ==.T.
	cPest := SUBSTR(cALMOX,nITEM,2)
	IF !EMPTY(SUBSTR(cALMOX,nITEM,2))
		cPest :='"PE'+(cPest)+'"'
		cVLPE :='"VLR'+substr(cPest,2,4)+'"'
		aAdd( aAGE1, { &(cPest)  ,"N"  ,16,4 } )
		aAdd( aAGE1, { &(cVLPE)  ,"N"  ,16,4 } )//MLS
	ELSE
		lLOOP :=.F.
	ENDIF
	nITEM :=nITEM+3
ENDDO
//----------------------------------------------------------


AGE1   := CriaTrab( aAGE1, .t. )
dbUseArea(.T.,,AGE1,"AGE1",.F.,.F.)
cKey   := "CODIGO"
cCond  := ""
cIndex := CriaTrab(NIL,.F.)
IndRegua( "AGE1" ,cIndex ,cKey ,,cCond ,"Indexando Arq.Temporario")

aTMPSB91  := {}
aAdd( aTMPSB91, { "CODIGO"      ,"C"  ,15,0 } )
aAdd( aTMPSB91, { "QTSALDO"     ,"N"  ,14,3 } )
aAdd( aTMPSB91, { "VALORTOT"    ,"N"  ,14,3 } )
TMPSB91   := CriaTrab( aTMPSB91, .t. )
dbUseArea(.T.,,TMPSB91,"TMPSB91",.F.,.F.)
cKey   := "CODIGO"
cCond  := ""
cIndex := CriaTrab(NIL,.F.)
IndRegua( "TMPSB91" ,cIndex ,cKey ,,cCond ,"Indexando Arq.Temporario")

// TIPO aglutina lancamentos
TIPO   := CriaTrab( aAGE1, .t. )
dbUseArea(.T.,,TIPO,"TIPO",.F.,.F.)
cKey   := "TIPO"
cCond  := ""
cIndex := CriaTrab(NIL,.F.)
IndRegua( "TIPO" ,cIndex ,cKey ,,cCond ,"Indexando Arq.Temporario")

// MASTER RECECE O RESULTADO EM VALOR
MASTER   := CriaTrab( aAGE1, .t. )
dbUseArea(.T.,,MASTER,"MASTER",.F.,.F.)
cKey   := "CODIGO"
cCond  := ""
cIndex := CriaTrab(NIL,.F.)
IndRegua( "MASTER" ,cIndex ,cKey ,,cCond ,"Indexando Arq.Temporario")


// GRUPO aglutina lancamentos
fGRUPO   := CriaTrab( aAGE1, .t. )
dbUseArea(.T.,,fGRUPO,"fGRUPO",.F.,.F.)
cKey   := "GRUPO"
cCond  := ""
cIndex := CriaTrab(NIL,.F.)
IndRegua( "fGRUPO" ,cIndex ,cKey ,,cCond ,"Indexando Arq.Temporario")
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SD3Query  ³ Autor ³ MAURICIO LIMA DE SOUZA            ³ Data ³22/10/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Query para arquivo de movimentacao de fabrica               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SD3Query(_cNomeCampo)
// Prepara a QUERY para movimentacao fabrica SD3
cArq    := CriaTrab(NIL,.f.)
cQuery3 :=           "SELECT SD3.D3_COD CODIGO ,SD3.D3_OP OP ,SD3.D3_QUANT QUANTIDADE ,SD3.D3_EMISSAO EMISSAO ,SD3.D3_ESTORNO ESTORNO "
cQuery3 := cQuery3 + "  FROM "
cQuery3 := cQuery3 + RetSqlName("SD3") + ' SD3 '
//cQuery3 := cQuery3 + "  WHERE LEFT(SD3.D3_CF,2)='PR'" 28/12/04
cQuery3 := cQuery3 + "  WHERE (LEFT(SD3.D3_CF,2)=('PR') OR D3_CF='DE0'  OR D3_CF='DE6') " //28/12/04
cQuery3 := cQuery3 + "  AND   SD3.D3_DOC<>'INVENT'  "
cQuery3 := cQuery3 + "  AND   SD3.D_E_L_E_T_ <> '*' "
cQuery3 := cQuery3 + "  AND   SD3.D3_FILIAL = '" +XFILIAL("SD3") + "' "
cQuery3 := cQuery3 + "  AND   SD3.D3_EMISSAO BETWEEN " + Dtos(_dAteDataCompra) + " AND "  + Dtos(_dDeDataCompra)
cQuery3 := cQuery3 + "  AND   SD3.D3_ESTORNO <> 'S' "
TCQUERY cQuery3 ALIAS QUERY3 NEW
// Atualiza arquivo com acumulados
dbSelectArea('QUERY3')
dbGotop()
ProcRegua(RECCOUNT())
dbGoTop()
While !eof()
	////INCPROC("Producoes   " +Dtoc(_dAteDataCompra) + " / " + Dtoc(_dDeDataCompra) + "  Codigo " + QUERY3->CODIGO )
	//INCPROC()
	
	// Verifica se o codigo existe no SALDO DE FECHAMENTO
	// Verifica nivel da OP
	//If Substr(QUERY3->OP,9,3) <> "001"
	//   dbSelectArea('QUERY3')
	//   dbSkip()
	//   Loop
	//Endif
	
	dbSelectArea('TMPSB91')
	If !dbSeek(QUERY3->CODIGO)
		// Nao existe no fechamento, entao desconsidera o codigo
		dbSelectArea('QUERY3')
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("AGE1")
	If !dbSeek(QUERY3->CODIGO)
		dbSelectArea('SB1')
		dbSetOrder(1)
		dbSeek(Xfilial('SB1') + QUERY3->CODIGO)
		dbSelectArea("AGE1")
		RecLock('AGE1',.T.)
		CODIGO		    := QUERY3->CODIGO
		&_cNomeCampo 	:= QUERY3->QUANTIDADE
		SALDO      	    := TMPSB91->QTSALDO
		C_UNIT        := TMPSB91->VALORTOT / TMPSB91->QTSALDO
		C_TOTAL        := TMPSB91->VALORTOT
		NOME 	        := SB1->B1_DESC
		TIPO            := SB1->B1_TIPO
		GRUPO           := SB1->B1_GRUPO
		SOMAENT    	    := QUERY3->QUANTIDADE
		AGE1->(MsUnlock())
	Else
		dbSelectArea("AGE1")
		RecLock('AGE1',.F.)
		&_cNomeCampo 	:= &_cNomeCampo + QUERY3->QUANTIDADE
		SOMAENT    	:= SOMAENT + QUERY3->QUANTIDADE
		AGE1->(MsUnlock())
	Endif
	dbSelectArea('QUERY3')
	dbSkip()
Enddo
DbSelectArea("QUERY3")
DbCloseArea()
Return()

Static Function BuscaSD1Entrada(_cNomeCampo)
// Prepara a QUERY
// Leitura das entradas no periodo
cArq    := CriaTrab(NIL,.f.)
cQuery1 :=           "SELECT SD1.D1_COD CODIGO, SD1.D1_QUANT QTD_ENT, SD1.D1_DTDIGIT DT_ENT, SD1.D1_TES TES "
cQuery1 := cQuery1 + "  FROM "
cQuery1 := cQuery1 + RetSqlName("SD1") + ' SD1'
cQuery1 := cQuery1 + "  WHERE SD1.D1_TIPO = 'N' "
cQuery1 := cQuery1 + "  AND   SD1.D_E_L_E_T_ <> '*' "
cQuery1 := cQuery1 + "  AND   SD1.D1_FILIAL = '" +XFILIAL("SD1") + "' "
cQuery1 := cQuery1 + "  AND   SD1.D1_DTDIGIT BETWEEN " + Dtos(_dAteDataCompra) + " AND "  + Dtos(_dDeDataCompra)
TCQUERY cQuery1 ALIAS QUERY1 NEW

// Atualiza arquivo com acumulados
dbSelectArea('QUERY1')
dbGotop()
ProcRegua(RECCOUNT())
dbGoTop()
While !eof()
	////INCPROC("Entradas de " +Dtoc(_dAteDataCompra) + " / " + Dtoc(_dDeDataCompra) + "  Codigo " + QUERY1->CODIGO )
	//INCPROC()
	// Verifica se o codigo existe no SALDO DE FECHAMENTO
	dbSelectArea('TMPSB91')
	If !dbSeek(QUERY1->CODIGO)
		// Nao existe no fechamento, entao desconsidera o codigo
		dbSelectArea('QUERY1')
		dbSkip()
		Loop
	Endif
	
	/////////////////////////////////////////////////////////////////
	// VERIFICAR SE A TES DO MOVIMENTO ESTA ATUALIZANDO ESTOQUE
	////////////////////////////////////////////////////////////////
	dbSelectArea("SF4")
	dbSeek(xFilial("SF4") + QUERY1->TES)
	//If SF4->F4_ESTOQUE <> "S"
	// TES Não Movimenta Estoque
	//	dbSelectArea('QUERY1')
	//	dbSkip()
	//	Loop
	//EndIf
	
	dbSelectArea("AGE1")
	If !dbSeek(QUERY1->CODIGO)
		dbSelectArea('SB1')
		dbSetOrder(1)
		dbSeek(Xfilial('SB1') + QUERY1->CODIGO)
		dbSelectArea("AGE1")
		RecLock('AGE1',.T.)
		CODIGO		    := QUERY1->CODIGO
		&_cNomeCampo 	:= QUERY1->QTD_ENT
		SALDO      	:= TMPSB91->QTSALDO
		C_UNIT       := TMPSB91->VALORTOT / TMPSB91->QTSALDO
		C_TOTAL       := TMPSB91->VALORTOT
		NOME 	        := SB1->B1_DESC
		TIPO           := SB1->B1_TIPO
		GRUPO          := SB1->B1_GRUPO
		SOMAENT    	:= QUERY1->QTD_ENT
		AGE1->(MsUnlock())
	Else
		dbSelectArea("AGE1")
		RecLock('AGE1',.F.)
		&_cNomeCampo 	:= &_cNomeCampo + QUERY1->QTD_ENT
		SOMAENT    	:= SOMAENT + QUERY1->QTD_ENT
		AGE1->(MsUnlock())
	Endif
	dbSelectArea('QUERY1')
	dbSkip()
Enddo
DbSelectArea("QUERY1")
DbCloseArea()
Return()

Static Function BuscaSB9Saldo()
cArq    := CriaTrab(NIL,.f.)

IF cSB2SB9= 'FECHAMENTO'
	
	cQuery1 :="SELECT SB9.B9_COD CODIGO, SB9.B9_DATA  PERIODO , SB9.B9_QINI QTSALDO, SB9.B9_VINI1 TOTAL, SB9.B9_LOCAL ALMOX "
	cQuery1 := cQuery1 + "  FROM "
	cQuery1 := cQuery1 + RetSqlName("SB9") + ' SB9 ' +", "+ RetSqlName("SB1") + ' SB1 '+ "  "
	cQuery1 := cQuery1 + "  WHERE SB9.B9_QINI<>0        "
	cQuery1 := cQuery1 + "  AND   SB9.B9_COD=SB1.B1_COD "
	// cQuery1 := cQuery1 + "  AND   SB1.B1_DETORIG <> '5' AND SUBSTRING(SB1.B1_CONTA,1,8) <> '11161095' "
	cQuery1 := cQuery1 + "  AND   SB9.B9_FILIAL = '" +XFILIAL("SB9") + "' "
	cQuery1 := cQuery1 + "  AND   SB9.B9_DATA = '" + DTOS(_dDataMovimento) + "' "
	cQuery1 := cQuery1 + "  AND   SB9.D_E_L_E_T_ <>'*'  "
	cQuery1 := cQuery1 + "  AND   SB1.D_E_L_E_T_ <>'*'  "
	cQuery1 := cQuery1 + "  AND   SB9.B9_QINI  >0       "
	cQuery1 := cQuery1 + "  AND   SB9.B9_VINI1 >0       "
	cQuery1:=ChangeQuery(cQuery1)
	TCQUERY cQuery1 ALIAS QUERY1 NEW
	
ENDIF

IF cSB2SB9= 'CM'
	
	cQuery1 := " SELECT SB2.B2_COD AS CODIGO, " +DTOS(DATE())+ " AS  PERIODO , "
	cQuery1 += "        SB2.B2_QFIM AS QTSALDO, SB2.B2_VFIM1 AS TOTAL, SB2.B2_LOCAL AS ALMOX "
	cQuery1 += " FROM  " + RetSqlName("SB2") + ' SB2 ' +", "+ RetSqlName("SB1") + ' SB1 '+ "  "
	cQuery1 += " WHERE SB2.B2_QFIM<>0  "
	cQuery1 += " AND   SB2.B2_COD=SB1.B1_COD "
	// cQuery1 := cQuery1 + "  AND   SB1.B1_DETORIG <> '5' AND SUBSTRING(SB1.B1_CONTA,1,8) <> '11161095' "
	cQuery1 += " AND   SB2.B2_FILIAL = '" +XFILIAL("SB2") + "' "
	cQuery1 += " AND   SB2.D_E_L_E_T_ <>'*'  "
	cQuery1 += " AND   SB1.D_E_L_E_T_ <>'*'  "
	cQuery1 += " AND   SB2.B2_QFIM  >0       "
	cQuery1 += " AND   SB2.B2_VFIM1 >0       "
	
	cQuery1:=ChangeQuery(cQuery1)
	TCQUERY cQuery1 ALIAS QUERY1 NEW
	/*
	SELECT SB9.B9_COD CODIGO, SB9.B9_DATA  PERIODO , SB9.B9_QINI QTSALDO, SB9.B9_VINI1 TOTAL, SB9.B9_LOCAL ALMOX
	FROM
	SB9010 SB9  , SB1010 SB1
	WHERE SB9.B9_QINI<>0
	AND   SB9.B9_COD=SB1.B1_COD
	AND   SB1.B1_DETORIG <> '5' AND SUBSTRING(SB1.B1_CONTA,1,8) <> '11161095'
	AND   SB9.B9_FILIAL = '01'
	AND   SB9.B9_DATA = 20041031
	and B1_TIPO IN('01','02','06','07')
	AND SB9.B9_LOCAL='01'
	AND SB9.D_E_L_E_T_ <>'*'
	AND SB1.D_E_L_E_T_ <>'*'
	AND SB9.B9_QINI <> 0
	AND SB9.B9_VINI1 <>0
	
	*/
	
ENDIF

dbSelectArea('QUERY1')
dbGotop()
ProcRegua(RECCOUNT())
dbGoTop()
While !eof()
	////INCPROC("Saldo Codigo " + AllTrim(QUERY1->CODIGO) )
	//INCPROC()
	dbSelectArea('SB1')
	dbSetOrder(1)
	dbSeek(Xfilial('SB1') + QUERY1->CODIGO)
	If SB1->B1_TIPO $(_cTipoConsidera)
		//
	else
		dbSelectArea('QUERY1')
		dbSkip()
		Loop
	Endif
	If AllTrim(QUERY1->ALMOX) $(cALMOX)
		//
	else
		dbSelectArea('QUERY1')
		dbSkip()
		Loop
	Endif
	
	// Verifica se quer incluir ou nao o material de terceiro
	//If cExibeTerceiro == "Nao"
	//	IF ALLTRIM(SB1->B1_DETORIG)=="5"  .OR. ALLTRIM(SB1->B1_CONTA)=="1116110"
	//		dbSelectArea('QUERY1')
	//		dbSkip()
	//		Loop
	//	Endif
	//Endif
	
	// Tipos de materiais para nao serem considerados
	If SB1->B1_TIPO $ _cTipoConsidera
		//
	else
		dbSelectArea('QUERY1')
		dbSkip()
		Loop
	Endif
	
	
	dbSelectArea("TMPSB91")
	If !dbSeek(QUERY1->CODIGO)
		RecLock('TMPSB91',.T.)
		CODIGO		:= QUERY1->CODIGO
		QTSALDO 	:= QUERY1->QTSALDO
		VALORTOT    := QUERY1->TOTAL
		TMPSB91->(MsUnlock())
	Else
		RecLock('TMPSB91',.F.)
		QTSALDO	 	:= QTSALDO  + QUERY1->QTSALDO
		VALORTOT    := VALORTOT + QUERY1->TOTAL
		TMPSB91->(MsUnlock())
	Endif
	dbSelectArea('QUERY1')
	dbSkip()
Enddo
Return()


Static Function FechaArquivo()

DbSelectArea("AGE1")
DbCloseArea()
DbSelectArea("TIPO")
DbCloseArea()
DbSelectArea("fGRUPO")
DbCloseArea()
DbSelectArea("TMPSB91")
DbCloseArea()
dbSelectArea( "MASTER")
DbCloseArea()
//DbSelectArea("QUERY1")
//DbCloseArea()
Return()

Static Function Imp1MASTER()

SetPrvt("titulo,aLinha,nomeprog,lAbortPrint,nLastKey,cbtxt,cbcont,cabec1,cabec2,li,nCaract,m_pag,wnrel,cPerg,cString,aOrd,Tamanho,nPag,aReturn")
SetPrvt("CDESC1,CDESC2,CDESC3,_cAtualCod,_cAtualQTD,_cAtualValor,_cAtualLinha,_cTotalQTD,_cTotalValor")


// Variaveis totalizadoras do relatorio
VLR0030   := 0
VLR3160   := 0
VLR6190   := 0
VLR91180  := 0
VLR181540 := 0
VLR541900 := 0
VLR540x   := 0

QTD0030   := 0
QTD3160   := 0
QTD6190   := 0
QTD91180  := 0

QTD181540 := 0
QTD541900 := 0
QTD540x   := 0

// -16 caracteres na Descricao
cabec1      := OemToAnsi("Codigo          Descricao                          Tipo Grupo     1 a 30 Dias !!     31 a 60 Dias !!    61 a 90 Dias !!     91 a 180 Dias !!    181 a 360 Dias  !!    361 a 540 Dias  !!    541 Dias em Diante")
cabec2      := OemToAnsi("                                                                  Valor em R$ !!      Valor em R$ !!      Valor em R$!!       Valor em R$ !!       Valor em R$  !!       Valor em R$  !!        Valor em R$   ")

titulo      := OemToAnsi("INVENTORY  AGING      Data Base de Fechamento  " + Dtoc(_dDataMovimento)) + "           Valores em R$"
aReturn     := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
aLinha      := { }
nomeprog    := "AGE01"
lAbortPrint := .F.
nLastKey    := 0
cbtxt       := SPACE(10)
cbcont      := 0
li          := 80
nCaract     := 15
m_pag       := 1
wnrel       := "AGE01"
cPerg       := ""
cString     := "SB1"
aOrd        := {}
Tamanho     := "G"
nPag        := 62
wnrel       := Setprint(cString, wnrel,cPerg, @Titulo, cDesc1, cDesc2, cDesc3, .f., aOrd, .t., Tamanho)

If LastKey() == 27 .Or. nLastkey == 27
	Return
EndIf
SetDefault(aReturn, cString)
If LastKey() == 27 .Or. nLastkey == 27
	Return
EndIf
nCaract    := IIF( aReturn[4]==1,15,18 )
Processa( {|| Imp2Detail()},"Impressao em andamento" )
Return

Static Function Imp2Detail()
dbSelectarea("MASTER")
dbGotop()
ProcRegua(RecCount())
dbGotop()
@ 00, 000 PSAY Chr(15)                // Compressao de Impressao
Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, nCaract )
li := 9
While !Eof()
	//INCPROC()
	If li >= 55
		Roda(cbcont,cbtxt,tamanho)
		@ 00, 000 PSAY Chr(15)                // Compressao de Impressao
		Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, nCaract )
		li := 9
	EndIf
	@ li, 0  pSay CODIGO +" "+ SubStr(NOME,1,34)+" "+TIPO+" " + GRUPO +" " + ;
	Transform(VLR00_30 ,"@E  99,999,999,999.99")+" !! " + transform(VLR31_60 ,"@E 99,999,999,999.99")+" !! "+  	;
	Transform(VLR61_90 ,"@E  99,999,999,999.99")+" !! " + transform(VLR91_180,"@E 99,999,999,999.99")+" !! "+  	;
	Transform(VLR181_360,"@E  99,999,999,999.99")+" !! " + transform(VLR361_540,"@E 99,999,999,999.99")+" !! "+  	;
	Transform(VLR540   ,"@E  99,999,999,999.99")
	
	VLR0030   :=   VLR0030    + MASTER->VLR00_30
	VLR3160   :=   VLR3160    + MASTER->VLR31_60
	VLR6190   :=   VLR6190    + MASTER->VLR61_90
	VLR91180  :=   VLR91180   + MASTER->VLR91_180
	VLR181540 :=   VLR181540  + MASTER->VLR181_360
	VLR541900 :=   VLR541900  + MASTER->VLR361_540
	VLR540x   :=   VLR540x    + MASTER->VLR540
	
	QTD0030   :=   QTD0030    + MASTER->QTD00_30
	QTD3160   :=   QTD3160    + MASTER->QTD31_60
	QTD6190   :=   QTD6190    + MASTER->QTD61_90
	QTD91180  :=   QTD91180   + MASTER->QTD91_180
	QTD181540 :=   QTD181540  + MASTER->QTD61_90
	QTD541900 :=   QTD541900  + MASTER->QTD91_180
	QTD540x   :=   QTD540x    + MASTER->QTD540
	
	dbSkip()
	li := li + 1
	If li >= 55
		Roda(cbcont,cbtxt,tamanho)
		@ 00, 000 PSAY Chr(15)                // Compressao de Impressao
		Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, nCaract )
		li := 9
	EndIf
Enddo

li := li + 1
If li >= 55
	Roda(cbcont,cbtxt,tamanho)
	@ 00, 000 PSAY Chr(15)                // Compressao de Impressao
	Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, nCaract )
	li := 9
EndIf

li := li + 1
If li >= 55
	Roda(cbcont,cbtxt,tamanho)
	@ 00, 000 PSAY Chr(15)                // Compressao de Impressao
	Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, nCaract )
	li := 9
EndIf

@ li, 0  pSay "                                                           " +;
Transform(VLR0030  ,"@E 99,999,999,999.99")+"    " + transform(VLR3160 ,"@E 99,999,999,999.99")+"    " +;     //12
Transform(VLR6190  ,"@E 99,999,999,999.99")+"    " + transform(VLR91180,"@E 99,999,999,999.99")+"    " +; //34
Transform(VLR181540,"@E 99,999,999,999.99")+"      " +Transform(VLR541900,"@E 99,999,999,999.99")+"      " +; //56
Transform(VLR540x  ,"@E 99,999,999,999.99")                                                                                //7

li := li + 2
If li >= 55
	Roda(cbcont,cbtxt,tamanho)
	@ 00, 000 PSAY Chr(15)                // Compressao de Impressao
	Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, nCaract )
	li := 9
EndIf

TipoTotal()
GrupoTotal()

li := li + 2
If li >= 55
	Roda(cbcont,cbtxt,tamanho)
	@ 00, 000 PSAY Chr(15)                // Compressao de Impressao
	Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, nCaract )
	li := 9
EndIf

@ li, 01 pSay "Total Geral R$ " + Transform(VLR0030+VLR3160+VLR6190+VLR91180+VLR181540+VLR541900+VLR540x,"@E 999,999,999.9999")

@ LI+3,01 PSAY "Empresa                     : " + cEMPRESA
@ LI+4,01 PSAY "Considera material terceiro : " + cEXIBETERCEIRO
@ LI+5,01 PSAY "Considera tipos             : " + _cTIPOCONSIDERA
@ LI+6,01 PSAY "Tipo saldo                  : " + cSB2SB9
@ LI+7,01 PSAY "Considera Almoxarifado      : " + cALMOX

Roda(cbcont,cbtxt,tamanho)
Set Device To Screen
If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()
dbSelectarea("MASTER")
dbGotop()
dbSelectArea('AGE1')
Return()

Static Function TipoTotal()
dbSelectarea("TIPO")
dbGotop()
ProcRegua(RecCount())
dbGotop()

li := li + 2
If li >= 55
	Roda(cbcont,cbtxt,tamanho)
	@ 00, 000 PSAY Chr(15)                // Compressao de Impressao
	Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, nCaract )
	li := 9
EndIf

While !Eof()
	//INCPROC()
	If li >= 55
		Roda(cbcont,cbtxt,tamanho)
		@ 00, 000 PSAY Chr(15)                // Compressao de Impressao
		Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, nCaract )
		li := 9
	EndIf
	@ li, 00 pSay "Totalizacao por Tipos"
	
	@ li, 0  pSay "Totalização por Tipos                              "+TIPO+"      " + ;
	Transform(VLR00_30  ,"@E  99,999,999,999.99")+" !! " + transform(VLR31_60  ,"@E 99,999,999,999.99")+" !! "+  	;
	Transform(VLR61_90  ,"@E  99,999,999,999.99")+" !! " + transform(VLR91_180 ,"@E 99,999,999,999.99")+" !! "+  	;
	Transform(VLR181_360,"@E  99,999,999,999.99")+" !! " + transform(VLR361_540,"@E 99,999,999,999.99")+" !! "+  	;
	Transform(VLR540    ,"@E  99,999,999,999.99")
	
	dbSkip()
	
	li := li + 1
	If li >= 55
		Roda(cbcont,cbtxt,tamanho)
		@ 00, 000 PSAY Chr(15)                // Compressao de Impressao
		Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, nCaract )
		li := 9
	EndIf
Enddo
Return()

Static Function GrupoTotal()
dbSelectarea("fGrupo")
dbGotop()
ProcRegua(RecCount())
dbGotop()

li := li + 2
If li >= 55
	Roda(cbcont,cbtxt,tamanho)
	@ 00, 000 PSAY Chr(15)                // Compressao de Impressao
	Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, nCaract )
	li := 9
EndIf

While !Eof()
	//INCPROC()
	If li >= 55
		Roda(cbcont,cbtxt,tamanho)
		@ 00, 000 PSAY Chr(15)                // Compressao de Impressao
		Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, nCaract )
		li := 9
	EndIf
	@ li, 00 pSay "Totalizacao por Grupos"
	
	@ li, 0  pSay "Totalização por Grupos                                "+Grupo+" " +;
	Transform(VLR00_30  ,"@E  99,999,999,999.99")+" !! " + transform(VLR31_60  ,"@E 99,999,999,999.99")+" !! "+  	;
	Transform(VLR61_90  ,"@E  99,999,999,999.99")+" !! " + transform(VLR91_180 ,"@E 99,999,999,999.99")+" !! "+  	;
	Transform(VLR181_360,"@E  99,999,999,999.99")+" !! " + transform(VLR361_540,"@E 99,999,999,999.99")+" !! "+  	;
	Transform(VLR540    ,"@E  99,999,999,999.99")
	
	dbSkip()
	li := li + 1
	If li >= 55
		Roda(cbcont,cbtxt,tamanho)
		@ 00, 000 PSAY Chr(15)                // Compressao de Impressao
		Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, nCaract )
		li := 9
	EndIf
Enddo
Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 18/05/2005
// Distribui o Saldo nos Peridos

Static Function Distribui()
// Busca padroes no arquivo resultante resultante
dbSelectArea('AGE1')
dbGotop()
ProcRegua(RECCOUNT())
dbGoTop()
_nSaldoTMP	:= 0
While !eof()
	//INCPROC()
	// Ira Reduzir o SALDO do fechamento dos periodos ate o zeramento total do SALDO
	// Guarda o valor do saldo para reduzir nos periodos
	_nSaldoTMP	:= AGE1->SALDO
	If AGE1->QTDE00_30 <> 0         // Somente continua se este periodo tiver saldo
		// O Periodo tem saldo para reduzir
		// Verifica quem tem valor maior o SALDO ou o Saldo do Periodo
		If _nSaldoTMP >= AGE1->QTDE00_30
			// Diminui a variavel Atualiza a variavel
			_nSaldoTMP := _nSaldoTMP - AGE1->QTDE00_30
			RecLock('AGE1',.F.)
			VLR00_30  :=   AGE1->QTDE00_30 * AGE1->C_UNIT
			AGE1->(MsUnlock())
		Else
			RecLock('AGE1',.F.)
			VLR00_30  :=   _nSaldoTMP * AGE1->C_UNIT
			AGE1->(MsUnlock())
			// Zera a variavel acumuladora
			_nSaldoTMP := 0
			dbSkip()
			Loop
		Endif
	Endif
	
	// PERIDODO DE 31 / 60
	If AGE1->QTDE31_60 <> 0         // Somente continua se este periodo tiver saldo
		// O Periodo tem saldo para reduzir
		// Verifica quem tem valor maior o SALDO ou o Saldo do Periodo
		If _nSaldoTMP >= AGE1->QTDE31_60
			// Diminui a variavel Atualiza a variavel
			_nSaldoTMP := _nSaldoTMP - AGE1->QTDE31_60
			RecLock('AGE1',.F.)
			VLR31_60  :=   AGE1->QTDE31_60 * AGE1->C_UNIT
			AGE1->(MsUnlock())
		Else
			RecLock('AGE1',.F.)
			VLR31_60  :=   _nSaldoTMP * AGE1->C_UNIT
			AGE1->(MsUnlock())
			// Zera a variavel acumuladora
			_nSaldoTMP := 0
			dbSkip()
			Loop
		Endif
	Endif
	
	// PERIDODO DE 61 / 90
	If AGE1->QTDE61_90 <> 0         // Somente continua se este periodo tiver saldo
		// O Periodo tem saldo para reduzir
		// Verifica quem tem valor maior o SALDO ou o Saldo do Periodo
		If _nSaldoTMP >= AGE1->QTDE61_90
			// Diminui a variavel Atualiza a variavel
			_nSaldoTMP := _nSaldoTMP - AGE1->QTDE61_90
			RecLock('AGE1',.F.)
			VLR61_90  :=   AGE1->QTDE61_90 * AGE1->C_UNIT
			AGE1->(MsUnlock())
		Else
			RecLock('AGE1',.F.)
			VLR61_90  :=   _nSaldoTMP * AGE1->C_UNIT
			AGE1->(MsUnlock())
			// Zera a variavel acumuladora
			_nSaldoTMP := 0
			dbSkip()
			Loop
		Endif
	Endif
	
	
	// PERIDODO DE 91 / 180
	If AGE1->QTDE91_180 <> 0         // Somente continua se este periodo tiver saldo
		// O Periodo tem saldo para reduzir
		// Verifica quem tem valor maior o SALDO ou o Saldo do Periodo
		If _nSaldoTMP >= AGE1->QTDE91_180
			// Diminui a variavel Atualiza a variavel
			_nSaldoTMP := _nSaldoTMP - AGE1->QTDE91_180
			RecLock('AGE1',.F.)
			VLR91_180  :=   AGE1->QTDE91_180 * AGE1->C_UNIT
			AGE1->(MsUnlock())
		Else
			RecLock('AGE1',.F.)
			VLR91_180  :=   _nSaldoTMP * AGE1->C_UNIT
			AGE1->(MsUnlock())
			// Zera a variavel acumuladora
			_nSaldoTMP := 0
			dbSkip()
			Loop
		Endif
	Endif
	
	// PERIDODO DE 181 / 540
	If AGE1->QTDE81_360 <> 0         // Somente continua se este periodo tiver saldo
		// O Periodo tem saldo para reduzir
		// Verifica quem tem valor maior o SALDO ou o Saldo do Periodo
		If _nSaldoTMP >= AGE1->QTDE81_360
			// Diminui a variavel Atualiza a variavel
			_nSaldoTMP := _nSaldoTMP - AGE1->QTDE81_360
			RecLock('AGE1',.F.)
			VLR61_90  :=   AGE1->QTDE81_360 * AGE1->C_UNIT
			AGE1->(MsUnlock())
		Else
			RecLock('AGE1',.F.)
			VLR181_360  :=   _nSaldoTMP * AGE1->C_UNIT
			AGE1->(MsUnlock())
			// Zera a variavel acumuladora
			_nSaldoTMP := 0
			dbSkip()
			Loop
		Endif
	Endif
	
	
	// PERIDODO DE 541 / 900
	If AGE1->QTDE61_540 <> 0         // Somente continua se este periodo tiver saldo
		// O Periodo tem saldo para reduzir
		// Verifica quem tem valor maior o SALDO ou o Saldo do Periodo
		If _nSaldoTMP >= AGE1->QTDE61_540
			// Diminui a variavel Atualiza a variavel
			_nSaldoTMP := _nSaldoTMP - AGE1->QTDE61_540
			RecLock('AGE1',.F.)
			VLR361_540  :=   AGE1->QTDE61_540 * AGE1->C_UNIT
			AGE1->(MsUnlock())
		Else
			RecLock('AGE1',.F.)
			VLR361_540  :=   _nSaldoTMP * AGE1->C_UNIT
			AGE1->(MsUnlock())
			// Zera a variavel acumuladora
			_nSaldoTMP := 0
			dbSkip()
			Loop
		Endif
	Endif
	
	// PERIDODO DE 900  EM DIANTE
	If AGE1->QTDE540 <> 0         // Somente continua se este periodo tiver saldo
		// O Periodo tem saldo para reduzir
		// Verifica quem tem valor maior o SALDO ou o Saldo do Periodo
		If _nSaldoTMP >= AGE1->QTDE540
			// Diminui a variavel Atualiza a variavel
			_nSaldoTMP := _nSaldoTMP - AGE1->QTDE540
			RecLock('AGE1',.F.)
			VLR540    :=   AGE1->QTDE540 * AGE1->C_UNIT
			AGE1->(MsUnlock())
		Else
			RecLock('AGE1',.F.)
			VLR540    :=  _nSaldoTMP * AGE1->C_UNIT
			AGE1->(MsUnlock())
			// Zera a variavel acumuladora
			_nSaldoTMP := 0
			dbSkip()
			Loop
		Endif
	Endif
	**********************************************************************************************
	
	// VERIFICA SE FICOU RESIDUO DO SALDO, HAVENDO DESCARREGA O SALDO NA ULTIMA ENTRADA
	// PERIDODO DE 180  EM DIANTE
	If _nSaldoTMP <> 0
		RecLock('AGE1',.F.)
		VLR540    :=    VLR540 + (_nSaldoTMP * AGE1->C_UNIT)
		AGE1->(MsUnlock())
	Endif
	dbSelectArea('AGE1')
	dbSkip()
Enddo
Return()

Static Function GeraMaster()
_CustoAtu := 0
// Aglutina codigos iguais
dbSelectArea("AGE1")
dbGotop()
ProcRegua(RECCOUNT())
dbGotop()
While !eof()
	//INCPROC()
	dbSelectArea("MASTER")
	If !dbSeek(AGE1->CODIGO)
		dbSelectArea("MASTER")
		RecLock('MASTER',.T.)
		CODIGO	    := AGE1->CODIGO
		NOME	    := AGE1->NOME
		TIPO        := AGE1->TIPO
		GRUPO       := AGE1->GRUPO
		SALDO	    := AGE1->SALDO
		SOMAENT	    := AGE1->SOMAENT
		
		QTDE00_30	:= AGE1->QTDE00_30
		QTDE31_60	:= AGE1->QTDE31_60
		QTDE61_90	:= AGE1->QTDE61_90
		QTDE91_180	:= AGE1->QTDE91_180
		QTDE81_360	:= AGE1->QTDE81_360
		QTDE61_540	:= AGE1->QTDE61_540
		QTDE540	    := AGE1->QTDE540
		
		VLR00_30	:= AGE1->VLR00_30
		VLR31_60	:= AGE1->VLR31_60
		VLR61_90	:= AGE1->VLR61_90
		VLR91_180	:= AGE1->VLR91_180
		VLR181_360	:= AGE1->VLR181_360
		VLR361_540	:= AGE1->VLR361_540
		VLR540  	:= AGE1->VLR540
		
		
		C_UNIT	:= AGE1->C_UNIT
		C_TOTAL	:= AGE1->C_TOTAL
		
		If AGE1->C_UNIT > 0
			QTD00_30	:= AGE1->VLR00_30/AGE1->C_UNIT
		EndIf
		If AGE1->C_UNIT > 0
			QTD31_60	:= AGE1->VLR31_60/AGE1->C_UNIT
		EndIf
		If AGE1->C_UNIT > 0
			QTD61_90	:= AGE1->VLR61_90/AGE1->C_UNIT
		EndIf
		If AGE1->C_UNIT > 0
			QTD91_180	:= AGE1->VLR91_180/AGE1->C_UNIT
		EndIf
		If AGE1->C_UNIT > 0
			QTD181_360	:= AGE1->VLR181_360/AGE1->C_UNIT
		EndIf
		If AGE1->C_UNIT > 0
			QTD361_540	:= AGE1->VLR361_540/AGE1->C_UNIT
		EndIf
		If AGE1->C_UNIT > 0
			QTD540	:= AGE1->VLR540/AGE1->C_UNIT
		EndIf
		
		nITEM :=1
		lLOOP :=.T.
		DO WHILE lLOOP==.T.
			cPEST :=SUBSTR(cALMOX,nITEM,2)
			IF !EMPTY(SUBSTR(cALMOX,nITEM,2))
				cPest :='PE' +(cPest)//+'"'
				cVLPE :='VLR'+(cPest)
				IF cSB2SB9=='CM'
					
					&(cPEST) :=POSICIONE("SB2",1,XFILIAL("SB2")+AGE1->CODIGO+alltrim(substr(cPEST,3,2)),"SB2->B2_QFIM")
					&(cVLPE) :=POSICIONE("SB2",1,XFILIAL("SB2")+AGE1->CODIGO+alltrim(substr(cPEST,3,2)),"SB2->B2_VFIM1")//MLS
				ELSE
					&(cPEST):=POSICIONE("SB9",1,XFILIAL("SB9")+AGE1->CODIGO+alltrim(substr(cPEST,3,2))+DTOS(_dDataMovimento),"SB9->B9_QINI")
					&(cVLPE):=POSICIONE("SB9",1,XFILIAL("SB9")+AGE1->CODIGO+alltrim(substr(cPEST,3,2))+DTOS(_dDataMovimento),"SB9->B9_VINI1")//MLS
				ENDIF
			ELSE
				lLOOP :=.F.
			ENDIF
			nITEM :=nITEM+3
		ENDDO
		
		MASTER->(MsUnlock())
		
	Else
		dbSelectArea("MASTER")
		RecLock('MASTER',.F.)
		QTDE00_30	:= QTDE00_30 + AGE1->QTDE00_30
		QTDE31_60	:= QTDE31_60 + AGE1->QTDE31_60
		QTDE61_90	:= QTDE61_90 + AGE1->QTDE61_90
		QTDE91_180	:= QTDE91_180 + AGE1->QTDE91_180
		QTDE81_360	:= QTDE81_360 + AGE1->QTDE81_360
		QTDE61_540	:= QTDE61_540 + AGE1->QTDE61_540
		QTDE540	:= QTDE540 + AGE1->QTDE540
		
		
		VLR00_30	:= VLR00_30  + AGE1->VLR00_30
		VLR31_60	:= VLR31_60  + AGE1->VLR31_60
		VLR61_90	:= VLR61_90  + AGE1->VLR61_90
		VLR91_180	:= VLR91_180 + AGE1->VLR91_180
		VLR181_360	:= VLR181_360  + AGE1->VLR181_360
		VLR361_540	:= VLR361_540  + AGE1->VLR361_540
		VLR540  	:= VLR540      + AGE1->VLR540
		
		
		If AGE1->C_UNIT > 0
			QTD00_30	:= AGE1->VLR00_30/AGE1->C_UNIT
		EndIf
		If AGE1->C_UNIT > 0
			QTD31_60	:= AGE1->VLR31_60/AGE1->C_UNIT
		EndIf
		If AGE1->C_UNIT > 0
			QTD61_90	:= AGE1->VLR61_90/AGE1->C_UNIT
		EndIf
		If AGE1->C_UNIT > 0
			QTD91_180	:= AGE1->VLR91_180/AGE1->C_UNIT
		EndIf
		If AGE1->C_UNIT > 0
			QTD181_360	:= AGE1->VLR181_360/AGE1->C_UNIT
		EndIf
		If AGE1->C_UNIT > 0
			QTD361_540	:= AGE1->VLR361_540/AGE1->C_UNIT
		EndIf
		If AGE1->C_UNIT > 0
			QTD540	:= AGE1->VLR540/AGE1->C_UNIT
		EndIf
		
		MASTER->(MsUnlock())
	Endif
	dbSelectArea("AGE1")
	dbSkip()
Enddo
Return()

/*

DESABILITADO EM 20041119
Static Function VerCusto(_cCodigo,_dDeData,_dAteData)
Custo := 0

cArq    := CriaTrab(NIL,.f.)

cCust := "SELECT SB9.B9_VINI1 Total, SB9.B9_QINI QTSALDO"
cCust := cCust + "  FROM "
cCust := cCust + RetSqlName("SB9") + ' SB9 WHERE'
cCust := cCust + "  SB9.D_E_L_E_T_ <> '*' "
cCust := cCust + "  AND   SB9.B9_FILIAL = '" +XFILIAL("SB9") + "' "
cCust := cCust + "  AND   SB9.B9_COD = '"    + _cCodigo + "' "
cCust := cCust + "  AND   SB9.B9_QINI > 0"
cCust := cCust + "  AND   SB9.B9_DATA BETWEEN " + Dtos(_dAteData) + " AND "  + Dtos(_dDeData)

TCQUERY cCust ALIAS Cust NEW

_TotQtd := 0
_TotVal := 0

dbSelectArea("Cust")
dbGotop()
While !EOF()
_TotQtd := _TotQtd + Cust->Total
_TotVal := _totVal + Cust->QTSALDO
DbSkip()
Enddo

Custo := _TotVal/_TotQtd
DbSelectArea("Cust")
DbCloseArea()
Return(Custo)

*/

Static Function S2OMAENT()
dbSelectArea('MASTER')
dbGotop()
ProcRegua(RECCOUNT())
dbGoTop()
While !eof()
	//INCPROC()
	RecLock('MASTER',.F.)
	// Soma as entrada nos peridos
	SOMAENT	:= (QTDE00_30 + QTDE31_60 + QTDE61_90 + QTDE91_180 + QTDE81_360 + QTDE61_540 + QTDE540)
	
	// Calcula as diferencas
	//DIFEREN	:= C_TOTAL - SOMAENT
	
	MASTER->(MsUnlock())
	dbSkip()
Enddo
Return()



//////////////////////////////////////////////////////////////////////
// ESte bloco trata componentes que nao tiveram entrada por nota fiscal mais tem saldo no
// SB9, proveniente de uma entrada interna de saldo inicial

Static Function SB9SemEntrada()

dbSelectArea('TMPSB91')
dbGotop()
ProcRegua(RECCOUNT())
dbGoTop()
While !eof()
	//INCPROC()
	dbSelectArea('AGE1')
	If !dbSeek(TMPSB91->CODIGO)
		// Nao achou faz inclusao manual
		dbSelectArea('SB1')
		dbSetOrder(1)
		dbSeek(Xfilial('SB1') + TMPSB91->CODIGO)
		
		
		dbSelectArea('AGE1')
		RecLock('AGE1',.T.)
		NOME 	      := SB1->B1_DESC
		TIPO        := SB1->B1_TIPO
		GRUPO       := SB1->B1_GRUPO
		CODIGO      := TMPSB91->CODIGO
		SALDO       := TMPSB91->QTSALDO
		C_UNIT    := TMPSB91->VALORTOT / TMPSB91->QTSALDO
		C_TOTAL    := TMPSB91->VALORTOT
		AGE1->(MsUnlock())
	Endif
	dbSelectArea('TMPSB91')
	dbSkip()
Enddo
Return()

Static Function GeraTipo()
// Aglutina Tipos iguais
dbSelectArea("MASTER")
dbGotop()
ProcRegua(RECCOUNT())
dbGotop()
While !eof()
	//INCPROC()
	dbSelectArea("TIPO")
	If !dbSeek(MASTER->TIPO)
		dbSelectArea("TIPO")
		RecLock('TIPO',.T.)
		CODIGO	    := MASTER->CODIGO
		NOME	    := MASTER->NOME
		TIPO        := MASTER->TIPO
		GRUPO       := MASTER->GRUPO
		SALDO	    := MASTER->SALDO
		SOMAENT	    := MASTER->SOMAENT
		QTDE00_30	:= MASTER->QTDE00_30
		QTDE31_60	:= MASTER->QTDE31_60
		QTDE61_90	:= MASTER->QTDE61_90
		QTDE91_180	:= MASTER->QTDE91_180
		QTDE81_360	:= MASTER->QTDE81_360
		QTDE61_540	:= MASTER->QTDE61_540
		QTDE540	    := MASTER->QTDE540
		
		
		
		QTD00_30	:= MASTER->QTD00_30
		QTD31_60	:= MASTER->QTD31_60
		QTD61_90	:= MASTER->QTD61_90
		QTD91_180	:= MASTER->QTD91_180
		QTD181_360	:= MASTER->QTD181_360
		QTD361_540	:= MASTER->QTD361_540
		QTD540	    := MASTER->QTD540
		
		
		VLR00_30	:= MASTER->VLR00_30
		VLR31_60	:= MASTER->VLR31_60
		VLR61_90	:= MASTER->VLR61_90
		VLR91_180	:= MASTER->VLR91_180
		VLR181_360	:= MASTER->VLR181_360
		VLR361_540	:= MASTER->VLR361_540
		VLR540  	:= MASTER->VLR540
		
		
		C_UNIT	:= MASTER->C_UNIT
		C_TOTAL	:= MASTER->C_TOTAL
		
		//S      	:= MASTER->S
		TIPO->(MsUnlock())
	Else
		dbSelectArea("TIPO")
		RecLock('TIPO',.F.)
		QTDE00_30	:= QTDE00_30 + MASTER->QTDE00_30
		QTDE31_60	:= QTDE31_60 + MASTER->QTDE31_60
		QTDE61_90	:= QTDE61_90 + MASTER->QTDE61_90
		QTDE91_180	:= QTDE91_180 + MASTER->QTDE91_180
		QTDE81_360	:= QTDE81_360 + MASTER->QTDE81_360
		QTDE61_540	:= QTDE61_540 + MASTER->QTDE61_540
		QTDE540	    := QTDE540 + MASTER->QTDE540
		
		
		QTD00_30	:= QTD00_30 + MASTER->QTD00_30
		QTD31_60	:= QTD31_60 + MASTER->QTD31_60
		QTD61_90	:= QTD61_90 + MASTER->QTD61_90
		QTD91_180	:= QTD91_180 + MASTER->QTD91_180
		QTD181_360	:= QTD181_360 + MASTER->QTD181_360
		QTD361_540	:= QTD361_540 + MASTER->QTD361_540
		QTD540	    := QTD540 + MASTER->QTD540
		
		
		
		VLR00_30	:= VLR00_30  + MASTER->VLR00_30
		VLR31_60	:= VLR31_60  + MASTER->VLR31_60
		VLR61_90	:= VLR61_90  + MASTER->VLR61_90
		VLR91_180	:= VLR91_180 + MASTER->VLR91_180
		VLR181_360	:= VLR181_360  + MASTER->VLR181_360
		VLR361_540	:= VLR361_540  + MASTER->VLR361_540
		VLR540  	:= VLR540    + MASTER->VLR540
		
		TIPO->(MsUnlock())
	Endif
	dbSelectArea("MASTER")
	dbSkip()
Enddo
Return()

Static Function GeraGrupo()
// Aglutina Grupo iguais
dbSelectArea("MASTER")
dbGotop()
ProcRegua(RECCOUNT())
dbGotop()
While !eof()
	//INCPROC()
	dbSelectArea("fGrupo")
	If !dbSeek(MASTER->GRUPO)
		dbSelectArea("fGrupo")
		RecLock('fGrupo',.T.)
		CODIGO	    := MASTER->CODIGO
		NOME	    := MASTER->NOME
		TIPO        := MASTER->TIPO
		GRUPO       := MASTER->GRUPO
		SALDO	    := MASTER->SALDO
		SOMAENT	    := MASTER->SOMAENT
		QTDE00_30	:= MASTER->QTDE00_30
		QTDE31_60	:= MASTER->QTDE31_60
		QTDE61_90	:= MASTER->QTDE61_90
		QTDE91_180	:= MASTER->QTDE91_180
		QTDE81_360	:= MASTER->QTDE81_360
		QTDE61_540	:= MASTER->QTDE61_540
		QTDE540	    := MASTER->QTDE540
		
		
		QTD00_30	:= MASTER->QTD00_30
		QTD31_60	:= MASTER->QTD31_60
		QTD61_90	:= MASTER->QTD61_90
		QTD91_180	:= MASTER->QTD91_180
		QTD181_360	:= MASTER->QTD181_360
		QTD361_540	:= MASTER->QTD361_540
		QTD540	    := MASTER->QTD540
		
		
		VLR00_30	:= MASTER->VLR00_30
		VLR31_60	:= MASTER->VLR31_60
		VLR61_90	:= MASTER->VLR61_90
		VLR91_180	:= MASTER->VLR91_180
		VLR181_360	:= MASTER->VLR181_360
		VLR361_540	:= MASTER->VLR361_540
		VLR540  	:= MASTER->VLR540
		
		
		
		C_UNIT	:= MASTER->C_UNIT
		C_TOTAL	:= MASTER->C_TOTAL
		//S      	:= MASTER->S
		fGrupo->(MsUnlock())
	Else
		dbSelectArea("fGrupo")
		RecLock('fGrupo',.F.)
		QTDE00_30	:= QTDE00_30 + MASTER->QTDE00_30
		QTDE31_60	:= QTDE31_60 + MASTER->QTDE31_60
		QTDE61_90	:= QTDE61_90 + MASTER->QTDE61_90
		QTDE91_180	:= QTDE91_180 + MASTER->QTDE91_180
		QTDE81_360	:= QTDE81_360 + MASTER->QTDE81_360
		QTDE61_540	:= QTDE61_540 + MASTER->QTDE61_540
		QTDE540	    := QTDE540 + MASTER->QTDE540
		
		
		QTD00_30	:= QTD00_30 + MASTER->QTD00_30
		QTD31_60	:= QTD31_60 + MASTER->QTD31_60
		QTD61_90	:= QTD61_90 + MASTER->QTD61_90
		QTD91_180	:= QTD91_180 + MASTER->QTD91_180
		QTD181_360	:= QTD181_360 + MASTER->QTD181_360
		QTD361_540	:= QTD361_540 + MASTER->QTD361_540
		QTD540	    := QTD540 + MASTER->QTD540
		
		
		VLR00_30	:= VLR00_30  + MASTER->VLR00_30
		VLR31_60	:= VLR31_60  + MASTER->VLR31_60
		VLR61_90	:= VLR61_90  + MASTER->VLR61_90
		VLR91_180	:= VLR91_180 + MASTER->VLR91_180
		VLR181_360	:= VLR181_360  + MASTER->VLR181_360
		VLR361_540	:= VLR361_540  + MASTER->VLR361_540
		VLR540  	:= VLR540    + MASTER->VLR540
		
		
		fGrupo->(MsUnlock())
		
	Endif
	dbSelectArea("MASTER")
	dbSkip()
Enddo
Return()



//------------------------WEEK
Static Function Imp1WEEK()
aWEEK1              := {}
aWEEKCampos		    := {}

aAdd( aWEEKCampos, { "TIPO"    ,"C"  ,2,0  } )
aAdd( aWEEKCampos, { "FAIXA"   ,"C"  ,1,0  } )
aAdd( aWEEKCampos, { "D_FAIXA" ,"C"  ,20,0 } )
aAdd( aWEEKCampos, { "CODIGO"  ,"C"  ,15,0 } )
aAdd( aWEEKCampos, { "NOME"    ,"C"  ,50,0 } )
aAdd( aWEEKCampos, { "VALOR"   ,"N"  ,16,4 } )

WEEK1   := CriaTrab( aWEEKCampos, .t. )
dbUseArea(.T.,,WEEK1,"WEEK1",.F.,.F.)
cKey   := "TIPO+FAIXA+STR(VALOR)"
cCond  := ""
cIndex := CriaTrab(NIL,.F.)
IndRegua( "WEEK1" ,cIndex ,cKey ,"D",cCond ,"Indexando Arq.Temporario")

//----------------------------
dbSelectArea("MASTER")
dbGotop()
ProcRegua(RECCOUNT())
dbGotop()
While !eof()
	//INCPROC()
	dbSelectArea("MASTER")
	
	//If !dbSeek(MASTER->CODIGO)
	
	dbSelectArea("WEEK1")
	
	//00A30
	RecLock('WEEK1',.T.)
	IF MASTER->TIPO <> 'PA' .OR. MASTER->TIPO <> 'PI'
		//TIPO   :='MP'
		TIPO   :=MASTER->TIPO
	ELSE
		TIPO   :=MASTER->TIPO
	ENDIF
	CODIGO   :=MASTER->CODIGO
	NOME     :=MASTER->NOME
	D_FAIXA  :="00A30"
	FAIXA    :='1'
	VALOR    :=MASTER->VLR00_30
	WEEK1->(MsUnlock())
	//31A60
	RecLock('WEEK1',.T.)
	IF MASTER->TIPO <> 'PA' .OR. MASTER->TIPO <> 'PI'
		//TIPO   :='MP'
		TIPO   :=MASTER->TIPO
	ELSE
		TIPO   :=MASTER->TIPO
	ENDIF
	TIPO     :=MASTER->TIPO
	CODIGO   :=MASTER->CODIGO
	NOME     :=MASTER->NOME
	D_FAIXA  :="31A60"
	FAIXA    :='2'
	VALOR    :=MASTER->VLR31_60
	WEEK1->(MsUnlock())
	//61A90
	RecLock('WEEK1',.T.)
	IF MASTER->TIPO <> 'PA' .OR. MASTER->TIPO <> 'PI'
		//TIPO   :='MP'
		TIPO   :=MASTER->TIPO
	ELSE
		TIPO   :=MASTER->TIPO
	ENDIF
	TIPO     :=MASTER->TIPO                  //mauricio tipo
	CODIGO   :=MASTER->CODIGO
	NOME     :=MASTER->NOME
	D_FAIXA  :="61A90"
	FAIXA    :='3'
	VALOR    :=MASTER->VLR61_90
	WEEK1->(MsUnlock())
	//91A180
	RecLock('WEEK1',.T.)
	IF MASTER->TIPO <> 'PA' .OR. MASTER->TIPO <> 'PI'
		//TIPO   :='MP'
		TIPO   :=MASTER->TIPO
	ELSE
		TIPO   :=MASTER->TIPO
	ENDIF
	TIPO     :=MASTER->TIPO
	CODIGO   :=MASTER->CODIGO
	NOME     :=MASTER->NOME
	D_FAIXA  :="91A180"
	FAIXA    :='4'
	VALOR    :=MASTER->VLR91_180
	WEEK1->(MsUnlock())
	//181A360
	RecLock('WEEK1',.T.)
	IF MASTER->TIPO <> 'PA' .OR. MASTER->TIPO <> 'PI'
		//TIPO   :='MP'
		TIPO   :=MASTER->TIPO
	ELSE
		TIPO   :=MASTER->TIPO
	ENDIF
	TIPO     :=MASTER->TIPO
	CODIGO   :=MASTER->CODIGO
	NOME     :=MASTER->NOME
	D_FAIXA  :="181A360"
	FAIXA    :='5'
	VALOR    :=MASTER->VLR181_360
	WEEK1->(MsUnlock())
	//361A540
	RecLock('WEEK1',.T.)
	IF MASTER->TIPO <> 'PA' .OR. MASTER->TIPO <> 'PI'
		//TIPO   :='MP'
		TIPO   :=MASTER->TIPO
	ELSE
		TIPO   :=MASTER->TIPO
	ENDIF
	TIPO     :=MASTER->TIPO
	CODIGO   :=MASTER->CODIGO
	NOME     :=MASTER->NOME
	D_FAIXA  :="361A540"
	FAIXA    :='6'
	VALOR    :=MASTER->VLR361_540
	WEEK1->(MsUnlock())
	//+540
	RecLock('WEEK1',.T.)
	IF MASTER->TIPO <> 'PA' .OR. MASTER->TIPO <> 'PI'
		//TIPO   :='MP'
		TIPO   :=MASTER->TIPO
		
	ELSE
		TIPO   :=MASTER->TIPO
	ENDIF
	TIPO     :=MASTER->TIPO
	CODIGO   :=MASTER->CODIGO
	NOME     :=MASTER->NOME
	D_FAIXA  :="+540"
	FAIXA    :='7'
	VALOR    :=MASTER->VLR540
	WEEK1->(MsUnlock())
	
	//Endif
	dbSelectArea("MASTER")
	dbSkip()
Enddo
//-----------------------------------------------------------------------

aWEEK2              := {}
aWEEK2CPOS		    := {}

aAdd( aWEEK2CPOS, { "TIPO"    ,"C"  ,2,0  } )
aAdd( aWEEK2CPOS, { "FAIXA"   ,"C"  ,1,0  } )
aAdd( aWEEK2CPOS, { "D_FAIXA" ,"C"  ,20,0 } )
aAdd( aWEEK2CPOS, { "CODIGO"  ,"C"  ,15,0 } )
aAdd( aWEEK2CPOS, { "NOME"    ,"C"  ,50,0 } )
aAdd( aWEEK2CPOS, { "VALOR"   ,"N"  ,16,4 } )

WEEK2   := CriaTrab( aWEEK2CPOS, .t. )
dbUseArea(.T.,,WEEK2,"WEEK2",.F.,.F.)
cKey   := "TIPO+FAIXA+STR(VALOR)"
cCond  := ""
cIndex := CriaTrab(NIL,.F.)
IndRegua( "WEEK2" ,cIndex ,cKey ,,cCond ,"Indexando Arq.Temporario")

dbSelectArea("WEEK1")
dbGotop()
While !eof()
	dbSelectArea("WEEK1")
	nCONT    := 0
	S_VALOR  := 0
	L_VALOR  := .F.
	cTIPO    := WEEK1->TIPO
	cFAIXA   := WEEK1->FAIXA
	While !eof() .and. WEEK1->TIPO == cTIPO .AND. WEEK1->FAIXA=cFAIXA
		dbSelectArea("WEEK2")
		nCONT  := nCONT+1
		IF alltrim(str(nCONT)) $"1|2|3|4|5"
			RecLock('WEEK2',.T.)
			TIPO     :=WEEK1->TIPO
			CODIGO   :=WEEK1->CODIGO
			NOME     :=WEEK1->NOME
			D_FAIXA  :=WEEK1->D_FAIXA
			FAIXA    :=WEEK1->FAIXA
			VALOR    :=WEEK1->VALOR
			WEEK2->(MsUnlock())
		ELSE
			S_VALOR    :=S_VALOR+WEEK1->VALOR
			L_VALOR    :=.T.
			cTIPO2     :=WEEK1->TIPO
			cD_FAIXA2  :=WEEK1->D_FAIXA
			cFAIXA     :=WEEK1->FAIXA
		ENDIF
		dbSelectArea("WEEK1")
		dbSkip()
	ENDDO
	IF L_VALOR ==.T.
		RecLock('WEEK2',.T.)
		TIPO     :=cTIPO2
		CODIGO   :="OUTROS"
		NOME     :="OUTROS"
		D_FAIXA  :=cD_FAIXA2
		FAIXA    :=cFAIXA
		VALOR    :=S_VALOR
		WEEK2->(MsUnlock())
	ENDIF
	dbSelectArea("WEEK1")
ENDDO

dbSelectArea("WEEK2")
COPY TO WEEK2
dbSelectArea("WEEK1")
COPY TO WEEK1

//WEEK1->(DbCloseArea())
//MSGALERT("GERADO WEEK2.DBF")
RETURN
//----------------------------


Static Function GerMdbf()  // gera master.dbf //mls
Local aArea		:= GetArea()
dbSelectArea('MASTER')
cKey   := "GRUPO+STR(C_TOTAL)"
cCond  := ""
cIndex := CriaTrab(NIL,.F.)
IndRegua( "MASTER" ,cIndex ,cKey ,,cCond ,"Indexando Arq.Temporario")

IF SM0->M0_CODIGO =='01'     // .OR. SM0->M0_CODIGO =='02'
	copy to MASTER_OMA.DBF
	If ! AvCpyFile("MASTER_OMA.DBF","C:\TEMP\MASTER_OMA.DBF")
		//		MsgStop("Nao foi possivel gerar o arquivo "+CHR(13)+CHR(10)+" C:\TEMP\MASTER_OMA.DBF"+CHR(13)+CHR(10)+" Verifique se está sendo utilizado "+CHR(13)+CHR(10)+" ou se existe o diretorio C:\TEMP\")
	ELSE
		//		MsgBox("Foi gerado arquivo com detalhes de nome "+CHR(13)+CHR(10)+" C:\TEMP\MASTER_OMA.DBF")
	Endif
	FERASE("MASTER_CER.DBF")
ELSE
	copy to MASTER_CER.DBF
	If ! AvCpyFile("MASTER_CER.DBF","C:\TEMP\MASTER_CER.DBF")
		//		MsgStop("Nao foi possivel gerar o arquivo "+CHR(13)+CHR(10)+"  C:\TEMP\MASTER_CER.DBF"+CHR(13)+CHR(10)+" Verifique se está sendo utilizado "+CHR(13)+CHR(10)+" ou se existe o diretorio C:\TEMP\")
	ELSE
		//		MsgBox("Foi gerado arquivo com detalhes de nome"+CHR(13)+CHR(10)+" C:\TEMP\MASTER_CER.DBF")
	Endif
	FERASE("MASTER_CER.DBF")
ENDIF

RestArea( aArea )

return



