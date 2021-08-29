#include 'rwmake.ch'
#include 'tbiconn.ch'
#include 'tbicode.ch'
#include "totvs.ch"     

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EnvMailto �Autor  �Helio Ferreira      � Data �  18/11/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o gen�rica de envio de e-mail                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
����������������lRet���������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

USER Function EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo,lUsaWorkflow)

LOCAL cAnexos := ''
LOCAL x
LOCAL n
LOCAl cPath
Private lOkEnv := .F.
default lUsaWorkflow := .T.		// .T. Via Processo Workflow  .F. Via Send Mail direto   


//LOCAL lUsaWorkflow := .T.		// .T. Via Processo Workflow  .F. Via Send Mail direto

Private oProcess

//Default cCC      := ""
Default cArquivo := ""

//�����������������������������������������������������������������������������Ŀ
//�Verifica se utiliza TWFProcess ou SEND MAIL											  �
//�������������������������������������������������������������������������������
If lUsaWorkflow
	
	oProcess:=TWFProcess():New("00001",OemToAnsi(cAssunto))
	oProcess:NewTask("000001","\workflow\basico2.htm")
	oHtml:=oProcess:oHtml
	
	oProcess:ClientName( Substr(cUsuario,7,15) )
	oProcess:cTo      := cPara 
	oProcess:cCC      := cCC
	oProcess:UserSiga := "000000"
	oProcess:cSubject := cAssunto
	
	cArquivo := Alltrim(cArquivo)
	
	n:=0
	For x := 1 to len(cArquivo)
		If Substr(cArquivo,x,1) == '\'
			n := x
		EndIf
	Next x
	
	cPath    := Substr(cArquivo,1,n)
	cArquivo := Substr(cArquivo,n+1)
	
	If File(cPath+cArquivo)
		cNewGetFile := "\temp_anexos\"+cArquivo
		If File(cNewGetFile)
			fErase(cNewGetFile)
		EndIf
		COPY File &(cPath+cArquivo) TO &cNewGetFile
		cGetFile := cNewGetFile
		
		cAnexos += cGetFile
		If File(cAnexos)
			oProcess:AttachFile( cAnexos )
			oProcess:oHtml:ValByName( "variavel"	   , cTexto)
			lOkEnv := .T.
		Else
			apMsgStop("Arquivo n�o encontrado para ser anexado ao e-mail: " + cAnexos)
			oProcess:oHtml:ValByName( "variavel"	   , "Arquivo n�o encontrado para ser anexado ao e-mail!")
		EndIf
		
	Else
		If !Empty(cArquivo)
			oProcess:oHtml:ValByName( "variavel"	   , cTexto + '   Arquivo ' + cArquivo + ' n�o encontrado para anexar ao e-mail!')
		Else
			oProcess:oHtml:ValByName( "variavel"	   , cTexto  )
			lOkEnv := .T.
		EndIf		
	EndIf
	
	
	oProcess:Start()
	oProcess:Finish()
	
