#Include 'protheus.ch'
#Include 'Totvs.ch'
#Include 'parmtype.ch'

/*/{Protheus.doc} zMDeNfe
	Realiza manifestações das notas fiscais
	
	@author Súlivan Simões Silva - Email: sulivansimoes@gmail.com
	@since  06/05/2020 [data da criação]
	@version 1.1
	@example zMDeNfe
	@type function
	@obs  * TSS deve estar devidamente configurado
	      * Usa static function presente no fonte SPEDMANIFE.prw       		

	@Obs: LOG MANUTENÇÃO		  
	----------------------------------------------------------------------
	Responsável: Súlivan
	Data: 01/2022
	Log:  Retirado o uso da SataticCall pois a compilação foi bloqueada
	 	  a partir da versão 12.1.33
	----------------------------------------------------------------------
/*/	
User Function zMDeNfe()
		
	Local aArea 		:= GetArea()
	Local dHoje			:= Date()
	Local cCodEve	    := "210210" //210210 - Ciência da operação	
	Local cRetorno 		:= ""		//Retorno da função de manifestação
	Local aXMLGZIP		:= {}		//Recebe os XMLs baixados da sefaz.
	Local aNotasMDe		:= {}		//Recebe as notas que deve ser manifestadas.    
	Local nIndice       := 0
	Local cEmp_schedule := ""
	Local cFil_schedule := ""
	
	Default aSchedule := {"01","01"}

	U_zWritLog("[u_zMDeNfe] - Iniciou função u_zMDeNfe dia: "+dToc(dHoje) + " Hora: "+time())	
	
	//Caso esteja sendo executada por schedulle
	If (IsBlind())
		
       	U_zWritLog("[u_zMDeNfe] - ** Função sendo executada via Schedulle **")
		
		/*Array padrão do sistema passado por parametro quando a rotina é chamada via schedule*/
		cEmp_schedule := aSchedule[01]
		cFil_schedule := aSchedule[02]
		
        RPCSetEnv(cEmp_schedule, cFil_schedule)
    EndIf
	
	//Pega os XMLs que baixou da sefaz.
	aXMLGZIP := u_zBxXMLNf(.T.)			
	fGetNfMDe( aXMLGZIP, @aNotasMDe )
	
	For nIndice := 1 To Len(aNotasMDe)
			
		Varinfo("nota para manifestar",aNotasMDe[nIndice])
			
		MontaXmlManif(cCodEve, aNotasMDe[nIndice], @cRetorno, "")
		U_zWritLog("[u_zMDeNfe] Retorno manifestação - " + cValToChar(cRetorno) )
	Next
	
	//Caso esteja sendo executada por schedulle
	If(IsBlind())
        RPCClearEnv() //Libera ambiente
    EndIf
	U_zWritLog("[u_zMDeNfe] - Encerrou função u_zMDeNfe dia: "+dToc(dHoje) + " Hora: "+time())
	
	RestArea(aArea)
Return


