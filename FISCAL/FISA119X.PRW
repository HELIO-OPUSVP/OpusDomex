#INCLUDE "PROTHEUS.CH"  
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"      
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"   

#DEFINE IMP_SPOOL 2
#DEFINE VBOX       080
#DEFINE HMARGEM    030


//-------------------------------------------------------------------
/*/{Protheus.doc} PrtGNRE
Rotina de impressão GNRE

@since 07/03/2016
/*/
//-------------------------------------------------------------------
user function XPrtGNRE(cIdEnt, oImpGNRE, oSetup, cFilePrint)

local aArea      := GetArea()
local lExistGnre := .F. 

private nConsNeg := 0.4 // Constante para concertar o cálculo retornado pelo GetTextWidth para fontes em negrito.
private nConsTex := 0.5 // Constante para concertar o cálculo retornado pelo GetTextWidth.

oImpGNRE:SetResolution(78) //Tamanho estipulado para a impressão da GNRE
oImpGNRE:SetPortrait()
oImpGNRE:SetPaperSize(DMPAPER_A4)
oImpGNRE:SetMargin(60,60,60,60)
oImpGNRE:lServer := oSetup:GetProperty(PD_DESTINATION)==AMB_SERVER

// ----------------------------------------------
// Define saida de impressão
// ----------------------------------------------

if oSetup:GetProperty(PD_PRINTTYPE) == IMP_SPOOL
	oImpGNRE:nDevice := IMP_SPOOL
	// ----------------------------------------------
	// Salva impressora selecionada
	// ----------------------------------------------
	fwWriteProfString(GetPrinterSession(),"DEFAULT", oSetup:aOptions[PD_VALUETYPE], .T.)
	oImpGNRE:cPrinter := oSetup:aOptions[PD_VALUETYPE]
elseif oSetup:GetProperty(PD_PRINTTYPE) == IMP_PDF
	oImpGNRE:nDevice := IMP_PDF
	// ----------------------------------------------
	// Define para salvar o PDF
	// ----------------------------------------------
	oImpGNRE:cPathPDF := oSetup:aOptions[PD_VALUETYPE]
endif

private PixelX := oImpGNRE:nLogPixelX()
private PixelY := oImpGNRE:nLogPixelY()


RptStatus({|lEnd| GnreProc(@oImpGNRE,@lEnd,cIdEnt,@lExistGnre)},'Imprimindo Gnre...')  

if lExistGnre
	oImpGNRE:Preview()//Visualiza antes de imprimir
else
	Aviso('GNRE','Nenhuma GNRE a ser impressa nos parametros utilizados.',{'OK'},3) 
endif

freeobj(oImpGNRE)
oImpGNRE := nil
RestArea(aArea)
return(.T.)

//-------------------------------------------------------------------
/*/{Protheus.doc} GnreProc
Rotina de impressão GNRE

@since 07/03/2016

/*/
//-------------------------------------------------------------------
static function GnreProc(oImpGNRE,lEnd,cIdEnt,lExistGnre) 

local aAreaSF6		:= {}
local aPerg   		:= {}
local aGnre			:= {}
local aArea			:= GetArea()
local aParam  		:= {space(len(SF6->F6_NUMERO)),space(len(SF6->F6_NUMERO)),Space(Len(SF6->F6_EST))}

local cNaoAut		:= ''
local cAliasGNRE	:= GetNextAlias()
local cGnreIni		:= ''
local cGnreFim		:= ''
local cUFGnre		:= ''
local cWhere		:= ''
local cAutoriza  	:= ''
local cCondicao		:= ''
local cIndex	 	:= ''
local cParGnreImp	:= SM0->M0_CODIGO+SM0->M0_CODFIL+"FISA119IMP"
local cTela			:= "Impressão GNRE " 
local cIdGuia		:= ''
local cXmlGnre		:= ''

local lQuery		:= .F.
local lOkParam		:= .F.

local oGnre			:= nil

local nLenNotas
local nIndex		:= 0
local nX			:= 0


MV_PAR01 := aParam[01] := PadR(ParamLoad(cParGnreImp,aPerg,1,aParam[01]),len(SF6->F6_NUMERO))
MV_PAR02 := aParam[02] := PadR(ParamLoad(cParGnreImp,aPerg,2,aParam[02]),len(SF6->F6_NUMERO))
MV_PAR03 := aParam[03] := PadR(ParamLoad(cParGnreImp,aPerg,3,aParam[03]),Len(SF6->F6_EST))