Else
	
	//�����������������������������������������������������������������������������Ŀ
	//�Prepara variaveis																				  �
	//�������������������������������������������������������������������������������
	aArea     := GetArea()
	cEmailTo  := ""								// E-mail de destino
	cEmailBcc := ""								// E-mail de copia
	lResult   := .F.								// Se a conexao com o SMPT esta ok
	cError    := ""								// String de erro
	lRelauth  := SuperGetMv("MV_RELAUTH",, .F.)	// Parametro que indica se existe autenticacao no e-mail
	lRet	    := .F.								// Se tem autorizacao para o envio de e-mail
	cCtaAut   := Trim(GetMV('MV_RELAUSR')) 		// usuario para Autenticacao Ex.: fuladetal
	cConta    := Trim(GetMV('MV_RELACNT')) 		// Conta Autenticacao Ex.: fuladetal@fulano.com.br
	cPsw      := Trim(GetMV('MV_RELAPSW')) 		// Senha de acesso Ex.: 123abc
	cServer   := Trim(GetMV('MV_RELSERV')) 		// Ex.: smtp.ig.com.br ou 200.181.100.51
	cFrom	    := Trim(GetMV('MV_RELFROM')) 		// e-mail utilizado no campo From'MV_RELACNT' ou 'MV_RELFROM' e 'MV_RELPSW'
	nCntFor   := 0
	cArquivo  := Alltrim(cArquivo)
	
	//�����������������������������������������������������������������������������Ŀ
	//�Prepara arquivo para ser anexado ao e-mail											  �
	//�������������������������������������������������������������������������������
	n:=0
	For x := 1 to len(cArquivo)
		If Substr(cArquivo,x,1) == '\'
			n := x
		EndIf
	Next x
	
	cPath    := Substr(cArquivo,1,n)
	cArquivo := Substr(cArquivo,n+1)
	
	If File(cPath+cArquivo)
		
		cNewGetFile := "\temp_anexos\"+cArquivo
		If File(cNewGetFile)
			fErase(cNewGetFile)
		EndIf
		COPY File &(cPath+cArquivo) TO &cNewGetFile
		cGetFile := cNewGetFile
		cAnexos += cGetFile
		
	EndIf
	
	//�����������������������������������������������������������������������������Ŀ
	//�Conex�o com SMTP.																				  �
	//�������������������������������������������������������������������������������
	CONOUT("OPUSVP MAIL "+Dtoc(Date())+" "+Time()+" - Conectando com servidor SMTP...")
	CONNECT SMTP SERVER cServer ACCOUNT cConta PASSWORD cPsw RESULT lResult
	
	//�����������������������������������������������������������������������������Ŀ
	//�Verifica conexao com SMTP																	  �
	//�������������������������������������������������������������������������������
	If lResult
		
		//�����������������������������������������������������������������������������Ŀ
		//�Verifica autenticacao.																		  �
		//�������������������������������������������������������������������������������
		If lRelauth
			lRet := Mailauth( cCtaAut, cPsw )
		Else
			lRet := .T.
		Endif
		
		If lRet
			
  
			//  ENVIA EMAIL EXTERNO SOMENTE SE FOR AMBIENTE DE PRODUCAO ROSENGERGER   
			If !(Upper(Alltrim(Getenvserv())) $ 'ROSENBERGER') 
				cPara :=  "denis.vieira@rdt.com.br"
				cCC	:=  "denis.vieira@rdt.com.br"   
			endif
		
		
			//�����������������������������������������������������������������������������Ŀ
			//�Envia e-mail verificando anexo															  �
			//�������������������������������������������������������������������������������
			If File(cAnexos)
				CONOUT("OPUS VP MAIL "+Dtoc(Date())+" "+Time()+" - Enviando e-mail para: "+cPara)
				CONOUT("OPUS VP MAIL "+Dtoc(Date())+" "+Time()+" - Enviando e-mail copia:"+cCC)
				CONOUT("OPUS VP MAIL "+Dtoc(Date())+" "+Time()+" - Assunto:              "+cPara)
				SEND MAIL;
				FROM 		cFrom;
				TO      	cPara;
				BCC     	cCC;
				SUBJECT 	cAssunto;
				BODY    	cTexto;
				ATTACHMENT  cAnexos;
				RESULT 		lResult
			Else
				CONOUT("OPUS VP MAIL "+Dtoc(Date())+" "+Time()+" - Enviando e-mail para: "+cPara)
			   CONOUT("OPUS VP MAIL "+Dtoc(Date())+" "+Time()+" - Enviando e-mail copia:"+cCC)
				CONOUT("OPUS VP MAIL "+Dtoc(Date())+" "+Time()+" - Assunto:              "+cPara)
				SEND MAIL;
				FROM 		cFrom;
				TO      	cPara;
				BCC     	cCC;
				SUBJECT 	cAssunto;
				BODY    	cTexto;
				RESULT	lResult
			EndIf

			//�����������������������������������������������������������������������������Ŀ
			//�Verifica erro de envio.																		  �
			//�������������������������������������������������������������������������������
			If !lResult
				GET MAIL ERROR cError
				CONOUT("OPUS VP MAIL "+Dtoc(Date())+" "+Time()+" - Erro no envio de e-mail: "+cError)
			Else
				lOkEnv := .T.
			Endif
			
		Else
			
			//�����������������������������������������������������������������������������Ŀ
			//�Verifica erro de autenticacao																  �
			//�������������������������������������������������������������������������������
			GET MAIL ERROR cError
			CONOUT("OPUS VP MAIL "+Dtoc(Date())+" "+Time()+" - Erro de autenticacao: "+cError)
			
		Endif
		
		//�����������������������������������������������������������������������������Ŀ
		//�Desconecta com SMTP.																			  �
		//�������������������������������������������������������������������������������
		CONOUT("OPUS VP MAIL "+Dtoc(Date())+" "+Time()+" - Desconectando com servidor SMTP...")
		DISCONNECT SMTP SERVER
		
	Else
		
		//�����������������������������������������������������������������������������Ŀ
		//�Verifica erro com SMTP.																		  �
		//�������������������������������������������������������������������������������
		GET MAIL ERROR cError
		CONOUT("OPUS VP MAIL "+Dtoc(Date())+" "+Time()+" - Erro de conexao com servidor SMTP: "+cError)

	Endif
	
	RestArea( aArea )
	
