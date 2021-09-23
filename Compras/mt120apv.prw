#include "rwmake.ch"
#include "topconn.ch"
//----------------------------------------------------------
/*/{PROTHEUS.DOC} MT120APV
Esta fun��o tem como objetivo o preenchimento do grupo padr�o '000003' devido ao protheus n�o estar obedecendo esta regra para os pedidos gerados pelo EIC
@since 10/12/2014
@author Marcos Rezende
/*/
//----------------------------------------------------------

USER FUNCTION MT120APV
Local cGrpAprov := '000003'
If U_Validacao()
    cGrpAprov := "000004"
EndIf

RETURN cGrpAprov