aadd(aPerg,{1,'Número GNRE Inicial:',aParam[01],'','.T.','','.T.',40,.T.}) 	
aadd(aPerg,{1,"Número GNRE Final:",aParam[02],'','.T.','','.T.',40,.T.})		
aadd(aPerg,{1,"UF : ",aParam[01],'','.T.','12','.T.',40,.F.}) 	

lOkParam 	:= ParamBox(aPerg,cTela,@aParam,,,,,,,cParGnreImp,.T.,.T.)

if lOkParam
	
	cGnreIni	:= alltrim(MV_PAR01)
	cGnreFim	:= alltrim(MV_PAR02)
	cUFGnre	:= alltrim(MV_PAR03)
	
	dbSelectArea("SF6")
	dbSetOrder(1)	
	
	#IFDEF TOP
				
		lQuery		:= .T.
		
		cWhere := "%"		
		cWhere += "SF6.F6_FILIAL = '"+xFilial ("SF6")+"' AND"
		cWhere += " SF6.F6_NUMERO>= '"+ cGnreIni +"' AND SF6.F6_NUMERO<= '"+ cGnreFim +"' " 
		if ! empty(cUFGnre)
			cWhere		+= " AND SF6.F6_EST = '" + cUFGnre + "' " 
		endif 
		cWhere		+= " AND SF6.F6_GNREWS = 'S' "  //Somente autorizada
		cWhere		+= " AND SF6.D_E_L_E_T_ = ''" 
		cWhere		+= ' %' 
		

		BeginSql Alias cAliasGNRE
			SELECT	* FROM  %Table:SF6% SF6 WHERE %Exp:cWhere% ORDER BY %Order:SF6%
		EndSql
							
	#ELSE
		cIndex    		:= CriaTrab(NIL, .F.)
		cChave			:= IndexKey(1)
		cCondicao 		:= 'F6_FILIAL == "' + xFilial("SF6") + '" .And. '
		cCondicao 		+= 'SF6->F6_NUMERO >= "'+ cGnreIni+'" .And. '
		cCondicao 		+= 'SF6->F6_NUMERO <="'+ cGnreFim+'" .And. '
		if ! empty(cUFGnre)
			cCondicao	+= 'SF6->F6_EST =="'+ cUFGnre+'" .And. '
		endif
		cCondicao		+= 'SF6->F6_GNREWS == "S"  '
		IndRegua(cAliasGNRE, cIndex, cChave, , cCondicao)
		nIndex := RetIndex(cAliasMDF)
        dbsetindex(cIndex + OrdBagExt())
        dbsetorder(nIndex + 1)
		dbgotop()
	
	#ENDIF
	
	while !(cAliasGNRE)->(Eof())
		
		aadd(aGnre,{})
		aadd(atail(aGnre),(cAliasGNRE)->F6_IDTSS)  //id TSS
		aadd(atail(aGnre),(cAliasGNRE)->F6_CDBARRA)//Código de Barras
		aadd(atail(aGnre),(cAliasGNRE)->F6_NUMCTRL)//Código de Barras
		
		nRecno	:= (cAliasGNRE)->R_E_C_N_O_
	
		dbselectarea('SF6')
		//Tratamento para campo Memo
		SF6->(dbgoto(nRecno))	
		
		aadd(atail(aGnre),SF6->F6_XMLENV) //XML enviado para TSS
		
		dbclosearea('SF6')
				 				
		(cAliasGNRE)->(dbSkip())
		
	enddo	
		
	if len(aGnre) > 0
		aAreaSF6 := SF6->(GetArea())
				
		for nX := 1 to len(aGnre)
			
			if ! empty( aGnre[nX][2])  //Código de Barras
				
				cIdGuia  := alltrim(aGnre[nX][1])
				cAutoriza:= alltrim(aGnre[nX][2])
				cNumCtrl := alltrim(aGnre[nX][3])
				cXmlGnre := alltrim(aGnre[nX][4])   //xml enviado TSS
				
				ImpDetGnre(@oImpGNRE,cAutoriza,cXmlGnre,cNumCtrl)
				lExistGnre := .T.
				
				oGnre      := nil
			else
			
				cNaoAut += aGnre[nX][1]+aGnre[nX][2]+CRLF
			
			endif
			
		next nX
		
		RestArea(aAreaSF6)
		delclassintf()
	endif
	if !lQuery
		dbclearfilter()
		ferase(cIndex+OrdBagExt())
	endif
	if !Empty(cNaoAut)
		Aviso('GNRE','As seguintes GNREs foram autorizadas, porém não contém Código de Barras: '+CRLF+CRLF+cNaoAut ,{'Ok'},3) 
	endif

