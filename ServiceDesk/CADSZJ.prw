#include "protheus.ch" 
#include "topconn.ch"

//Tabelas Reservadas
//SZJ - Service Desk - Cabecalho
//SZK - Service Desk - Interacoes
//SZL - Service Desk - Anexos
// - Service Desk - Cad. Categorias

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CADSZJ   บAutor  ณ Felipe A. Melo     บ Data ณ  03/07/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Chamados DOMEX                                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CADSZJ(__cTipo)

	Local aRetPerg    := {}

	Private cStrCad    := "SZJ"
	Private cTitCad    := "SERVICE DESK"
	Private cCadastro  := cTitCad+" ["+cStrCad+"]"
	Private cCodTec    := ""
	Private aRotina    := {}
	Private aFixe      := Nil
	Private aCores     := {}
	Private cFilSZJ    := ""
	Private cAnexoOpus := "\Dropbox\OpusVP\Anexos\"
	Private cExisteAnexo := "existe_anexo.txt"

	Default __cTipo    := "1"

	Private cTipoHlp   := __cTipo

	If cTipoHlp == "1"
		cCodTec := AllTrim(GetMv("MV_XUSRHLP")) //"000206/000000/000373/000422/000283/000211/000437/000492/000637"  //000206=Denis ; 000000=Admin ;000373=Mauresi  ; 000422 = Edmilson   ;  000211 = Helio ; 000437 = Douglas OndaTI; 000492 = Camila Martins (OndaTI); 000637 = Iranildo ; 000233 = Michel ; 000709 = Osmar
	ElseIf cTipoHlp == "2"
		cCodTec := AllTrim(GetMv("MV_XUSRMAN")) // USUARIOS MANUTENวรO
	ElseIf cTipoHlp == "3"
		cCodTec := AllTrim(GetMv("MV_XUSRENG")) // USUARIOS ENGENHARIA
	ElseiF cTipoHlp == "4"
		cCodTec := AllTrim(GetMv("MV_XUSRQLD")) // USUARIOS QUALIDADE
	EndIf

	aRotina    := fMenu()

//'BR_VERDE' = Chamado novo, aguardando tecnico
	aAdd(aCores,{'ZJ_STATUS == "P" .AND. ZJ_SITUAC == "T"','BR_VERDE'    })
//'BR_AMARELO'  = Em atendimento, aguardando tecnico
	aAdd(aCores,{'ZJ_STATUS == "A" .AND. ZJ_SITUAC == "T" .AND. ZJ_CLASSIF <> "7" .AND. ZJ_CLASSIF <> "5" .AND. (ZJ_CLASSIF <> "3" .OR. (ZJ_COD_CAT <> "000001" .AND. ZJ_COD_CAT <> "000011") )' ,'BR_AMARELO' })
//'BR_LARANJA'  = Em atendimento, aguardando solicitante
	aAdd(aCores,{'ZJ_STATUS == "A" .AND. ZJ_SITUAC == "S"','BR_LARANJA'  })
//'BR_VERMELHO'    = Fechado e resolvido
	aAdd(aCores,{'ZJ_STATUS == "F" .AND. ZJ_SITUAC == "R"','BR_VERMELHO' })
//'BR_PRETO'    = Fechado e cancelado
	aAdd(aCores,{'ZJ_STATUS == "F" .AND. ZJ_SITUAC == "C"','BR_PRETO'    })
//'BR_AZUL'    = Consultoria OpusVP
	aAdd(aCores,{'ZJ_STATUS == "A" .AND. ZJ_SITUAC == "T" .AND. ZJ_CLASSIF == "3" .AND. (ZJ_COD_CAT == "000001" .OR. ZJ_COD_CAT == "000011")','BR_AZUL' })
//'BR_PINK'    = Projetos
	aAdd(aCores,{'ZJ_CLASSIF == "5"'                      ,'BR_PINK'     })
//'BR_BRANCO'    = Projetos
	aAdd(aCores,{'ZJ_CLASSIF == "7"'                      ,'BR_BRANCO'   })
//'BR_MARRON'    = OBRIGACOES
	aAdd(aCores,{'ZJ_CLASSIF == "8"'                      ,'BR_MARRON'   })


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria estrutura da rotina                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	fCriaSX()

// Fun็ใo de sincroniza็ใo do SZ4 (projetos). Roda com StartJob Falso, ou seja, nใo fica aguardando a execu็ใo

//If Upper(GetEnvServ()) <> "MICHEL.OPUS" .AND. Upper(GetEnvServ()) <> "HELIO.OPUS"
//	U_SincSZ4()
//EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Caso usuแrio seja tecnico, finalizar chamados antigos        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If __cUserID $ cCodTec
		MsAguarde( { || fEncerrOld() } , "Aguarde...", "Finalizando chamados antigos..." )
	EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Endereca a funcao de BROWSE                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea(cStrCad)
	dbSetOrder(1)

//Faz a pergunta e monta filtro
	aRetPerg := fFiltroSZJ()

//Se pergunta confirmada, executa filtro, caso contrario, sai da rotina
	If aRetPerg[1]
		cFilSZJ := aRetPerg[2]
		aIndexSZJ := {}

		//If !Empty(cFilSZJ)
		//	bFiltraBrw := {|| FilBrowse(cStrCad,@aIndexSZJ,@cFilSZJ) }
		//	Eval(bFiltraBrw)
		//EndIf

		mBrowse(6,1,22,75,cStrCad,aFixe,,,,,aCores,,,,,,,,cFilSZJ)

		//Limpar filtro
		//dbSelectArea(cStrCad)
		//EndFilBrw(cStrCad,aIndexSZJ)

		SetMBTopFilter(cStrCad, "")

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MtSZJFil บAutor  ณ Felipe A. Melo     บ Data ณ  11/03/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MtSZJFil()

//Faz a pergunta e monta filtro
	Local aRetPerg := fFiltroSZJ()
	Local oObjMBrw := GetObjBrow()

//Se pergunta confirmada, executa filtro, caso contrario, sai da rotina
	If aRetPerg[1]
		//Limpar filtro
		SetMBTopFilter(cStrCad, "")

		cFilSZJ := aRetPerg[2]
		aIndexSZJ := {}

		If !Empty(cFilSZJ)
			oObjMBrw:ResetLen()
			(cStrCad)->(DbClearFilter())

			SetMBTopFilter(cStrCad,cFilSZJ,,.T.)

			DbSelectArea(cStrCad)
			(cStrCad)->(dbGoTop())

			oObjMBrw:GoPgDown()
			oObjMBrw:Refresh()

			oObjMBrw:GoTop()
			oObjMBrw:Refresh()

			oObjMBrw:GoPgUp()
			oObjMBrw:Refresh()
		EndIf

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  ณfFiltroSZJบAutor  ณ Felipe A. Melo     บ Data ณ  28/08/2013 บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ P11                                                        บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fFiltroSZJ()

	Local lRet      := .F.
	Local cRet      := ""
	Local aPerg     := {}
	Local aParam    := {}

	Local cPerg1Tit := "Situa็๕es"
	Local aPerg1Arr := {}
	Local cPerg1Vld := ".T."
	Local cPerg1Tam := 120
	Local cPerg1Obg := .T.

	Local cPerg2Tit := "Chamados"
	Local aPerg2Arr := {}
	Local cPerg2Vld := ".T."
	Local cPerg2Tam := 70
	Local cPerg2Obg := .T.

	Local cPerg3Tit := "Classificacao"
	Local aPerg3Arr := {}
	Local cPerg3Vld := ".T."
	Local cPerg3Tam := 70
	Local cPerg3Obg := .T.



//Op็๕es da Pergunta 01
	aAdd(aPerg1Arr,"1=Todas Situa็๕es")
	aAdd(aPerg1Arr,"2=Chamado novo, aguardando tecnico")
	aAdd(aPerg1Arr,"3=Em atendimento, aguardando tecnico")
	aAdd(aPerg1Arr,"4=Em atendimento, aguardando solicitante")
	aAdd(aPerg1Arr,"5=Fechado e resolvido")
	aAdd(aPerg1Arr,"6=Fechado e cancelado")

//Op็๕es da Pergunta 02
	aAdd(aPerg2Arr,"1=Todos Chamados")
	aAdd(aPerg2Arr,"2=Meus Chamados")


//Op็๕es da Pergunta 03
	aAdd(aPerg3Arr,"0=Todas Classific.")
	aAdd(aPerg3Arr,"1=Suporte N1")
	aAdd(aPerg3Arr,"2=Suporte N2")
	aAdd(aPerg3Arr,"3=Suporte N3")
	aAdd(aPerg3Arr,"4=Melhorias")

	Private mv_par01 := "1"
	Private mv_par02 := "2"
	Private mv_par03 := "0"

	If cTipoHlp == '1'
		Private cParRom  := "FILTRO1SZJ"+SM0->M0_CODIGO+SM0->M0_CODFIL
	EndIf

	If cTipoHlp == '2'
		Private cParRom  := "FILTRO2SZJ"+SM0->M0_CODIGO+SM0->M0_CODFIL
	EndIf

	If cTipoHlp == '3'
		Private cParRom  := "FILTRO2SZJ"+SM0->M0_CODIGO+SM0->M0_CODFIL
	EndIf
	
	If cTipoHlp == '4'
		Private cParRom  := "FILTRO2SZJ"+SM0->M0_CODIGO+SM0->M0_CODFIL
	EndIf

	aAdd(aPerg,{2           ,;
		cPerg1Tit   ,;
		mv_par01    ,;
		aPerg1Arr   ,;
		cPerg1Tam   ,;
		cPerg1Vld   ,;
		cPerg1Obg	})
	aAdd(aParam,mv_par01)

	If __cUserID $ cCodTec
		aAdd(aPerg,{2           ,;
			cPerg2Tit   ,;
			mv_par02    ,;
			aPerg2Arr   ,;
			cPerg2Tam   ,;
			cPerg2Vld   ,;
			cPerg2Obg	})
		aAdd(aParam,mv_par02)

		aAdd(aPerg,{2           ,;
			cPerg3Tit   ,;
			mv_par03    ,;
			aPerg3Arr   ,;
			cPerg3Tam   ,;
			cPerg3Vld   ,;
			cPerg3Obg	})
		aAdd(aParam,mv_par03)


	EndIf

	If ParamBox(aPerg,"Filtro Service Desk",@aParam,,,,,,,cParRom,.T.,.T.)


		Do Case
			//"1=Todas"
		Case SubStr(mv_par01,1,1) == "1"
			cRet := ""

			//"2=Chamado novo, aguardando tecnico"
		Case SubStr(mv_par01,1,1) == "2"
			cRet := "ZJ_STATUS='P' AND ZJ_SITUAC='T' "

			//"3=Em atendimento, aguardando tecnico"
		Case SubStr(mv_par01,1,1) == "3"
			cRet := "ZJ_STATUS='A' AND ZJ_SITUAC='T' "

			//"4=Em atendimento, aguardando solicitante"
		Case SubStr(mv_par01,1,1) == "4"
			cRet := "ZJ_STATUS='A' AND ZJ_SITUAC='S' "

			//"5=Fechado e resolvido"
		Case SubStr(mv_par01,1,1) == "5"
			cRet := "ZJ_STATUS='F' AND ZJ_SITUAC='R' "

			//"6=Fechado e cancelado"
		Case SubStr(mv_par01,1,1) == "6"
			cRet := "ZJ_STATUS='F' AND ZJ_SITUAC='C' "

		EndCase

		// Filtra Setor do Usuario Por Michel A. Sander em 20.03.2019
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Filtra Setor				                                      ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cRet += IIf(Empty(cRet),""," AND ")
		cRet += "ZJ_TIPO='"+cTipoHlp+"'  "

		If __cUserID $ cCodTec
			Do Case
				//"1=Todos Chamados"
			Case SubStr(mv_par02,1,1) == "1"
				cRet += ''

				//"2=Meus Chamados"
			Case SubStr(mv_par02,1,1) == "2"
				cRet += IIf(Empty(cRet),""," AND ")
				cRet += "(ZJ_COD_SOL='"+__cUserID+"' OR ZJ_COD_TEC='"+__cUserID+"')"
	
				// Classificacao
				// 0=Todas Classific.
			Case SubStr(mv_par03,1,1) == "0"
				cRet += ''

			EndCase

			Do Case
				// 1=Suporte N1
			Case SubStr(mv_par03,1,1) == "1"
				cRet += IIf(Empty(cRet),""," AND ")
				cRet += "ZJ_CLASSIF='1'  "

				// 2=Suporte N2
			Case SubStr(mv_par03,1,1) == "2"
				cRet += IIf(Empty(cRet),""," AND ")
				cRet += "ZJ_CLASSIF='2'  "

				// 3=Suporte N3
			Case SubStr(mv_par03,1,1) == "3"
				cRet += IIf(Empty(cRet),""," AND ")
				cRet += "ZJ_CLASSIF='3'  "

				//4=Melhorias
			Case SubStr(mv_par03,1,1) == "4"
				cRet += IIf(Empty(cRet),""," AND ")
				cRet += "ZJ_CLASSIF='4'  "

			EndCase
		Else
			cRet += IIf(Empty(cRet),""," AND ")
			cRet += " ZJ_COD_SOL='"+__cUserID+"' "
		EndIf

		lRet := .T.
	EndIf

Return({lRet,cRet})

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  ณ fMenu    บAutor  ณ Felipe A. Melo     บ Data ณ  03/07/2013 บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ P11                                                        บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fMenu()

/*
Local aRotina := {;
{ OemToAnsi("Pesquisar")      ,"AxPesqui"     ,  0 , 1},;
{ OemToAnsi("Visualizar")     ,"U_MtCadSZJ"   ,  0 , 2},;
{ OemToAnsi("Incluir")        ,"U_MtCadSZJ"   ,  0 , 3},;
{ OemToAnsi("Alterar")        ,"U_MtCadSZJ"   ,  0 , 4},;
{ OemToAnsi("Cancelar")       ,"U_MtSZJCan"   ,  0 , 4},;
{ OemToAnsi("Resolvido")      ,"U_MtSZJFec"   ,  0 , 4},;
{ OemToAnsi("Reabrir")        ,"U_MtSZJRea"   ,  0 , 4},;
{ OemToAnsi("Relatorio")      ,"U_Rel01SZJ"   ,  0 , 3},;
{ OemToAnsi("Env.Email")      ,"U_MtSZJEnv"   ,  0 , 4},;
{ OemToAnsi("Filtrar Chamado"),"U_MtSZJFil"   ,  0 , 4},;
{ OemToAnsi("Legenda")        ,"U_MtLegSZJ"   ,  0 , 3} }
//{ OemToAnsi("Excluir")   ,"U_MtCadSZJ"   ,  0 , 5},;
*/

	Local aRotina := {}

	AAdd( aRotina, { OemToAnsi("Pesquisar"	)		 ,"AxPesqui"     ,  0 , 1})
	AAdd( aRotina, { OemToAnsi("Visualizar")     ,"U_MtCadSZJ"   ,  0 , 2})
	AAdd( aRotina, { OemToAnsi("Incluir")        ,"U_MtCadSZJ"   ,  0 , 3})
	AAdd( aRotina, { OemToAnsi("Alterar")        ,"U_MtCadSZJ"   ,  0 , 4})
	AAdd( aRotina, { OemToAnsi("Cancelar")       ,"U_MtSZJCan"   ,  0 , 4})
	AAdd( aRotina, { OemToAnsi("Resolvido")      ,"U_MtSZJFec"   ,  0 , 4})
	AAdd( aRotina, { OemToAnsi("Reabrir")        ,"U_MtSZJRea"   ,  0 , 4})
	AAdd( aRotina, { OemToAnsi("Relatorio")      ,"U_Rel01SZJ"   ,  0 , 3})
	AAdd( aRotina, { OemToAnsi("Env.Email")      ,"U_MtSZJEnv"   ,  0 , 4})
	AAdd( aRotina, { OemToAnsi("Filtrar Chamado"),"U_MtSZJFil"   ,  0 , 4})
	If __cUserID $ cCodTec
		AAdd( aRotina, { OemToAnsi("Classificar")               ,"U_MtClass"        ,  0 , 2})
		AAdd( aRotina, { OemToAnsi("Encaminhar OpusVP")         ,"U_fEncOPUS"       ,  0 , 2})
		AAdd( aRotina, { OemToAnsi("Sincroniza็ใo OpusVP <F5>") ,"U_SITBOPUS(1000)" ,  0 , 2})
		SetKey(VK_F5, { || U_SITBOPUS(1000) } )
		//aAdd(aButtons,{"Documento",{||fEncOPUS(cAlias, nReg, nOpc,,4,@aRetDoc)}, "Encaminhar OpusVP"    , "Encaminhar OpusVP"    })
	EndIf
	AAdd( aRotina, { OemToAnsi("Legenda")        ,"U_MtLegSZJ"   ,  0 , 3})
	AAdd( aRotina, { OemToAnsi("Data Previsao")	,"U_MtSZJDtP"	 ,  0 , 3})


