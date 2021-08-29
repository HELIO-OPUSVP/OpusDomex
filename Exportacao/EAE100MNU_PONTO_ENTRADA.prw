//------------------------------------------------------------------------------------//
//Empresa...: OPUS 
//Funcao....: Ponto Entrada  Rotina EAE100MNU
//Autor.....: MAURICIO LIMA DE SOUZA
//Data......: 
//Uso.......: DETALHE PACKING LIST
//Versao....: 
//------------------------------------------------------------------------------------//

#INCLUDE "TOPCONN.CH"
#INCLUDE "FIVEWIN.CH"
#INCLUDE "PROTHEUS.CH"

*----------------------------------------------------------------------------------------
User Function EAE100MNU()
*----------------------------------------------------------------------------------------
Local cArea    := GetArea()
local aRotina:={}

aadd(aRotina,{"Detalhe Packing List","U_DOMPACKD(EEC->EEC_PEDREF)", 0 , 4,20,NIL}) 
RestArea(cArea)
Return     


USER function  DOMPACKD(cPEDREF)

	Local cAlias  := "ZEC"
	Local cTitulo := "Packing List Details"
    //Local cFunExc := "U_RERPA02A()"
	//Local cFunAlt := "U_CADSC4AL()"
	//Local cFunEXC := "U_CADSC4EX()"
	cFiltro := "ZEC_PEDREF == '"+ALLTRIM(cPEDREF)+"' "

	dbselectarea("ZEC")
	SET FILTER TO &(cFiltro)
	//AxCadastro( <cAlias>, <cTitulo>, <cVldExc>, <cVldAlt>)
	AxCadastro(cAlias, cTitulo)
	SET FILTER TO

Return


Return