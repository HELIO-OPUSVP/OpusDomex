#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VZX_PROD  ºAutor  ³Helio Ferreira      º Data ³  04/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VZX_PROD()
Local _Retorno := .T.

If !Empty(M->ZX_PRODUTO)
	SB1->( dbSetOrder(1) )
	If SB1->( dbSeek( xFilial() + M->ZX_PRODUTO ) )
	/*
		lPermitido := .T.
		If SB1->B1_TIPO <> 'MC'
			If SB1->B1_TIPO <> 'MS'
			   If SB1->B1_LOCPAD <> "05"
			      If SB1->B1_LOCPAD <> "07"
				      lPermitido := .F.       
				   EndIf
				EndIf
			EndIf                          
		EndIf
		If !lPermitido
			MsgStop("Somente Materiais de Consumo/Secundários devem ser solicitados por esta rotina. A partir de 15/02/2020 esta rotina não permitirá a solicitação deste dipo de produto.")
			If Date() >= CtoD("15/02/2021")  // ALTERACAO 17/01/2010 PARA 15/02/2021 MLS SOLIC:Denis   17/10/2018
				_Retorno := .F.
			EndIf
			
			cTexto   := "Produto " + M->ZX_PRODUTO + " tipo "+SB1->B1_TIPO+" solicitado pela rotina de Solicitação de Materiais de Consumo pelo usuário " + M->ZX_NOME
			cAssunto := "Material indevido na Solicitação de MC "
			cTxtMsg  := cAssunto
			cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
			cPara    := 'fabiana.santos@rosenbergerdomex.com.br;tatiane.alves@rosenbergerdomex.com.br;denis.vieira@rdt.com.br;'
			cCC      := ""
			cArquivo := Nil
			U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
			
		EndIf
	*/
		// Adicionado por MAURESI en 09/03/2020
		if Alltrim(SB1->B1_TIPO)  $ "PA/PR/MP/"   // Produto Acabado / Produto Revenda / Materia Prima
			MsgStop("Produtos dos tipos [ PA / PR / MP ] não podem ser solicitados por esta rotina.")
			_Retorno := .F.
		endif

	Else
		MsgStop("Produto inválido.")
	EndIf
EndIf

Return _Retorno
