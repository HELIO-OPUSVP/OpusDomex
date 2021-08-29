#include "totvs.ch"
#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VC5_TABELA  ºAutor  ³Helio Ferreira/Osmar     ³  10/03/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação do campo C6_SEUCOD                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rosenberger                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VC6_SEUCOD()

    Local _Retorno     := .T.
    Local nPC6_PRODUTO := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_PRODUTO" } )

    If !Empty(M->C5_CLIENTE)
        // If M->C5_TIPO == 'N'
        If M->C5_XPVTIPO == "OF"
            If !Empty(M->C5_TABELA)
                DA0->( dbSetOrder(1) )
                IF DA0->( dbSeek( xFilial() + M->C5_TABELA ) )
                    If DA0->DA0_XGENER <> 'S'
                        DA1->( dbSetOrder(1) )
                        If DA1->( dbSeek( xFilial() + M->C5_TABELA + aCols[N,nPC6_PRODUTO] ) )
                            IF M->C6_SEUCOD == DA1->DA1_SEUCOD
                                _Retorno := .T.
                            else
                                //Verificar se o cliente é dispensado de validar código
                                //  If !(M->C5_CLIENTE $ AllTrim(GetMv("MV_XVCODCL")))
                               If SA1->A1_XVALCOD <> "S"
                                    MsgStop("Código do cliente está diferente na tabela de preço!!")
                                    _Retorno := .F.
                                EndIf    
                            EndIf
                        Else
                            MsgStop("Produto não cadastrado na tabela de Preço " + M->C5_TABELA)
                            _Retorno := .F.
                        EndIF
                    EndIf
                Else
                    MsgStop("Tabela não encontrada")
                    _Retorno := .F.
                EndIf
            EndIf
        EndIf
    Else
        MsgInfo("Favor preencher o cliente")
        _Retorno := .F.
    EndIF


Return _Retorno
