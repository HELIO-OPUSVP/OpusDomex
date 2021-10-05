
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VLDMARGE  ºAutor  ³Osmar Ferreira      º Data ³  05/10/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida a margem de lucro do pedido de venda                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VldMarge()
	Local aCusto := {}
    Local nCusTotal  := 0
	Local cProdVenda := ""
	Local x := 0

	For x := 1 To Len(aCols)
		nPC6_PRODUTO := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_PRODUTO" } )
		cProdVenda := aCols[x,nPC6_PRODUTO]

	//	aCusto    := U_RetCust(cProdVenda,'N')
	//	nCusMedio := aCusto[1]
	//	cStatus   := aCusto[2]
    //  Alert(M->C5_NUM+"      "+cProdVenda)
	//	Alert(nCusMedio)
	//	Alert(cStatus)

    GravaTMP1(cProdVenda,cProdVenda,1,1,@nCusTotal)

    Alert(nCusTotal)

	Next x

Return(Nil)





Static Function GravaTMP1(cProduto,cCod,nNivel,nQtde,nCusTotal)

Local aAreaSG1
Local nNivelAnt
Local cComp

SG1->(DbSeek(xFilial("SG1")+cCod))
While xFilial("SG1")+cCod == SG1->G1_FILIAL+SG1->G1_COD .And. SG1->(!Eof())
	
  //  Alert("Produto---> "+SG1->G1_COD+"     Componente---> "+SG1->G1_COMP)
     
		cComp :=  SG1->G1_COMP  
        nG1_QTDE    := SG1->G1_QUANT
		nNivelAnt := nNivel

		aAreaSG1 := SG1->(GetArea())

		SG1->(DbSeek(xFilial("SG1")+cComp))
		If SG1->(!Eof()) // É um PI
			nNivel++
			GravaTMP1(cProduto,cComp,nNivel,(nQtde*nG1_QTDE),@nCusTotal)
		EndIf
       
        nCusto :=  U_RetCusB9(cComp,"N")
        nCusTotal += (nCusto * nG1_QTDE * nQtde)
        
        If nCusto = 0 .And. (cProduto <> SG1->G1_COMP)
			lOk := .F.
		EndIf

		nNivel := nNivelAnt
		SG1->(RestArea(aAreaSG1))
	
	SG1->(DbSkip())
EndDo

Return









