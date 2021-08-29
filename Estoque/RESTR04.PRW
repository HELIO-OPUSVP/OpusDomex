#INCLUDE "rwmake.ch"
#include "totvs.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RESTR04   º Autor ³ AP6 IDE            º Data ³  16/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina/Relatorio de validação do fechamento de Estoque     º±±
±±º          ³ Desenvolvido com Luciano para verificação fechamento 10/2016±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ DOMEX                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RESTR04()

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo         := "AVALIAÇÃO FECHAMENTO"
Local nLin           := 80

Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RESTR04"
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "RESTR04"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RESTR04"
Private cString      := ""

pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  16/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

cQuery := "SELECT D3_COD, D3_OP "
cQuery += "FROM "+RetSqlName("SD3")+" WHERE D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' AND "
cQuery += "D3_OP >= '"+mv_par05+"' AND D3_OP <= '"+mv_par06+"' AND D3_COD >= '"+mv_par03+"' AND D3_COD <= '"+mv_par04+"' AND "
cQuery += "D3_CF LIKE 'PR%' AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
cQuery += "GROUP BY D3_COD, D3_OP "
cQuery += "ORDER BY D3_COD, D3_OP "

If Select("QUERYOP") <> 0
	QUERYOP->( dbCloseArea() )
EndIf

nReg := 0

TCQUERY cQuery NEW ALIAS "QUERYOP"

QUERYOP->( dbEval({||nReg++}) )

SetRegua(nReg)

QUERYOP->( dbGoTop() )

nTotDiferenca := 0

While !QUERYOP->( EOF() )
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	// Entradas das OP
	cQuery1 := "SELECT SUM(D3_CUSTO1) AS D3_CUSTO1 FROM "+RetSqlName("SD3")+" WHERE D3_OP = '"+QUERYOP->D3_OP+"' AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND "
	cQuery1 += "D3_EMISSAO <= '"+DtoS(mv_par02)+"' AND D3_TM < '500' AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
	
	If Select("QUERY_ENTRADAS") <> 0
		QUERY_ENTRADAS->( dbCloseArea() )
	EndIf
	
	TCQUERY cQuery1 NEW ALIAS "QUERY_ENTRADAS"
	
	// Saídas da OP
	cQuery2 := "SELECT SUM(D3_CUSTO1) AS D3_CUSTO1 FROM "+RetSqlName("SD3")+" WHERE D3_OP = '"+QUERYOP->D3_OP+"' AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND "
	cQuery2 += "D3_EMISSAO <= '"+DtoS(mv_par02)+"' AND D3_TM > '500' AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
	
	If Select("QUERY_SAIDAS") <> 0
		QUERY_SAIDAS->( dbCloseArea() )
	EndIf
	
	TCQUERY cQuery2 NEW ALIAS "QUERY_SAIDAS"
	
	If QUERY_ENTRADAS->D3_CUSTO1 == QUERY_SAIDAS->D3_CUSTO1
		//@ nLin,030 pSay "OK   " + QUERYOP->D3_COD + Space(10) + QUERYOP->D3_OP + Space(10) + Transform(QUERY_ENTRADAS->D3_CUSTO1,"@E 999,999,999.9999")
		//nLin++
	Else
		If (QUERY_ENTRADAS->D3_CUSTO1-QUERY_SAIDAS->D3_CUSTO1) >= 1 .OR. (QUERY_ENTRADAS->D3_CUSTO1-QUERY_SAIDAS->D3_CUSTO1) <= (-1)
			@ nLin,030 pSay "ER   " + QUERYOP->D3_COD + Space(10) + QUERYOP->D3_OP + Space(10) + Transform(QUERY_ENTRADAS->D3_CUSTO1,"@E 999,999,999.9999") + Space(10) + Transform(QUERY_SAIDAS->D3_CUSTO1,"@E 999,999,999.9999")  + Space(10) + "Diferença: " + Transform(QUERY_ENTRADAS->D3_CUSTO1-QUERY_SAIDAS->D3_CUSTO1,"@E 999,999,999.9999")
			nTotDiferenca += (QUERY_ENTRADAS->D3_CUSTO1-QUERY_SAIDAS->D3_CUSTO1)
			nLin++
		EndIf
	EndIf
	
	QUERYOP->( dbSkip() )
	IncRegua()
End

nLin++

@ nLin,000 pSay "TOTAL DIFERENÇA: " + Transform(nTotDiferenca,"@E 999,999,999.9999")

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
