#include "protheus.ch"
#include "rwmake.ch"
                             
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMETDL5 ºAutor  ³ Michel A. Sander   º Data ³  26.01.17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressão de etiquetas com amarração de layout serial      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMETDL5()

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
Private mv_par06 := Space(02) //Layout da Etiqueta
Private mv_par07 := 0
Private _PesoAuto:= 0
nEdit := 0

aAdd(aPar,{3,"Pesquisar Por"     ,mv_par01  ,{"1-Numero O.P.","2-Senf + Item"}          ,  100,              ,.T.})
aAdd(aPar,{1,"Numero O.P."       ,mv_par02  ,"@!"      ,/*"NaoVazio()"*/                ,     ,"mv_par01==1" ,060 ,.F.})
aAdd(aPar,{1,"Senf + Item"       ,mv_par03  ,"@!"      ,/*"NaoVazio()"*/                ,     ,"mv_par01==2" ,060 ,.F.})
aAdd(aPar,{1,"Qtde por Embalagem",mv_par04  ,"@E 99999" ,"NaoVazio()"                   ,     ,              ,060 ,.T.})
aAdd(aPar,{1,"Qtde de Etiquetas" ,mv_par05  ,"@E 99999" ,"NaoVazio()"                   ,     ,              ,060 ,.T.})
aAdd(aPar,{1,"Serial Inicial"    ,mv_par07  ,"@E 99999" ,"NaoVazio()"                   ,     ,              ,060 ,.T.})

