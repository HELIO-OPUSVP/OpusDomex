#Include "PROTHEUS.CH"
//--------------------------------------------------------------
/*/{Protheus.doc} DOMCEI
Description

@param xParam Parameter Description
@return xRet Return Description
@author  -
@since 04/06/2019
/*/
//--------------------------------------------------------------

// QDHSZV

User Function DOMCEI()
	Private A,B,C,D,E,F,G,H,I,J,K,L,M,N,O
	Private cVar1  := SPACE(1)
	Private cVar2  := " "
	Private cVar3  := " "
	Private cVar4  := " "
	Private cVar5  := " "
	Private cVar6  := " "
	Private cVar7  := " "
	Private cVar8  := " "
	Private cVar9  := " "
	Private cVar10 := " "
	Private cVar11 := " "
	Private cVar12 := " "
	Private cVar13 := " "
	Private cVar14 := " "
	Private cVar15 := " "
	Private cVar16 := ""
	Private _Codigo
	Private cTabF3:= "SB1"

	Private oFont1 := TFont():New("Calibri",,072,,.T.,,,,,.F.,.F.)
	Private oFont2 := TFont():New("MS Sans Serif",,016,,.F.,,,,,.F.,.F.)
	Private oFont3 := TFont():New("Calibri",,026,,.F.,,,,,.F.,.F.)
	Private oFont4 := TFont():New("Arial",,032,,.T.,,,,,.F.,.F.)
	Private oFont5 := TFont():New("Arial",,020,,.T.,,,,,.F.,.F.)
	Private oPanel1
	Private oGroup1
	Private oSay1
	Private oSay2
	Private oSay3
	Private oSay4
	Private oSay5
	Private oSay6
	Private oSay7
	Private oSay8
	Private oSay9
	Private oSay10
	Private oSay11
	Private oSay12
	Private oSay13
	Private oSay14
	Private oSay15
	Private oSay16
	Private aCpoHead:={}
	Private oButton1
	Private oButton2
	Private aCols2:={}
	Private aCols:={}
	Private lcodBase:= .F.
	Private lItem:= .F.
	Private lFormula:= .F.
	Private lCaract:= .F.
	Private lTam:= .F.
	Private lMascara:= .F.
	Private lDescr:= .F.
	Private oGetDados2
	Private oButton3
	Private oOpcoes
	Private cOpcoes:= CriaVar("B1_DESC")

//Private lFirst:= .T.
	Private oDlg

	aAdd(aCpoHead,"ZZA_TIPO")
	aAdd(aCpoHead,"ZZA_PN")
//aAdd(aCpoHead,"ZZA_QUANT")
	aAdd(aCpoHead,"ZZA_CONTEU")
	aAdd(aCpoHead,"ZZA_MREGRA")


	DEFINE MSDIALOG oDlg TITLE "CEI - Cadastro de Estrutura Inteligente" FROM 000, 000  TO 750, 1500 COLORS 0, 16777215 PIXEL

	@ 040, 089 MSGET A VAR cVar1  SIZE 010, 030 OF oDlg Picture "@!" VALID MontaTela() COLORS 0, 16777215 FONT oFont1 PIXEL
	@ 040, 119 MSGET B VAR cVar2  SIZE 010, 030 OF oDlg Picture "@!" VALID MontaTela() COLORS 0, 16777215 FONT oFont1 PIXEL
	@ 040, 149 MSGET C VAR cVar3  SIZE 010, 030 OF oDlg Picture "@!" VALID fVldVar()   COLORS 0, 16777215 FONT oFont1 PIXEL
	@ 040, 179 MSGET D VAR cVar4  SIZE 010, 030 OF oDlg Picture "@!" VALID fVldVar()   COLORS 0, 16777215 FONT oFont1 PIXEL
	@ 040, 209 MSGET E VAR cVar5  SIZE 010, 030 OF oDlg Picture "@!" VALID fVldVar()   COLORS 0, 16777215 FONT oFont1 PIXEL
	@ 040, 239 MSGET F VAR cVar6  SIZE 010, 030 OF oDlg Picture "@!" VALID fVldVar()   COLORS 0, 16777215 FONT oFont1 PIXEL
	@ 040, 269 MSGET G VAR cVar7  SIZE 010, 030 OF oDlg Picture "@!" VALID fVldVar()   COLORS 0, 16777215 FONT oFont1 PIXEL
	@ 040, 299 MSGET H VAR cVar8  SIZE 010, 030 OF oDlg Picture "@!" VALID fVldVar()   COLORS 0, 16777215 FONT oFont1 PIXEL
	@ 040, 329 MSGET I VAR cVar9  SIZE 010, 030 OF oDlg Picture "@!" VALID fVldVar()   COLORS 0, 16777215 FONT oFont1 PIXEL
	@ 040, 359 MSGET J VAR cVar10 SIZE 010, 030 OF oDlg Picture "@!" VALID fVldVar()   COLORS 0, 16777215 FONT oFont1 PIXEL
	@ 040, 389 MSGET K VAR cVar11 SIZE 010, 030 OF oDlg Picture "@!" VALID fVldVar()   COLORS 0, 16777215 FONT oFont1 PIXEL
	@ 040, 419 MSGET L VAR cVar12 SIZE 010, 030 OF oDlg Picture "@!" VALID fVldVar()   COLORS 0, 16777215 FONT oFont1 PIXEL
	@ 040, 449 MSGET M VAR cVar13 SIZE 010, 030 OF oDlg Picture "@!" VALID fVldVar()   COLORS 0, 16777215 FONT oFont1 PIXEL
	@ 040, 479 MSGET N VAR cVar14 SIZE 010, 030 OF oDlg Picture "@!" VALID fVldVar()   COLORS 0, 16777215 FONT oFont1 PIXEL
	@ 040, 509 MSGET O VAR cVar15 SIZE 010, 030 OF oDlg Picture "@!" VALID fVldVar()   COLORS 0, 16777215 FONT oFont1 PIXEL

	@ 024, 098 SAY oSay1  PROMPT  "1" SIZE 009, 015 OF oDlg FONT oFont3 COLORS 0, 16777215 PIXEL
	@ 024, 128 SAY oSay2  PROMPT  "2" SIZE 009, 015 OF oDlg FONT oFont3 COLORS 0, 16777215 PIXEL
	@ 024, 158 SAY oSay3  PROMPT  "3" SIZE 009, 015 OF oDlg FONT oFont3 COLORS 0, 16777215 PIXEL
	@ 024, 188 SAY oSay4  PROMPT  "4" SIZE 009, 015 OF oDlg FONT oFont3 COLORS 0, 16777215 PIXEL
	@ 024, 218 SAY oSay5  PROMPT  "5" SIZE 009, 015 OF oDlg FONT oFont3 COLORS 0, 16777215 PIXEL
	@ 024, 248 SAY oSay6  PROMPT  "6" SIZE 009, 015 OF oDlg FONT oFont3 COLORS 0, 16777215 PIXEL
	@ 024, 278 SAY oSay7  PROMPT  "7" SIZE 009, 015 OF oDlg FONT oFont3 COLORS 0, 16777215 PIXEL
	@ 024, 308 SAY oSay8  PROMPT  "8" SIZE 009, 015 OF oDlg FONT oFont3 COLORS 0, 16777215 PIXEL
	@ 024, 338 SAY oSay9  PROMPT  "9" SIZE 009, 015 OF oDlg FONT oFont3 COLORS 0, 16777215 PIXEL
	@ 024, 368 SAY oSay10 PROMPT "10" SIZE 013, 015 OF oDlg FONT oFont3 COLORS 0, 16777215 PIXEL
	@ 024, 398 SAY oSay11 PROMPT "11" SIZE 013, 015 OF oDlg FONT oFont3 COLORS 0, 16777215 PIXEL
	@ 024, 428 SAY oSay12 PROMPT "12" SIZE 013, 015 OF oDlg FONT oFont3 COLORS 0, 16777215 PIXEL
	@ 024, 458 SAY oSay13 PROMPT "13" SIZE 013, 015 OF oDlg FONT oFont3 COLORS 0, 16777215 PIXEL
	@ 024, 488 SAY oSay14 PROMPT "14" SIZE 013, 015 OF oDlg FONT oFont3 COLORS 0, 16777215 PIXEL
	@ 024, 518 SAY oSay15 PROMPT "15" SIZE 013, 015 OF oDlg FONT oFont3 COLORS 0, 16777215 PIXEL

	@ 018, 089 GROUP oGroup1 TO 040, 539 OF oDlg COLOR 0, 16777215 PIXEL

	@ 040, 539 BUTTON oButton1 PROMPT "Ok" 			SIZE 060, 032 OF oDlg ACTION (fGrvRegra(),MontaTela()) FONT oFont3 PIXEL
	@ 040, 599 BUTTON oButton2 PROMPT "Cancela" 		SIZE 060, 032 OF oDlg ACTION (oDlg:End()) FONT oFont3 PIXEL
	@ 018, 539 BUTTON oButton3 PROMPT "Relatório" 	SIZE 120, 022 OF oDlg ACTION (U_DOMRELC2()) FONT oFont3 PIXEL
