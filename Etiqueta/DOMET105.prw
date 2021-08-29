#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMET105 ºAutor  ³ Michel A. Sander   º Data ³  28.05.2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Etiqueta padrão OI S/A nível 3	Expedição	              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Executado pela DOMETDL3 e via Menu                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMET105(cEtqOp, cEtqProd, cEtqPed, nEtqQtd, dDataFab, lControl, cNfDanfe, nPesoDanfe)

PRIVATE cChvDanfe  := SPACE(44)
PRIVATE nOpcDanfe  := 0
PRIVATE nVolDanfe  := 0
PRIVATE oTelaDanfe
PRIVATE cPedDanfe  := ""
PRIVATE cSemana    := ""
PRIVATE cTransp    := ""

ImpEtqOi(@cEtqOp, @cEtqProd, @cEtqPed, @nEtqQtd, @dDataFab, @lControl, @cNfDanfe, @nPesoDanfe)

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
	ElseIf cUserSis == "EMBALAGEM DIO 1T"
		cFila := "000012"
	ElseIf cUserSis == "EMBALAGEM DIO 2T"
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
	EndIf
EndIf

// Armazenando informacoes para um possivel cancelamento da etiqueta por falha na impressao
If Type("cOiDl32_CancOP") <> "U"
	
	cOiDl32_CancOP     := cEtqOp
	cOiDl33_CancPro    := cEtqProd
	cOiDl34_CancPed    := Subs(cEtqPed,1,6)
	cOiDl35_CancUni    := nEtqQtd
	cOiDl38_CancDat    := dDataFab
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
//³Busca a semana do ano corrente						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
cSQL    := "SELECT dbo.SemanaProtheus() AS SEMANA"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"WEEK",.F.,.T.)
cSemana := WEEK->SEMANA
cYY     := SUBSTR(cSemana,3,2)
cWW     := StrZero(Val(SubStr(cSemana,5,2)),2)
cSemana := cWW+cYY
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
//³Verifica fila de impressão no ACD				 	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
If !CB5SetImp(cFila,.F.)
	Aviso("Local de impressao invalido!","Aviso")
	Return .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