While lLoop

	//Define Variaveis
	lOk      := .F.
	mv_par01 := 1         //Pesquisar por OP ou Senf
	mv_par02 := Space(11) //Numero OP
	mv_par03 := Space(09) //Senf + Item
	mv_par04 := 0         //Qtd Embalagem
	mv_par05 := 0         //Qtd Etiquetas
	mv_par06 := Space(02) //Layout da Etiqueta
	mv_par07 := 0         //Qtd Etiquetas
	
	//Chama tela de perguntas
	If ParamBox(aPar,"Impressão Etiqueta",@aRet)
		mv_par01 := aRet[1]
		mv_par02 := aRet[2]
		mv_par03 := aRet[3]
		mv_par04 := aRet[4]
		mv_par05 := aRet[5]
		mv_par06 := SPACE(02)
		mv_par07 := aRet[6] 
		Do Case
			Case Empty(mv_par02) .And. mv_par01 == 1
				Alert("Favor preencher o Numero da O.P.")

			Case Empty(mv_par03) .And. mv_par01 == 2
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
	   If !SC2->(dbSeek(xFilial("SC2")+MV_PAR02))
	      //Aviso("Atenção","OP invalida.",{"Ok"})
	      Alert("OP invalida")
	      
	      Loop
	   EndIf
	   cGrupo  := Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_GRUPO")
	   cSubCla := Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_SUBCLAS")
	   cCodCli := Posicione("SA1",1,xFilial("SA1")+SC2->C2_CLIENT,"A1_COD")
	   cLojCli := Posicione("SA1",1,xFilial("SA1")+SC2->C2_CLIENT,"A1_LOJA")
	   If !SZG->(dbSeek(xFilial("SZG")+cCodCli+cLojCli+cGrupo))
	      //Aviso("Atenção","Não existe layout de etiqueta amarrado para esse Cliente x Grupo de produto.",{"Ok"})
	      Alert("Não existe layout de etiqueta amarrado para esse Cliente x Grupo de produto.")
			cTxtMsg  := " Não existe layout de etiqueta amarrado para esse Cliente x Grupo de produto." + Chr(13)
			cTxtMsg  += " Produto = " + SC2->C2_PRODUTO + Chr(13)
			cTxtMsg  += " Cliente = " + SC2->C2_CLIENT  + Chr(13)
			cAssunto := "Amarração Cliente x Grupo de Produto x Layout de Etiqueta"
			cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
			cPara    := 'denis.vieira@rdt.com.br;tatiane.alves@rosenbergerdomex.com.br;fabiana.santos@rdt.com.br;monique.garcia@rosenbergerdomex.com.br;daniel.cavalcante@rosenbergerdomex.com.br'
	      cCC      := 'natalia.silva@rosenbergerdomex.com.br;keila.gamt@rosenbergerdomex.com.br;leonardo.andrade@rosenbergerdomex.com.br;gabriel.cenato@rosenbergerdomex.com.br;luiz.pavret@rdt.com.br' //chamado monique 015475
			cArquivo := Nil
			U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
	      Loop
	   EndIf

	   If Empty(SZG->ZG_SERIAL)
	      //Aviso("Atenção","Não existe layout serial amarrado para esse grupo.")
	      Alert("Não existe layout serial amarrado para esse grupo.")
	      
	      Loop
	   EndIf
	   
	   mv_par06  := SZG->ZG_SERIAL
	   If AllTrim(cSubCla)=="MHARNESS"
	      mv_par06 := "86"
	   EndIf
	   
	   _PesoAuto := 0
	   lColetor  := .F.
	   
	   If mv_par06=="86"
		   cNumSerie := AllTrim(str(mv_par07))
	   ElseIf mv_par06 == "16"
	      cNumSerie := mv_par07
	   ElseIf mv_par06 == "38"
	      cNumSerie := mv_par07
	   ElseIf mv_par06 == "81"
	      cNumSerie := mv_par07
	   Else
	      cNumSerie := ""
	   EndIf
		
		Do Case
			Case mv_par06 == "01"
				U_DOMETQ04(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,_PesoAuto,lColetor,cNumSerie) //Layout 01 - HUAWEI UNIFICADA
			Case mv_par06 == "02"
				U_DOMETQ03(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,_PesoAuto,lColetor,cNumSerie) //Layout 02
			Case mv_par06 == "03"
				U_DOMETQ05(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,_PesoAuto,lColetor,cNumSerie) //Layout 03
			Case mv_par06 == "04"
			   U_DOMETQ06(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,_PesoAuto,lColetor,cNumSerie) //Layout 04 - Por Michel A. Sander	
			Case mv_par06 == "05"
			   U_DOMETQ07(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,_PesoAuto,lColetor,cNumSerie) //Layout 05 - Por Michel A. Sander	
			Case mv_par06 == "06"
			   U_DOMETQ08(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,_PesoAuto,lColetor,cNumSerie) //Layout 06 - Por Michel A. Sander	
			Case mv_par06 == "07"
			   U_DOMETQ09(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,_PesoAuto,lColetor,cNumSerie) //Layout 07 - Por Michel A. Sander	
			Case mv_par06 == "10"
			   U_DOMETQ10(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,_PesoAuto,lColetor,cNumSerie) //Layout 10 - Por Michel A. Sander	
			Case mv_par06 == "11"
			   U_DOMETQ11(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,_PesoAuto,lColetor,cNumSerie) //Layout 11 - Por Michel A. Sander	
			Case mv_par06 == "12"
			   U_DOMETQ12(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,_PesoAuto,lColetor,cNumSerie) //Layout 11 - Por MLS			   
			Case mv_par06 == "13"
			   U_DOMETQ13(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,_PesoAuto,lColetor,cNumSerie) //Layout 11 - Por Michel A. Sander
			Case mv_par06 == "14"
			   U_DOMETQ14(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,_PesoAuto,lColetor,cNumSerie) //Layout 11 - Por Michel A. Sander
			Case mv_par06 == "15"
			   U_DOMETQ15(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,_PesoAuto,lColetor,cNumSerie) //Layout 15 - Por Michel A. Sander	
			Case mv_par06 == "16"
			   U_DOMETQ16(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,_PesoAuto,lColetor,cNumSerie) //Layout 16 - Por Michel A. Sander	
			Case mv_par06 == "31"
			   U_DOMETQ31(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,_PesoAuto,lColetor,cNumSerie) //Layout 31 - Por Michel A. Sander
			Case mv_par06 == "36"
			   U_DOMETQ36(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,_PesoAuto,lColetor,cNumSerie) //Layout 36 - Por Michel A. Sander
			Case mv_par06 == "38"
			   U_DOMETQ38(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,_PesoAuto,lColetor,cNumSerie) //Layout 36 - Por Michel A. Sander
			Case mv_par06 == "71"
			   U_DOMETQ71(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,_PesoAuto,lColetor,cNumSerie) //Layout 71 - Por Michel A. Sander
			Case mv_par06 == "80"
			   U_DOMETQ80(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,_PesoAuto,lColetor,cNumSerie) //Layout 80 - Por Michel A. Sander
			Case mv_par06 == "81"
			   U_DOMETQ81(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,_PesoAuto,lColetor,cNumSerie) //Layout 81 - Por Michel A. Sander
			Case mv_par06 == "82"
			   U_DOMETQ82(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,_PesoAuto,lColetor,cNumSerie) //Layout 82 - Por Michel A. Sander
			Case mv_par06 == "83"
			   U_DOMETQ83(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,_PesoAuto,lColetor,cNumSerie) //Layout 83 - Por Michel A. Sander
			Case mv_par06 == "84"
			   U_DOMETQ84(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,_PesoAuto,lColetor,cNumSerie) //Layout 84 - Por Michel A. Sander
			Case mv_par06 == "85"
			   U_DOMETQ85(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,_PesoAuto,lColetor,cNumSerie) //Layout 85 - Por Michel A. Sander
			Case mv_par06 == "86"
			   U_DOMETQ86(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,_PesoAuto,lColetor,cNumSerie) //Layout 86 - Por Michel A. Sander
			Case mv_par06 == "87"
			   U_DOMETQ87(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,_PesoAuto,lColetor,cNumSerie) //Layout 87 - Por Michel A. Sander
			Case mv_par06 == "90"
			   U_DOMETQ90(mv_par02,mv_par03,mv_par04,mv_par05,'1',{},.T.,_PesoAuto,lColetor,cNumSerie,Nil,Nil) //Layout 90 - Por Michel A. Sander
		EndCase
	EndIf

End

Return
