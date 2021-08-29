#include 'Ap5Mail.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFGEN010   บAutor  ณ                    บ Data ณ  01/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para envio de e-mail.                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParโmetrosณ ExpC1: e-mail do destinatแrio                              บฑฑ
ฑฑบ          ณ ExpC2: assunto do e-mail                                   บฑฑ
ฑฑบ          ณ ExpC3: texto do e-mail                                     บฑฑ
ฑฑบ          ณ ExpC4: anexos do e-mail                                    บฑฑ
ฑฑบ          ณ ExpL1: exibe mensagem de envio                             บฑฑ
ฑฑบ          ณ ExpC5: conta FROM  para envio da mensagem (opcional)       บฑฑ
ฑฑบ          ณ ExpC6: conta COPIA para envio da mensagem (opcional)       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno  ณ ExpL2: .T. - envio realizado                               บฑฑ
ฑฑบ          ณ        .F. - nใo enviado                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FGEN010(c_MailDestino,c_Assunto,c_Texto,c_Anexos,l_Mensagem,c_MailFrom,c_MailBCC)

Local 	l_Ret				:= .T.
Local 	c_Cadastro		:= "Envio de e-mail"
Private	c_MailServer	:= AllTrim(GetMv("MV_RELSERV"))
Private	c_MailConta 	:= AllTrim(GetMv("MV_RELAUSR"))
Private 	l_Auth			:= GetMv("MV_RELAUTH")
Private c_MailAuth		:= AllTrim(GetMv("MV_RELACNT"))

Private	c_MailSenha		:= AllTrim(GetMv("MV_RELPSW"))
Private c_SenhaAuth		:= AllTrim(GetMv("MV_RELAPSW"))
Private	c_MailDestino	:= If( ValType(c_MailDestino) != "U" , c_MailDestino,  "" )
Private	l_Mensagem		:= If( ValType(l_Mensagem)    != "U" , l_Mensagem,  .T. )
Private c_MailFrom		:= iif( c_MailFrom == Nil, c_MailConta, c_MailFrom)
Private c_MailBCC	  		:= iif( c_MailBCC == Nil, "", c_MailBCC)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEfetua validacoesณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If Empty(c_MailDestino)
	If l_Mensagem
		Aviso(	c_Cadastro, "Conta(s) de e-mail de destino(s) nใo informada. ";
		+"Envio nใo realizado.",{"&Ok"},,"Falta informa็ใo" )
	EndIf
	c_msgerro := "Conta(s) de e-mail de destino(s) nใo informada. Envio nใo realizado."
	l_Ret	:= .F.
EndIf

If Empty(c_Assunto)
	If l_Mensagem
		Aviso(	c_Cadastro,"Assunto do e-mail nใo informado. ";
		+"Envio nใo realizado.",{"&Ok"},,"Falta informa็ใo" )
	EndIf
	c_msgerro := "Assunto do e-mail nใo informado. Envio nใo realizado."
	l_Ret	:= .F.
EndIf

If Empty(c_Texto)
	If l_Mensagem
		Aviso(	c_Cadastro,"Texto do e-mail nใo informado. ";
		+"Envio nใo realizado.",{"&Ok"},, "Falta informa็ใo" )
	EndIf
	c_msgerro := "Texto do e-mail nใo informado. Envio nใo realizado."
	l_Ret	:= .F.
EndIf

If l_Ret
	If l_Mensagem
		Processa({|| l_Ret := SendMail(c_MailDestino,c_Assunto,c_Texto,c_Anexos,l_Mensagem,c_MailFrom,c_MailBCC), "Enviando e-mail"})
	Else
		l_Ret := SendMail(c_MailDestino,c_Assunto,c_Texto,c_Anexos,l_Mensagem,c_MailFrom,c_MailBCC)
	EndIf
EndIf

Return(l_Ret)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSendMail  บAutor  ณ Marco Aurelio-HF   บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao de envio de e-mail.                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SendMail(c_MailDestino,c_Assunt,c_Text,c_Anexo,l_Mensagem,c_MailFrom,c_MailBCC)

