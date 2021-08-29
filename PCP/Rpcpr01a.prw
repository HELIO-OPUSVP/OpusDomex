#include "print.ch"
#include "font.ch"
#include "colors.ch"
#include "Protheus.ch"
#include "Topconn.ch" 
#include "Rwmake.ch"                               

#INCLUDE "RPCPR01.CH"

#xcommand @ <nLinha>, <nColuna> PSAY <cTexto>;
			=> oprn:say(<nLinha>*50+100, <nColuna>*30/*-<nColuna>/2*/+40, transform(<cTexto>, ''), ofnt,,;
			   CLR_BLACK)
			                                                                                            
#xcommand @ <nLinha>, <nColuna> PSAY <cTexto> FONT <oFonte>;
			=> oprn:say(<nLinha>*50+100, <nColuna>*25/*-<nColuna>/2*/+40, transform(<cTexto>, ''), <oFonte>,,;
			   CLR_BLACK)

#xcommand @ <nLinha>, <nColuna> PSAY <cTexto> PICTURE <cPicture>;
			=> oprn:say(<nLinha>*50+100, <nColuna>*30/*-<nColuna>/2*/+40, transform(<cTexto>, <cPicture>), ofnt,,;
			   CLR_BLACK)

#xcommand @ <nLinha>, <nColuna> PSAY <cTexto> PICTURE <cPicture> FONT <oFonte>;
			=> oprn:say(<nLinha>*50+100, <nColuna>*25/*-<nColuna>/2*/+40, transform(<cTexto>, <cPicture>), <oFonte>,,;
			   CLR_BLACK)
			   
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR820  ³ Autor ³ Paulo Boschetti       ³ Data ³ 07.07.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ordens de Producao                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ MATR820(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico³                                                  ³±±
±±³ Alteração³ FiveWin ³ Fabrício Becherini (10/05/04)                    ³±±
±±³          ³                                                            ³±±
±±³          ³09/06/11                                                    ³±±
±±³          ³ Alterado por Juliano Ferreira da Silva                     ³±±
±±³          ³ Corrigir o preenchimento dos campos                        ³±±
±±³          ³ Ordem de Fornecimento / Cod Cliente / Nome do Cliente      ³±±
±±³          ³ prazo solicitado expedição                                 ³±±
±±³          ³                                                            ³±±
±±³          ³ 11/08/11                                                   ³±±
±±³          ³ Alterado por Juliano, para tratar impressão                ³±±
±±³          ³ Frente e Verso                                             ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function RPCPR01a()
Local titulo  := STR0039 //"Ordens de Producao"
//Local cString := "SC2"
Local wnrel   := "MATR820"
//Local cDesc   := STR0001	//"Este programa ira imprimir a Rela‡„o das Ordens de Produ‡„o"
//Local aOrd    := {STR0002,STR0003,STR0004,STR0005}	//"Por Numero"###"Por Produto"###"Por Centro de Custo"###"Por Prazo de Entrega"
Local tamanho := "G"
Local resp
Local cQry
Local cOP1
Local cOP2
//Private aReturn  := {STR0006,1,STR0007, 1, 2, 1, "",1 }	//"Zebrado"###"Administracao"
Private cPerg    :="MTR820"
//Private nLastKey := 0
Private lItemNeg := .F.
Private plinha   := .t.
Private cContPg  := ""

MsgStop("Usar o programa RPCPR01B().")

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
resp := pergunte("MTR820",.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // Da OP                                 ³
//³ mv_par02            // Ate a OP                              ³
//³ mv_par03            // Da data                               ³
//³ mv_par04            // Ate a data                            ³
//³ mv_par05            // Imprime roteiro de operacoes          ³
//³ mv_par06            // Imprime codigo de barras              ³
//³ mv_par07            // Imprime Nome Cientifico               ³
//³ mv_par08            // Imprime Op Encerrada                  ³
//³ mv_par09            // Impr. por Ordem de                    ³
//³ mv_par10            // Impr. OP's Firmes, Previstas ou Ambas ³
//³ mv_par11            // Impr. Item Negativo na Estrutura      ³
//³ mv_par12            // Data de Expedicao                     ³
//³ mv_par13            // Imprime Processos para                ³
//³ mv_par14            // Utiliza impresora frente e verso?     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//If !ChkFile("SH8",.F.) DELETEI AQUI!
//	Help(" ",1,"SH8EmUso")
//Return
//Endif ATE AQUI


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//³ Coloca um flag em um campo criado para poder indicar ao pessoal do Estoque que um OP foi impressa. ³
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
cContPg:=AllTrim(MV_PAR01)
cOP1   := SUBSTR(MV_PAR01,1,6)
cItem1 := SUBSTR(MV_PAR01,7,2)
cSeq1  := SUBSTR(MV_PAR01,9,3)

DBSELECTAREA("SC2")
DBGOTOP()
DBSETORDER(1)

cQry := " SELECT * "
cQry += " FROM " + RETSQLNAME("SC2")
cQry += " WHERE C2_FILIAL = '" + xFilial("SC2") + "'"
cQry += " AND C2_NUM = '" + cOP1 + "'"
cQry += " AND C2_ITEM = '" + cItem1 + "'"
cQry += " AND C2_SEQUEN = '" + cSeq1 + "'"

TcQuery cQry NEW Alias "TMP"

DBSELECTAREA("TMP")
DBGOTOP()

If TMP->C2_FLAG = "S"
	
	MSGBOX("Essa Op já foi impressa !")
	
elseIf TMP->C2_FLAG != "S"
	
	While TMP->(!Eof())
		
		DBSELECTAREA("SC2")
		DBSETORDER(1)
		
		If DBSEEK(xFilial("TMP")+TMP->C2_NUM,.F.)
			RecLock("SC2",.F.)
			SC2->C2_FLAG  := "S"
		ENDIF
		
		DBSELECTAREA("TMP")
		DBSKIP()
		
	ENDDO
	
	DbCloseArea("TMP")
	DbCloseArea("SC2")
	
ENDIF
		
		 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc,"","",.F.,aOrd,,Tamanho)

lItemNeg := GetMv("MV_NEGESTR") .And. mv_par11 == 1

/*DELETEI AQUI
If nLastKey == 27
	dbSelectArea("SH8")
	Set Filter To
	dbCloseArea()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Retira o SH8 da variavel cFopened ref. a abertura no MNU     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ClosFile("SH8")
	dbSelectArea("SC2")
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27

If resp == .f.
	dbSelectArea("SH8")
	Set Filter To
	dbCloseArea() Até aqui!!
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Retira o SH8 da variavel cFopened ref. a abertura no MNU     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ClosFile("SH8")
	dbSelectArea("SC2")
	Return
Endif
*/

print oprn preview
define font ofnt name "Courier New" /*bold*/ size 0,12 of oprn
define font ofnt2 name "Courier New" bold size 0,10 of oprn
define font ofnt3 name "Courier New" bold size 0,12 of oprn

RptStatus({|lEnd| R820Imp(@lEnd,wnRel,titulo,tamanho)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ R820Imp  ³ Autor ³ Waldemiro L. Lustosa  ³ Data ³ 13.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R820Imp(lEnd,wnRel,titulo,tamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local CbCont,cabec1,cabec2
Local limite     := 100
Local nQuant     := 1
Local nomeprog   := "MATR820"
Local nTipo      := 18
Local cProduto   := SPACE(LEN(SC2->C2_PRODUTO))
Local cQtd
Local cIndSC2    := CriaTrab(NIL,.F.), nIndSC2
Private aArray   := {}
Private li       := 100

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(0)
cbcont   := 0                                      
m_pag    := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cabec1 := ""
cabec2 := ""

// Linha adicionada por Fabrício Becherini (27/11/03), para reset e configuração de caracteres da impressora
//@ 0,0 psay chr(27)+"E"+chr(27)+"(19U"

dbSelectArea("SC2")
/*
If aReturn[8] == 4
	#IFDEF TOP
		IndRegua("SC2",cIndSC2,"C2_FILIAL+C2_DATPRF",,,STR0008)	//"Selecionando Registros..."
	#ELSE
		IndRegua("SC2",cIndSC2,"C2_FILIAL+DTOS(C2_DATPRF)",,,STR0008)	//"Selecionando Registros..."
	#ENDIF
	dbGoTop()
Else
	dbSetOrder(aReturn[8])
EndIf
*/
SC2->( dbSetOrder(1) )
If !SC2->( dbSeek( xFilial() + mv_par01) )
   SC2->( dbSeek( xFilial() ) )
EndIf

SetRegua(LastRec())

While !Eof() .and. SC2->C2_FILIAL+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN <= xFilial("SC2")+mv_par02
	IF lEnd
		@ Prow()+1,001 PSay STR0009	//"CANCELADO PELO OPERADOR"
		Exit
	EndIF
	
	IncRegua()
	
	If C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD < xFilial()+mv_par01 .or. C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD > xFilial()+mv_par02
		dbSkip()
		Loop
	EndIf
	
	If  C2_DATPRF < mv_par03 .Or. C2_DATPRF > mv_par04
		dbSkip()
		Loop
	Endif
	
	If !(Empty(C2_DATRF)) .And. mv_par08 == oprn:npage
		dbSkip()
		Loop
	Endif
	
	//-- Valida se a OP deve ser Impressa ou n„o
	If !MtrAValOP(mv_par10, 'SC2')
		dbSkip()
		Loop
	EndIf
	
	cProduto  := SC2->C2_PRODUTO
	nQuant    := aSC2Sld()
	
	dbSelectArea("SB1")
	dbSeek(xFilial("SB1")+cProduto)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona o primeiro elemento da estrutura , ou seja , o Pai  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AddAr820(nQuant)
	
	MontStruc(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD,nQuant)
	
	If mv_par09 == 1
		aSort( aArray,2,, { |x, y| (x[1]+x[8]) < (y[1]+y[8]) } )
	Else
		aSort( aArray,2,, { |x, y| (x[8]+x[1]) < (y[8]+y[1]) } )
	ENDIF
	
	
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime cabecalho                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cabecOp(Tamanho)
	
	For I := 2 TO Len(aArray)
		@Li ,   10 PSay aArray[I][1]    	 				   	// CODIGO PRODUTO
		For nBegin := 1 To Len(Alltrim(aArray[I][2])) Step 31
			@li,025 PSay Substr(aArray[I][2],nBegin,31)
			li++
		Next nBegin
		//  	Li++
		//    @ li,000 PSAY Repl("-",170)
		//    li := li+3
		//	 li--
		//	 	 li--
		li--
		cQtd := Alltrim(Transform(aArray[I][5],PesqPictQt("D4_QUANT",14)))
		@Li , (55+5-Len(cQtd)) PSay cQtd					// QUANTIDADE
		@Li ,  62 PSay "|"+aArray[I][4]+"|"			  	// UNIDADE DE MEDIDA
		@li ,  65 PSay aArray[I][6]+"|"                  	// ALMOXARIFADO
		@li ,  69 PSay Substr(aArray[I][7],1,12)         	// LOCALIZACAO
		@li ,  79 PSay "|"+aArray[I][8]                  	// SEQUENCIA
		Li++
		Li++
		@ li,000 PSAY Repl("-",170)
		li := li+1
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se nao couber, salta para proxima folha                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF li > 55
			Li := 1
			CabecOp(Tamanho)		// imprime cabecalho da OP
		EndIF
		
	Next I
	
	If mv_par05 == 1
		RotOper()   	// IMPRIME ROTEIRO DAS OPERACOES
	Else
		RotOper2()      // IMPRIME ROTEIRO DAS OPERACOES PERSONALIZADO
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprimir Relacao de medidas para Cliente == HUNTER DOUGLAS.  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SMX")
	If Found() .And. SC2->C2_DESTINA == "P"
		R820Medidas()
	EndIf
	
	*	m_pag++
	Li := 0					// linha inicial - ejeta automatico
	aArray:={}
	
	dbSelectArea("SC2")
	dbSkip()
	
EndDO

dbSelectArea("SH8")
dbCloseArea() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retira o SH8 da variavel cFopened ref. a abertura no MNU     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ClosFile("SH8")

dbSelectArea("SC2") 
/*If aReturn[8] == 4
	RetIndex("SC2")
	Ferase(cIndSC2+OrdBagExt())
EndIf*/
Set Filter To
dbSetOrder(1)

/*If aReturn[5] = 1
	Set Printer TO
	dbCommitall()
	ourspool(wnrel)
Endif

MS_FLUSH()*/

endprint
ofnt:end()
ofnt2:end()
ofnt3:end()

Return NIL    

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ AddAr820 ³ Autor ³ Paulo Boschetti       ³ Data ³ 07/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Adiciona um elemento ao Array                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ AddAr820(ExpN1)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Quantidade da estrutura                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


Static Function AddAr820(nQuantItem)
Local cDesc := SB1->B1_DESC
Local cRoteiro:=""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se imprime nome cientifico do produto. Se Sim    ³
//³ verifica se existe registro no SB5 e se nao esta vazio    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par07 == 1
	dbSelectArea("SB5")
	dbSeek(xFilial()+SB1->B1_COD)
	If Found() .and. !Empty(B5_CEME)
		cDesc := B5_CEME
	EndIf
ElseIf mv_par07 == 2
	cDesc := SB1->B1_DESC
Else
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se imprime descricao digitada ped.venda, se sim  ³
	//³ verifica se existe registro no SC6 e se nao esta vazio    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SC2->C2_DESTINA == "P"
		dbSelectArea("SC6")
		dbSetOrder(1)
		dbSeek(xFilial()+SC2->C2_PEDIDO+SC2->C2_ITEM)
		If Found() .and. !Empty(C6_DESCRI) .and. C6_PRODUTO==SB1->B1_COD
			cDesc := C6_DESCRI
		ElseIf C6_PRODUTO # SB1->B1_COD
			dbSelectArea("SB5")
			dbSeek(xFilial("SB5")+SB1->B1_COD)
			If Found() .and. !Empty(B5_CEME)
				cDesc := B5_CEME
				
			EndIf
		EndIf
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se imprime ROTEIRO da OP ou PADRAO do produto    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(SC2->C2_ROTEIRO)
	cRoteiro:=SC2->C2_ROTEIRO
Else
	If !Empty(SB1->B1_OPERPAD)
		cRoteiro:=SB1->B1_OPERPAD
	Else
		dbSelectArea("SG2")
		If dbSeek(xFilial()+SC2->C2_PRODUTO+"01")
			RecLock("SB1",.F.)
			Replace B1_OPERPAD With "01"
			SB1->( MsUnLock() )
			cRoteiro:="01"
		EndIf
	EndIf
EndIf
//dbSelectArea("SG1")
dbSelectArea("SB2")
dbSeek(xFilial()+SB1->B1_COD+SD4->D4_LOCAL)
//dbSelectArea("SG1")
dbSelectArea("SD4")
AADD(aArray, {SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQuantItem,D4_LOCAL,SD4->D4_TRT,D4_TRT,cRoteiro } )

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ MontStruc³ Autor ³ Ary Medeiros          ³ Data ³ 19/10/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Monta um array com a estrutura do produto                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ MontStruc(ExpC1,ExpN1,ExpN2)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do produto a ser explodido                  ³±±
±±³          ³ ExpN1 = Quantidade base a ser explodida                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

Static Function MontStruc(cOp,nQuant)

dbSelectArea("SD4")
dbSetOrder(2)
dbSeek(xFilial()+cOp)

While !Eof() .And. D4_FILIAL+D4_OP == xFilial()+cOp
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no produto desejado                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB1")
	dbSeek(xFilial()+SD4->D4_COD)
	If SD4->D4_QUANT > 0 .Or. (lItemNeg .And. SD4->D4_QUANT < 0)
		AddAr820(SD4->D4_QUANT)
	EndIf
	dbSelectArea("SD4")
	dbSkip()
Enddo

dbSetOrder(1)

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ CabecOp  ³ Autor ³ Paulo Boschetti       ³ Data ³ 07/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Monta o cabecalho da Ordem de Producao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ CabecOp()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function CabecOp(Tamanho)

//								           012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                        			       1         2         3         4         5         6         7         8
Local nBegin
Local nPed
Local cPed
Local _nTamOK  :=100
Local _nTamMax :=34

If li # 5
	li := 0
Endif  
	
if plinha
  plinha := .f.
else
  cContPg :=Alltrim(SC2->C2_NUM+" "+SC2->C2_ITEM+SC2->C2_SEQUEN)
  endpage
  page
  //If mv_par14 == 1 .And. Alltrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN) <> cContPg
  //   if  (oprn:npage%2) <> 0
  //      endpage
  //      page
  //      cContPg :=Alltrim(SC2->C2_NUM+" "+SC2->C2_ITEM+SC2->C2_SEQUEN)
  //   endif 
  //endif
endif
//page
Li++
@Li,00 Psay /*CHR(27)+"(s-5B"+CHR(27)+'(s10H'+*/REPLICATE(CHR(151),170)
Li++
//@Li,28 Psay "ROSENBERGER DOMEX TELECOM"
@Li,25 Psay "ROSENBERGER DOMEX TELECOM"
oPr := oprn
cCode := (SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD) 
//cCode := ("010"+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD+"13")
MSBAR2("CODE128",1.60,12.5,Alltrim(cCode),opr,.F.,,.T.,0.025,0.5,NIL,NIL,NIL,.F.)  

Li++
@Li,00 Psay REPLICATE(CHR(151),170)
//@Li,65 Psay CHR(27)+"&k4S"+CHR(27)+"(s7B"+"OM: "+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SPACE(05)+CHR(27)+"(s-5B"+CHR(27)+'(s10H'

Li++   

//IF (mv_par06 == 1) // .And. aReturn[5] # 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime o codigo de barras do numero da OP              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Alteração feita por Fabrício Becherini (10/05/04)
//	oPr := ReturnPrtObj()
//	oPr := oprn
//	cCode := (SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD)
//	MSBAR2("CODE128",2.5,0.5,Alltrim(cCode),oPr,Nil,Nil,Nil,nil ,1.5 ,Nil,Nil,Nil)
//	Li += 5

//ENDIF


DbSelectArea("SB1")
DbSetOrder(1)
DBSeek(xFilial("SB1")+SC2->C2_PRODUTO)

DbSelectArea("SC5")
DbSetOrder(1)
DbSeek(xFilial("SC5")+SC2->C2_PEDIDO)

DbSelectArea("SC6")
DbSetOrder(1)
DbSeek(xFilial("SC6")+SC2->C2_PEDIDO+SC2->C2_ITEMPV)

DbSelectArea("SA1")
DbSetOrder(1)
//DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI) jfs
DbSeek(xFilial("SA1")+SC2->C2_CLIENT)

//inicio jfs 09/06/11
//@Li,10 Psay "Ordem de Fornecimento: "+SC5->C5_NUM Font ofnt2 alterado por JFS
If Empty(Alltrim(SC2->C2_NPEDIDO))
   @Li,10 Psay "Ordem de Fornecimento: "+Alltrim(SC2->C2_PEDIDO) Font ofnt2
Else
   @Li,10 Psay "Ordem de Fornecimento: "+Alltrim(SC2->C2_PEDIDO)+" / "+Alltrim(SC2->C2_NPEDIDO)  Font ofnt2
EndIf 

// fim 09/06/11 
@Li,54 Psay "Ordem de Montagem: "+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN Font ofnt2
Li++
@Li,00 Psay REPLICATE(CHR(151),170)
Li++
@Li,10 Psay "Plano Produção: "+Dtoc(mv_par12) Font ofnt2
@Li,50 Psay "Nome do" Font ofnt2
Li++ 
@Li,20 Psay "OTD: "+DtoC(SC6->C6_XXDTDEF) Font ofnt2
@Li,50 Psay "Cliente:" Font ofnt2

_cNome:=StrTran(StrTran(StrTran(StrTran(SA1->A1_NREDUZ,"(",""),")",""),",",""),"Ø","0")
_cNome:=SubStr(_cNome,1,AT(" ",_cNome))
MSBAR2("CODE128",3.50,12.75,Alltrim(_cNome),opr,.F.,,.T.,0.025,0.5,NIL,NIL,NIL,.F.)  

Li++
@Li,00 Psay REPLICATE(CHR(151),170)
Li++
@Li,10 Psay "CÓDIGO DO CLIENTE: "+SA1->A1_COD+"-"+SA1->A1_LOJA+" "+SA1->A1_NOME Font ofnt2
Li++
@Li,00 Psay REPLICATE(CHR(151),170)
Li++         
@Li,10 PSay STR0013+aArray[1][1] Font ofnt2    

//If _nTamOK < _nTamMax //Len(AllTrim(aArray[1][2]))<_nTamMax               
//   @Li,45 PSay aArray[1][2] Font ofnt2
//   Li++    
//EndIf
// jfs inicio

MSBAR2("CODE128",5.90,3.5,Alltrim(aArray[1][1]),opr,.F.,,.T.,0.025,0.5,NIL,NIL,NIL,.F.)  

_cDesc:=StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(SB1->B1_DESC,"(",""),")",""),",",""),"Ø","0"),"/",""),"-","")
_cDesc:=StrTran(StrTran(StrTran(StrTran(StrTran(SB1->B1_DESC,"Á","A"),"É","E"),"Í","I"),"Ó","O"),"Ú","U")
//If _nTamOK < _nTamMax //Len(AllTrim(aArray[1][2]))<_nTamMax
//   MSBAR2("CODE128",6.40,9.5,Alltrim(_cDesc),opr,.F.,,.T.,0.025,0.5,NIL,NIL,NIL,.F.)  
//Else
   Li+=3
   @Li,18 PSay aArray[1][2] Font ofnt2    
   MSBAR2("CODE128",7.20,3.5,Alltrim(_cDesc),opr,.F.,,.T.,0.025,0.5,NIL,NIL,NIL,.F.)  
   Li+=2