Return(aRotina)


User Function MtSZJDtP()

	Static oDlg
	Static oButton1
	Static oGet1
	Static dGet1 := SZJ->ZJ_PREVIS
	Static oSay1

	dGet1 := SZJ->ZJ_PREVIS

	DEFINE MSDIALOG oDlg TITLE "Data de Previsao" FROM 000, 000  TO 100, 200 COLORS 0, 16777215 PIXEL

	@ 014, 018 MSGET oGet1 VAR dGet1 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 035, 030 BUTTON oButton1 PROMPT "Confirmar" SIZE 037, 012 ACTION AltData() OF oDlg PIXEL
	@ 004, 004 SAY oSay1 PROMPT "Data da Previsao" SIZE 093, 007 OF oDlg COLORS 0, 16777215 PIXEL

	ACTIVATE MSDIALOG oDlg

Return

Static Function AltData()

	If RecLock("SZJ",.F.)
		SZJ->ZJ_PREVIS := dGet1
		SZJ->(MsUnlock())
		Alert("Data Alterada com sucesso.")
		oDlg:End()
	EndIf

Return

//===========================================================================
User Function MtSZJEnv()

	If __cUserID $ cCodTec
		U_fEnviaWf(SZJ->ZJ_NUMCHAM,,cTipoHlp)
	Else
		Alert("Somente o t้cnico pode for็ar envio do chamado por e-mail!")
	EndIf

Return
//===========================================================================

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  ณ MtSZJCan บAutor  ณ Felipe A. Melo     บ Data ณ  09/02/2014 บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ P11                                                        บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MtSZJCan()

	If __cUserID == SZJ->ZJ_COD_SOL
		If SimNao("Confirma cancelamento do chamado?"+Chr(13)+Chr(10)+"Caso Sim, o mesmo serแ fechado!") == "S"
			//Trata fechamento do chamado / Cancelado
			RecLock("SZJ",.F.)
			SZJ->ZJ_STATUS  := "F"
			SZJ->ZJ_SITUAC  := "C"
			SZJ->ZJ_DT_FECH := Date()
			SZJ->ZJ_HR_FECH := Time()
			SZJ->(MsUnLock())

			//Envia Email
			U_fEnviaWf(SZJ->ZJ_NUMCHAM,4,cTipoHlp)
		EndIf
	Else
		Alert("Somente o solicitante do chamado poderแ cancelar o mesmo!")
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  ณ MtSZJFec บAutor  ณ Felipe A. Melo     บ Data ณ  09/02/2014 บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ P11                                                        บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MtSZJFec()

	If __cUserID == SZJ->ZJ_COD_SOL
		If SimNao("Confirma solu็ใo do chamado?"+Chr(13)+Chr(10)+"Caso Sim, o mesmo serแ fechado!") == "S"
			//Trata fechamento do chamado / Resolvido
			RecLock("SZJ",.F.)
			SZJ->ZJ_STATUS  := "F"
			SZJ->ZJ_SITUAC  := "R"
			SZJ->ZJ_DT_FECH := Date()
			SZJ->ZJ_HR_FECH := Time()
			SZJ->(MsUnLock())

			//Envia Email
			U_fEnviaWf(SZJ->ZJ_NUMCHAM,4,cTipoHlp)
		EndIf
	Else
		Alert("Somente o solicitante do chamado poderแ confirmar solu็ใo do mesmo!")
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  ณ MtSZJFec บAutor  ณ Felipe A. Melo     บ Data ณ  09/02/2014 บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ P11                                                        บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MtSZJRea()

	If __cUserID $ cCodTec
		If SimNao("Confirma reabertura do chamado?"+Chr(13)+Chr(10)+"Caso Sim, o mesmo serแ reaberto!") == "S"
			//Trata fechamento do chamado / Resolvido
			RecLock("SZJ",.F.)
			SZJ->ZJ_STATUS  := "A"
			SZJ->ZJ_SITUAC  := "T"
			SZJ->ZJ_DT_FECH := StoD("")
			SZJ->ZJ_HR_FECH := ""
			SZJ->(MsUnLock())

			//Envia Email
			U_fEnviaWf(SZJ->ZJ_NUMCHAM,4,cTipoHlp)
		EndIf
	Else
		Alert("Somente um tecnico poderแ reabrir o chamado!")
	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออุออออออุออออออออออออบฑฑ
ฑฑบPrograma  ณ MtClass  บAutor  ณ Marco Aurelio       บ Data ณ30/03/2017  บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออฯอออออออออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MtClass()

	If __cUserID $ cCodTec

		RecLock("SZJ",.F.)
		if SZJ->ZJ_CLASSIF $ "1"
			SZJ->ZJ_CLASSIF := "4"
		else
			SZJ->ZJ_CLASSIF := "1"
		endif
		SZJ->(MsUnLock())
	Else
		Alert("Somente um tecnico poderแ alterar a Classificacao!")
	EndIf

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  ณ MtLegSZJ บAutor  ณ Felipe A. Melo     บ Data ณ  15/08/2013 บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ P11                                                        บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MtLegSZJ()

	Local cCadLeg	:= "Status Service Desk"
	Local aLegenda	:= {}

	aAdd(aLegenda,{'BR_VERDE'    ,'Chamado novo, aguardando t้cnico'         })
	aAdd(aLegenda,{'BR_AMARELO'  ,'Em atendimento, aguardando t้cnico'       })
	aAdd(aLegenda,{'BR_LARANJA'  ,'Em atendimento, aguardando solicitante'   })
	aAdd(aLegenda,{'BR_VERMELHO' ,'Fechado e resolvido'                      })
	aAdd(aLegenda,{'BR_PRETO'    ,'Fechado e cancelado'                      })
	aAdd(aLegenda,{'BR_BRANCO'   ,'Solicitado envio para Consultoria OpusVP' })
	aAdd(aLegenda,{'BR_AZUL'     ,'Encaminhado para Consultoria OpusVP'      })

	BrwLegenda(cCadLeg,"Legenda",aLegenda)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  ณ MtVldSZJ บAutor  ณ Felipe A. Melo     บ Data ณ  15/08/2013 บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ P11                                                        บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MtVldSZJ(cCpoVld)

	Local lRet := .T.
	Default cCpoVld := ""

	Do Case
	Case cCpoVld == "CABEC"
		If lRet .And. Empty(M->ZJ_COD_TEC) .And. __cUserID != M->ZJ_COD_SOL
			Alert("Favor informar no cabe็alho o Codigo do T้cnico que estแ atendendo o chamado!")
			lRet := .F.
		EndIf
		//If lRet .And. Empty(M->ZJ_COD_TEC) .And. Len(oGdInter:aCols) > 1
		//	Alert("Favor informar no cabe็alho o Codigo do T้cnico que estแ atendendo o chamado!")
		//	lRet := .F.
		//EndIf

	Case cCpoVld == "ZJ_STATUS"
		If lRet .And. !Empty(M->ZJ_COD_TEC)
			lRet := fVldStatus()
		EndIf

	Case cCpoVld == "ZJ_SITUAC"
		If lRet .And. !Empty(M->ZJ_COD_TEC)
			lRet := fVldSituac()
		EndIf

	EndCase

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  ณfVldStatusบAutor  ณ Felipe A. Melo     บ Data ณ  15/08/2013 บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ P11                                                        บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fVldStatus()

	Local lRet := .T.

	Do Case
	Case M->ZJ_STATUS == "P" .And. M->ZJ_SITUAC != "T"
		Alert("O Status 'Chamado Novo' ้ para abertura do chamado e obrigatoriamente deve ser combinado com a Situa็ใo 'Aguardando Tecnico'!")
		M->ZJ_SITUAC := "T"
		lRet := .F.

	Case M->ZJ_STATUS == "A" .And. M->ZJ_SITUAC != "T" .And. M->ZJ_SITUAC != "S"
		Alert("O Status 'Em atendimento' ้ para atendimento do chamado e obrigatoriamente deve ser combinado com a Situa็ใo 'Aguardando Tecnico ou Solicitante'!")
		M->ZJ_SITUAC := "T"
		lRet := .F.

	Case M->ZJ_STATUS == "F" .And. M->ZJ_SITUAC != "R" .And. M->ZJ_SITUAC != "C"
		Alert("O Status 'Fechado' ้ para fechamento do chamado e obrigatoriamente deve ser combinado com a Situa็ใo 'Resolvido ou Cancelado'!")
		M->ZJ_SITUAC := "R"
		lRet := .F.

	EndCase

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  ณfVldSituacบAutor  ณ Felipe A. Melo     บ Data ณ  15/08/2013 บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ P11                                                        บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fVldSituac()

	Local lRet := .T.

	Do Case
	Case M->ZJ_SITUAC == "T" .And. M->ZJ_STATUS != "P" .And. M->ZJ_STATUS != "A"
		//Alert("A Situa็ใo 'Aguardando Tecnico' s๓ pode deve ser combinado com o Status 'Em Atendimento ou Chamado Novo'!")
		//lRet := .F.
		If Len(oGdInter:aCols) > 1
			M->ZJ_STATUS := "A"
		Else
			M->ZJ_STATUS := "P"
		EndIf

	Case M->ZJ_SITUAC == "S" .And. M->ZJ_STATUS != "P" .And. M->ZJ_STATUS != "A"
		//Alert("A Situa็ใo 'Aguardando Solicitante' s๓ pode deve ser combinado com o Status 'Em Atendimento ou Chamado Novo'!")
		//lRet := .F.
		M->ZJ_STATUS := "A"

	Case M->ZJ_SITUAC == "R" .And. M->ZJ_STATUS != "F"
		//Alert("A Situa็ใo 'Resolvido' s๓ pode deve ser combinado com o Status 'Fechado'!")
		//lRet := .F.
		M->ZJ_STATUS := "F"

	Case M->ZJ_SITUAC == "C" .And. M->ZJ_STATUS != "F"
		//Alert("A Situa็ใo 'Cancelado' s๓ pode deve ser combinado com o Status 'Fechado'!")
		//lRet := .F.
		M->ZJ_STATUS := "F"

	EndCase

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fCriaSX  บAutor  ณ Felipe A. Melo     บ Data ณ  03/07/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fCriaSX()

//SZJ - Service Desk - Cabecalho
//SZK - Service Desk - Interacoes
//SZL - Service Desk - Anexos
//SZM - Service Desk - Cad. Categorias

//Cria Tabela
	fCriaSX2()
//Cria Campos
	fCriaSX3()
//Cria Indice
	fCriaSIX()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fCriaSX2 บAutor  ณ Felipe A. Melo     บ Data ณ  03/07/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fCriaSX2()

//SZJ - Service Desk - Cabecalho
//SZK - Service Desk - Interacoes
//SZL - Service Desk - Anexos
//SZM - Service Desk - Cad. Categorias

	Local cPath  := ""
	Local cNome  := ""
	Local aEstrut:= {}
	Local aSX2   := {}
	Local i      := 0
	Local j      := 0

	aEstrut := {"X2_CHAVE","X2_PATH"   ,"X2_ARQUIVO","X2_NOME"                       ,"X2_NOMESPA"                    ,"X2_NOMEENG"                    ,"X2_DELET","X2_MODO","X2_MODOUN","X2_MODOEMP","X2_TTS","X2_ROTINA","X2_PYME","X2_UNICO"}
	Aadd(aSX2, {"SZJ"     ,""          ,""          ,"Service Desk - Cabecalho"      ,"Service Desk - Cabecalho"      ,"Service Desk - Cabecalho"      ,0         ,"C"      ,"C"        ,"C"         ,""      ,""         ,"N"      ,""        })
	Aadd(aSX2, {"SZK"     ,""          ,""          ,"Service Desk - Interacoes"     ,"Service Desk - Interacoes"     ,"Service Desk - Interacoes"     ,0         ,"C"      ,"C"        ,"C"         ,""      ,""         ,"N"      ,""        })
	Aadd(aSX2, {"SZL"     ,""          ,""          ,"Service Desk - Anexos"         ,"Service Desk - Anexos"         ,"Service Desk - Anexos"         ,0         ,"C"      ,"C"        ,"C"         ,""      ,""         ,"N"      ,""        })
	Aadd(aSX2, {"SZM"     ,""          ,""          ,"Service Desk - Cad. Categorias","Service Desk - Cad. Categorias","Service Desk - Cad. Categorias",0         ,"C"      ,"C"        ,"C"         ,""      ,""         ,"N"      ,""        })




	dbSelectArea("SX2")
	dbSetOrder(1)
	dbSeek("SA1")

	cPath := SX2->X2_PATH
	cNome := Substr(SX2->X2_ARQUIVO,4,5)

	For i:= 1 To Len(aSX2)
		If !Empty(aSX2[i][1])
			If !dbSeek(aSX2[i,1])
				RecLock("SX2",.T.)
				For j:=1 To Len(aSX2[i])
					If FieldPos(aEstrut[j]) > 0
						FieldPut(FieldPos(aEstrut[j]),aSX2[i,j])
					EndIf
				Next j
				SX2->X2_PATH    := cPath
				SX2->X2_ARQUIVO := aSX2[i,1]+cNome
				dbCommit()
				MsUnLock()
			EndIf
		EndIf
	Next i

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fCriaSX3 บAutor  ณ Felipe A. Melo     บ Data ณ  03/07/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fCriaSX3()

	Local aSX3       := {}
	Local cAlias     := ""
	Local aEstrut    := {}
	Local aCampos    := {}
	Local i          := 0
	Local j          := 0
	Local x 		 := 0
	Local lCriaPerg  := .F.

	Local cStatus    := "P=Chamado Novo;A=Em Atendimento;F=Fechado"
	Local cSitiac    := "T=Aguardando T้cnico;S=Aguardando Solicitante;R=Resolvido;C=Cancelado"
	Local cPriori    := "A=Alta(Sem Solucao de Contorno);M=Media(Com Solucao de Contorno);B=Baixa(Melhoria)"

