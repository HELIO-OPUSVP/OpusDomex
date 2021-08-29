#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 30/07/01
#include "laser.ch"
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function relfat2()        // incluido pelo assistente de conversao do AP5 IDE em 30/07/01

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
SetPrvt("NGERAL,APEDCLI,CSTRING,M_PAG,MEDIA,VLTOT")
SetPrvt("QTDTOT,CABEC2,CABEC1,NSUBTOTAL,NTOTAL,NTOTAL2")
SetPrvt("PERIODO,WCABEC,_SALIAS,AREGS,I,J,MEUTRAB,TRABCAMPOS,AORDEM")

// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 30/07/01 ==> #include "laser.ch"
#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 30/07/01 ==>     #DEFINE PSAY SAY
#ENDIF
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ relfat   ³ Autor ³ Marcia Maria Natale   ³ Data ³ 23.11.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao de relacoes  de pedidos de venda por cliente       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ relfat                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ OBS      ³                                                            ³±±
±±³          ³ Adaptacao do lay-out segundo necessidade do cliente DOMEX  ³±±
±±³          ³ para impressao dos pedidos de venda                        ³±±
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
cDesc1           :="Emissao de listagem de pedidos de venda, de acordo com"
cDesc2           :="intervalo informado na opcao Parametros."
cDesc3           :=" "
nRegistro        := 0
cKey             :=""
nIndex           :=""
cIndex           :=""//  && Variaveis para a criacao de Indices Temp.
cCondicao        :=""
lEnd             := .T.
cPerg            :="RELFAT"
cPerg			     :=LEFT(cPerg+SPACE(10),10)
aReturn          := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nomeprog         :="relfat"
nLastKey         := 0
nBegin           := 0
aLinha           :={ }
li               :=80
limite           :=220
lRodape          :=.F.
cPictQtd         :=""
nTotQtd          :=nTotVal:=0
nGeral           := 0
aPedCli          := {}
wnrel            := "PEDCLI"
cString          := "SC6"
aOrdem           := { "Emissão", "OF", "NF", "OM", "Produto", "Quantidade", "Valor S/ IPI",;
                      "Valor C/ Impostos", "Total", "Subtotal", "Entrega", "Fatura" }
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
validperg()               
cPerg2		 :=LEFT("RELFAT"+SPACE(10),10)
pergunte(cPerg,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01              Da Data do Pedido                     ³
//³ mv_par02              Ate Data do Pedido                    ³
//³ mv_par06              Da Data do Pedido                     ³
//³ mv_par07              Ate Data do Pedido                    ³
//³ mv_par03              Do Nome PRODUTO                       ³
//³ mv_par04              Ate Nome PRODUTO                      ³
//³ mv_par05              Pedidos faturados/Nao faturados/ambos ³
//³ mv_par08              Da Data do Faturamento                ³
//³ mv_par09              Ate Data do Faturamento               ³
//³ mv_par10              Analitico ou sintetico                ³
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
    ëReturn
// Substituido pelo assistente de conversao do AP5 IDE em 30/07/01 ==>     Function C730IMP
Static Function C730IMP()
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
tamanho        :="G"
titulo         :="EMISSAO DE LISTAGEM DE PEDIDO POR CLIENTE"
cDesc1         :="Emissao dos pedidos de venda, de acordo com"
cDesc2         :="intervalo informado na opcao Parametros."
cDesc3         :=" "
nRegistro      := 0
cKey           :=""
nIndex         :=""
cIndex         :=""//  && Variaveis para a criacao de Indices Temp.
cCondicao      :=""
trabcampos     := { }

aadd(trabcampos, { "TB_EMISSAO", "D", 8, 0 } )
aadd(trabcampos, { "TB_OF", "C", 6, 0 } )
aadd(trabcampos, { "TB_F_NF", "C", 8, 0 } )
aadd(trabcampos, { "TB_OM", "C", 6, 0 } )
aadd(trabcampos, { "TB_PRODUTO", "C", 15, 0 } )
aadd(trabcampos, { "TB_QTD", "N", 9, 2 } )
aadd(trabcampos, { "TB_VALORS", "N", 9, 2 } )
aadd(trabcampos, { "TB_VALORC", "N", 9, 2 } )
aadd(trabcampos, { "TB_TOTAL", "N", 12, 2 } )
aadd(trabcampos, { "TB_SUBTOT", "N", 14, 2 } )
aadd(trabcampos, { "TB_ENTREGA", "D", 8, 0 } )
aadd(trabcampos, { "TB_FATURA", "D", 8, 0 } )
aadd(trabcampos, { "TB_CLIENTE", "C", 30, 0 } )
aadd(trabcampos, { "TB_OBS", "C", 30, 0 } )

meutrab := criatrab(trabcampos,.t.)
dbusearea(.t.,,meutrab,meutrab,.t.,.f.)
indregua(meutrab,meutrab,trabcampos[aReturn[8]][1],,,"Criando indice ...")   

DbSelectArea("SA1")
dbSetOrder(2)
DbGoTop()
Set SoftSeek on
dbSeek(xFilial()+MV_PAR03)
Set SoftSeek off
SetRegua(LastRec())            // Total de Elementos da regua
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contadores de linha e pagina                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
li := 80
m_pag := 1
MEDIA := 0
QTDE := 0
VALOR := 0
VLTOT := QTDTOT := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ IMPREME CABECALHO                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 CABEC2 := "EMISSAO   OF    F NF     CLIENTE                         O.M.   PRODUTO               QTD     VALOR S/ IPI     VALOR C/ IMPOSTOS     TOTAL     SUB.TOTAL  ENTREGA  FATURA  OBSERVACAO"
IF MV_PAR05 == 1
   CABEC1 := "Emitidos entre "+ dtoc(mv_par01) + " a "+dtoc(mv_par02) + " - Faturados entre " + dtoc(mv_par08) + " a "+dtoc(mv_par09) + " - Entregues entre " + dtoc(mv_par06) + " a "+dtoc(mv_par07)
ELSEIF MV_PAR05 == 2
   CABEC1 := "Emitidos entre "+ dtoc(mv_par01) + " a "+dtoc(mv_par02) + " - NAO Faturados entre " + dtoc(mv_par08) + " a "+dtoc(mv_par09) + " - Entregues entre " + dtoc(mv_par06) + " a "+dtoc(mv_par07)
ELSE   
   CABEC1 := "Emitidos entre "+ dtoc(mv_par01) + " a "+dtoc(mv_par02) + " - Faturados e Nao Faturados entre " + dtoc(mv_par08) + " a "+dtoc(mv_par09) + " - Entregues entre " + dtoc(mv_par06) + " a "+ dtoc(mv_par07)
endif

If li > 58
   cabec(titulo,cabec1,cabec2,wnrel,Tamanho)
EndIf

VALOR := QTDE := nSubTotal := 0
nTotal := ntotal2 := 0
//While !Eof() .And. SUBS(SA1->A1_NOME,1,30) >= mv_par03 .AND. SUBS(SA1->A1_NOME,1,30) <= mv_par04
While !Eof() .And. Trim(SA1->A1_NOME) >= Trim(mv_par03) .AND. Trim(SA1->A1_NOME) <= Trim(mv_par04)
   IF LastKey() == 286
     @Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
     Exit
   Endif
   DBSELECTAREA("SC5")
   DBSETORDER(3)
   dbSeek(xFilial("SC5")+SA1->A1_COD )
   dbselectarea("SC5")
   While !eof() .and. SC5->C5_CLIENTE == SA1->A1_COD 
            IF SC5->C5_XPVTIPO <> "OF" 
            SKIP
            LOOP
         ENDIF 
         IF SC5->C5_EMISSAO < MV_PAR01 .OR. SC5->C5_EMISSAO >MV_PAR02
            SKIP
            LOOP
         ENDIF
         DBSELECTAREA("SC6")
         DBSETORDER(1)
         dbSeek(xFilial("SC6")+SC5->C5_NUM )
         While !eof() .and. SC5->C5_NUM == SC6->C6_NUM
            if MV_PAR05 == 1
               IF EMPTY(SC6->C6_DATFAT) .OR. (SC6->C6_DATFAT < MV_PAR08 .OR. SC6->C6_DATFAT >MV_PAR09)
                  SKIP
                  LOOP
               ENDIF
            ENDIF
            IF MV_PAR05 = 2 .AND. (SC6->C6_QTDENT == SC6->C6_QTDVEN)
//                             IF (SC6->C6_QTDLIB == SC6->C6_QTDVEN) // .OR. !EMPTY(SC6->C6_NOTA))
                 SKIP             
                 LOOP                               
//                             ENDIF  
            ENDIF
            
            //If !GetMV("MV_XXINVDT")   tratado na segunda invesão
	         //   IF SC6->C6_ENTREG < MV_PAR06 .OR. SC6->C6_ENTREG > MV_PAR07  // Tratado
	         //      SKIP
	         //      LOOP
	         //   ENDIF
            //Else
	            IF SC6->C6_DTFATUR < MV_PAR06 .OR. SC6->C6_DTFATUR >MV_PAR07  // Tratado
	               SKIP
	               LOOP
	            ENDIF            
            //EndIf

dbselectarea(meutrab)
reclock(meutrab,.t.)

//               @ LI,00 PSAY SC5->C5_EMISSAO
		TB_EMISSAO := SC5->C5_EMISSAO
//               @ LI,09 PSAY SC5->C5_NUM
		TB_OF := SC5->C5_NUM
               IF !EMPTY(SC6->C6_NOTA)
//               @ LI,16 PSAY "S "+SC6->C6_NOTA
		TB_F_NF := "S "+SC6->C6_NOTA
               ENDIF
//               @ LI,25 PSAY SUBS(SA1->A1_NOME,1,30)
		TB_CLIENTE := SUBS(SA1->A1_NOME,1,30)
               dbSelectArea("SC2")
               dbSetOrder(6)
               dbSeek(xFilial("SC2")+SC6->C6_NUM )
//               dbSelectArea("SC6")
dbselectarea(meutrab)
//               @ LI,57 PSAY SC2->C2_NUM
		TB_OM := SC2->C2_NUM
//               @ LI,64 PSAY SC6->C6_PRODUTO
		TB_PRODUTO := SC6->C6_PRODUTO

// ALTERADO EM 20/11/2001, PARA CONTEMPLAR OS PEDIDOS ENTREGUES PARCIALMENTE.

               IF MV_PAR05 = 2
//                  @ LI,79 PSAY (SC6->C6_QTDVEN - SC6->C6_QTDENT) picture "@E 999,999.99"
		TB_QTD := SC6->C6_QTDVEN - SC6->C6_QTDENT
                  VALOR := ((SC6->C6_QTDVEN - SC6->C6_QTDENT) * SC6->C6_PRCVEN)
                  QTDE := (SC6->C6_QTDVEN - SC6->C6_QTDENT)
               ENDIF   
               IF MV_PAR05 = 1
//                  @ LI,79 PSAY SC6->C6_QTDENT picture "@E 999,999.99"
		TB_QTD := SC6->C6_QTDENT
                  VALOR := (SC6->C6_QTDENT * SC6->C6_PRCVEN)
                  QTDE := SC6->C6_QTDENT
               ENDIF
               IF MV_PAR05 = 3
//                  @ LI,79 PSAY SC6->C6_QTDVEN picture "@E 999,999.99"
		TB_QTD := SC6->C6_QTDVEN
                  VALOR := SC6->C6_VALOR//(SC6->C6_QTDVEN * SC6->C6_PRCVEN)
                  QTDE := SC6->C6_QTDVEN
               ENDIF

// FIM DA ALTERACAO.
                
//               @ LI,93  PSAY SC6->C6_PRCVEN picture "@E 999,999.99"
		TB_VALORS := SC6->C6_PRCVEN
//               @ LI,110 PSAY (SC6->C6_PRCVEN*((SC6->C6_IPI/100)+1)) picture "@E 999,999.99"
		TB_VALORC := SC6->C6_PRCVEN*((SC6->C6_IPI/100)+1)
//               @ LI,126 PSAY NoRound(VALOR*((SC6->C6_IPI/100)+1)) picture "@E 99999,999.99"
		TB_TOTAL := NoRound(VALOR*((SC6->C6_IPI/100)+1))

               IF VLTOT == 0
//                  @ LI,139 PSAY NoRound(VALOR*((SC6->C6_IPI/100)+1)) picture "@E 99999,999.99"
		TB_SUBTOT := NoRound(VALOR*((SC6->C6_IPI/100)+1))
               ELSE
//                  @ LI,139 PSAY VLTOT picture "@E 999999,999.99"
		TB_SUBTOT := VLTOT
               ENDIF

		If !GetMV("MV_XXINVDT")   // tratado na segunda inversão
		   //TB_FATURA := SC6->C6_DTFATUR  // Tratado
		   //TB_ENTREGA := SC6->C6_ENTREG
		   TB_FATURA := SC6->C6_ENTRE3   // Tratado
		   TB_ENTREGA := SC6->C6_DTFATUR
		Else
		   TB_FATURA := SC6->C6_ENTREG   // Tratado
		   TB_ENTREGA := SC6->C6_DTFATUR
		EndIf
//               @ LI,172 PSAY SUBS(SC5->C5_MENNOTA,1,30)
		TB_OBS := SUBS(SC5->C5_MENNOTA,1,30)
		
msunlock()
dbskip()

//               If li > 58
//                  cabec(titulo,cabec1,cabec2,wnrel,Tamanho)
//               EndIf
//
//               LI := LI + 1

//            ENDIF

                  nTotal := nTotal + NoRound(VALOR*((SC6->C6_IPI/100)+1))
            nSubTotal := nSubTotal + NoRound(VALOR*((SC6->C6_IPI/100)+1))
                    VLTOT := VLTOT + NoRound(VALOR*((SC6->C6_IPI/100)+1))

            Media  := QTDE + MEDIA
            QTDTOT := SC6->C6_QTDVEN + QTDTOT
            DBSELECTAREA("SC6")
            SKIP
         ENDDO
         DBSELECTAREA("SC5")
         SKIP
   ENDDO
/*   if nsubtotal >0
      li := li + 1
      @ li,10 psay "Total do cliente : " + SA1->A1_NOME
      @ li,110 PSAY nsubtotal  PICTURE "@E 99,999,999,999.99"
      ntotal2 := ntotal2 + nsubtotal
      nsubtotal := 0
      li := li + 2
   endif*/
   DBSELECTAREA("SA1")
   SKIP
   IncRegua()
ENDDO
dbselectarea(meutrab)
dbgotop()
while !eof()
  @ LI,00 PSAY TB_EMISSAO
  @ LI,09 PSAY TB_OF
  @ LI,16 PSAY TB_F_NF
  @ LI,25 PSAY TB_CLIENTE
  @ LI,57 PSAY TB_OM
  @ LI,64 PSAY TB_PRODUTO
  @ LI,79 PSAY TB_QTD picture "@E 999,999.99"
  @ LI,93 PSAY TB_VALORS picture "@E 999,999.99"		
  @ LI,110 PSAY TB_VALORC picture "@E 999,999.99"
  @ LI,126 PSAY TB_TOTAL picture "@E 99999,999.99"
  @ LI,139 PSAY TB_SUBTOT picture "@E 99999,999.99"
  @ LI,153 PSAY TB_ENTREGA
  @ LI,163 PSAY TB_FATURA
  @ LI,172 PSAY TB_OBS
  If li > 58
    cabec(titulo,cabec1,cabec2,wnrel,Tamanho)
  EndIf
  LI := LI + 1  
  dbskip()
enddo
dbclosearea()
ferase(meutrab+".DBF")

LI := LI + 1
@ LI,010 PSAY "TOTAL GERAL -------------------------------->"
@ LI,072 PSAY QTDTOT PICTURE "@E 99,999,999,999.99" 
@ LI,110 PSAY nTotal PICTURE "@E 99,999,999,999.99"


// GERARDO (5/12) ****************************************

LI := LI + 5

PERIODO := (MEDIA/(((MV_PAR02-MV_PAR01)+1)/30))

//             01234567890123456789012345678901234567890
//             1         2         3         4         5
@ LI,010 PSAY "MEDIA MENSAL (NO PERIODO) --> "
@ LI,040 PSAY PERIODO PICTURE "@E 99,999,999.99"

LI := LI + 1
@ LI,010 PSAY MV_PAR01
@ LI,020 PSAY "ATE"
@ LI,025 PSAY MV_PAR02

//********************************************************

Eject


If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO DE IMPRESSAO DO CABECALHO - GERARDO 12/12/00      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Substituido pelo assistente de conversao do AP5 IDE em 30/07/01 ==> function impcab
Static function impcab()

   LI := 0
   @ LI,00 PSAY CHR(27) + "(s20H"       // comprimido HP DJ

   @ LI,00 PSAY "*"+Replicate("*",158)+"*"
   LI := LI + 1
   @ LI,00 PSAY "*"+PADC("Emissao de Listagem de Pedido do Cliente",160)
   @ LI,00 PSAY PADL("*",160)
   LI := LI + 1                                            
   @ LI,00 PSAY "*"+PADC("Domex Telecom",160)
   @ LI,00 PSAY PADL("*",160)
   LI := LI + 1
   @ LI,00 PSAY "*"+Replicate("*",158)+"*"
   LI := LI + 1
IF MV_PAR05 == 1
   WCABEC := "Emitidos entre "+ dtoc(mv_par01) + " a "+dtoc(mv_par02) + " - Faturados entre " + dtoc(mv_par10) + " a "+dtoc(mv_par11) + " - Entregues entre " + dtoc(mv_par06) + " a "+dtoc(mv_par07)
ELSEIF MV_PAR05 == 2
   WCABEC := "Emitidos entre "+ dtoc(mv_par01) + " a "+dtoc(mv_par02) + " - NAO Faturados entre " + dtoc(mv_par10) + " a "+dtoc(mv_par11) + " - Entregues entre " + dtoc(mv_par06) + " a "+dtoc(mv_par07)
ELSE   
   WCABEC := "Emitidos entre "+ dtoc(mv_par01) + " a "+dtoc(mv_par02) + " - Faturados e Nao Faturados entre " + dtoc(mv_par10) + " a "+dtoc(mv_par11) + " - Entregues entre " + dtoc(mv_par06) + " a "+ dtoc(mv_par07)
endif

//   @ LI,00 PSAY WCABEC   // "Emitidos entre "+ dtoc(MV_PAR01) + " a "+dtoc(MV_PAR02) + " - Faturados entre " + dtoc(MV_PAR08) + " a "+dtoc(MV_PAR09) + " - Entregues entre " + dtoc(MV_PAR06) + " a "+dtoc(MV_PAR07)

   LI := LI + 1
   @ LI,00 PSAY "EMISSAO   OF    F NF     CLIENTE                         O.M.   PRODUTO               QTD     VALOR S/ IPI     VALOR C/ IMPOSTOS     TOTAL     SUB.TOTAL  ENTREGA  FATURA  OBSERVACAO"
   LI := LI + 1
   @ LI,00 PSAY "*"+Replicate("*",158)+"*"
   LI := LI + 1


//CABEC2 := "EMISSAO   OF    F NF      CLIENTE                          O.M.    PRODUTO              QTD        VALOR       TOTAL   SUB.TOT.CLIE  ENTREGA     PREV.FATUR  OBSERVACAO"
//CABEC1 := "Emitidos entre "+ dtoc(mv_par01) + " a "+dtoc(mv_par02) + " - Faturados entre " + dtoc(mv_par08) + " a "+dtoc(mv_par09) + " - Entregues entre " + dtoc(mv_par06) + " a "+dtoc(mv_par07)

Return     


// ************************************************************

// Substituido pelo assistente de conversao do AP5 IDE em 30/07/01 ==> Function ValidPerg
Static Function ValidPerg()
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := "RELFAT"
cPerg			 :=LEFT(cPerg+SPACE(10),10)
aRegs:={}
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
//AADD(aRegs,{cPerg,"10","Analitico/Sintetico ","mv_cha","C",1,0,0,"G","","mv_par10","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"02","Ate Emissao  Pedido?","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"03","Do Nome Cliente    ?","mv_ch3","C",15,0,0,"G","","mv_par03","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"04","Ate Nome Cliente   ?","mv_ch4","C",15,0,0,"G","","mv_par04","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"05","Faturados/Nao/Ambos?","mv_ch5","C",1,0,0,"G","","mv_par05","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"06","Da Entrega do Prod. ","mv_ch6","D",8,0,0,"G","","mv_par06","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"07","Ate Entrega  Prod.  ","mv_ch7","D",8,0,0,"G","","mv_par07","","","","","","","","","","","","","",""})

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