//EndIf   
//jfs fim
Li+=2
@Li,10 Psay Substr(SB1->B1_DESCR1,1,50)+Substr(SB1->B1_DESCR2,1,20)
Li++
@Li,10 Psay Substr(SB1->B1_DESCR2,21,30)+Substr(SB1->B1_DESCR3,1,40)
Li++
@Li,10 Psay Substr(SB1->B1_DESCR3,41,10)+Substr(SB1->B1_DESCR4,1,50)+Substr(SB1->B1_DESCR5,1,10)
Li++
@Li,10 Psay Substr(SB1->B1_DESCR5,11,40)
Li++
@Li,00 Psay REPLICATE(CHR(151),170)
Li++
@li,10 Psay "Requisitos Cliente: "
@Li,30 Psay Substr(SC2->C2_REQ1,01,65)
Li++
@Li,20 Psay Substr(SC2->C2_REQ2,01,65)
Li++
@Li,20 Psay Substr(SC2->C2_REQ3,01,65) 
Li++
@Li,10 Psay "Pedido do Cliente: "
@(li-1.4),30 Psay SC5->C5_ESP1

//nPed   :=AT(" ",Alltrim(SC5->C5_ESP1))
//_cCode :=Substr(Alltrim(SC5->C5_ESP1),1,nPed)

