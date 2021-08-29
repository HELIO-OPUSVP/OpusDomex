#include "rwmake.ch"
#include "laser.ch"
#include "topconn.ch"

#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function RFATR01()

SetPrvt("WNREL,TAMANHO,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("NREGISTRO,CKEY,NINDEX,CINDEX,CCONDICAO,LEND")
SetPrvt("CPERG,ARETURN,NOMEPROG,NLASTKEY,NBEGIN,ALINHA")
SetPrvt("LI,LIMITE,LRODAPE,CPICTQTD,NTOTQTD,NTOTVAL")
SetPrvt("NGERAL,APEDCLI,CSTRING,QTDTOT,M_PAG,CABEC1")
SetPrvt("CABEC2,NSUBTOTAL,NTOTAL,_SALIAS,AREGS,I,J,MEUTRAB,TRABCAMPOS,AORDEM")

#IFNDEF WINDOWS
	
#ENDIF

wnrel            := ""
tamanho          := "G"
titulo           := "Emissao de Listagem de Pedido"
cDesc1           := "Emiss„o de listagem de pedidos de venda, de acordo com"
cDesc2           := "intervalo informado na op‡„o Parƒmetros."
cDesc3           := " "
nRegistro        := 0
cKey             := ""
nIndex           := ""
cIndex           := ""
cCondicao        := ""
lEnd             := .T.
cPerg            := "RFATR01"
aReturn          := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nomeprog         := "RELPRO"
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
wnrel            := "RELPRO"
cString          := "SC6"
aOrdem           := { "Emissão", "OF", "NF", "OM", "Produto", "Quantidade", "Valor S/ IPI","Valor C/ Impostos", "Total", "Subtotal", "Entrega", "Fatura"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

validperg()

pergunte("RFATR01",.T.)

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

Processa({||C730Imp()})// Substituido pelo assistente de conversao do AP5 IDE em 30/07/01 ==>     RptStatus({||Execute(C730Imp)})

Return

Static Function C730IMP()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
tamanho        := "G"
titulo         := "EMISSAO DE LISTAGEM DE PEDIDO POR PRODUTO"
cDesc1         := "Emiss„o dos pedidos de venda, de acordo com"
cDesc2         := "intervalo informado na op‡„o Parƒmetros."
cDesc3         := " "
nRegistro      := 0
cKey           := ""
nIndex         := ""
cIndex         := ""//  && Variaveis para a criacao de Indices Temp.
cCondicao      := ""
QTDTOT         := 0
trabcampos     := { }


aadd(trabcampos, { "TB_EMISSAO", "D", 8, 0 } )    // C6_EMISSAO
aadd(trabcampos, { "TB_OF"     , "C", 6, 0 } )    // C6_NUM
aadd(trabcampos, { "TB_ITEM"   , "C", 20, 0 } )   // C6_ITEM

aadd(trabcampos, { "TB_F_NF"   , "C", 8, 0 } )
//aadd(trabcampos, { "TB_ITEM", "C", 20, 0 } )
aadd(trabcampos, { "TB_OM", "C", 6, 0 } )
aadd(trabcampos, { "TB_PRODUTO", "C", 15, 0 } )
aadd(trabcampos, { "TB_QTD", "N", 9, 2 } )
//aadd(trabcampos, { "TB_VALORS", "N", 9, 2 } )
aadd(trabcampos, { "TB_VALORC", "N", 9, 2 } )
aadd(trabcampos, { "TB_TOTAL", "N", 9, 2 } )
aadd(trabcampos, { "TB_SUBTOT", "N", 12, 2 } )
aadd(trabcampos, { "TB_ENTREGA", "D", 8, 0 } )//JFS 20/05/11 JULIANO ALTERADO
aadd(trabcampos, { "TB_FATURA" , "D", 08, 0 } )
aadd(trabcampos, { "TB_CLIENTE", "C", 30, 0 } )
aadd(trabcampos, { "TB_OBS"    , "C", 30, 0 } )
aadd(trabcampos, { "TB_DESCPRO", "C", 30, 0 } )
aadd(trabcampos, { "TB_CLIRED" , "C", 20, 0 } )
aadd(trabcampos, { "TB_CODCLI" , "C", 20, 0 } )

aadd(trabcampos, { "TB_TRANSP" , "C", 40, 0 } )

//meutrab := criatrab(trabcampos,.t.)
//dbusearea(.t.,,meutrab,meutrab,.t.,.f.)

//indregua(meutrab,meutrab,trabcampos[aReturn[8]][1],,,"Criando indice ...")

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
//                    10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
//          01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//CABEC2 := "EMISSAO  OF     ITEM         NF     CLIENTE             PRODUTO                           CODIGO           COD.CLIENTE         QTD        Vlr s/IPI    Vlr C/ IMP.   Total         DT.Em NF   FATURA   ENT.Real  OBSERVACAO "
CABEC2 := "EMISSAO  OF     ITEM         NF     CLIENTE             PRODUTO                           CODIGO           COD.CLIENTE         QTD        Vlr s/IPI    Vlr C/ IMP.   Total         DT.Em NF   FATURA   OBSERVACAO "

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

If !GetMV("MV_XXINVDT")  // tratado na segunda inversão
	//cQuery := "SELECT C5_EMISSAO,  FROM "+RetSqlName("SC5")+", "+RetSqlName("SC6")+" "
	//cQuery += "WHERE C5_EMISSAO >= '"+DtoS(mv_par01)+"' AND C5_EMISSAO <= '"+DtoS(mv_par02)+"' "
	//cQuery += "AND C6_ENTREG  >= '"+DtoS(mv_par06)+"' AND C6_ENTREG <= '"+DtoS(mv_par07)+"' "    // Tratado
	//cQuery += "AND C5_CLIENT  >= '"+mv_par08+"' AND C5_CLIENTE <= '"+mv_par09+"' "
	//cQuery += "AND C6_DTFATUR >= '"+DtoS(mv_par10)+"' AND C6_DTFATUR <= '"+DtoS(mv_par11)+"' "   // Tratado
	//cQuery += "AND C6_PRODUTO >= '"+mv_par12+"' AND C6_PRODUTO <= '"+mv_par13+"' "
	//cQuery += "AND C5_XPVTIPO = '"+mv_par14+"' "
	//cQuery += "AND "+RetSqlName("SC5")+".D_E_L_E_T_ = '' AND "+RetSqlName("SC6")+".D_E_L_E_T_ = '' "
	//cQuery += "ORDER BY C6_EMISSAO "
	
	cQuery := "SELECT C5_EMISSAO,  FROM "+RetSqlName("SC5")+", "+RetSqlName("SC6")+" "
	cQuery += "WHERE C5_EMISSAO >= '"+DtoS(mv_par01)+"' AND C5_EMISSAO <= '"+DtoS(mv_par02)+"' "
	cQuery += "AND C6_DTFATUR  >= '"+DtoS(mv_par06)+"' AND C6_DTFATUR <= '"+DtoS(mv_par07)+"' "  // Tratado
	cQuery += "AND C5_CLIENT  >= '"+mv_par08+"' AND C5_CLIENTE <= '"+mv_par09+"' "
	cQuery += "AND C6_ENTRE3  >= '"+DtoS(mv_par10)+"' AND C6_ENTRE3 <= '"+DtoS(mv_par11)+"' "    // Tratado
	cQuery += "AND C6_PRODUTO >= '"+mv_par12+"' AND C6_PRODUTO <= '"+mv_par13+"' "
	cQuery += "AND C5_XPVTIPO = '"+mv_par14+"' "
	cQuery += "AND "+RetSqlName("SC5")+".D_E_L_E_T_ = '' AND "+RetSqlName("SC6")+".D_E_L_E_T_ = '' "
	cQuery += "ORDER BY C6_EMISSAO "
Else
	cQuery := "SELECT C5_EMISSAO,  FROM "+RetSqlName("SC5")+", "+RetSqlName("SC6")+" "
	cQuery += "WHERE C5_EMISSAO >= '"+DtoS(mv_par01)+"' AND C5_EMISSAO <= '"+DtoS(mv_par02)+"' "
	cQuery += "AND C6_DTFATUR  >= '"+DtoS(mv_par06)+"' AND C6_DTFATUR <= '"+DtoS(mv_par07)+"' "  // Tratado
	cQuery += "AND C5_CLIENT  >= '"+mv_par08+"' AND C5_CLIENTE <= '"+mv_par09+"' "
	cQuery += "AND C6_ENTREG  >= '"+DtoS(mv_par10)+"' AND C6_ENTREG <= '"+DtoS(mv_par11)+"' "    // Tratado
	cQuery += "AND C6_PRODUTO >= '"+mv_par12+"' AND C6_PRODUTO <= '"+mv_par13+"' "
	cQuery += "AND C5_XPVTIPO = '"+mv_par14+"' "
	cQuery += "AND "+RetSqlName("SC5")+".D_E_L_E_T_ = '' AND "+RetSqlName("SC6")+".D_E_L_E_T_ = '' "
	cQuery += "ORDER BY C6_EMISSAO "
EndIf

If Select("QUERYSC6") <> 0
	QUERYSC6->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYSC6"

While !QUERYSC6->( EOF() )
	
	IncProc()
	
	If MV_PAR05 == "F"
		IF Empty(QUERYSC6->C6_DATFAT) .OR. (QUERYSC6->C6_DATFAT < MV_PAR10 .OR. QUERYSC6->C6_DATFAT >MV_PAR11)
			QUERYSC6->(DBSKIP())
			LOOP
		ENDIF
	ENDIF
	
	/*
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
	
	IF MV_PAR05 = "N"
	VALOR   := ((SC6->C6_QTDVEN - SC6->C6_QTDENT) * SC6->C6_PRCVEN)
	QTDE    := (SC6->C6_QTDVEN - SC6->C6_QTDENT)
	ENDIF
	
	IF MV_PAR05 = "F"
	VALOR   := (SC6->C6_QTDENT * SC6->C6_PRCVEN)
	QTDE    := SC6->C6_QTDENT
	ENDIF
	
	IF MV_PAR05 = "A"
	VALOR   := (SC6->C6_QTDVEN * SC6->C6_PRCVEN)
	QTDE    := SC6->C6_QTDVEN
	ENDIF
	
	TB_QTD     := QTDE
	//TB_VALORS  := SC6->C6_PRCVEN
	TB_VALORC  := SC6->C6_PRCVEN*((SC6->C6_IPI/100)+1)
	TB_TOTAL   := NoRound(VALOR*((SC6->C6_IPI/100)+1))
	
	IF nSubTotal == 0
	TB_SUBTOT := NoRound(VALOR*((SC6->C6_IPI/100)+1))
	Else
	TB_SUBTOT := nSubTotal
	EndIF
	
	//TB_ENTREGAR := SC6->C6_ENTRE3
	//TB_OBS      := SC5->C5_ESP1
	TB_OBS      := SC5->C5_ESP2
	
	
	nTotal := nTotal + NOROUND(VALOR*((SC6->C6_IPI/100)+1))
	QTDTOT := QTDE + QTDTOT
	nSubTotal := nSubTotal + NOROUND(VALOR*((SC6->C6_IPI/100)+1))
	
	msunlock()
	dbskip()
	
	SC6->( dbSkip() )
	ENDDO
	DBSELECTAREA("SB1")
	SKIP
	nSubTotal := 0
	ENDDO
	*/
	
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
	//@ LI,pCol()+1  PSAY TB_CODCLI
	@ LI,pCol()+1 PSAY TB_QTD picture "@E 999,999.99"
	//@ LI,pCol()+1 PSAY TB_VALORS picture "@E 999,999.99"  // C6_PRCVEN
	//@ LI,pCol()+1 PSAY TB_VALORC picture "@E 999,999.99"
	@ LI,pCol()+1 PSAY TB_TOTAL picture "@E 99999,999.99"
	//@ LI,139 PSAY TB_SUBTOT picture "@E 99999,999.99"
	//@ LI,179 PSAY TB_ENTREGA
	//@ LI,190 PSAY TB_FATURA
	@ LI,pCol()+1 PSAY TB_FATURA
	@ LI,pCol()+1 PSAY DtoC(TB_ENTREGA)
	@ LI,pCol()+1 PSAY TB_TRANSP
	@ LI,pCol()+1 PSAY TB_OBS
	
	If li > 58
		cabec(titulo,cabec1,cabec2,wnrel,Tamanho)
	EndIf
	
	QUERYSC6->( dbSkip() )
enddo

dbclosearea()

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
cPerg := "RFATR01"
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
