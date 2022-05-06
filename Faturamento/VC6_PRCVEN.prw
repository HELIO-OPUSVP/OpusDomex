#include "totvs.ch"
#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VC6_PRCVEN º Autor  ³Helio Ferreira/Osmar     ³  05/03/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação do campo Preço com tabela de preço               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rosenberger                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VC6_PRCVEN()

    Local _Retorno     := .T.
    Local nPC6_PRODUTO := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_PRODUTO" } )
    Local lGenerica    := .F.
    Local lValida      := .f.
    Local nPrMaximo    := 0
    Local nPrMinimo    := 0
    Local aAreaSB1     := SB1->( GetArea() )

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
    SB1->( dbSeek(xFilial() + aCols[N,nPC6_PRODUTO]) )
	//Para produtos tipo "SI/SV -Serviços" o preço de venda não será validado
    If (SB1->B1_TIPO == 'SV' .Or. SB1->B1_TIPO == 'SI')
    	   lValida := .f.
   	EndIf 
	
    If !lValida
       RestArea(aAreaSB1)
       Return(_Retorno)
    EndIf

    If !Empty(M->C5_CLIENTE)
        //If M->C5_TIPO == 'N'
        If M->C5_XPVTIPO == "OF"
            If !Empty(M->C5_TABELA)
                DA0->( dbSetOrder(1) )
                IF DA0->( dbSeek( xFilial() + M->C5_TABELA ) )
                    DA1->( dbSetOrder(1) )
                    If DA1->( dbSeek( xFilial() + M->C5_TABELA + aCols[N,nPC6_PRODUTO] ) )
                        
                        //Aguardando a criação do campo DA1_XAPROV e aprovação do usuário - Osmar 27/10/2020
                        //If DA1->DA1_XAPROV == "N" 
                        //   MsgStop("Preço Bloqueado na Tabela de Preços")
                        //   _Retorno := .F.
                        //Else
                        //EndIf //Este EndIf deve estar antes do Else (linha 108) do If acima

                        nPrMaximo := DA1->DA1_PRCVEN + ( DA1->DA1_PRCVEN * ( DA1->DA1_XTOLER / 100 ) )
                        nPrMinimo := DA1->DA1_PRCVEN - ( DA1->DA1_PRCVEN * ( DA1->DA1_XTOLER / 100 ) )
                        If M->C6_PRCVEN == DA1->DA1_PRCVEN
                            _Retorno := .T.
                        Else                           
                            //Tabela é genérica
                            If DA0->DA0_XGENER == "S"
                                lGenerica := .T.
                            else
                                lGenerica := .F.
                            EndIf

                            If lGenerica
                               //If M->C6_PRCVEN >= nPrMinimo --Usar no futuro
                               If M->C6_PRCVEN > DA1->DA1_PRCVEN
                                  _Retorno := .T.
                               Else
                                  MsgStop("Preço inferior a Tabela de Preços")
                                  _Retorno := .F.
                               EndIf
                            Else    //Tabela padrão
                                If ( M->C6_PRCVEN >= nPrMinimo ) .And. ( M->C6_PRCVEN <= nPrMaximo ) 
                                   _Retorno := .T.
                                Else
                                   MsgStop("Preço fora das margens de tolerância da Tabela de Preços")
                                   _Retorno := .F. 
                                EndIf   
                            EndIf

                            /*If lGenerica .and. M->C6_PRCVEN > DA1->DA1_PRCVEN
                                _Retorno := .T.
                            ELSE
                                _Retorno := .F.
                                If lGenerica
                                    MsgStop("Preço inferior a Tabela de Preços")
                                Else  
                                    MsgStop("Preço diferente da Tabela de Preços")
                                EndIf
                            EndIf
                            */
                        EndIf
                    Else
                        MsgStop("Produto não cadastrado na tabela de Preço " + M->C5_TABELA)
                        _Retorno := .F.
                    EndIF
                Else
                    MsgStop("Tabela não encontrada")
                    _Retorno := .F.
                EndIf
            Else
                MsgStop("Tabela de preços obrigatória para Pedidos de Venda tipo 'Normal'")
                _Retorno := .F.
            EndIf
        EndIf
    Else
        MsgInfo("Favor preencher o cliente")
        _Retorno := .F.
    EndIF

RestArea(aAreaSB1)
Return _Retorno
