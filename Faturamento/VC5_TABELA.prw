#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VC5_TABELA  ºAutor  ³Helio Ferreira/Osmar     ³  05/03/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação do campo C5_TABELA                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rosenberger                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VC5_TABELA()
    Local _Retorno := .F.
    Local lValida  := .F.

    //Verifica se vai aplicar o controle de validação do preço
    //e obrigação da tabela de preços
    If Altera
        If M->C5_EMISSAO > GetMV("MV_XTABVEN")
           lValida := .t.
        Else
           lValida := .f.
        EndIf
    Else
        If Inclui
           lValida := .t.
        EndIf
    EndIf

    If !lValida
       Return(_Retorno)
    EndIf

    //If M->C5_TIPO <> "N"
    If M->C5_XPVTIPO <> "OF"
        _Retorno := .T.
    Else
        If !Empty(M->C5_TABELA)
            If !Empty(M->C5_CLIENTE)
                SA1->( dbSetOrder(1)  )
                IF SA1->( dbSeek( xFilial() + M->C5_CLIENTE + M->C5_LOJACLI )   )
                    If Empty(SA1->A1_TABELA)
                        MsgStop("O campo Tabela de Preços deve ser preenchido no cadastro de Clientes para Pedidos tipo 'Normal'")
                        _Retorno := .T.
                    else
                        If M->C5_TABELA == SA1->A1_TABELA
                            _Retorno := .T.
                        Else
                            DA0->( dbSetOrder(1) )
                            If DA0->( dbSeek( xFilial() + M->C5_TABELA ) )
                                If DA0->DA0_XGENER == "S"
                                    _Retorno := .T.
                                Else
                                    _Retorno := .F.
                                    MsgStop("Tabela de Preços diferente da informada no cadastro de Clientes")
                                EndIf
                            Else
                                _Retorno := .F.
                                MsgStop("Tabela de Preços não cadastrada")
                            EndIf
                            // _Retorno := .F.
                            // MsgStop("Tabela de Preços diferente da informada no cadastro de Clientes")
                        EndIf
                    EndIf
                EndIf
            Else
                MsgInfo("Favor preencher o cliente")
                _Retorno := .F.
            EndIF
        else
            MsgStop("O campo Tabela de Preços deve ser preenchido no cadastro de Clientes para Pedidos tipo 'Normal'")
            _Retorno := .F.
        EndIF
    EndIf
Return _Retorno