//@ 018, 539 BUTTON oButton3 PROMPT "Validador" 	SIZE 120, 022 OF oDlg ACTION (fVldEstrut()) FONT oFont3 PIXEL

	@ 000, 332 SAY oSay16 PROMPT "Mascara" SIZE 055, 013 OF oDlg FONT oFont4 COLORS 0, 16777215 PIXEL
	@ 078, 300 SAY oSay17 PROMPT "Estrutura de PN" SIZE 120, 014 OF oDlg FONT oFont4 COLORS 0, 16777215 PIXEL
	@ 190, 250 SAY oSay18 PROMPT "Regra de Estrutura Inteligente" SIZE 250, 015 OF oDlg FONT oFont4 COLORS 0, 16777215 PIXEL

	@ 194, 010 SAY oSay2 PROMPT "Pesquisar" SIZE 090, 015 OF oDlg FONT oFont5 COLORS 0, 16777215 PIXEL
	@ 192, 055 MSGET oOpcoes VAR cOpcoes SIZE 086, 015 OF oDlg   COLORS 0, 16777215 FONT oFont5 PIXEL  valid(MontaTela2())

	aHeader := {}
	aCols  	:= {}
	AADD(aHeader,  {    "Código Base"      ,  "BQ_BASE"   		,"@R" 		   		,14,0,""    ,"","C","","","","",".T."})
	AADD(aHeader,  {    "Item"   		  		,  "BQ_ITEM"    	,"@R" 				,03,0,""    ,"","C","","","","",".T."})
	AADD(aHeader,  {    "Formulas" 			,  "BQ_ID"  		,"@R" 				,10,0,""    ,"","C","","","","",".T."})
	AADD(aHeader,  {    "Caracteristicas" 	,  "BQ_CARACT"  	,"@R" 				,18,0,""    ,"","C","","","","",".T."})
	AADD(aHeader,  {    "Tamanho"    		,  "BQ_TAMANHO"  	,"@E 999,999" 		,08,0,""    ,"","N","","","","",".T."})
	AADD(aHeader,  {    "Mascara" 			,  "BQ_MASCARA"  	,"@R" 				,16,0,""    ,"","C","","","","",".T."})
	AADD(aHeader,  {    "Descrição" 		,  "BQ_DESCR"  	,"@R" 				,30,0,""    ,"","C","","","","",".T."})
	AADD(aHeader,  {    "Pos.Inicio" 		,  "PINI"  			,"@R" 				,30,0,""    ,"","C","","","","",".T."})
	AADD(aHeader,  {    "Pos.Fim" 			,  "PFIM"  			,"@R" 				,30,0,""    ,"","C","","","","",".T."})

	aHeader2 := {}
	aCols2   := {}

	//                    X3_TITULO         , X3_CAMPO        , X3_PICTURE      		,X3_TAMANHO		, X3_DECIMAL , X3_VALID, X3_USADO        , X3_TIPO, X3_F3 , X3_CONTEXT , X3_CBOX      , X3_RELACAO ,X3_WHEN ,X3_VISUAL, X3_VLDUSER       , X3_PICTVAR, X3_OBRIGAT
	AADD(aHeader2,  {    "Família"     		,"ZZA_BASE"   		,"@R" 			   		,02          	,0           ,""       ,"??????????????°","C"     ,""     ,"R"         ,""            ,"cVar1+cVar2",""      ,"V"      , ""               , ""        , ""        })    //cVar1+cVar2
	AADD(aHeader2,  {    "Tipo"   		  	,"ZZA_TIPO"      	,"@R" 			  		,10          	,0           ,""       ,"??????????????°","C"     ,""     ,"R"         ,"1=Cod;2=Doc" ,""           ,""      ,"A"      , ""               , ""        , ""        })
	AADD(aHeader2,  {    "Código Produto" 	,"ZZA_PN"  	    	,"@R" 					,20          	,0           ,""       ,"??????????????°","C"     ,cTabF3 ,"R"         ,""            ,""           ,""      ,"A"      , ""               , ""        , ""        })
	AADD(aHeader2,  {    "Descrição" 		,"ZZA_DESCR"  		,"@R " 			  		,60          	,0           ,""       ,"??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader2,  {    "Conteudo"  	  	,"ZZA_CONTEU"  		,"@S100"				,256          	,0           ,""       ,"??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"A"      , ""               , ""        , ""        })
	AADD(aHeader2,  {    "Regra" 			,"ZZA_MREGRA"  		,"@S100"				,3000         	,0           ,""       ,"??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"A"      , ""               , ""        , ""        })
	AADD(aHeader2,  {    "Etiq.1"	 		,"ZZA_QETQ1"  		,"@E 9,999.9999"  		,03          	,4           ,""       ,"??????????????°","N"     ,""     ,"R"         ,""            ,""           ,""      ,"A"      , ""               , ""        , ""        })
	AADD(aHeader2,  {    "Etiq.2" 		    ,"ZZA_QETQ2"  		,"@E 9,999.9999"  		,03         	,4           ,""       ,"??????????????°","N"     ,""     ,"R"         ,""            ,""           ,""      ,"A"      , ""               , ""        , ""        })
	AADD(aHeader2,  {    "Nivel Emb." 		,"ZZA_EMB"  		,"@R " 			  		,01          	,0           ,""       ,"??????????????°","C"     ,""     ,"R"         ,"1=Nivel 1;2=Nivel 2;3=Nivel 3;4=Nivel 4"      ,""           ,""      ,"A"      , ""               , ""        , ""        })
	AADD(aHeader2,  {    "Pesa Emb." 		,"ZZA_PSEMB"  		,"@R " 			  		,01          	,0           ,""       ,"??????????????°","C"     ,""     ,"R"         ,"1=sim;2=Não" ,""           ,""      ,"A"      , ""               , ""        , ""        })
	AADD(aHeader2,  {    "Qtd.Vias" 		,"ZZA_QTDVIA"  		,"@E 9999"  		    ,04         	,0           ,""       ,"??????????????°","N"     ,""     ,"R"         ,""            ,""           ,""      ,"A"      , ""               , ""        , ""        })
	AADD(aHeader2,  {    "INTERNO" 			,"RECNO"  		   	,"@E" 					,10          	,0           ,""       ,"??????????????°","N"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })

	oGetDados  := (MsNewGetDados():New( 094, 009, 190, 725,NIL ,"AlwaysTrue" ,"AlwaysTrue", /*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,"AllwaysTrue",/*superdel*/,/*delok*/,oDlg,aHeader,aCols))
	oGetDados2 := (MsNewGetDados():New( 210, 009, 351, 725, GD_INSERT+GD_DELETE+GD_UPDATE ,"U_fLinOk2" ,"AlwaysTrue" ,"AlwaysTrue",Nil,/*nfreeze*/,9999 ,"U_VldCpo","","AllwaysTrue",oDlg,aHeader2,aCols2))



	ACTIVATE MSDIALOG oDlg CENTERED


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMCEI    ºAutor  ³Microsiga           º Data ³  06/04/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MontaTela()
	Local cQuery:= ""
	Local lRet:= .F.
	Local nIni:= 1
	Local nFim:= 0

	cOpcoes:= CriaVar("B1_COD")
	oOpcoes:refresh()
	If Empty(cVar1) .or. Empty(cVar2)
		Return .T.
	EndIf

	If Select("QRY") > 0
		QRY->(dbCloseArea())
	Endif

	cQuery:= " SELECT *
	cQuery+= " FROM "+RETSQLNAME("SBQ")+" SBQ"
	cQuery+= " WHERE BQ_FILIAL = '"+xFilial("SBQ")+"' "
	cQuery+= " AND SBQ.D_E_L_E_T_ = '' "
	cQuery+= " AND BQ_BASE = '"+cVar1+cVar2+"' "
	cQuery+= " ORDER BY BQ_BASE,BQ_ITEM,BQ_ID "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)

	oGetDados:aCols := {}

	If !QRY->(eof())
		While QRY->(!eof())
			nFim+= QRY->BQ_TAMANHO
			AADD(oGetDados:aCols,Array(Len(oGetDados:aHeader)+1))
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_BASE" 	  	})] := QRY->BQ_BASE
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_ITEM"      	})] := QRY->BQ_ITEM
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_ID"   	  	})] := QRY->BQ_ID
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_CARACT"  	})] := QRY->BQ_CARACT
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_TAMANHO" 	})] := QRY->BQ_TAMANHO
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_MASCARA" 	})] := QRY->BQ_MASCARA
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_DESCR"   	})] := QRY->BQ_DESCR
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "PINI" 	  		})] := cValtochar(nIni+2)
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "PFIM"    	  	})] := cValtoChar(nFim+2)

			if !empty(cVar1) .and. !empty(cVar2)
				oGetDados:aCols[Len(oGetDados:aCols),Len(oGetDados:aHeader)+1 ] := .F.
			Else
				oGetDados:aCols[Len(oGetDados:aCols),Len(oGetDados:aHeader)+1 ] := .T.
			Endif
			nIni+= QRY->BQ_TAMANHO

			QRY->(DbSkip())
		EndDo
		lRet:= .T.
	Else
		AADD(oGetDados:aCols,Array(Len(oGetDados:aHeader)+1))
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_BASE" 	})] := ""
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_ITEM"   	})] := ""
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_ID"   	})] := ""
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_CARACT"  })] := ""
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_TAMANHO" })] := ""
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_MASCARA" })] := ""
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_DESCR"   })] := ""
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "PINI" 	  	})] := ""
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "PFIM"    	})] := ""
		oGetDados:aCols[Len(oGetDados:aCols),Len(oGetDados:aHeader)+1 ] := .F.
		lRet:= .f.

	EndIf

	oGetDados:Refresh()
	oGetDados2:Refresh()

	If Select("QRY") > 0
		QRY->(dbCloseArea())
	Endif

	If lRet
		MontaTela2()
	Else
		msgInfo("Base não identificada no cadastro","Aviso")

		cVar1:= Space(1)
		cVar2:= Space(1)

		A:Refresh()
		B:Refresh()

	Endif

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMCEI    ºAutor  ³Microsiga           º Data ³  06/04/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MontaTela2()
	Local cQuery:= ""


	If Select("QRY") > 0
		QRY->(dbCloseArea())
	Endif

	cQuery:= " SELECT ZZA_BASE,ZZA_PN,ZZA_DESCR,ZZA_QUANT,ZZA_TIPO,ZZA_QETQ1,ZZA_QETQ2,ZZA_EMB,ZZA_PSEMB,ZZA_CONTEU,ZZA_QTDVIA, "
	cQuery+= " R_E_C_N_O_,
	cQuery+= " ISNULL(CAST(CAST(ZZA_MREGRA AS VARBINARY(8000)) AS VARCHAR(8000)),'') ZZA_MREGRA
	cQuery+= " FROM "+RETSQLNAME("ZZA")+" ZZA"
	cQuery+= " WHERE ZZA_FILIAL = '"+xFilial("ZZA")+"' "
	cQuery+= " AND ZZA_BASE = '"+cVar1+cVar2+"' "
	IF U_VALIDACAO() //RODA 01/10/2021
		cQuery+= " AND (ZZA_PN LIKE '"+ALLTRIM(cOpcoes)+"%' "
		cQuery+= " OR ZZA_DESCR LIKE '"+ALLTRIM(cOpcoes)+"%') "
	ELSE
		cQuery+= " AND ZZA_PN LIKE '"+ALLTRIM(cOpcoes)+"%' "
	
	ENDIF



	cQuery+= " AND ZZA.D_E_L_E_T_ = '' "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)

	oGetDados2:aCols:={}

	If !QRY->(eof())
		While QRY->(!eof())
			AADD(oGetDados2:aCols,Array(Len(oGetDados2:aheader)+1))
			oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_BASE" 	})] := QRY->ZZA_BASE
			oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_TIPO"  	})] := QRY->ZZA_TIPO
			oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_PN"   	})] := QRY->ZZA_PN
			oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_DESCR" 	})] := QRY->ZZA_DESCR
