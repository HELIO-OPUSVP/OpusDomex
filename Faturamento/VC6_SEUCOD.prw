#include "totvs.ch"
#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VC5_TABELA  �Autor  �Helio Ferreira/Osmar     �  10/03/20   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o do campo C6_SEUCOD                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Rosenberger                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
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
                                //Verificar se o cliente � dispensado de validar c�digo
                                //  If !(M->C5_CLIENTE $ AllTrim(GetMv("MV_XVCODCL")))
                               If SA1->A1_XVALCOD <> "S"
                                    MsgStop("C�digo do cliente est� diferente na tabela de pre�o!!")
                                    _Retorno := .F.
                                EndIf    
                            EndIf
                        Else
                            MsgStop("Produto n�o cadastrado na tabela de Pre�o " + M->C5_TABELA)
                            _Retorno := .F.
                        EndIF
                    EndIf
                Else
                    MsgStop("Tabela n�o encontrada")
                    _Retorno := .F.
                EndIf
            EndIf
        EndIf
    Else
        MsgInfo("Favor preencher o cliente")
        _Retorno := .F.
    EndIF


Return _Retorno