/*
	* Descompacta XML's
	* Pega os XML dos resumos (que precisam ser manifestados para efetuar o download completo)
	* Monta um array com as informações necessárias para manifestar
	* Retorna o array montado.
	
	Param: aXMLGZIP, Array, Array contendo todas as notas que serão baixadas no próximo zBxXMLNf
	Param: aNotasMDe, Array, endereço do array que será populado com as notas que sofrerão a manifestação
*/
Static Function fGetNfMDe( aXMLGZIP, aNotasMDe )

	Local nIndice    := 0
	Local nTamanho   := 0
	Local cUnXML     := ""
	Local cDecode64  := ""
	Local cWarning   := ""
	Local cError	 := ""
	Local lHouveErro := .F.
	Local lOk		 := .T.
	Local cConteudo  := ""
	Local cChaveNFe  := ""
	Local cValorNFe  := "" 
	Local cCNPJNFe   := ""
	Local cIENFe	 := ""
	Local xDateEmiss := ""
	Local xDateAuto	 := ""
	Local aNotas	 := {} 
	
	Private oNF		 := Nil
	
	For nIndice := 1 To Len(aXMLGZIP)
	
		//Pega tag que contém XML em zip
		cConteudo := aXMLGZIP[nIndice]:TEXT
	
		//Pega o tamanho e descriptografa o conteúdo
		nTamanho  := Len(cConteudo)
		cDecode64 := Decode64(cConteudo)
		lOk       := GzStrDecomp(cDecode64, nTamanho, @cUnXML)
		
		If lOk
		
			//Verifica se é uma NF-e e se for então gera XML senão não gera.
			oNF := XmlParser(cUnXML, "_", @cError, @cWarning)
		
			//Se existir Warning, mostra no console.log
			If ! Empty(cWarning)
				U_zWritLog("[u_zMDeNfe][fGetNfMDe] - Alerta cWarning: " + cWarning)
			EndIf
			
			//Se houve erro, não permitirá prosseguir
			If ! Empty(cError)
				U_zWritLog("[u_zMDeNfe][fGetNfMDe] - Erro cError: " + cError)
				lHouveErro := .T.
			EndIf			
			
			//Verifica estrutura do xml
			//Se for de resumo irei precisar realizar manifestação.
			If ( type("oNF:_resNFe") <> "U")
				
				cChaveNFe := Iif(type("oNF:_RESNFE:_CHNFE") <> "U", oNF:_RESNFE:_CHNFE:TEXT, "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
				cValorNFe := Iif(type("oNF:_RESNFE:_VNF"  ) <> "U", oNF:_RESNFE:_VNF:TEXT  , "0")
				cCNPJNFe  := Iif(type("oNF:_RESNFE:_CNPJ" ) <> "U", oNF:_RESNFE:_CNPJ:TEXT , "XXXXXXXXXXXXXX")
				cIENFe	  := Iif(type("oNF:_RESNFE:_IE"   ) <> "U", oNF:_RESNFE:_IE:TEXT   , "XXXXXXXXXXXXX")
				xDateEmiss:= Iif(type("oNF:_RESNFE:_DHEMI") <> "U", oNF:_RESNFE:_DHEMI:TEXT, "2000-01-01")
				xDateAuto := Iif(type("oNF:_RESNFE:_DHRECBTO") <> "U", oNF:_RESNFE:_DHRECBTO:TEXT, "2000-01-01")
				
				//Tratando as datas
				xDateEmiss := cTod( Substr(xDateEmiss,9,2) + "/" +;
								    Substr(xDateEmiss,6,2) + "/" +;
									Substr(xDateEmiss,1,4) )

				xDateAuto := cTod( Substr(xDateAuto,9,2) + "/" +;
								   Substr(xDateAuto,6,2) + "/" +;
								   Substr(xDateAuto,1,4) )
				
				aNotas:={}
				aAdd(aNotas, { ,;
							  cChaveNFe 			 ,; //Chave
							  Substr(cChaveNFe,23,3) ,; //Série
							  Substr(cChaveNFe,27,9) ,; //Nota
							  Val(cValorNFe)		 ,; //Valor
							  cCNPJNFe				 ,; //Cnpj
							  "NOME"				 ,; //Razão social
							  cIENFe				 ,; //IE
							  xDateEmiss             ,; //DT Emissão
							  xDateAuto				 ,; //DT Autorização
							  .T. ,;
							  '0' ,;
							  '1' })
							  	
				aAdd(aNotasMde,aNotas)										
			Endif
		Else
			U_zWritLog("[u_zMDeNfe][fGetNfMDe] - Houve um erro na tentativa de descompactação do XML")
		Endif
	Next
Return 


/*/{Protheus.doc} MontaXmlManif()
Monta xml para transmissão da manifestação

@author FUNCAO CONGELADA
@since 04.07.2012
@version 1.00
@param 	cCbCpo     - Evento Selecionado no listbox
		aMontXml   - Dados da nota que deve ser transmitida
		cRetorno   - Chaves de acesso das notas transmitidas
		cJustific  - Justificativa da Operação não realizada
@Return lRetOk	   - Se a transmissão foi concluída ou não		
/*/
//-----------------------------------------------------------------------     
Static Function MontaXmlManif(cCbCpo,aMontXml,cRetorno,cJustific) 

	Local aRet			:={}

	Local cAmbiente		:= "" 
	Local cXml			:= ""
	Local cTpEvento		:= SubStr(cCbCpo,1,6)
	Local lUsaColab		:= UsaColaboracao("4")
	Local cIdEnt		:= RetIdEnti(lUsaColab)
	Local cURL			:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local cChavesMsg	:= ""
	Local cMsgManif		:= ""
	Local cIdEven		:= ""
	Local cErro		:= ""
	Local cRetPE		:= ""

	Local aNfe			:= {}

	Local lRetOk		:= .T. 
	Local lManiEven	:= ExistBlock("MANIEVEN")
	Local lMata103	:= IIf(FunName()$"MATA103",.T.,.F.)

	Local nX 			:= 0
	Local nZ 			:= 0

	Private oWs			:= Nil

	Default cJustific 	:= ""

	If !Empty(Alltrim(RetIdEnti()))
		If lUsaColab	
			cAmbiente := ColGetPar("MV_AMBIENT")
			lRetOk := .F.
			
			For nX:=1 To Len(aMontXml)
				aNfe := {}
				aNfe := {aMontXml[nX][2],"","",""}
				cIdEven := ""
				cXML	 := ""
				cXml := SpedCCeXml(aNfe,cJustific,cTpEvento)		
				//Adiciona a CHAVE da nota para solicitar o envio.
						
				
				If ColEnvEvento("MDE",aNfe,cXml,@cIdEven,@cErro)
					lRetOk := .T.
					aadd(aRet,cIdEven)
				else
					Aviso("MD-e TOTVS Colaboração 2.0",cErro,{"Problema encontrado na transmissão"},3)	
				EndIf
			Next
		else
			oWs :=WSMANIFESTACAODESTINATARIO():New()
			oWs:cUserToken   := "TOTVS"
			oWs:cIDENT	     := cIdEnt
			oWs:cAMBIENTE	 := ""
			oWs:cVERSAO      := ""
			oWs:_URL         := AllTrim(cURL)+"/MANIFESTACAODESTINATARIO.apw" 
			
			If oWs:CONFIGURARPARAMETROS()
				cAmbiente		 := oWs:OWSCONFIGURARPARAMETROSRESULT:CAMBIENTE
				
				cXml+='<envEvento>'
				cXml+='<eventos>'
				
				For nX:=1 To Len(aMontXml)
					cXml+='<detEvento>'
					If lManiEven
						cRetPE := ExecBlock("MANIEVEN",.F.,.F.,{cTpEvento,aMontXml[nX][2]})
						If cRetPE <> Nil .And. !Empty(cRetPE)
							cTpEvento := cRetPE
						EndIf
					EndIf
					cXml+='<tpEvento>'+cTpEvento+'</tpEvento>'
					cXml+='<chNFe>'+Alltrim(aMontXml[nX][2])+'</chNFe>'
					cXml+='<ambiente>'+cAmbiente+'</ambiente>'
					If '210240' $ cTpEvento .and. !Empty(cJustific)
						cXml+='<xJust>'+Alltrim(cJustific)+'</xJust>'
					EndIf		
					cXml+='</detEvento>'
				Next
				cXml+='</eventos>'
				cXml+='</envEvento>'
				
				lRetOk:= EnvioManif(cXml,cIdEnt,cUrl,@aRet)
			
			Else                                                                               
				Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3)
			endif	
		endif
				
		If lRetOk .And. Len(aRet) > 0
			For nZ:=1 to Len(aRet)
				aRet[nZ]:= Substr(aRet[nZ],9,44)
				cChavesMsg += aRet[nZ] + Chr(10) + Chr(13)	    	    
			Next
			cMsgManif := "Transmissão da Manifestação concluída com sucesso!"+ Chr(10) + Chr(13)
			cMsgManif += cCbCpo + Chr(10) + Chr(13)
			cMsgManif += "Chave(s): "+ Chr(10) + Chr(13)
			cMsgManif += cChavesMsg
			IF lMata103
				cMsgManif += Chr(10) + Chr(13)+ "Consulte a rotina de Manifestação do Destinatário para verificar o resultado!"
			EndIf
			cRetorno := Alltrim(cMsgManif)
			
		EndIf
			
		AtuStatus(aRet,cTpEvento)			
		
	Else
		Aviso("SPED","Serviço não configurado",{"Execute o módulo de configuração do serviço, antes de utilizar esta opção!!!"},3)
	EndIf
		
