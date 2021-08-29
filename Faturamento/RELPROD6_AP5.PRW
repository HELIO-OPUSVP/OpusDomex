#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 30/07/01
#include "laser.ch"
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function relprod6()        // incluido pelo assistente de conversao do AP5 IDE em 30/07/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("WNREL,TAMANHO,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("NREGISTRO,CKEY,NINDEX,CINDEX,CCONDICAO,LEND")
SetPrvt("CPERG,ARETURN,NOMEPROG,NLASTKEY,NBEGIN,ALINHA")
SetPrvt("LI,LIMITE,LRODAPE,CPICTQTD,NTOTQTD,NTOTVAL")
SetPrvt("NGERAL,APEDCLI,CSTRING,QTDTOT,M_PAG,CABEC1")
SetPrvt("CABEC2,NSUBTOTAL,NTOTAL,_SALIAS,AREGS,I,J,MEUTRAB,TRABCAMPOS,AORDEM")

// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 30/07/01 ==> #include "laser.ch"
#IFNDEF WINDOWS
	// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 30/07/01 ==>     #DEFINE PSAY SAY
#ENDIF
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
wnrel            :=""
tamanho          :="G"
titulo           :="Emissao de Listagem de Pedido"
cDesc1           :="Emiss„o de listagem de pedidos de venda, de acordo com"
cDesc2           :="intervalo informado na op‡„o Parƒmetros."
cDesc3           :=" "
nRegistro        := 0
cKey             :=""
nIndex           :=""
cIndex           :=""//  && Variaveis para a criacao de Indices Temp.
cCondicao        :=""
lEnd             := .T.
cPerg            :="RELPRO"
aReturn          := { "Zebrado", 1,"Administracao", 2, 2, 1, "", 1 }
nomeprog         :="RELPRO"
nLastKey         := 0
nBegin           :=0
aLinha           :={ }
li               :=80
limite           :=220
lRodape          :=.F.
cPictQtd         :=""
nTotQtd          :=nTotVal:=0
nGeral           := 0
aPedCli          := {}
wnrel            := "RELPRO"
cString          := "SC6"
aOrdem           := { "Emissão", "OF", "NF", "Produto", "Quantidade", "Valor S/ Impostos",;
"Valor C/ Impostos", "Local", "Valor S/ IPI" }
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
validperg()
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

#IFDEF WINDOWS
	RptStatus({||C730Imp()})// Substituido pelo assistente de conversao do AP5 IDE em 30/07/01 ==>     RptStatus({||Execute(C730Imp)})
	Return
	// Substituido pelo assistente de conversao do AP5 IDE em 30/07/01 ==>     Function C730IMP
	Static Function C730IMP()
#ENDIF

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
aadd(trabcampos, { "TB_PRODUTO", "C", 15, 0 } )
aadd(trabcampos, { "TB_QTD", "N", 9, 2 } )
aadd(trabcampos, { "TB_VALORS", "N", 9, 2 } )
aadd(trabcampos, { "TB_VALORC", "N", 9, 2 } )
aadd(trabcampos, { "TB_TOTAL", "N", 9, 2 } )
aadd(trabcampos, { "TB_LOCAL", "C", 2, 0 } )
aadd(trabcampos, { "TB_VALOR", "N", 9, 2 } )
aadd(trabcampos, { "TB_CLIENTE", "C", 30, 0 } )
//aadd(trabcampos, { "TB_DESCPRO", "C", 30, 0 } )
//aadd(trabcampos, { "TB_CLIRED", "C", 20, 0 } )
//aadd(trabcampos, { "TB_DESENHO", "C", 20, 0 } )
aadd(trabcampos, { "TB_ENTREGA", "D", 8, 0 } )
aadd(trabcampos, { "TB_FATURA", "D", 8, 0 } )
aadd(trabcampos, { "TB_OBS", "C", 30, 0 } )

meutrab := criatrab(trabcampos,.t.)
dbusearea(.t.,,meutrab,meutrab,.t.,.f.)
indregua(meutrab,meutrab,trabcampos[aReturn[8]][1],,,"Criando indice ...")