//If _nTamOK < _nTamMax //Len(AllTrim(aArray[1][2]))<_nTamMax
//   MSBAR("CODE128",10,8.0,AllTrim(SC5->C5_ESP1),opr,.F.,,.T.,0.025,0.5,NIL,NIL,NIL,.F.) 
//Else    
   If !Empty(SC5->C5_ESP1)
   MSBAR2("CODE128",11.7,8.0,AllTrim(SC5->C5_ESP1),opr,.F.,,.T.,0.025,0.5,NIL,NIL,NIL,.F.) 
	EndIf
//EndIf
Li++
Li++
@Li,10 Psay "Código do Cliente: "
@(li-1.1),30 Psay SC6->C6_SEUCOD            

//If _nTamOK < _nTamMax //Len(AllTrim(aArray[1][2]))<_nTamMax
//   MSBAR2("CODE128",11.8,10,Alltrim(SC6->C6_SEUCOD),opr,.F.,,.T.,0.025,0.5,NIL,NIL,NIL,.F.)  
//Else    
   If !Empty(SC6->C6_SEUCOD)
   MSBAR2("CODE128",12.6,8.0,Alltrim(StrTran(SC6->C6_SEUCOD,"–","-")),opr,.F.,,.T.,0.025,0.5,NIL,NIL,NIL,.F.)  
	EndIf
