#Include "Protheus.ch"

User Function MT094END()
 	Local cPedAprov	:= AllTrim(SCR->CR_NUM)//SC7->C7_NUM
	Local cMsg		:= ""
	Local cArquivo  := "\pedido_compra\" + cPedAprov + ".pdf"
	Local cEmail	:= ""
	Local cUserComp	:= ""

	U_DMXCPR01(AllTrim(SCR->CR_NUM))
 
  
   //Chama a função de controle de envios d e-mails ao forncedor.
	
Return
   
Static Function BKMT094END  
	Local cPedAprov	:= AllTrim(SCR->CR_NUM)//SC7->C7_NUM
	Local cMsg		:= ""
	Local cArquivo  := "\pedido_compra\" + cPedAprov + ".pdf"
	Local cEmail	:= ""
	Local cUserComp	:= ""

	U_DMXCPR01(AllTrim(SCR->CR_NUM))

	SC7->(DbSetOrder(1))
	SC7->(DbSeek(xFilial("SC7")+AllTrim(cPedAprov)))                      
	
	cEmail	:= AllTrim(Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE,"A2_EMAIL"))
	cUserComp	:= UsrRetName(SC7->C7_USER) 
	
	PswOrder(2)
	//cEmail := ""
	If PswSeek( cUserComp, .T. )  
		cEmail += Iif(Empty(AllTrim(PswRet()[1][14])),"",";" + AllTrim(PswRet()[1][14])) // Retorna vetor com informações do usuário
	EndIf
	cEmail += ";denis.vieira@rosenbergerdomex.com.br"

	
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
	U_EnvMailto("Pedido Aprovado: " + cPedAprov,cMsg,cEmail,"",cArquivo)
	
Return