//SZJ - TABELA
//             X3_CAMPO   ,X3_TIPO  ,X3_TAMANHO   ,X3_DECIMAL   ,X3_TITULO     ,X3_PICTURE,   X3_CBOX                        ,X3_F3         ,HELP                                     ,                                         ,                                         ,
	aCampos := {}
	aAdd(aCampos,{"ZJ_FILIAL" ,"C"      ,2            ,0            ,"Filial      ","@!"      ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       } })
	aAdd(aCampos,{"ZJ_NUMCHAM","C"      ,6            ,0            ,"Num. Chamado","@!"      ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       } })
	aAdd(aCampos,{"ZJ_QTDINTE","C"      ,3            ,0            ,"Q.Intera็๕es","@!"      ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       } })
	aAdd(aCampos,{"ZJ_DT_INC" ,"D"      ,8            ,0            ,"Dt Inclusใo ","@D"      ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       } })
	aAdd(aCampos,{"ZJ_HR_INC" ,"C"      ,8            ,0            ,"Hr Inclusใo ","@!"      ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       } })

	aAdd(aCampos,{"ZJ_STATUS" ,"C"      ,1            ,0            ,"Status      ","@!"      ,   cStatus                        ,""            ,{""                                        ,""                                       ,""                                       } })
	aAdd(aCampos,{"ZJ_COD_SOL","C"      ,6            ,0            ,"Cod. Solic. ","@!"      ,   ""                             ,"US2"         ,{""                                        ,""                                       ,""                                       } })
	aAdd(aCampos,{"ZJ_NOMESOL","C"      ,30           ,0            ,"Nome Solic. ","@!"      ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       } })
	aAdd(aCampos,{"ZJ_SITUAC" ,"C"      ,1            ,0            ,"Situa็ใo    ","@!"      ,   cSitiac                        ,""            ,{""                                        ,""                                       ,""                                       } })
	aAdd(aCampos,{"ZJ_COD_CAT","C"      ,6            ,0            ,"Cod. Categ. ","@!"      ,   ""                             ,"Z2"          ,{""                                        ,""                                       ,""                                       } })
	aAdd(aCampos,{"ZJ_NOMECAT","C"      ,30           ,0            ,"Descr.Categ.","@!"      ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       } })
	aAdd(aCampos,{"ZJ_PRIORID","C"      ,1            ,0            ,"Prioridade  ","@!"      ,   cPriori                        ,""            ,{""                                        ,""                                       ,""                                       } })
	aAdd(aCampos,{"ZJ_COD_TEC","C"      ,6            ,0            ,"Cod. Tecnico","@!"      ,   ""                             ,"US2"         ,{""                                        ,""                                       ,""                                       } })
	aAdd(aCampos,{"ZJ_NOMETEC","C"      ,30           ,0            ,"Nome Tecnico","@!"      ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       } })
	aAdd(aCampos,{"ZJ_ASSUNTO","C"      ,30           ,0            ,"Assunto     ","@!"      ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       } })
//Conforme array acima, monta array abaixo
	aEstrut :=      { "X3_ARQUIVO" ,"X3_ORDEM"   ,"X3_CAMPO"    ,"X3_TIPO"     ,"X3_TAMANHO"  ,"X3_DECIMAL"  ,"X3_TITULO"    ,"X3_TITSPA"    ,"X3_TITENG"    ,"X3_DESCRIC"   ,"X3_DESCSPA"   ,"X3_DESCENG"   ,"X3_PICTURE"         ,"X3_VALID"                              ,"X3_USADO"          ,"X3_RELACAO" ,"X3_F3"      ,"X3_NIVEL","X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER","X3_PROPRI" ,"X3_BROWSE"  ,"X3_VISUAL","X3_CONTEXT" ,"X3_OBRIGAT","X3_VLDUSER" ,"X3_CBOX"     ,"X3_CBOXSPA"  ,"X3_CBOXENG"  ,"X3_PICTVAR","X3_WHEN","X3_INIBRW","X3_GRPSXG","X3_FOLDER","X3_PYME","X3_CONDSQL"}
	For x:=1 To Len(aCampos)
		cAlias := "S"+SubStr(aCampos[x][1],1,2)
		If aCampos[x][1] $ "ZJ_FILIAL"
			Aadd(aSX3,{	cAlias       ,StrZero(x,2) ,aCampos[x][1] ,aCampos[x][2] ,aCampos[x][3] ,aCampos[x][4] ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][6]        ,"                                      ","€€€€€€€€€€€€€€€   ","           ",aCampos[x][8],1         ,"          ","          ","          ","P         ","N          ","A        ","R          ","          ","           ",aCampos[x][7] ,aCampos[x][7] ,aCampos[x][7] ,"          ","       ","         ","         ","         ","       ","          "})
		Else
			Aadd(aSX3,{	cAlias       ,StrZero(x,2) ,aCampos[x][1] ,aCampos[x][2] ,aCampos[x][3] ,aCampos[x][4] ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][6]        ,"                                      ","€€€€€€€€€€€€€€    ","           ",aCampos[x][8],1         ,"          ","          ","          ","P         ","S          ","A        ","R          ","          ","           ",aCampos[x][7] ,aCampos[x][7] ,aCampos[x][7] ,"          ","       ","         ","         ","         ","       ","          "})
		EndIF
	Next

//SZK - TABELA
//             X3_CAMPO   ,X3_TIPO  ,X3_TAMANHO   ,X3_DECIMAL   ,X3_TITULO     ,X3_PICTURE,   X3_CBOX                        ,X3_F3         ,HELP
	aCampos := {}
	aAdd(aCampos,{"ZK_FILIAL" ,"C"      ,2            ,0            ,"Filial      ","@!"      ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       } })
	aAdd(aCampos,{"ZK_NUMCHAM","C"      ,6            ,0            ,"Num. Chamado","@!"      ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       } })
	aAdd(aCampos,{"ZK_NUMINTE","C"      ,3            ,0            ,"N. Intera็ใo","@!"      ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       } })
	aAdd(aCampos,{"ZK_DT_INC" ,"D"      ,8            ,0            ,"Dt Inclusใo ","@D"      ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       } })
	aAdd(aCampos,{"ZK_HR_INC" ,"C"      ,8            ,0            ,"Hr Inclusใo ","@!"      ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       } })
	aAdd(aCampos,{"ZK_ORIGEM" ,"C"      ,1            ,0            ,"Orig. Inc.  ","@!"      ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       } })
	aAdd(aCampos,{"ZK_COD_ORI","C"      ,6            ,0            ,"Cod. Origem ","@!"      ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       } })
	aAdd(aCampos,{"ZK_NOMEORI","C"      ,30           ,0            ,"Nome Origem ","@!"      ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       } })
	aAdd(aCampos,{"ZK_DESCRIC","M"      ,10           ,0            ,"Descri็ใo   ","@!"      ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       } })
//Conforme array acima, monta array abaixo
	aEstrut :=      { "X3_ARQUIVO" ,"X3_ORDEM"   ,"X3_CAMPO"    ,"X3_TIPO"     ,"X3_TAMANHO"  ,"X3_DECIMAL"  ,"X3_TITULO"    ,"X3_TITSPA"    ,"X3_TITENG"    ,"X3_DESCRIC"   ,"X3_DESCSPA"   ,"X3_DESCENG"   ,"X3_PICTURE"         ,"X3_VALID"                              ,"X3_USADO"          ,"X3_RELACAO" ,"X3_F3"      ,"X3_NIVEL","X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER","X3_PROPRI" ,"X3_BROWSE"  ,"X3_VISUAL","X3_CONTEXT" ,"X3_OBRIGAT","X3_VLDUSER" ,"X3_CBOX"     ,"X3_CBOXSPA"  ,"X3_CBOXENG"  ,"X3_PICTVAR","X3_WHEN","X3_INIBRW","X3_GRPSXG","X3_FOLDER","X3_PYME","X3_CONDSQL"}
	For x:=1 To Len(aCampos)
		cAlias := "S"+SubStr(aCampos[x][1],1,2)
		If aCampos[x][1] $ "ZK_FILIAL/ZK_NUMCHAM"
			Aadd(aSX3,{	cAlias       ,StrZero(x,2) ,aCampos[x][1] ,aCampos[x][2] ,aCampos[x][3] ,aCampos[x][4] ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][6]        ,"                                      ","€€€€€€€€€€€€€€€   ","           ",aCampos[x][8],1         ,"          ","          ","          ","P         ","N          ","A        ","R          ","          ","           ",aCampos[x][7] ,aCampos[x][7] ,aCampos[x][7] ,"          ","       ","         ","         ","         ","       ","          "})
		Else
			Aadd(aSX3,{	cAlias       ,StrZero(x,2) ,aCampos[x][1] ,aCampos[x][2] ,aCampos[x][3] ,aCampos[x][4] ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][6]        ,"                                      ","€€€€€€€€€€€€€€    ","           ",aCampos[x][8],1         ,"          ","          ","          ","P         ","S          ","A        ","R          ","          ","           ",aCampos[x][7] ,aCampos[x][7] ,aCampos[x][7] ,"          ","       ","         ","         ","         ","       ","          "})
		EndIF
	Next

//SZL - TABELA
//             X3_CAMPO   ,X3_TIPO  ,X3_TAMANHO   ,X3_DECIMAL   ,X3_TITULO     ,X3_PICTURE,   X3_CBOX                        ,X3_F3         ,HELP
	aCampos := {}
	aAdd(aCampos,{"ZL_FILIAL" ,"C"      ,2            ,0            ,"Filial      ","@!"      ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       } })
	aAdd(aCampos,{"ZL_NUMCHAM","C"      ,6            ,0            ,"Num. Chamado","@!"      ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       } })
	aAdd(aCampos,{"ZL_NUMINTE","C"      ,3            ,0            ,"N. Anexo"    ,"@!"      ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       } })
	aAdd(aCampos,{"ZL_ARQUIVO","C"      ,100          ,0            ,"Arquivo"     ,"@!"      ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       } })
	aAdd(aCampos,{"ZL_DATA"   ,"D"      ,8            ,0            ,"Data"        ,"@!"      ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       } })
	aAdd(aCampos,{"ZL_HORA"   ,"C"      ,8            ,0            ,"Hora"        ,"@!"      ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       } })
	aAdd(aCampos,{"ZL_USUARIO","C"      ,30           ,0            ,"Usuแrio"     ,"@!"      ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       } })
	aAdd(aCampos,{"ZL_ORIGEM" ,"C"      ,200          ,0            ,"Bkp Origem"  ,"@!"      ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       } })
//Conforme array acima, monta array abaixo
	aEstrut :=      { "X3_ARQUIVO" ,"X3_ORDEM"   ,"X3_CAMPO"    ,"X3_TIPO"     ,"X3_TAMANHO"  ,"X3_DECIMAL"  ,"X3_TITULO"    ,"X3_TITSPA"    ,"X3_TITENG"    ,"X3_DESCRIC"   ,"X3_DESCSPA"   ,"X3_DESCENG"   ,"X3_PICTURE"         ,"X3_VALID"                              ,"X3_USADO"          ,"X3_RELACAO" ,"X3_F3"      ,"X3_NIVEL","X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER","X3_PROPRI" ,"X3_BROWSE"  ,"X3_VISUAL","X3_CONTEXT" ,"X3_OBRIGAT","X3_VLDUSER" ,"X3_CBOX"     ,"X3_CBOXSPA"  ,"X3_CBOXENG"  ,"X3_PICTVAR","X3_WHEN","X3_INIBRW","X3_GRPSXG","X3_FOLDER","X3_PYME","X3_CONDSQL"}
	For x:=1 To Len(aCampos)
		cAlias := "S"+SubStr(aCampos[x][1],1,2)
		If aCampos[x][1] $ "ZL_FILIAL/ZL_NUMCHAM"
			Aadd(aSX3,{	cAlias       ,StrZero(x,2) ,aCampos[x][1] ,aCampos[x][2] ,aCampos[x][3] ,aCampos[x][4] ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][6]        ,"                                      ","€€€€€€€€€€€€€€€   ","           ",aCampos[x][8],1         ,"          ","          ","          ","P         ","N          ","A        ","R          ","          ","           ",aCampos[x][7] ,aCampos[x][7] ,aCampos[x][7] ,"          ","       ","         ","         ","         ","       ","          "})
		Else
			Aadd(aSX3,{	cAlias       ,StrZero(x,2) ,aCampos[x][1] ,aCampos[x][2] ,aCampos[x][3] ,aCampos[x][4] ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][6]        ,"                                      ","€€€€€€€€€€€€€€    ","           ",aCampos[x][8],1         ,"          ","          ","          ","P         ","S          ","A        ","R          ","          ","           ",aCampos[x][7] ,aCampos[x][7] ,aCampos[x][7] ,"          ","       ","         ","         ","         ","       ","          "})
		EndIF
	Next

	dbSelectArea("SX3")
	dbSetOrder(2)

	For i:= 1 To Len(aSX3)
		If !Empty(aSX3[i][1])
			If !dbSeek(aSX3[i,3])
				RecLock("SX3",.T.)
				For j:=1 To Len(aSX3[i])
					If FieldPos(aEstrut[j])>0
						FieldPut(FieldPos(aEstrut[j]),aSX3[i,j])
					EndIf
				Next j
				dbCommit()
				MsUnLock()
				lCriaPerg := .T.
			EndIf
		EndIf
	Next i

//Cria Help dos campos
	If lCriaPerg
		fHelpCpo(aCampos,1,9)
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fHelpCpo บAutor  ณ Felipe A. Melo     บ Data ณ  03/07/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fHelpCpo(aCampos,nPosCpo,nPosHelp)

	Local x        := 00
	Local aHelpPor := {}
	Local aHelpEng := {}
	Local aHelpEsp := {}

	For x:=1 To Len(aCampos)
		aHelpPor := aCampos[x][nPosHelp]
		aHelpEng := aCampos[x][nPosHelp]
		aHelpEsp := aCampos[x][nPosHelp]
		PutHelp( "P"+aCampos[x][nPosCpo],aHelpPor, aHelpEng, aHelpEsp, .T. )
	Next x

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fCriaSIX บAutor  ณ Felipe A. Melo     บ Data ณ  03/07/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fCriaSIX()

	Local aSIX   := {}
	Local aEstrut:= {}
	Local i      := 0
	Local j      := 0

	aEstrut := {"INDICE","ORDEM","CHAVE","DESCRICAO","DESCSPA","DESCENG","PROPRI","F3","NICKNAME"}

//------------------- SZJ -------------------
	Aadd(aSIX,{	"SZJ","1","ZJ_FILIAL+ZJ_NUMCHAM",;
		"Num. Chamado ",;
		"Num. Chamado ",;
		"Num. Chamado ",;
		"S","",""})

//------------------- SZK -------------------
	Aadd(aSIX,{	"SZK","1","ZK_FILIAL+ZK_NUMCHAM+ZK_NUMINTE",;
		"Num. Chamado + Num. Intera็ใo",;
		"Num. Chamado + Num. Intera็ใo",;
		"Num. Chamado + Num. Intera็ใo",;
		"S","",""})

