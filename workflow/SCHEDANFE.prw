#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "tbiconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SCHEDANFE�Autor  � Michel A. Sander   � Data �  18/10/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Agendamento para impress�o autom�tica de DANFE             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SCHEDANFE()

Local cQuery := ""
Local cKebra := Chr(13)+Chr(10)
Local aAbreTab := {}
Local aWfItens := {}
Local aWfEmpre := {}
Local cChave   := ""
Local lGuiaOk := .F.
Local cWfEmp := "01"
Local cWfFil := "01"
Local lEnvExped   := .T.

Private cVlrTotal := 0
Private cPathGuia := "\SYSTEM\GNRE_PDF\"

//������������������������������������������������������Ŀ
//�Prepara fun��o para ser executada via JOB/Schedule		�
//��������������������������������������������������������
If Type("cEmpAnt") == "U"
	RPCSetType(3)
	aAbreTab := {}
	RpcSetEnv(cWfEmp,cWfFil,,,,,aAbreTab)
	SetUserDefault("000000")
EndIf

CONOUT("Iniciando SCHEDANFE Dia: "+Dtoc(dDataBase)+" Hora: "+Time())

// A PRIMEIRA PARTE FOI SEPARADA NO FONTE PRTDANFE.prw PARA NOTAS FISCAIS COM GUIA GNRE = "S"
//���������������������������������������������������������������Ŀ
//� Busca as notas com emiss�o pelo coletor de dados 					�
//�����������������������������������������������������������������
//cAliasSF2 := GetNextAlias()

//BeginSQL Alias cAliasSF2
	
//	SELECT F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_NFICMST, F2_XXGUIA From %table:SF2% SF2 (NOLOCK), SPED050 (NOLOCK)
//	WHERE F2_XCOLET = 'S'
//	AND F2_XXAUTNF = 'N'
//	AND ID_ENT = '000002'
//	AND F2_SERIE + F2_DOC = NFE_ID
//	AND STATUS = '6' 
//	AND SF2.%NotDel%
	
//EndSQL

//������������������������������������������������������Ŀ
//�Gera a DANFE para impress�o de NF sem guia	   		�
//��������������������������������������������������������
//SF6->(dbSetOrder(3))
//Do While (cAliasSF2)->(!Eof())
	
	//�������������������������������������������Ŀ
	//�Imprime comprovante GNRE pago					 �
	//���������������������������������������������
	//If (cAliasSF2)->F2_XXGUIA <> "S"
		
	//	CONOUT("Imprimindo DANFE via SCHEDANFE para NFe - "+(cAliasSF2)->F2_DOC)
	//	lEnvExped := .T.
	//	cDanfeDoc := U_PDFDanfe((cAliasSF2)->F2_DOC,(cAliasSF2)->F2_SERIE, lEnvExped) // Imprime DANFE direto na expedi��o
		
	//EndIf
	
	//(cAliasSF2)->(dbSkip())
	
//EndDo

//(cAliasSF2)->(DbCloseArea())

//���������������������������������������������������������������Ŀ
//�SEGUNDA PARTE																	�
//�																					�
//� NFs autorizadas COM GUIA GNRE n�o TRANSMITIDA 						�
//�����������������������������������������������������������������
cAliasSF2 := GetNextAlias()
sDataIni  := DtoS(Date()-1)

BeginSQL Alias cAliasSF2
	
	SELECT F2_FILIAL,
	F2_DOC,
	F2_SERIE,
	F2_CLIENTE,
	F2_LOJA,
	F2_FIMP,
	F2_EMISSAO,
	F2_EST,
	IsNull(F6_FILIAL,'') F6_FILIAL,
	IsNull(F6_NUMERO,'') F6_NUMERO,
	IsNull(F6_DOC,'') F6_DOC,
	IsNull(F6_SERIE,'') F6_SERIE,
	IsNull(F6_CLIFOR,'') F6_LOJA,
	IsNull(F6_GNREWS,'') F6_GNREWS,
	IsNull(F6_VALOR,0) F6_VALOR,
	IsNull(F6_EST,'') F6_EST,
	SF6.R_E_C_N_O_ SF6RECNO
	FROM %table:SF2% SF2 (NOLOCK) LEFT JOIN %table:SF6% SF6 (NOLOCK)
	ON SF2.D_E_L_E_T_='' AND SF6.D_E_L_E_T_=''
	AND F2_FILIAL=F6_FILIAL
	AND F2_DOC=F6_DOC
	AND F2_SERIE=F6_SERIE
	AND F2_CLIENTE=F6_CLIFOR
	AND F2_LOJA=F6_LOJA
	AND F6_EST <> 'RJ'
	JOIN SPED050 ON ID_ENT='000002' AND SF2.F2_SERIE+SF2.F2_DOC = NFE_ID AND STATUS='6'
	WHERE F2_SERIE='001' AND F2_XXGUIA='S' AND F6_GNREWS IN ('','N') AND F2_EMISSAO >= %Exp:sDataIni%
	ORDER BY F2_DOC
	
