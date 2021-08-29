
#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"
#include "Tbiconn.ch"
/*
Chamada do fonte DOMETDL7 para desabilitar a trava no roteiro, devido a etiqueta serial
que passou a gravar XD4, porém exisitam muitas ainda em proudução sem gravação.

*/


User Function DL7STRVR()
    U_DOMETDL7()
Return 