Return lRetOk 

//-----------------------------------------------------------------------
/*/{Protheus.doc} AtuStatus()
Atualiza o Status da Manifestação de acordo com o Tipo de Evento

@author FUNCAO CONGELADA
@since 04.07.2012
@version 1.00

@param 	aRet   	   - Chaves de acesso das notas transmitidas
		cTpEvento  - Tipo do Evento em que a nota foi transmitida
	
/*/
//----------------------------------------------------------------------- 
Static Function AtuStatus(aRet,cTpEvento)

	Local aAreas	:= {}
	Local cStat		:= "0"
	Local nX		:= 0

	If cTpEvento $ '210200'
		cStat:= "1"  //Confirmada operação
	ElseIf cTpEvento $ '210220'
		cStat:= "2"  //Desconhecimento da Operação
	ElseIf cTpEvento $ '210240' 
		cStat:= "3"  //Operação não Realizada		 
	ElseIf cTpEvento $ '210210' 
		cStat:= "4"  //Ciência da operação
	EndIf

	If Len(aRet) > 0
		aAreas := GetArea()
		For nX:=1 to Len(aRet)
			C00->(DbSetOrder(1))
			If C00->(DBSEEK(xFilial("C00")+aRet[nX]))
				RecLock("C00")
				C00->C00_STATUS := cStat
				C00->C00_CODEVE := "2"
				MsUnlock()
			EndIf
		Next
		RestArea(aAreas)	
	EndIf	
