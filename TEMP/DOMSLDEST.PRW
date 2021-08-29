#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "MSOBJECT.CH"
#include "Topconn.ch"     
#include "TbiConn.ch"               
#include "TbiCode.ch"


*------------------------------------------------------
USER FUNCTION DOMSLDEST()
*------------------------------------------------------

Local oFont1 	  := TFont():New("Arial Narrow",,022,,.F.,,,,,.F.,.F.)
Local _cPAR01     := DATE()
Local _cPAR02     := DATE()
Local _cPAR03     := 'PA/PI/MP'
Local _cPAR04     := "C:\TEMP\ESTOQUE_NEGATIVO.DBF"
Local oGet1
Local oGet2
Local oGet3
Local oGet4
Local oSButton1
Local oSButton2
Static oDlgEST

PRIVATE ccadastro := 'Estoque Negativo'
PRIVATE lImport   := .F.
PRIVATE cTIPO     := SPACE(02)

PRIVATE aSaldos   := {}
PRIVATE aSLDNEG   := {}
PRIVATE nQuant    := 0
PRIVATE dData1    := CTOD('30/12/2012')
PRIVATE dData2    := CTOD('30/12/2012')
PRIVATE nX        := 0
PRIVATE nDIAS     := 0
PRIVATE cFileName := "C:\TEMP\ESTOQUE_NEGATIVO.DBF"

_cPAR01           := date()
_cPAR02           := date()
_cPAR03           := 'PA/PI/MP                                                           '
  
PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01'

DEFINE MSDIALOG oDlgEST TITLE "Estoque Negativo 97" FROM 000, 000  TO 280, 470 COLORS 0, 16777215 PIXEL

@ 011, 010 SAY oSay1 PROMPT "Estoque Negativo(97) por data"	SIZE 136, 014 OF oDlgEST FONT oFont1 COLORS 16711680, 16777215 PIXEL
@ 037, 010 SAY oSay2 PROMPT "Data inicial :" 	        SIZE 045, 007 OF oDlgEST COLORS 0, 16777215 PIXEL
@ 050, 010 SAY oSay3 PROMPT "Data Final :" 	            SIZE 045, 007 OF oDlgEST COLORS 0, 16777215 PIXEL
@ 063, 010 SAY oSay4 PROMPT "Tipo produto:" 	        SIZE 045, 007 OF oDlgEST COLORS 0, 16777215 PIXEL
@ 076, 010 SAY oSay5 PROMPT "Arquivo:"      	        SIZE 045, 007 OF oDlgEST COLORS 0, 16777215 PIXEL

@ 037, 050 MSGET oGet1 VAR _cPAR01 WHEN(.T.)    SIZE 050, 010 OF oDlgEST COLORS 0, 16777215 PIXEL
@ 050, 050 MSGET oGet2 VAR _cPAR02 WHEN(.T.)    SIZE 050, 010 OF oDlgEST COLORS 0, 16777215 PIXEL
@ 063, 050 MSGET oGet3 VAR _cPAR03 WHEN(.T.)    SIZE 050, 010 OF oDlgEST COLORS 0, 16777215 PIXEL
@ 076, 050 MSGET oGet4 VAR _cPAR04 WHEN(.T.)    SIZE 150, 010 OF oDlgEST COLORS 0, 16777215 PIXEL

DEFINE SBUTTON oSButton1 FROM 110, 041 TYPE 01 OF oDlgEST ENABLE Action (lImport :=.T., oDlgEST:End() )
DEFINE SBUTTON oSButton2 FROM 110, 077 TYPE 02 OF oDlgEST ENABLE Action (lLOOP   :=.F., oDlgEST:End() )//oDlgEST:End()

ACTIVATE MSDIALOG oDlgEST CENTERED

IF lImport ==.T.
	lImport   :=.F.
	dData1    := (_cPAR01-1)
	dData2    := (_cPAR01-1)
	nDIAS     := (_cPAR02-_cPAR01)+1
	cTIPO     := _cPAR03
	cFileName := _cPAR04
	U_HIGSLDE1()
ENDIF

RETURN


*------------------------------------------------------
USER FUNCTION HIGSLDE1()
*------------------------------------------------------

aMVD1  := {}

aAdd( aMVD1, { "PRODUTO"   ,"C"  ,15,0 } )
aAdd( aMVD1, { "ARMAZEM"   ,"C"  ,02,0 } )
aAdd( aMVD1, { "CDATA"     ,"C"  ,10,0 } )
aAdd( aMVD1, { "QTDE"      ,"N"  ,15,3 } )

MVD1   := CriaTrab( aMVD1, .t. )
dbUseArea(.T.,,MVD1,"MVD1",.F.,.F.)
cKey   := "PRODUTO"
cCond  := ""
cIndex := CriaTrab(NIL,.F.)
IndRegua( "MVD1" ,cIndex ,cKey ,,cCond ,"Indexando Arq.Temporario")

