#include "totvs.ch"
#include "topconn.ch"

User Function CalPalet(aEmbFinal,aProdutos,aPalets)
    Local _Retorno :={}
    Local aCPalets := {}
    Local lForm    := .F.

    If lForm

        AADD(aCPalets,{'001',aPalets[1,1]})
        AADD(_Retorno,aCPalets)

    Else
        AADD(_Retorno,aEmbFinal)
        AADD(_Retorno,aProdutos)
        AADD(_Retorno,aPalets)


    EndIf

Return _Retorno