//------------------- SZK -------------------
	Aadd(aSIX,{	"SZL","1","ZL_FILIAL+ZL_NUMCHAM+ZL_NUMINTE",;
		"Num. Chamado + Num. Intera็ใo",;
		"Num. Chamado + Num. Intera็ใo",;
		"Num. Chamado + Num. Intera็ใo",;
		"S","",""})

	dbSelectArea("SIX")
	dbSetOrder(1)

	For i:= 1 To Len(aSIX)
		If !Empty(aSIX[i,1])
			If !dbSeek(aSIX[i,1]+aSIX[i,2])
				RecLock("SIX",.T.)
				For j:=1 To Len(aSIX[i])
					If FieldPos(aEstrut[j])>0
						FieldPut(FieldPos(aEstrut[j]),aSIX[i,j])
					EndIf
				Next j
				dbCommit()
				MsUnLock()
			EndIf
		EndIf
	Next i

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  บ MtCadSZJ บAutor  บFelipe Aur้lio de Melo บ Data บ 10/07/13 บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ P11                                                        บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MtCadSZJ(cAlias,nReg,nOpc)

	Local cAlias2     := "SZK"
	Local nRegis2     := Nil

	Local aRetDoc     := {}

	Private INCLUI  := .F.
	Private ALTERA  := .F.
	Private EXCLUI  := .F.
	Private TECNICO := .F. //Nใo posso esquecer de tratar essa variavel (X3_WHEN)

	Private nSaveSx8Len := (cAlias)->(GetSx8Len())

	Private nPosInter := Nil
	Private nPosAnexo := Nil
	Private oGdInter  := Nil
	Private oGdAnexo  := Nil

	Private oMmInter  := Nil
	Private cTxInter  := ""

	Private oOrigDesc := Nil
	Private cOrigDesc := ""

	Private oBtnSvMm  := Nil
	Private oBtnAnex  := Nil
	Private oBtnAbri  := Nil

	Private oDialg
	Private oEnchc
	Private oFolder

	Private aFolder   := {}
	Private aExibe    := {}
	Private aGets     := {}
	Private aTela     := {}
	Private aGets1     := {}
	Private aTela1     := {}
	Private aButtons   := {}
	Private nOpcao     := 0
	Private bOk        := { || IIf(nOpc==3.Or.nOpc==4,IIf(Obrigatorio(aGets1,aTela1) .And. oGdInter:TudoOk() .And. U_MtVldSZJ("CABEC") , (nOpcao:=1,oDialg:End()) , nOpcao := 0),(nOpcao:=1,oDialg:End())) }
	Private bCancel    := { || nOpcao:=0 , oDialg:End() }
	Private nSuperior  := 0
	Private nEsquerda  := 0
	Private nInferior  := 0
	Private nInferiort := 0
	Private nPHortot   := 0
	Private nPVertot   := 0
	Private nTotpeds   := 0

	Private nDireita  := 0
	Private aSizeAut  := {}
	Private aObjects  := {}
	Private aInfo     := {}
	Private aPosGet   := {}
	Private aPosObj   := {}

	Private cSlvAnexos := "\ServiceDesk\Anexos\"

	Default cAlias    := "SZJ"
	Default nReg      := IIf(nOpc==3,Nil,(cAlias)->(Recno()))

// Fun็ใo de sincroniza็ใo do SZ4 (projetos). Roda com StartJob Falso, ou seja, nใo fica aguardando a execu็ใo

//If Upper(GetEnvServ()) <> "MICHEL.OPUS" .AND. Upper(GetEnvServ()) <> "HELIO.OPUS"
//	U_SincSZ4()
//EndIf

	If __cUserID $ cCodTec
		TECNICO := .T.
	EndIf

// Maximizacao da tela em rela็ใo a area de trabalho
	aSizeAut := MsAdvSize()
	aInfo    := {aSizeAut[1],aSizeAut[2],aSizeAut[3],aSizeAut[4],3,3}

	aAdd(aObjects,{100,065,.T.,.T.})
	aAdd(aObjects,{100,035,.T.,.T.})
	aPosObj   := MsObjSize(aInfo,aObjects)
	aPosObj1  := MsObjSize(aInfo,aObjects)

	nSuperior  := 002
	nEsquerda  := 003
	nInferior  := aPosObj[2,3]-(aPosObj[2,1]+15)
	nDireita   := aPosObj[2,4]-(aPosObj[2,2]+04)
	nInferiort := aPosObj[2,3]-(aPosObj[2,1]+30)
	nPHortot   := aPosObj[2,4]-(aPosObj[2,2]+85)
	nPVertot   := aPosObj[2,3]-(aPosObj[2,1]+21)

	cVarCampo := ""

// Verifica o tipo de chamada e trata a situa็ใo
	Do Case
	Case nOpc == 2	//Visualiza็ใo
		nOpEch := 2
		aExibe := fInitVarX3(cAlias ,.F.,"")
		INCLUI := .F.
		ALTERA := .F.
		EXCLUI := .F.

	Case nOpc == 3	//Inclusใo
		nOpEch := 3
		aExibe := fInitVarX3(cAlias ,.T.,"")
		INCLUI := .T.
		ALTERA := .F.
		EXCLUI := .F.
		M->ZJ_TIPO := cTipoHlp
		aAdd(aButtons,{"Documento",{||MsDocument(cAlias, nReg, nOpc,,4,@aRetDoc)}, "Banco de Conhecimento", "Banco de Conhecimento"})

	Case nOpc == 4	//Altera็ใo
		nOpEch := 3
		aExibe := fInitVarX3(cAlias ,.F.,"")
		INCLUI := .F.
		ALTERA := .T.
		EXCLUI := .F.
		aAdd(aButtons,{"Documento",{||MsDocument(cAlias, nReg, nOpc,,4,@aRetDoc)}, "Banco de Conhecimento", "Banco de Conhecimento"})
		aAdd(aButtons,{"Documento",{||U_fEncOPUS(cAlias, nReg, nOpc,,4,@aRetDoc)}, "Encaminhar OpusVP"    , "Encaminhar OpusVP"    })

	Case nOpc == 5	//Exclusใo
		nOpEch := 5
		aExibe := fInitVarX3(cAlias ,.F.,"")
		INCLUI := .F.
		ALTERA := .F.
		EXCLUI := .T.

	Otherwise //Outras situa็๕es
		nOpEch := 2
		aExibe := fInitVarX3(cAlias ,.F.,"")
		INCLUI := .F.
		ALTERA := .F.
		EXCLUI := .F.

	EndCase

//Valida se ้ altera็ใo de um chamado fechado
	If ALTERA .And. SZJ->ZJ_STATUS == "F" //.And. !TECNICO
		Alert("O chamado "+SZJ->ZJ_NUMCHAM+" estแ fechado e por isso nใo pode ser alterado!")
		If Date() > StoD('20180831')
			Return
		Else
			MsgInfo("Altera็ใo permitida at้ 31/08/18")
		EndIf
	EndIf

//Monta Array com os Folders
	aAdd(aFolder	,"Intera็๕es"   )
	nPosInter := Len(aFolder)
	aAdd(aFolder	,"Anexos"       )
	nPosAnexo   := Len(aFolder)

// Montagem da tela que serah apresentada para usuario (lay-out)
	Define MsDialog oDialg Title cCadastro From aSizeAut[7],0 To aSizeAut[6],aSizeAut[5] Of oMainWnd Pixel

/*Cabe็alho		*/ oEnchc := Msmget():New(cAlias,nReg  ,nOpEch,,,,aExibe ,aPosObj[1],aExibe,,,,,oDialg,,.T.,,'aTela1')
/*Cabe็alho		*/ aGets1 := aclone(oEnchc:aGets)
/*Cabe็alho		*/ aTela1 := aclone(oEnchc:aTela)
/*Cabe็alho		*/ aGets  := {}
/*Cabe็alho		*/ aTela  := {}

/*Folders		*/ oFolder:= TFolder():New(aPosObj[2,1],aPosObj[2,2],aFolder,{"HEADER"},oDialg,,,,.T.,.F.,aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]-aPosObj[2,1])

/*Intera็๕es   */ fGDInter(nOpc,nPosInter,@oGdInter)
/*Anexos       */ fGDAnexo(nOpc,nPosAnexo,@oGdAnexo)

	Activate MsDialog oDialg On Init EnchoiceBar(oDialg,bOk,bCancel,,aButtons)

	Do Case
		//Se for inclusao e foi cancelado
	Case nOpc == 3 .And. nOpcao == 0
		While (cAlias)->(GetSx8Len()) > nSaveSx8Len
			(cAlias)->(RollBackSx8())
		End

		//Se for inclusao e foi confirmado
	Case nOpc == 3 .And. nOpcao == 1
		fSalvaTudo(nOpc,cAlias)
		U_fEnviaWf(SZJ->ZJ_NUMCHAM,nOpc,cTipoHlp)

		//Se for alteracao e foi confirmado
	Case nOpc == 4 .And. nOpcao == 1
		fSalvaTudo(nOpc,cAlias)
		U_fEnviaWf(SZJ->ZJ_NUMCHAM,nOpc,cTipoHlp)

		//Se for exclusao e foi confirmado
	Case nOpc == 5 .And. nOpcao == 1
		fExcluiTudo()

	EndCase

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  บ fGDInter บAutor  บFelipe Aur้lio de Melo บ Data บ09/08/2013บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ P11                                                        บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGDInter(hcOpc,nPosFolder,oGdInter)

// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia
	Local cGetOpc        := IIf(hcOpc==2,Nil,GD_INSERT+GD_UPDATE)           // GD_INSERT+GD_DELETE+GD_UPDATE
	Local cLinhaOk       := Nil//"U_CADZKLOk"                               // Funcao executada para validar o contexto da linha atual do aCols
	Local cTudoOk        := Nil//"U_CADZKTOk"                               // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
	Local cIniCpos       := "+ZK_NUMINTE"                                   // Nome dos campos do tipo caracter que utilizarao incremento automatico.
	Local nFreeze        := Nil                                             // Campos estaticos na GetDados.
	Local nMax           := 999                                             // Numero maximo de linhas permitidas. Valor padrao 99
	Local cCampoOk       := Nil//"U_CADZKCPO"                               // Funcao executada na validacao do campo
	Local cSuperApagar   := Nil                                             // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
	Local cApagaOk       := Nil                                             // Funcao executada para validar a exclusao de uma linha do aCols
	Local aCpoItem       := {}                                              // Array com os campos que deverใo ser tratados quando rotina de inclusใo
	Local aHead          := {}                                              // Array do aHeader
	Local aCols          := {}                                              // Array do aCols
	Local x    			 := 0
//============================================================
//Monta MsNewGetDados
//============================================================
	cVrAlias := "SZK"
	cOpcaoUt := hcOpc
	cOrdSeek := 1
	cCndSeek := "xFilial('SZJ')+M->ZJ_NUMCHAM"
	cCpoSeek := "SZK->ZK_FILIAL+SZK->ZK_NUMCHAM"
	nQtdLnhs := 1
	cVCampos := ""

//Cria varias linhas em branco caso necessario
	For x:=1 To nQtdLnhs
		aAdd(aCpoItem,{"ZK_NUMCHAM",M->ZJ_NUMCHAM,.F.})
		aAdd(aCpoItem,{"ZK_NUMINTE",StrZero(x,3) ,.F.})
	Next x

	aHead := faHead(cVrAlias,cVCampos)
	aCols := faCols(aHead,cVrAlias,aCpoItem,nQtdLnhs,cOpcaoUt,cOrdSeek,cCndSeek,cCpoSeek,cVCampos)

//============================================================
//Quando inclusใo s๓ deixar incluir uma linha
//============================================================
	If hcOpc == 3
		nMax := 1
	Else
		nMax := Len(aCols)+1
	EndIf


	oGdInter := MsNewGetDados():New(nSuperior,nEsquerda,nInferior,(nDireita/2)-2,cGetOpc,cLinhaOk,cTudoOk,cIniCpos,,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oFolder:aDialogs[nPosFolder],aHead,aCols)

	oGdInter:oBrowse:bChange := { || fMudaLinha(1) }

	nMemoEsquerda := nEsquerda+(nDireita/2)+2
	nMemoSuperior := nSuperior+15
	nMemoDireita  := (nDireita/2)-5
	nMemoInferior := nInferior-17

	oMmInter := TMultiGet():New( nMemoSuperior,nMemoEsquerda,{|u|if(Pcount()>0,cTxInter:=u,cTxInter)},oFolder:aDialogs[nPosFolder], nMemoDireita, nMemoInferior,/*oFont*/,.F., NIL, NIL, NIL,.T., NIL,.F.,{||.T.}, .F.,.F., NIL, NIL,{|| fMudaLinha(3)}, .F., NIL, NIL)

	@ nSuperior,nMemoEsquerda MsGet oOrigDesc Var cOrigDesc Picture "@!" Size nMemoDireita,10 Of oFolder:aDialogs[nPosFolder] When .F. Pixel

//oBtnSvMm := tButton():New(nSuperior,nMemoEsquerda,"Salvar Texto",oFolder:aDialogs[nPosFolder],{|| fSalvaMemo() },55,12,,,,.T.)
//@ nSuperior,nMemoEsquerda+60 MsGet oOrigDesc Var cOrigDesc Picture "@!" Size nMemoDireita-60,10 Of oFolder:aDialogs[nPosFolder] When .F. Pixel

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  บ fGDInter บAutor  บFelipe Aur้lio de Melo บ Data บ09/08/2013บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ P11                                                        บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGDAnexo(hcOpc,nPosFolder,oGdAnexo)

// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia
	Local cGetOpc        := IIf(hcOpc==2,Nil,GD_DELETE)                     // GD_INSERT+GD_DELETE+GD_UPDATE
	Local cLinhaOk       := Nil//"U_CADZKLOk"                               // Funcao executada para validar o contexto da linha atual do aCols
	Local cTudoOk        := Nil//"U_CADZKTOk"                               // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
	Local cIniCpos       := "+ZL_NUMINTE"                                   // Nome dos campos do tipo caracter que utilizarao incremento automatico.
	Local nFreeze        := Nil                                             // Campos estaticos na GetDados.
	Local nMax           := 999                                             // Numero maximo de linhas permitidas. Valor padrao 99
	Local cCampoOk       := Nil//"U_CADZKCPO"                               // Funcao executada na validacao do campo
	Local cSuperApagar   := Nil                                             // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
	Local cApagaOk       := Nil                                             // Funcao executada para validar a exclusao de uma linha do aCols
	Local aCpoItem       := {}                                              // Array com os campos que deverใo ser tratados quando rotina de inclusใo
	Local aHead          := {}                                              // Array do aHeader
	Local aCols          := {}                                              // Array do aCols
	Local x				 := 0
//============================================================
//Monta MsNewGetDados
//============================================================
	cVrAlias := "SZL"
	cOpcaoUt := hcOpc
	cOrdSeek := 1
	cCndSeek := "xFilial('SZJ')+M->ZJ_NUMCHAM"
	cCpoSeek := "SZL->ZL_FILIAL+SZL->ZL_NUMCHAM"
	nQtdLnhs := 1
	cVCampos := ""