endif

RestArea(aArea)
return(.T.)

//----------------------------------------------------------------------
/*/{Protheus.doc} ImpDetGnre
Controle do Fluxo do relatorio.

@since 10/03/2016
@version 1.0 

/*/
//-----------------------------------------------------------------------
static function ImpDetGnre(oImpGNRE, cAutoriza, cXmlGnre, cNumCtrl)
	
private oFont07    	:= TFont():New('Arial',07,07,,.F.,,,,.T.,.F.)	//Fonte Arial 07
private oFont07N   	:= TFont():New('Arial',07,07,,.T.,,,,.T.,.F.)	//Fonte Arial 07
private oFont08		:= TFont():New('Arial',08,08,,.F.,,,,.T.,.F.)
private oFont08N  	:= TFont():New('Arial',08,08,,.T.,,,,.T.,.F.)
private oFont10		:= TFont():New('Arial',10,10,,.F.,,,,.T.,.F.)
private oFont10N  	:= TFont():New('Arial',10,10,,.T.,,,,.T.,.F.)
private oFont12N   	:= TFont():New('Arial',12,12,,.T.,,,,.T.,.F.)	//Fonte Arial 12 Negrito
private oFont14N   	:= TFont():New('Arial',14,14,,.T.,,,,.T.,.F.)	//Fonte Arial 14 Negrito

PrtGnreWS(@oImpGNRE, cAutoriza, cXmlGnre, cNumCtrl)

return(.T.)

//-----------------------------------------------------------------------
/*/{Protheus.doc} PrtDamdfe
Impressao do formulario DANFE grafico conforme laytout no formato retrato

@since 10/03/2016
@version 1.0 

@return .T.
/*/
//-----------------------------------------------------------------------
static function PrtGnreWS(oImpGNRE, cAutoriza, cXmlGnre, cNumCtrl)

local oGnreXml:= nil

local cCab			:= 'Guia Nacional de Recolhimento de Tributos Estaduais - GNRE'
local cUfFav		:= ''
local cCodRec		:= ''
local cRazEmi		:= ''
local cCnpjCpfEm	:= ''
local cEndEmi		:= ''
local cMunEmi		:= ''
local cUfEmi		:= ''	
local cCepEmi		:= ''	
local cTelEmi		:= ''	
local cDocOrig		:= ''
local cCnpjCpfDs	:= ''
local cMunDest		:= ''
local cPerRef		:= ''
local cParcela		:= ''
local cValPrinc		:= ''
local cConvenio		:= ''
local cProduto		:= ''
local cAtuMon		:= ''
local cInfCompl		:= ''
local cJuros		:= ''
local cMulta		:= ''
local cTotRec		:= ''
local cVia			:= ''
local cDtVenc		:= ''

local nX			:= 0
local nBox1			:= 0
local nBox2			:= 0
local nBox3			:= 0
local nBox4			:= 0
local nSay1			:= 0
local nSay2			:= 0

//Inicializacao do objeto grafico 
if oImpGNRE == nil
	lPreview := .T.
	oImpGNRE 	:= FWMSPrinter():New('GNRE', IMP_SPOOL)
	oImpGNRE:SetPortrait()
	oImpGNRE:Setup()
endif
	
//Inicializacao da pagina do objeto grafico
oImpGNRE:StartPage()
nHPage := oImpGNRE:nHorzRes()
nHPage *= (300/PixelX)
nHPage -= HMARGEM
nVPage := oImpGNRE:nVertRes()
nVPage *= (300/PixelY)
nVPage -= VBOX

