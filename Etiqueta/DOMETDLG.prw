#include "protheus.ch"
#include "rwmake.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMETDLG ºAutor  ³ Felipe A. Melo     º Data ³  12/02/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DOMETDLG()

	Local lLoop    := .T.
	Local lOk      := .F.
	Local aPar     := {}
	Local aRet     := {}
	Local aLayout  := {}

	Private mv_par01 := 1         //Pesquisar por OP ou Senf
	Private mv_par02 := Space(11) //Numero OP
	Private mv_par03 := Space(09) //Senf + Item
	Private mv_par04 := 0         //Qtd Embalagem
	Private mv_par05 := 0         //Qtd Etiquetas
	Private mv_par06 := Space(03) //Layout da Etiqueta
	Private mv_par07 := 0		   //Serial Inicial
	Private __PESO   := 0

	aAdd(aPar,{3,"Pesquisar Por"     ,mv_par01  ,{"1-Numero O.P.","2-Senf + Item"}           ,  100,              ,.T.})
	aAdd(aPar,{1,"Numero O.P."       ,mv_par02  ,"@!"       ,/*"NaoVazio()"*/                ,     ,"mv_par01==1" ,060 ,.F.})
	aAdd(aPar,{1,"Senf + Item"       ,mv_par03  ,"@!"       ,/*"NaoVazio()"*/                ,     ,"mv_par01==2" ,060 ,.F.})
	aAdd(aPar,{1,"Qtde por Embalagem",mv_par04  ,"@E 99999" ,"NaoVazio()"                    ,     ,              ,060 ,.T.})
	aAdd(aPar,{1,"Qtde de Etiquetas" ,mv_par05  ,"@E 99999" ,"NaoVazio()"                    ,     ,              ,060 ,.T.})
	aAdd(aPar,{1,"Layout"            ,mv_par06  ,"@!"       ,"ExistCpo('SX5','Z3'+mv_par06)" ,"Z3" ,              ,060 ,.T.})
	aAdd(aPar,{1,"Serial Inicial"    ,mv_par07  ,"@E 99999" ,"NaoVazio()"                    ,     ,              ,060 ,.T.})


	While lLoop
		//Define Variaveis
		lOk      := .F.
		mv_par01 := 1         //Pesquisar por OP ou Senf
		mv_par02 := Space(11) //Numero OP
		mv_par03 := Space(09) //Senf + Item
		mv_par04 := 0         //Qtd Embalagem
		mv_par05 := 0         //Qtd Etiquetas
		mv_par06 := Space(03) //Layout da Etiqueta
		mv_par07 := 0         //Qtd Etiquetas

		//Chama tela de perguntas
		If ParamBox(aPar,"Impressão Etiqueta",@aRet)
			mv_par01 := aRet[1]
			mv_par02 := aRet[2]
			mv_par03 := aRet[3]
			mv_par04 := aRet[4]
			mv_par05 := aRet[5]
			mv_par06 := aRet[6] //Space(02)
			mv_par07 := aRet[7] //Space(02)
			Do Case
			Case Empty(mv_par02) .And. mv_par01 == 1  .and. (mv_par06 <> "20" .and. mv_par06 <> "21") .and. mv_par06 <> "109"
				Alert("Favor preencher o Numero da O.P.")

			Case Empty(mv_par03) .And. mv_par01 == 2 .and. mv_par06 <> "109"
				Alert("Favor preencher o Senf + Item")

			Otherwise
				lOk   := .T.
			EndCase
		Else
			lOk   := .F.
			lLoop := .F.
		EndIf

		//Caso OK, chama rotina de impressão de etiqueta
		If lOk

			If AllTrim(mv_par06)=="93" .And. !Empty(MV_PAR02)
				If !SC2->(dbSeek(xFilial("SC2")+MV_PAR02)) .and. (mv_par06 <> "20" .and. mv_par06 <> "21")
					Aviso("Atenção","OP invalida.",{"Ok"})
					Loop
				EndIf
			EndIf

			cGrupo  := Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_GRUPO")
			cSubCla := Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_SUBCLAS")

			__PESO    := 0
			lColetor  := .F.
			mv_par06  := AllTrim(mv_par06)

			If mv_par06 $ "16*88*89*38"
				cNumSerie := mv_par07
			Else
				cNumSerie := ""
			EndIf

			If mv_par06 == "01"
				U_DOMETQ04(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie) //Layout 01 - HUAWEI UNIFICADA
			ElseIf mv_par06 == "02"
				U_DOMETQ03(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie) //Layout 02
			ElseIf mv_par06 == "03"
				U_DOMETQ05(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie) //Layout 03
			ElseIf mv_par06 == "04"
				U_DOMETQ06(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie) //Layout 04 - Por Michel A. Sander
			ElseIf mv_par06 == "05"
				U_DOMETQ07(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie) //Layout 05 - Por Michel A. Sander
			ElseIf mv_par06 == "06"
				U_DOMETQ08(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie) //Layout 06 - Por Michel A. Sander
			ElseIf mv_par06 == "07"
				U_DOMETQ09(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie) //Layout 07 - Por Michel A. Sander
			ElseIf mv_par06 == "10"
				U_DOMETQ10(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie) //Layout 10 - Por Michel A. Sander
			ElseIf mv_par06 == "11"
				U_DOMETQ11(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie) //Layout 11 - Por Michel A. Sander
			ElseIf mv_par06 == "12"
				U_DOMETQ12(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie) //Layout 12 - Por MLS
			ElseIf mv_par06 == "13"
				U_DOMETQ13(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie) //Layout 13 - Por Michel A. Sander
			ElseIf mv_par06 == "14"
				U_DOMETQ14(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie) //Layout 13 - Por Michel A. Sander
			ElseIf mv_par06 == "15"
				U_DOMETQ15(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie) //Layout 15 - Por Michel A. Sander
			ElseIf mv_par06 == "16"
				U_DOMETQ16(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie) //Layout 16 - Por Michel A. Sander

			ElseIf mv_par06 == "17"
				U_DOMETQ17(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie) //Layout 13 - Por Michel A. Sander

			ElseIf mv_par06 == "31"
				U_DOMETQ31(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie) //Layout 31 - Por Michel A. Sander
			ElseIf mv_par06 == "36"
				U_DOMETQ36(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie) //Layout 36 - Por Michel A. Sander
			ElseIf mv_par06 == "38"
				U_DOMETQ38(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,mv_par07)  //Layout 38 - Kit Pigtail Por Michel A. Sanders
			ElseIf mv_par06 == "70"
				U_DOMETQ70(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,mv_par07)  //Layout 80 - Serial Datamatrix Por Michel A. Sander
			ElseIf mv_par06 == "71"
				U_DOMETQ71(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,mv_par07)  //Layout 71 - Junção 29 Trunk (NOVO) Por Michel A. Sander
			ElseIf mv_par06 == "80"
				U_DOMETQ80(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,mv_par07)  //Layout 80 - Serial Datamatrix Por Michel A. Sander
			ElseIf mv_par06 == "81"
				U_DOMETQ81(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,mv_par07) //Layout 81 - Serial em T Datamatrix Por Michel A. Sander
			ElseIf mv_par06 == "82"
				U_DOMETQ82(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie) //Layout 82 - Serial Datamatrix Sem Numeração Por Michel A. Sander
			ElseIf mv_par06 == "83"
				U_DOMETQ83(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,mv_par07) //Layout 83 - Junção 28 Trunk Por Michel A. Sander
			ElseIf mv_par06 == "84"
				U_DOMETQ84(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,mv_par07) //Layout 84 - Junção 29 Trunk Por Michel A. Sander
			ElseIf mv_par06 == "85"
				U_DOMETQ85(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,mv_par07) //Layout 85 - Cordão Ericsson Por Michel A. Sander
			ElseIf mv_par06 == "86"
				U_DOMETQ86(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,iif(ValType(mv_par07) <> "C","1",mv_par07)) //Layout 86 - Junção 29 Trunk Por Michel A. Sander
			ElseIf mv_par06 == "87"
				U_DOMETQ87(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,mv_par07) //Layout 87 - Por Michel A. Sander (Huawei 50X100mm)
			ElseIf mv_par06 == "87B"
				U_DOMET87B(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,mv_par07) //Layout 87 - Por Michel A. Sander (Huawei 50X100mm)
			ElseIf mv_par06 == "88"
				U_DOMETQ88(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie) //Layout 10 - COM DATAMATRIX
			ElseIf mv_par06 == "89"
				U_DOMETQ89(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie) //Layout 10 - COM DATAMATRIX
			ElseIf mv_par06 == "90"
				U_DOMETQ90(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie,Nil,Nil) //Layout 90 - Por Michel A. Sander
			ElseIf mv_par06 == "93"
				If !Empty(mv_par03)
					SC5->(dbSetOrder(1))
					SC5->(dbSeek(xFilial()+SUBSTR(MV_PAR03,1,6)))
					SC6->(dbSetOrder(1))
					SC6->(dbSeek(xFilial()+ALLTRIM(MV_PAR03)))
					U_DOMETQ93(mv_par03,SC6->C6_PRODUTO, SC5->C5_NUM   , mv_par05, dDataBase, .F., '', 0, .T., mv_par04) // Layout 93 - Por Michel A. Sander TELEFONICA
				Else
					U_DOMETQ93(mv_par02,SC2->C2_PRODUTO, SC2->C2_PEDIDO, mv_par05, dDataBase, .F., '', 0, .T., mv_par04) // Layout 93 - Por Michel A. Sander TELEFONICA
				EndIf
			ElseIf mv_par06 == "94"
				U_DOMETQ94(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie) //Layout 94 - Por Michel A. Sander (ERICSSON JUMPER)
			ElseIf mv_par06 == "97"
				U_DOMETQ97(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie) //Layout 94 - Por Michel A. Sander (ERICSSON JUMPER)
			ElseIf mv_par06 == "99"
				U_DOMETQ99(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie) //Layout 99 - Por Michel A. Sander (HUAWEI CRYSTAL)
			ElseIf mv_par06 == "20"
				U_DOMETQ20('000012',mv_par05,2) //Layout 0A - Por Ricardo Roda (Instrução Grande)
			ElseIf mv_par06 == "21"
				U_DOMETQ20('000012',mv_par05,1) //Layout 0A - Por Ricardo Roda (Instrução Pequena)
			ElseIf mv_par06 == "106"
				If !Empty(mv_par03)
					SC5->(dbSetOrder(1))
					SC5->(dbSeek(xFilial()+SUBSTR(MV_PAR03,1,6)))
					SC6->(dbSetOrder(1))
					SC6->(dbSeek(xFilial()+ALLTRIM(MV_PAR03)))
					U_DOMET106(mv_par03,SC6->C6_PRODUTO, SC5->C5_NUM   , mv_par05, dDataBase, .F., '', 0,mv_par04) // Layout 93 - Por Michel A. Sander TELEFONICA
				Else
					SC2->(dbSeek(xFilial("SC2")+MV_PAR02))
					U_DOMET106(mv_par02,SC2->C2_PRODUTO, SC2->C2_PEDIDO, mv_par05, dDataBase, .F., '', 0,mv_par04) // Layout 93 - Por Michel A. Sander TELEFONICA
				EndIf
				//U_DOMET106(cEtqOp, cEtqProd, cEtqPed, nEtqQtd, dDataFab, lControl, cNfDanfe, nPesoDanfe, nQtdProd)

			ElseIf mv_par06 == "107" // Layout 107 - Ricardo Roda
				U_DOMET107(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,mv_par07)
			ElseIf mv_par06 == "108" // Layout 108 - Ricardo Roda
				U_DOMET108(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,mv_par07)
			ElseIf mv_par06 == "109" // Layout 109 - Ricardo Roda
				U_DOMET109(mv_par05)
			ElseIf mv_par06 == "110" // Layout 110 - Ricardo Roda (IBM)
				U_DOMET110(mv_par02,mv_par05, mv_par07)
			ElseIf mv_par06 == "111" // Layout 111 (CLARO)
				U_DOMET111(mv_par02,mv_par03,mv_par04,mv_par05,/*cNivel*/,/*aFilhas*/{},/*lImpressao*/.T.,/*nPesoVol*/1,/*cVolumeAtu*/,/*lColetor*/.F.)
			ElseIf mv_par06 == "112" // Layout 112 - (AMAZOM))
				U_DOMET112(mv_par02,mv_par03,mv_par04,mv_par05,/*cNivel*/,/*aFilhas*/{},/*lImpressao*/.T.,/*nPesoVol*/1,/*cVolumeAtu*/,/*lColetor*/.F.)
			ElseIf mv_par06 == "113" // Layout 113 - (ID CORTE - AVULSA))
				U_DOMET113(mv_par02,mv_par05,mv_par07)

			ElseIf mv_par06 == "39" // Layout 39 COPIA DO LAYOUT 002 COM QRCODE
				U_DOMETQ39(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie)
			ElseIf mv_par06 == "40"  // Layout 40 COPIA DO LAYOUT 004 COM QRCODE
				U_DOMETQ40(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie)
			ElseIf mv_par06 == "41"  // Layout Ericsson Zebra
				U_DOMETQ41(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie)
			ElseIf mv_par06 == "42"
				U_DOMETQ42(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,mv_par07)
			ElseIf mv_par06 == "43" // Layout 43 - (NOVO LAYOUT SUBSTITUTO DA 107) Ricardo Roda
				U_DOMETQ43(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,mv_par07)
			ElseIf mv_par06 == "44" // Layout 44 - (NOVO LAYOUT SUBSTITUTO DA 83) Ricardo Roda
				U_DOMETQ44(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,mv_par07)
			ElseIf mv_par06 == "45" // Layout 44 - (NOVO LAYOUT SUBSTITUTO DA 83) Ricardo Roda
				U_DOMETQ45(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,mv_par07) //Antigo Layout 88 - COM DATAMATRIX e Impressora ZEBRA
			ElseIf mv_par06 == "46" // Layout 44 - (NOVO LAYOUT SUBSTITUTO DA 83) Ricardo Roda
				U_DOMETQ46(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,mv_par07) //Antigo Layout 88 - COM DATAMATRIX e Impressora ZEBRA
			ElseIf mv_par06 == "47" // Layout 47 - Ricardo Roda
				U_DOMETQ47(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,mv_par07)
			ElseIf mv_par06 == "48" // Layout 48 - Ricardo Roda
				U_DOMETQ48(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie,"") 
			ElseIf mv_par06 == "49" // Layout 49 - Ricardo Roda
				U_DOMETQ49(mv_par02,mv_par03,""      ,mv_par04, mv_par05, .F.     , "",0)
			ElseIf mv_par06 == "50" // Layout 50 - Ricardo Roda
				U_DOMETQ50(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie,"")
		
			ElseIf mv_par06 == "115"  // Layout 49 - etiqueta V-Tal
				U_DOMET115(mv_par02,mv_par05,mv_par07)
			ElseIf mv_par06 == "117"  // Layout 117 - (TELECOM ARGENTINA )
				U_DOMET117(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,__PESO,lColetor,cNumSerie)
			EndIf


		EndIf

	End

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fPsqLayoutºAutor  ³ Felipe Melo        º Data ³  12/02/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fPsqLayout(cNumOP,cNumSenf)

	Local lAchou  := .T.
	Local cLayOut := ""

	If !Empty(cNumOP)
		//Localiza SC2
		SC2->(DbSetOrder(1))
		If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+cNumOP))
			Alert("Numero O.P. "+AllTrim(cNumOP)+" não localizada!")
			lAchou := .F.
		EndIf

		//Localiza SC5
		SC5->(DbSetOrder(1))
		If lAchou .And. SC5->(!DbSeek(xFilial("SC5")+SC2->C2_PEDIDO))
			Alert("Numero de Senf "+AllTrim(SC2->C2_PEDIDO)+" não localizado!")
			lAchou := .F.
		EndIf

		//Localiza SC6
		SC6->(DbSetOrder(1))
		If lAchou .And. SC6->(!DbSeek(xFilial("SC6")+SC2->C2_PEDIDO+SC2->C2_ITEMPV))
			Alert("Item Senf "+AllTrim(SC2->C2_ITEMPV)+" não localizado!")
			lAchou := .F.
		EndIf
	EndIf

	If !Empty(cNumSenf)
		//Localiza SC5
		SC5->(DbSetOrder(1))
		If lAchou .And. SC5->(!DbSeek(xFilial("SC5")+Subs(cNumSenf,1,6) ))
			Alert("Numero de Senf "+Subs(cNumSenf,1,6)+" não localizado!")
			lAchou := .F.
		EndIf

		//Localiza SC6
		SC6->(DbSetOrder(1))
		If lAchou .And. SC6->(!DbSeek(xFilial("SC6")+Subs(cNumSenf,1,8) ))
			Alert("Item Senf "+Subs(cNumSenf,7,2) +" não localizado!")
			lAchou := .F.
		EndIf
	EndIf

