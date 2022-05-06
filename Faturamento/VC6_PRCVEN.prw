#include "totvs.ch"
#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VC6_PRCVEN � Autor  �Helio Ferreira/Osmar     �  05/03/20   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o do campo Pre�o com tabela de pre�o               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Rosenberger                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function VC6_PRCVEN()

    Local _Retorno     := .T.
    Local nPC6_PRODUTO := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_PRODUTO" } )
    Local lGenerica    := .F.
    Local lValida      := .f.
    Local nPrMaximo    := 0
    Local nPrMinimo    := 0
    Local aAreaSB1     := SB1->( GetArea() )

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
    SB1->( dbSeek(xFilial() + aCols[N,nPC6_PRODUTO]) )
	//Para produtos tipo "SI/SV -Servi�os" o pre�o de venda n�o ser� validado
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
                        
                        //Aguardando a cria��o do campo DA1_XAPROV e aprova��o do usu�rio - Osmar 27/10/2020
                        //If DA1->DA1_XAPROV == "N" 
                        //   MsgStop("Pre�o Bloqueado na Tabela de Pre�os")
                        //   _Retorno := .F.
                        //Else
                        //EndIf //Este EndIf deve estar antes do Else (linha 108) do If acima

                        nPrMaximo := DA1->DA1_PRCVEN + ( DA1->DA1_PRCVEN * ( DA1->DA1_XTOLER / 100 ) )
                        nPrMinimo := DA1->DA1_PRCVEN - ( DA1->DA1_PRCVEN * ( DA1->DA1_XTOLER / 100 ) )
                        If M->C6_PRCVEN == DA1->DA1_PRCVEN
                            _Retorno := .T.
                        Else                           
                            //Tabela � gen�rica
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
                                  MsgStop("Pre�o inferior a Tabela de Pre�os")
                                  _Retorno := .F.
                               EndIf
                            Else    //Tabela padr�o
                                If ( M->C6_PRCVEN >= nPrMinimo ) .And. ( M->C6_PRCVEN <= nPrMaximo ) 
                                   _Retorno := .T.
                                Else
                                   MsgStop("Pre�o fora das margens de toler�ncia da Tabela de Pre�os")
                                   _Retorno := .F. 
                                EndIf   
                            EndIf

                            /*If lGenerica .and. M->C6_PRCVEN > DA1->DA1_PRCVEN
                                _Retorno := .T.
                            ELSE
                                _Retorno := .F.
                                If lGenerica
                                    MsgStop("Pre�o inferior a Tabela de Pre�os")
                                Else  
                                    MsgStop("Pre�o diferente da Tabela de Pre�os")
                                EndIf
                            EndIf
                            */
                        EndIf
                    Else
                        MsgStop("Produto n�o cadastrado na tabela de Pre�o " + M->C5_TABELA)
                        _Retorno := .F.
                    EndIF
                Else
                    MsgStop("Tabela n�o encontrada")
                    _Retorno := .F.
                EndIf
            Else
                MsgStop("Tabela de pre�os obrigat�ria para Pedidos de Venda tipo 'Normal'")
                _Retorno := .F.
            EndIf
        EndIf
    Else
        MsgInfo("Favor preencher o cliente")
        _Retorno := .F.
    EndIF

RestArea(aAreaSB1)
Return _Retorno