//EndIf   

Li++
Li++
@Li,10 Psay "Item do Pedido/Cliente: "
@(Li-1),30 Psay SC6->C6_SEUDES
//If _nTamOK < _nTamMax //Len(AllTrim(aArray[1][2]))<_nTamMax
//   MSBAR2("CODE128",12.5,15,Alltrim(SC6->C6_SEUDES),opr,.F.,,.T.,0.025,0.5,NIL,NIL,NIL,.F.)  
//Else    
   If !Empty(SC6->C6_SEUDES)
   MSBAR2("CODE128",13.5,8.0,Alltrim(SC6->C6_SEUDES),opr,.F.,,.T.,0.025,0.5,NIL,NIL,NIL,.F.)  
	EndIf
//EndIf   
Li+=2 
@Li,10 Psay "Observação: "+MemoLine(SC5->C5_OBSGERA ,100,1,100,.T.)
Li+=2                                      

@Li,10 Psay "Número de Série (Inicial): " Font ofnt3 

_cSerieIni:=""
IF "294KIT" $ SC2->C2_PRODUTO
   Do Case
      CASE (SC2->C2_QUANT*12)<= 99
           @Li,34 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"01" 	 	 
           _cSerieIni:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"01" 	 	 
      CASE ((SC2->C2_QUANT*12)>= 100 .AND. (SC2->C2_QUANT*12)<= 999)
           @Li,34 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"001" 
           _cSerieIni:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"001" 
      CASE ((SC2->C2_QUANT*12)>= 1000 .AND. (SC2->C2_QUANT*12)<= 9999) 
           @Li,34 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"0001"
           _cSerieIni:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"0001"
   EndCase
ELSE  
   Do Case 
      Case SC2->C2_QUANT <=9
           @Li,32 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"1" 
           _cSerieIni:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"1" 
           //@ l, c Psay 'A'
      Case  SC2->C2_QUANT >=10 .And.  SC2->C2_QUANT <= 99
           @Li,32 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"01"	 
           _cSerieIni:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"01"	 
          //@ l, c Psay 'B'
      Case  SC2->C2_QUANT >=100 .And. SC2->C2_QUANT <= 999
           @Li,32 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"001"
           _cSerieIni:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"001"
           //@ l, c Psay 'C'
      Case  SC2->C2_QUANT >=1000 .And. SC2->C2_QUANT <= 9999
           @Li,32 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"0001" 
           _cSerieIni:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"0001" 
   EndCase
ENDIF 

//If _nTamOK < _nTamMax //Len(AllTrim(aArray[1][2]))<_nTamMax
//   MSBAR2("CODE128",14.8,8.3,_cSerieIni,opr,.F.,,.T.,0.025,0.5,NIL,NIL,NIL,.F.)  
//Else    
   MSBAR2("CODE128",15.8,8.3,_cSerieIni,opr,.F.,,.T.,0.025,0.5,NIL,NIL,NIL,.F.)  
//EndIf   

//@Li,30 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"0001
//@Li,62 Psay  
//@Li,30 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"01"

		
//IF SC2->C2_QUANT <=9  
//@Li,30 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"1"  
//ELSE
//@Li,30 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"01"	
//ENDIF

//IF SC2->C2_QUANT >=100
//@Li,30 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"001"
//ELSE
//@Li,30 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"0001"
//ENDIF	 
	 
//IF SC2->C2_QUANT> =10 .And. SC2->C2_QUANT<= 99;  
//@Li,30 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"01"
//ENDIF
	 		
//IF SC2->C2_QUANT>=100 .And. <= SC2->C2_QUANT<=999;
//@Li,30 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"001"
//ENDIF
	
//IF SC2->C2_QUANT>=1000 .And. <= SC2->C2_QUANT<=9999; 
//@Li,30 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"0001"
//ENDIF      
 
//ELSE          
 
//@Li,30 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"1"

@Li,54 Psay "Número de Série (Final):" Font ofnt3   

IF "294KIT" $ SC2->C2_PRODUTO   
@Li,66 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+(AllTrim(Str(SC2->C2_QUANT*12)))  //TRANSFORM(SC2->C2_QUANT) 
else 
@Li,66 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+(AllTrim(Str(SC2->C2_QUANT))) 
Endif
Li++   
@Li,66 Psay REPLICATE(CHR(151),170)
Li++
@Li,10 PSay "Emissão.: " +DTOC(dDatabase)
//@Li,42 PSay "Inicio.: "+DTOC(SC2->C2_DATPRI)      
//@Li,62 PSay "Fim.: "+DTOC(SC2->C2_DATPRF)        

