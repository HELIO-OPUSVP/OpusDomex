#include "rwmake.ch"
#include "protheus.ch"

USER FUNCTION MTA120G2
   Local aArea := GetArea()
   
	SC7->C7_XTPPC := _cTPPC
	
	RestArea( aArea )
RETURN