Local l_Conexao	   		:= .F.
Local l_Envio			:= .F.
Local l_Desconexao 		:= .F.
Local l_Ret				:= .F.
Local c_Assunto	   		:= If( ValType(c_Assunt) != "U" , c_Assunt , "" )
Local c_Texto			:= If( ValType(c_Text)   != "U" , c_Text   , "" )
Local c_Anexos			:= If( ValType(c_Anexo)  != "U" , c_Anexo  , "" )
Local c_MailFrom		:= iif( c_MailFrom == Nil, c_MailConta, c_MailFrom)
Local c_MailBCC	   		:= iif( c_MailBCC == Nil, "", c_MailBCC)

Local c_Erro_Conexao	:= ""
Local c_Erro_Envio		:= ""
Local c_Erro_Desconexao	:= ""
Local c_Cadastro			:= "Envio de e-mail"

If l_Mensagem
	IncProc("Conectando-se ao servidor de e-mail...")
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executa conexao ao servidor mencionado no parametro. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Connect Smtp Server c_MailServer ACCOUNT c_MailConta PASSWORD c_MailSenha RESULT l_Conexao

If !l_Conexao
	GET MAIL ERROR c_Erro_Conexao
	If l_Mensagem
		Aviso(	c_Cadastro, "Nao foi possํvel estabelecer conexใo com o servidor - ";
		+c_Erro_Conexao,{"&Ok"},,"Sem Conexใo" )
	EndIf
	c_msgerro := "Nao foi possํvel estabelecer conexใo com o servidor - "+c_Erro_Conexao
	l_Ret := .F.
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se deve fazer autenticacaoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If l_Auth
	If !MailAuth(c_MailAuth, c_SenhaAuth)
		GET MAIL ERROR c_Erro_Conexao
		If l_Mensagem
			Aviso(	c_Cadastro, "Nao foi possํvel autenticar a conexใo com o servidor - ";
			+c_Erro_Conexao,{"&Ok"},,"Sem Conexใo" )
		EndIf
		c_msgerro := "Nao foi possํvel autenticar a conexใo com o servidor - "+c_Erro_Conexao
		l_Ret := .F.
	EndIf
EndIf

If l_Mensagem
	IncProc("Enviando e-mail...")
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executa envio da mensagem. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !Empty(c_Anexos)
	Send Mail From c_MailFrom to c_MailDestino Bcc c_MailBCC SubJect c_Assunto BODY c_Texto FORMAT TEXT ATTACHMENT c_Anexos RESULT l_Envio
Else
	Send Mail From c_MailFrom to c_MailDestino Bcc c_MailBCC SubJect c_Assunto BODY c_Texto FORMAT TEXT RESULT l_Envio
EndIf

If !l_Envio
	Get Mail Error c_Erro_Envio
	If l_Mensagem
		Aviso(	c_Cadastro,"Nใo foi possํvel enviar a mensagem - ";
		+c_Erro_Envio,{"&Ok"},,	"Falha de envio" )
	EndIf
	c_msgerro := "Nใo foi possํvel enviar a mensagem - "+c_Erro_Envio
	l_Ret := .F.
Else
	l_Ret := .T.
EndIf

If l_Mensagem
	IncProc("Desconectando-se do servidor de e-mail...")
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executa disconexao ao servidor SMTP. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DisConnect Smtp Server Result l_Desconexao

If !l_Desconexao
	Get Mail Error c_Erro_Desconexao
	If l_Mensagem
		Aviso(	c_Cadastro,"Nใo foi possํvel desconectar-se do servidor - ";
		+c_Erro_Desconexao,{"&Ok"},,"Descone็ใo" )
	EndIf
	c_msgerro := "Nใo foi possํvel desconectar-se do servidor - "+c_Erro_Desconexao
	l_Ret := .F.
EndIf

Return(l_Ret)