//pergunte("RELPRO",.F.)
cESP:="               "
DbSelectArea("SB1")
dbSetOrder(3)
DbGoTop()
Set SoftSeek on
dbSeek(xFilial("SB1")+(MV_PAR03+cESP))
Set SoftSeek off
SetRegua(lastrec())            // Total de Elementos da regua
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contadores de linha e pagina                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
li := 80
m_pag := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o cabecalho.                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//                    10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180
//          012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
CABEC2 := "DATA      OF             CLIENTE                           LOCALIDADE     PRODUTO               QTD     PRC S/ IMP   VALOR S/ IPI     VALOR C/ IMPOSTOS     TOTAL      ENTREGA   FATURA    OBSERVACAO"
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
While !Eof() .And. SB1->B1_DESC >= mv_par03 .AND. SB1->B1_DESC <= mv_par04
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
	While !eof() .and. SC6->C6_PRODUTO == SB1->B1_COD
		if MV_PAR05 == "F"
			IF  EMPTY(SC6->C6_DATFAT) .OR. (SC6->C6_DATFAT < MV_PAR10 .OR. SC6->C6_DATFAT >MV_PAR11)
				SKIP
				LOOP
			ENDIF
		ENDIF
		IF SC6->C6_ENTREG < MV_PAR06 .OR. SC6->C6_ENTREG >MV_PAR07
			SKIP
			LOOP
		ENDIF
		dbSelectArea("SC5")
		dbSetOrder(1)
		dbseek(xFilial("SC5")+SC6->C6_NUM)
		DBSELECTAREA("SC6")
		//alterado por Marcos Rezende
		//data: 17/10/2012
		//motivo: Devido a alteração da numeração dos pedidos de venda
		//foi necessário a inclusão de parâmetro para informar o tipo de pedido
		//a ser considerado.
		//If SC5->C5_XPVTIPO < mv_par14 .or. SC5->C5_XPVTIPO > mv_par15
		If SC5->C5_XPVTIPO <> mv_par14 //.or. SC5->C5_XPVTIPO > mv_par15
			dbSkip()
			Loop
		Endif
		
		///////////////////////////////////////
		IF MV_PAR05 = "N" .AND. SC6->C6_QTDENT >= SC6->C6_QTDVEN
			SKIP
			LOOP
		ENDIF
		IF SC5->C5_EMISSAO < MV_PAR01 .OR. SC5->C5_EMISSAO >MV_PAR02
			SKIP
			LOOP
		ENDIF
		DBSELECTAREA("SA1")
		DBSETORDER(1)
		DBSEEK(XFILIAL("SA1")+SC5->C5_CLIENTE)
		DBSELECTAREA("SC6")
		IF SA1->A1_NOME < MV_PAR08 .OR. SA1->A1_NOME > MV_PAR09
			SKIP
			LOOP
		ENDIF
		
		dbselectarea(meutrab)
		reclock(meutrab,.t.)
		
		//         @ LI,01 PSAY SC5->C5_EMISSAO
		TB_EMISSAO := SC5->C5_EMISSAO
		TB_OBS     := SUBS(SC5->C5_ESP1,1,30)
		//         @ LI,10 PSAY SC5->C5_NUM
		TB_OF := SC5->C5_NUM
		IF !EMPTY(SC6->C6_NOTA)
			//            @ LI,17 PSAY "S "+SC6->C6_NOTA
			TB_F_NF := "S "+SC6->C6_NOTA
			//TB_DESCPRO := SC6->C6_DESCRI
			//56TB_DESENHO:= SC6->C6_SEUDES
			
		ENDIF
		
		If !GetMV("MV_XXINVDT")   // tratado na segunda inversão
		   //TB_FATURA:= SC6->C6_DTFATUR  // Tratado
		   //TB_ENTREGA:= SC6->C6_ENTREG  // Tratado
		   TB_FATURA:= SC6->C6_ENTRE3   // Tratado
		   TB_ENTREGA:= SC6->C6_DTFATUR // Tratado
		Else
		   TB_FATURA:= SC6->C6_ENTREG   // Tratado
		   TB_ENTREGA:= SC6->C6_DTFATUR // Tratado
		EndIf
		//         @ LI,27 PSAY SUBS(SA1->A1_NREDUZ,1,19)
		TB_CLIENTE := SUBS(SA1->A1_NOME,1,30)
		//TB_CLIRED:= SUBS(SA1->A1_NREDUZ,1,20)
		dbSelectArea("SC2")
		dbSetOrder(6)
		dbSeek(xFilial("SC2")+SC6->C6_NUM )
		//         dbSelectArea("SC6")
		dbselectarea(meutrab)
		//         @ LI,50 PSAY SC2->C2_NUM
		//	TB_OM := SC2->C2_NUM
		//         @ LI,58 PSAY SB1->B1_COD
		TB_PRODUTO := SB1->B1_COD
		
		IF MV_PAR05 = "N"
			VALOR := ((SC6->C6_QTDVEN - SC6->C6_QTDENT) * SC6->C6_PRCVEN)
			QTDE := (SC6->C6_QTDVEN - SC6->C6_QTDENT)
		ENDIF
		
		IF MV_PAR05 = "F"
			VALOR := (SC6->C6_QTDENT * SC6->C6_PRCVEN)
			QTDE := SC6->C6_QTDENT
		ENDIF
		
		IF MV_PAR05 = "A"
			VALOR := (SC6->C6_QTDVEN * SC6->C6_PRCVEN)
			QTDE := SC6->C6_QTDVEN
		ENDIF
		
		//         @ LI,095 PSAY QTDE picture "@E 999,999.99"
		TB_QTD := QTDE
		TB_VALORS := SC6->C6_PRCVEN
		//         @ LI,106 PSAY (SC6->C6_PRCVEN*((SC6->C6_IPI/100)+1)) picture "@E 999,999.99"
		TB_VALORC := SC6->C6_PRCVEN*((SC6->C6_IPI/100)+1)
		//         @ LI,120 PSAY NoRound(VALOR*((SC6->C6_IPI/100)+1)) picture "@E 99999,999.99"
		TB_TOTAL := NoRound(VALOR*((SC6->C6_IPI/100)+1))
		
		/*
		IF nSubTotal == 0
		//         	@ LI,133 PSAY NoRound(VALOR*((SC6->C6_IPI/100)+1)) picture "@E 999999,999.99"
		TB_SUBTOT := NoRound(VALOR*((SC6->C6_IPI/100)+1))
		Else
		//            @ LI,133 PSAY nSubTotal picture "@E 999999,999.99"
		TB_SUBTOT := nSubTotal
		EndIF
		*/
		
		//         @ LI,167 PSAY SUBS(SC5->C5_MENNOTA,1,20)
		//	TB_OBS := SUBS(SC5->C5_MENNOTA,1,30)
		nTotal := nTotal + NOROUND(VALOR*((SC6->C6_IPI/100)+1))
		QTDTOT := QTDE + QTDTOT
		nSubTotal := nSubTotal + NOROUND(VALOR*((SC6->C6_IPI/100)+1))
		TB_VALOR := tiraicms(SC6->C6_PRCVEN)
		TB_LOCAL := retlocal()
		
		msunlock()
		//dbskip()
		
		dbselectarea("SC6")
		SKIP
		/*
		LI := LI + 1
		If li > 58
		cabec(titulo,cabec1,cabec2,wnrel,Tamanho)
		EndIf
		*/
	ENDDO
	DBSELECTAREA("SB1")
	SKIP
	nSubTotal := 0
