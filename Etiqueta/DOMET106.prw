#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMET106 ºAutor  ³ Michel A. Sander   º Data ³  28.05.2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Etiqueta padrão OI S/A nível 2					              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Executado pela DOMETDL3 e via Menu                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DOMET106(cEtqOp, cEtqProd, cEtqPed, nEtqQtd, dDataFab, lControl, cNfDanfe, nPesoDanfe, nQtdProd, cfila)

PRIVATE cChvDanfe  := SPACE(44)
PRIVATE nOpcDanfe  := 0
PRIVATE nVolDanfe  := 0
PRIVATE oTelaDanfe
PRIVATE cPedDanfe  := ""
PRIVATE cSemana    := ""
PRIVATE cTransp    := ""
Default cFila:= ""

if Empty(cFila) 
	cCelula:= fButtCel()
	cFila:= fLocImp(cCelula)
Endif

ImpEtqOi(@cEtqOp, @cEtqProd, @cEtqPed, @nEtqQtd, @dDataFab, @lControl, @cNfDanfe, @nPesoDanfe, @nQtdProd, cfila)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ImpEtqOi ºAutor  ³ Michel A. Sander   º Data ³  28.05.2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime etiqueta padrão OI S/A				                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpEtqOi(cEtqOp, cEtqProd, cEtqPed, nEtqQtd, dDataFab, lControl, cNfDanfe, nPesoDanfe, nQtdProd, cFila)

LOCAL cAliasSB1   := SB1->(GetArea())
LOCAL cAliasSC2   := SC2->(GetArea())
LOCAL	cModPrinter := "Z4M"
LOCAL	lPrinOK     := MSCBModelo("ZPL",cModPrinter)
//LOCAL cFila 		:= ""
LOCAL _aArq       := {}
LOCAL aCodEtq     := {}
//LOCAL cUserSis		:= Upper(Alltrim(Substr(cUsuario,7,15)))
LOCAL	cCdAnat1    := ""
LOCAL	cCdAnat2    := ""
LOCAL	cCdAnat3    := ""

/*
If lControl
	cFila := SuperGetMv("MV_XFILEXP",.F.,"000005")
Else
	If cUserSis     == "CORD01 1T"
		cFila := "000006"
	ElseIf cUserSis == "CORD01 2T"
		cFila := "000006"
	ElseIf cUserSis == "CORD02 1T"
		cFila := "000007"
	ElseIf cUserSis == "CORD02 2T"
		cFila := "000007"
	ElseIf cUserSis == "CORD03 1T"
		cFila := "000008"
	ElseIf cUserSis == "CORD03 2T"
		cFila := "000008"
	ElseIf cUserSis == "CORD04 1T"
		cFila := "000009"
	ElseIf cUserSis == "CORD04 2T"
		cFila := "000009"
	ElseIf cUserSis == "CORD05 1T"
		cFila := "000011"
	ElseIf cUserSis == "CORD05 2T"
		cFila := "000011"
	ElseIf cUserSis == "EMBALAGEM DIO 1"
		cFila := "000012"
	ElseIf cUserSis == "EMBALAGEM DIO 2"
		cFila := "000012"
	ElseIf cUserSis == "EMB DROP 1T"     // Adicionado em 20/03/2019 por MAURESI
		cFila := "000013"
	ElseIf cUserSis == "EMB DROP 2T"     // Adicionado em 20/03/2019 por MAURESI
		cFila := "000013"
	ElseIf cUserSis == "CORD06 1T"
		cFila := "000015"
		cSD:= "21"
	ElseIf cUserSis == "CORD06 2T"
		cFila := "000015"
		cSD:= "21"
	ElseIf cUserSis == "TRUNK TERM 01"
		cFila := "000016"
	ElseIf cUserSis == "TRUNK TERM 02"
		cFila := "000016"
	ElseIf cUserSis == "TRUNK TERM 03"
		cFila := "000016"
	ElseIf cUserSis == "TRUNK TERM 04"
		cFila := "000016"
	ElseIf cUserSis == "TRUNK TERM 05"
		cFila := "000016"
	ElseIf cUserSis == "TRUNK TERM 06"
		cFila := "000016"
	ElseIf cUserSis == "TRUNK TERM 07"
		cFila := "000016"
	ElseIf cUserSis == "TRUNK TERM 08"
		cFila := "000016"
	ElseIf cUserSis == "TRUNK TERM 09"
		cFila := "000016"
	ElseIf cUserSis == "TRUNK TERM01"
		cFila := "000016"
	ElseIf cUserSis == "Karolyne"
		cFila := "000011"	
	ElseIf cUserSis == "CORTEDIO1"
		cFila := "000020"	
	EndIf

EndIf
*/

