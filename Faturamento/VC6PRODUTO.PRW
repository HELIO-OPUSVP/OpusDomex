
#INCLUDE "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VC6PRODUTO º Autor  ³Helio Ferreira/Osmar     ³  05/03/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação do campo Produto com tabela de preço               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rosenberger                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VC6PRODUTO()
    Local _Retorno := .T.
    Local lValida  := .f. 
    Local aAreaSB1 := SB1->( GetArea() )

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

    SB1->( dbSetOrder(01) )
    SB1->( dbSeek(xFilial() + M->C6_PRODUTO) )
    //Para produtos tipo "SI-Serviços" o preço de venda não será validado
    If SB1->B1_TIPO == 'SI'
       lValida := .f.
    EndIf 

    If !lValida
       RestArea(aAreaSB1)
       Return(_Retorno)
    EndIf

    //If M->C5_TIPO == 'N'
    If M->C5_XPVTIPO == "OF"
        If !Empty(M->C5_CLIENTE)
            SA1->( dbSetOrder(1) )
            If SA1->( dbSeek( xFilial() + M->C5_CLIENTE + M->C5_LOJACLI ) )
                If !Empty(SA1->A1_TABELA)
                    If SA1->A1_TABELA == M->C5_TABELA
                        DA0->( dbSetOrder(1) )
                        IF DA0->( dbSeek( xFilial() + M->C5_TABELA ) )
                            DA1->( dbSetOrder(1) )
                            If !DA1->( dbSeek( xFilial() + M->C5_TABELA + M->C6_PRODUTO ) )
                                MsgStop("Produto não encontrado na Tabela de Preços " + M->C5_TABELA + ". Favor incluir o produto na Tabela de Preços antes de incluir o Pedido de Vendas.")
                                _Retorno := .F.
                            ENDIF
                        EndIF
                    else
                        If DA0->DA0_XGENER <> "S"  // Não é tabela genérica, portanto a tabela no PV e cadastro de cliente deve ser igual
                           MsgInfo("A Tabela de Preços preenchida no Cadastro de Clientes está diferente da informada no cabeçalho do Pedido")
                           _Retorno := .F.
                        EndIf
                    EndIf
                else
                    MsgInfo("A Tabela de Preços deve estar preenchida no cadastro de Clientes para inclusão de Pedidos tipo 'Normal'")
                    _Retorno := .F.
                EndIf
            else
                MsgInfo("Cliente inválido")
                _Retorno := .F.
            EndIF
        Else
            MsgInfo("Favor preencher o Cliente antes do Produto")
            _Retorno := .F.
        EndIf
    ENDIF

RestArea(aAreaSB1)
Return _Retorno
