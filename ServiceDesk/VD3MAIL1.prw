#include "rwmake.ch"
#include "totvs.ch"
#include "topconn.ch"
#include "TbiCode.ch"
#include "protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"


#DEFINE ENTER CHAR(13) + CHAR(10)

/*
Envia email falta saldo 99
Jonas 10/09/2020 para ajuda idetificacao de um erro intermitente
*/

//                     Protudo               Saldo                                             Local                  Necessidade
//				U_VD3MAIL1(aInsuficientes[nU,1], Transform(aInsuficientes[nU,3],"@E 999,999.9999"),aInsuficientes[nU,2] , aInsuficientes[nU,4]  , cTimeEnv )
User Function VD3MAIL1(cProduto            , cQuant                                           , cLocal              , nNecessidade          , cDtTime  )

//Local cMsg			:= ""
//Local cEmail		:= "jonas@opusvp.com.br; helio@opusvp.com.br; denis.vieira@rosenbergerdomex.com.br"
//Local cMsgDados	:= ""
//Local cQuery      := ""
//Local cProduto  := "50004070109    "
//Local lFirst    := .t.
Local cMsg2

Default cDtTime   := "99/99/99 - 99:99:99"

cMsg2 := 'Produto: ' + cProduto + ' Saldo: ' + cQuant + ' Local: ' + cLocal + ' Necessidade: ' + Transform(nNecessidade,'@E 999,999,999.9999') 

U_EnvMailto("Falta de Saldo no 99: " + cDtTime ,cMsg2,"denis.vieira@rosenbergerdomex.com.br; sergio.santos@rosenbergerdomex.com.br","",)

// cQuery := " SELECT SUM(CAST(RIGHT(RTRIM(P05_SOMA), LEN(RTRIM(P05_SOMA))-PATINDEX('%-%',P05_SOMA)) AS DECIMAL(10,5) )) AS SOMA_P05 FROM P05010 (NOLOCK) WHERE P05_FILIAL='01' AND D_E_L_E_T_='' AND  P05_CAMPO='B2_QATU' AND P05_PRODUT='"+cProduto+"' AND P05_LOCAL='99' "
// cQuery += " UNION ALL "
// cQuery += " SELECT P05_SOMA AS SOMA_P05 FROM P05010 (NOLOCK) WHERE P05_FILIAL='01' AND D_E_L_E_T_='' AND  P05_CAMPO='B2_QATU' AND P05_PRODUT='"+cProduto+"' AND P05_LOCAL='99' "

// If Select("QUERY") <> 0
// 	QUERY->( dbCloseArea() )
// EndIf

// TCQUERY cQuery NEW ALIAS "QUERY"
	

// If	!QUERY->( EOF() ) 
//     If SB2->(dbseek(xFIlial()+cProduto+"99"))
//         cMsgDados += "Código  "+ cProduto + ", Local: 99, QTD SB2: " + STR(SB2->B2_QATU)  + ENTER + ENTER + ENTER 
//     EndIf

// 	IF !QUERY->( EOF() ) 
// 	//	If lFirst
// 			cMsgDados += "Código  "+ cProduto + ", Local: 99, QTD TOTAL P05: " + STR(QUERY->SOMA_P05)  + ENTER + ENTER  + ENTER 
// 			cMsgDados += "Código  "+ cProduto + ", Local: 99, QTD APONTADA: " + cQuant  + ENTER 
// 	//	EndIf
// 	Else
// 			cMsgDados += "Código  "+ cProduto + ", Local: 99, QTD TOTAL P05: 0 "  + ENTER + ENTER  + ENTER 
// 			cMsgDados += "Código  "+ cProduto + ", Local: 99, QTD APONTADA: " + cQuant  + ENTER 
		
// 	EndIf
// 	//	QUERY->(DbSkip()) 
// 	//Enddo




// 	cMsg := ""
// 	cMsg += "<html>"
// 	cMsg += "<table border=0 cellpeding=0 cellspace=0>"
// 	cMsg += "<tr><td><font face=Arial size=2><i>"
// 	cMsg += "Atençao " + cEmail  + ", <br>"
// 	cMsg += "<p>Abaixo analise de falta de saldo 99</p>"
// 	cMsg += "</i></font></td></tr>"
// 	cMsg += "<tr><td><font face=Arial size=3 color=Red><b><i>"
// 	cMsg += "<br>"
//     cMsg += "Data e hora "+DTOC(daysum(date(),30))+" / "+ Time() 
// 	cMsg += "</b></u></i></font></td></tr>"           
// 	cMsg += "<tr><td><font face=Arial size=2><i>	 "
// 	cMsg += "<p>"+cMsgDados+"</p>"
// 	cMsg += "</i></font></td></tr>"
// 	cMsg += "<tr><td><font face=Arial size=3 color=Red><b><i>"
// 	cMsg += "<br>"
// 	cMsg += ""
// 	cMsg += "</b></i></font></td></tr>"
// 	cMsg += "<tr><td><font face=Arial size=2><i>	 "
// 	cMsg += "<p></p>"
// 	cMsg += "</i></font></td></tr>"
// 	cMsg += "<tr><td><font face=Arial size=3 color=Red><b><i>"
// 	cMsg += "<br>"
// 	cMsg += ""
// 	cMsg += "</b></i></font></td></tr> "
// 	cMsg += "<tr><td><font face=Arial size=2><i>	 "
// 	cMsg += "<p>Atenciosamente,<br><br>Departamento de TI - Rosenberger Domex Telecomunicações Ltda</p>"
// 	cMsg += "</i></font></td></tr>"
// 	cMsg += "<tr><td><font face=Arial size=1><i>"
// 	cMsg += "<br>	 " 	
// 	cMsg += "Este e-mail foi enviado para os seguintes destinatarios: " + StrTran(cEmail,";"," - ")  
// 	cMsg += "</i></font></td></tr>"
// 	cMsg += "</table>"
// 	cMsg += "</html>"
	
		
	//Sleep(4000)
		
	//U_EnvMailto("Falta de Saldo no 99 " ,cMsg,cEmail,"",)

//EndIf	
	 
Return