// Armazenando informacoes para um possivel cancelamento da etiqueta por falha na impressao
If Type("cOiDl32_CancOP") <> "U"
	
	cOiDl32_CancOP     := cEtqOp
	cOiDl33_CancPro    := cEtqProd
	cOiDl34_CancPed    := cEtqPed
	cOiDl35_CancUni    := nEtqQtd
	cOiDl38_CancDat    := dDataFab
   cOiDl39_CancQtd    := nQtdProd 	
EndIf

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
SB1->(dbSetOrder(1))
SB1->(dbSeek( xFilial() + cEtqProd ))
cItBusca := SUBSTR(cEtqOp,7,2)
SC5->(dbSetOrder(1))
SC5->(dbSeek(xFilial()+cEtqPed))
SC6->(dbSetOrder(1))
SC6->(dbSeek(xFilial()+cEtqPed+cItBusca))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
//³Busca codigo ANATEL										 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
aRetAnat := fCodNat(SB1->B1_COD)
lAchou   := aRetAnat[1]
aCodAnat := aRetAnat[2]
aGrpAnat := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
//³Agrupando ANATEL											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
For x:=1 To Len(aCodAnat)
	nVar := aScan(aGrpAnat,aCodAnat[x])
	If nVar == 0
		aAdd(aGrpAnat,aCodAnat[x])
	EndIf
Next x

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
//³Separando codigos ANATEL								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
If ALLTRIM(SB1->B1_TIPO) == 'PR'
	
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
//³Verifica peso do material								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
If nPesoDanfe == 0
   cDescPeso := "NA"
Else
   cDescPeso := AllTrim(TransForm(nPesoDanfe,"@E 999,999.99"))
EndIf
   