Li++
@Li,00 Psay REPLICATE(CHR(151),170)
Li++


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime nome do cliente quando OP for gerada            ³
//³ por pedidos de venda                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
If SC2->C2_DESTINA == "P"
dbSelectArea("SC5")
dbSetOrder(1)
If dbSeek(xFilial()+SC2->C2_PEDIDO,.F.)
dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
@Li,00 PSay STR0016	//"Cliente :"
@Li,10 PSay SC5->C5_CLIENTE+"-"+SC5->C5_LOJACLI+" "+A1_NOME
dbSelectArea("SG1")
Li++
EndIf
EndIf
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime a quantidade original quando a quantidade da    ³
//³ Op for diferente da quantidade ja entregue              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SC2->C2_QUJE + SC2->C2_PERDA > 0
	@Li,00 PSay STR0017 //"Qtde Prod.:"
	@Li,11 PSay aSC2Sld()		PICTURE PesqPictQt("C2_QUANT",14)
	@Li,26 PSay "Qtde Orig.:"
	@Li,37 PSay TRANSFORM(SC2->C2_QUANT,"@E 99,999,999,999.99") Font ofnt2
Else
	@Li,10 PSay "Quantidade :" Font ofnt2
	@Li,25 PSay TRANSFORM(SC2->C2_QUANT - SC2->C2_QUJE,"@E 99,999,999,999.99") Font ofnt2
Endif
@Li,52 PSay "Unid. Medida : " +aArray[1][4]

// @ li,000 PSAY Repl("-",220)                        
//@Li,00 PSay STR0023+SC2->C2_CC                          //"C.Custo: "
//@Li,42 PSay STR0024+DTOC(SC2->C2_DATAJI)        //"Ajuste: "
//@Li,62 PSay STR0024+DTOC(SC2->C2_DATAJF)        //"Ajuste: "
//Li++
//If SC2->C2_STATUS == "S"
//        @Li,00 PSay STR0025                                             //"Status: OP Sacramentada"
//ElseIf SC2->C2_STATUS == "U"
//        @Li,00 PSay STR0026                                             //"Status: OP Suspensa"
//ElseIf SC2->C2_STATUS $ " N"
//        @Li,00 PSay STR0027                                             //"Status: OP Normal"
//EndIf
//@Li,42 PSay STR0028                                                     //      "Real  :   /  /      Real  :   /  / "
Li++

If !(Empty(SC2->C2_OBS))
	@Li,10 PSay STR0029						//"Observacao: "
	For nBegin := 1 To Len(Alltrim(SC2->C2_OBS)) Step 65
		@li,012 PSay Substr(SC2->C2_OBS,nBegin,65)
		li++
	Next nBegin
EndIf
@Li,00 Psay REPLICATE(CHR(151),170)
Li++
 


@Li,30 PSay  "C O M P O N E N T E S " Font ofnt3
Li++
@Li,00 Psay REPLICATE(CHR(151),170)
Li++
 
@Li, 10 PSay  "CÓDIGO             DESCRIÇÃO                       QUANTIDADE |UM|AL|  DESENHO    "
Li++
@Li,00 Psay REPLICATE(CHR(151),170)
Li++

Return
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ RotOper  ³ Autor ³ Paulo Boschetti       ³ Data ³ 18/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Imprime Roteiro de Operacoes                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ RotOper()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function RotOper()

Local nBegin, lSH8

dbSelectArea("SG2")
If dbSeek(xFilial()+aArray[1][1]+aArray[1][9],.F.)
	
	cRotOper()
	
	While !Eof() .And. G2_FILIAL+G2_PRODUTO+G2_CODIGO = xFilial()+aArray[1][1]+aArray[1][9]
		
		dbSelectArea("SH4")
		dbSeek(xFilial()+SG2->G2_FERRAM)
		
		dbSelectArea("SH8")
		dbSetOrder(1)
		dbSeek(xFilial()+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD+SG2->G2_OPERAC)
		lSH8 := IIf(Found(),.T.,.F.)
		
		If lSH8
			While !Eof() .And. SH8->H8_FILIAL+SH8->H8_OP+SH8->H8_OPER == xFilial()+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD+SG2->G2_OPERAC
				ImpRot(lSH8)
				dbSelectArea("SH8")
				dbSkip()
			End
		Else
			ImpRot(lSH8)
		Endif
		
		dbSelectArea("SG2")
		dbSkip()
		
	EndDo
	
Endif

Return Li

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ RotOper2  ³ Autor ³Paulo Boschetti       ³ Data ³ 18/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Imprime Roteiro de Operacoes Personalizado - DOMEX         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ RotOper2()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DOMEX                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³ CASSANDRA JACINTO DA SILVA - 15/08/2003                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function RotOper2()

Local aTitulo := {}

//Optico
aadd(aTitulo, {"CONFERÊNCIA MATÉRIA-PRIMA",;  //1
               "CORTE"                    ,;  //2
               "PREPARAÇÃO"               ,;  //3
               "RESINAGEM"                ,;  //4
               "MONTAGEM"                 ,;  //5
               "CLIVAGEM/PRÉ POLIMENTO"   ,;  //6
               "TUNNING"                  ,;  //7
               "POLIMENTO / INSPEÇÃO"     ,;  //8
               "TESTE IL/RL"              ,;
               "INTERFERÔMETRO"           ,;
               "FIBRA CRUZADA"            ,;
               "FIBER CHECK"              ,;
               "EMBALAGEM"                ,;
               "CQ"                       ,;
               "EXPEDIÇÃO"})
             
//Coaxial
aadd(aTitulo, {"CONFERÊNCIA MATÉRIA-PRIMA"     ,;
               "CORTE"                         ,;
               "MONTAGEM"                      ,;
               "SOLDA"                         ,;
               "TESTE DE CONTINUIDADE/ISOLAÇÃO",;
               "TESTE RL"                      ,;
               "TESTE PIM"                     ,;
               "COLOCAÇÃO ETIQUETAS/ACESSORIOS",;
               "EMBALAGEM"                     ,;
               "EXPEDIÇÃO"})

//Dio
aadd(aTitulo, {"CONFERÊNCIA MATÉRIA-PRIMA"     ,;
               "MONTAGEM DO KIT PIGTAILS"      ,;
               "MONTAGEM DO CHASSI"            ,;
               "COLOCAÇÃO ADAPTADORES"         ,;
               "LIGAÇÃO DE FIBRAS"             ,;
               "MONTAGEM DE KIT"               ,;
               "COLOCAÇÃO DE ACESSÓRIOS"       ,;
               "EMBALAGEM"                     ,;
               "EXPEDIÇÃO"})
               
Li++
@Li,10 PSay "Almox.Data__/__/__Hora__:__Ass.____________" 
Li++ 


//dbSelectArea("SG2")
//If dbSeek(xFilial()+aArray[1][1]+aArray[1][9],.F.)

Li++

@Li,00 Psay REPLICATE(CHR(151),170)


Li++
@Li,22 Psay "R O T E I R O  D E  O P E R A Ç Õ E S" Font ofnt3
//        @Li,65 Psay CHR(27)+"&k4S"+CHR(27)+"(s7B"+"OM: "+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SPACE(05)+CHR(27)+"(s-5B"+CHR(27)+'(s10H'
Li++
@Li,00 Psay REPLICATE(CHR(151),170)
Li++
Li++