//Localiza SA1
	SA1->(DbSetOrder(1))
	If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
		Alert("Cliente "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+" não localizado!")
		lAchou := .F.
	EndIf

//Varifica qual é o layout definido no cadastro do usuário
	If lAchou
		If SA1->(FieldPos("A1_XXETIQU")) > 0
			cLayOut := SA1->A1_XXETIQU
		Else
			Alert("O campo de Layout de impressão não foi criado no SA1!"+Chr(13)+Chr(10)+"Foi definido automaticamente o Layout 03.")
			lAchou := .F.
		EndIf
	EndIf

	If lAchou .And. Empty(cLayOut)
		Alert("Layout de impressão não definido no cadastro do cliente!")
		lAchou := .F.
	EndIf

Return({lAchou,cLayOut})

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fSemanaAnoºAutor  ³ Felipe Melo        º Data ³  11/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//Static Function fSemanaAno()
User Function fSemaAno()

	Local dDataIni := StoD(StrZero(Year(Date()),4)+"0101")
	Local dDataAtu := Date()
	Local nRet     := 0
	Local cRet     := ""
	Local nDiff    := Dow(dDataIni)

	nDias := (dDataAtu - dDataIni) + nDiff

	nRet  := nDias
	nRet  := nRet / 7
	nRet  := Int(nRet)

