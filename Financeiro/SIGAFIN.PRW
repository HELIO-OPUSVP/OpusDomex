#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

USER FUNCTION SIGAFIN    

// Cria VAriavel para tratar erro lAltera na rotina de Baixa de Titulos a Pagar
// Utilizado até que se tenha retorno Definitivo da TOTVS

If type("lAltera") == 'U'
   //Public lAltera := .T.
   Private lAltera := .T.
EndIf

RETURN