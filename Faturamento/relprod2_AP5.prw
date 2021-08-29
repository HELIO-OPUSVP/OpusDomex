// =====================================================================================
// Dt Alteração | Autor    | Motivo
// 20/05/11      Juliano F.  Alteração dos campos para incluir a data da emissao da NF
// Alterado posicao dos campos para evitar campos truncados
// Foi excluido o campo de numero de om
// =====================================================================================

#include "rwmake.ch"
#include "laser.ch"
#include "topconn.ch"

//#DEFINE PSAY SAY

User Function relprod2()


If MsgYesNo("Deseja executar a nova versão deste relatório para validação da melhora de performance?","Atenção")
   NewRelato()
   Return
EndIf

SetPrvt("WNREL,TAMANHO,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("NREGISTRO,CKEY,NINDEX,CINDEX,CCONDICAO,LEND")
SetPrvt("CPERG,ARETURN,NOMEPROG,NLASTKEY,NBEGIN,ALINHA")
SetPrvt("LI,LIMITE,LRODAPE,CPICTQTD,NTOTQTD,NTOTVAL")
SetPrvt("NGERAL,APEDCLI,CSTRING,QTDTOT,M_PAG,CABEC1")
SetPrvt("CABEC2,NSUBTOTAL,NTOTAL,_SALIAS,AREGS,I,J,MEUTRAB,TRABCAMPOS,AORDEM")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RELPRO   ³ Autor ³ Marcia Maria Natale   ³ Data ³ 23.11.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao de relacoes  de pedidos de venda por Produto       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RELPROpr                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ OBS      ³                                                            ³±±
±±³          ³ Adaptacao do lay-out segundo necessidade do cliente DOMEX  ³±±
±±³          ³ para impressao dos pedidos de venda por produto            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel            := ""
tamanho          := "G"
titulo           := "Emissao de Listagem de Pedido"
cDesc1           := "Emiss„o de listagem de pedidos de venda, de acordo com"
cDesc2           := "intervalo informado na op‡„o Parƒmetros."
cDesc3           := " "
nRegistro        := 0
cKey             := ""
nIndex           := ""
cIndex           := ""//  && Variaveis para a criacao de Indices Temp.
cCondicao        := ""
lEnd             := .T.
cPerg            := "RELPRO"
aReturn          := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nomeprog         := "RELPRO2"
nLastKey         := 0
nBegin           := 0
aLinha           := { }
li               := 80
limite           := 220
lRodape          := .F.
cPictQtd         := ""
nTotQtd          := nTotVal:=0
nGeral           := 0
aPedCli          := {}
wnrel            := "RELPRO2"
cString          := "SC6"
aOrdem           := { "Emissão", "OF", "NF", "OM", "Produto", "Quantidade", "Valor S/ IPI","Valor C/ Impostos", "Total", "Subtotal", "Entrega", "Fatura"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte("RELPRO",.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01              Da Data do Pedido                     ³
//³ mv_par02              Ate Data do Pedido                    ³
//³ mv_par06              Da Data do Pedido                     ³
//³ mv_par07              Ate Data do Pedido                    ³
//³ mv_par03              Do Nome PRODUTO                       ³
//³ mv_par04              Ate Nome PRODUTO                      ³
//³ mv_par05              Pedidos faturados/Nao faturados/ambos ³
//³ mv_par06              DA ENTREGA                            ³
//³ mv_par07              Ate entrega                           ³
//³ mv_par08              Do cliente                            ³
//³ mv_par09              Ate cliente                           ³
//³ mv_par10              do Faturamento                        ³
//³ mv_par11              Ate faturameto                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrdem,.T.,"G")

If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Return
	
Endif

RptStatus({||C730Imp()})// Substituido pelo assistente de conversao do AP5 IDE em 30/07/01 ==>     RptStatus({||Execute(C730Imp)})

Return



Static Function C730IMP()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
tamanho        :="G"
titulo         :="EMISSAO DE LISTAGEM DE PEDIDO POR PRODUTO"
cDesc1         :="Emiss„o dos pedidos de venda, de acordo com"
cDesc2         :="intervalo informado na op‡„o Parƒmetros."
cDesc3         :=" "
nRegistro      := 0
cKey           :=""
nIndex         :=""
cIndex         :=""//  && Variaveis para a criacao de Indices Temp.
cCondicao      :=""
QTDTOT         := 0
trabcampos     := { }

aadd(trabcampos, { "TB_EMISSAO", "D", 8, 0 } )
aadd(trabcampos, { "TB_OF", "C", 6, 0 } )
aadd(trabcampos, { "TB_F_NF", "C", 8, 0 } )
//aadd(trabcampos, { "TB_ITEM", "C", 20, 0 } )
aadd(trabcampos, { "TB_OM", "C", 6, 0 } )
aadd(trabcampos, { "TB_PRODUTO", "C", 15, 0 } )
aadd(trabcampos, { "TB_QTD", "N", 9, 2 } )
aadd(trabcampos, { "TB_VALORS", "N", 9, 2 } )
aadd(trabcampos, { "TB_VALORC", "N", 9, 2 } )
aadd(trabcampos, { "TB_TOTAL", "N", 15, 2 } )
aadd(trabcampos, { "TB_SUBTOT", "N", 15, 2 } )
aadd(trabcampos, { "TB_ENTREGA", "D", 8, 0 } )//JFS 20/05/11 JULIANO ALTERADO
/* SUBSTIUIR A DATA DA ENTEGA POR DATA DA EMISSAO DA NF
C6_DATFAT
*/
aadd(trabcampos, { "TB_FATURA" , "D", 08, 0 } )
aadd(trabcampos, { "TB_CLIENTE", "C", 30, 0 } )
aadd(trabcampos, { "TB_OBS"    , "C", 30, 0 } )
aadd(trabcampos, { "TB_DESCPRO", "C", 30, 0 } )
aadd(trabcampos, { "TB_CLIRED" , "C", 20, 0 } )
aadd(trabcampos, { "TB_CODCLI" , "C", 20, 0 } )
aadd(trabcampos, { "TB_ITEM"   , "C", 20, 0 } )
aadd(trabcampos, { "TB_TRANSP" , "C", 40, 0 } )

meutrab := criatrab(trabcampos,.t.)
dbusearea(.t.,,meutrab,meutrab,.t.,.f.)
indregua(meutrab,meutrab,trabcampos[aReturn[8]][1],,,"Criando indice ...")

//pergunte("RELPRO",.F.)
cESP:="               "
DbSelectArea("SB1")
dbSetOrder(3)
DbGoTop()
//Set SoftSeek on
dbSeek(xFilial("SB1")+(MV_PAR03+cESP))
//Set SoftSeek off
SetRegua(lastrec())            // Total de Elementos da regua
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contadores de linha e pagina                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
li := 80
m_pag := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o cabecalho.                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//                    10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
//          01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//CABEC2 := "EMISSAO  OF     ITEM         NF     CLIENTE             PRODUTO                           CODIGO           COD.CLIENTE         QTD        Vlr s/IPI    Vlr C/ IMP.   Total         DT.Em NF   FATURA   ENT.Real  OBSERVACAO "
CABEC2 := "EMISSAO  OF     ITEM         NF     CLIENTE             PRODUTO                           CODIGO           COD.CLIENTE         QTD        Vlr s/IPI    Vlr C/ IMP.   Total         Dt.Entrega   Dt.Fatura   OBSERVACAO "

IF MV_PAR05 =="F"
	CABEC1 := "Emitidos entre "+ dtoc(mv_par01) + " a "+dtoc(mv_par02) + " - Faturados entre " + dtoc(mv_par10) + " a "+dtoc(mv_par11) + " - Entregues entre " + dtoc(mv_par06) + " a "+dtoc(mv_par07)
ELSEIF MV_PAR05 == "N"
	CABEC1 := "Emitidos entre "+ dtoc(mv_par01) + " a "+dtoc(mv_par02) + " - NAO Faturados entre " + dtoc(mv_par10) + " a "+dtoc(mv_par11) + " - Entregues entre " + dtoc(mv_par06) + " a "+dtoc(mv_par07)
ELSE
	CABEC1 := "Emitidos entre "+ dtoc(mv_par01) + " a "+dtoc(mv_par02) + " - Faturados e Nao Faturados entre " + dtoc(mv_par10) + " a "+dtoc(mv_par11) + " - Entregues entre " + dtoc(mv_par06) + " a "+dtoc(mv_par07)
endif

If li > 58
	cabec(titulo,cabec1,cabec2,wnrel,Tamanho)
EndIf

nSubTotal := 0
nTotal := 0

SC2->( dbSetOrder(6) )

SB1->(dbSeek(xFilial("SB1")+(AllTrim(MV_PAR03))))
While SB1->(!Eof()) .And. SB1->B1_DESC >= mv_par03 .AND. SB1->B1_DESC <= mv_par04
	IF LastKey() == 286
		@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	incregua()
	
	if sb1->b1_cod < mv_par12 .or. sb1->b1_cod > mv_par13
		skip
		loop
	endif
	
	DBSELECTAREA("SC6")
	DBSETORDER(2)
	dbSeek(xFilial("SC6")+SB1->B1_COD )
	
	While sc6->(!eof()) .and. SC6->C6_PRODUTO == SB1->B1_COD
		
		If MV_PAR05 == "F"
			IF  EMPTY(SC6->C6_DATFAT) .OR. (SC6->C6_DATFAT < mv_par10 .OR. SC6->C6_DATFAT > mv_par11)
				sc6->(DBSKIP())
				LOOP
			ENDIF
		ENDIF
		
		//If !GetMV("MV_XXINVDT")   tratado na segunda inversão
		//	IF SC6->C6_ENTREG < mv_par06 .OR. SC6->C6_ENTREG >mv_par07  // Tratado
		//		sc6->(DBSKIP())
		//		LOOP
		//	ENDIF
		//Else
			IF SC6->C6_DTFATUR < mv_par06 .OR. SC6->C6_DTFATUR >mv_par07  // Tratado
				sc6->(DBSKIP())
				LOOP
			ENDIF		
		//EndIf
		
		dbSelectArea("SC5")
		SC5->(dbSetOrder(1))
		SC5->(dbseek(xFilial("SC5")+SC6->C6_NUM))
		IF SC5->C5_XPVTIPO <> "OF"
			sc6->(DBSKIP())
			LOOP
		ENDIF
		
		DBSELECTAREA("SC6")              
		//--> Elimina o registro com residuo
		//--> Inserido por Michel Sander em 04.12.2014
		IF AllTrim(SC6->C6_BLQ) == "R"
		   SC6->(dbSkip())
		   Loop
		EndIf
		
		IF mv_par05 == "N" .AND. SC6->C6_QTDENT >= SC6->C6_QTDVEN
			sc6->(DBSKIP())
			LOOP
		ENDIF
		IF SC5->C5_EMISSAO < mv_par01 .OR. SC5->C5_EMISSAO >mv_par02
			sc6->(DBSKIP())
			LOOP
		ENDIF
		DBSELECTAREA("SA1")
		DBSETORDER(1)
		If SA1->(DBSEEK(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			IF AllTrim(SA1->A1_NOME) < AllTrim(mv_par08) .OR. AllTrim(SA1->A1_NOME) > AllTrim(mv_par09)
				sc6->(DBSKIP())
				LOOP
			ENDIF
		Else
			sc6->(DBSKIP())
			LOOP
		EndIf

		DBSELECTAREA("SC6")
		
		dbselectarea(meutrab)
		reclock(meutrab,.t.)
		
		TB_EMISSAO := SC5->C5_EMISSAO
		TB_OF      := SC5->C5_NUM
		TB_TRANSP  := Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_NOME")
		
		IF !EMPTY(SC6->C6_NOTA)
			TB_F_NF := "S "+SC6->C6_NOTA
		ENDIF
		
		TB_ITEM    := SC6->C6_SEUDES
		TB_DESCPRO := SC6->C6_DESCRI
		TB_CODCLI  := SC6->C6_SEUCOD
		TB_CLIENTE := SUBS(SA1->A1_NOME,1,30)
		TB_CLIRED  := SUBS(SA1->A1_NREDUZ,1,20)
		TB_OM      := SC2->C2_NUM
		TB_PRODUTO := SB1->B1_COD
		
		IF mv_par05 == "N"
			VALOR   := ((SC6->C6_QTDVEN - SC6->C6_QTDENT) * SC6->C6_PRCVEN)
			QTDE    := (SC6->C6_QTDVEN - SC6->C6_QTDENT)
		ENDIF
		
		IF mv_par05 == "F"
			VALOR   := (SC6->C6_QTDENT * SC6->C6_PRCVEN)
			QTDE    := SC6->C6_QTDENT
		ENDIF
		
		IF mv_par05 == "A"
			VALOR   := (SC6->C6_QTDVEN * SC6->C6_PRCVEN)
			QTDE    := SC6->C6_QTDVEN
		ENDIF
		
		TB_QTD     := QTDE
		TB_VALORS  := SC6->C6_PRCVEN
		TB_VALORC  := SC6->C6_PRCVEN*((SC6->C6_IPI/100)+1)
		TB_TOTAL   := NoRound(VALOR*((SC6->C6_IPI/100)+1))
		
		IF nSubTotal == 0
			TB_SUBTOT := NoRound(VALOR*((SC6->C6_IPI/100)+1))
		Else
			TB_SUBTOT := nSubTotal
		EndIF
		
		If !GetMV("MV_XXINVDT")    // tratado na segunda inversão
		   //TB_ENTREGA := SC6->C6_ENTREG   // Tratado
		   //TB_FATURA   := SC6->C6_DTFATUR   // Tratado
		   TB_ENTREGA := SC6->C6_DTFATUR  // Tratado
		   TB_FATURA   := SC6->C6_ENTRE3   // Tratado
		Else
		   TB_ENTREGA := SC6->C6_DTFATUR  // Tratado
		   TB_FATURA   := SC6->C6_ENTREG   // Tratado
		EndIf
		
		TB_OBS      := SC5->C5_ESP1
		
		nTotal := nTotal + NOROUND(VALOR*((SC6->C6_IPI/100)+1))
		QTDTOT := QTDE + QTDTOT
		nSubTotal := nSubTotal + NOROUND(VALOR*((SC6->C6_IPI/100)+1))
		
		msunlock()
		//dbskip()
		
		SC6->( dbSkip() )
	ENDDO
	
	DBSELECTAREA("SB1")
	SB1->(DBSKIP())
	nSubTotal := 0
ENDDO

DBSEEK(XFILIAL()+SC6->C6_NUM)
dbselectarea(meutrab)
dbgotop()
while !eof()
	@ LI,000      PSAY TB_EMISSAO
	@ LI,pCol()+1 PSAY TB_OF
	@ LI,pCol()+1 PSAY TB_ITEM
	@ LI,pCol()+1 PSAY TB_F_NF
	@ LI,pCol()+1 PSAY TB_CLIRED
	//@ LI,56 PSAY TB_OM
	/*
	ALTERADO A REGUAR DE DESLOCAMENTO -10 PARA ACERTAR A DATA DE EMISSAO DA NF
	CAMPO DA TABELA SD2 D2_DT_EMSI FAT >6TIPO C
	*/
	
	/* juliano ferreira da silva  20/05/11 inic
	@ LI,62 PSAY TB_DESCPRO
	@ LI,112 PSAY TB_PRODUTO
	@ LI,127  PSAY TB_CODCLI
	@ LI,147 PSAY TB_QTD picture "@E 999,999.99"
	@ LI,158 PSAY TB_VALORS picture "@E 999,999.99"
	@ LI,169 PSAY TB_VALORC picture "@E 999,999.99"
	@ LI,180 PSAY TB_TOTAL picture "@E 99999,999.99"
	//  @ LI,139 PSAY TB_SUBTOT picture "@E 99999,999.99"
	@ LI,191 PSAY TB_ENTREGA
	@ LI,199 PSAY TB_FATURA
	// @ LI,200 PSAY TB_ENTREGAR
	@ LI,208 PSAY TB_OBS
	fim juliano ferreira da silva */
	
	
	@ LI,pCol()+1 PSAY TB_DESCPRO
	@ LI,pCol()+1 PSAY TB_PRODUTO
	@ LI,pCol()+1  PSAY TB_CODCLI
	@ LI,pCol()+1 PSAY TB_QTD picture "@E 999,999.99"
	@ LI,pCol()+1 PSAY TB_VALORS picture "@E 999,999.99"
	@ LI,pCol()+1 PSAY TB_VALORC picture "@E 999,999.99"
	@ LI,pCol()+1 PSAY TB_TOTAL picture "@E 99999,999.99"
	//@ LI,139 PSAY TB_SUBTOT picture "@E 99999,999.99"
	//@ LI,179 PSAY TB_ENTREGA
	//@ LI,190 PSAY TB_FATURA
	@ LI,pCol()+1 PSAY DtoC(TB_ENTREGA)
	@ LI,pCol()+1 PSAY TB_FATURA
	@ LI,pCol()+1 PSAY TB_OBS
	//@ LI,pCol()+1 PSAY TB_TRANSP
	
	If li > 58
		cabec(titulo,cabec1,cabec2,wnrel,Tamanho)
	EndIf
	LI := LI + 1
	dbskip()
enddo
dbclosearea()
ferase(meutrab+".DBF")


dbclosearea()
ferase(meutrab+".DBF")

LI := LI + 1
@ LI,010 PSAY "TOTAL GERAL "
@ LI,095 PSAY QTDTOT PICTURE "@E 99,999,999.99"
@ LI,116 PSAY nTotal picture "@E 99,999,999,999.99"

Eject

If aReturn[5] == 1
	dbCommitAll()
	Set Printer To
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return


Static Function NewRelato()

SetPrvt("WNREL,TAMANHO,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("NREGISTRO,CKEY,NINDEX,CINDEX,CCONDICAO,LEND")
SetPrvt("CPERG,ARETURN,NOMEPROG,NLASTKEY,NBEGIN,ALINHA")
SetPrvt("LI,LIMITE,LRODAPE,CPICTQTD,NTOTQTD,NTOTVAL")
SetPrvt("NGERAL,APEDCLI,CSTRING,QTDTOT,M_PAG,CABEC1")
SetPrvt("CABEC2,NSUBTOTAL,NTOTAL,_SALIAS,AREGS,I,J,MEUTRAB,TRABCAMPOS,AORDEM")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RELPRO   ³ Autor ³ Marcia Maria Natale   ³ Data ³ 23.11.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao de relacoes  de pedidos de venda por Produto       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RELPROpr                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ OBS      ³                                                            ³±±
±±³          ³ Adaptacao do lay-out segundo necessidade do cliente DOMEX  ³±±
±±³          ³ para impressao dos pedidos de venda por produto            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel            := ""
tamanho          := "G"
titulo           := "Emissao de Listagem de Pedido"
cDesc1           := "Emiss„o de listagem de pedidos de venda, de acordo com"
cDesc2           := "intervalo informado na op‡„o Parƒmetros."
cDesc3           := " "
nRegistro        := 0
cKey             := ""
nIndex           := ""
cIndex           := ""//  && Variaveis para a criacao de Indices Temp.
cCondicao        := ""
lEnd             := .T.
cPerg            := "RELPRO"
aReturn          := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nomeprog         := "RELPRO2"
nLastKey         := 0
nBegin           := 0
aLinha           := { }
li               := 80
limite           := 220
lRodape          := .F.
cPictQtd         := ""
nTotQtd          := nTotVal:=0
nGeral           := 0
aPedCli          := {}
wnrel            := "RELPRO2"
cString          := "SC6"
aOrdem           := { "Emissão", "OF", "NF", "OM", "Produto", "Quantidade", "Valor S/ IPI","Valor C/ Impostos", "Total", "Subtotal", "Entrega", "Fatura"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

pergunte("RELPRO",.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01              Da Data do Pedido                     ³
//³ mv_par02              Ate Data do Pedido                    ³
//³ mv_par06              Da Data do Pedido                     ³
//³ mv_par07              Ate Data do Pedido                    ³
//³ mv_par03              Do Nome PRODUTO                       ³
//³ mv_par04              Ate Nome PRODUTO                      ³
//³ mv_par05              Pedidos faturados/Nao faturados/ambos ³
//³ mv_par06              DA ENTREGA                            ³
//³ mv_par07              Ate entrega                           ³
//³ mv_par08              Do cliente                            ³
//³ mv_par09              Ate cliente                           ³
//³ mv_par10              do Faturamento                        ³
//³ mv_par11              Ate faturameto                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrdem,.T.,"G")

If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Return
	
Endif

RptStatus({||C730Imp2()})

Return



Static Function C730IMP2()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
tamanho        :="G"
titulo         :="EMISSAO DE LISTAGEM DE PEDIDO POR PRODUTO"
cDesc1         :="Emiss„o dos pedidos de venda, de acordo com"
cDesc2         :="intervalo informado na op‡„o Parƒmetros."
cDesc3         :=" "
nRegistro      := 0
cKey           :=""
nIndex         :=""
cIndex         :=""//  && Variaveis para a criacao de Indices Temp.
cCondicao      :=""
QTDTOT         := 0
trabcampos     := { }

aadd(trabcampos, { "TB_EMISSAO", "D", 8, 0 } )
aadd(trabcampos, { "TB_OF", "C", 6, 0 } )
aadd(trabcampos, { "TB_F_NF", "C", 8, 0 } )
//aadd(trabcampos, { "TB_ITEM", "C", 20, 0 } )
aadd(trabcampos, { "TB_OM", "C", 6, 0 } )
aadd(trabcampos, { "TB_PRODUTO", "C", 15, 0 } )
aadd(trabcampos, { "TB_QTD", "N", 9, 2 } )
aadd(trabcampos, { "TB_VALORS", "N", 12, 2 } )
aadd(trabcampos, { "TB_VALORC", "N", 12, 2 } )
aadd(trabcampos, { "TB_TOTAL", "N", 15, 2 } )
aadd(trabcampos, { "TB_SUBTOT", "N", 15, 2 } )
aadd(trabcampos, { "TB_ENTREGA", "D", 8, 0 } )//JFS 20/05/11 JULIANO ALTERADO
/* SUBSTIUIR A DATA DA ENTEGA POR DATA DA EMISSAO DA NF
C6_DATFAT
*/
aadd(trabcampos, { "TB_FATURA" , "D", 08, 0 } )
aadd(trabcampos, { "TB_CLIENTE", "C", 30, 0 } )
aadd(trabcampos, { "TB_OBS"    , "C", 30, 0 } )
aadd(trabcampos, { "TB_DESCPRO", "C", 30, 0 } )
aadd(trabcampos, { "TB_CLIRED" , "C", 20, 0 } )
aadd(trabcampos, { "TB_CODCLI" , "C", 20, 0 } )
aadd(trabcampos, { "TB_ITEM"   , "C", 20, 0 } )
aadd(trabcampos, { "TB_TRANSP" , "C", 40, 0 } )

meutrab := criatrab(trabcampos,.t.)
dbusearea(.t.,,meutrab,meutrab,.t.,.f.)
indregua(meutrab,meutrab,trabcampos[aReturn[8]][1],,,"Criando indice ...")

cESP:="               "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contadores de linha e pagina                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
li := 80
m_pag := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o cabecalho.                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//                    10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
//          01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//CABEC2 := "EMISSAO  OF     ITEM         NF     CLIENTE             PRODUTO                           CODIGO           COD.CLIENTE         QTD        Vlr s/IPI    Vlr C/ IMP.   Total         DT.Em NF   FATURA   ENT.Real  OBSERVACAO "
CABEC2 := "EMISSAO  OF     ITEM         NF     CLIENTE             PRODUTO                           CODIGO           COD.CLIENTE         QTD        Vlr s/IPI    Vlr C/ IMP.   Total         Dt.Entrega   Dt.Fatura   OBSERVACAO "

IF MV_PAR05 =="F"
	CABEC1 := "Emitidos entre "+ dtoc(mv_par01) + " a "+dtoc(mv_par02) + " - Faturados entre " + dtoc(mv_par10) + " a "+dtoc(mv_par11) + " - Entregues entre " + dtoc(mv_par06) + " a "+dtoc(mv_par07)
ELSEIF MV_PAR05 == "N"
	CABEC1 := "Emitidos entre "+ dtoc(mv_par01) + " a "+dtoc(mv_par02) + " - NAO Faturados entre " + dtoc(mv_par10) + " a "+dtoc(mv_par11) + " - Entregues entre " + dtoc(mv_par06) + " a "+dtoc(mv_par07)
ELSE
	CABEC1 := "Emitidos entre "+ dtoc(mv_par01) + " a "+dtoc(mv_par02) + " - Faturados e Nao Faturados entre " + dtoc(mv_par10) + " a "+dtoc(mv_par11) + " - Entregues entre " + dtoc(mv_par06) + " a "+dtoc(mv_par07)
endif

If li > 58
	cabec(titulo,cabec1,cabec2,wnrel,Tamanho)
EndIf

nSubTotal := 0
nTotal := 0

SC2->( dbSetOrder(6) )

cQuery := "SELECT B1_COD, C5_EMISSAO, C5_NUM, C5_TRANSP, C6_NOTA, C6_SEUDES, C6_DESCRI, C6_SEUCOD, A1_NOME, A1_NREDUZ, C6_QTDENT, C6_PRCVEN, C6_IPI, C6_DTFATUR, C6_ENTRE3, C5_ESP1, C6_QTDVEN "
cQuery += "FROM " + RetSqlTab("SB1") + " (NOLOCK), " + RetSqlTab("SC6") + " (NOLOCK), " + RetSqlTab("SC5") + " (NOLOCK), " + RetSqlTab("SA1") + " (NOLOCK) "
cQuery += "WHERE B1_COD = C6_PRODUTO AND C6_NUM = C5_NUM AND C6_BLQ <> 'R' AND C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA "
cQuery += "AND B1_DESC >= '"+mv_par03+"' AND B1_DESC <= '"+mv_par04+"' AND B1_COD >= '"+mv_par12+"' AND B1_COD <= '"+mv_par13+"' "
cQuery += " AND C5_XPVTIPO = '" + mv_par14 + "' "
If MV_PAR05 == "F"  // Somente Faturados
   cQuery += "AND C6_DATFAT <> '' AND C6_DATFAT >= '"+DtoS(mv_par10)+"' AND C6_DATFAT <= '"+DtoS(mv_par11)+"' "
EndIf   
If MV_PAR05 == "N" // Somente Nao Faturados
   cQuery += "AND C6_QTDENT < C6_QTDVEN "
EndIf

cQuery += "AND C5_EMISSAO >= '"+DtoS(mv_par01)+"' AND C5_EMISSAO <= '"+DtoS(mv_par02)+"' "
		
cQuery += "AND C6_DTFATUR >= '"+DtoS(mv_par06)+"' AND C6_DTFATUR <= '"+DtoS(mv_par07)+"' "
 
cQuery += "AND A1_NOME >= '"+mv_par08+"' AND A1_NOME <= '"+mv_par09+"' "

cQuery += "AND SB1.D_E_L_E_T_ = '' AND SC6.D_E_L_E_T_ = '' AND SC5.D_E_L_E_T_ = '' AND SA1.D_E_L_E_T_ = ''"

If Select("QUERY") <> 0
   QUERY->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERY"

nReg := 0
QUERY->( dbEval({||nReg++}) )

SetRegua(nReg)

QUERY->(dbGoTop()) 

While QUERY->(!Eof()) 
	If LastKey() == 286
		@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	incregua()

		dbselectarea(meutrab)
		reclock(meutrab,.t.)
		
		TB_EMISSAO := StoD(QUERY->C5_EMISSAO)
		TB_OF      := QUERY->C5_NUM
		TB_TRANSP  := Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_NOME")
		
		IF !EMPTY(QUERY->C6_NOTA)
			TB_F_NF := "S "+QUERY->C6_NOTA
		ENDIF
		
		TB_ITEM    := QUERY->C6_SEUDES
		TB_DESCPRO := QUERY->C6_DESCRI
		TB_CODCLI  := QUERY->C6_SEUCOD
		TB_CLIENTE := SUBS(QUERY->A1_NOME,1,30)
		TB_CLIRED  := SUBS(QUERY->A1_NREDUZ,1,20)
		TB_OM      := "" // QUERY->C2_NUM
		TB_PRODUTO := QUERY->B1_COD
		
		IF MV_PAR05 == "N"
			VALOR   := ((QUERY->C6_QTDVEN - QUERY->C6_QTDENT) * QUERY->C6_PRCVEN)
			QTDE    := (QUERY->C6_QTDVEN - QUERY->C6_QTDENT)
		ENDIF
		
		IF MV_PAR05 == "F"
			VALOR   := (QUERY->C6_QTDENT * QUERY->C6_PRCVEN)
			QTDE    := QUERY->C6_QTDENT
		ENDIF
		
		IF MV_PAR05 == "A"
			VALOR   := (QUERY->C6_QTDVEN * QUERY->C6_PRCVEN)
			QTDE    := QUERY->C6_QTDVEN
		ENDIF
		
		TB_QTD     := QTDE
		TB_VALORS  := QUERY->C6_PRCVEN
		TB_VALORC  := QUERY->C6_PRCVEN*((QUERY->C6_IPI/100)+1)
		TB_TOTAL   := NoRound(VALOR*((QUERY->C6_IPI/100)+1))
		
		IF nSubTotal == 0
			TB_SUBTOT := NoRound(VALOR*((QUERY->C6_IPI/100)+1))
		Else
			TB_SUBTOT := nSubTotal
		EndIF
		
		If !GetMV("MV_XXINVDT")    // tratado na segunda inversão
		   //TB_ENTREGA := SC6->C6_ENTREG   // Tratado
		   //TB_FATURA   := SC6->C6_DTFATUR   // Tratado
		   TB_ENTREGA := StoD(QUERY->C6_DTFATUR)  // Tratado
		   TB_FATURA   := StoD(QUERY->C6_ENTRE3)   // Tratado
		Else
		   TB_ENTREGA := StoD(QUERY->C6_DTFATUR)  // Tratado
		   TB_FATURA   := StoD(QUERY->C6_ENTREG)   // Tratado
		EndIf
		
		TB_OBS      := QUERY->C5_ESP1
		
		nTotal := nTotal + NOROUND(VALOR*((QUERY->C6_IPI/100)+1))
		QTDTOT := QTDE + QTDTOT
		nSubTotal := nSubTotal + NOROUND(VALOR*((QUERY->C6_IPI/100)+1))
		
		msunlock()
		//dbskip()
		
	//	SC6->( dbSkip() )
	//ENDDO
	
	//DBSELECTAREA("SB1")
	QUERY->(DBSKIP())
	nSubTotal := 0
END

//DBSEEK(XFILIAL()+SC6->C6_NUM)
dbselectarea(meutrab)
dbgotop()
while !eof()
	@ LI,000      PSAY TB_EMISSAO
	@ LI,pCol()+1 PSAY TB_OF
	@ LI,pCol()+1 PSAY TB_ITEM
	@ LI,pCol()+1 PSAY TB_F_NF
	@ LI,pCol()+1 PSAY TB_CLIRED
	
	@ LI,pCol()+1 PSAY TB_DESCPRO
	@ LI,pCol()+1 PSAY TB_PRODUTO
	@ LI,pCol()+1 PSAY TB_CODCLI
	@ LI,pCol()+1 PSAY TB_QTD    picture "@E 999,999.99"
	@ LI,pCol()+1 PSAY TB_VALORS picture "@E 999,999,999.99"
	@ LI,pCol()+1 PSAY TB_VALORC picture "@E 999,999,999.99"
	@ LI,pCol()+1 PSAY TB_TOTAL  picture "@E 999,999,999.99"
	//@ LI,139 PSAY TB_SUBTOT picture "@E 99999,999.99"
	//@ LI,179 PSAY TB_ENTREGA
	//@ LI,190 PSAY TB_FATURA
	@ LI,pCol()+1 PSAY DtoC(TB_ENTREGA)
	@ LI,pCol()+1 PSAY TB_FATURA
	@ LI,pCol()+1 PSAY TB_OBS
	//@ LI,pCol()+1 PSAY TB_TRANSP
	
	If li > 58
		cabec(titulo,cabec1,cabec2,wnrel,Tamanho)
	EndIf
	LI := LI + 1
	dbskip()
enddo
dbclosearea()
ferase(meutrab+".DBF")


//dbclosearea()
//ferase(meutrab+".DBF")

LI := LI + 1
@ LI,010 PSAY "TOTAL GERAL "
@ LI,095 PSAY QTDTOT PICTURE "@E 99,999,999.99"
@ LI,116 PSAY nTotal picture "@E 99,999,999,999.99"

//Eject

If aReturn[5] == 1
	dbCommitAll()
	Set Printer To
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