EndIf

Return lOkEnv

//Local nLineSize     := 60
//Local nTabSize      := 3
//Local lWrap         := .T.
//Local nLine         := 0
//Local lServErro	  := .f.
//LOCAL cIP
//Local nI
//Private lConectou   := .F.
//Private lEnviado    := .F.
//Private cDe         := "workflow@opusvp.com.br"
//Private cSerMail	:=  "webmail.opusvp.com.br"//GETMV("MV_RELSERV")

//Usar TWFProcess()
/*
lServERRO 	:= .F.
cIP := SPACE(0)
FOR nI := 1 TO LEN(ALLTRIM(cSerMail))
	IF SUBSTRING(cSermail,nI,1)= ":"
		EXIT
	ENDIF
	cIP += SUBSTRING(cSermail,nI,1)
NEXT nI
cSerMail 	:= "webmail.opusvp.com.br"//GETMV("MV_RELSERV")
cSenha1		:= "workflowopusvp"
_xx			:= 0

Do While !lConectou
	//    CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword
	CONNECT SMTP SERVER cSerMail ACCOUNT cde PASSWORD cSenha1 Result lConectou
	_xx += 1
	If _xx > 9 // Tenta 10 vezes
		Conout("Nao conectou ")
		Exit
	Endif
Enddo

cDe     := Rtrim(cDe)
cPara   := Rtrim(cPara)
cAssunto:= Rtrim(cAssunto)
cArquivo:= Rtrim(cArquivo)
cCC	  := Rtrim(cCC)
_xx := 0
Do While !lEnviado
	If !Empty(cCC)
		If Empty(cArquivo)
			SEND MAIL FROM cDe To cPara CC cCC SUBJECT cAssunto Body cTexto FORMAT TEXT RESULT lEnviado
		Else
			//SEND MAIL FROM cDe To cPara CC cCC SUBJECT cAssunto Body cTexto Attachment cArquivo FORMAT TEXT RESULT lEnviado
			SEND MAIL FROM cDe To cPara CC cCC SUBJECT cAssunto Body cTexto FORMAT TEXT ATTACHMENT cArquivo  RESULT lEnviado
		EndIf
	Else
		If Empty(cArquivo)
			SEND MAIL FROM cDe To cPara SUBJECT	cAssunto Body cTexto FORMAT TEXT RESULT lEnviado
			
			Conout("Enviou ")
		Else
			SEND MAIL FROM cDe To cPara SUBJECT	cAssunto Body cTexto Attachment cArquivo FORMAT TEXT RESULT lEnviado
			
			Conout("Enviou ")
		EndIf
	EndIF
	_xx += 1
	If _xx > 9
		Conout("Nao enviou ")
		Exit
	Endif
Enddo

DISCONNECT SMTP SERVER
*/
