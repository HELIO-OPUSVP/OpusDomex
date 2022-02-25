#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMETQ49 ºAutor  ³ RICARDO RODA       º Data ³  18.02.2022 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³      Etiqueta padrão v-tal nível 3 Expedição              º±±
±±º          ³                       PADRÃO ZEBRA                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMETQ49(cEtqOp, cEtqProd, cEtqPed, nEtqQtd, dDataFab, lControl, cNfDanfe, nPesoDanfe)

PRIVATE cChvDanfe  := SPACE(44)
PRIVATE nOpcDanfe  := 0
PRIVATE nVolDanfe  := 0
PRIVATE oTelaDanfe
PRIVATE cPedDanfe  := ""
PRIVATE cSemana    := ""
PRIVATE cTransp    := ""

ImpEtqOi(@cEtqOp, @cEtqProd, @cEtqPed, @nEtqQtd, @dDataFab, @lControl, @cNfDanfe, @nPesoDanfe)

Return


Static Function ImpEtqOi(cEtqOp, cEtqProd, cEtqPed, nEtqQtd, dDataFab, lControl, cNfDanfe, nPesoDanfe)

LOCAL cAliasSB1   := SB1->(GetArea())
LOCAL cAliasSC2   := SC2->(GetArea())
LOCAL cModPrinter := "Z4M"
LOCAL lPrinOK     := MSCBModelo("ZPL",cModPrinter)
LOCAL cFila       := ""
LOCAL _aArq       := {}
LOCAL aCodEtq     := {}
LOCAL cUserSis	  := Upper(Alltrim(Substr(cUsuario,7,15)))
LOCAL cCdAnat1    := ""
LOCAL cCdAnat2    := ""
LOCAL cCdAnat3    := ""
LOCAL cDanfe      := ""
LOCAL cSerie      := ""
Local cInfDanfe	  := ""
local x

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
//³Busca a semana do ano corrente						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
cSQL    := "SELECT dbo.SemanaProtheus() AS SEMANA"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"WEEK",.F.,.T.)
cSemana := WEEK->SEMANA
cYY     := SUBSTR(cSemana,3,2)
cWW     := StrZero(Val(SubStr(cSemana,5,2)),2)
cSemana := cWW+"/"+cYY
WEEK->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
//³Posiciona no Pedido										 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
SB1->(dbSetOrder(1))
SB1->(dbSeek( xFilial() + cEtqProd ))
cItemPed := SUBSTR(cEtqPed,7,2)
SC5->(dbSetOrder(1))
SC5->(dbSeek(xFilial() + Subs(cEtqPed,1,6) ))
SC6->(dbSetOrder(1))
SC6->(dbSeek(xFilial()+Subs(cEtqPed,1,6) + cItemPed))
SF2->(dbSetOrder(1))

If SF2->( dbSeek( SC6->C6_FILIAL + SC6->C6_NOTA + SC6->C6_SERIE + SC6->C6_CLI + SC6->C6_LOJA ))
   cDanfe  := SF2->F2_DOC
   cSerie  := SF2->F2_SERIE
   cInfDanfe := cDanfe+" SERIE "+cSerie
EndIF
   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
//³Busca codigo ANATEL										 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
aRetAnat := fCodNat(SB1->B1_COD)
lAchou   := aRetAnat[1]
aCodAnat := aRetAnat[2]
aGrpAnat := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
//³Agrupando ANATEL											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
For x:=1 To Len(aCodAnat)
	nVar := aScan(aGrpAnat,aCodAnat[x])
	If nVar == 0
		aAdd(aGrpAnat,aCodAnat[x])
	EndIf
