#include "rwmake.ch"
#include "totvs.ch"
#include 'tbiconn.ch'
#include 'tbicode.ch'
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MRSXML05  ºAutor  ³Marco Aurelio       º Data ³  09/07/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ FUNCOES Auxiliares do GESTOR XML                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/



//======================================================================================================================
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ 												³
//³ ##  Retorna a TES INTELIGENTE de Entrada  ##  	³
//³ 												³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function ReTesENT(_cProd,_cFornec,_cLojaFor,_cOper,cChvCTE)

Local cTab4 := AllTrim(GetMV("MX_MRALS04"))
Local cAls4 := IIf(SubStr(cTab4,1,1)=="S",SubStr(cTab4,2,2),cTab4)

Local _cTes   := space(03)
Local _xTESENT := space(03)
Local _TESINT  := {_cTes,.F.,"","",0} // TES, VALIDADA OU NÃO, PEDIDO, ITEM, REGRA 1 2 OU 3
Local aAreaGER := GetArea()
Local aAreaTES := (cTab4)->(GetArea())
Local aAreaSB1 := SB1->( GetArea() )

(cTab4)->( dbSetOrder(1) )
If (cTab4)->( dbSeek(xfilial(cTab4)+_cProd+_cFornec+_cLojaFor+_cOper) )
	
	If (cTab4)->&(cAls4+"_CTE") == 'S' .and.  !empty(Alltrim(cChvCTE))	// Operacao exclusiva para CTE (considera CFOP informada no cadastro)
		
		// Busca Chave no SD2
		cQuery := " SELECT DISTINCT D2_CF FROM "+RetSqlName("SD2")+" WHERE D_E_L_E_T_ = '' AND  D2_FILIAL+D2_SERIE+D2_DOC IN "
		cQuery += "(SELECT F2_FILIAL+F2_SERIE+F2_DOC FROM "+RetSqlName("SF2")+" WHERE F2_CHVNFE = '"+Alltrim(cChvCTE)+"' AND D_E_L_E_T_ = '') "
		
		If Select("TRBCTE") <> 0
			TRBCTE->( dbCloseArea() )
		EndIf
		
		TCQUERY cQuery NEW ALIAS "TRBCTE"
		
		cCfoCTE := TRBCTE->D2_CF
		
		If !Empty(cCfoCTE)
			While !(cTab4)->( EOF() ) .and. (cTab4)->&(cAls4+"_FORNEC") == _cFornec .and. (cTab4)->&(cAls4+"_LOJAFO") == _cLojaFor .and. (cTab4)->&(cAls4+"_TIPO") == _cOper
				If (cTab4)->&(cAls4+"_CTE") == "S"
					If Alltrim(cCfoCTE) $ (cTab4)->&(cAls4+"_CFOP1") .or.  Alltrim(cCfoCTE) $ (cTab4)->&(cAls4+"_CFOP2")
						_TESINT[1]	:= (cTab4)->&(cAls4+"_TES1")
						_xTESENT	:=  (cTab4)->&(cAls4+"_TES1")
						Exit
					EndIf
				EndIf
				(cTab4)->( dbSkip() )
			End
		EndIf

		/*
		// Se o CFOP estiver no Campo1, retorna TES1
		If cCfoCTE $ (cTab4)->&(cAls4+"_CFOP1")
		_TESINT[1]	:= (cTab4)->&(cAls4+"_TES1")
		_xTESENT	   :=  (cTab4)->&(cAls4+"_TES1")
		// Se o CFOp estiver no Campo 2, retorna TES2
		elseif  cCfoCTE $ (cTab4)->&(cAls4+"_CFOP2")
		_TESINT[1]	:= (cTab4)->&(cAls4+"_TES2")
		_xTESENT	   :=  (cTab4)->&(cAls4+"_TES2")
		// Senao, mantem TES ORIGINAL
		else
		_TESINT[1]	:= _cTes			// Mantem TES original
		_xTESENT  	:= _cTes
		endif
		*/
		
	else    // Operacao Normal
		
		_TESINT[1]	:= (cTab4)->&(cAls4+"_TES1")
		_xTESENT		:= (cTab4)->&(cAls4+"_TES1")
		If (cTab4)->&(cAls4+"_VALID1") == '1'	// Se ja foi validada
			_TESINT[2] := .T.
			_TESINT[3] := (cTab4)->&(cAls4+"_PV1")
			_TESINT[4] := (cTab4)->&(cAls4+"_IT1")
			_TESINT[5] := 1
		else
			_TESINT[2] := .F.
			_TESINT[3] := ""
			_TESINT[4] := ""
			_TESINT[5] := 1
		endif
	Endif
Else
	_TESINT[1]	:= _cTes			   			// Mantem TES original
	_xTESENT	:= _cTes
Endif

RestArea(aAreaTES)
RestArea(aAreaSB1)
RestArea(aAreaGER)
  

Return _xTESENT //_TESINT[1]


//======================================================================================================================
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ 																³
//³ ##  Envia EMAIL GestorXML    ##					  	³
//³ 																³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function MRSMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

