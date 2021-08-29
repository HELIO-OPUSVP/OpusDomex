#Include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF1100E   ºAutor  ³Marco Aurelio Silva º Data ³  21/10/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada - Exclusao de Pre-Nota                    º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//FILIALMG

User Function SF1100E()
Local aXD1Recno := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Chama rotina de Gestor XML para tratar Exclusao de Documento de Entrada³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock("MRSXML02")                   
 		u_MRSXML02()
	Endif

If ((fwfilial() == "02" .and. SD1->D1_FORNECE == "900000" .and. SD1->D1_LOJA == "01" ) .or. (fwfilial() == "01" .and. SD1->D1_FORNECE == "004500" .and. SD1->D1_LOJA == "01" ))
	XD1->(DbSetOrder(2))
	If XD1->(DbSeek(SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA))
		While XD1->(!EOF()) .AND. SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == XD1->XD1_FILIAL + XD1->XD1_DOC + XD1->XD1_SERIE + XD1->XD1_FORNECE + XD1->XD1_LOJA
			If SD1->D1_DTDIGIT == XD1->XD1_DTDIGI
				AADD(aXD1Recno,XD1->( Recno() ))				
			EndIf			
			XD1->(dbSkip())
		Enddo
	EndIf
	
	If Len(aXD1Recno) > 0				
		For x := 1 to Len(aXD1Recno)
			XD1->( dbGoTo(aXD1Recno[x]) )
			If XD1->( Recno() ) == aXD1Recno[x]
				Reclock("XD1",.F.)
				XD1->XD1_FILIAL  := If(fwfilial()=="01", "02", "01")
				XD1->XD1_LOCAL   := "95"
				XD1->XD1_OCORRE  := "9"                        
				XD1->XD1_DOC     := ""
				XD1->XD1_SERIE   := ""
				XD1->XD1_FORNEC  := ""
				XD1->XD1_LOJA    := ""
				XD1->XD1_DTDIGI  := CTOD("")
				XD1->(MsUnlock())							
			EndIf
		Next x
	EndIf

EndIf


Return