Return

//-----------------------------------------------------------------------
/*/{Protheus.doc} EnvioManif()
Envia o xml para transmissão da manifestação

@author FUNCAO CONGELADA
@since 04.07.2012
@version 1.00

@param 	cXmlReceb  - String com o XML a ser transmitido
		cIdEnt	   - Codigo da Entidade
		cUrl	   - URL
		aRetorno   - Retorno do RemessaEvento

@Return lRetOk	   - Se a transmissão foi concluída ou não		
/*/
//-----------------------------------------------------------------------    
Static Function EnvioManif(cXmlReceb,cIdEnt,cUrl,aRetorno,cModel)

	Local lRetOk		:= .T.

	Default cURL		:= PadR(GetNewPar("MV_SPEDURL","http://"),250)  
	Default cIdEnt		:= RetIdEnti(lUsaColab)
	Default aRetorno	:= {}
	Default cModel		:= ""

	If !Empty(Alltrim(RetIdEnti())) .And. !(UsaColaboracao("4"))
		// Chamada do metodo e envio
		oWs:= WsNFeSBra():New()
		oWs:cUserToken	:= "TOTVS"
		oWs:cID_ENT		:= cIdEnt
		oWs:cXML_LOTE	:= cXmlReceb
		oWS:_URL		:= AllTrim(cURL)+"/NFeSBRA.apw"
		If !Empty(cModel)
			oWS:cModelo := cModel
		EndIf
		//oWs:RemessaEvento()
		
		If oWs:RemessaEvento()
			If Type("oWS:oWsRemessaEventoResult:cString") <> "U"
				If Type("oWS:oWsRemessaEventoResult:cString") <> "A"
					aRetorno:={oWS:oWsRemessaEventoResult:cString}
				Else
					aRetorno:=oWS:oWsRemessaEventoResult:cString
				EndIf
			EndIf
		Else
			lRetOk := .F.	
			Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3)
		Endif
	Else
		Aviso("SPED","Wizard nao configurado",{"Execute o módulo de configuração do serviço, antes de utilizar esta opção!!!"},3) 
	EndIf

Return lRetOk