Local cAnexos := ''
Local x
Local n
Local cPath
Local lUsaWorkflow := .T.		// .T. Via Processo Workflow  .F. Via Send Mail direto

Private oProcess

Default cCC      := ""
Default cArquivo := ""



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se for DIPACK,  na usa email por WorkFlow³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if lCliDIP .or.  lCliTay
	lUsaWorkflow := .F.
endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se utiliza TWFProcess ou SEND MAIL											  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lUsaWorkflow
	
	oProcess:=TWFProcess():New("00001",OemToAnsi(cAssunto))
	oProcess:NewTask("000001","\workflow\basico2.htm")
	oHtml:=oProcess:oHtml
	
	oProcess:ClientName( Subs(cUsuario,7,15) )
	oProcess:cTo      := cPara
	oProcess:UserSiga := "000000"
	oProcess:cSubject := cAssunto
	
	cArquivo := Alltrim(cArquivo)
	
	n:=0
	For x := 1 to len(cArquivo)
		If Subs(cArquivo,x,1) == '\'
			n := x
		EndIf
	Next x
	
	cPath    := Subs(cArquivo,1,n)
	cArquivo := Subs(cArquivo,n+1)
	
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
		Else
			apMsgStop("Arquivo não encontrado para ser anexado ao e-mail: " + cAnexos)
			oProcess:oHtml:ValByName( "variavel"	   , "Arquivo não encontrado para ser anexado ao e-mail!")
		EndIf
		
	Else
		If !Empty(cArquivo)
			oProcess:oHtml:ValByName( "variavel"	   , cTexto + '   Arquivo ' + cArquivo + ' não encontrado para anexar ao e-mail!')
		Else
			oProcess:oHtml:ValByName( "variavel"	   , cTexto  )
		EndIf
	EndIf
	
	oProcess:Start()
	oProcess:Finish()
	
Else
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Prepara variaveis																				  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Prepara arquivo para ser anexado ao e-mail											  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	n:=0
	For x := 1 to len(cArquivo)
		If Subs(cArquivo,x,1) == '\'
			n := x
		EndIf
	Next x
	
	cPath    := Subs(cArquivo,1,n)
	cArquivo := Subs(cArquivo,n+1)
	
	If File(cPath+cArquivo)
		
		cNewGetFile := "\temp_anexos\"+cArquivo
		If File(cNewGetFile)
			fErase(cNewGetFile)
		EndIf
		COPY File &(cPath+cArquivo) TO &cNewGetFile
		cGetFile := cNewGetFile
		cAnexos += cGetFile
		
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Conexão com SMTP.																				  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CONOUT("OpusVP MAIL "+Dtoc(Date())+" "+Time()+" - Conectando com servidor SMTP...")
	CONNECT SMTP SERVER cServer ACCOUNT cConta PASSWORD cPsw RESULT lResult
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica conexao com SMTP																	  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lResult
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica autenticacao.																		  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRelauth
			lRet := Mailauth( cCtaAut, cPsw )
		Else
			lRet := .T.
		Endif
		
		If lRet
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Envia e-mail verificando anexo															  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If File(cAnexos)
				CONOUT("OpusVP MAIL "+Dtoc(Date())+" "+Time()+" - Enviando e-mail para: "+cPara)
				CONOUT("OpusVP MAIL "+Dtoc(Date())+" "+Time()+" - Assunto:              "+cPara)
				SEND MAIL;
				FROM 		cFrom;
				TO      	cPara;
				BCC     	cCC;
				SUBJECT 	cAssunto;
				BODY    	cTexto;
				ATTACHMENT  cAnexos;
				RESULT 		lResult
			Else
				CONOUT("OpusVP MAIL "+Dtoc(Date())+" "+Time()+" - Enviando e-mail para: "+cPara)
				CONOUT("OpusVP MAIL "+Dtoc(Date())+" "+Time()+" - Assunto:              "+cPara)
				SEND MAIL;
				FROM 		cFrom;
				TO      	cPara;
				BCC     	cCC;
				SUBJECT 	cAssunto;
				BODY    	cTexto;
				RESULT	lResult
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica erro de envio.																		  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !lResult
				GET MAIL ERROR cError
				CONOUT("OpusVP MAIL "+Dtoc(Date())+" "+Time()+" - Erro no envio de e-mail: "+cError)
			Endif
			
		Else
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica erro de autenticacao																  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			GET MAIL ERROR cError
			CONOUT("OpusVP MAIL "+Dtoc(Date())+" "+Time()+" - Erro de autenticacao: "+cError)
			
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Desconecta com SMTP.																			  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		CONOUT("OpusVP MAIL "+Dtoc(Date())+" "+Time()+" - Desconectando com servidor SMTP...")
		DISCONNECT SMTP SERVER
		
	Else
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica erro com SMTP.																		  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		GET MAIL ERROR cError
		CONOUT("OpusVP MAIL "+Dtoc(Date())+" "+Time()+" - Erro de conexao com servidor SMTP: "+cError)
		
	Endif
	
	RestArea( aArea )
	
EndIf

Return

