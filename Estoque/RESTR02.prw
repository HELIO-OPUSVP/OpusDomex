#INCLUDE "rwmake.ch"
#include "totvs.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RESTR02   º Autor ³ Helio Ferreira     º Data ³  19/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de conferência entre contagens de inventários    º±±
±±º          ³ Domex (inventários feitos pelo coletor de dados)           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RESTR02()

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo         := "Conferência entre contagens de inventário Domex"
Local nLin           := 80

Local Cabec1         := "PRODUTO         ALM  LOCALIZ          PECA"+Space(60)+"           CONTAGEM 001      CONTAGEM 002      CONTAGEM 003      CONTAGEM 004      CONTAGEM 005      CONTAGEM 006      STATUS"
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RESTR02"
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "RESTR02"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RESTR02"
Private cString      := ""

Private aQtdConta    := {0,0,0,0,0,0,0,0,0,0}

Private cCont1       := "001"
Private cCont2       := "002"
Private cCont3       := "003"
Private cCont4       := "004"
Private cCont5       := "005"
Private cCont6       := "006"
Private cCont7       := "007"
Private cCont8       := "008"
Private cCont9       := "009"
Private cCont10      := "010"

Private nSkipCol     := 18
Private nCont1       := 55
Private nCont2       := nCont1 + nSkipCol
Private nCont3       := nCont2 + nSkipCol

Private cMasc        := "@E 999,999.99"

Private aLinProd     := {}

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

RptStatus({|lAbortPrint| RunReport(Cabec1,Cabec2,Titulo,nLin,@lAbortPrint) },Titulo)

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

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,lAbortPrint)

Local nOrdem

cQuery := "SELECT * FROM " + RetSqlName("SZC") + " "
cQuery += "WHERE ZC_DATAINV >= '"+DtoS(mv_par01)+"' AND ZC_DATAINV <= '"+DtoS(mv_par02)+"' "
cQuery += "AND ZC_PRODUTO >= '"+mv_par03+"' AND ZC_PRODUTO <= '"+mv_par04+"' AND ZC_LOCAL >= '"+mv_par05+"' AND ZC_LOCAL <= '"+mv_par06+"' "
cQuery += "AND D_E_L_E_T_ = '' AND ZC_FILIAL = '"+xFilial("SZC")+"' "
cQuery += "ORDER BY ZC_PRODUTO, ZC_LOCAL, ZC_XXPECA, ZC_LOCALIZ, ZC_CONTAGE "

If Select("QUERYSZC") <> 0
	QUERYSZC->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYSZC"

nContagem := 0
While !QUERYSZC->( EOF() )
	nContagem += 1
	QUERYSZC->( dbSkip() )
End

QUERYSZC->( dbGoTop() )

ProcRegua(nContagem)

cProLoLocPC := ""

