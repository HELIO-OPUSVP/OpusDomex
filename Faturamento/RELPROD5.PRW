#include "rwmake.ch"
#include "laser.ch"
#include "rwmake.ch"
#include "topconn.ch"

User Function RELPROD5()

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
±±³Fun‡…o    ³ RELPROD5 ³ Autor ³ Reescrito por Hélio Ferreira em 08/12/16³±±
±±³          ³                                                            ³±±
±±³          ³                    Marcia Maria Natale   ³ Data ³ 23.11.00 ³±±
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
aReturn          := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog         :="RELPROD5"
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
wnrel            := "RELPROD5"
cString          := "SC6"
aOrdem           := { "Emissão", "Produto", "Quantidade", "Valor" }

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
aadd(trabcampos, { "TB_PRODUTO", "C", 15, 0 } )
aadd(trabcampos, { "TB_QTD", "N", 9, 2 } )
aadd(trabcampos, { "TB_TOTAL", "N", 12, 2 } )

//meutrab := criatrab(trabcampos,.t.)
//dbusearea(.t.,,meutrab,meutrab,.t.,.f.)
//indregua(meutrab,meutrab,"TB_PRODUTO",,,"Criando indice ...")

cESP := "               "

//DbSelectArea("SB1")
//dbSetOrder(3)

//DbGoTop()

//Set SoftSeek on

//dbSeek(xFilial("SB1")+(MV_PAR03+cESP))

//Set SoftSeek off

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contadores de linha e pagina                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

li    := 80
m_pag := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o cabecalho.                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                                                                     
CABEC2 := "PRODUTO           PROD.PREV.VENDAS         QTD PERÍODO                TOTAL       DESCRIÇÃO"

IF MV_PAR05 == "F"
	CABEC1 := "Emitidos entre "+ dtoc(mv_par01) + " a "+dtoc(mv_par02) + " - Faturados entre " + dtoc(mv_par10) + " a "+dtoc(mv_par11) + " - Entregues entre " + dtoc(mv_par06) + " a "+dtoc(mv_par07)+' - Cliente de "' + mv_par08 + '" até "' + mv_par09 + '"'
ELSEIF MV_PAR05 == "N"
	CABEC1 := "Emitidos entre "+ dtoc(mv_par01) + " a "+dtoc(mv_par02) + " - NAO Faturados entre " + dtoc(mv_par10) + " a "+dtoc(mv_par11) + " - Entregues entre " + dtoc(mv_par06) + " a "+dtoc(mv_par07)+' - Cliente de "' + mv_par08 + '" até "' + mv_par09 + '"'
ELSE
	CABEC1 := "Emitidos entre "+ dtoc(mv_par01) + " a "+dtoc(mv_par02) + " - Faturados e Nao Faturados entre " + dtoc(mv_par10) + " a "+dtoc(mv_par11) + " - Entregues entre " + dtoc(mv_par06) + " a "+dtoc(mv_par07)+' - Cliente de "' + mv_par08 + '" até "' + mv_par09 + '"'
endif

If li > 58
	cabec(titulo,cabec1,cabec2,wnrel,Tamanho)
EndIf

nSubTotal := 0
nTotal    := 0

cQuery := "SELECT B1_COD, B1_XPRVEND, B1_DESC, C6_IPI, "
If MV_PAR05 = "N"
	cQuery += "SUM(C6_QTDVEN - C6_QTDENT)               AS QUANTIDADE, "
	cQuery += "SUM((C6_QTDVEN - C6_QTDENT) * C6_PRCVEN) AS VALOR       "
EndIf
If MV_PAR05 = "F"
	cQuery += "SUM(C6_QTDENT)             AS QUANTIDADE, "
	cQuery += "SUM(C6_QTDENT * C6_PRCVEN) AS VALOR       "
EndIf

If MV_PAR05 = "A"
	cQuery += "SUM(C6_QTDVEN)             AS QUANTIDADE, "
	cQuery += "SUM(C6_QTDVEN * C6_PRCVEN) AS VALOR       "
EndIf
 
cQuery += "FROM " + RetSqlName("SB1") + " SB1, "+RetSqlName("SC5")+" SC5, "+RetSqlName("SC6")+" SC6, "+RetSqlName("SA1")+" SA1 "
cQuery += "WHERE B1_DESC >= '"+mv_par03+"' AND B1_DESC <= '"+mv_par04+"' AND "
cQuery += "B1_COD >= '"+mv_par12+"' AND B1_COD <= '"+mv_par13+"' AND "
cQuery += "C6_DTFATUR >= '"+DtoS(mv_par06)+"' AND C6_DTFATUR <= '"+DtoS(mv_par07)+"' AND "
cQuery += "B1_COD = C6_PRODUTO AND C6_NUM = C5_NUM AND C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND C5_XPVTIPO = '"+mv_par14+"' AND "
cQuery += "C5_EMISSAO >= '"+DtoS(MV_PAR01)+"' AND C5_EMISSAO <= '"+DtoS(MV_PAR02)+"' AND " 
cQuery += "A1_NOME >= '"+MV_PAR08+"' AND A1_NOME <= '"+MV_PAR09+"' AND "
cQuery += "SB1.D_E_L_E_T_ = '' AND SC5.D_E_L_E_T_ = '' AND SC6.D_E_L_E_T_ = '' "

If MV_PAR05 == "F"
   cQuery += "AND C6_DATFAT <> '' "
EndIf
If MV_PAR05 == "N"
   cQuery += "AND C6_QTDENT < C6_QTDVEN"
EndIf

