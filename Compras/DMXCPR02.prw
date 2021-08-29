#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "Tbiconn.ch"
#Include "rwmake.ch"
#include 'tbicode.ch'
#include "totvs.ch"


#DEFINE ENTER CHAR(13) + CHAR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DMXCPR02  ºAutor  ³Jackson Santos      º Data ³  06/12/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Programa para enviar e-mail ao fornecedor com o anexo do  º±±
±±º          ³  Pedido de compras                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DMXCPR02(cNumPCLib) //024847

    Local cPedAprov	:= IIF(Empty(Alltrim(cNumPCLib)),SC7->C7_NUM,cNumPCLib)
    Local cMsg			:= ""
    Local cArquivo  	:= "\pedido_compra\" + cPedAprov + ".pdf"
    Local cArqDOC    	:= "\DOCS\"//D:\TOTVS12\01-Oficial\Protheus_Data\DOCS\00904614.pdf
    Local cEmail		:= ""
    Local cUserComp	:= ""
    Local lEnviar 		:= .F.
    Local cMsgUser		:= ""
    Local nQtdEnvios	:= 0
    Local aAreaAtu		:= GetArea()
    Local aAreaSC7	   := SC7->(GetArea())
    Default cNumPCLib := ""

    SC7->(DbSetOrder(1))
    SC7->(DbSeek(xFilial("SC7")+AllTrim(cPedAprov)))
    If SC7->C7_CONAPROV == "L" //Enviar e-mail apenas de pedidos aprovados
        If Empty(Alltrim(cNumPCLib))
            If SC7->C7_XQEMAIL > 0
                nQtdEnvios := SC7->C7_XQEMAIL
                cMsgUser := "Deseja enviar novamente o pedido de compras por e-mail para o fornecedor ?"
                cMsgUser += ENTER + "Qtd.E-mails Enviados: " + Alltrim(STR(SC7->C7_XQEMAIL))
            Else
                cMsgUser := "Confirmar o envio do pedido de compras por e-mail para o fornecedor ?"
            EndIf
            lEnviar := MsgYesNo(cMsgUser,"Enviar E-Mail do Pedido")
        Else
            If SC7->C7_XQEMAIL > 0
                lEnviar := .F.
            Else
                lEnviar := .T.
            EndIf
        EndIf

        If lEnviar
            cEmail	:= AllTrim(Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE,"A2_EMAIL"))
            cUserComp	:= UsrRetName(SC7->C7_USER)

            PswOrder(2)
            cEmail := ""
            If PswSeek( cUserComp, .T. )
                cEmail += Iif(Empty(AllTrim(PswRet()[1][14])),"",";" + AllTrim(PswRet()[1][14])) // Retorna vetor com informações do usuário
            EndIf
            cEmail += ";denis.vieira@rosenbergerdomex.com.br;mauricio.souza@opusvp.com.br"
        /* TESTE */
         //   cEmail :='mauricio.souza@opusvp.com.br'


		/*
		cMsg := "<html>"
		cMsg := "<font size='4' face='Arial'><center>Pedido Aprovado: " + cPedAprov + "</center></font>"
		cMsg := "<br> Este e-mail foi enviado para os seguintes destinatarios: " + StrTran(cEmail)
		cMsg += "</html>"
		*/

            cMsg := ""
            cMsg += "<html>"
            cMsg += "<table border=0 cellpeding=0 cellspace=0>"
            cMsg += "<tr><td><font face=Arial size=2><i>"
            cMsg += "Caro " + AllTrim(Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE,"A2_NOME"))  + ", <br>"
            cMsg += "<p>Anexo Pedido de Compra, no qual solicitamos sua aten&ccedil;&atilde;o para o atendimento das condi&ccedil;&otilde;es <br> de atendimento:</p>"
            cMsg += "</i></font></td></tr>"
            cMsg += "<tr><td><font face=Arial size=3 color=Red><b><i>"
            cMsg += "<br>"
            cMsg += "ATENÇÃO: NÃO RESPONDA ESTE E-MAIL!"
            cMsg += "<br>"
            cMsg += "ACEITE DO PEDIDO DE COMPRA"
            cMsg += "</b></u></i></font></td></tr>"
            cMsg += "<tr><td><font face=Arial size=2><i>	 "
            cMsg += "<p>Responder aos e-mails do Departamento de Materiais - Setor de Compras: alberto.oliveira@rosenbergerdomex.com.br, carlos.carvalho@rosenbergerdomex.com.br enviando a confirma&ccedil;&atilde;o do recebimento deste Pedido de Compra e da data de entrega.</p>"
            cMsg += "<p>Ap&oacute;s 24 horas do envio do Pedido de Compra, o mesmo ser&aacute; considerado aceito pelo Fornecedor.</p>"
            cMsg += "</i></font></td></tr>"
            cMsg += "<tr><td><font face=Arial size=3 color=Red><b><i>"
            cMsg += "<br>"
            cMsg += "CONDI&Ccedil;&Otilde;ES DE ENTREGA"
            cMsg += "</b></i></font></td></tr>"
            cMsg += "<tr><td><font face=Arial size=2><i>	 "
            cMsg += "<p>Os atrasos em rela&ccedil;&atilde;o da data de entrega requerida ser&atilde;o computados negativamente na avalia&ccedil;&atilde;o de desempenho do fornecedor, sendo que eventuais antecipa&ccedil;&otilde;es somente poder&atilde;o ser realizadas mediante autoriza&ccedil;&atilde;o pr&eacute;via da &aacute;rea de Compras.</p>"
            cMsg += "<p>Hor&aacute;rio de Recebimento: Entre 8h00 &agrave;s 12h00 e 13h30 &agrave;s 15:30 horas - Dias &uacute;teis. </p>"
            //cMsg += "<p>Descarga de material: Enviar um ajudante para descarga dos materiais </p>"
            //cMsg += "<p>Para pedidos com frete FOB (por conta da Rosenberger), solicitar a Rosenberger o nome da transportadora autorizada para efetuar a coleta.</p>"
            cMsg += "<br><p>IMPORTANTE: Por raz&otilde;es de seguran&ccedil;a e normas internas, o acesso de terceiros as depend&ecirc;ncias da empresa Rosenberger para coleta, entrega de materiais, produtos e servi&ccedil;os, dever&aacute; ser feito obrigatoriamente com uso de cal&ccedil;ado de seguran&ccedil;a e apresenta&ccedil;&atilde;o de documentos originais de identifica&ccedil;&atilde;o.</p>"
            cMsg += "</i></font></td></tr>"
            cMsg += "<tr><td><font face=Arial size=3 color=Red><b><i>"
            cMsg += "<br>"
            cMsg += "INFORMA&Ccedil;&Otilde;ES DE FATURAMENTO"
            cMsg += "</b></i></font></td></tr> "
            cMsg += "<tr><td><font face=Arial size=2><i>	 "
            cMsg += "<p>Envio da Nota Fiscal e XML: Dever&aacute; ocorrer antecipadamente a entrega, para os seguintes endere&ccedil;os de e-mail: nfe@rosenbergerdomex.com.br, alberto.oliveira@rosenbergerdomex.com.br, carlos.carvalho@rosenbergerdomex.com.br</p>"
            cMsg += "<p>Os t&iacute;tulos/boletos devem obrigatoriamente estar em nome da Rosenberger Domex Telecomunica&ccedil;&otilde;es Ltda, n&atilde;o sendo permitido ao fornecedor a negocia&ccedil;&atilde;o destes t&iacute;tulos com terceiros.</p>"
            cMsg += "<p>&Eacute; obrigat&oacute;ria a informa&ccedil;&atilde;o do nosso n&uacute;mero de Pedido de Compra, c&oacute;digo e descri&ccedil;&atilde;o do material/servi&ccedil;o na Nota Fiscal.</p>"
            cMsg += "<p>Atenciosamente,<br><br>Rosenberger Domex Telecomunicações Ltda</p>"
            cMsg += "</i></font></td></tr>"
            cMsg += "<tr><td><font face=Arial size=1><i>"
            cMsg += "<br>	 "
            cMsg += "Este e-mail foi enviado para os seguintes destinatarios: " + StrTran(cEmail,";"," - ")
            cMsg += "</i></font></td></tr>"
            cMsg += "</table>"
            cMsg += "</html>"


            //Alert("Envia e-mail")

            U_DOMIMPPC(2)

            Sleep(4000)
            //cEmail := "jackson.santos@opusvp.com.br"
            //cEmail := "mauricio.souza@opusvp.com.br"
            //teste
            //
            U_EnvMailPC("Pedido Aprovado: " + cPedAprov,cMsg,cEmail,"",cArquivo,cPedAprov)

            //Incrementa Controle de Envios de Emails
            SC7->(DbSeek(xFilial("SC7")+AllTrim(cPedAprov)))
            While SC7->(!EOF()) .And. SC7->C7_NUM == AllTrim(cPedAprov)
                RecLock("SC7",.F.)
                SC7->C7_XQEMAIL := nQtdEnvios  + 1
                SC7->C7_XDTUENV := DDATABASE
                SC7->C7_XUSRENV := Substr(cUsuario,7,14)
                SC7->(MsUnlock())
                SC7->(DbSkip())
            EndDo
            If Empty(Alltrim(cNumPCLib))
                MsgInfo("Enviado com sucesso!","Envio E-Mail Pedido")
            EndIf
        EndIf
    Else
        MsgStop("O Pedido de Compras está bloqueado!","Pedido Bloqueado")
    EndIf
    RestArea(aAreaSC7)
    RestArea(aAreaAtu)