dbSelectArea("MVD1")

PROCESSA({||U_HIGSLDE2()})
RETURN

*------------------------------------------------------
USER FUNCTION HIGSLDE2()
*------------------------------------------------------

SB2->(DBSELECTAREA('SB2'))
SB2->(DBSETORDER(1))
SB2->(DBGOTOP())    
//SB2->(dbSeek(xFilial("SB2")+'97'))

PROCREGUA(SELECT("SB2"))

DO WHILE !SB2->(EOF()) //.and. SB2->B2_LOCAL=='97'

	dData1  :=dData2
	IF SB2->B2_LOCAL=='97'//TIPO $(cTIPO)
	FOR nX:= 1 TO  nDIAS                                   	
	 //	INCPROC(DTOC(dData1-1)+' '+ALLTRIM(SB2->B2_COD))//+' ' +ALLTRIM(SB1->B1_DESC))
		dData1:=dData1+1
		//aSaldos:=CalcEst(SB1->B1_COD,SB1->B1_LOCPAD, dData1)
		aSaldos:=CalcEst(SB2->B2_COD,'97', dData1)
		nQuant:=aSaldos[1]
		IF nQuant<0
			dbSelectArea("MVD1")
			RecLock('MVD1',.T.)
			PRODUTO := SB2->B2_COD
			ARMAZEM := '97'
			CDATA   := DTOC(dData1-1)
			QTDE    := nQuant                              
			MVD1->(MsUnlock())         
			           
			//Devolve valores negativos
		  //	TMATA241(PRODUTO, ARMAZEM, (QTDE*-1), CTOD(CDATA) )
		ENDIF
	NEXT nX
	ENDIF
 	SB2->(DBSKIP())
ENDDO

dbSelectArea("MVD1")

copy to EST_NEG_2018_01.DTC  // Gera o dbf no server a partir da query.

// Copia o arquivo do server para a maquina do cliente.
//If !U_MLSCpyFile("MVD_TEMP.DBF",cFileName)
//	MsgStop("Nao foi possivel gerar o arquivo."+CHR(13)+CHR(10)+cFileName+CHR(13)+CHR(10)+" Verifique se está sendo utilizado.")
//ELSE
//	MsgBox("Foi gerado arquivo com detalhes de nome "+CHR(13)+CHR(10)+cFileName,"Atenção","ALERT")
//Endif

//FERASE("MVD_TEMP.DBF") // limpa o arquivo do server.

MVD1->(DBCLOSEAREA())

MSGALERT('FIM')
RETURN
                                     


Static Function TMATA241(cCodProd, cLocal, nQTD, dDT )

Local _aCab1    := {}
Local _aItem    := {}
Local _atotitem := {}
Local nTipo     := 0
Local cReturn   := ""           
Local cCodigoTM := "004"

Private lMsHelpAuto := .t. // se .t. direciona as mensagens de help
Private lMsErroAuto := .f. //necessario a criacao

//Private _acod:={"1","MP1"}


dbSelectArea("SB1")
dbSetOrder(1)
SB1->(dbSeek(xFilial("SB1")+cCodProd))
	
dbSelectArea("SD3")
dbSetOrder(1)
nTipo := 3
_aCab1 := { {"D3_TM" ,cCodigoTM      , NIL},;
			   {"D3_EMISSAO" ,dDT       , NIL}}
	
_aItem := { ;
			   {"D3_COD"     ,cCodProd   ,NIL},;
			   {"D3_UM"      ,SB1->B1_UM ,NIL},;
			   {"D3_QUANT"   ,nQTD       ,NIL},;
			   {"D3_LOCAL"   ,cLocal     ,NIL}}
//{"D3_OP"      ,cCodOP     ,NIL},;
//{"D3_LOTECTL" , cLoteCTL  ,NIL}}
	

aadd(_atotitem,_aitem)
MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_atotitem,nTipo)

//If nTipo ==3
//	cReturn := SD3->D3_NUMSEQ
//EndIf

If lMsErroAuto
	MOSTRAERRO()
  //	RETURN("")
EndIf

Return //(cReturn)



/*
CalcEst(cProduto, cAlmox, dData)
Parâmetros
cProduto - Produto a ser pesquisado
cAlmox - Almoxarifado a pesquisar
dData - Data desejada
Retorna
aArray - Array contendo:
Elemento 1 - Quantidade inicial em estoque na data
Elemento 2 - Custo inicial na data na moeda 1
Elemento 3 - Custo inicial na data na moeda 2
Elemento 4 - Custo inicial na data na moeda 3
Elemento 5 - Custo inicial na data na moeda 4
Elemento 6 - Custo inicial na data na moeda 5
Elemento 7 - Quantidade inicial na segunda unidade de medida

Exemplo

aSaldos:=CalcEst(SB1->B1_COD,SB1->B1_LOCPAD, dDataBase)
nQuant:=aSaldos[1]
*/