cQuery += "GROUP BY B1_COD, B1_XPRVEND, B1_DESC, C6_IPI "
cQuery += "ORDER BY B1_XPRVEND, B1_COD "

If Select("QUERYSB1") <> 0
   QUERYSB1->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYSB1"

//SetRegua(lastrec())

//While !QUERYSB1->( Eof() )
	
	//If LastKey() == 286
	//	@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
	//	Exit
	//Endif
	
	//incregua()
	
	//DBSELECTAREA("SC6")
	//DBSETORDER(2)
	
	//dbSeek(xFilial()+SB1->B1_COD )
	
	//While !eof() .and. SC6->C6_PRODUTO == SB1->B1_COD
	
	
	//dbSelectArea("SC5")
	//dbSetOrder(1)
	//dbseek(xFilial()+SC6->C6_NUM)
	//DBSELECTAREA("SC6")
	//alterado por Marcos Rezende
	//data: 17/10/2012
	//motivo: Devido a alteração da numeração dos pedidos de venda
	//foi necessário a inclusão de parâmetro para informar o tipo de pedido
	//a ser considerado.
	
	//IF SC5->C5_EMISSAO < MV_PAR01 .OR. SC5->C5_EMISSAO >MV_PAR02
	//	SKIP
	//	LOOP
	//ENDIF
	//DBSELECTAREA("SA1")
	//DBSETORDER(1)
	//DBSEEK(XFILIAL()+SC5->C5_CLIENTE)
	//DBSELECTAREA("SC6")
	
	//IF SA1->A1_NOME < MV_PAR08 .OR. SA1->A1_NOME > MV_PAR09
	//	//         IF SA1->A1_NREDUZ < MV_PAR08 .OR. SA1->A1_NREDUZ > MV_PAR09
	//	SKIP
	//	LOOP
	//ENDIF
	
	//IF MV_PAR05 = "N" .AND. SC6->C6_QTDENT >= SC6->C6_QTDVEN
	//	SKIP
	//	LOOP
	//ENDIF
	
	//dbselectarea(meutrab)
	//if dbseek(SB1->B1_COD)
	//	reclock(meutrab)
	//else
	//	reclock(meutrab,.t.)
	//	TB_PRODUTO := SB1->B1_COD
	//	TB_QTD := 0
	//	TB_TOTAL := 0
	//endif
	
	
	//dbSelectArea("SC2")
	//dbSetOrder(6)
	//dbSeek(xFilial()+SC6->C6_NUM )
	//dbselectarea(meutrab)
	
	//IF MV_PAR05 = "N"
	//	VALOR := ((SC6->C6_QTDVEN - SC6->C6_QTDENT) * SC6->C6_PRCVEN)
	//	QTDE := (SC6->C6_QTDVEN - SC6->C6_QTDENT)
	//ENDIF
	
	//IF MV_PAR05 = "F"
	//	VALOR := (SC6->C6_QTDENT * SC6->C6_PRCVEN)
	//	QTDE := SC6->C6_QTDENT
	//ENDIF
	
	//IF MV_PAR05 = "A"
	//	VALOR := (SC6->C6_QTDVEN * SC6->C6_PRCVEN)
	//	QTDE := SC6->C6_QTDVEN
	//ENDIF
	
	//TB_QTD   := TB_QTD + QTDE
	//TB_TOTAL := TB_TOTAL + NoRound(VALOR*((SC6->C6_IPI/100)+1))
	
	
//	msunlock()
	
	//dbselectarea("SC6")
	//SKIP
	//ENDDO
//	QUERYSB1->( dbSkip() )
	nSubTotal := 0
//End

//dbselectarea("SB1")
//dbsetorder(1)
//dbselectarea(meutrab)
//dbclearind()
//indregua(meutrab,meutrab,trabcampos[aReturn[8]][1],,,"Criando indice ...")
//dbgobottom()

//SB1->( dbSetOrder(1) )

While !QUERYSB1->( Eof() )
   //SB1->( dbSeek( xFilial() + QUERYSB1->B1_COD ) )
   
   nCol := 0
	@ LI,nCol PSAY  QUERYSB1->B1_COD
   
   nCol += 22
   @ LI,nCol PSAY QUERYSB1->B1_XPRVEND
   
   nCol += 22
	@ LI,nCol PSAY QUERYSB1->QUANTIDADE picture "@E 999,999.99"
   
   nCol += 18
	@ LI,nCol PSAY QUERYSB1->VALOR * (1+(QUERYSB1->C6_IPI/100)) picture "@E 999999,999.99"
	//dbselectarea("SB1")
	//dbseek(xFilial()+&(meutrab+"->TB_PRODUTO"))
	//  @ LI,40 PSAY alltrim(B1_DESCR1)+" "+alltrim(B1_DESCR2)+" "+alltrim(B1_DESCR3)+" "+alltrim(B1_DESCR4)+" "+alltrim(B1_DESCR5)
	nCol += 20
	
	@ LI,nCol PSAY QUERYSB1->B1_DESC
	//dbselectarea(meutrab)
	If li > 58
		cabec(titulo,cabec1,cabec2,wnrel,Tamanho)
	EndIf
	LI++
	//QTDTOT += QUERYSB1->QUANTIDADE
	//nTotal += QUERYSB1->VALOR
	QUERYSB1->( dbSkip() )
enddo

//dbclosearea()
//ferase(meutrab+".DBF")

QUERYSB1->( dbCloseArea() )
 
LI := LI + 1
@ LI,010 PSAY "TOTAL GERAL "
@ LI,095 PSAY QTDTOT PICTURE "@E 99,999,999.99"
@ LI,116 PSAY nTotal picture "@E 99,999,999,999.99"

//Eject

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()