//      @Li,56 PSay "Data __/__/__ Hora__:__"

dbSelectArea("SH8")
dbSetOrder(1)
dbSeek(xFilial()+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD+SG2->G2_OPERAC)
lSH8 := IIf(Found(),.T.,.F.)

For nCont:=1 to Len(aTitulo[mv_par13])
	IF Li > 59	
		Li := 0
		Li++
      // Incluído por Fabrício Becherini (18/05/04)
		endpage
		page
		//page
      @Li,00 Psay REPLICATE(CHR(151),170)
		Li++
      @Li,24 Psay "O R D E M   D E   M O N T A G E M" Font ofnt3 
      //@Li,65 Psay CHR(27)+"&k4S"+CHR(27)+"(s7B"+"OM: "+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SPACE(05)+CHR(27)+"(s-5B"+CHR(27)+'(s10H'
      Li++
      @Li,00 Psay REPLICATE(CHR(151),170)
      Li++
  	Endif                   

  	@Li,10 PSay aTitulo[mv_par13][nCont]
   @Li,38 PSay "Ass.______________________"
   @Li,66 PSay "Data __/__/__ "
	Li++
   @Li,80 PSay ""
	// Li,00 PSay STR0032+IIF(lSH8,DTOC(SH8->H8_DTINI),Space(8))+" "+IIF(lSH8,SH8->H8_HRINI,Space(5))+" "+STR0033+" ____/ ____/____ ___:___"  //"INICIO  ALOC.: "###" INICIO  REAL :"
	// Li++
	// @Li,00 PSay STR0034+IIF(lSH8,DTOC(SH8->H8_DTFIM),Space(8))+" "+IIF(lSH8,SH8->H8_HRFIM,Space(5))+" "+STR0035+" ____/ ____/____ ___:___"  //"TERMINO ALOC.: "###" TERMINO REAL :"
	// Li++
	// @Li,00 PSay "Perdas: ________"
	// Li++
	// @Li,00 PSay __PrtThinLine()
	Li++
Next

//cContPg :=Alltrim(SC2->C2_NUM+" "+SC2->C2_ITEM+SC2->C2_SEQUEN)
 
If mv_par14 == 1.And.Alltrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN) <> cContPg
	if  (oprn:npage%2) <> 0
  		endpage
      page
      cContPg :=Alltrim(SC2->C2_NUM+" "+SC2->C2_ITEM+SC2->C2_SEQUEN)
  	endif 
endif

Return
		
	   
//	@Li,40 PSay "Ordem de Produção"
//	IF (mv_par06 == 1) // .And. aReturn[5] # 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime o codigo de barras do numero da OP              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Alteração feita por Fabrício Becherini (10/05/04)
//	oPr := ReturnPrtObj()
//oPr := oprn
//cCode := ("010"+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD+"13")
//MSBAR2("CODE128",7.5,2.5,Alltrim(cCode),oPr,Nil,Nil,Nil,nil ,0.5 ,Nil,Nil,Nil)
//MSBAR2("CODE128",7.5,2.5,Alltrim(cCode),Nil,Nil,Nil,nil ,0.5 ,Nil,Nil,Nil)
//Li +=5
//	cCode := ("010"+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD+"13")
//			MSBAR3("CODE128",10,2,Alltrim(cCode),oPr,Nil,Nil,,2 ,2,1,Nil,Nil,Nil)
//ENDIF
// deletei aqui

/*
User Function ETI_ZEBRA()
Local nX
Local cPorta
cPorta := "COM2:9600,n,8,2"
MSCBPRINTER("S500-8",cPorta,,,.f.,,,,) 
MSCBLOADGRF("SIGA.GRF")
For nx:=1 to 3
MSCBBEGIN(1,6)                            
MSCBBOX(02,01,76,35)
MSCBLineH(30,05,76,3) 
MSCBLineH(02,13,76,3,"B") 
MSCBLineH(02,20,76,3,"B") 
MSCBLineV(30,01,13)
	MSCBGRAFIC(2,3,"SIGA")                   
	MSCBSAY(33,02,'PRODUTO',"N","0","025,035") 
	MSCBSAY(33,06,"CODIGO","N","A","015,008")
	MSCBSAY(33,09, "000006", "N", "0", "032,035") 
	MSCBSAY(05,14,"DESCRICAO","N","A","015,008")
	MSCBSAY(05,17,"IMPRESSORA ZEBRA S500-8","N", "0", "020,030")
	MSCBSAYBAR(23,22,"00000006","N","C",8.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)
	MSCBEND()
Next	
MSCBCLOSEPRINTER()
Return

//Endif

Return Li  

*/


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ ImpRot   ³ Autor ³ Marcos Bregantim      ³ Data ³ 10/07/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Imprime Roteiro de Operacoes                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ ImpRot()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function ImpRot(lSH8)
Local nBegin

dbSelectArea("SH1")
dbSeek(xFilial()+IIf(lSH8,SH8->H8_RECURSO,SG2->G2_RECURSO))

Verilim()

@Li,00 PSay IIF(lSH8,SH8->H8_RECURSO,SG2->G2_RECURSO)+" "+SUBS(SH1->H1_DESCRI,1,25)
@Li,33 PSay SG2->G2_FERRAM+" "+SUBS(SH4->H4_DESCRI,1,20)
@Li,61 PSay SG2->G2_OPERAC

For nBegin := 1 To Len(Alltrim(SG2->G2_DESCRI)) Step 16
	@li,064 PSay Substr(SG2->G2_DESCRI,nBegin,16)
	li++
Next nBegin

Li+=1
@Li,00 PSay STR0032+IIF(lSH8,DTOC(SH8->H8_DTINI),Space(8))+" "+IIF(lSH8,SH8->H8_HRINI,Space(5))+" "+STR0033+" ____/ ____/____ ___:___"	//"INICIO  ALOC.: "###" INICIO  REAL :"
Li++
@Li,00 PSay STR0034+IIF(lSH8,DTOC(SH8->H8_DTFIM),Space(8))+" "+IIF(lSH8,SH8->H8_HRFIM,Space(5))+" "+STR0035+" ____/ ____/____ ___:___"	//"TERMINO ALOC.: "###" TERMINO REAL :"
Li++
@Li,00 PSay STR0019	//"Quantidade :"
@Li,13 PSay IIF(lSH8,SH8->H8_QUANT,aSC2Sld()) PICTURE PesqPictQt("H8_QUANT",14)
@Li,28 PSay STR0036	//"Quantidade Produzida :               Perdas :"
Li++                                                                 
@Li,00 PSay "Data __/__/__ASS. __________________________________"
Li++                                                                 
@Li,00 PSay __PrtThinLine()
Li++

Return
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ RotOper  ³ Autor ³ Paulo Boschetti       ³ Data ³ 18/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Imprime Roteiro de Operacoes                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ RotOper()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function cRotOper()


Li++
@Li,00 Psay REPLICATE(CHR(151),170)
Li++
@Li,24 Psay "O R D E M   D E   M O N T A G E M"     
@Li,65 Psay "OM: "+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SPACE(05)+CHR(27) Font ofnt2
Li++
@Li,00 Psay REPLICATE(CHR(151),170)
Li++  
@Li,00 PSay STR0013+aArray[1][1] //"Produto: "
ImpDescr(aArray[1][2]) 

 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime a quantidade original quando a quantidade da    ³