for nX:= 1 to 2 //Gera via Banco e Contribuinte

	//Alimentando as variáveis
	if ! empty( cXmlGnre )
		oGnreXml := XmlParser(NoAcentReco(cXmlGnre),"","","")
	else //Tratamento casa haja algum erro no retorno do xml
		Alert('Não há dados para imprimir.')
		return
	endif

	// ----------------------------------------------
	// Variáveis de Posicionamento
	// ----------------------------------------------
	nBox1	:= iif(nX==1,0,nBox1 + 50)
	nBox2	:= 000
	nBox3	:= iif(nX==1, 20, nBox3 + 50)
	nBox4	:= 450
	
	nSay1	:= iif(nX==1, 13, nBox1 + 13)
	nSay2	:= iif(nX==1, 80, nBox2 + 80)


	// ----------------------------------------------
	// BOX: Cabeçalho
	// ----------------------------------------------
	oImpGNRE:Box(nBox1,000,nBox3,450,'-6')	
	oImpGNRE:Say(nSay1, nSay2, cCab, oFont12N)  
		
	// ----------------------------------------------
	// BOX: UF Favorecida
	// ----------------------------------------------
	cUfFav 	:= alltrim( oGnreXml:_gnre:_identgnre:_uf:text )
	
	nSay1	:= nBox1 + 8
	nSay1A	:= nBox1 + 16
	
	oImpGNRE:Box(nBox1,450,nBox3,520,'-6')
	oImpGNRE:Say(nSay1, 453, 'UF Favorecida', oFont07N)
	oImpGNRE:Say(nSay1A, 453, cUfFav, oFont08)
	
	// ----------------------------------------------
	// BOX: Código da Receita
	// ----------------------------------------------
	cCodRec	:= alltrim( oGnreXml:_gnre:_identgnre:_receita:text )
		
	oImpGNRE:Box(nBox1,520,nBox3,600,'-6')
	oImpGNRE:Say(nSay1, 523, 'Código da Receita', oFont07N) 
	oImpGNRE:Say(nSay1A, 523, cCodRec, oFont08)  
	
	
	// ----------------------------------------------
	// BOX: Dados do Contribuinte Emitente
	// ----------------------------------------------	
	cRazEmi	:= alltrim( oGnreXml:_gnre:_emitente:_nome:text )
	
	//cnpj/cpf/ie
	if ! empty( oGnreXml:_gnre:_emitente:_cnpjcpf:text )
		cCnpjCpfEm	:= transform(oGnreXml:_gnre:_emitente:_cnpjcpf:text,iif(len(oGnreXml:_gnre:_emitente:_cnpjcpf:text)<>14,"@r 999.999.999-99","@r 99.999.999/9999-99"))
	else
		cCnpjCpfEm	:= alltrim( oGnreXml:_gnre:_emitente:_ie:text )
	endif
	
	cEndEmi	:= alltrim( oGnreXml:_gnre:_emitente:_endereco:text )
	cMunEmi	:= alltrim( oGnreXml:_gnre:_emitente:_descmun:text )
	cUfEmi		:= alltrim( oGnreXml:_gnre:_emitente:_uf:text )
	cCepEmi	:= alltrim( oGnreXml:_gnre:_emitente:_cep:text )
	
	cTelEmi	:= alltrim( oGnreXml:_gnre:_emitente:_telefone:text )
	cTelEmi	:= transform(cTelEmi, iif(len(cTelEmi) == 11, '@R (99) 99999-9999', '@R (99) 9999-9999' ))
	
	oImpGNRE:Box(nBox1 + 20,000,nBox3 + 060,450,'-6')	
	oImpGNRE:Say(nBox1 + 28, 0180, 'Dados do Contribuinte Emitente' , oFont07N)
	oImpGNRE:Say(nBox1 + 36, 0005, 'Razão Social:' , oFont07N)
	oImpGNRE:Say(nBox1 + 46, 0005, cRazEmi , oFont08)
	oImpGNRE:Say(nBox1 + 36, 0350, 'CNPJ/CPF/Insc. Est.:' , oFont07N)
	oImpGNRE:Say(nBox1 + 46, 0350, cCnpjCpfEm , oFont08)
	oImpGNRE:Say(nBox1 + 54, 0005, 'Endereço:' , oFont07N)
	oImpGNRE:Say(nBox1 + 54, 0045, cEndEmi , oFont08)
	oImpGNRE:Say(nBox1 + 64, 0005, 'Município:' , oFont07N)
	oImpGNRE:Say(nBox1 + 64, 0045, cMunEmi , oFont08)
	oImpGNRE:Say(nBox1 + 64, 0350, 'UF:' , oFont07N)
	oImpGNRE:Say(nBox1 + 64, 0365, cUfEmi , oFont08)
	oImpGNRE:Say(nBox1 + 74, 0005, 'CEP:' , oFont07N)
	oImpGNRE:Say(nBox1 + 74, 0025, cCepEmi , oFont08)
	oImpGNRE:Say(nBox1 + 74, 0350, 'Telefone:' , oFont07N)
	oImpGNRE:Say(nBox1 + 74, 0385, cTelEmi , oFont08)
		
	// ----------------------------------------------
	// BOX: Número de Controle
	// ----------------------------------------------
	oImpGNRE:Box(nBox1 + 20,450,nBox3 + 020,600,'-6')
	oImpGNRE:Say(nBox1 + 28, 0453, 'Nº de Controle', oFont07N) 
	oImpGNRE:Say(nBox1 + 36, 0528, cNumCtrl, oFont08)  
	
	// ----------------------------------------------
	// BOX: Data de Vencimento
	// ----------------------------------------------
	cDtVenc := substr(oGnreXml:_gnre:_identgnre:_vencimento:text,7,2)+'/'+ substr(oGnreXml:_gnre:_identgnre:_vencimento:text,5,2)+'/'+ substr(oGnreXml:_gnre:_identgnre:_vencimento:text,1,4)
		
	oImpGNRE:Box(nBox1 + 40,450, nBox3 + 040,600,'-6')
	oImpGNRE:Say(nBox1 + 48, 0453, 'Data de Vencimento', oFont07N) 
	oImpGNRE:Say(nBox1 + 56, 0558, cDtVenc, oFont08)  
	
	// ----------------------------------------------
	// BOX: Nº Documento de Origem
	// ----------------------------------------------
	cDocOrig := transform(oGnreXml:_gnre:_identgnre:_docorig:text,'@R 999999999')
	
	oImpGNRE:Box(nBox1 + 60,450,nBox3 +  060,600,'-6')
	oImpGNRE:Say(nBox1 + 68, 0453, 'Nº Documento de Origem', oFont07N) 
	oImpGNRE:Say(nBox1 + 76, 0558, cDocOrig, oFont08)
	
	
	// ----------------------------------------------
	// BOX: Dados do Destinatário
	// ----------------------------------------------
	//cnpj/cpf/ie
	if ! empty( oGnreXml:_gnre:_destinatario:_cnpjcpf:text )
		cCnpjCpfDs	:= transForm(oGnreXml:_gnre:_destinatario:_cnpjcpf:text,iif(len(oGnreXml:_gnre:_destinatario:_cnpjcpf:text)<>14,"@r 999.999.999-99","@r 99.999.999/9999-99")) 
	else
		cCnpjCpfDs	:= alltrim( oGnreXml:_gnre:_destinatario:_ie:text )
	endif
	
	cMunDest := alltrim( oGnreXml:_gnre:_destinatario:_descmun:text )
	
	
	oImpGNRE:Box(nBox1 + 080, 000, nBox3 + 090, 450, '-6')	
	oImpGNRE:Say(nBox1 + 088, 0180, 'Dados do Destinatário' , oFont07N)
	oImpGNRE:Say(nBox1 + 096, 0005, 'CNPJ/CPF/Insc. Est.:' , oFont07N)
	oImpGNRE:Say(nBox1 + 096, 0080, cCnpjCpfDs , oFont08)
	oImpGNRE:Say(nBox1 + 106, 0005, 'Município:' , oFont07N)
	oImpGNRE:Say(nBox1 + 106, 0080, cMunDest , oFont08)
	
	
	// ----------------------------------------------
	// BOX: Período de Referência
	// ----------------------------------------------
	cPerRef := alltrim( oGnreXml:_gnre:_referencia:_mes:text ) + '/' + alltrim( oGnreXml:_gnre:_referencia:_ano:text )
	
	oImpGNRE:Box(nBox1 + 080,450,nBox3 + 080,530,'-6')
	oImpGNRE:Say(nBox1 + 088, 0453, 'Período de Referência', oFont07N) 
	oImpGNRE:Say(nBox1 + 096, 0500, cPerRef, oFont08) 
	
	
	// ----------------------------------------------
	// BOX: Parcela
	// ----------------------------------------------
	cParcela := alltrim( oGnreXml:_gnre:_referencia:_parcela:text )
	
	oImpGNRE:Box(nBox1 + 080,530,nBox3 + 080,600,'-6')
	oImpGNRE:Say(nBox1 + 088, 0533, 'Parcela', oFont07N) 
	oImpGNRE:Say(nBox1 + 096, 0588, cParcela, oFont08) 
	
	
	// ----------------------------------------------
	// BOX: Valor Principal
	// ----------------------------------------------
	cMascara	:= '@e 9,999,999,999,999.99'
	cValPrinc	:= PadL( 'R$ '+ alltrim(transform(val(oGnreXml:_gnre:_valores:_principal:text), cMascara)),len(cMascara))
	
	oImpGNRE:Box(nBox1 + 100,450,nBox3 + 100,600,'-6')
	oImpGNRE:Say(nBox1 + 108, 0453, 'Valor Principal', oFont07N) 
	oImpGNRE:SayAlign( nBox1 + 108,0500,cValPrinc,oFont08, 96, 19, , 1)
	
	
	// ----------------------------------------------
	// BOX: Reservado a Fiscalização
	// ----------------------------------------------
	cConvenio	:= alltrim( oGnreXml:_gnre:_identgnre:_convenio:text )
	cProduto	:= alltrim( oGnreXml:_gnre:_identgnre:_produto:text )
	
	oImpGNRE:Box(nBox1 + 110, 000, nBox3 + 130, 450, '-6')	
	oImpGNRE:Say(nBox1 + 118, 0180, 'Reservado a Fiscalização' , oFont07N)
	oImpGNRE:Say(nBox1 + 128, 0005, 'Convênio/Protocolo:' , oFont07N)
	oImpGNRE:Say(nBox1 + 128, 0080, cConvenio , oFont08)
	oImpGNRE:Say(nBox1 + 138, 0005, 'Produto:' , oFont07N)
	oImpGNRE:Say(nBox1 + 138, 0080, cProduto , oFont08) 
	
	// ----------------------------------------------
	// BOX: Atualização Monetária
	// ----------------------------------------------
	cAtuMon	:= PadL( 'R$ '+ alltrim(transform(val(oGnreXml:_gnre:_valores:_atumonetaria:text), cMascara)),len(cMascara))
	
	oImpGNRE:Box(nBox1 + 120,450,nBox3 + 120,600,'-6')
	oImpGNRE:Say(nBox1 + 128, 0453, 'Atualização Monetária', oFont07N) 
	oImpGNRE:SayAlign( nBox1 + 128,0500,cAtuMon,oFont08, 96, 19, , 1)
	
	// ----------------------------------------------
	// BOX: Informações Complementares
	// ----------------------------------------------
	cInfCompl := alltrim( oGnreXml:_gnre:_identgnre:_informacoes:text )
	
	oImpGNRE:Box(nBox1 + 140, 000, nBox3 + 180, 450, '-6')	
	oImpGNRE:Say(nBox1 + 148, 0005, 'Informações Complementares' , oFont07N)
	oImpGNRE:Say(nBox1 + 158, 0005, cInfCompl , oFont08)
	oImpGNRE:Say(nBox1 + 194, 0005, 'Documento Válido para pagamento até ' , oFont08N)
	oImpGNRE:Say(nBox1 + 194, 0200, cDtVenc , oFont08) 
	
	// ----------------------------------------------
	// BOX: Juros
	// ----------------------------------------------
	cJuros:= PadL( 'R$ '+ alltrim(transform(val(oGnreXml:_gnre:_valores:_juros:text), cMascara)),len(cMascara))
	
	oImpGNRE:Box(nBox1 + 140,450,nBox3 + 140,600,'-6')
	oImpGNRE:Say(nBox1 + 148, 0453, 'Juros', oFont07N) 
	oImpGNRE:SayAlign( nBox1 + 148,0500,cJuros,oFont08, 96, 19, , 1)
	
	// ----------------------------------------------
	// BOX: Multa
	// ----------------------------------------------
	cMulta:= PadL( 'R$ '+ alltrim(transform(val(oGnreXml:_gnre:_valores:_multa:text), cMascara)),len(cMascara))
		
	oImpGNRE:Box(nBox1 + 160,450,nBox3 + 160,600,'-6')
	oImpGNRE:Say(nBox1 + 168, 0453, 'Multa', oFont07N) 
	oImpGNRE:SayAlign( nBox1 + 168,0500,cMulta,oFont08, 96, 19, , 1)
	
	// ----------------------------------------------
	// BOX: Total a Recolher
	// ----------------------------------------------
	cTotRec:= PadL( 'R$ '+ alltrim(transform(val(oGnreXml:_gnre:_valores:_total:text), cMascara)),len(cMascara))
		
	oImpGNRE:Box(nBox1 + 180,450,nBox3 + 180,600,'-6')
	oImpGNRE:Say(nBox1 + 188, 0453, 'Total a Recolher', oFont07N) 
	oImpGNRE:SayAlign( nBox1 + 188,0500,cTotRec,oFont08, 96, 19, , 1)
	
	// ----------------------------------------------
	// BOX: Código de Barras
	// ----------------------------------------------
	cCodBar := alltrim(cAutoriza)
	cCodBar1 := substr(cCodBar,1,11) + ' '+ substr(cCodBar,12,1) + ' ' + substr(cCodBar,13,11) + ' ' + substr(cCodBar,24,1) + ' '+ substr(cCodBar,25,11) + ' ' +substr(cCodBar,36,1) + ' ' + substr(cCodBar,37,11) + ' ' + substr(cCodBar,48,1)
	oImpGNRE:say(nBox1 + 212, 0035, cCodBar1 , oFont10N)
	nFontSize := 40
	
	// ----------------------------------------------
	// BOX: Codigo de Barras para impressão sem digito  
	// DOMEX
	// ----------------------------------------------
	cCodBar2 := substr(cCodBar,1,11)  // Bloco 1
	cCodBar2 += substr(cCodBar,13,11) // Bloco 2
	cCodBar2 += substr(cCodBar,25,11) // Bloco 3
	cCodBar2 += substr(cCodBar,37,11) // Bloco 4
	
 //oImpGNRE:Code128C(nBox1 + 255,0005,Alltrim(cCodBar) , nFontSize )
	oImpGNRE:Code128C(nBox1 + 255,0005,Alltrim(cCodBar2), nFontSize )
	
	//Via Boleto
	if nX == 1 
		oImpGNRE:say(nBox1 + 215, 0555, '1ª via - Banco' , oFont07)
	else
		oImpGNRE:say(nBox1 + 215, 0540, '2ª via - Contribuinte' , oFont07)
	endif 
	
	//Atribuo a ultima posição no nBox 1 para a via do contribuinte
	
	if nX == 1
	    //linha pontilhada
		oImpGNRE:say(nBox1 + 300, 0000, replicate(' - ',100) , oFont07)
			
		nBox1 := 280
		nBox3 += 280
	endif
	