EndSQL

Do While (cAliasSF2)->(!Eof())
	
	cTpOper  := "2"		// Nota Fiscal de Saida
	cTpDoc   := "N"      // Tipo de Documento (N= Normal)
	cAmbGnre := "1"		// Ambiente WebServices (1=Ambiente Produ��o 2=Ambiente Homologa��o)
	
	//������������������������������������������������������Ŀ
	//�Caso a guia seja rejeitada, reenvia							�
	//��������������������������������������������������������
	If (cAliasSF2)->F6_GNREWS == "N"
		
		//������������������������������������������������������Ŀ
		//�N�o enviar RJ(at� que resolva o servi�o para o estado)�
		//��������������������������������������������������������
		If (cAliasSF2)->F6_EST == "RJ"
			(cAliasSF2)->(dbSkip())
			Loop
		EndIf
		
		//SF6->(dbSetOrder(1))
		//If dbSeek(xFilial("SF6")+(cAliasSF2)->F6_IDTSS)
		SF6->( dbGoTo((cAliasSF2)->SF6RECNO) )
		If SF6->( Recno() ) == (cAliasSF2)->SF6RECNO
			RecLock("SF6",.F.)
			SF6->F6_GNREWS  := ""
			SF6->F6_RECIBO  := ""
			SF6->F6_CDBARRA := ""
			SF6->F6_NUMCTRL := ""
			SF6->( MsUnlock() )
		EndIf
		//EndIf
		
	EndIf
	
	//������������������������������������������������������Ŀ
	//�Envie guia GNRE													�
	//��������������������������������������������������������
	CONOUT("Transmitindo GNRE via SCHEDANFE para NFe - "+(cAliasSF2)->F2_DOC)
	lEnvGnre := U_GnreTrans((cAliasSF2)->F6_NUMERO, (cAliasSF2)->F6_NUMERO, cAmbGnre, .T., (cAliasSF2)->F2_EST) // Trasnmiss�o da Guia
	
	(cAliasSF2)->(dbSkip())
	
EndDo

(cAliasSF2)->(DbCloseArea())

//���������������������������������������������������������������Ŀ
//�TERCEIRA PARTE																	�
//�																					�
//� NFs autorizadas COM GUIA GNRE TRANSMITIDA monitorando retorno	�
//�����������������������������������������������������������������

cAliasTRF := GetNextAlias()

BeginSQL Alias cAliasTRF
	
	SELECT F2_FILIAL,
	F2_DOC,
	F2_SERIE,
	F2_CLIENTE,
	F2_LOJA,
	F2_FIMP,
	F2_EMISSAO,
	F2_EST,
	IsNull(F6_FILIAL,'') F6_FILIAL,
	IsNull(F6_NUMERO,'') F6_NUMERO,
	IsNull(F6_DOC,'') F6_DOC,
	IsNull(F6_SERIE,'') F6_SERIE,
	IsNull(F6_CLIFOR,'') F6_LOJA,
	IsNull(F6_GNREWS,'') F6_GNREWS,
	IsNull(F6_IDTSS,'') F6_IDTSS,
	IsNull(F6_VALOR,0) F6_VALOR
	FROM %table:SF2% SF2 (NOLOCK) LEFT JOIN %table:SF6% SF6 (NOLOCK)
	ON SF2.D_E_L_E_T_='' AND SF6.D_E_L_E_T_=''
	AND F2_FILIAL=F6_FILIAL
	AND F2_DOC=F6_DOC
	AND F2_SERIE=F6_SERIE
	AND F2_CLIENTE=F6_CLIFOR
	AND F2_LOJA=F6_LOJA
	JOIN SPED050 ON ID_ENT='000002' AND SF2.F2_SERIE+SF2.F2_DOC = NFE_ID AND STATUS='6'
	WHERE F2_SERIE='001' AND F2_XXGUIA='S' AND F6_GNREWS='T' AND F2_EMISSAO >= %Exp:sDataIni%
	ORDER BY F2_DOC
	
