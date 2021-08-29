#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} UACONCEP
Consulta CEP

@author		Jackson Santos
@since 		24/03/2015

@Example	Cliente 	-> U_UACONCEP( M->A1_CEP,"M->A1_EST","M->A1_MUN","M->A1_BAIRRO","M->A1_END","M->A1_COD_MUN")
@Example	Fornecedor 	-> U_UACONCEP( M->A2_CEP,"M->A2_EST","M->A2_MUN","M->A2_BAIRRO","M->A2_END","M->A2_COD_MUN")
@Example	Vendedor 	-> U_UACONCEP( M->A3_CEP,"M->A3_EST","M->A3_MUN","M->A3_BAIRRO","M->A3_END")

@OBS		Usar por gatilho. Dominio e contra Dominio Iguais
@OBS		Conteúdo pode ser utilizado desde que respeite as referencias do autor.
/*/
User Function UACONCEP( cCEP, oUF, oCidade, oBairro, oEnd, oCodMun )
Local oXML		:= Nil

Local cError	:= ''
Local cWarning	:= ''
Local cURL		:= ''
Local cXML		:= ''

Local cUF		:= ''
Local cCidade	:= ''
Local cBairro	:= ''
Local cEnd		:= ''
Local cTipoEnd	:= ''

Local aAreaCC2	:= CC2->( GetArea() )

Default oUF		:= ''
Default oCidade	:= ''
Default oBairro	:= ''
Default oEnd	:= ''
Default oCodMun:= ''



cURL	:= "http://cep.republicavirtual.com.br/web_cep.php?cep=" + StrTran( cCEP, "-", "") + "&formato=xml"
MsgRun( "Aguarde..." , "Consultando CEP" , { || cXML := HTTPGET( cURL ) } )

oXML		:= XmlParser( cXML , "_" , @cError , @cWarning )

If oXml:_WebServiceCep:_Resultado:Text == '1'

	cUF				:= oXml:_WebServiceCep:_UF:Text
	cCidade			:= oXml:_WebServiceCep:_Cidade:Text
	cBairro			:= oXml:_WebServiceCep:_Bairro:Text
	cEnd			:= oXml:_WebServiceCep:_Logradouro:Text
	cTipoEnd		:= oXml:_WebServiceCep:_Tipo_Logradouro:Text
	
	If oUF <> ''
	
		&(oUF)			:= cUF
		
	Endif
	If oCidade <> ''
	
		&(oCidade)		:= PADR(cCidade,TamSx3(Substr(oCidade,4))[1])
		
	Endif
	If oBairro <> ''
	
		&(oBairro)		:= PADR(cBairro,TamSx3(Substr(oBairro,4))[1])
		
	Endif
	If oEnd <> ''
	    //If Substr(oEnd,4,3)=="RA_"                                        
	    //	&("M->RA_LOGRTP") := PADR(cTipoEnd,TamSx3("RA_LOGRTP")[1])
		//	&(oEnd)   		:= PADR(cEnd,TamSx3(Substr(oEnd,4))[1])
		//Else
			&(oEnd)   		:= cTipoEnd + ' ' + PADR(cEnd,TamSx3(Substr(oEnd,4))[1])
		//Endif
	Endif
	
	cCidade := NoAcento(cCidade)
	CC2->( dbSetOrder(2) )
	If CC2->( dbSeek( xFilial("CC2") + Upper( Padr( cCidade, TamSX3("A1_MUN")[01] ) ) ) )   

		If oCodMun <> ''
		
			&(oCodMun)   		:= CC2->CC2_CODMUN
			
		Endif
		
	Endif	

Else

	MsgAlert( 'CEP não encontrado: ' + cCEP, 'Consulta de CEP' )

Endif

RestArea( aAreaCC2 )
Return( &( Alltrim( ReadVar() ) ) )


Static Function NoAcento(cString)

Local cChar	:= ""
Local cVogal	:= "aeiouAEIOU"
Local cAgudo	:= "áéíóú"+"ÁÉÍÓÚ"
Local cCircu	:= "âêîôû"+"ÂÊÎÔÛ"
Local cTrema	:= "äëïöü"+"ÄËÏÖÜ"
Local cCrase	:= "àèìòù"+"ÀÈÌÒÙ" 
Local cTio		:= "ãõÃÕ"
Local cCecid	:= "çÇ"
Local cMaior	:= "&lt;"
Local cMenor	:= "&gt;"
Local cEcom		:= "&"

Local nX		:= 0 
Local nY		:= 0

For nX:= 1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase+cEcom
		nY:= At(cChar,cAgudo)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCircu)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTrema)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCrase)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf		
		nY:= At(cChar,cTio)
		If nY > 0          
			cString := StrTran(cString,cChar,SubStr("aoAO",nY,1))
		EndIf		
		nY:= At(cChar,cCecid)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("cC",nY,1))
		EndIf
		nY:= At(cChar,cEcom)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("eE",nY,1))
		EndIf
	Endif
Next

If cMaior$ cString 
	cString := strTran( cString, cMaior, "" ) 
EndIf
If cMenor$ cString 
	cString := strTran( cString, cMenor, "" )
EndIf

cString := StrTran( cString, CRLF, " " )

For nX:=1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	If (Asc(cChar) < 32 .Or. Asc(cChar) > 123) .and. !cChar $ '|' 
		cString:=StrTran(cString,cChar,".")
	Endif
Next nX

Return cString