//Se iniciou a semana, soma 1
	If nDias % 7 > 0
		nRet := nRet + 1
	EndIf

	cRet := StrZero(nRet,2)

//Função padrão que retorna a semana e o ano
//RetSem(dDataAtu)

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fTrataTextºAutor  ³ Felipe Melo        º Data ³  11/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//Static Function fTrataText(cTexto)
User Function fTratTxt(cTexto)

	Default := cTexto

	_cDesc:=StrTran(cTexto,"–"," ")
	_cDesc:=StrTran(_cDesc,"_"," ")
	_cDesc:=StrTran(_cDesc,"~","-")
	_cDesc:=StrTran(StrTran(StrTran(StrTran(StrTran(_cDesc,"(",""),")",""),",","."),"Ø","0"),"/","-")
	_cDesc:=StrTran(StrTran(StrTran(StrTran(StrTran(_cDesc,"Á","A"),"É","E"),"Í","I"),"Ó","O"),"Ú","U")
	_cDesc:=StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(_cDesc,"Ç","C"),"Ã","A"),"Í","I"),"Ó","O"),"Ú","U"),":","")
	_cDesc:=AllTrim(_cDesc)

Return(_cDesc)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fCodNat  ºAutor  ³ Felipe Melo        º Data ³  16/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//Static Function fCodNat(cCodProd)
User Function fCodNat(cCodProd)

	Local aRet     := {}
	Local x        := 0
	Local lOk      := .T.
	Local cErro    := ""

	Local aAreaSB1 := SB1->(GetArea())
	Local aAreaSG1 := SG1->(GetArea())

	SB1->(DbSetOrder(1))
	SG1->(DbSetOrder(1))