//³ Op for diferente da quantidade ja entregue              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SC2->C2_QUJE + SC2->C2_PERDA > 0
	@Li,00 PSay STR0017			//"Qtde Prod.:"
	@Li,11 PSay aSC2Sld()		PICTURE PesqPictQt("C2_QUANT",14)
	@Li,26 PSay STR0018			//"Qtde Orig.:"
	@Li,37 PSay SC2->C2_QUANT	PICTURE PesqPictQt("C2_QUANT",14)
Else
	@Li,00 PSay STR0019		//"Quantidade :"
	@Li,15 PSay aSC2Sld()	PICTURE PesqPictQt("C2_QUANT",14)
Endif

Li++
@Li,00 PSay STR0023+SC2->C2_CC	//"C.Custo: "
Li++
@Li,00 Psay REPLICATE(CHR(151),170)
Li++
@Li,00 Psay "RECURSO                       FERRAMENTA               OPERAÇÃO"
Li++
@Li,00 Psay REPLICATE(CHR(151),170)
Li++

***
Return Li      




/* Deletei Aqui
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ Verilim  ³ Autor ³ Paulo Boschetti       ³ Data ³ 18/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ Verilim()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 			                                          		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

//Static Function Verilim()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a possibilidade de impressao da proxima operacao alocada na ³
//³ mesma folha.																			 ³
//³ 7 linhas por operacao => (total da folha) 66 - 7 = 59					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*IF Li > 59						// Li > 55
	Li := 0
	cRotOper(0)					// Imprime cabecalho roteiro de operacoes
Endif
Return Li     


/* Deletei
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ BARCODE  ³ Autor ³ Ricardo Dutra          ³ Data ³ 16/08/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa para imprimir codigo de barras                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CodBar(ExpC1)								               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
  
*/

/*#define ESC	27
Static Function BarCode(cCodigo)
Local nLargura := 40	// largura de impressao do codigo
Local i, j, l, k, nCarac, cTexto, cEsc, cCode, nLimite, nImp, nBorda, nLin
Local aV0 := { Replicate(Chr(0),7), Chr(0) + Chr(0) + Chr(0) }
Local aV1 := { Replicate(Chr(127),6), Chr(127) + Chr(127) }
Local aImp [50]

nLin := 0							// imprime codigo comeco formulario
cEsc := Chr(ESC)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Reseta a impressora na posicao atual - comeco formulario           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 0,0 PSay cEsc + "@"				// reseta a impressora nesta posicao

cTexto := cCodigo
cTexto := "*" + cTexto + "*"		// caracteres de inicio e fim

nImp := 1
aImp [nImp] := ""
nLimite := Len(cTexto)

FOR i := 1 TO nLimite
	nCarac := Asc (Substr (cTexto, i, 1))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atribui um codigo a cada caracter                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	IF nCarac == 42					// *                     
	
		cCode := "2122121222"
	ELSEIF nCarac == 32				// branco
		cCode := "2112221222"
	ELSEIF nCarac == 48				// 0
		cCode := "2221121222"
	ELSEIF nCarac == 49				// 1
		cCode := "1221222212"
	ELSEIF nCarac == 50				// 2
		cCode := "2211222212"
	ELSEIF nCarac == 51				// 3
		cCode := "1211222222"
	ELSEIF nCarac == 52				// 4
		cCode := "2221122212"
	ELSEIF nCarac == 53				// 5
		cCode := "1221122222"
	ELSEIF nCarac == 54				// 6
		cCode := "2211122222"
	ELSEIF nCarac == 55				// 7
		cCode := "2221221212"
	ELSEIF nCarac == 56				// 8
		cCode := "1221221222"
	ELSEIF nCarac == 57				// 9
		cCode := "2211221222"
	ELSEIF nCarac == 65				// A
		cCode := "1222212212"
	ELSEIF nCarac == 66				// B
		cCode := "2212212212"
	ELSEIF nCarac == 67				// C
		cCode := "1212212222"
	ELSEIF nCarac == 68				// D
		cCode := "2222112212"
	ELSEIF nCarac == 69				// E
		cCode := "1222112222"
	ELSEIF nCarac == 70				// F
		cCode := "2212112222"
	ELSEIF nCarac == 71				// G
		cCode := "2222211212"
	ELSEIF nCarac == 72				// H
		cCode := "1222211222"
	ELSEIF nCarac == 73				// I
		cCode := "2212211222"
	ELSEIF nCarac == 74				// J
		cCode := "2222111222"
	ELSEIF nCarac == 75				// K
		cCode := "1222222112"
	ELSEIF nCarac == 76				// L
		cCode := "2212222112"
	ELSEIF nCarac == 77				// M
		cCode := "1212222122"
	ELSEIF nCarac == 78				// N
		cCode := "2222122112"
	ELSEIF nCarac == 79				// O
		cCode := "1222122122"
	ELSEIF nCarac == 80				// P
		cCode := "2212122122"
	ELSEIF nCarac == 81				// Q
		cCode := "2222221112"
	ELSEIF nCarac == 82				// R
		cCode := "1222221122"
	ELSEIF nCarac == 83				// S
		cCode := "2212221122"
	ELSEIF nCarac == 84				// T
		cCode := "2222121122"
	ELSEIF nCarac == 85				// U
		cCode := "1122222212"
	ELSEIF nCarac == 86				// V
		cCode := "2112222212"
	ELSEIF nCarac == 87				// W
		cCode := "1112222222"
	ELSEIF nCarac == 88				// X
		cCode := "2122122212"
	ELSEIF nCarac == 89				// Y
		cCode := "1122122222"
	ELSEIF nCarac == 90				// Z
		cCode := "2112122222"
	ENDIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona barras ou espacos ao array de impressao, sendo :     ³
	//³ - barra grossa  = 6 * Chr(127)                				      ³
	//³ - barra fina    = 2 * Chr(127)								         ³
	//³ - espaco grosso = 7 * Chr(0)                                  ³
	//³ - espaco fino   = 3 * Chr(0) 								         ³
	//³																               ³
	//³ As barras e espacos sao alocados de acordo com os caracteres  ³
	//³ de cCode, tomados 2 a 2, sendo que o primeiro designa as bar- ³
	//³ ras e o segundo, os espacos. 								         ³
	//³ Se o caracter for 1 => barra/espaco grosso					      ³
	//³ Se o caracter for 2 => barra/espaco fino					         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FOR j := 1 to 9 STEP 2
		aImp[nImp] := aImp[nImp] + aV1 [val(substr(cCode,j,1))] + ;
		aV0 [val(substr(cCode,j + 1,1))]
	NEXT
	
	l := len(aImp[nImp])       */
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se tamanho do string atual de impressao for maior que 120,		     ³
	//³copia o que ultrapassou para o proximo string						 ³
	//³Limita o string atual para 120 + caracteres de controle de imp grafica³
	//³Incrementa contador de strings										 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/ //Deletei Aqui
	
	/*IF l > 120
		aImp[nImp+1] := Right(aImp[nImp],l -120)
		aImp[nImp] := cEsc + "L" + Chr(120) + Chr(0) + Left(aImp[nImp],120)
		nImp++
	ENDIF
NEXT

j := Len(aImp[nImp])      */

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Borda esquerda da etiqueta para centrar o codigo   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*nBorda := (nLargura - (j + (nImp - 1) * 120 ) / Len(cTexto)) / 2