//		oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_QUANT" 	})] := QRY->ZZA_QUANT
			oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_CONTEU" })] := QRY->ZZA_CONTEU
			oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_MREGRA" 	})] := QRY->ZZA_MREGRA
			oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_QETQ1" 	})] := QRY->ZZA_QETQ1
			oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_QETQ2" 	})] := QRY->ZZA_QETQ2
			oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_EMB"   	})] := QRY->ZZA_EMB
			oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_PSEMB" 	})] := QRY->ZZA_PSEMB
			oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_QTDVIA"    })] := QRY->ZZA_QTDVIA
			oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "RECNO"     	})] := QRY->R_E_C_N_O_
			oGetDados2:aCols[Len(oGetDados2:aCols),Len(oGetDados2:aheader)+1 ] := .F.
			QRY->(DbSkip())
		EndDo
	Else
		AADD(oGetDados2:aCols,Array(Len(oGetDados2:aheader)+1))
		oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_BASE" 	})] := cVar1+cVar2
		oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_TIPO"  })] := CriaVar("ZZA_TIPO" ,.F.)
		oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_PN"    })] := CriaVar("ZZA_PN"   ,.F.)
		oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_DESCR" })] := CriaVar("ZZA_DESCR",.F.)
//	oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_QUANT" })] := CriaVar("ZZA_QUANT",.F.)
		oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_CONTEU"})] := CriaVar("ZZA_CONTEU",.F.)
		oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_MREGRA" })] := CriaVar("ZZA_MREGRA",.F.)
		oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_QETQ1" })] := CriaVar("ZZA_QETQ1",.F.)
		oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_QETQ2" })] := CriaVar("ZZA_QETQ2",.F.)
		oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_EMB"   })] := CriaVar("ZZA_EMB"  ,.F.)
		oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_PSEMB" })] := CriaVar("ZZA_PSEMB",.F.)
		oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_QTDVIA"})] := CriaVar("ZZA_QTDVIA",.F.)
		oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "RECNO"     })] := 0
		oGetDados2:aCols[Len(oGetDados2:aCols),Len(oGetDados2:aheader)+1 ] := .F.
	EndIf

	oGetDados2:Refresh()
	oGetDados2:GoBottom()

	QRY->(dbCloseArea())

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMCEI    ºAutor  ³Microsiga           º Data ³  06/10/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VldCpo()

	Local lRetorno	:= .T.
	Local cRegrax	:= ""
	Private oError := ErrorBlock({|e| MsgAlert("Regra inválida: " +chr(10)+ e:Description)})

