#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CustEmp    ºAutor  ³ Osmar / Helio   º Data ³  27/02/2020   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Retorna o custo do produto                                º±±
±±º          ³  pelo empenho da Ordem e último custo médio                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*--------------------------------------------------------------------------*
User Function CustEmp(cOrdem)
    *--------------------------------------------------------------------------*
    Local aRetorno  := {}
    Local aCusto    := {}
    Local nCusMedio := 0
    Local cStatus   := "0"
    Local nValor    := 0
    Local nUnit     := 0
    Local cCodigo   := ''
    Local nQtde     := 0
    Local x         := 0
    Private aAreaSC2 := SC2->( GetArea() )
    Private aAreaSD4 := SD4->( GetArea() )
    Private aAreaSB1 := SB1->( GetArea() )
    Private lOk      := .t.
    Private aOPs     := {}

    aadd(aOPs,cOrdem)

    SC2->(dbSetOrder(1))
    SC2->(dbSeek(xFilial()+cOrdem))
    nQtde := SC2->C2_QUANT

    SD4->(dbSetOrder(2))
    If SD4->(dbSeek(xFilial()+cOrdem))
        While xFilial("SD4") == SD4->D4_FILIAL .And. AllTrim(cOrdem) == AllTrim(SD4->D4_OP) .And. SD4->(!EOF())
            If !Empty(SD4->D4_OPORIG)
                If aScan(aOPs,Alltrim(SD4->D4_OPORIG)) == 0
                    AADD(aOPs,Alltrim(SD4->D4_OPORIG))
                EndIF
            EndIf
            SD4->(dbSkip())
        EndDo
    EndIf


    For x := 1 to Len(aOPs)
        SD4->(dbSetOrder(2))
        If SD4->(dbSeek(xFilial()+aOPs[x]))
            While xFilial("SD4") == SD4->D4_FILIAL .And. AllTrim(aOPs[x]) == AllTrim(SD4->D4_OP) .And. SD4->(!EOF())
                If !Empty(SD4->D4_OPORIG)
                    If aScan(aOPs,Alltrim(SD4->D4_OPORIG)) == 0
                        AADD(aOPs,Alltrim(SD4->D4_OPORIG))
                        x := 1
                    EndIF
                EndIf
                SD4->(dbSkip())
            EndDo
        EndIf
    Next x

    For x := 1 to Len(aOPs)
        SD4->(dbSetOrder(2))
        If SD4->(dbSeek(xFilial()+aOPs[x]))
            While xFilial("SD4") == SD4->D4_FILIAL .And. AllTrim(aOPs[x]) == AllTrim(SD4->D4_OP) .And. SD4->(!EOF())

                If Empty(SD4->D4_OPORIG)
                    cCodigo := SD4->D4_COD

                    SB1->( dbSetOrder(01) )
                    SB1->(dbSeek(xFilial()+cCodigo))
                    //Verificar se não é um PA/PI que foi incluído pelo ajuste de empenho    
                    If SB1->B1_TIPO == "PA" .Or. SB1->B1_TIPO == "PI"
                        //Busca o custo por estrutura                    
                        aCusto    := U_RetCust(cCodigo,'S')
                        nCusMedio := aCusto[1]
                        cStatus   := aCusto[2]
                        nValor    += (SD4->D4_QTDEORI * nCusMedio)
                        If cStatus = "2"
                           lOk := .f.
                        EndIf
                    Else
                        nUnit  := U_RetCusB9(cCodigo,'S')  //Segundo parametro: Gera SC S/N
                        nValor += (SD4->D4_QTDEORI * nUnit)
                        If nUnit = 0
                            lOk := .f.
                        EndIf
                    EndIf

                EndIF
                SD4->(dbSkip())
            EndDo
        EndIf
    Next x

    nValor := nValor / nQtde

    RestArea(aAreaSB1)
    RestArea(aAreaSD4)
    RestArea(aAreaSC2)

    AADD(aRetorno,nValor)

    If lOk
        AADD(aRetorno,"1") //Todos tem custo
    else
        AADD(aRetorno,"2") //Há itens com custo zero
    EndIf

Return(aRetorno)