EndSQL

//���������������������������������������������������������������Ŀ
//�Vari�veis ambientais para o Webservices						    	�
//�����������������������������������������������������������������
cAmbGnre := "1"
cUrl     := Padr(GetNewPar("MV_SPEDURL","http://"),250)
cAviso   := ""

Do While (cAliasTRF)->(!Eof())
	
	//���������������������������������������������������������������Ŀ
	//�Verifica o retorno da guia no Webservices						    	�
	//�����������������������������������������������������������������
	aRetGnre := RetGnre(cUrl, (cAliasTRF)->F6_IDTSS, (cAliasTRF)->F6_IDTSS, cAmbGNRE ,cAviso)
	(cAliasTRF)->(dbSkip())
	
EndDo

(cAliasTRF)->(dbCloseArea())

//���������������������������������������������������������������Ŀ
//�QUARTA PARTE																	�
//�																					�
//� NFs autorizadas COM GUIA AUTORIZADA									�
//�����������������������������������������������������������������
cAliasSF6 := GetNextAlias()

BeginSQL Alias cAliasSF6
	
	SELECT F6_FILIAL, F6_NUMERO, F6_DOC, F6_SERIE, F6_CLIFOR, F6_LOJA, F6_VALOR FROM %table:SF6% SF6 (NOLOCK)
	WHERE SF6.%NotDel% AND
	F6_GNREWS   = 'S' AND
	F6_CDBARRA <> ''  AND
	F6_OBSERV   = '' AND 
	F6_DTARREC >= %Exp:sDataIni%
	
EndSQL

Do While (cAliasSF6)->(!Eof())
	
	cNomeGuia := U_PDFGNRE( (cAliasSF6)->F6_NUMERO, (cAliasSF6)->F6_DOC, (cAliasSF6)->F6_SERIE, (cAliasSF6)->F6_CLIFOR, (cAliasSF6)->F6_LOJA )
	
	If !Empty(cNomeGuia)
		
		//�������������������������������������������������������������������Ŀ
		//�Envia e-mail ao departamento fiscal sobre GNRE                     �
		//���������������������������������������������������������������������
		
		cAssunto  := "GUIA GNRE AUTORIZADA " + Substr((cAliasSF6)->F6_NUMERO,4)
		cTexto    := "Gerada guia GNRE para pagamento : " + SUBSTR((cAliasSF6)->F6_NUMERO,4) + Chr(13)+Chr(10)
		cTexto    += Chr(13)+Chr(10)
		cTexto    += "Nota Fiscal   " + (cAliasSF6)->F6_DOC   + Chr(13)+Chr(10)
		cTexto    += "Serie         " + (cAliasSF6)->F6_SERIE + Chr(13)+Chr(10)
		cTexto    += "Valor da Guia " + TransForm((cAliasSF6)->F6_VALOR,"@E 999,999,999.99")
		cPara     := "patricia.vieira@rdt.com.br;denis.vieira@rdt.com.br;priscila.silva@rosenbergerdomex.com.br;ludmila.guimaraes@rosenbergerdomex.com.br"
		cCC       := ""
		cArquivo  := "D:\TOTVS12\01-Oficial\Protheus_Data"+cPathGuia+cNomeGuia
		U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
		
	EndIf
	
	(cAliasSF6)->(dbSkip())
	
EndDo

(cAliasSF6)->(dbCloseArea())

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RetGnre   �Autor  � Michel A. Sander   � Data �  18/10/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Monitora o Status da GNRE							              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function RetGnre(cUrl, cIdIni, cIdFim, cAmbGNRE ,cAviso)

