
#Include "rwMake.ch"

User Function GeraSC8(cNumSC)
    Local cNumero
    Local aAreaSC8 := SC8->(GetArea())

    cNumero := GetSXENum("SC8","C8_NUM")
    SC8->(dbSetOrder(1))
    While SC8->(dbSeek(xFilial()+cNumero))
        ConfirmSX8()
        cNumero := GetSXENum("SC8","C8_NUM")
    EndDo
    ConfirmSX8()

    SC1->( dbSetOrder(1) )
    SC1->(dbSeek(xFilial()+cNumSC))
    SA5->( dbSetOrder(2) )

    While !SC1->(EOF()) .And. SC1->C1_NUM == cNumSC
        cProduto := SC1->C1_PRODUTO
        SA5->(dbSeek(xFilial()+cProduto))
        While SA5->(EOF()) .And. SA5->A5_PRODUTO == cProduto
            RecLock("SC8",.t.)
            SC8->C8_FILIAL  := xFilial("SC8")
            SC8->C8_NUM     := cNumero
            SC8->C8_ITEM    := SC1->C1_ITEM
            SC8->C8_NUMPRO  := '01'
            SC8->C8_PRODUTO := cProduto
            SC8->C8_UN      := SC1->C1_UN
            SC8->C8_QUANT   := SC1->C1_QUANT
            SC8->C8_FORNECE := SA5->A5_FORNECE
            SC8->C8_LOJA    := SA5->A5_LOJA
            SC8->C8_FILENT  := SC1->C1_FILENT
            SC8->C8_EMISSAO := dDatabase()
            SC8->C8_VALIDA  := dDatabase()+30
            SC8->C8_NUMSC   := SC1->C1_NUM
            SC8->C8_ITEMSC  := SC1->C1_ITEM
            SC8->C8_DATPRF  := dDatabase()
            SC8->C8_IDENT   := SC1->C1_IDENT
            SC8->C8_MOEDA   := '1'
            SC8->C8_CODORCA := '20050000'
            SC8->C8_TPDOC   := '1'
            SC8->C8_FORNOME := A5_NOMEFOR
            SC8->C8_WF      := .F.
            
            SC8->(MsUnlock())
            SA5->(dbSkip())
        EndDo

        RecLock("SC1",.F.)
        SC1->C1_COTACAO := cNumero
        SC1->(MsUnLock())

        SC1->(dbSkip())
    EndDo

    RestArea(aAreaSC8)

Return