//Cria varias linhas em branco caso necessario
	For x:=1 To nQtdLnhs
		aAdd(aCpoItem,{"ZL_NUMCHAM",M->ZJ_NUMCHAM,.F.})
		aAdd(aCpoItem,{"ZL_NUMINTE",StrZero(x,3) ,.F.})
	Next x

	aHead := faHead(cVrAlias,cVCampos)
	aCols := faCols(aHead,cVrAlias,aCpoItem,nQtdLnhs,cOpcaoUt,cOrdSeek,cCndSeek,cCpoSeek,cVCampos)
	oGdAnexo := MsNewGetDados():New(nSuperior,nEsquerda,nInferior-20,nDireita,cGetOpc,cLinhaOk,cTudoOk,cIniCpos,,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oFolder:aDialogs[nPosFolder],aHead,aCols)
	oBtnAnex := tButton():New(nInferior-15,nEsquerda+000,"Anexar",oFolder:aDialogs[nPosFolder],{|| fAnexar(M->ZJ_NUMCHAM) },55,12,,,,.T.)
	oBtnAbri := tButton():New(nInferior-15,nEsquerda+060,"Visualizar",oFolder:aDialogs[nPosFolder],{|| fAbrirDoc() },55,12,,,,.T.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  บ fAnexa   บAutor  บFelipe Aur้lio de Melo บ Data บ 25/01/14 บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ P11                                                        บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fAbrirDoc()

	Local cFileDes := ""
	Local cPathTmp := AllTrim(GetTempPath())
	Local nPosArqv := aScan(oGdAnexo:aHeader,{|x|Alltrim(x[2])==AllTrim("ZL_ARQUIVO" )})

	nLin := oGdAnexo:oBrowse:nAt
	cFileDes := AllTrim(oGdAnexo:aCols[nLin, nPosArqv])
	cPathTmp += SubStr(cFileDes,RAT('\',cFileDes)+1)

	If File(cPathTmp)
		fErase(cPathTmp)
	EndIf
	If File(cPathTmp)
		Alert("Arquivo jแ estแ aberto!")
		Return
	EndIf

	COPY File &cFileDes TO &cPathTmp
	ShellExecute("open",cPathTmp,"","", 5 )

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  บ fAnexa   บAutor  บFelipe Aur้lio de Melo บ Data บ 25/01/14 บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ P11                                                        บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fAnexar(cChamado)

	Local cTipo 	:= "Todos os Arquivos (*.*)    | *.*    |"+;
		"Arquivos PDF (*.PDF)       | *.PDF  |"+;
		"Arquivos JPEG (*.JPG)      | *.JPG  |"+;
		"Arquivos do Word (*.DOCX)  | *.DOCX |"+;
		"Arquivos do Excel (*.XLSX) | *.XLSX |"

	Local cTitulo	:= "Dialogo de Selecao de Arquivos"
	Local cDirIni	:= ""
	Local cDrive	:= ""
	Local cDir		:= ""
	Local cFile		:= ""
	Local cExten	:= ""
	Local cGetFile	:= cGetFile(cTipo,cTitulo,,cDirIni,.F.,GETF_LOCALHARD+GETF_NETWORKDRIVE)//GETF_ONLYSERVER+GETF_RETDIRECTORY+GETF_LOCALFLOPPY
	Local cNewFile	:= ""

	Local nPosItem := aScan(oGdAnexo:aHeader,{|x|Alltrim(x[2])==AllTrim("ZL_NUMINTE" )})
	Local nPosArqv := aScan(oGdAnexo:aHeader,{|x|Alltrim(x[2])==AllTrim("ZL_ARQUIVO" )})
	Local nPosData := aScan(oGdAnexo:aHeader,{|x|Alltrim(x[2])==AllTrim("ZL_DATA"    )})
	Local nPosHora := aScan(oGdAnexo:aHeader,{|x|Alltrim(x[2])==AllTrim("ZL_HORA"    )})
	Local nPosUser := aScan(oGdAnexo:aHeader,{|x|Alltrim(x[2])==AllTrim("ZL_USUARIO" )})
	Local nPosOrig := aScan(oGdAnexo:aHeader,{|x|Alltrim(x[2])==AllTrim("ZL_ORIGEM"  )})

// Separa os componentes
	SplitPath( cGetFile, @cDrive, @cDir, @cFile, @cExten )

	If !Empty(cFile)
		If !File(cGetFile)
			Alert("Erro ao localizar arquivo origem!")
			Return
		EndIf

		//Cria pasta caso nใo exita ainda
		// cSlvAnexos := "\ServiceDesk\Anexos\"
		MontaDir(cSlvAnexos+cChamado+"\")

		//Verifica Ultima Sequencia dos Anexos
		cNewFile := fNovoAnexo(cChamado,cExten)

		cNewGetFile := cSlvAnexos+cChamado+"\"+cNewFile+cExten
		If File(cNewGetFile)
			Alert("Erro ao tentar anexar arquivo!")
			Return
		EndIf
		COPY File &cGetFile TO &cNewGetFile

		//Cria pasta caso nใo exita ainda (PASTA PARA SINCRONIZAวรO COM SISTEMOPUS)
		If M->ZJ_CLASSIF == '3' // Suporte nํvel 3 (consultoria)
			MontaDir(cAnexoOpus+cChamado+"\")
			cFileOpus := cAnexoOpus+cChamado+"\"+cNewFile+'_'+DtoC(Date())+"_"+Time()+"_"+Alltrim(UsrRetName(__cUserID))+cExten

			COPY File &cGetFile TO &cFileOpus

			If !File(cAnexoOpus+cChamado+"\"+cExisteAnexo)
				COPY File &cAnexoOpus+cExisteAnexo TO &cAnexoOpus+cChamado+"\"+cExisteAnexo
			EndIf
		EndIf

		nLin := oGdAnexo:oBrowse:nAt
		oGdAnexo:aCols[nLin, nPosArqv] := cNewGetFile
		oGdAnexo:aCols[nLin, nPosOrig] := cGetFile

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณInclui registro no banco de conhecimentoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		RecLock("ACB",.T.)
		ACB->ACB_FILIAL := xFilial("ACB")
		ACB->ACB_CODOBJ := GetSxeNum("ACB","ACB_CODOBJ")
		ACB->ACB_OBJETO := cNewGetFile
		ACB->ACB_DESCRI := "SERVICE DESK - CHAMADO: "+cChamado
		ACB->(MsUnLock())
		ACB->(ConfirmSx8())

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณInclui a palavra-chave de pesquisaณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		RecLock("ACC",.T.)
		ACC->ACC_FILIAL := xFilial("ACC")
		ACC->ACC_CODOBJ := ACB->ACB_CODOBJ
		ACC->ACC_KEYWRD := "CHAMADO: "+cChamado
		ACC->(MsUnLock())

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  บfInitVarX3บAutor  บFelipe Aur้lio de Melo บ Data บ 10/07/13 บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ P11                                                        บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fNovoAnexo(cChamado,cExten)

	Local nPosItem := aScan(oGdAnexo:aHeader,{|x|Alltrim(x[2])==AllTrim("ZL_NUMINTE" )})
	Local nPosArqv := aScan(oGdAnexo:aHeader,{|x|Alltrim(x[2])==AllTrim("ZL_ARQUIVO" )})
	Local nPosData := aScan(oGdAnexo:aHeader,{|x|Alltrim(x[2])==AllTrim("ZL_DATA"    )})
	Local nPosHora := aScan(oGdAnexo:aHeader,{|x|Alltrim(x[2])==AllTrim("ZL_HORA"    )})
	Local nPosUser := aScan(oGdAnexo:aHeader,{|x|Alltrim(x[2])==AllTrim("ZL_USUARIO" )})
	Local nPosOrig := aScan(oGdAnexo:aHeader,{|x|Alltrim(x[2])==AllTrim("ZL_ORIGEM"  )})
	Local nLinhaOK := 0
	Local x        := 0
	Local cNovoArq := ""
	Local cNovoItm := ""
	Local lLoop    := .T.

//Verifica se tem alguma linha em branco
	For x:=1 To Len(oGdAnexo:aCols)
		If Empty(oGdAnexo:aCols[x][nPosArqv])
			nLinhaOK := x
		EndIf
	Next x

//Se nใo tiver linha em branco, adicionar nova linha
	If Empty(nLinhaOK)
		//Cria uma linha no aCols
		aAdd(oGdAnexo:aCols,Array(Len(oGdAnexo:aHeader)+1))
		nLin := Len(oGdAnexo:aCols)
		oGdAnexo:aCols[nLin, Len(oGdAnexo:aHeader)+1] := .F.
	Else
		nLin := nLinhaOK
	EndIf

//Alimenta Colunas
	oGdAnexo:aCols[nLin, nPosItem] := StrZero(nLin,3)
	oGdAnexo:aCols[nLin, nPosArqv] := ""
	oGdAnexo:aCols[nLin, nPosData] := Date()
	oGdAnexo:aCols[nLin, nPosHora] := Time()
	oGdAnexo:aCols[nLin, nPosUser] := UsrRetName(__cUserID)
	oGdAnexo:aCols[nLin, nPosOrig] := ""

//Atualiza tela
	oGdAnexo:oBrowse:nAt := nLin
	oGdAnexo:oBrowse:Refresh()
	oGdAnexo:oBrowse:SetFocus()

	cNovoItm := StrZero(nLin,3)
	cNovoArq := cSlvAnexos+cChamado+"\"+cNovoItm+cExten

	While lLoop
		If File(cNovoArq)
			cNovoItm := Soma1(cNovoItm)
			cNovoArq := cSlvAnexos+cChamado+"\"+cNovoItm+cExten
		Else
			lLoop := .F.
		EndIf
	End

Return(cNovoItm)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  บfInitVarX3บAutor  บFelipe Aur้lio de Melo บ Data บ 10/07/13 บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ P11                                                        บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fMudaLinha(nChamada)

	Local nLinAlter := oGdInter:oBrowse:nat

	Local nPosDescr := aScan(oGdInter:aHeader,{|x|Alltrim(x[2])==AllTrim("ZK_DESCRIC")})
	Local nPosCodOr := aScan(oGdInter:aHeader,{|x|Alltrim(x[2])==AllTrim("ZK_COD_ORI")})
	Local nPosNomOr := aScan(oGdInter:aHeader,{|x|Alltrim(x[2])==AllTrim("ZK_NOMEORI")})
	Local nPosOrig  := aScan(oGdInter:aHeader,{|x|Alltrim(x[2])==AllTrim("ZK_ORIGEM" )})

//Trata campo Solicitante/Tecnico
	If oGdInter:aCols[nLinAlter][nPosCodOr] == SZJ->ZJ_COD_SOL
		oGdInter:aCols[nLinAlter][nPosOrig] := "S"
		oGdInter:Refresh()
	Else
		oGdInter:aCols[nLinAlter][nPosOrig] := "T"
		oGdInter:Refresh()
	EndIf

//Trata quantidade de intera็๕es
	M->ZJ_QTDINTE := StrZero(Len(oGdInter:aCols),3)

//Trata Status
	If Len(oGdInter:aCols) > 1 .And. M->ZJ_STATUS == "P"
		M->ZJ_STATUS := "A"
	EndIf

//Trata Situa็ใo = Aguardando Tecnico
	If Len(oGdInter:aCols) > 1 .And. __cUserID == M->ZJ_COD_SOL
		M->ZJ_SITUAC := "T"
		//Solicitado por Denis em 22/10/19
		//Se estiver com o nํvel 3 mudar para o nํvel 2 para controle na tela de chamdos pendentes do nํvel 2
		//Se for o caso de redirecionar para o nํvel 3, entใo serแ feito pelo nํvel 2.
		If M->ZJ_CLASSIF == "3"
			M->ZJ_CLASSIF := "2"
		EndIf

	EndIf

	If nChamada == 1
		cOrigDesc:= oGdInter:aCols[nLinAlter][nPosCodOr] + " - " + oGdInter:aCols[nLinAlter][nPosNomOr]
		oOrigDesc:Refresh()

		cTxInter := oGdInter:aCols[nLinAlter][nPosDescr]
		oMmInter:Refresh()
	EndIf

	If nChamada == 3
		oGdInter:aCols[nLinAlter][nPosDescr] := cTxInter
		oGdInter:SetArray(oGdInter:aCols)
		//oGdInter:ForceRefresh()

		oGdInter:oBrowse:nAt := nLinAlter
		oGdInter:Refresh()
		oGdInter:oBrowse:SetFocus()
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  บ CADZKLOk บAutor  บFelipe Aur้lio de Melo บ Data บ 14/07/13 บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ P11                                                        บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CADZKLOk()

	Local lRet := .T.
	Local nLinAlter := oGdInter:oBrowse:nat
	Local nPosDescr := aScan(oGdInter:aHeader,{|x|Alltrim(x[2])==AllTrim("ZK_DESCRIC")})

	oGdInter:aCols[nLinAlter][nPosDescr] := cTxInter
	oGdInter:ForceRefresh()

	oGdInter:oBrowse:nAt:= nLinAlter
	oGdInter:oBrowse:Refresh()
	oGdInter:oBrowse:SetFocus()

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  บfInitVarX3บAutor  บFelipe Aur้lio de Melo บ Data บ 10/07/13 บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ P11                                                        บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fInitVarX3(cAlias,lInitVarX3,cExibeCpos,lRelacao,lVerifica)

	Local aExibLst := {}
	Local nRecSx3  := 0
	Default lRelacao := .T.
	Default lVerifica := .T.

	SX3->(DbSetOrder(1))
	SX3->(DbSeek(cAlias))
	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == cAlias
		If (X3USO(SX3->X3_USADO) .Or. !lVerifica) .And. cNivel >= SX3->X3_NIVEL
			If Empty(cExibeCpos) .Or. AllTrim(SX3->X3_CAMPO)+"/" $ cExibeCpos
				If lInitVarX3
					If lRelacao
						If !Empty(SX3->X3_RELACAO)
							_SetOwnerPrvt(Trim(SX3->X3_CAMPO),(cAlias)->&(SX3->X3_RELACAO))
						Else
							_SetOwnerPrvt(Trim(SX3->X3_CAMPO),CriaVar(Trim(SX3->X3_CAMPO),.T.))
						EndIf
					Else
						_SetOwnerPrvt(Trim(SX3->X3_CAMPO),CriaVar(Trim(SX3->X3_CAMPO),.F.))
					EndIf
				Else
					If SX3->X3_CONTEXT != "V"
						If !Empty(SX3->X3_RELACAO) .And. SX3->X3_VISUAL == "V" .And. !("GetSx8" $ SX3->X3_RELACAO) .And. !("GetSxE" $ SX3->X3_RELACAO)
							If lRelacao
								_SetOwnerPrvt(Trim(SX3->X3_CAMPO),(cAlias)->&(SX3->X3_RELACAO))
							Else
								_SetOwnerPrvt(Trim(SX3->X3_CAMPO),CriaVar(Trim(SX3->X3_CAMPO),.F.))
							EndIf
						Else
							_SetOwnerPrvt(Trim(SX3->X3_CAMPO),(cAlias)->&(SX3->X3_CAMPO))
						EndIf
					Else
						If lRelacao
							_SetOwnerPrvt(Trim(SX3->X3_CAMPO),(cAlias)->&(SX3->X3_RELACAO))
						Else
							_SetOwnerPrvt(Trim(SX3->X3_CAMPO),CriaVar(Trim(SX3->X3_CAMPO),.F.))
						EndIf
					EndIf
				EndIf
				AADD(aExibLst,SX3->X3_CAMPO)
			EndIf
		EndIf
		SX3->(DbSkip())
	End

Return(aExibLst)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  บ faHead บ Autor  บ Felipe Aur้lio de Melo บ Data บ09/08/2013บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ P11                                                        บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function faHead(hcAlias,hcCampos,hcNaoCampos)

	Local haHead     := {}
	Default hcCampos := ""
	Default hcNaoCampos := ""


// Montagem do aHeader
	SX3->(dbSetOrder(1))
	SX3->(dbSeek(hcAlias))
	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == hcAlias
		If ((((X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL)) .And. Empty(hcCampos) ) .Or. AllTrim(SX3->X3_CAMPO) $ hcCampos);
				.And. !(AllTrim(SX3->X3_CAMPO) $ hcNaoCampos)
			aAdd(haHead, {	AllTrim(X3Titulo())	,;
				SX3->X3_CAMPO		,;
				SX3->X3_PICTURE	,;
				SX3->X3_TAMANHO	,;
				SX3->X3_DECIMAL	,;
				SX3->X3_VALID		,;
				SX3->X3_USADO		,;
				SX3->X3_TIPO		,;
				SX3->X3_F3			,;
				SX3->X3_CONTEXT	,;
				SX3->X3_CBOX		,;
				SX3->X3_RELACAO	,;
				SX3->X3_WHEN		,;
				SX3->X3_VISUAL		,;
				SX3->X3_VLDUSER	,;
				SX3->X3_PICTVAR	,;
				SX3->X3_OBRIGAT	})
		EndIf
		SX3->(DbSkip())
	End

Return(haHead)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  บ faCols บ Autor  บ Felipe Aur้lio de Melo บ Data บ09/08/2013บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ P11                                                        บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function faCols(haHead,hcAlias,haCampo,hnQtdLin,hcOpc,hcOrdSeek,hcCndSeek,hcCpoSeek,hcCampos,hcNaoCampos)

	Local k := 0
	Local x := 0
	Local y := 0
	Local haCol := {}
	Local lFoiTratado := .F.
	Default hcCampos  := ""
	Default hcNaoCampos := ""


	If hcOpc == 3
		// Montagem do aCols em Branco
		For y := 1 To hnQtdLin

			AADD(haCol,Array(Len(haHead)+1))
			nLin	:= Len(haCol)
			x	:= 1

			SX3->(DbSetOrder(1))
			SX3->(DbSeek(hcAlias))
			While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == hcAlias
				If (((X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL) .And. Empty(hcCampos) ) .Or. AllTrim(SX3->X3_CAMPO) $ hcCampos);
						.And. !(AllTrim(SX3->X3_CAMPO) $ hcNaoCampos)
					lFoiTratado := .F.
					For k := 1 To Len(haCampo)
						If haCampo[k,1] $ SX3->X3_CAMPO .And. !haCampo[k,3]
							haCol[nLin,x] := haCampo[k,2]
							haCampo[k,3]  := .T.
							lFoiTratado   := .T.
							k := Len(haCampo)
						EndIf
					Next k
					If !lFoiTratado
						If Empty(SX3->X3_RELACAO)
							haCol[nLin,x] := CriaVar(SX3->X3_CAMPO)
						Else
							haCol[nLin,x] := &(SX3->X3_RELACAO)
						EndIf
					EndIf
					x += 1
				EndIf
				SX3->(DbSkip())
			End

			haCol[nLin,Len(haHead)+1] := .F.

		Next y
	Else
		// Montagem do aCols com registros caso tenha
		DbSelectArea(hcAlias)
		&(hcAlias+"->(DbSetOrder("+TRANSFORM(hcOrdSeek,"99")+"))")
		If DbSeek(&(hcCndSeek))
			While !EOF() .And. &(hcCndSeek) == &(hcCpoSeek)

				AADD(haCol,Array(Len(haHead)+1))
				nLin	:= Len(haCol)

				x := 1
				SX3->(DbSetOrder(1))
				SX3->(DbSeek(hcAlias))
				While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == hcAlias
					If (((X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL) .And. Empty(hcCampos) ).Or. AllTrim(SX3->X3_CAMPO) $ hcCampos);
							.And. !(AllTrim(SX3->X3_CAMPO) $ hcNaoCampos)
						If SX3->X3_CONTEXT == "V"
							haCol[nLin,x] := &(SX3->X3_RELACAO)
						Else
							haCol[nLin,x] := &(SX3->X3_CAMPO)
						EndIf
						x += 1
					EndIf
					SX3->(DbSkip())
				End

				haCol[nLin,Len(haHead)+1] := .F.
				DbSkip()
			End
		Else
			AADD(haCol,Array(Len(haHead)+1))
			nLin	:= Len(haCol)
			x	:= 1
			SX3->(DbSetOrder(1))
			SX3->(DbSeek(hcAlias))
			While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == hcAlias
				If (((X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL) .And. Empty(hcCampos) ) .Or. AllTrim(SX3->X3_CAMPO) $ hcCampos) ;
						.And. !(AllTrim(SX3->X3_CAMPO) $ hcNaoCampos)
					lFoiTratado := .F.
					For k := 1 To Len(haCampo)
						If haCampo[k,1] $ SX3->X3_CAMPO .And. !haCampo[k,3]
							haCol[nLin,x] := haCampo[k,2]
							haCampo[k,3]  := .T.
							lFoiTratado   := .T.
							k := Len(haCampo)
						EndIf
					Next k
					If !lFoiTratado
						If Empty(SX3->X3_RELACAO)
							IF hcOpc ==2
								haCol[nLin,x] := CriaVar(SX3->X3_CAMPO,.F.)
							ELSE
								haCol[nLin,x] := CriaVar(SX3->X3_CAMPO)
							ENDIF
						Else
							IF hcOpc ==2
								haCol[nLin,x] := CriaVar(SX3->X3_CAMPO,.F.)
							ELSE
								haCol[nLin,x] := &(SX3->X3_RELACAO)
							ENDIF
						EndIf
					EndIf
					x += 1
				EndIf
				SX3->(DbSkip())
			End

			haCol[nLin,Len(haHead)+1] := .F.
		EndIf
	EndIf

Return(haCol)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  บ fSalvaTudoบ Autor บFelipe Aur้lio de Meloบ Data บ09/08/2013บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ P11                                                        บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fSalvaTudo(cTpOper,cTpAlias)

	Local aAreaSZJ := SZJ->(GetArea())
	Local cCpoAlias:= ""

//cTpOper == 3 => Modo Inclusao
//cTpOper == 4 => Modo Alteracao

	If SubStr(cTpAlias,1,1) == "S"
		cCpoAlias := SubStr(cTpAlias,2,2)
	Else
		cCpoAlias := cTpAlias
	EndIf

// Grava Processo
	If cTpOper == 3
		If Alltrim(M->ZJ_TIPO) <> Alltrim(cTipoHlp)
			M->ZJ_TIPO := cTipoHlp
		EndIf
		RecLock(cTpAlias,.T.)
		//Trata campos que nใo sใo visualizados em tela
		&(cTpAlias+"->"+cCpoAlias+"_FILIAL") := xFilial(cTpAlias)
		//Grava o Tipo do Chamado na Inclusใo por Michel A. Sander em 20.03.2019
		&(cTpAlias+"->"+cCpoAlias+"_TIPO")   := cTipoHlp
	Else
		RecLock(cTpAlias,.F.)
	EndIf

//Trata os demais campos
	SX3->(DbSetOrder(1))
	SX3->(DbSeek(cTpAlias))
	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == cTpAlias
		cWhen := IIf(Empty(SX3->X3_WHEN),".T.",AllTrim(SX3->X3_WHEN))
		If X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. SX3->X3_CONTEXT != "V"
			If &(cWhen)
				&(cTpAlias+"->"+SX3->X3_CAMPO) := M->&(SX3->X3_CAMPO)
			Else
				If cWhen == ".F."
					&(cTpAlias+"->"+SX3->X3_CAMPO) := M->&(SX3->X3_CAMPO)
				Else
					If cTpOper == 3
						&(cTpAlias+"->"+SX3->X3_CAMPO) := CriaVar(AllTrim(SX3->X3_CAMPO))
					Else
						&(cTpAlias+"->"+SX3->X3_CAMPO) := &(cTpAlias+"->"+SX3->X3_CAMPO)
					EndIF
				EndIf
			EndIf
		EndIf
		SX3->(DbSkip())
	End

//Trata fechamento do chamado
	If SZJ->ZJ_STATUS == "F" .And. Empty(SZJ->ZJ_DT_FECH) .And. Empty(SZJ->ZJ_HR_FECH)
		SZJ->ZJ_DT_FECH := Date()
		SZJ->ZJ_HR_FECH := Time()
	EndIf

//S๓ muda status se codigo do tecnico preenchido
	If !Empty(SZJ->ZJ_COD_TEC)
		//Trata Status
		If Len(oGdInter:aCols) > 1 .And. SZJ->ZJ_STATUS == "P"
			SZJ->ZJ_STATUS := "A"
		EndIf

		//Trata Situa็ใo = Aguardando Tecnico
		If Len(oGdInter:aCols) > 1 .And. __cUserID == SZJ->ZJ_COD_SOL
			SZJ->ZJ_SITUAC := "T"
			//Solicitado por Denis em 22/10/19
			//Se estiver com o nํvel 3 mudar para o nํvel 2 para controle na tela de chamdos pendentes do nํvel 2
			//Se for o caso de redirecionar para o nํvel 3, entใo serแ feito pelo nํvel 2.
			If SZJ->ZJ_CLASSIF == "3"
				SZJ->ZJ_CLASSIF := "2"
			EndIf

		EndIf
	EndIf

	(cTpAlias)->(MsUnLock())

// Grava Itens
	aGrvCps := {}
	aAdd(aGrvCps,{"ZK_NUMCHAM" ,"M->ZJ_NUMCHAM" })
	aAdd(aGrvCps,{"ZK_NUMINTE" ,"cCodItem"      })
	cOrdSeek := 1
	cCpoItem := "ZK_NUMINTE"
	cCndSeek := "xFilial('SZK')+M->ZJ_NUMCHAM"
	cCpoSeek := "SZK->ZK_FILIAL+SZK->ZK_NUMCHAM+SZK->ZK_NUMINTE"
	fGravaGD(oGdInter,"SZK",aGrvCps,cTpOper,cOrdSeek,cCndSeek,cCpoSeek,cCpoItem)

// Grava Anexo
	aGrvCps := {}
	aAdd(aGrvCps,{"ZL_NUMCHAM" ,"M->ZJ_NUMCHAM" })
	aAdd(aGrvCps,{"ZL_NUMINTE" ,"cCodItem"      })
	cOrdSeek := 1
	cCpoItem := "ZL_NUMINTE"
	cCndSeek := "xFilial('SZL')+M->ZJ_NUMCHAM"
	cCpoSeek := "SZL->ZL_FILIAL+SZL->ZL_NUMCHAM+SZL->ZL_NUMINTE"
	fGravaGD(oGdAnexo,"SZL",aGrvCps,cTpOper,cOrdSeek,cCndSeek,cCpoSeek,cCpoItem)

//Confirma opera็ใo quando inclusใo
	If cTpOper == 3
		While (cTpAlias)->(GetSx8Len()) > nSaveSx8Len
			(cTpAlias)->(ConfirmSX8())
		End
	Else
		RestArea(aAreaSZJ)
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  บfExcluiTudoบ Autor บFelipe Aur้lio de Meloบ Data บ09/08/2013บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ P11                                                        บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fExcluiTudo()

//Verifica se houve intera็๕es
	If SZJ->ZJ_QTDINTE >= "001" //.And. !TECNICO
		Alert("O chamado "+SZJ->ZJ_NUMCHAM+" jแ teve intera็๕es e por isso nใo pode ser excluido!")
		Return
	EndIf

	If SimNao("Confirma exclusใo do chamado '"+SZJ->ZJ_NUMCHAM+"' ?") == "S"
		//Deleta Itens
		SZK->(DbSetOrder(1))
		SZK->(DbSeek(SZJ->ZJ_FILIAL+SZJ->ZJ_NUMCHAM))
		Do While SZK->(!Eof()) .And. SZK->ZK_FILIAL+SZK->ZK_NUMCHAM == SZJ->ZJ_FILIAL+SZJ->ZJ_NUMCHAM
			RecLock("SZK",.F.)
			SZK->(dbDelete())
			SZK->(MsUnLock())
			SZK->(DbSkip())
		EndDo

		//Deleta Anexos
		SZL->(DbSetOrder(1))
		SZL->(DbSeek(SZJ->ZJ_FILIAL+SZJ->ZJ_NUMCHAM))
		Do While SZK->(!Eof()) .And. SZL->ZL_FILIAL+SZL->ZL_NUMCHAM == SZJ->ZJ_FILIAL+SZJ->ZJ_NUMCHAM
			RecLock("SZL",.F.)
			SZL->(dbDelete())
			SZL->(MsUnLock())
			SZL->(DbSkip())
		EndDo

		//Deleta Cabe็alho
		RecLock("SZJ",.F.)
		SZJ->(dbDelete())
		SZJ->(MsUnLock())
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  บfGravaGDบ Autor  บ Felipe Aur้lio de Melo บ Data บ 05/04/11 บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ RFINM06                                                   บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGravaGD(hoObj,hcAlias,haCposAdd,hcTpOper,hcOrdSeek,hcCndSeek,hcCpoSeek,hcCpoItm)

	Local k        := 01
	Local x        := 01
	Local y        := 01

//Este variavel nใo pode
//ser do tipo Local
	cCodItem := "001"

	DbSelectArea(hcAlias)

	For x:=1 To Len(hoObj:aCols)
		If  !hoObj:aCols[x,Len(hoObj:aHeader)+1]

			lTemInfo := .F.
			For y:=2 To Len(hoObj:aHeader)
				If !Empty(hoObj:aCols[x][aScan(hoObj:aHeader,{|x|Alltrim(x[2])==AllTrim(hoObj:aHeader[y,2])})])
					lTemInfo := .T.
				EndIf
			Next y

			If lTemInfo

				DbSelectArea(hcAlias)
				&(HcAlias+"->(DbSetOrder("+TRANSFORM(hcOrdSeek,"99")+"))")

				If hcTpOper == 3
					RecLock(hcAlias,.T.)
				ElseIf DbSeek(&(hcCndSeek)+hoObj:aCols[x][aScan(hoObj:aHeader,{|x|Alltrim(x[2])==hcCpoItm})])
					RecLock(hcAlias,.F.)
				Else
					RecLock(hcAlias,.T.)
				EndIf

				For y:=1 To Len(hoObj:aHeader)
					&(hoObj:aHeader[y,2]) := hoObj:aCols[x][aScan(hoObj:aHeader,{|x|Alltrim(x[2])==AllTrim(hoObj:aHeader[y,2])})]
				Next y

				For k:=1 To Len(haCposAdd)
					&(haCposAdd[k,1]) := &(haCposAdd[k,2])
				Next k

				cCodItem := Soma1(cCodItem)
				MsUnLock()
			EndIf
		Else
			DbSelectArea(hcAlias)
			&(hcAlias+"->(DbSetOrder("+TRANSFORM(hcOrdSeek,"99")+"))")
			If hcTpOper != 3
				If DbSeek(&(hcCndSeek)+hoObj:aCols[x][aScan(hoObj:aHeader,{|x|Alltrim(x[2])==hcCpoItm})])
					RecLock(hcAlias,.F.)
					dbDelete()
					MsUnLock()
				EndIf
			Else
			EndIf
		EndIf
	Next x

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fEnviaWf บAutor  ณ Felipe A. Melo     บ Data ณ  09/02/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fEnviaWf(cChamado,nOpc,cTipoHlp)

	Local cContato := ""
	Local aEmails  := {}
	Local aTecEng  := {}
	Local n 	   := 0
	Local x		   := 0
	Default nOpc   := 0
	
	Default cTipoHlp  :='1' // MLS ERRO SCHEDULER variable does not exist CTIPOHLP on U_FENVIAWF(CADSZJ.PRW) 01/03/2021 16:08:46 line : 2276

//Se nใo achar, sair sem enviar WF
	SZJ->(DbSetOrder(1))
	If SZJ->(!DbSeek(xFilial("SZJ")+cChamado))
		Return
	EndIf

//Localizando contatos
	cContato := ""
	If SZJ->ZJ_COD_SOL=='000486' .Or. SZJ->ZJ_COD_SOL=='000421'
		cContato += IIf(Empty(cContato),"",";")+"mayara.sousa@rdt.com.br"
		cContato += IIf(Empty(cContato),"",";")+"aline.maciel@rdt.com.br"
	Else
		cContato += IIf(Empty(cContato),"",";")+AllTrim(UsrRetMail(SZJ->ZJ_COD_SOL))
		cContato += IIf(Empty(cContato),"",";")+AllTrim(UsrRetMail(SZJ->ZJ_COD_TEC))
	EndIf

    //Adicione sempre o email do Denis para receber copia de tudo
	If !("DENIS.VIEIRA" $ Upper(cContato)) //.And. cTipoHlp == "1" //mls scheduler
		cContato += IIf(Empty(cContato),"",";")+"denis.vieira@rosenbergerdomex.com.br"
	EndIf

	If !("FULGENCIO MUNIZ" $ Upper(cContato)) //.And. cTipoHlp == "1" //mls scheduler
		cContato += IIf(Empty(cContato),"",";")+"fulgencio.muniz@rosenbergerdomex.com.br"
	EndIf

	If Alltrim(cTipoHlp) =="3" .or. Alltrim(cTipoHlp)  == "4"  //Chamado da engenharia e Qualidade
		//cContato := ""	
		cContato += IIf(Empty(cContato),"",";")+AllTrim(UsrRetMail(SZJ->ZJ_COD_SOL))
		If Empty(SZJ->ZJ_COD_TEC)
			aTecEng := {}
			aTecEng := StrToKArr(cCodTec,"/")
			For n := 1 To Len(aTecEng)
				cContato += IIf(Empty(cContato),"",";")+AllTrim(UsrRetMail(aTecEng[n]))
			Next n
		Else			
			cContato += IIf(Empty(cContato),"",";")+AllTrim(UsrRetMail(SZJ->ZJ_COD_TEC))
		EndIf
	EndIf

	If nOpc == 3

		If !("DEBORA" $ Upper(cContato)) .And. cTipoHlp == "2"
			cContato += IIf(Empty(cContato),"",";")+"debora.zani@rosenbergerdomex.com.br"
		EndIf

		If !("ALESSANDRO OLIVEIRA" $ Upper(cContato)) .And. cTipoHlp == "2"
			cContato += IIf(Empty(cContato),"",";")+"alessandro.oliveira@rdt.com.br"
		EndIf

		If !("FELIPE MORAES" $ Upper(cContato)) .And. cTipoHlp == "2"
			cContato += IIf(Empty(cContato),"",";")+"felipe.moraes@rosenbergerdomex.com.br"
		EndIf

		If !("JANINE SANTOS" $ Upper(cContato)) .And. cTipoHlp == "2"
			cContato += IIf(Empty(cContato),"",";")+"janine.santos@rdt.com.br"
		EndIf

		If !("KAROLYNE" $ Upper(cContato)) .And. cTipoHlp == "2"
			cContato += IIf(Empty(cContato),"",";")+"karolyne.santos@rdt.com.br"
		EndIf
		If cTipoHlp == "3"
			aTecQuali := {}
			aTecQuali := StrToKArr(cCodTec,"/")
			For n := 1 To Len(aTecQuali)
				IF !Alltrim(AllTrim(UsrRetMail(aTecQuali[n]))) $ Alltrim(cContato)
					cContato += IIf(Empty(cContato),"",";")+AllTrim(UsrRetMail(aTecQuali[n]))
				Endif
			Next n			
		EndIf
		If cTipoHlp == "4"
			aTecQuali := {}
			aTecQuali := StrToKArr(cCodTec,"/")
			For n := 1 To Len(aTecQuali)
				IF !Alltrim(AllTrim(UsrRetMail(aTecQuali[n]))) $ Alltrim(cContato)
					cContato += IIf(Empty(cContato),"",";")+AllTrim(UsrRetMail(aTecQuali[n]))
				Endif
			Next n			
		EndIf


	EndIf

/*
	If !("MAXIMILIANO.REIS" $ Upper(cContato))
cContato += IIf(Empty(cContato),"",";")+"maximiliano.reis@rosenbergerdomex.com.br"
	EndIf
	If !("EDMILSON.GOLCALVES" $ Upper(cContato))
cContato += IIf(Empty(cContato),"",";")+"edmilson.goncalves@rosenbergerdomex.com.br"
	EndIf
*/

	If !("SUPORTE" $ Upper(cContato))
		cContato += IIf(Empty(cContato),"",";")+"suporte@rosenbergerdomex.com.br"
	EndIf

//Se for altera็ใo realizada pelo Denis, nใo enviar e-mail pra ele mesmo(Denis)
	If nOpc == 4 .And. __cUserID $ "000206" .And. cTipoHlp == "1"
		//If nOpc == 4 .And. __cUserID $ "000373"  //  MAURESI
		cContato := StrTran(cContato,"denis.vieira@rosenbergerdomex.com.br","")
	EndIf

	If nOpc == 4 .And. __cUserID $ "000422/000492"
		cContato := StrTran(cContato,"suporte@rosenbergerdomex.com.br","")
	EndIf

//Trata emails pra ficarem minusculo
	cContato := Lower(cContato)

//Se nใo tiver pra quem enviar e-mail, sair da rotina
	If Empty(cContato)
		Return
	EndIf

//Enviado e-mails individualmente pra tratar anexos
	aEmails := StrToKArr(cContato,";")
	For x:= 1 To Len(aEmails)
		fTrataAnexo(cChamado,aEmails[x])
	Next x

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fEnviaWf บAutor  ณ Felipe A. Melo     บ Data ณ  09/02/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fTrataAnexo(cChamado,cContato)

	Local x := 0
	Local aAreaSZJ   := SZJ->(GetArea())
	Local aAreaSZK   := SZK->(GetArea())
	Local aAreaSZL   := SZL->(GetArea())
	Local cDescri    := ""
	Local cAnexo     := ""
	Local cMvSdAnexo := GetMv("MV_SDANEXO") //ServiceDesk Anexo (email de quem recebe anexo)

//IF MsgYesNo("Enviando workflow chamado " + cChamado + " para " + cContato)
//EndIf

	Conout("fTrataAnexo - Enviando workflow chamado " + cChamado + " para " + cContato)

//Se nใo achar, sair sem enviar WF
	SZJ->(DbSetOrder(1))
	If SZJ->(!DbSeek(xFilial("SZJ")+cChamado))
		Return
	EndIf

//Monta workflow e dispara envio
	oProcess:=TWFProcess():New("000001",OemToAnsi("Service Desk - Chamado : "+cChamado))
	oProcess:NewTask("000001","\workflow\html\Wf_Chamado.htm")
	oHtml   := oProcess:oHtml

	oProcess:ClientName(cUserName)
	oProcess:UserSiga := "000000"
	oProcess:cSubject := "[Service Desk] Chamado : "+cChamado+" - "+fDscStatus(SZJ->ZJ_STATUS)

	oProcess:cTo      := cContato

	oProcess:cFromName:= "WF Rosenberger"
	oProcess:cFromAddr:= "siga@rosenbergerdomex.com.br"

	oProcess:oHtml:ValByName( "cNumChamado"		, SZJ->ZJ_NUMCHAM )
	oProcess:oHtml:ValByName( "cSolicitante"		, AllTrim(UsrRetName(SZJ->ZJ_COD_SOL)) )
	oProcess:oHtml:ValByName( "cTecnico"			, AllTrim(UsrRetName(SZJ->ZJ_COD_TEC)) )
	oProcess:oHtml:ValByName( "cStatus"				, fDscStatus(SZJ->ZJ_STATUS) )
	oProcess:oHtml:ValByName( "cSituacao"			, fDscSituac(SZJ->ZJ_SITUAC) )
	oProcess:oHtml:ValByName( "cDtAbertura"		, DtoC(SZJ->ZJ_DT_INC ) )
	oProcess:oHtml:ValByName( "cDtFechamento"		, DtoC(SZJ->ZJ_DT_FECH) )

//Itens
	SZK->(DbSetOrder(1))
	If SZK->(DbSeek(SZJ->ZJ_FILIAL+SZJ->ZJ_NUMCHAM))
		Do While SZK->(!Eof()) .And. SZK->ZK_FILIAL+SZK->ZK_NUMCHAM == SZJ->ZJ_FILIAL+SZJ->ZJ_NUMCHAM
			cDescri := StrTran(SZK->ZK_DESCRIC,Chr(13),"<br>")
			aAdd((oHtml:ValByName("a.Item"  )) ,SZK->ZK_NUMINTE		)
			aAdd((oHtml:ValByName("a.Data"  )) ,DtoC(SZK->ZK_DT_INC)	)
			aAdd((oHtml:ValByName("a.Hora"  )) ,SZK->ZK_HR_INC			)
			aAdd((oHtml:ValByName("a.Nome"  )) ,SZK->ZK_NOMEORI		)
			aAdd((oHtml:ValByName("a.Texto" )) ,cDescri					)
			SZK->(DbSkip())
		EndDo
	Else
		aAdd((oHtml:ValByName("a.Item"  )) ,""	)
		aAdd((oHtml:ValByName("a.Data"  )) ,""	)
		aAdd((oHtml:ValByName("a.Hora"  )) ,""	)
		aAdd((oHtml:ValByName("a.Nome"  )) ,""	)
		aAdd((oHtml:ValByName("a.Texto" )) ,""	)
	EndIf

//Anexos
	SZL->(DbSetOrder(1))
	If SZL->(DbSeek(SZJ->ZJ_FILIAL+SZJ->ZJ_NUMCHAM))
		Do While SZL->(!Eof()) .And. SZL->ZL_FILIAL+SZL->ZL_NUMCHAM == SZJ->ZJ_FILIAL+SZJ->ZJ_NUMCHAM
			aAdd((oHtml:ValByName("b.Anexo"		)) ,SZL->ZL_NUMINTE	)
			aAdd((oHtml:ValByName("b.Data"		)) ,DtoC(SZL->ZL_DATA))
			aAdd((oHtml:ValByName("b.Hora"		)) ,SZL->ZL_HORA		)
			aAdd((oHtml:ValByName("b.ArqChamado")) ,SZL->ZL_ARQUIVO	)
			aAdd((oHtml:ValByName("b.ArqOrigem" )) ,SZL->ZL_ORIGEM	)

			//Anexo arquivo no e-mail
			If !Empty(SZL->ZL_ARQUIVO) .And. Upper(AllTrim(cContato)) $ Upper(AllTrim(cMvSdAnexo))
				cAnexo := AllTrim(SZL->ZL_ARQUIVO)
				oProcess:AttachFile(cAnexo)
			EndIf

			SZL->(DbSkip())
		EndDo
	Else
		aAdd((oHtml:ValByName("b.Anexo"		)) ,"" )
		aAdd((oHtml:ValByName("b.Data"		)) ,"" )
		aAdd((oHtml:ValByName("b.Hora"		)) ,"" )
		aAdd((oHtml:ValByName("b.ArqChamado")) ,"" )
		aAdd((oHtml:ValByName("b.ArqOrigem" )) ,"" )
	EndIf

//Envia e-mail
	oProcess:Start()
	oProcess:Finish()
	WFSendMail({"01","01"})

//MsgInfo("Chamado "+SZJ->ZJ_NUMCHAM+" enviado para " + oProcess:cTo)

	RestArea(aAreaSZJ)
	RestArea(aAreaSZK)
	RestArea(aAreaSZL)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfDscSituacบAutor  ณ Felipe A. Melo     บ Data ณ  09/02/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fDscSituac(cCod)

	Local cRet := ""

	Do Case
	Case cCod == "T"
		cRet := "Aguardando Tecnico"
	Case cCod == "S"
		cRet := "Aguardando Solicitante"
	Case cCod == "R"
		cRet := "Resolvido"
	Case cCod == "C"
		cRet := "Cancelado"
	EndCase

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfDscStatusบAutor  ณ Felipe A. Melo     บ Data ณ  09/02/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fDscStatus(cCod)

	Local cRet := ""

	Do Case
	Case cCod == "P"
		cRet := "Chamado Novo"
	Case cCod == "A"
		cRet := "Em Atendimento
	Case cCod == "F"
		cRet := "Fechado"
	EndCase

Return(cRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfEncerrOldบAutor  ณ Felipe A. Melo     บ Data ณ  07/05/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fEncerrOld()

	Local cQuery   := ""
	Local cDtFil   := DtoS(Date()-5)
	Local cMsgCham := ""

//Mensagem que serแ gravada na intera็ใo automatica
	cMsgCham := CRLF+"ATENวรO"
	cMsgCham += CRLF+""
	cMsgCham += CRLF+"Este chamado foi encerrado em "+DtoC(Date())+" automaticamente por estar a mais de 5 dias com a situa็ใo Aguardando Solicitante."
	cMsgCham += CRLF+"Se desejar, o chamado pode ser reaberto."
	cMsgCham += CRLF+""
	cMsgCham += CRLF+"Atenciosamente"
	cMsgCham += CRLF+"Equipe T.I."
	cMsgCham += CRLF+"Rosenberger Domex"
	cMsgCham += CRLF+""

//Query que serแ executada
	cQuery := CRLF+" SELECT TOP 10 * "
	cQuery += CRLF+" FROM "

	cQuery += CRLF+" ( "
	cQuery += CRLF+"  SELECT  "
	cQuery += CRLF+"         ZJ_FILIAL, "
	cQuery += CRLF+"         ZJ_NUMCHAM, "
	cQuery += CRLF+"         ZJ_DT_INC, "
	cQuery += CRLF+"         SZJ.R_E_C_N_O_ ZJ_RECNO, "
	cQuery += CRLF+"         MAX(ZK_NUMINTE) ZK_NUMINTE,  "
	cQuery += CRLF+"         MAX(ZK_DT_INC)  ZK_DT_INC "
	cQuery += CRLF+"    FROM "+RetSqlName("SZJ")+" SZJ(NOLOCK) "
	cQuery += CRLF+"    LEFT JOIN "+RetSqlName("SZK")+" SZK(NOLOCK) ON SZK.D_E_L_E_T_ = '' AND ZK_FILIAL = ZJ_FILIAL AND ZK_NUMCHAM = ZJ_NUMCHAM "
	cQuery += CRLF+"   WHERE SZJ.D_E_L_E_T_ = '' "
	cQuery += CRLF+"     AND SZJ.ZJ_STATUS != 'F' "
	cQuery += CRLF+"     AND SZJ.ZJ_SITUAC  = 'S' "
	cQuery += CRLF+"   GROUP BY ZJ_FILIAL, ZJ_NUMCHAM, ZJ_DT_INC, SZJ.R_E_C_N_O_ "
	cQuery += CRLF+" ) "

	cQuery += CRLF+" TEMP "
	cQuery += CRLF+" WHERE ZK_DT_INC < '"+cDtFil+"' "
	cQuery += CRLF+" ORDER BY ZK_DT_INC ASC "

	If Select("TRB") > 0 ; TRB->(dbCloseArea()) ; EndIf
		TcQuery cQuery Alias "TRB" New

		TRB->(DbGoTop())
		While TRB->(!Eof())
			SZJ->(DbGoTo(TRB->ZJ_RECNO))

			//Altera Status e Situa็ใo
			RecLock("SZJ",.F.)
			SZJ->ZJ_STATUS := 'F'
			SZJ->ZJ_SITUAC := 'R'
			SZJ->ZJ_QTDINTE:= Soma1(TRB->ZK_NUMINTE)

			//Trata fechamento do chamado
			If Empty(SZJ->ZJ_DT_FECH) .And. Empty(SZJ->ZJ_HR_FECH)
				SZJ->ZJ_DT_FECH := Date()
				SZJ->ZJ_HR_FECH := Time()
			EndIf
			SZJ->(MsUnLock())

			//Cria Intera็ใo
			RecLock("SZK",.T.)
			SZK->ZK_FILIAL  := xFilial("SZK")
			SZK->ZK_NUMCHAM := SZJ->ZJ_NUMCHAM
			SZK->ZK_NUMINTE := Soma1(TRB->ZK_NUMINTE)
			SZK->ZK_DT_INC  := Date()
			SZK->ZK_HR_INC  := Time()
			SZK->ZK_ORIGEM  := "T"
			SZK->ZK_COD_ORI := "000000"
			SZK->ZK_NOMEORI := "Administrador"
			SZK->ZK_DESCRIC := cMsgCham
			SZK->(MsUnLock())

			//Dispara Workflow
			U_fEnviaWf(SZJ->ZJ_NUMCHAM,,cTipoHlp)

			TRB->(DbSkip())
		End



		If Select("TRB") > 0 ; TRB->(dbCloseArea()) ; EndIf

			Return


User Function fEncOPUS()
	Local oConsultores

	Private aConsultores := {}
	Private aCodConsult  := {}
	Private cConsultores
	Private _RetF3SZ4
	Private cDescricao := "CHAMADO " + SZJ->ZJ_NUMCHAM + " - " + SZJ->ZJ_ASSUNTO + Space(220)

	AADD(aConsultores, "0-Indefinido")
	AADD(aCodConsult , ""       )

	AADD(aConsultores, "1-Maurํcio")
	AADD(aCodConsult , "000004" )  // Mauricio

	AADD(aConsultores, "2-Marco Aur้lio")
	AADD(aCodConsult , "000007" )  // Marco

	AADD(aConsultores, "3-Michel")
	AADD(aCodConsult , "000006" )  // Michel

	AADD(aConsultores, "4-Joใo")
	AADD(aCodConsult , "000011" )  // Joใo

	AADD(aConsultores, "5-H้lio")
	AADD(aCodConsult , "000002" )  // Helio

	AADD(aConsultores, "6-Osmar")
	AADD(aCodConsult , "000021" )  //6-S้rgio // Glaydson

	AADD(aConsultores, "7-Ricardo")
	AADD(aCodConsult , "000018" )  // Ricardo Roda

	AADD(aConsultores, "8-Jonas")
	AADD(aCodConsult , "000015" )  // Jonas

	AADD(aConsultores, "9-Jackson")
	AADD(aCodConsult , "000012" )  // Jackson

	AADD(aConsultores, "A-Luis Roberto")
	AADD(aCodConsult , "000001" )  // Luis

	DEFINE MSDIALOG oDlg TITLE 'Cria็ใo de item de projeto Opus' FROM 000, 000  TO 150,500 COLORS 0, 16777215 PIXEL

	@ 005, 005 TO 065,245 LABEL OemToAnsi("Descri็ใo resumida da Atividade/Projeto") OF oDlg PIXEL

	@ 020, 010 MSGET oGet VAR cDescricao WHEN(.T.) PICTURE "@!"  SIZE 230, 12 OF oDlg COLORS 0, 16777215 PIXEL

	@ 046, 011 SAY oSay1 PROMPT "Consultor: " SIZE 093, 007 OF oDlg COLORS 0, 16777215 PIXEL

	@ 044, 040 COMBOBOX oConsultores  VAR cConsultores ITEMS aConsultores    SIZE 45,10 VALID .T. PIXEL

	@ 45, 148 Button "Ok"        Size 40,13 Action BotaoOK()    Pixel
	@ 45, 198 Button "Cancelar"  Size 40,13 Action oDlg:End() Pixel

	ACTIVATE MSDIALOG oDlg CENTER


Return


Static Function BotaoOK()
	Local aVetorIn := {}
	Local n			:=0
	Local x			:= 0
	If "'" $ cDescricao
		MsgStop("Nใo ้ possํvel abrir chamados com o caracter aspas simples (')")
	Else
		//If MsgNoYes("Deseja sincronizar os projetos?")
		//   MsgRun("Sincronizando projetos.....","Aguarde...",{|| U_SITBOPUS() })  //Fun็ใo que sincroniza a SZ4 - Cadastro de Projetos
		//EndIf

		//_RetF3SZ4 := U_F3SZ4("000012",.F.)
		_RetF3SZ4 := U_F3SZ4New("000012",.F.)

		If SZ4->( dbSeek( xFilial() + _RetF3SZ4 ) )
			If SZ4->Z4_NIVEL <> '2'
				MsgStop("Selecione um projeto sint้tico de segundo nํvel para a cria็ใo da atividade")
				Return
			EndIf
		Else
			MsgStop("Projeto nใo encontrado")
		EndIf

		Reclock("SZK",.T.)
		SZK->ZK_FILIAL  := xFilial("SZK")
		SZK->ZK_NUMCHAM := SZJ->ZJ_NUMCHAM
		SZK->ZK_NUMINTE := U_fZKITEM(SZJ->ZJ_NUMCHAM)
		SZK->ZK_DT_INC  := Date()
		SZK->ZK_HR_INC  := Time()
		SZK->ZK_ORIGEM  := "T"
		SZK->ZK_COD_ORI := __cUserID
		SZK->ZK_NOMEORI := UsrRetName(__cUserID)
		SZK->ZK_DESCRIC := "Chamado encaminhado para o Sistema de Controle de chamados da Consultoria OpusVP. Aguardando sincroniza็ใo"
		SZK->( msUnlock() )

		If SZJ->ZJ_NUMCHAM == M->ZJ_NUMCHAM //.and. SZJ->ZJ_CLASSIF <> '3'
			Reclock("SZJ",.F.)
			SZJ->ZJ_CLASSIF := '7'
			SZJ->ZJ_SITUAC  := 'T'   // Situa็ใo (T-Aguardando Tecnico;S=Aguardando Solicitante;R=Resolvido;C=Cancelado)
			SZJ->ZJ_QTDINTE := SZK->ZK_NUMINTE
			SZJ->ZJ_Z4COD   := _RetF3SZ4   // Nํvel 2
			SZJ->ZJ_Z4DESC  := cDescricao
			SZJ->ZJ_Z4CONSU := fRetCodCon(cConsultor)
			SZJ->( msUnlock() )

			M->ZJ_CLASSIF := '7'
			M->ZJ_SITUAC  := 'T'   // Situa็ใo (T-Aguardando Tecnico;S=Aguardando Solicitante;R=Resolvido;C=Cancelado)
			M->ZJ_QTDINTE := SZK->ZK_NUMINTE

			M->ZJ_Z4COD   := _RetF3SZ4   // Nํvel 2
			M->ZJ_Z4DESC  := cDescricao
			M->ZJ_Z4CONSU := fRetCodCon(cConsultor)
		Else
			M->ZJ_CLASSIF := '7'
			M->ZJ_SITUAC  := 'T'   // Situa็ใo (T-Aguardando Tecnico;S=Aguardando Solicitante;R=Resolvido;C=Cancelado)
			M->ZJ_QTDINTE := SZK->ZK_NUMINTE

			M->ZJ_Z4COD   := _RetF3SZ4   // Nํvel 2
			M->ZJ_Z4DESC  := cDescricao
			M->ZJ_Z4CONSU := fRetCodCon(cConsultor)
		EndIf

		cZ4_MEMO   := ""
		cInteracao := ""
		SZK->( dbSetOrder(1) ) // Intera็๕es
		If SZK->( dbSeek( xFilial() + SZJ->ZJ_NUMCHAM ) )
			nPrimeira := 1
			While !SZK->( EOF() ) .and. SZK->ZK_NUMCHAM == SZJ->ZJ_NUMCHAM
				cCaracIni := "|"
				cCaracFim := "|"
				nTamanho  := 74
				cTmpTXT   := SZK->ZK_DESCRIC
				cTmpTXT   := StrTran(              Strtran(cTmpTXT,chr(10),"")         ,chr(13),"#$#$#$")

				aTmpTXT  := StrToKarr(cTmpTXT,"#$#$#$")
				cTmpTXT  := ""
				For x := 1 to Len(aTmpTXT)
					cLinha  := aTmpTXT[x]
					If Len(cLinha) <= nTamanho
						cTmpTXT += cCaracIni + cLinha + Space(nTamanho-Len(cLinha))+cCaracFim+Chr(13)
					Else
						aLinhas := U_QuebraString(cLinha,nTamanho)
						For n := 1 to Len(aLinhas)
							cTmpTXT += cCaracIni + aLinhas[n] + Space(nTamanho-Len(aLinhas[n]))+cCaracFim+Chr(13)
						Next n
					EndIf
				Next x

				If nPrimeira == 1
					cZ4_MEMO += "+--------------------------------------------------------------------------+" + Chr(13)
				EndIf
				cZ4_MEMO +=    "|##CHAMADO:" + SZK->ZK_NUMCHAM + " INTERAวรO:" + SZK->ZK_NUMINTE + " | " + DtoC(SZK->ZK_DT_INC) + " | " + SZK->ZK_HR_INC + " | " + SUBS(SZK->ZK_NOMEORI,1,18) + " |" + Chr(13)
				cZ4_MEMO +=    "+--------------------------------------------------------------------------+" + Chr(13)
				cZ4_MEMO +=    cTmpTXT
				cZ4_MEMO +=    "+--------------------------------------------------------------------------+" + Chr(13)

				nPrimeira++
				cInteracao := SZK->ZK_NUMINTE
				SZK->( dbSkip() )
			End
		EndIf

		AADD(aVetorIn,{"SZ4","Z4_CODIGO" , "######"                  })
		AADD(aVetorIn,{"SZ4","Z4_CLIENTE", "000012"                  })
		AADD(aVetorIn,{"SZ4","Z4_LOJA"   , "01"                      })
		AADD(aVetorIn,{"SZ4","Z4_NOMECLI", "DOMEX"                   })
		AADD(aVetorIn,{"SZ4","Z4_DESC"   , SZJ->ZJ_Z4DESC            })
		AADD(aVetorIn,{"SZ4","Z4_NIVEL"  , "3"                       })
		AADD(aVetorIn,{"SZ4","Z4_SUPN1"  , SZ4->Z4_SUPN1             })
		AADD(aVetorIn,{"SZ4","Z4_SUPERIO", SZJ->ZJ_Z4COD             })
		AADD(aVetorIn,{"SZ4","Z4_DTCAD"  , Date()                    })
		AADD(aVetorIn,{"SZ4","Z4_DTAUTOR", Date()                    })
		AADD(aVetorIn,{"SZ4","Z4_COBRANC", "2"                       })
		AADD(aVetorIn,{"SZ4","Z4_TXTCHAM", cZ4_MEMO                  })
		AADD(aVetorIn,{"SZ4","Z4_CHAMADO", SZJ->ZJ_NUMCHAM           })
		AADD(aVetorIn,{"SZ4","Z4_ITEMCHA", cInteracao                })
		AADD(aVetorIn,{"SZ4","Z4_RELATO" , "S"                       })
		AADD(aVetorIn,{"SZ4","Z4_MSBLQL" , "2"                       })
		AADD(aVetorIn,{"SZ4","Z4_CONSULT", SZJ->ZJ_Z4CONSU           })
		//AADD(aVetorIn,{"SZ4","Z4_SEPFAT" , "000001"                })
		AADD(aVetorIn,{"SZ4","Z4_LINHA"  , "ZZZZZZZZZZZZZZZ"         })

		SZL->(DbSetOrder(1))
		If SZL->(DbSeek(SZJ->ZJ_FILIAL+SZJ->ZJ_NUMCHAM))
			//Cria pasta caso nใo exita ainda (PASTA PARA SINCRONIZAวรO COM SISTEMOPUS)
			MontaDir(cAnexoOpus+M->ZJ_NUMCHAM+"\")

			If !File(cAnexoOpus+M->ZJ_NUMCHAM+"\"+cExisteAnexo)
				COPY File &cAnexoOpus+cExisteAnexo TO &cAnexoOpus+M->ZJ_NUMCHAM+"\"+cExisteAnexo
			EndIf

			While SZL->(!Eof()) .And. SZL->ZL_FILIAL+SZL->ZL_NUMCHAM == SZJ->ZJ_FILIAL+SZJ->ZJ_NUMCHAM
				cArqOrig := Alltrim(SZL->ZL_ARQUIVO)
				cArqDest := cAnexoOpus+M->ZJ_NUMCHAM+'\'
				For x := Len(cArqOrig) to 1 Step (-1)
					If Subs(cArqOrig,x,1) == '\'
						cArqDest += StrTran(Subs(Subs(cArqOrig,x+1),1,3)+'_'+DtoC(SZL->ZL_DATA)+"_"+Subs(SZL->ZL_HORA,1,2)+'h'+Subs(SZL->ZL_HORA,4,2)+"m_"+Alltrim(SZL->ZL_USUARIO)+Subs(Subs(cArqOrig,x+1),4),'/','-')
						Exit
					EndIf
				Next x
				COPY File &cArqOrig TO &cArqDest
				SZL->(DbSkip())
			End
		EndIf

		//If MsgNoYes("Deseja aguardar o envio do chamado para o SistemOpus (Yes) ou coloca-lo na fila de envio (No)")
		//	U_fWSOpus(aVetorIn,"R")
		//	MsgInfo("Chamado gravado com sucesso")
		//Else
		U_GravaSZ4(aVetorIn,"R")
		MsgInfo("Chamado colocado na fila para ser incluํdo no SistemOpus")
		//EndIf

	EndIf

	oDlg:End()

Return

User Function fZKITEM(cChamado)
	Local _Retorno := "001"

	cQuery := "SELECT MAX(ZK_NUMINTE) AS MAX_ITEM FROM " + RetSqlName("SZK") + " WHERE ZK_NUMCHAM = '"+cChamado+"' AND D_E_L_E_T_ = '' "

	If Select("QUERYSZK") <> 0
		QUERYSZK->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "QUERYSZK"

	_Retorno := StrZero(Val(QUERYSZK->MAX_ITEM)+1,3)

Return _Retorno

Static Function fRetCodCon(cConsultor)
	Local aTemp := {}
	Local x
	Local _Retorno := ""

	If Subs(cConsultor,1,1) <> '0'
		nTemp := aScan(aConsultores,cConsultores)
		//alert(str(nTemp))
		_Retorno := aCodConsult[nTemp]
	EndIf

Return _Retorno

//Retorna Classifica็ใo do Chamado Domex
User Function DmxClaCh(nTipo,cCampo)
Local cTitulo
Local cDescri
Local cCombo
Local cRet := "1=Suporte N1;2=Suporte N2;3=Suporte N3 OpusVP;4=Melhoria;5=Projeto;6=Suporte N3 Outros;7=Aguardando envio Opus;8=Obriga็๕es" 
Default nTipo := 1
Default cCampo := "ZJ_CLASSIF"

//dbSelectArea(“SX3”)
SX3->(dbSetOrder(2))
If SX3->(dbSeek( cCampo )  )
	If nTipo == 3 //Se for Engenharia
		cRet := "9=Telecom;10=Subsistemas;3=Aplicacao"
		If Alltrim(SX3->X3_CBOX) <> Alltrim(cRet ) .And. Alltrim(SX3->X3_CAMPO) == Alltrim(cCampo)
			If Reclock("SX3",.F.) 
				SX3->X3_CBOX := cRet
				SX3->(MsUnlock())
			EndIf
		EndIf
	else
		cRet := "1=Suporte N1;2=Suporte N2;3=Suporte N3 OpusVP;4=Melhoria;5=Projeto;6=Suporte N3 Outros;7=Aguardando envio Opus;8=Obriga็๕es" 
		If Alltrim(SX3->X3_CBOX) <> Alltrim(cRet ) .And. Alltrim(SX3->X3_CAMPO) == Alltrim(cCampo)
			If Reclock("SX3",.F.) 
				SX3->X3_CBOX := cRet
				SX3->(MsUnlock())
			EndIf
		EndIf
	EndIf
	//cTitulo := X3Titulo()   
	//cDescri := X3Descri()   
	//cCombo  := X3Cbox()
EndIf

Return 