//³Monta o layout 105 no Zebra Design				 	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
AADD(_aArq,'CT~~CD,~CC^~CT~'+CRLF)
AADD(_aArq,'^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR2,2~SD28^JUS^LRN^CI0^XZ'+CRLF)
AADD(_aArq,'^XA'+CRLF)
AADD(_aArq,'^MMT'+CRLF)
AADD(_aArq,'^PW1181'+CRLF)
AADD(_aArq,'^LL0827'+CRLF)
AADD(_aArq,'^LS0'+CRLF)
AADD(_aArq,'^FO896,160^GFA,04608,04608,00008,:Z64:'+CRLF)
AADD(_aArq,'eJzVl81q20AQx7Vag0JVqprSW4l8DAnUPhYcsm9m7bH40keojsaHvECg8iP0Deqj6aF2oQfVqJ5IM7NKZccrqVagWQI/Nqvs/ndm5yOO87+M9/PbeUEFADY2HRfzWaP9VL+vkPjTgpoYPswnOF84u4LByicCZMy0oATYoECAGBn+IcFubL3P5Xze7D7eL9IjN09LNzb2eIvyreqb6+/1PPZzsCWqlAhLhARNyztiWF0WvEzWz5cz3mXb7PwWQ53C8d1dYtOR2ys58ZzLv8XW2n8Na8tdD8aL6XRq3Y/Z7/8mPSLtls5s/77WJ9j1/R1/q5FAD84FeoAex3cACT7MYCMo/peUF0LOE3m+uMF583xD3y/o74OVpPySebR/Kim/pJLySypj5GvxqPwL5jVTxcwN04QXLJASOBwjMFwhJ0AJbBLQwkQwnaQ6HzI5ziLKhznxIJ/3DzmOzfkm+o0+o9foPzquWvlnwP4ZsX9GCdl79I3sP4Iqxwkx/EwMkgP/iE79c8P3b+Kfd8TVecHcPx5yCETBdJJXPH/J60QA/vv0nKgDh/zjOo/4x+iJq3pr/WPih/0vj/kn9arxsyjj5wvOm9dtE29Up7XZj+NzJTM+P2M9eL44qNdcWNyPdTfsdDSu/71euz5mj6U9jX1NP7N06/qZJTLk/HBmt0/T+qHe/OymX2nZz5xZ1Xc/mvo3HxHBLxMx4gq+FxD8mYIZkdvLMo+afojXzffOkPN5+Quzv4hI363dTzX904BZ1hvNLPMZ0eQz/yGfaSbXm4huMPH3642qzoemzhyrN5rO+8rn66oeXdVr9FvGfj/SisMfa6tdu+4Hn3v8dd5/SqbHDJkRE1KsH3KXYTwEux3VjzRCqiW9YLWgCLvRAb63a0fogh9q7nPq/78DZov4oi/+Ob4+1cUXn9dNfLWofz2kscMTcVyj93mMezDo2TQ=:C5E8'+CRLF)
AADD(_aArq,'^FO992,640^GFA,03200,03200,00020,:Z64:'+CRLF)
AADD(_aArq,'eJztlr9u2zAQxs8SEKWUIT+CO2fIXCSDXyVzhiLZi0qPwtHQoK6GuPBROBocDI9BYVTliTz+ETV3SQkEUL78crw73kcJ4P/6hOt+RdutaHW3wqlca84r3J+VeCIPuJlkDj7wXGtvufZ0yrX3KddedL7x2yHf+Fudb/zWZhy7DBm3m/JCaiHWuGwLpvNtt5niV5dL+yTofL5FP6h4X/yvapo+4vyONslTNBC7yYCHKcmS6R7gtddxF+d6DRZXjfVuhEir3k+yRO4aaUWv7gazkrmZ5A655JgFrzFefMzV1O2Ri+eLneFJ44q09jqXkRRiEnvGeNEcbszf25kLWjMAPGJ+Q9B2poAlx0xic7gx5iZpudCYQms1p6eDZuqQ04KDQnCxyM9EzDgG8HVY5md+lhz618XzJ7y75pxpH9j84jryvqB/Xf8K0tC/jvMafD9R/4Jm/OvOY+O15/F+jjfCF7/Luz/fjc/w5UE1mJ7J02tve1nZeQmc8W/p5oX7fcP8KSc1w6AKTI8HLp5nGtVauIJNcifP3bw/yEsM+8a0Hs1zMtKVHfsfQenwRLDWaKQlBoSU4x0Uc2pDxFH+Pym/I3CKM1J+N5AfC67RZ3Vxz69RvWSNNtTLafSE0zbIyZSD4pfquX2kuKZYSd4NlrvnYrSjF420JE9Go6V0b3/RCXe1KQSNu8ugTOPdLOfyZB3644JEQRbB95Eb+oq42vr3BNGryfSlc7fQ3sfTF+Xc8UgWnvtnlponzHHC+nfsSm/hLfkcp9pxzR1TOH59Hyy8rcD5PFiTleDuAxHFW+EKcPdLsHDCUa/KLotn++eWl4APtIIGKxxQuHGFoyuacbpftKZ5wfuFOLrya9M5ihf8Nskl1/SDz++4wpF/WS18vcRtofWcIs7US/lxz4X8ZOB8vbDCkdYAvT9C+1Cr0vTiBh4T7bB8MZhV/MbudYk237zL76JSrHx2tPE9ThHzr5h/vP4C7oW7mQ==:2172'+CRLF)
AADD(_aArq,'^FO992,64^GFA,04608,04608,00024,:Z64:'+CRLF)
AADD(_aArq,'eJztVrtu20AQvPNBMBAXNAtWLhKkTeEPUEHmD1hQn5LKhfUpKgM3SSmYgK1PYZkuKgUQ4IW85+zeSZWLFBpClrEY7c3OHvdOiCuu+BCUZXmfi9/0r18y4dVmRpPGaz1jSMJyY5DEH3uDHY9Xlt/y+F9tcMqpWcBKUKMDW8DTNx2Nv2udWyCkZxWoPmCbUZ9YVOiAA4RlpJOK5Tj2/kFBIIcIgvR6AkEV8kHQugeAQ0hHQRoxZOUj/2ZExAKIfOhAQfJPeflQMJEPHaD0WLCmOGTlQwHg/vL4gldn+IrlP+blB/4dld+/nuH7gmuW3xvE6Z6/Hhm2l/maY5u1xxsqe47DRb7ySdkOcuXel8ygO+P6fvHJdWAH9ndQRwu7Z4A+YP4WhFn+g9GM++g38NGoLto/YSNO0c4OG9dF+0+2EnwDnATZxEab+HNIWWB+6fjVJm48w3eS67cwhd6AP381lO8smTvgDZoovyV8afe8sh/7XOLbpIOyn7iBzvLt0Jm/hjBFY3up/ibkP6J+k78KfEH5xvKjqKd4CABfVB3l30bLizQ/6a/NbxTvTX9xAp3jF9HyOs1P9pvhP1jPF0qYQMBvcQ7F/PqPr4Tl3+BcacL2X4ZOHKPIb+A9hvz65yedzY8w+fn0If6nfJd/enmZ//xK80s5/1cBP0ru9yrRb/xsZd7/QST7x/SrhVuKMo6bGa4G8cT8N/xVI4AfR87Mf87lXzUkfxg5amdf5ve4/7tUD+xPpx/e3+XeU26QL8O9R40nFeePb2vzPfof5wMB4SMMn52+/mVIjxc3Dz/n82c2hJvn9PSdHzuf+fEbDtQkv2lGpgDHTwrYibygxsZvef6Djcsfeb54yp+/yQKeLx5J+nABkiX9hQB8S+8P3CV6xY2XLHrFjUuwO/ea338Es5XxwwKUT6chYoTpgzjHL5g9fAEeF/z+SRfoknidky/Iq0ygsvJ9D7h8t0Ai3y2QyjFnGXPfQubTLxal1S78KuOOwdd8+Ir/HP8AUwXZ9w==:7A02'+CRLF)
AADD(_aArq,'^FO800,64^GFA,01792,01792,00008,:Z64:'+CRLF)
AADD(_aArq,'eJzdk7tKxEAUhicZ2BnWMKYcFiHB0kIsg0+zj2C5lYzWi7XlYiUrWItVSh/BcksrtQxYRDj/mYUZmWjURv/mg7mc+xHir2lnfU2s+o6YHze4sPZ71EzhGekWyHpHlFcb4kTMiUYcEQtRwhzbsQnqLUv+Xwf25Pkm8Of9p2Sen4i+HvpyZP4NswPlA+qplsjL7CKePdlyHsOaxv3Z7/gGdoR0oOLjQ+YifJa1/IyfG76u3u4i+8PxxPWZ3eO/5fx/TK2JZSqAA86nB+UNElTb+amJY+eniOZHceGkA4VLBQT5enj+Wj1sHO+w4v5YPZz/Z/ukBeZ3Ik6Ifl+zvoXDdSKQUyD3e37Wsp05seA99/a/Hl8T/DfcJ8UDnr+4wP8H1TUh7tfo/V6Ee549ol7qAnFV6pU4kyticp7/ld4B+LZbZw==:DBCF'+CRLF)
AADD(_aArq,'^FO800,448^GFA,02304,02304,00008,:Z64:'+CRLF)
AADD(_aArq,'eJzdlb9KA0EQxvdyd9kUx62N2AQFH0AQBYOIuULfICGND6EgaKUHFil9DXtf4GxMZ2xCarGwtVNEs+LNNwe77pogauE0Py673/zb2Y0Q/9XiUaek0q8GaytbtCFtmlwEt8ETcEKUT6RTD8/EARg+lkyCOXcitE0EmhjqnPyNC+jpWwX0ndoMibKXQ2/6Y//CCl+PwSXEA9MWMTkmv0kL3DcZHyDuHfRXiJs7avz4/ZDrI0qu8xJcRT0eyg1ivZ2DcNxyx2NTunAy7mVmwuhnxditU8g/7kyLa86VfKIGhCGty6nnCaJP3Dfx4o7n66/6Zn+l3V9rfqKdDPUVFkkfLXBiOVi4aeV/j/wH8DPslwyGtD+4Aa8r0vpYkk5Dp5FPG5zvZsJpuB+f5vKIdL5+MdUa9qNfNe7bujscm903eYr8cN/9/WJmXweY0ew5rdjdK5mK5kyUFWlg5IjevVATA31LATfdeVTzOyFKPo/znOi7LyCvy35u6Nkf+7etcUH7ve+D5zyi3cLSCYOR5MLc+pjfd76n0NWW3Xn++vtp3e8E85Vi3hS/S0Ni9f/C/X2z8htAdwai7sYPze3f2DvdYsfh:5081'+CRLF)
AADD(_aArq,'^FO736,64^GFA,02304,02304,00008,:Z64:'+CRLF)
AADD(_aArq,'eJzVlbFKw1AUhs9NhkgDrZuC1YaODpqxVNA+yhUdioN0dCg02sFCH8KO4isItb6Bj5BRHMTBwckq+f+bktuEtiiIp8PH5Z7znz+5pzci/yXWAfcTrGyADTdKGMokYSBxQv39W4YmP1Sob1Kv7EK/VGBHvYH+GNz2ivxM2K9l9T8lT8jjrB/WGb2qB1b4/OqdRqJ8f70pdHoPsdV3Nc75cdCwRj++8fOU78MObXFRHNyPEvam6O848CMe1jKGD/WB5T7Spcv6C7JK+twXnp/soV54/vV6nOm3e2cKstGy9GtkhelmPpTxdw09dQV9FZFDFKgbyTyHF1M3yj5Pe85JQOqleP4KYTMfa4N4pXo7ZucDnbMXUGv9OwyChK3c7rNI550U1i9kDCrSJT2NjjuNScJuDWyXo5X8mPdjh6n/+/nJhpn39DwHENDcX5WBpW/Wxo9Pf6rg/ygyytQ7ZNnct1vIDzeRHzTgW4dwoAOyQ6bz1UJ+jPzwEfXNPvRqfeiXonz/HfKQ++Y6cp9pn98FNUSCukSf9NzMeVr3l4vtdB6aVr+imJv/if4Z+X7kFj7lCD6lvMDI/4ovacC6mA==:141D'+CRLF)
AADD(_aArq,'^FO640,64^GFA,01536,01536,00008,:Z64:'+CRLF)
AADD(_aArq,'eJzVkzFLAzEYhnN3lSsW7hwz9fILJOPRQr2fEpzEQTq7WCmo4OBPqOAiCv4Bl5v8HYcu4uDsIFbJ+6ZwwXgdXJoOD6X5vu/Jm0aIzVu7d9eWJ8vG8uACND+fdahW3yvLUtSWMgKz+5ll+sWBt3/7jB/bPodv9DHmf6iUZRWYv00Oc3CUw19LnEeV9NEV+4Xm4XfVYL+uUT+eo18x57w4ILIDJMwtL0CZ0Ic5K0Efnqj7vujD+5mwX5bQJ6Djln8/8T76CrMmGzAhc4U+Qw2fcg8+U+ZvOnyO3puWT78f2FgBA+ZZLMDR73n2mGevgcEWmZCRy9vPU3p5xt79KnJKTsgU5SL6QEG0SMGrG/D0BZw9g+dP4MMZ+In9A76vAhri2Jvnr5j73fvMLlEoI9C9Z+2dt/P/taqrW/1c/3TJ+a8BsQ1c317kc8c=:9ECC'+CRLF)
AADD(_aArq,'^FO576,64^GFA,01536,01536,00008,:Z64:'+CRLF)
AADD(_aArq,'eJzNlMFOwkAQhmdT2m0MpZBwwKQPQcJBTtJH4kCiBwl9M/cRfABNGm/eOJjogUTNzv+XUFrbeJHp4YPu7sy//05X5GJjDN4qzJdTutLTytwzkpnnQDLP4c/TxKQgY6yfgUtlvtbxN81/vcs946sOnasD9CltIcgrqN+PAzAC7VgNCJDXbA+N5WMw5TqnNGu8gH9yg4H5J5jVuFEuSszHuntFuEedQpk0qjmGvdN8KfRL/oARJDLQEyAhDYMcoX7ICTGd+0zr+c+CjvY7geTl+SSfmWS91pGsRn/O/A+f8GMJTptlP6L+x7sn7WFf1Puldz/lyqqf4F9roP/ox9Fn6scGTYkCTjnCMO1D/xgce3Xck7b8vwfn2T/qb7sfusj7JaruDb1/glfdmNk5rdtxX/B7Hdb+/098AyoZS2Y=:6EBB'+CRLF)
AADD(_aArq,'^FO512,64^GFA,02304,02304,00008,:Z64:'+CRLF)
AADD(_aArq,'eJzNlTFLw0AYhr8ziZchaTtWiPgXAg46iGZwdHCwWwv+BAehDgUL/pH+lGyuOnRTCM4ObjoIUfK+V7iUpJ4W7C1Pwt1935v3vvsisuEjmF9U7JafFdVOgol+5MaQTLi/cwjqN9ArWnWY/IZRFK2XAvqtKr7ljq9tHaf2/lX0FwxJ+OEJ/FCPV0hUFuCgXU/8/GTpkV7PTb//T/pPAHWbg3nBOGnFbelb8X+uL7H2a4Eeb4r4apxb+dc9lvzNzn6lv9HfuVt9BAP7/sa79HNd94b1E7bLcB9bpKmPl6KiOc+/1wf81BniqfwSzBr0HAOmfrxZk54+84WOeur1ir6oypz5p2DD9Tbnq9/ZB/h9IhPA9Nc9vn6AOgM7XK3P+cC2LCPSY37F+qPeel927T/BaMhwjv8Tw8b/yaxVx5Ju1vNKJuQROSFfQe+evtzB4Fg9VKzfD/PeJXUOLuxlvckBJ1IeWJrUCD9lv+B67rsBAtrRnYKxbNT4AuKUacE=:C3EC'+CRLF)
AADD(_aArq,'^FO416,64^GFA,01536,01536,00008,:Z64:'+CRLF)
AADD(_aArq,'eJzV1LFKA0EQBuBZLU4Q7lqF02ydQrZcSHOPsqVYWVqILmkE8xBeKfoCQiAc+CL7BGJhYSEq7P/vwR16MWpAp/kINzszt5lE5P/EwU0dPX8L0a0ZlE0PcyaW9A6oXlrGx/vU0rOH0Kkv3n84h3qE2wu4x4KWDYw0UU2dVNQNqiV0zqd6ZQaLV/Z/4iDteG4l0/tN5uFb5yt+OqEjWtScj/ejFhhQXTRwin7K0xkOqCvmP8OMY41wXE5Z/1DWE+k+2u/duZ/Z3pce7DuZ192+n8QGzXMfLXkx1jZRYyp0M+jrjqmmri/ybUCd3XtYTP3gHHINshfOc4v8HcV5uLeGG5L2+cv7TkvufZ5+sL2o6F/bv3Hv/+noEgUcn6+qXtLvN+IdwdBvKg==:B2A7'+CRLF)
AADD(_aArq,'^FO352,64^GFA,00768,00768,00008,:Z64:'+CRLF)
AADD(_aArq,'eJxjYBhyIDbUAUz//38ATF8UhIgfYCCPdsBhD/MDCC1eA6Gt+CB0ATuETmBsgOhnPAA1rwFKH8BBo6qH6YeZZ8EPoeX/QO3/AKEZ4S4i1kcQGhY+9fWk6UPQUPuhDoCZB6MPHKAyDbXXAWeM0AAAAE0HRVM=:B5FE'+CRLF)
AADD(_aArq,'^FO288,64^GFA,01536,01536,00008,:Z64:'+CRLF)
AADD(_aArq,'eJzVk7FOwzAQhs+ysTNYJWxFsniGjkzQB8jAAOprMCBl6VCJl2IsS9+gG0MGHiAPACpS/v+CXInQSGHAyxfJubvv7LPIP1tn+/uO54ePjuYyYWMex7EgE+Nn12BoQdsMemh9ZYxxWgrofhLYAub1EbrP8A5hjnZ8gXiP/qJnXpfXcezfRf6fEG9fkNe0d0PHILIiDxAye/rIAj6CfF6YX/L+jul6Fowvs3zar9br60+8prpfPV9/hfkKK9yTbZuOZjnsEeqnzEOqSljgNCZyDZp3+NgdfTjvMwOfOKwj8oD3Z+kTLnA/nts6r/FEBtKS5vMNH9pvWR4JjKsQ6nXH/vyW1ThDLX9DP53zbUNvzKXnnDvhe/tlzr/nPWXxQfh+NshvatSTW/mL9QW+g0A7:AD59'+CRLF)
AADD(_aArq,'^FO128,128^GFA,03584,03584,00016,:Z64:'+CRLF)
AADD(_aArq,'eJztlj9v1DAUwF8SOEc9lHY8lVMTdWRIoy5EBRW+CNIxsUG2dqgqs1UqH4DxRnQsN1ZFqu6jZLwpZDyB6PHsOLbfQ0VVy9CBJ7W+X+z3/P7FDsBDleHsC+F0vSK8fVASHo1GD4tjyltwP+HxJ82KrSgYs3mxoHxF8XFLOZGUx/D3+aBmCw4YCzNmWabH0Ci8WpudC8Iu3omeSH9RdnI3TpoltW/36/zbuLwwXHT6RV/Pg5pyuqC8ISn3ZjxuGulzsF7jvOmQZ1+nIM8llKa/dT5SLEDV8f5+AeEPgM26d6/QtRWvHV9Jb9+iCPzaKlaqu5lbX3nxK84lPPU5WhB9gEvGwuOsgLNz58BWFx/p39lM8n5m2XKM8Qc+59et8t+tx/1PGB9KypgfwoMV4/QR5eEn50mFHHy2GM6RcxefmFcwOHHxbY5qEEvH47SGVDoHy3AK115AGeanpQkIpowBbk6QyY/HdSDBT0AFbeQxvnhlgm2cGVa9Nfbqg7VNSld/3VteAx3iX1Q7Vm0qane+qdSg/k7PqnfQ/qbsH6D948S+/rp3aiFVDXv/Aon+frAKE4xPwtvWxtc9Ne/H86OKsNVa2p/YfxLeLdycev/e0+XQh/ji21wNw96//jyy7oV62PZUtX0nGWN8PyKgnHvnj2LVP61jtbm8cPwGTJOg5E0LSnVvav0LVGinZnUcz9X80IVfKOet/4qxfjs+Y4sIwlgfX1914EsW73Dq+OgIlA0tJn/x2YX1Tw02PnP+b/j3u6iByB67u4692ydvapgMHCv7i8j1b4nxY/+48wyKQAbS3s/350zZt7yFT3B/yyOcrxPHY6ihGjtO8HzPV47FWsc/si/oTP+P4bZyQjHqes/mV0SabT4S9Acl3F31/k66H3U3lOpEUnakjb+zA5RzxseMjTmdHxTdo559Ycz3+ye9/8a/9KfpH9FpWv+jRnb+9wosfis8gzfeMHdi/v3F77M4/rf7/clMTimG5AjCtH1cEB7YAnXyhH0/xsC+r9n+92Vun++fMP+EbaBOwu+SMI//v9xGfgPDmA8m:E9DF'+CRLF)
AADD(_aArq,'^FO32,64^GFA,02304,02304,00008,:Z64:'+CRLF)
AADD(_aArq,'eJzVlE1KxEAQhTtp6R5Uso4/OJ7AtQvxKl7BA4g2uJmVZxCXs5i1ZEBylIAbmcUgrgaVjJB6ryGtkx8IqLX5knR11etKVyn1byxeTCvadSkfJk9YOQULQZQLd5zwKHC7hBvcNdzsclmPPxo1C5pnEgf++iEWUi9oOpL+GvLVh8RXF2WzDu6fhvW5w8oZHF6EY3x+FFjksy7Ij3XvHxd4uKrFt+vPWv422wJN8D64bTvhTS5crCpEeVpRO/m/GgpiKDIbyHX6c3+U42IV4HGzLP4f0hgzLL3eZtO4v9QRY7/qygQ8B9+SCtHzrsS/lXpb9QpdofXrEFMG/envd9cOa87eVq++xngW1AUe0D5q7IR7Uh+VvoMYWGkCYsM++zcXZrI/WiHPfT3fJmP99Jzz8xDkgIQePxjxGXI4ThTyctx6dx8/+zE/+53zJkI6heP7eXOA8/L86QnIuiA+68d6XiMu6wJ9xoVKfvf+hf1nZjPhUHMglvO1zddv86jnqbqd9o/aF0VzbW0=:9681'+CRLF)
AADD(_aArq,'^FO114,383^GB156,412,1^FS'+CRLF)
AADD(_aArq,'^FO113,70^GB157,304,1^FS'+CRLF)
AADD(_aArq,'^FO41,382^GB65,416,1^FS'+CRLF)
AADD(_aArq,'^FO279,382^GB64,416,1^FS'+CRLF)
AADD(_aArq,'^FO354,382^GB64,416,1^FS'+CRLF)
AADD(_aArq,'^FO429,383^GB64,415,1^FS'+CRLF)
AADD(_aArq,'^FO41,69^GB65,306,1^FS'+CRLF)
AADD(_aArq,'^FO278,69^GB65,306,1^FS'+CRLF)
AADD(_aArq,'^FO502,383^GB65,415,1^FS'+CRLF)
AADD(_aArq,'^FO353,69^GB65,306,1^FS'+CRLF)
AADD(_aArq,'^FO576,383^GB64,416,1^FS'+CRLF)
AADD(_aArq,'^FO428,69^GB65,307,1^FS'+CRLF)
AADD(_aArq,'^FO649,383^GB65,416,1^FS'+CRLF)
AADD(_aArq,'^FO502,69^GB65,306,1^FS'+CRLF)
AADD(_aArq,'^FO723,383^GB64,416,1^FS'+CRLF)
AADD(_aArq,'^FO575,70^GB65,305,1^FS'+CRLF)
AADD(_aArq,'^FO796,383^GB65,416,1^FS'+CRLF)
AADD(_aArq,'^FO649,70^GB65,305,1^FS'+CRLF)
AADD(_aArq,'^FO868,71^GB120,728,1^FS'+CRLF)
AADD(_aArq,'^FO722,70^GB65,305,1^FS'+CRLF)
AADD(_aArq,'^FO796,70^GB65,306,1^FS'+CRLF)
AADD(_aArq,'^FO31,60^GB964,747,1^FS'+CRLF)
AADD(_aArq,'^FT743,403^A0R,25,24^FH\^FD'+SC6->C6_SEUCOD+'^FS'+CRLF)
AADD(_aArq,'^FT674,401^A0R,25,24^FH\^FD'+SubStr(SC6->C6_DESCRI,1,20)+'+^FS'+CRLF)
AADD(_aArq,'^FT598,399^A0R,25,24^FH\^FD'+TransForm(nEtqQtd,"@E 999,999.99")+'^FS'+CRLF)
AADD(_aArq,'^FT524,399^A0R,25,24^FH\^FD'+SC5->C5_ESP1+'^FS'+CRLF)
AADD(_aArq,'^FT452,398^A0R,25,24^FH\^FD'+cInfDanfe+'^FS'+CRLF)
AADD(_aArq,'^FT377,398^A0R,25,24^FH\^FD'+cSemana+'^FS'+CRLF)
AADD(_aArq,'^FT303,399^A0R,25,24^FH\^FD'+TransForm(nPesoDanfe,"@E 999,999.99")+'^FS'+CRLF)
AADD(_aArq,'^FT187,399^A0R,25,24^FH\^FD'+"NA"+'^FS'+CRLF)
AADD(_aArq,'^FT64,398^A0R,25,24^FH\^FD'+cCdAnat1+" "+cCdAnat2+" "+cCdAnat3+'^FS'+CRLF)
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