//Alltrim(oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_PN"  })] )

	oGetDados2:Refresh()

	IF !empty(cVar1) .and. !empty(cVar2)

		If ReadVar() == "M->ZZA_TIPO"
			IF  M->ZZA_TIPO == "2" //Alltrim(oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_TIPO"  })] ) == "2"
				aHeader[aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_PN" }),9]:=  "QDHSZV"
			Else
				aHeader[aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_PN" }),9]:=  "SB1"
			Endif
		/*
		cArqAux:= cGetFile( 'Arquivo TXT|*.txt| Arquivo XML|*.xml |Arquivo PDF|*.pdf |Todos arquivos|*.* ' ,; //[ cMascara],
		'Selecao de Arquivos',;                  //[ cTitulo],
		0,;                                      //[ nMascpadrao],
		'C:\TOTVS\',;                            //[ cDirinicial],
		.F.,;                                    //[ lSalvar],
		GETF_LOCALHARD  + GETF_NETWORKDRIVE,;    //[ nOpcoes],
		.T.)                                     //[ lArvore]
		oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_PN" })] := cArqAux
		oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_DESCR" })] := cArqAux
		oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_QUANT" })] := 1
		*/

		EndIf


		If ReadVar() == "M->ZZA_PN"
			cTipo := oGetDados2:aCols[oGetDados2:nat,aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_TIPO" })]
		
			
			If !EMPTY(M->ZZA_PN)
				If cTipo == "1"
					SB1->( DbSetorder(1) )
					If SB1->( DbSeek(xFilial("SB1")+M->ZZA_PN ))
						oGetDados2:aCols[oGetDados2:nat,aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_DESCR" })] := SB1->B1_DESC
						oGetDados2:Refresh()
			
					Else
						Alert( "Produto "+AllTrim(M->ZZA_PN)+" não existe! , verifique" )
						lRetorno	:= .F.
					EndIf

				ElseIf cTipo == "2"
					QDH->( DbSetorder(1) )
					If QDH->( DbSeek(xFilial("QDH")+ALLTRIM(M->ZZA_PN) ))
						oGetDados2:aCols[oGetDados2:nat,aScan(oGetDados2:aheader,{|aVet| Alltrim(aVet[2]) == "ZZA_DESCR" })] := QDH->QDH_TITULO
					Else
						Alert( "DOCUMENTO "+AllTrim(M->ZZA_PN)+" não existe! , verifique" )
						lRetorno	:= .F.
					EndIf

				EndIf
			Endif
		EndIf

		If ReadVar() == "M->ZZA_MREGRA"
			M->ZZA_MREGRA := EditRegr(Alltrim(M->ZZA_MREGRA))

			If !EMPTY(M->ZZA_MREGRA)
				Begin Sequence
					cRegraX := Alltrim(M->ZZA_MREGRA)
					cRegraX := StrTran( cRegraX, "#(", "SUBS(_CODIGO," )
					Validacao := &(Alltrim(cRegraX))

				End Sequence
				ErrorBlock(oError)
			Endif
			If Validacao == Nil
				lRetorno := .F.
			Else
				lRetorno := .T.
			EndIf
		EndIf

	Endif

	oGetDados2:Refresh()

Return lRetorno
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMCEI    ºAutor  ³Microsiga           º Data ³  06/14/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function fLinOk2()
	Local nPosTipo := GdFieldPos( "ZZA_TIPO"	)
	Local nPosCod  := GdFieldPos( "ZZA_PN" 	)
//Local nPosQtd  := GdFieldPos( "ZZA_QUANT"	)
	Local nPosQtd  := GdFieldPos( "ZZA_CONTEU"	)
	Local nPosRegra:= GdFieldPos( "ZZA_MREGRA"	)
	Local lRetorno	:= .T.

//For _i := 1 To Len(oGetDados2:aCols)-1

	If !oGetDados2:aCols[oGetDados2:nat,len(oGetDados2:aheader)+1]
		if Empty(oGetDados2:aCols [oGetDados2:nat,nPosTipo]) .Or. Empty(oGetDados2:aCols [oGetDados2:nat,nPosCod]).or. Empty(oGetDados2:aCols [oGetDados2:nat,nPosQtd])   .or. Empty(oGetDados2:aCols [oGetDados2:nat,nPosRegra])

			_cCpo:=""
			If Empty(oGetDados2:aCols [oGetDados2:nat,nPosTipo])
				_cCpo+= "*** Tipo ***"+ chr(13)+chr(10)
			Endif
			If Empty(oGetDados2:aCols [oGetDados2:nat,nPosCod])
				_cCpo+= "*** Código Produto ***"+ chr(13)+chr(10)
			Endif
			If Empty(oGetDados2:aCols [oGetDados2:nat,nPosQtd])
				_cCpo+= "*** Quantidade ***"+ chr(13)+chr(10)
			Endif
			If Empty(oGetDados2:aCols [oGetDados2:nat,nPosRegra])
				_cCpo+= "*** Regra ***"+ chr(13)+chr(10)
			Endif

			MsgInfo( "Informe o(s) campo(s):" + chr(13)+chr(10)+ _cCpo,"Cadastro Incompleto")
			lRetorno	:= .F.

		Endif
		oGetDados2:Refresh()
	Endif
//Next

Return lRetorno
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMCEI    ºAutor  ³Microsiga           º Data ³  06/10/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fVldVar()

	Local lRetorno	:= .T.
	Local _y
	_Codigo := cVar1
	_Codigo+= cVar2
	_Codigo+= cVar3
	_Codigo+= cVar4
	_Codigo+= cVar5
	_Codigo+= cVar6
	_Codigo+= cVar7
	_Codigo+= cVar8
	_Codigo+= cVar9
	_Codigo+= cVar10
	_Codigo+= cVar11
	_Codigo+= cVar12
	_Codigo+= cVar13
	_Codigo+= cVar14
	_Codigo+= cVar15

	For _y := 1 to Len(oGetDados:aCols)

		_nPosIni:= val(oGetDados:aCols[_y,aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2])== "PINI"})])
		_nPosFim:= val(oGetDados:aCols[_y,aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2])== "PFIM"})])

		_nTam:= oGetDados:aCols[_y,aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2])== "BQ_TAMANHO"})]
		_cVldVar:= alltrim(Substring(_Codigo,_nPosIni,_nTam))

		if !empty(_cVldVar) .and. len(_cVldVar) == _nTam
			dbSelectArea("SBS")
			dBSetOrder(1)//BS_FILIAL, BS_BASE, BS_ID, BS_CODIGO
			IF !dbSeek(xFilial("SBS")+PADR(cVar1+cVar2,TAMSX3("BQ_BASE")[1])+PADR(strzero(_y,2),TAMSX3("BQ_ID")[1])+PADR(_cVldVar,TAMSX3("BS_CODIGO")[1]))
				MsgInfo("Codigo não encontrado!"+CHR(13)+CHR(10)+"Verifique a posição "+cValtoChar(_nPosIni)+ " até  "+cValtoChar(_nPosFim) ,"Aviso!")
				lRetorno:= .F.
				fListOpc(_Codigo,PADR(strzero(_y,2),TAMSX3("BQ_ID")[1]),_nPosIni,_nTam)

			Endif
		Endif
	Next

	oGetDados2:Refresh()