For nX := 1 to nEtqQtd

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	//³Verifica fila de impressão no ACD				 	 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	//cModPrinter := "Z4M"
	//lPrinOK     := MSCBModelo("ZPL",cModPrinter)
	If !CB5SetImp(cFila,.F.)
		MsgAlert("Fila de impressao inválida ou não conectada!","Etiqueta OI S/A")
		Return .F.
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	//³Monta o layout 106 no Zebra Design				 	 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	AADD(_aArq,'CT~~CD,~CC^~CT~'+CRLF)
	AADD(_aArq,'^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR2,2~SD22^JUS^LRN^CI0^XZ'+CRLF)
	AADD(_aArq,'^XA'+CRLF)
	AADD(_aArq,'^MMT'+CRLF)
	AADD(_aArq,'^PW945'+CRLF)
	AADD(_aArq,'^LL0709'+CRLF)
	AADD(_aArq,'^LS0'+CRLF)
	AADD(_aArq,'^FO96,640^GFA,02304,02304,00036,:Z64:'+CRLF)
	AADD(_aArq,'eJztkj9r3DAYxh9ZIIki7Ct0MEXEIoXSUcdB8BDq+yAd1K1DB5dCm6GDuMBdtq4dCv0qgg5d+gE6HvkEGW8Idl/V58RzMtYvGPzn50c/HgmYZ55HTSsM2+EZIGPTVbdVHyDhONqq/9HrgXFC4TLUQLFvuqIriOGhzrAv+q/dkbmQJdvFcwo0DqVEmxLPObuhFzgydVayTXgFeE0MCxbIw2uOb7DlyHwRJdvG98B6YDyg4xlnf+Dvcl6Sz2b9DohwUAOzP83YFbwamc+Us1u/AUsM5ZCPaVecmYnPi+Rjr4CQGA7yKe3ykuuJz9utYVv/O+U01A5orUW7/CkFfDX2Y7fkM+Q0t8UhMc7a64yYYuznwy/yWX4/+pSpn+bgPsp+4mOvyWc5+uiUQ8yqoFXvfPwnw8RTeoiCmDwx3riV5pN+/JnimycK2FOHSvxjlH2uebjvpz0xXFZmul9r4yrD4sTnJM+ynHLqOvWT9ivmrkg7d++Ty07keoHqpunpb0+XcHKBSP0U3ZAjcMi0qunUNJ2iLwpB2MzRXTpBDzq388wzz38+fwFz/nTq:83CF'+CRLF)
	AADD(_aArq,'^FO96,416^GFA,01536,01536,00024,:Z64:'+CRLF)
	AADD(_aArq,'eJztkTFOw0AQRf/iyOvCWtOxxSI7N3CZKs5NWIsLrCX6TABxDo4yFhJcw7lByhRRlg22IyQS0SKRXz59/Zn5A/wTqeI0z7vTPDnDf9eScy8ecCc825uFhNj0vNpm+2gPT76zVReR3PXcGQMpRduSs85Jvs17XqQaqXjCmnTBM0U6oi9uYxP4B2rWNZuUS9Hz4ipBihggXRPSrkDPnTTIAhekG4JxTvDg14hIBV5OCboY/VaG/XcTCL+pgWtnMfqzPeYThAvugTL4+ZgP+QyxojC32n7Ph3gJ+Tw98GN+2N+IdzTc1ZxaM/ptnCDBIyxZS4lNxrsO/RjxhoZcw3phTDT0ozVUtKKWZkVXslJq6H+Te+nhWzJ2ueZ47Ll6zTxtMQelNiOKceLD8sxPh+p/SJzxqzP8oov+lD4B0nJlYw==:CBF1'+CRLF)
	AADD(_aArq,'^FO96,480^GFA,00768,00768,00024,:Z64:'+CRLF)
	AADD(_aArq,'eJzd0jFLxDAUB/D3mtDeEOq5ZTjQyTngkk2C4uRHcDD0C3S88dVCXeRwvI/heGMPDlz8AI49BOeODnLxNdXD0cHJN/7455/wCMC/nQPSSFbQaehPwJP2gaIf9ewl0mHoL8C12oU2urVa0Fy0Joc3KDpbUB/9Zsb5K3YJl+B77clEb3P2Z9EZBQ34FbseXbJvsJwO7pbafTml7I2w3M/5pfU0GRhJaMRGaCMxBX/PPbPRE43VrVBGIecXep/P2BHlVKEEd8f9anDBeVGHOjW5SKGoV8V3nu9lF0ay+2q5f2c+wQbr+lElCWx/+GYoXuODkhk4enE0jd7tcrGAV+jzVMCW3j3Z6MammYJzKKXEak1zT2X0s49sp4a8UhAqsj50x4NnT9hr8FAqCddIvH8YDyR//AF+M59A2GZ9:1095'+CRLF)
	AADD(_aArq,'^FO96,576^GFA,01792,01792,00028,:Z64:'+CRLF)
	AADD(_aArq,'eJztkjFqwzAUhn/lqXIHY3f0YOgNgkeRoQRammv4CDlAqFyylp6hR1GaodcQLWTO0MGDsftkWwmUDl0D/uXB8PH86b1nYMqUi03nTEMONRQycjH2aYN5NTBzNE1aU+NZepTYRR2MHZjTJRbzhCoFvbhLsOdXdxzYMi9RyFgwywolcS/Fc1UMzMbMVAbLrJyxj59Kj3XMbvgsmS2JfVyKbPQx03wc+xy94ivBJ+Kz7xYFSl8nvA+PgVlt6rTWPbP04n2HwLi/GpvRJ3rfQ2DdWwnM+7rgOyAZfWCmzvfcS6xOPmblrL9n5uvY947rM1uH3le9b3fqj5lWwzyLJ0XbRGxPc2GWy4j8HvI8IpIk7Dp807S8oxZRl6UttZS2vNNQZ5ori7Vn4gMbEX3znP4IVf/7WaZM+Z0fdmNkAA==:A2EB'+CRLF)
	AADD(_aArq,'^FO96,0^GFA,04608,04608,00024,:Z64:'+CRLF)
	AADD(_aArq,'eJztlrFu2zAQho8KVAMa2inIJHgt+BL11jWL0Snw3qlD1yKa8xQeDT2FHsGDA3SQoD6CB3dTw5IURd6dSNhrAJ2BBPjx4efx7kQSYIkl3nXcb7dR/aWuq4j8TSn1dzPXZa1jP5PLzsZMr8fgK+RqjAvTPzq+5vZ9N/7i9nyB/Nn5q4bomefpDu67KU5ELzx/ILq3VyqeDk0o70Mco+nQhB6CvTojXSIeJ/TUhWhv4FH6ZAM1jiCLrg+/PsWHDa+wPepAQfiglx2OFB8KtCP+f6LbJXyP43yVJ+VBDajjvCDpd1f5OxX3z1K8r31u/s75AxDel38QpD4pPp8yP9pBaiK8xP31/hdbKc9/SPFT5U/CdMLrob02H1+2tS/NVzKfdBwCT8enTfCHiL8tEucl58ez55h3/av5z/hKJ5+R8Rn9N7o4KzI+hUu7YHw51h7yVszHX2OZ7VdF/bVtbvs758HyEHhT+0Y8ihZ6/PlavtLunLdf7cMApr9vnC8MLzFv84eyhUc9Py3jwfEH5g/rAX5q/wvnZQ2f4Ts+Du3U61W0/647Rnjjj3g7n/BlgB/aP5RnnOeYP86f89N+K+a/cfnfwN/Z+q9+i5M+iSrOw97WH/Ouv2IAcjpneB4QL/D8IB7cGBfm+0KyeB7Hfq1yen25+ZRmPrG+M/PfiKd+RU7/8fysNPxCeXt+/tOndE/9ZezrBfIBE/8iweP7BetZghfo9Mc6pPiEf4pH9y/1lwk+XDBvN/FluH+JHjZMnye59x+IDgle+A20lJdxPmyA+RcJ/lPs9YP5PdV9h89UhwTvO9AwfVqgYvq0wIbpU0WZrEfIVn/+vpWx7cJ0CQwzPUvw4hd9O9Ad8PTBvRF5+m6FfUQGsX2N4UssscS1+A+BfBfd:0F49'+CRLF)
	AADD(_aArq,'^FO96,288^GFA,01792,01792,00028,:Z64:'+CRLF)
	AADD(_aArq,'eJztUjFqw0AQ3L0DnQoRpbzAgZQfuFQV5SEppB/IDwhZbLAbP2oNIWlS5AnnLqXcqTC+rJAUuw6BNJpquWGYndkDmDFjxj+i7DSlnYIqeE3lOf2CBwh+4F66rM2CgTq0WVuGLGDYh27gcigKq9d0TzIswCokz3bgKqgSi4ZrhsoJpw007CYdRzGsuCLwyQJi3EDOycA1yMbitlkyMogO3+D2oiNlcZWLH/Uc7MByPPqJzpmoqQedww/hRl3pSaVnVUg+gvIUiy4O7ZjvSDo7GbcMRxbOiu4ufI5+SNoWKqmv/ejKz0VRPe35KntWU3ZS8Y1Sko8jyQcbWHA+5pMna4xeMjwmvW4rvRRTPulMKzyQDH1na6gufTbO6QgPDM2T5DO450svqY9xBT50mZf7nSHQT59g2OJ7fz/Dcr8WnpHT3/+VGX+MbxOhe7s=:E909'+CRLF)
	AADD(_aArq,'^FO192,192^GFA,06912,06912,00072,:Z64:'+CRLF)
	AADD(_aArq,'eJztlk2O3DYQhUshAm6MqQvEzRwhywnQafkmvoKzkxGlRScLX8ow2CtvfQT2CUzBAcIgsphXlEbNEZAgCy1sWIXuGf2MHz89vSqaaK+99tprr6+41G/b6Oh32+jwuI3Ok/NGOk+20fmCi1XylJKPFLoUQ518oBNRbUl5UpHkhFKkGl/2HOhMJo04q0fLpD2FScfoNFQpXYYKOp/w7UOVHBlLZqAqkpzgPnUpkAmzTsIZPgY6VVh4xhWPEIKnHoVHgQP37cIzPvCkyLhCceFJwjM+8FyDxtKdAwHpgYArPG7iMYBdeAaDKwVPsuAZM48Hj2exwwmEGoiBK7wLT1p4BvCEwp90kc/EU4PHAKFzAgEeLC48uFHy1HJhxeOMxXGC8D2FI1EwNtIvrops9RsYDp6g5AZWx7/7QHQgnB0JPIeCx/ElYEn8aKvQEriopc7roJ0eqXvW4ZLGDfzti6dBfcDLxB/gczZ0jjcer73wAKqhgLTge6a/vVznt4hPjUsUJUbcnKBjwXOSXJ2YTnHhUU6veFoc9KDBExuJi61CFTNP81PQ7xaeFr/b6qajvETELf4c6XvqvXLfEMvKbJGRmP25/zGo13bxx9B9c8uP01fw/HnNPB24sFjmwU1ZmR3WHDJP++uNJ+fnxgN/lEdUPvrsTw2fRMdnnQOLjhV/ECzw3Af9u6c7dJvPeW5OxftSPfLzsc889cxzjROPFZ0q6yA/x5dBvxaenJ9oqDkW+ck8fcj+CE+DjcJHbfFO2DYrHgbPYeLxLK9xxdP/Vfqj/SA8Z3YP/uT++u5lYIXflPvLGfTS2p8QS3+Ua0TnqO0jfw4NdBZ/iCVrK57wqciPdLnoYM2ZJ048P6P5Zp7WOIPGe+QPMhDPZX6gI/mBzrHMz13IOlN+2LEMuFV+QlfmWacR1zF03JTnOT+mn3kkz9o/5oE/OA61+OPROF46J42Tb/40+5P7i728bvgj/YX2k9l18yf3F0aC8BxxVKNzUkK/X2TuYHX0V54bwiM6Jj+XCgY6r27+sBMes/hTY7KAJ7CTOWjr2/yZeSZ/VFzxPC94xJ/6IpNODeYCDuOK+cNXMW/2pxrmZ3k0n2VLmecPS+KNzGfRKeczeERH8gzDIsu7wPid5gaeMWHX0guPyTqVPHuVhzUOfSe+6MvMg7OWJp5CJ+9favGHU5C3lBKiG3nav1zm0S5EvKvMc8RcZZt7odi/rgUP9i+kBuHBbjnIZjbtX0PmGWRCyvDBDDeM7M08LBum+KMWfzCrhYej8BD6iuBRyXM3+VPzxONmnveZp1ryQ8/hgXbfvkeLtTgBzx9ZBzy9pNlMz2UwLqt+1vn3Uva/7//f0mEbHXrxmen8sJHORjz4v9YmZdw2Onvttddee+2119dd/wAfo4Iv:15AE'+CRLF)
	AADD(_aArq,'^FO96,352^GFA,02304,02304,00036,:Z64:'+CRLF)
	AADD(_aArq,'eJztkjGK20AYhd8/4+g3YfCIpFgVQyT2BFNuaZIi11CyFxCk2CaFsSDrwpDWxUL2CDmCiQLbptxSJBdQ6UKryW/JSpHKkCqgV0nw6embJwFTpvxPSc5g4jOY7B89zg43+KgDaPkMRRq+BNtqFBGIf2Bv24GxB93psEK9QG3D586GNWoFZQ/H+4FxjrmkmpqUGhQOhipqGOwcNYZWPeMXhkpkdP8cO2QJDErspMcv6N5gYIrIUYWCmgt6RC49qOgxwsxH2hvseyaXmX/B4+sL2iCfC/ONNgqzTKpGZikzv0FMu5fkRh/HmDlwYmhgaum4RkK7S216Hyq1UZi/Wqlk9Fn2TEx3NxwhT4MNmqMIhpvIGT0yGd6L0+ZSCWM72ykVSQ8OxtgOf3o+yLvurjn0Pk5zYHkoTVv7hNO5ruRdV7R9LasefRbaBiWMsp05fa+cj+fy9P2t0f0+rI1mxDk7HplMzVGJ06e1GB730XKxRpapRI2M52Hn28rRftjH0QO851iPTCICJWoq1wmthn0Skp5k4fX2xKQtBx32727Fay/7yPeK8RDytC1oZHQN+YOQl8oLY8MWPz2qLtN1hpGZMmXKX/kNN4d+Zg==:2B12'+CRLF)
	AADD(_aArq,'^FO480,288^GFA,02304,02304,00036,:Z64:'+CRLF)
	AADD(_aArq,'eJztkrFq3TAUhmUE0RLsPIBav0Fnhbo3Q9+jDWToKtMhN2BqGQ3ekkfIi5Qi4UFvUY7xC8jcxYPxqYydkJteKKVDF/+L5cOvj3N+HUI2bdq06a/F8Okkn2sUjz0UzXq6flFTrzj+BMcfeWgFv3sUHHkYgU+kiPwHf2tSxrksWEGNTKOfPPL7/XKHANKJDe/9Fyj1928wnQ1UySv9Y8cGsbBZ1KNjyXg1lB6bEXusfeCUFjEZ3/i1v7ZrSMwzsR/axrRtUyuqBLSdu+dvYZ3LWkc4zwqZW2fbPvxRk0PvHOfJkgudqOrgPBbiWphOma6qycy50fo8TpacWErtYUynLJN3eLDmgDPnzuRNnSJbPPRBK5jSSQh5iV1lutmjLs1XrR+n1cNYY+EzJzPHsMocDJv7MbmrOVn7YbQxQO9J4AgIAXfqLHAkdLqOSbLOFYVR2ONFlhV5/7Hq+yZwbB++dXrxlE8FWOtkFGLOUGGLYS4EbLV+GIVfOb5kyMYsu4XSmWBk876U1jk27uX6Xn5HBgJC3Kh3czC70M9EYqo1ASnICUX+VPVYrzbnpJ439x896Z8tm/6bfgGzwui/:4C78'+CRLF)
	AADD(_aArq,'^FO96,512^GFA,00768,00768,00012,:Z64:'+CRLF)
	AADD(_aArq,'eJxjYBgFAwsYGxhimf9//v8BxGlg+N8MZD8AiR9gPPiAhx2iqIGZIYGHGaqenaEAymZoYGMwgIkfYGGQgIvzwNmMEPb/A2BxDgYJDgib8QAPgwzcfD4k9SwMAnA2E5L5yPYyNzyAif8/+P8A0Hyw+/832DEAzX9A1RCiJQAAYzsluw==:5A8B'+CRLF)
	AADD(_aArq,'^FO672,32^GFA,02560,02560,00020,:Z64:'+CRLF)
	AADD(_aArq,'eJztlD1r20AYx+90xIIIJHfq4EG7Bs8hGpSlewrJ3rF06FyKiK4UWmiHfgWPwg1HRmFBUT9B8xE0BlOMMxQ0qLk+9yadLoF26NY+2JL98ON//+dFQugfDlbeS8WcuylS1/XKyRWc836a8rYQO+qqQVxPcmldu4JYYlPBkLEdY2w9kfv5VBx8Z+eOlcHaOhg38BVg47hegkMrN59ri9cOFzxQsQ/c3sl5YNBtIb7fGYRBr/oDDokOujm3YBGgt3FzouDhT6hsLcGgdWBjOKpz5LOqM7UaGHHeuVwCxsxd5+bmPJszg7D05GwbzTUq54nJrrQ/zYn+igYPPFJzkI2zBhzpTbG5Q7F6N/BjPQ44e4CTq/dFzcPoCVuiwcTiXjK1eWK+zOa49tmM5QohewHVKtMJt5VBlU+Hi/nYP6O3uKfXTDjGlLHl6A8bruDjHhg9WTea6tncWvuTtwlHH3Fr/7Qe0W20+kKJzSXSnxozm3CqLWbvpa/NOGZrHrHNJcpYYsYsQgNyzJ3OaaHU1osUUNjcjMn9WzO9hiJkAa1qo3nO8Vju+D6Q7ZNl8NbkXojndibbOOQyYS/m1hqAGeFrUU/eV744L5tyaJguGzj0uB+6jf5OzH9L4FN8enBycHJ+/uT85EzlvJXXhnTWst27HdWvP39PuohGt5x/4l/12IKKVAENrkgbUKTHEXU+cPGetFGD9TiSG688pHAFVaTHm3V+H9Oi86/jgTuuyCZFrytCFxRrvYve5xnKO7+JqeEuS48tUVnOKOgpf7jPI57hrgfuDVbjxeVR8HFDKqFXkyuZI/s8+sbJHrgMbrrc54cftl57Ax633kqVe5vH73v/FjxmSHOkroK3VQBXmiKiuIj3MenFFTi/lbmQfQ+9y3B3GdIl0noxzTMMUA41Gy6lRykq4bqgx0YPSoVPgfIYFWf+j2cit0RJgp7DJ4QHxFP7V6CLAr1S3J0/7un/cOMXqUOaCg==:F569'+CRLF)
	AADD(_aArq,'^FT432,674^A0N,25,24^FH\^FD'+cCdAnat1+" "+cCdAnat2+" "+cCdAnat3+'^FS'+CRLF)
	AADD(_aArq,'^FT436,447^A0N,25,24^FH\^FD'+SubStr(SC6->C6_DESCRI,1,20)+'^FS'+CRLF)
	AADD(_aArq,'^FO417,641^GB416,47,1^FS'+CRLF)
	AADD(_aArq,'^FO417,583^GB416,47,1^FS'+CRLF)
	AADD(_aArq,'^FT432,617^A0N,25,24^FH\^FD'+cDescPeso+'^FS'+CRLF)
	AADD(_aArq,'^FT434,506^A0N,25,24^FH\^FD'+TransForm(nQtdProd,"@E 999,999.99")+'^FS'+CRLF)
	AADD(_aArq,'^FO417,527^GB416,47,1^FS'+CRLF)
	AADD(_aArq,'^FO418,471^GB415,48,1^FS'+CRLF)
	AADD(_aArq,'^FO105,177^GB729,120,1^FS'+CRLF)
	AADD(_aArq,'^FT437,396^A0N,25,24^FH\^FD'+SC6->C6_SEUCOD+'^FS'+CRLF)
	AADD(_aArq,'^FO104,583^GB307,48,1^FS'+CRLF)
	AADD(_aArq,'^FO95,169^GB746,527,1^FS'+CRLF)
	AADD(_aArq,'^FO418,416^GB415,47,1^FS'+CRLF)
	AADD(_aArq,'^FO104,641^GB306,47,1^FS'+CRLF)
	AADD(_aArq,'^FO418,360^GB416,47,1^FS'+CRLF)
	AADD(_aArq,'^FO418,304^GB416,47,1^FS'+CRLF)
	AADD(_aArq,'^FO104,527^GB306,48,1^FS'+CRLF)
	AADD(_aArq,'^FT433,562^A0N,25,24^FH\^FD'+cSemana+'^FS'+CRLF)
	AADD(_aArq,'^FO104,471^GB306,48,1^FS'+CRLF)
	AADD(_aArq,'^FO105,304^GB306,47,1^FS'+CRLF)
	AADD(_aArq,'^FO104,416^GB306,47,1^FS'+CRLF)
	AADD(_aArq,'^FO105,360^GB305,47,1^FS'+CRLF)
	AADD(_aArq,'^PQ1,0,1,Y^XZ'+CRLF)
	AaDd(aCodEtq,_aArq)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	//³Imprime a etiqueta									 	 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿                                                          	// Parametros dentro do Crystal
	For nY:=1 To Len(aCodEtq)
		For nP:=1 To Len(aCodEtq[nY])
			MSCBWrite(aCodEtq[nY][nP])
		Next nP
	Next nY
	
	_aArq:= {}
	aCodEtq:= {}
	
	MSCBEND()
	MSCBCLOSEPRINTER()

Next nX

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


  DEFINE MSDIALOG oDlg TITLE "Escolha a sua célula de trabalho" FROM 000, 000  TO 300, 300 COLORS 0, 16777215 PIXEL

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
	Msginfo("Local de impressão "+cCel+" não identificado", "aviso")
ENDIF

IF SELECT ("QCB5") > 0 
	QCB5->(DBCLOSEAREA())
ENDIF

Return cFila
