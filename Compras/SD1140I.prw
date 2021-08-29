//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Wederson L. Santana - 08/10/12                                                                                                                   //
//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Especifico Domex - Ponto de entrada.                                                                                                             //
//Inclusao Pre nota.                                                                                                                               //
//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Este ponto de entrada imprimir'a as etiquetas e armazenar'a as informa'c~oes impressas em tabela especifica.                                     //
//-------------------------------------------------------------------------------------------------------------------------------------------------//

User Function SD1140I()

Local _aArea   := GetArea()
Local lOrigXml := IIf(Type("lImpXmlNF")=="U",.F.,lImpXmlNF)

//Caso origem seja a rotina de importação do XML
//Sair sem executar P.E.
If lOrigXml
	Return
EndIf

If cTipo == "N".And.cUfOrigP <> "EX"
	If SB1->B1_XXETIQU $ "1/2"
		If Localiza(SD1->D1_COD) .and. Rastro(SD1->D1_COD)
			U_DOMEST03()
		Else
			MsgInfo("Produto "+SD1->D1_COD+" não tem controle por endereço ou controle de lote.","A T E N Ç Ã O")
		EndIf
	EndIf		
EndIf
Restarea(_aArea)

Return