Return lRetorno
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMCEI    ºAutor  ³Microsiga           º Data ³  06/14/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
Static Function fListOpc(_Codigo,cId,nPosIni,nTam)

	Local oDlg2     := Nil
	Local cTitulo  := ""
	Local cCabec   := ""
	Local	_CVARTEMP:= ""
	Local x

	Private lChk     := .F.
	Private oLbx := Nil
	Private aVetor := {}
	Private aFiles:={}
	cBase:= PADR(Substring(_Codigo,1,2),TAMSX3("BQ_BASE")[1])

	dbselectArea("SBQ")
	DbSetOrder(2)
	dbSeek(xFilial("SBQ")+cBase + cId)
	cTitulo:= SBQ->BQ_CARACT

	dbselectArea("SBS")
	DbSetOrder(1)
	IF dbSeek(xFilial("SBS")+cBase + cId)
		While SBS->(!eof()) .AND. SBS->(BS_BASE+BS_ID) == cBase+cId
			aadd(aFiles,{SBS->BS_CODIGO,SBS->BS_DESCR, SBS->BS_DESCPRD })
			SBS->(dbSkip())
		Enddo
	Endif


	For x :=1 to len(aFiles)
		aAdd( aVetor, {aFiles[x][1],aFiles[x][2],aFiles[x][3]})
	next

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+
	If Len(aVetor ) == 0
		MsgInfo( "Nao encontramos dados para a pesquisa ",cTitulo )
		Return(aFiles)
	Endif

	DEFINE MSDIALOG oDlg2 TITLE cTitulo FROM 0,0 TO 240,500 PIXEL

	@ 10,10 LISTBOX oLbx VAR cCabec FIELDS HEADER " ", "Código","Descrição","Descr.Prod" SIZES {02,14,25,25} ;
		SIZE 230,095 OF oDlg2 PIXEL ON dblClick(_cVarTemp:= aVetor[oLbx:nAt,1],Odlg2:end())	//(aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1],oLbx:Refresh())

	oLbx:SetArray( aVetor )
	oLbx:bLine := {|| {aVetor[oLbx:nAt,1],aVetor[oLbx:nAt,2],aVetor[oLbx:nAt,3]}}