Return



//===========================================================================================


//USER Function EnvMailPC(cAssunto,cTexto,cPara,cCC,cArquivo,lUsaWorkflow)
USER Function EnvMailPC(cAssunto,cTexto,cPara,cCC,cArquivo,cPedAprov)


    LOCAL cAnexos := ''
    Local cArqDOC    	:= "\DOCS\"//D:\TOTVS12\01-Oficial\Protheus_Data\DOCS\00904614.pdf
    LOCAL x
    LOCAL n
    LOCAl cPath
    default lUsaWorkflow := .T.		// .T. Via Processo Workflow  .F. Via Send Mail direto


//LOCAL lUsaWorkflow := .T.		// .T. Via Processo Workflow  .F. Via Send Mail direto

    Private oProcess

//Default cCC      := ""
    Default cArquivo := ""

//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
//ï¿½Verifica se utiliza TWFProcess ou SEND MAIL											  ï¿½
//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
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
            // If File(cAnexos)
            //    oProcess:AttachFile( cAnexos )
            //    oProcess:oHtml:ValByName( "variavel"	   , cTexto)
            //Else
            //    apMsgStop("Arquivo nï¿½o encontrado para ser anexado ao e-mail: " + cAnexos)
            //    oProcess:oHtml:ValByName( "variavel"	   , "Arquivo nï¿½o encontrado para ser anexado ao e-mail!")
            //EndIf

            oProcess:AttachFile( cAnexos )

            //========================================================================
            SC7->(DbSeek(xFilial("SC7")+AllTrim(cPedAprov)))
            While SC7->(!EOF()) .And. SC7->C7_NUM == AllTrim(cPedAprov)
                SB1->(DbSeek(xFilial("SB1")+AllTrim(SC7->C7_PRODUTO)))
                cGrupo := SB1->B1_GRUPO
                IF cGrupo=='ESTP'
                    // \DOCS\
                    //   SZV	2	ZV_FILIAL + ZV_CHAVE + ZV_ARQUIVO
                    SZV->( dbSetOrder(2) )
                    SZV->(DbSeek(xFilial("SZV")+SC7->C7_PRODUTO))
                    cARQSZV := SZV->ZV_ARQUIVO
                    //QDH	1	QDH_FILIAL+QDH_DOCTO+QDH_RV
                    QDH->( dbSetOrder(1) )
                    QDH->(DbSeek(xFilial("QDH")+ALLTRIM(cARQSZV)))
                    cARQDOC:=''
                    While QDH->(!EOF()) .And. ALLTRIM(QDH->QDH_DOCTO) == AllTrim(cARQSZV)
                        cARQDOC :=QDH->QDH_NOMDOC
                        QDH->(DbSkip())
                    EndDo

                    //COPY File &("\DOCS\"+cArquivo) TO &cNewGetFile
                    //cGetFile := cNewGetFile
                    //cGetFile:=\DOCS\cARQDOC
                    //cAnexos +=cGetFile
                    cAnexdoc:="\docs\"+cARQDOC

                    cNewGetFile := "\temp_anexos\"+AllTrim(SC7->C7_PRODUTO)+".pdf"
                    If File(cNewGetFile)
                        fErase(cNewGetFile)
                    EndIf
                    COPY File &("\docs\"+cARQDOC) TO &cNewGetFile
                    cGetFileDOC := cNewGetFile

                    If File(cGetFileDOC)
                        oProcess:AttachFile( cGetFileDOC )
                    ENDIF

                ENDIF
                SC7->(DbSkip())
            EndDo


            //========================================================================
            If File(cAnexos)
                //oProcess:AttachFile( cAnexos )
                oProcess:oHtml:ValByName( "variavel"	   , cTexto)
            Else
                apMsgStop("Arquivo nï¿½o encontrado para ser anexado ao e-mail: " + cAnexos)
                oProcess:oHtml:ValByName( "variavel"	   , "Arquivo nï¿½o encontrado para ser anexado ao e-mail!")
            EndIf
        Else
            If !Empty(cArquivo)
                oProcess:oHtml:ValByName( "variavel"	   , cTexto + '   Arquivo ' + cArquivo + ' nï¿½o encontrado para anexar ao e-mail!')
            Else
                oProcess:oHtml:ValByName( "variavel"	   , cTexto  )
            EndIf
        EndIf



        oProcess:Start()
        oProcess:Finish()

    Else

        //ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
        //ï¿½Prepara variaveis																				  ï¿½
        //ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
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

        //ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
        //ï¿½Prepara arquivo para ser anexado ao e-mail											  ï¿½
        //ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
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

        //ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
        //ï¿½Conexï¿½o com SMTP.																				  ï¿½
        //ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
        CONOUT("OPUSVP MAIL "+Dtoc(Date())+" "+Time()+" - Conectando com servidor SMTP...")
        CONNECT SMTP SERVER cServer ACCOUNT cConta PASSWORD cPsw RESULT lResult

        //ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
        //ï¿½Verifica conexao com SMTP																	  ï¿½
        //ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
        If lResult

            //ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
            //ï¿½Verifica autenticacao.																		  ï¿½
            //ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
            If lRelauth
                lRet := Mailauth( cCtaAut, cPsw )
            Else
                lRet := .T.
            Endif

            If lRet


                //  ENVIA EMAIL EXTERNO SOMENTE SE FOR AMBIENTE DE PRODUCAO ROSENGERGER
                If !(Upper(Alltrim(Getenvserv())) $ 'ROSENBERGER')
                    cPara :=  "denis.vieira@rosenbergerdomex.com.br"
                    cCC	:=  "denis.vieira@rosenbergerdomex.com.br"
                endif


                //ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
                //ï¿½Envia e-mail verificando anexo															  ï¿½
                //ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
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

                //ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
                //ï¿½Verifica erro de envio.																		  ï¿½
                //ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
                If !lResult
                    GET MAIL ERROR cError
                    CONOUT("OPUS VP MAIL "+Dtoc(Date())+" "+Time()+" - Erro no envio de e-mail: "+cError)
                Endif

            Else

                //ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
                //ï¿½Verifica erro de autenticacao																  ï¿½
                //ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
                GET MAIL ERROR cError
                CONOUT("OPUS VP MAIL "+Dtoc(Date())+" "+Time()+" - Erro de autenticacao: "+cError)

            Endif

            //ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
            //ï¿½Desconecta com SMTP.																			  ï¿½
            //ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
            CONOUT("OPUS VP MAIL "+Dtoc(Date())+" "+Time()+" - Desconectando com servidor SMTP...")
            DISCONNECT SMTP SERVER

        Else

            //ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
            //ï¿½Verifica erro com SMTP.																		  ï¿½
            //ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
            GET MAIL ERROR cError
            CONOUT("OPUS VP MAIL "+Dtoc(Date())+" "+Time()+" - Erro de conexao com servidor SMTP: "+cError)

        Endif

        RestArea( aArea )

    EndIf

Return

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