Next x

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
//³Separando codigos ANATEL								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
If ALLTRIM(SB1->B1_TIPO) == 'PR'
	
	If Val(SB1->B1_XXNANAT) == 0
		cCdAnat1 := ""
		cCdAnat2 := ""
	ElseIf Val(SB1->B1_XXNANAT) == 1
		cCdAnat1 := SB1->B1_XXANAT1
		cCdAnat2 := ""
	ElseIf Val(SB1->B1_XXNANAT) == 2
		cCdAnat1 := SB1->B1_XXANAT1
		cCdAnat2 := SB1->B1_XXANAT1
	ElseIf Val(SB1->B1_XXNANAT) == 3
		cCdAnat1 := SB1->B1_XXANAT1
		cCdAnat2 := SB1->B1_XXANAT2
		cCdAnat3 := SB1->B1_XXANAT3
	Else
		cCdAnat1 := ""
		cCdAnat2 := ""
	EndIf
	
Else
	
	If Val(SB1->B1_XXNANAT) == 0 .And. Len(aGrpAnat) == 0
		cCdAnat1 := ""
		cCdAnat2 := ""
	ElseIf Val(SB1->B1_XXNANAT) == 1 .And. Len(aGrpAnat) == 1
		cCdAnat1 := aGrpAnat[1]
		cCdAnat2 := ""
	ElseIf Val(SB1->B1_XXNANAT) == 2 .And. Len(aGrpAnat) == 1
		cCdAnat1 := aGrpAnat[1]
		cCdAnat2 := aGrpAnat[1]
	ElseIf Val(SB1->B1_XXNANAT) == 3 .And. Len(aGrpAnat) == 2
		cCdAnat1 := aGrpAnat[1]
		cCdAnat2 := aGrpAnat[2]
	ElseIf Val(SB1->B1_XXNANAT) == 3 .And. Len(aGrpAnat) == 1
		cCdAnat1 := aGrpAnat[1]
		cCdAnat2 := aGrpAnat[1]
	Else
		cCdAnat1 := ""
		cCdAnat2 := ""
	EndIf
	
EndIf

cVar1:= SC6->C6_SEUCOD
cVar2:= SubStr(SC6->C6_DESCRI,1,20)
cVar3:= TransForm(nEtqQtd,"@E 999,999.99")
//cVar4:= SC5->C5_ESP1
//cVar4:= cInfDanfe
cVar4:= cSemana
cVar5:= TransForm(nPesoDanfe,"@E 999,999.99")
cVar6:= cCdAnat1+" "+cCdAnat2+" "+cCdAnat3

			aVar:={}
			AADD(aVar,cVar1)
			AADD(aVar,cVar2)
			AADD(aVar,cVar3)
			AADD(aVar,cVar4)
			AADD(aVar,cVar5)
			AADD(aVar,cVar6)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
			//³Executa IMPRESSÃO NA ZEBRA			         	 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿

			cLocImp      := ""
			cPrn         := "DOMETQ49.prn"
			aVar         := aVar
			cVetor      := "!aVar"
			lTemperatura := .F.
			U_IMPPRN(cLocImp,cPrn,aVar,cVetor,lTemperatura)

RestArea( cAliasSB1 )
RestArea( cAliasSC2 )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fCodNat  ºAutor  ³ Felipe Melo        º Data ³  16/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fCodNat(cCodProd)

Local aRet     := {}
Local aAreaSB1 := SB1->(GetArea())
Local aAreaSG1 := SG1->(GetArea())

SB1->(DbSetOrder(1))
SG1->(DbSetOrder(1))

If SG1->(DbSeek(xFilial("SG1")+cCodProd))
	While SG1->(!Eof()) .And. AllTrim(cCodProd) == AllTrim(SG1->G1_COD)
		If SB1->(DbSeek(xFilial("SB1")+SG1->G1_COMP)) .And. !Empty(SB1->B1_XXANAT1)
			aAdd(aRet,SB1->B1_XXANAT1)
		EndIf
		SG1->(DbSkip())
	End
EndIf

RestArea(aAreaSB1)
RestArea(aAreaSG1)

Return({.T.,aRet})