//+----------------------------------------------------------------
//| Para marcar e desmarcar todos existem duas opçoes, acompanhe...
//+----------------------------------------------------------------
//| Chamando uma funcao própria
//+----------------------------------------------------------------
/*If oChk <> NIL
@ 110,10 CHECKBOX oChk VAR lChk PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oDlg2;
ON CLICK(Iif(lChk,Marca(lChk),Marca(lChk)))
Endif
//+----------------------------------------------------------------
//| Utilizando Eval()
//+----------------------------------------------------------------
@ 110,10 CHECKBOX oChk VAR lChk PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oDlg2 ;
ON CLICK(aEval(aVetor,{|x| x[1]:=lChk}),oLbx:Refresh())*/

//DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION oDlg2:End() ENABLE OF oDlg2
ACTIVATE MSDIALOG oDlg2 CENTER

aFiles:= {}
_cBase:= SubsTring(_Codigo,1,nPosIni-1) + alltrim(_cVarTemp) + SubsTring(_Codigo,nPosIni+nTam,(len(_Codigo)))

cVar1 := SubsTring(_cBase,1 ,1)
cVar2 := SubsTring(_cBase,2 ,1)
cVar3 := SubsTring(_cBase,3 ,1)
cVar4 := SubsTring(_cBase,4 ,1)
cVar5 := SubsTring(_cBase,5 ,1)
cVar6 := SubsTring(_cBase,6 ,1)
cVar7 := SubsTring(_cBase,7 ,1)
cVar8 := SubsTring(_cBase,8 ,1)
cVar9 := SubsTring(_cBase,9 ,1)
cVar10:= SubsTring(_cBase,10,1)
cVar11:= SubsTring(_cBase,11,1)
cVar12:= SubsTring(_cBase,12,1)
cVar13:= SubsTring(_cBase,13,1)
cVar14:= SubsTring(_cBase,14,1)
cVar15:= SubsTring(_cBase,15,1)

A:Refresh()
B:Refresh()
C:Refresh()
D:Refresh()
E:Refresh()
F:Refresh()
G:Refresh()
H:Refresh()
I:Refresh()
J:Refresh()
K:Refresh()
L:Refresh()
M:Refresh()
N:Refresh()
O:Refresh()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMCEI    ºAutor  ³Microsiga           º Data ³  06/14/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function fGrvRegra()
Local _x
	dbSelectArea("ZZA")
	For _x := 1 To Len (oGetdados2:aCols)
		If oGetdados2:aCols[_x,LEN(oGetdados2:aHeader)+1]
			If !Empty(oGetdados2:aCols[_x,aScan(oGetDados2:aHeader,{|aVet| Alltrim(aVet[2])== "RECNO"}) ])
				ZZA->( dbGoTo(oGetdados2:aCols[_x,aScan(oGetDados2:aHeader,{|aVet| Alltrim(aVet[2])== "RECNO"})]) )
				If ZZA->( Recno() ) == oGetdados2:aCols[_x,aScan(oGetDados2:aHeader,{|aVet| Alltrim(aVet[2])== "RECNO"}) ]
					RecLock("ZZA",.F.)
					ZZA->( dbDelete() )
					ZZA->( msUnlock() )
				EndIf
			Endif
		Else
			If Empty(oGetdados2:aCols[_x,aScan(oGetDados2:aHeader,{|aVet| Alltrim(aVet[2])== "RECNO"})])
				RecLock("ZZA",.T.)
				ZZA->ZZA_FILIAL := xFilial("ZZA")
				ZZA->ZZA_BASE 	 := oGetdados2:aCols[_x,1]
				ZZA->ZZA_TIPO	 := oGetdados2:aCols[_x,2]
				ZZA->ZZA_PN	     := oGetdados2:aCols[_x,3]
				ZZA->ZZA_DESCR	 := oGetdados2:aCols[_x,4]
//			ZZA->ZZA_QUANT	 := oGetdados2:aCols[_x,5] 
				ZZA->ZZA_CONTEU  := oGetdados2:aCols[_x,5]
				ZZA->ZZA_MREGRA  := oGetdados2:aCols[_x,6]
				ZZA->ZZA_MREGRA  := oGetdados2:aCols[_x,6]
				ZZA->ZZA_QETQ1	 := oGetdados2:aCols[_x,7]
				ZZA->ZZA_QETQ2   := oGetdados2:aCols[_x,8]
				ZZA->ZZA_EMB     := oGetdados2:aCols[_x,9]
				ZZA->ZZA_PSEMB   := oGetdados2:aCols[_x,10]
				ZZA->ZZA_QTDVIA  := oGetdados2:aCols[_x,11]
				ZZA->( MsUnlock() )

				oGetdados2:aCols[_x,aScan(oGetDados2:aHeader,{|aVet| Alltrim(aVet[2])== "RECNO"}) ] := ZZA->( Recno() )
			Else
				ZZA->( dbGoTo(oGetdados2:aCols[_x,aScan(oGetDados2:aHeader,{|aVet| Alltrim(aVet[2])== "RECNO"}) ]) )
				If ZZA->( Recno() ) == oGetdados2:aCols[_x,aScan(oGetDados2:aHeader,{|aVet| Alltrim(aVet[2])== "RECNO"}) ]
					RecLock("ZZA",.F.)
					ZZA->ZZA_FILIAL	:= xFilial("ZZA")
					ZZA->ZZA_BASE  	:= oGetdados2:aCols[_x,1]
					ZZA->ZZA_TIPO  	:= oGetdados2:aCols[_x,2]
					ZZA->ZZA_PN	      	:= oGetdados2:aCols[_x,3]
					ZZA->ZZA_DESCR  	:= oGetdados2:aCols[_x,4]