next

oImpGNRE:EndPage()

return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NoAcentRecoºAutor  ³Danilo.Santos          º Data ³ 20/09/16º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao responsavel por retirar caracteres especiais das     º±±
±±º          ³String                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function NoAcentReco(cXmlGnre)

Local cByte,ni
Local s1:= "áéíóú" + "ÁÉÍÓÚ" + "âêîôû" + "ÂÊÎÔÛ" + "äëïöü" + "ÄËÏÖÜ" + "àèìòù" + "ÀÈÌÒÙ"  + "ãõÃÕ" + "çÇ"
Local s2:= "aeiou" + "AEIOU" + "aeiou" + "AEIOU" + "aeiou" + "AEIOU" + "aeiou" + "AEIOU"  + "aoAO" + "cC"
Local nPos:=0, nByte
Local cRet:=''
Default cXmlGnre := ""

cXmlGnre := (StrTran(cXmlGnre,"&","&amp;")) 

For ni := 1 To Len(cXmlGnre)
	cByte := Substr(cXmlGnre,ni,1)
	nByte := ASC(cByte)
	If nByte > 122 .Or. nByte < 48 .Or. ( nByte > 57 .And. nByte < 65 ) .Or. ( nByte > 90 .And. nByte < 97 )
		nPos := At(cByte,s1)
		If nPos > 0
			cByte := Substr(s2,nPos,1)
		Else
			If cByte $ "<"
				cByte := "<"
			Elseif cByte $ ">"
				cByte := ">"
			Elseif cByte $ "/"
				cByte := "/"
			Endif

		EndIf
	EndIf
	cRet+=cByte
Next

Return(AllTrim(cRet))

