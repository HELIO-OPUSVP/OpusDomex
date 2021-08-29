#include "totvs.ch"
// Função de validação do preenchimento do campo DB_LOCALIZ (Endereçamento de estoque)
User Function VDBLOCALIZ()
   Local _Retorno := .T.
   Local aAreaGER := GetArea()
   Local aAreaSD3 := SD3->( GetArea() )

   If !Empty(M->DB_LOCALIZ) .and. FunName() <> 'DOMCORT' .and. Subs(FunName(),1,8) <> 'DOMCORTP'
      If Alltrim(M->DB_LOCALIZ) == '01CORTE' .or. Alltrim(M->DB_LOCALIZ) == '01PRODUCAO'
         If SDA->DA_ORIGEM == 'SD3'
            SD3->( dbSetOrder(4) )
            If SD3->( dbSeek( xFilial() + SDA->DA_NUMSEQ ) )
               If SD3->D3_TM == '015' // TM utilizada no ajuste de fibras
                  _Retorno := .T.
               else
                  MsgStop("3-Endereço permitido apenas pela ferramenta de entrega de material para produção")
                  _Retorno := .F.
               EndIf
            else
               MsgStop("3-Endereço permitido apenas pela ferramenta de entrega de material para produção")
               _Retorno := .F.
            EndIf
         Else
            MsgStop("1-Endereço permitido apenas pela ferramenta de entrega de material para produção")
            _Retorno := .F.
         EndIf
      EndIf
   EndIf
   
   RestArea(aAreaSD3)
   RestArea(aAreaGER)

Return _Retorno