//				ZZA->ZZA_QUANT 		:= oGetdados2:aCols[_x,5]
					ZZA->ZZA_CONTEU 	:= oGetdados2:aCols[_x,5]
					ZZA->ZZA_MREGRA     := oGetdados2:aCols[_x,6]
					ZZA->ZZA_MREGRA     := oGetdados2:aCols[_x,6]
					ZZA->ZZA_QETQ1	 	:= oGetdados2:aCols[_x,7]
					ZZA->ZZA_QETQ2  	:= oGetdados2:aCols[_x,8]
					ZZA->ZZA_EMB    	:= oGetdados2:aCols[_x,9]
					ZZA->ZZA_PSEMB  	:= oGetdados2:aCols[_x,10]
					ZZA->ZZA_QTDVIA 	:= oGetdados2:aCols[_x,11]
					ZZA->( MsUnlock() )
				EndIf

			EndIf
		Endif
	Next

	MsgInfo("Regra cadastrada com sucesso!", "Aviso")

Return


/*/{Protheus.doc} fVldEstrut
(long_description)
@type  Static Function
@author user
@since date
@version version
@param param, param_type, param_descr           
@return return, return_type, return_description
@example
(examples)
@see (links_or_references)
/*
Static Function fVldEstrut()

Local cQuery 	:= ""
Local aEstrut 	:= {}
Local aDocs		:= {}
Local aRegras 	:= {}
Local nPos		:= 0
Local lGrava	:= .T.
Local oDlg3     := Nil
Local cTitulo  := "validação de estrutura"
Local cCabec	:= ""
Local oLbx2		:= Nil

dbSelectArea("SG1")
dbSetOrder(1) // G1_FILIAL, G1_COD, G1_COMP
dbSeek(xFilial("SG1")+_CODIGO)
While SG1->(!eOF()) .and. SG1->G1_COD == _CODIGO
	aAdd(aEstrut,{SG1->G1_COMP, SG1->G1_QUANT,SG1->G1_XXQTET1,SG1->G1_XXQTET2,SG1->G1_XXEMBNI,SG1->G1_XPESEMB,"",0,0,0,"","",""})
	SG1->(DbSkip())
End

dbSelectArea("SZV")
dbSetOrder(2) // ZV_FILIAL, ZV_CHAVE, ZV_ARQUIVO
dbSeek(xFilial("SZV")+_CODIGO)
While SZV->(!eOF()) .and. SZV->ZV_CHAVE == _CODIGO
	aAdd(aDocs,{SZV->ZV_ARQUIVO,"",""})
	SZV->(DbSkip())
End

If Select("QRY2") > 0
	QRY2->(dbCloseArea())
Endif
cQuery:= " SELECT ZZA_BASE,ZZA_PN,ZZA_DESCR,ZZA_QUANT,ZZA_TIPO,ZZA_QETQ1,ZZA_QETQ2,ZZA_EMB,ZZA_PSEMB,ZZA_CONTEU, R_E_C_N_O_,
cQuery+= " ISNULL(CAST(CAST(ZZA_MREGRA AS VARBINARY(8000)) AS VARCHAR(8000)),'') ZZA_MREGRA
cQuery+= " FROM ZZA010
cQuery+= " WHERE ZZA_BASE = '"+Substring(_CODIGO,1,2)+"'"
cQuery+= " AND D_E_L_E_T_ = ''
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY2",.T.,.T.)

If !QRY2->(eof())
	While QRY2->(!eof())
		aAdd(aRegras,{QRY2->ZZA_TIPO ,QRY2->ZZA_PN , QRY2->ZZA_CONTEU , QRY2->ZZA_REGRA , QRY2->ZZA_QETQ1 , QRY2->ZZA_QETQ2 , QRY2->ZZA_EMB , QRY2->ZZA_PSEMB})
		QRY2->(DbSkip())
	End
Else
	msgAlert("Não foi encontrada nenhuma regra para a base " + Substring(_CODIGO,1,2) ,"Aviso")
	Return
EndIf

For _i:= 1 to len(aRegras)   
	cRegra := StrTran( aRegras[_i,4], "#(", "SUBS(_CODIGO," ) 
	lGrava := &(Alltrim(cRegra))
	If lGrava
		if aRegras[_i,1] == "1"
			nPos:= aScan(aEstrut,{|aVet| aVet[1] == aRegras[_i,2] })
			IF nPos > 0
				aEstrut[nPos,7]:= aRegras[_i,2]
				aEstrut[nPos,8]:= aRegras[_i,3]
				aEstrut[nPos,9]:= aRegras[_i,5]
				aEstrut[nPos,10]:= aRegras[_i,6]
				aEstrut[nPos,11]:= aRegras[_i,7]
				aEstrut[nPos,12]:= aRegras[_i,8]
			Else
				aAdd(aEstrut,{"",0,0,0,"","",aRegras[_i,2],aRegras[_i,3],aRegras[_i,5],aRegras[_i,6],aRegras[_i,7],aRegras[_i,8],""})
			Endif
		Else
			nPos:= aScan(aDocs,{|aVet| aVet[1] == aRegras[_i,2] })
			IF nPos > 0
				aDocs[nPos,2]:= aRegras[_i,2]
			Else
				aAdd(aDocs,{"",aRegras[_i,2],""})
			Endif
		EndIf
	Endif
next _i

For _y :=1 to len (aEstrut)
	If !Empty(alltrim(aEstrut[_y,1]))
		aEstrut[_y,5]:= aEstrut[_y,1]
	ElseIf !Empty(alltrim(aEstrut[_y,3]))
		aEstrut[_y,5]:= aEstrut[_y,3]
	Endif
Next _y


For _y :=1 to len (aDocs)
	If !Empty(alltrim(aDocs[_y,1]))
		aDocs[_y,3]:= aDocs[_y,1]
	ElseIf !Empty(alltrim(aDocs[_y,2]))
		aDocs[_y,3]:= aDocs[_y,2]
	Endif
Next _y


ASORT(aEstrut,,,{ | x,y | x[5] < y[5] } )
ASORT(aDocs,,,{ | x,y | x[3] < y[3] } )

if len(aEstrut)> 0
	DEFINE MSDIALOG oDlg3 TITLE cTitulo FROM 0,0 TO 240,500 PIXEL
	@ 10,10 LISTBOX oLbx2 VAR cCabec FIELDS HEADER "Cód.SG1","Qtd.SG1","Etq1.SG1","Etq2.SG1","Nivel SG1","Cód.ZZA","Qtd.ZZA","Etq1.ZZA","Etq2.ZZA","Nivel ZZA","Comparação"; //SIZES {02,14,25,25} ;
	SIZE 230,095 OF oDlg3 PIXEL
	oLbx2:SetArray( aEstrut )
	oLbx2:bLine := {|| {aEstrut[oLbx2:nAt,1],;
	aEstrut[oLbx2:nAt,2],;
	aEstrut[oLbx2:nAt,3],;
	aEstrut[oLbx2:nAt,4],;
	aEstrut[oLbx2:nAt,5],;
	aEstrut[oLbx2:nAt,7],;
	aEstrut[oLbx2:nAt,8],;
	aEstrut[oLbx2:nAt,9],;
	aEstrut[oLbx2:nAt,10],;
	aEstrut[oLbx2:nAt,11],;
	aEstrut[oLbx2:nAt,12]}}
	ACTIVATE MSDIALOG oDlg3 CENTER
Else
	MsgAlert("Não há dados para consulta","Aviso")
Endif
Return
*/
Static Function EditRegr(cVar)
Local oButton1
Local oButton2
Local oButton3
Local oButton4
Local oButton5
Local oButton6
Local oButton7
Local oButton8
Local oButton10
Local oButton11