ENDDO
dbselectarea(meutrab)
dbgotop()
while !eof()
	@ LI,00 PSAY TB_EMISSAO
	@ LI,09 PSAY TB_OF
	@ LI,16 PSAY TB_F_NF
	@ LI,25 PSAY TB_CLIENTE
	@ LI,62 PSAY TB_LOCAL
	@ LI,74 PSAY TB_PRODUTO
	@ LI,89 PSAY TB_QTD picture "@E 999,999.99"
	@ LI,103 PSAY TB_VALOR picture "@E 999,999.99"
	@ LI,116 PSAY TB_VALORS picture "@E 999,999.99"
	@ LI,133 PSAY TB_VALORC picture "@E 999,999.99"
	@ LI,149 PSAY TB_TOTAL picture "@E 99999,999.99"
	//  @ LI,162 PSAY TB_SUBTOT picture "@E 99999,999.99"
	@ LI,167 PSAY TB_ENTREGA
	@ LI,177 PSAY TB_FATURA
	@ LI,187 PSAY TB_OBS
	If li > 58
		cabec(titulo,cabec1,cabec2,wnrel,Tamanho)
	EndIf
	LI := LI + 1
	dbskip()
enddo
dbclosearea()
ferase(meutrab+".DBF")

LI := LI + 1
@ LI,010 PSAY "TOTAL GERAL "
@ LI,095 PSAY QTDTOT PICTURE "@E 99,999,999.99"
@ LI,116 PSAY nTotal picture "@E 99,999,999,999.99"

Eject

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

// Substituido pelo assistente de conversao do AP5 IDE em 30/07/01 ==> Function ValidPerg
Static Function ValidPerg()
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := "RELPRO"
aRegs:={}
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
//AADD(aRegs,{cPerg,"01","Da Emissao do Pedido","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"02","Ate Emissao  Pedido?","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"03","Da Descricao Produto","mv_ch3","C",15,0,0,"G","","mv_par03","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"04","Ate Descr. Produto ?","mv_ch4","C",15,0,0,"G","","mv_par04","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"05","Faturados/Nao/Ambos?","mv_ch5","C",1,0,0,"G","","mv_par05","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"06","Da Entrega do Prod. ","mv_ch6","D",8,0,0,"G","","mv_par06","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"07","Ate Entrega  Prod.  ","mv_ch7","D",8,0,0,"G","","mv_par07","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"08","Do Nome Cliente     ","mv_ch8","C",15,0,0,"G","","mv_par08","","","","","","","","","","","","","",""})
//DD(aRegs,{cPerg,"09","Ate Nome Cliente   ?","mv_ch9","C",15,0,0,"G","","mv_par09","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"10","Do Faturamento      ","mv_ch10","D",8,0,0,"G","","mv_par10","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"11","Ate Faturamento     ","mv_ch11","D",8,0,0,"G","","mv_par11","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
		dbCommit()
	Endif
Next

dbSelectArea(_sAlias)

Return

static function tiraicms(valof)

local oldalias, valicm

oldalias := dbf()
dbselectarea("SA1")
dbsetorder(1)
if dbseek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJAENT)
	do case
		case A1_EST == "SP"
			valicm := valof * 0.7275
		case A1_EST $ "RS|SC|PR|RJ|MG"
			valicm := valof * 0.7875
		otherwise
			valicm := valof * 0.8375
	endcase
else
	valicm := 0
endif
dbselectarea(oldalias)

return valicm

static function retlocal()

local oldalias, localcl

oldalias := dbf()
dbselectarea("SA1")
dbsetorder(1)
if dbseek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJAENT)
	localcl := A1_EST
else
	localcl := ''
endif
dbselectarea(oldalias)

return localcl