While !QUERYSZC->( EOF() )
	If mv_par10 == 1
		cQuery := "SELECT ZC_PRODUTO, ZC_CONTAGE FROM " + RetSqlName("SZC") + " "
		cQuery += "WHERE ZC_DATAINV >= '"+DtoS(mv_par01)+"' AND ZC_DATAINV <= '"+DtoS(mv_par02)+"' "
		cQuery += "AND ZC_PRODUTO = '"+QUERYSZC->ZC_PRODUTO+"' AND ZC_LOCAL >= '"+mv_par05+"' AND ZC_LOCAL <= '"+mv_par06+"' "
		cQuery += "AND D_E_L_E_T_ = '' AND ZC_FILIAL = '"+xFilial("SZC")+"' "
		cQuery += "GROUP BY ZC_PRODUTO, ZC_CONTAGE "
		
		If Select("TEMP") <> 0
			TEMP->( dbCloseArea() )
		EndIf
		
		TCQUERY cQuery NEW ALIAS "TEMP"
		
		nTemp := 0
		While !TEMP->( EOF() )
			nTemp++
			TEMP->( dbSkip() )
		End
		
		If nTemp <= 1
			QUERYSZC->( dbSkip() )
			Loop
		EndIf
	EndIf
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If cProLoLocPC <> QUERYSZC->ZC_PRODUTO + QUERYSZC->ZC_LOCAL + QUERYSZC->ZC_LOCALIZ + QUERYSZC->ZC_XXPECA
		If nLin > 55
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		cProLoLocPC := QUERYSZC->ZC_PRODUTO + QUERYSZC->ZC_LOCAL + QUERYSZC->ZC_LOCALIZ + QUERYSZC->ZC_XXPECA
		cPeca       := ""
		//nLin ++
		//@ nLin, 000        pSay "Produto: "  + QUERYSZC->ZC_PRODUTO
		//@ nLin, pCol() + 2 pSay "Desc:"      + Posicione("SB1",1,xFilial("SB1")+QUERYSZC->ZC_PRODUTO,"B1_DESC")
		//@ nLin, pCol() + 2 pSay "Local: "    + QUERYSZC->ZC_LOCAL
		//@ nLin, pCol() + 2 pSay "Endereço: " + QUERYSZC->ZC_LOCALIZ
		//@ nLin, pCol() + 2 pSay "Endereço: " + QUERYSZC->ZC_XXPECA
		
		//@ nLin, 000        pSay QUERYSZC->ZC_PRODUTO
		//@ nLin, pCol() + 2 pSay QUERYSZC->ZC_LOCAL
		//@ nLin, pCol() + 2 pSay QUERYSZC->ZC_LOCALIZ
		//@ nLin, pCol() + 2 pSay QUERYSZC->ZC_XXPECA
		
		cLinha     := QUERYSZC->ZC_PRODUTO + Space(2) + QUERYSZC->ZC_LOCAL + Space(2) + QUERYSZC->ZC_LOCALIZ + Space(2) + QUERYSZC->ZC_XXPECA + Posicione("SB1",1,xFilial("SB1")+QUERYSZC->ZC_PRODUTO,"B1_DESC")
		cTxtCont1  := ""
		cTxtCont2  := ""
		cTxtCont3  := ""
		cTxtCont4  := ""
		cTxtCont5  := ""
		cTxtCont6  := ""
		cTxtCont7  := ""
		cTxtCont8  := ""
		cTxtCont9  := ""
		cTxtCont10 := ""
		
		aQtdConta  := {0,0,0,0,0,0,0,0,0,0}
	EndIf
	
	If QUERYSZC->ZC_CONTAGE == cCont1
		cTxtCont1 := Space(2) + Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)
		aQtdConta[1] := QUERYSZC->ZC_QUANT
	EndIf
	
	If QUERYSZC->ZC_CONTAGE == cCont2
		If Empty(cTxtCont1)
			cTxtCont1 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		cTxtCont2 := Space(2) + Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)
		
		aQtdConta[2] := QUERYSZC->ZC_QUANT
	EndIf
	
	If QUERYSZC->ZC_CONTAGE == cCont3
		If Empty(cTxtCont1)
			cTxtCont1 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont2)
			cTxtCont2 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		cTxtCont3 := Space(2) + Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)
		
		aQtdConta[3] := QUERYSZC->ZC_QUANT
	EndIf
	
	If QUERYSZC->ZC_CONTAGE == cCont4
		If Empty(cTxtCont1)
			cTxtCont1 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont2)
			cTxtCont2 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont3)
			cTxtCont3 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		cTxtCont4 := Space(2) + Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)
		
		aQtdConta[4] := QUERYSZC->ZC_QUANT
	EndIf
	
	If QUERYSZC->ZC_CONTAGE == cCont5
		If Empty(cTxtCont1)
			cTxtCont1 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont2)
			cTxtCont2 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont3)
			cTxtCont3 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont4)
			cTxtCont4 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		
		aQtdConta[5] := QUERYSZC->ZC_QUANT
		
	EndIf
	
	If QUERYSZC->ZC_CONTAGE == cCont6
		If Empty(cTxtCont1)
			cTxtCont1 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont2)
			cTxtCont2 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont3)
			cTxtCont3 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont4)
			cTxtCont4 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont5)
			cTxtCont5 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		
		aQtdConta[6] := QUERYSZC->ZC_QUANT
		
	EndIf
	
	If QUERYSZC->ZC_CONTAGE == cCont7
		If Empty(cTxtCont1)
			cTxtCont1 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont2)
			cTxtCont2 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont3)
			cTxtCont3 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont4)
			cTxtCont4 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont5)
			cTxtCont5 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont6)
			cTxtCont6 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		
		aQtdConta[7] := QUERYSZC->ZC_QUANT
		
	EndIf
	
	If QUERYSZC->ZC_CONTAGE == cCont8
		If Empty(cTxtCont1)
			cTxtCont1 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont2)
			cTxtCont2 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont3)
			cTxtCont3 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont4)
			cTxtCont4 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont5)
			cTxtCont5 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont6)
			cTxtCont6 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont7)
			cTxtCont7 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		
		aQtdConta[8] := QUERYSZC->ZC_QUANT
	EndIf
	
	If QUERYSZC->ZC_CONTAGE == cCont9
		If Empty(cTxtCont1)
			cTxtCont1 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont2)
			cTxtCont2 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont3)
			cTxtCont3 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont4)
			cTxtCont4 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont5)
			cTxtCont5 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont6)
			cTxtCont6 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont7)
			cTxtCont7 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont8)
			cTxtCont8 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		
		aQtdConta[9] := QUERYSZC->ZC_QUANT
		
	EndIf
	
	If QUERYSZC->ZC_CONTAGE == cCont10
		If Empty(cTxtCont1)
			cTxtCont1 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont2)
			cTxtCont2 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont3)
			cTxtCont3 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont4)
			cTxtCont4 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont5)
			cTxtCont5 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont6)
			cTxtCont6 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont7)
			cTxtCont7 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont8)
			cTxtCont8 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		If Empty(cTxtCont9)
			cTxtCont9 := Space(2) + Space(Len(Subs(QUERYSZC->ZC_USUARIO,1,5)+ ':' + Transform(QUERYSZC->ZC_QUANT,cMasc)))
		EndIf
		
		aQtdConta[10] := QUERYSZC->ZC_QUANT
	EndIf
	
	QUERYSZC->( dbSkip() )
	
	If cProLoLocPC <> QUERYSZC->ZC_PRODUTO + QUERYSZC->ZC_LOCAL + QUERYSZC->ZC_LOCALIZ + QUERYSZC->ZC_XXPECA
		
		cQuery := "SELECT MAX(ZC_CONTAGE) AS MAXCONT FROM " + RetSqlName("SZC") + " "
		cQuery += "WHERE ZC_DATAINV >= '"+DtoS(mv_par01)+"' AND ZC_DATAINV <= '"+DtoS(mv_par02)+"' "
		cQuery += "AND ZC_PRODUTO = '"+Subs(cProLoLocPC,1,15)+"' AND ZC_LOCAL >= '"+mv_par05+"' AND ZC_LOCAL <= '"+mv_par06+"' "
		cQuery += "AND D_E_L_E_T_ = '' AND ZC_FILIAL = '"+xFilial("SZC")+"' "
		cQuery += "GROUP BY ZC_PRODUTO "
		
		If Select("TEMP2") <> 0
			TEMP2->( dbCloseArea() )
		EndIf
		
		TCQUERY cQuery NEW ALIAS "TEMP2"
		
		cStatus := "ERRO"
		//If Len(aQtdConta) == Val(TEMP2->MAXCONT)
		For x := 1 to (Val(TEMP2->MAXCONT)-1) //(Len(aQtdConta))
			//If x <> Val(TEMP2->MAXCONT)
				//If aQtdConta[x] <> 0 .and. aQtdConta[Val(TEMP2->MAXCONT)] <> 0
					If aQtdConta[x] == aQtdConta[Val(TEMP2->MAXCONT)]
						cStatus := "OK"
						Exit
					EndIf
				//EndIf
			//EndIf
		Next x
		//EndIf
		//@ nLin, 120 pSay cStatus
		
		cLinha     := cLinha + cTxtCont1 + cTxtCont2 + cTxtCont3 + cTxtCont4 + cTxtCont5 + cTxtCont6 + cTxtCont7 + cTxtCont8 + cTxtCont9 + cTxtCont10
		cLinha     := cLinha + Space(210-Len(cLinha)) + cStatus
		
		AADD(aLinProd,cLinha)
		
		If Subs(cProLoLocPC,1,15) <> QUERYSZC->ZC_PRODUTO  // Mudou de Produto
			lProdOK := .T.
			For x := 1 to Len(aLinProd)
				If Subs(aLinProd[x],Len(aLinProd[x])-3) == "ERRO"
					lProdOK := .F.
					Exit
				EndIf
			Next x
			
			If mv_par07 == 3 .or. (mv_par07 == 1 .and. lProdOK) .or. (mv_par07 == 2 .and. !lProdOK)   //1 = Somente OK, 2 = Somente erros, 3 = Todos
				If mv_par08 == 1
					@ nLin,000 pSay __PrtThinLine()
					nLin++
				EndIf
				
				cEnderecos := ''
				
				For x := 1 to Len(aLinProd)
					If mv_par08 == 1  // Analitico
						@ nLin, 000 pSay aLinProd[x]
						nLin++
					EndIf
					If nLin > 55
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						nLin := 8
					Endif
					If !(Alltrim(Subs(aLinProd[x],22,10)) $ cEnderecos)
						cEnderecos += Alltrim(Subs(aLinProd[x],22,10))+'/'
					EndIf
				Next x
				
				If mv_par08 == 2 .or. mv_par09 == 1  // mv_par08-Analitico/Sintetico, mv_par09-indica em quais endereços o produto foi encontrado para facilitar próxima contagem
					@ nLin,000 pSay __PrtThinLine()
					nLin++
					If lProdOK
						@ nLin, 000 pSay "OK   " + Subs(aLinProd[1],1,15) + '  Endereços: ' + cEnderecos
					Else
						@ nLin, 000 pSay "ERRO " + Subs(aLinProd[1],1,15) + '  Endereços: ' + cEnderecos
					EndIf
					nLin++
				EndIf
			EndIf
			aLinProd := {}
			
		EndIf
		
	EndIf
	
	IncProc()
End

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
