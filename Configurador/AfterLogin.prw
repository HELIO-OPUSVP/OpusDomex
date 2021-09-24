#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAfterLoginบAutor  ณ Felipe Melo        บ Data ณ  06/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Utilizado para equalizar SX3 com BD para prossegui com a   บฑฑ
ฑฑบ          ณ atualiza็ใo mp710to101                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function AfterLogin()

//ALERT("Teste Jonas")

//Corrigi estornos no SD5
U_DOMESTD5()   // Nใo pode retirar. Este programa deleta os registros no SD5 que estejam com D5_ESTORNO = 'S'

//If Subs(cUsuario,7,5) == "HELIO"
//   U_RPROD2_NEW()
//EndIf
//Return

// Habilita/Desabilita  Rotina Padrใo de Analise de Cr้dito, baseado no parametro MV_XANACRE
// Ambos tem que estar Iguais, para adotar o mesmo crit้rio tanto na rotina customizadas do Coletor, quanto rotina Padrao
//	If GetMV("MV_XANACRE")
//		PutMv("MV_BLOQUEI",.T.)
//	Else
//		PutMv("MV_BLOQUEI",.F.)
//	EndIf



//virada protheus nuvem Jonas /15/05/2019
//	Final('Configura็๕es atualizadas com sucesso, finalize e fa็a novo login')
/*
If 'TREINAMEN' $ Upper(GetEnvServer())
Alert("A T E N ว ร O  ! ! !"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
"VOCE ESTม ACESSANDO O AMBIENTE  T R E I N A M E N T O  ! ! !"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
"INFORMATIVO: Este ambiente foi criado para realiza็๕es de testes.")

EndIf

If 'HOMOLOG' $ Upper(GetEnvServer())
Alert("A T E N ว ร O  ! ! !"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
"VOCE ESTม ACESSANDO O AMBIENTE  H O M O L O G A ว ร O  ! ! !"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
"INFORMATIVO: Este ambiente foi criado para realiza็๕es de testes.")

EndIf

If 'CUSTOS' $ Upper(GetEnvServer()) .and. Subs(CUSUARIO,7,5) == 'HELIO'
U_CUSTOPUS()
EndIf

If 'MAURESI' $ Upper(GetEnvServer())  .and.  Subs(CUSUARIO,7,7) == 'mauresi'
U_MRSXML00()
//U_RCUSTOS1()
//U_ProdDomex()
EndIf



//MATA650()  // 07/04/14
//Mata410()

//If Subs(cUsuario,7,15) == "Michel"
//   U_DOMACD21()   //U_MnuColetor()
//Endif

If Subs(cUsuario,7,15) == "Usuario Coletor" .AND. nModulo == 4
U_DOMACD21()   //U_MnuColetor()
EndIf

If Subs(cUsuario,7,5) == "HELIO"
//U_DOMACD21()   //U_MnuColetor()
//nLargBut := 80
//nAltuBut := 15
//@ 50,500 BUTTON oBtn01 PROMPT "Inventแrio CADSZI()" ACTION U_CADSZI() SIZE nLargBut,nAltuBut PIXEL
//@ 050,500 BUTTON oBtn01 PROMPT "Etiqueta PA DOMETDLG()"    ACTION U_DOMETDLG() SIZE nLargBut,nAltuBut PIXEL
//@ 070,500 BUTTON oBtn01 PROMPT "Etiqueta DOMETDL3()"       ACTION U_DOMETDL3() SIZE nLargBut,nAltuBut PIXEL
//@ 090,500 BUTTON oBtn01 PROMPT "Subst.Estrut. M200SUBS()"  ACTION U_M200SUBS() SIZE nLargBut,nAltuBut PIXEL
//@ 100,500 BUTTON oBtn01 PROMPT "GERASB7    "               ACTION U_GERASB7() SIZE nLargBut,nAltuBut PIXEL

//oBtn01:SetCSS( FWGetCSS( CSS_BUTTON ) )
//oBtn01:SetFocus()
EndIf

If Subs(cUsuario,7,5) == "Denis"
//For x := 1 to 5
//   MsgStop("Denis, favor alterar o IP externo de conexใo remota para o servidor 192.168.0.8 (s๓ pra garantir, mensagem "+Alltrim(Str(x))+"/5)")
//Next x
EndIf

If GetMv("XX_SERSCHE") == "S"

If "192.168.0.8" $ GetClientIP()
//WinExec('TaskKill /f /FI "SERVICES eq .:13-Protheus12-Schedulle-2115"')
Else
//WinExec('TaskKill /S 192.168.0.3 /U DOMEX\helio.opus /P hf2014# /f /FI "SERVICES eq .:13-Protheus12-Schedulle-2115"')
EndIf

//WinExec('TaskKill /S 192.168.0.8 /U DOMEX\helio.opus /P hf2014# /f /FI "SERVICES eq .:13-Protheus12-Schedulle-2115"')
//WinExec("cmd.exe /c sc start .:13-Protheus12-Schedulle-2115 obj= domex\helio.opus password= h2014#")
//WinExec("cmd.exe /c sc start .:13-Protheus12-Schedulle-2115")
EndIf
*/

//If 'HELIO.OPUS' $ Upper(GetEnvServer())
	//U_CoDifSal()
	//U_RCUSTOS1()
	//U_ProdDomex()
	//U_DOMCEI()
//EndIf

Return