//SB1->(DbSeek(xFilial("SB1")+cCodProd)) //MLS
//MSGALERT('DOMETQ01:'+cCodProd)        //MLS
	cNEtiquetas := ""
	If SG1->(DbSeek(xFilial("SG1")+cCodProd))
		cNEtiquetas := Alltrim(SB1->B1_XXNANAT)

		While SG1->(!Eof()) .And. AllTrim(cCodProd) == AllTrim(SG1->G1_COD)
			If SB1->(DbSeek(xFilial("SB1")+SG1->G1_COMP)) .And. !Empty(SB1->B1_XXANAT1)
				//For x:=1 To SG1->G1_QUANT
				If aScan(aRet,SB1->B1_XXANAT1) == 0
					aAdd(aRet,SB1->B1_XXANAT1)
				EndIf
				//Next x
				//If (SG1->G1_QUANT%1) > 0
				//	lOk := .F.
				//	cErro += IIf(Empty(cErro),""," / ") + AllTrim(SG1->G1_COMP)
				//EndIf
			EndIf
			SG1->(DbSkip())
		End
	EndIf

	If Empty(cNEtiquetas)
		MsgStop('Não foi preenchido o número de códigos de Barra Anatel no produto ' + cCodProd)
		Aviso("Atenção","Não foi preenchido o número de códigos de Barra Anatel no produto " + cCodProd,{"Ok"})
		cTxtMsg  := "Não foi preenchido o número de códigos de Barra Anatel no produto " + cCodProd + Chr(13)
		cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
		cAssunto := "Codigo ANATEL"
		cPara    := 'denis.vieira@rdt.com.br;fabiana.santos@rdt.com.br'
		cCC      := 'monique.garcia@rosenbergerdomex.com.br;tatiane.alves@rosenbergerdomex.com.br;daniel.cavalcante@rosenbergerdomex.com.br;luiz.pavret@rdt.com.br' //mls 04/05/2015
		cCC      += ';natalia.silva@rosenbergerdomex.com.br;keila.gamt@rosenbergerdomex.com.br;leonardo.andrade@rosenbergerdomex.com.br;gabriel.cenato@rosenbergerdomex.com.br' //chamado monique 015475
		cArquivo := Nil
		U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
	Else
		If cNEtiquetas == '0'
			If Len(aRet) <> 0
				MsgStop('No produto ' + Alltrim(cCodProd) + ' foi selecionado a opção de 0 códigos de Barra Anatel, e foi encontrado ' + Alltrim(Str(Len(aRet)))+' código Anatel na Etrutura do Produto.')
				lOk := .F.
			EndIf
		Else
			If cNEtiquetas == '1' .or. cNEtiquetas == '2'
				If Len(aRet) <> 1
					MsgStop('No produto ' + Alltrim(cCodProd) + ' foi selecionado a opção de 1 códigos de Barra Anatel, e foi encontrado ' + Alltrim(Str(Len(aRet)))+' código Anatel na Etrutura do Produto.')
					lOk := .F.
				EndIf
			Else
				If cNEtiquetas == '3'
					If Len(aRet) <> 2
						MsgStop('No produto ' + Alltrim(cCodProd) + ' foi selecionado a opção de 2 códigos de Barra Anatel, e foi encontrado ' + Alltrim(Str(Len(aRet)))+' código Anatel na Etrutura do Produto.')
						lOk := .F.
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

//If !lOk
//	Alert("A quantidade da(s) MP(s) "+cErro+" está(ão) com casas decimais na quantidade da estrutura e isso não é permitido!")
//EndIf

	RestArea(aAreaSB1)
	RestArea(aAreaSG1)

Return({lOk,aRet})