local aRetMnt		:= {}
local cIdGNRE		:= ""
local cAmb			:= ""
local cDesc			:= ""
local cRecibo		:= ""
local cResultado	:= ""
local cLote			:= ""
local cStatus		:= ""
local cHrEnvSef	:= ""
local cHrEnvTSS	:= ""
local cHrRecSef	:= ""
local cXMLErro		:= ""
local cNumContro	:= ""
local cCodBarras	:= ""
local dDtEnvSef	:= SToD ("  /  /  ")
local dDtEnvTSS	:= SToD ("  /  /  ")
local dDtRecSef	:= SToD ("  /  /  ")
local lOk			:= .F.
local nX				:= 0
Local cIdEnt		:= "000002"

default cUrl		:= ""
default cIdIni		:= ""
default cIdFim 	:= ""
default cAmbGNRE	:= ""
default cAviso		:= ""

oWS:= WSTSSGNRE():New()
oWS:cUSERTOKEN := "TOTVS"
oWS:cIDENT 	   := cIdEnt
oWS:cAMBIENTE  := cAmbGNRE
oWS:_URL		   := AllTrim(cURL)+"/TSSGNRE.apw"
oWS:cIDINI		:= cIdIni
oWS:cIDFIM		:= cIdFim
oWS:oWSMONITORRESULT:oWSDOCUMENTOS := TSSGNRE_ARRAYOFMONITORRETDOC():New()

aadd(oWS:oWSMONITORRESULT:oWSDOCUMENTOS:oWSMONITORRETDOC,TSSGNRE_MONITORRETDOC():New())

lOk := oWS:MONITOR()

if (lOk <> nil .Or. lOk) .And. type("oWS:OWSMONITORRESULT:OWSDOCUMENTOS:OWSMONITORRETDOC")<>"U"
	
	oRetorno:=	oWS:OWSMONITORRESULT:OWSDOCUMENTOS:OWSMONITORRETDOC
	
	for nX:= 1 to len( oRetorno )
		
		cIdGNRE	   := oRetorno[nX]:CID
		cAmb		   := oRetorno[nX]:CAMBIENTE
		cDesc		   := oRetorno[nX]:CDESCRICAO
		cRecibo		:= oRetorno[nX]:CRECIBO
		cResultado	:= oRetorno[nX]:CRESULTADO
		cLote		   := oRetorno[nX]:CLOTE
		cStatus		:= oRetorno[nX]:CSTATUS
		cHrEnvSef	:= oRetorno[nX]:CHRENVSEF
		cHrEnvTSS	:= oRetorno[nX]:CHRENVTSS
		cHrRecSef	:= oRetorno[nX]:CHRRECSEF
		dDtEnvSef	:= oRetorno[nX]:DDTENVSEF
		dDtEnvTSS	:= oRetorno[nX]:DDTENVTSS
		dDtRecSef	:= oRetorno[nX]:DDTRECSEF
		cXMLErro   	:= oRetorno[nX]:CXMLERRO
		cNumContro	:= oRetorno[nX]:CNUMCONTRO
		cCodBarras	:= oRetorno[nX]:CCODBARRAS
		
		//dados para atualiza��o da base
		aadd(aRetMnt, {	cIdGNRE,;
		cAmb,;
		cDesc,;
		cRecibo,;
		cResultado,;
		cLote,;
		cStatus,;
		cHrEnvSef,;
		cHrEnvTSS,;
		cHrRecSef,;
		dDtEnvSef,;
		dDtEnvTSS,;
		dDtRecSef,;
		cXMLErro,;
		cNumContro,;
		cCodBarras})
		
		//Se o retorno for N�o autorizado / Autorizado pela SEFAZ atualizo a SF6
		If cStatus $"4#5"
			
			dbSelectArea("SF6")
			SF6->(dbSetOrder(1))
			
			If dbSeek(xFilial("SF6")+subStr(cIdGnre,1,2)+subStr(cIdGnre,3,len(cIdGnre)-2))
				RecLock("SF6")
				SF6->F6_GNREWS := IIF(cStatus=='5',"S","N")
				SF6->F6_RECIBO := cRecibo
				SF6->F6_CDBARRA:= cCodBarras
				SF6->F6_NUMCTRL:= cNumContro
				SF6->(MsUnlock())
			Endif
			
		EndIf
		
	Next
	
Endif

Return ( aRetMnt )
