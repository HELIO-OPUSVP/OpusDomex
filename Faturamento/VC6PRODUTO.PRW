
#INCLUDE "TOTVS.CH"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VC6PRODUTO � Autor  �Helio Ferreira/Osmar     �  05/03/20   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o do campo Produto com tabela de pre�o               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Rosenberger                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function VC6PRODUTO()
    Local _Retorno := .T.
    Local lValida  := .f. 
    Local aAreaSB1 := SB1->( GetArea() )

    //Verifica se vai aplicar o controle de valida��o do pre�o
    //e obriga��o da tabela de pre�os
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
    //Para produtos tipo "SI-Servi�os" o pre�o de venda n�o ser� validado
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
                                MsgStop("Produto n�o encontrado na Tabela de Pre�os " + M->C5_TABELA + ". Favor incluir o produto na Tabela de Pre�os antes de incluir o Pedido de Vendas.")
                                _Retorno := .F.
                            ENDIF
                        EndIF
                    else
                        If DA0->DA0_XGENER <> "S"  // N�o � tabela gen�rica, portanto a tabela no PV e cadastro de cliente deve ser igual
                           MsgInfo("A Tabela de Pre�os preenchida no Cadastro de Clientes est� diferente da informada no cabe�alho do Pedido")
                           _Retorno := .F.
                        EndIf
                    EndIf
                else
                    MsgInfo("A Tabela de Pre�os deve estar preenchida no cadastro de Clientes para inclus�o de Pedidos tipo 'Normal'")
                    _Retorno := .F.
                EndIf
            else
                MsgInfo("Cliente inv�lido")
                _Retorno := .F.
            EndIF
        Else
            MsgInfo("Favor preencher o Cliente antes do Produto")
            _Retorno := .F.
        EndIf
    ENDIF

RestArea(aAreaSB1)
Return _Retorno
