#include "rwmake.ch"
#include "totvs.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VldCarac  �Autor  �Helio Ferreira      � Data �  25/07/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o de caracteres. Usado no Valid dos campos         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Domex / Clientes OpusVP                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

// cCaracter = Cadeia de caracteres a ser avaliada
// lMensgem  = indica se deve ou n�o mostrar mensagem com o caracter inv�lido
// lPermite  = indica se deve ou n�o retornar .T. quando encontrar um caracter inv�lido

User Function VldCarac(cCaracter,lMensagem,lPermite)
Local _Retorno := .T.
Local x, n
Local cPermitidos := ""

Default lMensagem := .T.
Default lPermite  := .F.

//Asc(cParam)   // Converte o caracter para num�rico
// Chr(nParam)  // Converte de num�rico para caracter ascaii

For n := 1 to 255
   If n >= 48 .and. n <= 57     // N�meros
      cPermitidos += Chr(n)
   EndIf
   
   If n >= 65 .and. n <= 90     // Letras Mai�sculas
      cPermitidos += Chr(n)
   EndIf
   
   If n >= 97 .and. n <= 122    // Letras Minusculas
      cPermitidos += Chr(n)
   EndIf
Next n

// Exce��es
cPermitidos += " "
cPermitidos += "+"
cPermitidos += "-"
cPermitidos += ","
cPermitidos += "�"
cPermitidos += "�"
cPermitidos += "("
cPermitidos += ")"
cPermitidos += "/"
cPermitidos += "."
cPermitidos += "~"
cPermitidos += "�"
cPermitidos += "$"
cPermitidos += "%"
cPermitidos += "#"

If ValType(cCaracter) == "C"
	For x := 1 to Len(cCaracter)
		If !(Subs(cCaracter,x,1) $ cPermitidos)
			If lMensagem
				MsgStop("Conte�do impr�prio na posi��o " + Alltrim(Str(x)) + " igual a (" + Subs(cCaracter,x,1)+").")
			EndIf
			If !lPermite
				_Retorno := .F.
			EndIf
		EndIf
	Next x
Else
	If lMensagem
		MsgStop("Conte�do validado diferente de 'CARACTER'.")
	EndIf
	If !lPermite
		_Retorno := .F.
	EndIf
EndIf

Return _Retorno