Local oFont1 := TFont():New("Arial Narrow",,023,,.F.,,,,,.F.,.F.)
Local oFont2 := TFont():New("Arial",,020,,.T.,,,,,.F.,.F.)
Local oGet2
Local oGet3
Local oGet4
Local cGet1 := cVar
Local cGet2 := Space(1)
Local cGet3 := Space(1)
Local cGet4 := Space(4)
Local oSay1
Local oSay2
Static oDlg4

  DEFINE MSDIALOG oDlg4 TITLE "Regra" FROM 000, 000  TO 320, 800 COLORS 0, 16777215 PIXEL
	
	@ 005, 014 SAY 	 oSay1    PROMPT "REGRA" SIZE 044, 010 OF oDlg4 FONT oFont2 COLORS 8388608, 16777215 PIXEL
   	@ 020, 008 GET oMultiGe1 VAR cGet1 OF oDlg4 MULTILINE SIZE 328, 120 COLORS 0, 16777215  FONT oFont1 HSCROLL PIXEL

	@ 005, 348 SAY oSay2   PROMPT "Variaveis" SIZE 050, 010 OF oDlg4 FONT oFont2 COLORS 8388608, 16777215 PIXEL
   	@ 015, 348 MSGET oGet2 VAR cGet2 SIZE 010, 013 OF oDlg4 COLORS 0, 16777215 FONT oFont1 PIXEL
    @ 015, 378 MSGET oGet3 VAR cGet3 SIZE 010, 013 OF oDlg4 COLORS 0, 16777215 FONT oFont1 PIXEL

	@ 125, 370 MSGET oGet4 VAR cGet4 SIZE 020, 012 OF oDlg4 COLORS 0, 16777215 FONT oFont1 PIXEL
	
	@ 035, 348 BUTTON oButton1 PROMPT "#( , )" 			SIZE 046, 012 OF oDlg4 action(cGet1:= cGet1+" #("+cGet2+","+cGet3+")") FONT oFont2 PIXEL
    @ 050, 348 BUTTON oButton2 PROMPT ".AND. #( , )"	SIZE 046, 012 OF oDlg4 action(cGet1:= cGet1+" .AND. #("+cGet2+","+cGet3+")")  FONT oFont2 PIXEL
    @ 065, 348 BUTTON oButton3 PROMPT ".OR. #( , )" 	SIZE 046, 012 OF oDlg4 action(cGet1:= cGet1+" .OR. #("+cGet2+","+cGet3+")")  FONT oFont2 PIXEL
    @ 080, 348 BUTTON oButton4 PROMPT "==" 				SIZE 018, 012 OF oDlg4 action(cGet1:= cGet1+"==") FONT oFont2 PIXEL
    @ 080, 378 BUTTON oButton5 PROMPT "<>" 				SIZE 017, 012 OF oDlg4 action(cGet1:= cGet1+"<>") FONT oFont2 PIXEL
    @ 095, 348 BUTTON oButton6 PROMPT ">=" 				SIZE 018, 012 OF oDlg4 action(cGet1:= cGet1+">=") FONT oFont2 PIXEL
    @ 095, 378 BUTTON oButton7 PROMPT "<=" 				SIZE 017, 012 OF oDlg4 action(cGet1:= cGet1+"<=") FONT oFont2 PIXEL
    @ 110, 348 BUTTON oButton8 PROMPT ">" 				SIZE 018, 012 OF oDlg4 action(cGet1:= cGet1+">") FONT oFont2 PIXEL
    @ 110, 378 BUTTON oButton9 PROMPT "<" 				SIZE 017, 012 OF oDlg4 action(cGet1:= cGet1+"<") FONT oFont2 PIXEL
	@ 125, 348 BUTTON oButton10 PROMPT "''" 			SIZE 017, 012 OF oDlg4 action(cGet1:=cGet1+"'"+alltrim(cGet4)+"'") FONT oFont2 PIXEL
	@ 142, 348 BUTTON oButton11 PROMPT "SALVAR" 	    SIZE 046, 012 OF oDlg4 action(oDlg4:end()) FONT oFont2 PIXEL
    
  ACTIVATE MSDIALOG oDlg4 CENTERED
  
  Return cGet1

*/

