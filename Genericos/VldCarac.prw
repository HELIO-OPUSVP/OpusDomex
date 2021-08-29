#include "rwmake.ch"
#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VldCarac  ºAutor  ³Helio Ferreira      º Data ³  25/07/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação de caracteres. Usado no Valid dos campos         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex / Clientes OpusVP                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

// cCaracter = Cadeia de caracteres a ser avaliada
// lMensgem  = indica se deve ou não mostrar mensagem com o caracter inválido
// lPermite  = indica se deve ou não retornar .T. quando encontrar um caracter inválido

User Function VldCarac(cCaracter,lMensagem,lPermite)
Local _Retorno := .T.
Local x, n
Local cPermitidos := ""

Default lMensagem := .T.
Default lPermite  := .F.

//Asc(cParam)   // Converte o caracter para numérico
// Chr(nParam)  // Converte de numérico para caracter ascaii

For n := 1 to 255
   If n >= 48 .and. n <= 57     // Números
      cPermitidos += Chr(n)
   EndIf
   
   If n >= 65 .and. n <= 90     // Letras Maiúsculas
      cPermitidos += Chr(n)
   EndIf
   
   If n >= 97 .and. n <= 122    // Letras Minusculas
      cPermitidos += Chr(n)
   EndIf
Next n

// Exceções
cPermitidos += " "
cPermitidos += "+"
cPermitidos += "-"
cPermitidos += ","
cPermitidos += "µ"
cPermitidos += "Ø"
cPermitidos += "("
cPermitidos += ")"
cPermitidos += "/"
cPermitidos += "."
cPermitidos += "~"
cPermitidos += "º"
cPermitidos += "$"
cPermitidos += "%"
cPermitidos += "#"

If ValType(cCaracter) == "C"
	For x := 1 to Len(cCaracter)
		If !(Subs(cCaracter,x,1) $ cPermitidos)
			If lMensagem
				MsgStop("Conteúdo impróprio na posição " + Alltrim(Str(x)) + " igual a (" + Subs(cCaracter,x,1)+").")
			EndIf
			If !lPermite
				_Retorno := .F.
			EndIf
		EndIf
	Next x
Else
	If lMensagem
		MsgStop("Conteúdo validado diferente de 'CARACTER'.")
	EndIf
	If !lPermite
		_Retorno := .F.
	EndIf
EndIf

Return _Retorno
