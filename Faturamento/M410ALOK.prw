#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#include "AP5MAIL.CH"
#include "rwmake.ch"

/*
   Programa M410ALOK  Autor  Mauricio Lima de Souza OPUSVP Data 12/02/21 
   Ponto entrada utilizado para tratar oalteracao de pedidos
   de venda para exportacao(Alteracao)
*/

User Function M410ALOK()

	Local aAreaGER    := GetArea()
	Local aAreaSC5    := SC5->( GetArea() )
	Local _Retorno    :=.T.

	EE7->(dbSelectArea("EE7"))
	EE7->(DBSETORDER(12)) //EE7	C 12 	EE7_FILIAL+EE7_PEDFAT
	EE7->(DBGOTOP())

	If EE7->(MsSeek(xFilial("EE7")+SC5->C5_NUM)) .AND. ALTERA==.T.  //EE7	C 12 	EE7_FILIAL+EE7_PEDFAT
		If EE7->EE7_XXPV=='S' //BLOQUEADO
			_Retorno := .F.
			MSGALERT('Pedido de Venda, Bloqueado - '+ SC5->C5_NUM+' - Departamento de Exportacao','Solicitar Liberacao')

			cData     := DtoC(Date())
			cAssunto  := "Alteracao PV Bloqueado - Depto. Exportacao  Pedido: "+SC5->C5_NUM+" User:  " + Subs(cUSUARIO,7,14)
			cTexto    := "Alteracao PV Bloqueado - Depto. Exportacao  Pedido: "+SC5->C5_NUM+" User:  " + Subs(cUSUARIO,7,14)+" - Data " + cData + "  Hora: " + Time()
			cPara     := "natassia.curado@rdt.com.br;adriana.ottoboni@rosenbergerdomex.com.br;denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
			//cPara     := "mauricio.souza@opusvp.com.br"
			cCC       := ""
			cArquivo  := ""

			U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
		EndIf
		If EE7->EE7_XXPV<>'S' //LIBERADO
			_Retorno := .T.
			MSGALERT('Alteracao LIBERADA - '+ SC5->C5_NUM+' - Departamento de Exportacao')
		ENDIF
	EndIf

	RestArea(aAreaSC5)
	RestArea(aAreaGER)

Return(_Retorno)
