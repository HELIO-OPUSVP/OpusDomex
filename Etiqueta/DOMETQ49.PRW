#include "protheus.ch"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DOMETQ49 �Autor  � RICARDO RODA       � Data �  18.02.2022 ���
�������������������������������������������������������������������������͹��
���Desc.     �      Etiqueta padr�o v-tal n�vel 3 Expedi��o              ���
���          �                       PADR�O ZEBRA                         ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DOMETQ49(cEtqOp, cEtqProd, cEtqPed, nEtqQtd, dDataFab, lControl, cNfDanfe, nPesoDanfe,nQtdEmb,cLocImp)

PRIVATE cChvDanfe  := SPACE(44)
PRIVATE nOpcDanfe  := 0
PRIVATE nVolDanfe  := 0
PRIVATE oTelaDanfe
PRIVATE cPedDanfe  := ""
PRIVATE cSemana    := ""
PRIVATE cTransp    := ""
default cLocImp   := ""
			

ImpEtqOi(@cEtqOp, @cEtqProd, @cEtqPed, @nEtqQtd, @dDataFab, @lControl, @cNfDanfe, @nPesoDanfe,nQtdEmb,cLocImp)

Return


Static Function ImpEtqOi(cEtqOp, cEtqProd, cEtqPed, nEtqQtd, dDataFab, lControl, cNfDanfe, nPesoDanfe,nQtdEmb,cLocImp)

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
If Type("cOiDl32_CancOP") <> "U"
	
	cOiDl32_CancOP     := cEtqOp
	cOiDl33_CancPro    := cEtqProd
	cOiDl34_CancPed    := cEtqPed
	cOiDl35_CancUni    := nEtqQtd
	cOiDl38_CancDat    := dDataFab
    cOiDl39_CancQtd    := nQtdEmb 	
EndIf

//�����������������������������������������������x�[�
//�Busca a semana do ano corrente						 �
//�����������������������������������������������x�[�
cSQL    := "SELECT dbo.SemanaProtheus() AS SEMANA"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"WEEK",.F.,.T.)
cSemana := WEEK->SEMANA
cYY     := SUBSTR(cSemana,3,2)
cWW     := StrZero(Val(SubStr(cSemana,5,2)),2)
cSemana := cWW+"/"+cYY
WEEK->(dbCloseArea())

//�����������������������������������������������x�[�
//�Posiciona no Pedido										 �
//�����������������������������������������������x�[�
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
   
//�����������������������������������������������x�[�
//�Busca codigo ANATEL										 �
//�����������������������������������������������x�[�
aRetAnat := fCodNat(SB1->B1_COD)
lAchou   := aRetAnat[1]
aCodAnat := aRetAnat[2]
aGrpAnat := {}

//�����������������������������������������������x�[�
//�Agrupando ANATEL											 �
//�����������������������������������������������x�[�
For x:=1 To Len(aCodAnat)
	nVar := aScan(aGrpAnat,aCodAnat[x])
	If nVar == 0
		aAdd(aGrpAnat,aCodAnat[x])
	EndIf
Next x

//�����������������������������������������������x�[�
//�Separando codigos ANATEL								 �
//�����������������������������������������������x�[�
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

			//�����������������������������������������������x�[�
			//�Executa IMPRESS�O NA ZEBRA			         	 �
			//�����������������������������������������������x�[�

			cPrn         := "DOMETQ49.prn"
			aVar         := aVar
			cVetor      := "!aVar"
			lTemperatura := .F.
			U_IMPPRN(cLocImp,cPrn,aVar,cVetor,lTemperatura)

RestArea( cAliasSB1 )
RestArea( cAliasSC2 )

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fCodNat  �Autor  � Felipe Melo        � Data �  16/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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



Static Function fButtCel()

Local oButton1
Local oButton2
Local oButton3
Local oButton4
Local oButton5
Local oButton6
Local oButton7
Local oButton8
Local oButton9
Local cCel:= ""
Local cCSSBtN1 :="QPushButton{background-color: #f6f7fa; color: #707070; font: bold 22px Arial; }"+;
		"QPushButton:pressed {background-color: #50b4b4; color: white; font: bold 22px  Arial; }"+;
		"QPushButton:hover {background-color: #878787 ; color: white; font: bold 22px  Arial; }"

Static oDlg


  DEFINE MSDIALOG oDlg TITLE "Escolha a sua c�lula de trabalho" FROM 000, 000  TO 300, 300 COLORS 0, 16777215 PIXEL

    @ 010, 018 BUTTON oButton1 PROMPT "DIO 1" SIZE 119, 043 OF oDlg ACTION (cCel := "DIO 1", oDlg:end() ) PIXEL
	oButton1:setCSS(cCSSBtN1)
 	@ 069, 018 BUTTON oButton2 PROMPT "DIO 2" SIZE 119, 043 OF oDlg ACTION (cCel := "DIO 2", oDlg:end() ) PIXEL
	oButton2:setCSS(cCSSBtN1)    
	
  ACTIVATE MSDIALOG oDlg CENTERED    

Return cCel


Static Function fLocImp(cCel)
Local cQuery:= ""
Local cFila	:= ""

IF SELECT ("QCB5") > 0 
	QCB5->(DBCLOSEAREA())
ENDIF

cQuery:= " SELECT TOP 1 CB5_CODIGO FROM CB5010 "
cQuery+= " WHERE CB5_DESCRI = '"+cCel+"'  "
cQuery+= " AND D_E_L_E_T_ = '' "
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QCB5",.T.,.T.)
	
IF QCB5->(!EOF())
	cFila := QCB5->CB5_CODIGO
else
	Msginfo("Local de impress�o "+cCel+" n�o identificado", "aviso")
ENDIF

IF SELECT ("QCB5") > 0 
	QCB5->(DBCLOSEAREA())
ENDIF

Return cFila