IF nBorda < 0
	return -2		// Codigo muito grande p/largura especificada
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Acrescenta caracteres de controle grafico ao ultimo string   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aImp[nImp] := cEsc + "L" + Chr(j)+Chr(0) + aImp[nImp] + cEsc + "3" + Chr(1)

FOR l := 1 to 4					// imprime quatro linhas
	FOR k := 1 to 3				// imprime tres vezes
		FOR i := 1 to nImp		// contador de strings
			@ nLin,nBorda+(i-1)*10 PSay aImp[i]
		NEXT
		nLin++
	NEXT
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seta tamanho de linha para posicionar para a proxima         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ nLin,1 PSay cEsc + "3" + Chr(18)
	nLin++
NEXT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seta tamanho de linha p/ posicionar cursor proxima coluna de texto ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ nLin,1 PSay  cEsc + "3" + Chr(24)
nLin++

@ nLin,1 PSay cEsc + "2"			// cancela espacamentos de linha progrados

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime o numero da OP expandido e centralizado, embaixo do codigo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNumOp := Replicate(" ",3) + cTexto		// para centralizar
@ nLin,nBorda PSay Chr(14) + cNumOp	    // imprime expandido
nLin++
@ nLin,0 PSay Chr(20)					// volta ao normal

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpDescr ³ Autor ³ Marcos Bregantim      ³ Data ³ 31.08.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprimir descricao do Produto.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpProd(Void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*Static Function ImpDescr(cDescri)

For nBegin := 1 To Len(Alltrim(cDescri)) Step 50
	@li,025 PSay Substr(cDescri,nBegin,50)
	li++
Next nBegin

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R820Medidas³ Autor ³ Jose Lucas           ³ Data ³ 25.01.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o registros referentes as medidas do Pedido Filho. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R820Medidas(Void)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*Static Function R820Medidas()
Local aArrayPro := {}, lImpItem := .T.
Local nCntArray := 0,a01 := "",a02 := ""
Local nX:=0,nI:=0,nL:=0,nY:=0
Local cNum:="", cItem:="",lImpCab := .T.
Local nBegin, cProduto:="", cDesc, cDescri, cDescri1, cDescri2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime Relacao de Medidas do cliente quando OP for gerada ³
//³ por pedidos de vendas.                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC5")
dbSetOrder(1)
If dbSeek(xFilial()+SC2->C2_PEDIDO,.F.)
	cNum := SC2->C2_NUM
	cItem := SC2->C2_ITEM
	cProduto := SC2->C2_PRODUTO
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprimir somente se houver Observacoes.                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  
  	IF !Empty(SC5->C5_OBSERVA)
	   *///deletei aqui
	     /*	IF li > 53
			@ 03,001 PSay "HUNTER DOUGLAS DO BRASIL LTDA"
			@ 05,008 PSay "CONFIRMACAO DE PEDIDOS  -  "+IIF( SC5->C5_VENDA=="01","ASSESSORIA","DISTRIBUICAO")
			@ 05,055 PSay "No. RMP    : "+SC5->C5_NUM+"-"+SC5->C5_VENDA
			@ 06,055 PSay "DATA IMPRES: "+DTOC(dDataBase)
			li := 07
		EndIF
		li++
		@ li,001 PSay "--------------------------------------------------------------------------------"
		li++
		cDescri := SC5->C5_OBSERVA
		@ li,001 PSay " OBSERVACAO: "
		@ li,018 PSay SubStr(cDescri,1,60)
		For nBegin := 61 To Len(Trim(cDescri)) Step 60
			li++
			cDesc:=Substr(cDescri,nBegin,60)
			@ li,018 PSay cDesc
		Next nBegin
		li++
		cDescri1 := SC5->C5_OBSERV1
		@ li,018 PSay SubStr(cDescri1,1,60)
		For nBegin := 61 To Len(Trim(cDescri1)) Step 60
			li++
			cDesc:=Substr(cDescri1,nBegin,60)
			@ li,018 PSay cDesc
		Next nBegin
		Li++
		cDescri2 := SC5->C5_OBSERV2
		@ li,018 PSay SubStr(cDescri2,1,60)
		For nBegin := 61 To Len(Trim(cDescri2)) Step 60
			li++
			cDesc:=Substr(cDescri2,nBegin,60)
			@ li,018 PSay cDesc
		Next nBegin
		li++
		@ li,001 PSay "--------------------------------------------------------------------------------"
		li++
	EndIf    */
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carregar as medidas em array para impressao.                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*dbSelectArea("SMX")
	dbSetOrder(2)
	dbSeek(xFilial()+cNum+cProduto)
	While !Eof() .And. M6_FILIAL+M6_NRREL+M6_PRODUTO == xFilial()+cNum+cProduto
		IF M6_ITEM == cItem
			AADD(aArrayPro,M6_ITEM+" - "+M6_PRODUTO)
			nCntArray++
			cCnt := StrZero(nCntArray,2)
			aArray&cCnt := {}
			While !Eof() .And. M6_FILIAL+M6_NRREL+M6_PRODUTO == xFilial()+cNum+cProduto
				If M6_ITEM == cItem
					AADD(aArray&cCnt,{ Str(M6_QUANT,9,2)," PECAS COM ",M6_COMPTO})
				EndIf
				dbSkip()
			End
		Else
			dbSkip()
		EndIF
	End
	cCnt := StrZero(nCntArray+1,2)
	aArray&cCnt := {}
	
	For nX := 1 TO Len(aArrayPro)
		If li > 58
			R820CabMed()
		EndIF
		@ li,009 PSay aArrayPro[nx]
		Li++
		Li++
		dbSelectArea("SMX")
		dbSetOrder(2)
		dbSeek( xFilial()+cNum+Subs(aArrayPro[nX],06,15) )
		While !Eof() .And. M6_FILIAL+M6_NRREL+M6_PRODUTO == xFilial()+cNum+Subs(aArrayPro[nX],06,15)
			If li > 58
				R820CabMed()
			EndIF
			IF M6_ITEM == Subs(aArrayPro[nX],1,2)
				@ li,002 PSay M6_QUANT
				@ li,013 PSay "PECAS COM"
				@ li,023 PSay M6_COMPTO
				@ li,035 PSay M6_OBS
				li ++
			EndIF
			dbSkip()
		End
		li++
	Next nX
	@ li,001 PSay "--------------------------------------------------------------------------------"
EndIf
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R820CabMed ³ Autor ³ Jose Lucas           ³ Data ³ 25.01.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o cabecalho referentes as medidas do Pedido Filho. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R820CabMed(Void)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R820CabMed()


Li := 0

Li++
//@Li,00 Psay REPLICATE(CHR(151),80)
@Li,00 Psay REPLICATE(CHR(151),170)
Li++
@Li,24 Psay "O R D E M   D E   M O N T A G E M"
@Li,65 Psay "OM: "+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SPACE(05)+CHR(27) Font ofnt2
Li++
//@Li,00 Psay REPLICATE(CHR(151),80)
@Li,00 Psay REPLICATE(CHR(151),170)
Li++
Return Nil
