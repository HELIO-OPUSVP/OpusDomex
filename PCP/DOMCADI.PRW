#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'Protheus.ch'
#INCLUDE 'FWMVCDef.ch'

//--------------------------------------------------------------
/*/{Protheus.doc} DOMCADI
Description

@param xParam Parameter Description
@return xRet Return Description
@author  -
@since 13/08/2020
/*/
//--------------------------------------------------------------
User Function DOMCADI()
Private oButton1
Private oButton2
Private oComboBo1
Private cComboBo1 := ""
Private oComboBo2
Private cComboBo2 := ""
Private oFont1 := TFont():New("Arial Narrow",,022,,.T.,,,,,.F.,.F.)
Private oFont2 := TFont():New("Arial Narrow",,020,,.T.,,,,,.F.,.F.)
Private oFont3 := TFont():New("Arial",,018,,.F.,,,,,.F.,.F.)
Private oFont10 := TFont():New("Arial Black",,040,,.T.,,,,,.F.,.F.)
Private oFont4 := TFont():New("MS Sans Serif",,018,,.T.,,,,,.F.,.F.)
Private oDesc
Private cDesc := criaVar("B1_DESC")
Private cCodNew:= criaVar("B1_DESC")
Private oGroup1
Private oGroup2
Private oDescDet
Private cDescDet := space(400)
Private oSay
Private oSay1
Private oSay2
Private oSay3
Private aItensFam:= {}
Private aOpcFil:= {"1-Opções","2-Código da Opcão","3-Código do Produto"}
Private oOk      := LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
Private oNo      := LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
Private oLegOk   := LoadBitmap( GetResources(), "BR_VERDE" )
Private OLegNo   := LoadBitmap( GetResources(), "BR_VERMELHO" )
Private cBase    := ""
Private cId      := ""
Private cCodBs   := ""
Private cCodigo  := ""
Private nTam	 := 0
Private c2Leg1      := "1"
Private n2Leg1      := RGB(176,224,230)
Private c2Leg2      := "2"
Private n2Leg2      := RGB(248,248,255)
Private aCodigo		:= {}
Private oCodigo
Private cGrupo		:= ""
Private lEnd := .F.
Private oDlg
private cOpcoes:= space(30)
Private oOpcoes


DEFAULT ALTERA:= NIL
DEFINE MSDIALOG oDlg TITLE "Cadastro de Produtos" FROM 000, 000  TO 650, 1200 COLORS 0, 16777215 PIXEL

MsAguarde({|lEnd| fFamilia()},"Aguarde...","Processando",.T.)
//FWMsgRun( , {|lEnd| fFamilia()},"Aguarde...","Processando")

@ 004, 007 GROUP oGroup1 TO 043, 140 OF oDlg COLOR 0, 16777215 PIXEL
@ 011, 017 SAY oSay1 PROMPT "Família" SIZE 050, 013 OF oDlg FONT oFont4 COLORS 0, 16777215 PIXEL
@ 023, 016 MSCOMBOBOX oComboBo1 VAR cComboBo1 ITEMS aItensFam valid(MsgRun("Carregando Dados, aguarde...",,{|| fMSNewGe1() })) SIZE 105, 012 OF oDlg COLORS 0, 16777215 FONT oFont3 PIXEL

@ 005, 205 MSCOMBOBOX oComboBo2 VAR cComboBo2 ITEMS aOpcFil  SIZE 80, 10 OF oDlg COLORS 0, 16777215 FONT oFont4 PIXEL
@ 004, 153 GROUP oGroup1 TO 043, 291  OF oDlg COLOR 0, 16777215 PIXEL
@ 007, 160 SAY oSay2 PROMPT "Pesquisar" SIZE 120, 013 OF oDlg FONT oFont4 COLORS 0, 16777215 PIXEL
@ 015, 160 MSGET oOpcoes VAR cOpcoes SIZE 125, 022 OF oDlg   COLORS 0, 16777215 FONT oFont3 PIXEL  valid(fMSNewGe2())


@ 004, 300 GROUP oGroup2 TO 043, 593  OF oDlg COLOR 0, 16777215 PIXEL
@ 007, 310 SAY oSay2 PROMPT "Código" SIZE 050, 013 OF oDlg FONT oFont4 COLORS 0, 16777215 PIXEL
@ 015, 310 MSGET oCodigo VAR cCodigo SIZE 270, 022 OF oDlg   COLORS 0, 16777215 FONT oFont10 PIXEL When .F. //valid(fMark3(1)) //When .F.

@ 245, 007 SAY oSay2 PROMPT "Descrição" SIZE 100, 015 OF oDlg FONT oFont4 COLORS 0, 16777215 PIXEL
@ 245, 049 MSGET oDesc VAR cDesc SIZE 450, 012 OF oDlg COLORS 0, 16777215 FONT oFont3 PIXEL When .F.

@ 260, 006 SAY oSay3 PROMPT "Descrição Detalhada" SIZE 121, 015 OF oDlg FONT oFont4 COLORS 0, 16777215 PIXEL
@ 270, 006 GET oDescDet VAR cDescDet OF oDlg MULTILINE SIZE 500, 035 COLORS 0, 16777215 HSCROLL PIXEL When .F.

@ 250, 520 BUTTON oButton1 PROMPT "Confirmar" ACTION FWMsgRun(, {|oSay| if (U_m010IncR(oSay), fMSNewGe1(),"")  }, "Processando...", "Processando Inclusão" ) SIZE 060, 026 OF oDlg PIXEL
@ 280, 520 BUTTON oButton2 PROMPT "Fechar" ACTION (oDlg:end()) SIZE 060, 026 OF oDlg PIXEL

aHeader := {}
aCols 	 := {}
aAdd(aHeader, {" "                ,"BQ_FLAG"    ,"@BMP"     ,01,0,"","??????????????" ,"C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
AADD(aHeader, {"ID"               ,"BQ_ID"      ,"@R" 		,05,0,"","??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
AADD(aHeader, {"Características"  ,"BQ_CARACT"  ,"@R" 		,25,0,"","??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
AADD(aHeader, {"Tam"  			  ,"BQ_TAMANHO" ,"@E 99999" ,05,0,"","??????????????°","N"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
AADD(aHeader, {"Descrição"        ,"BP_DESCR"   ,"@R " 		,20,0,"","??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
AADD(aHeader, {""	 			  ,"COR"   	    ,"@R"	    ,01,0,"","??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })

aHeader2 := {}
aCols2   := {}
aAdd(aHeader2, {" "                ,"BS_FLAG"     ,"@BMP"   ,01,0,"","?????????????"  ,"C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
AADD(aHeader2, {"Opções"           ,"BS_DESCR" 	  ,"@R " 	,25,0,"","??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
AADD(aHeader2, {"Código"           ,"BS_CODIGO"   ,"@R " 	,14,0,"","??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
AADD(aHeader2, {"Descrição"        ,"BS_DESCPRD"  ,"@R " 	,20,0,"","??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
AADD(aHeader2, {"Descr.Detalhada"  ,"BS_XDESC"    ,"@R " 	,20,0,"","??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
AADD(aHeader2, {""	 	           ,"COR"         ,"@R"     ,01,0,"","??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })


aHeader3 := {}
aCols3   := {}
aAdd(aHeader3, {" "                ,"B1_FLAG"   ,"@BMP"     ,01,0,"","?????????????"  ,"C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
AADD(aHeader3, {"Código Produto"   ,"B1_COD"    ,"@R" 		,15,0,"","??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
AADD(aHeader3, {"Descrição"        ,"B1_DESC" 	,"@R " 		,60,0,"","??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
AADD(aHeader3, {""	 	           ,"COR"       ,"@R"       ,01,0,"","??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })


oGetDados := MsNewGetDados():New( 045, 007, 240, 147,NIL ,"AlwaysTrue" ,"AlwaysTrue", /*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*VldCpo*/,/*superdel*/,/*delok*/,oDlg,aHeader, aCols)
oGetDados:oBrowse:lUseDefaultColors := .F.
oGetDados:oBrowse:SetBlkBackColor({|| CorGd01(@oGetDados)})
oGetDados:oBrowse:bChange := { ||fChange(@oGetDados)  }

//IIf(oGetDados:aCols[oGetDados:nAt,1]== oNo,fMark1(1),fMark1(2))

oGetDados2 := MsNewGetDados():New(045, 153, 240, 293,NIL ,"AlwaysTrue" ,"AlwaysTrue", /*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*VldCpo*/,/*superdel*/,/*delok*/,oDlg, aHeader2, aCols2)
oGetDados2:oBrowse:lUseDefaultColors := .F.
oGetDados2:oBrowse:SetBlkBackColor({|| CorGd01(@oGetDados2)})
oGetDados2:oBrowse:bLDblClick := { ||  IIf(oGetDados2:aCols[oGetDados2:nAt,1]== oNo,fMark2(1),fMark2(2)) }

oGetDados3 := MsNewGetDados():New( 045, 300, 240, 593,NIL ,"AlwaysTrue" ,"AlwaysTrue", /*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*VldCpo*/,/*superdel*/,/*delok*/,oDlg, aHeader3, aCols3)
oGetDados3:oBrowse:lUseDefaultColors := .F.
oGetDados3:oBrowse:SetBlkBackColor({|| CorGd01(@oGetDados3)})
oGetDados3:oBrowse:bLDblClick := { ||  IIf(oGetDados3:aCols[oGetDados3:nAt,1]== oNo,fMark3(1),fMark3(2)) }

if len(aCodigo) == 0
	MsgRun("Carregando Dados GRID 1, aguarde...",,{|| fMSNewGe1() })
	//	MsgRun("Carregando Dados GRID 2, aguarde...",,{|| fMSNewGe2() })
Endif

ACTIVATE MSDIALOG oDlg CENTERED

Return
//------------------------------------------------
Static Function fFamilia()
//------------------------------------------------
dbSelectArea("SBP")
SBP->(dbSetOrder(1))
SBP->(DbGotop())

Aadd(aItensFam, "")

While SBP->(!eof())
	
	If lEnd
		MsgInfo(cCancel,"Fim")
		Exit
	Endif
	MsProcTxt("Buscando Famílias: "+ ALLTRIM(SBP->BP_DESCR))
	ProcessMessage()
	
	Aadd(aItensFam, ALLTRIM(SBP->BP_BASE) +" - "+ALLTRIM(SBP->BP_DESCR))
	SBP->(DbSkip())
End
cID:= ""
cBase:= ""
cCodBs:= ""
aCodigo:= {}
cCodigo:= SBP->BP_BASE

Return


//------------------------------------------------
Static Function fMSNewGe1()
//------------------------------------------------
Local cQuery:= ""
Local lRet:= .F.

If Empty(cComboBo1)
	oGetDados:aCols:= {}
	AADD(oGetDados:aCols,Array(Len(oGetDados:aHeader)+1))
	oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_FLAG"  	})] := ""
	oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_ID"  	    })] := ""
	oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_CARACT"  })] := ""
	oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_TAMANHO"  	})] := 0
	oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BP_DESCR"   	})] := ""
	oGetDados:aCols[Len(oGetDados:aCols),Len(oGetDados:aHeader)+1 ] := .F.
	oGetDados:Refresh()
	Return .T.
EndIf

cBase:= SUBSTRING(cComboBo1,1,2)
cGrupo:= ALLTRIM(SBP->BP_DESCR)
cID:= ""
cCodBs:= ""
aCodigo:= {}
cCodigo:= SBP->BP_BASE
If Select("QRY") > 0
	QRY->(dbCloseArea())
Endif

cQuery:= " SELECT *
cQuery+= " FROM "+RETSQLNAME("SBQ")+" SBQ"
cQuery+= " INNER JOIN "+RETSQLNAME("SBP")+" SBP ON BP_BASE = BQ_BASE AND SBP.D_E_L_E_T_ = ''
cQuery+= " WHERE BQ_FILIAL = '"+xFilial("SBQ")+"' "
cQuery+= " AND SBQ.D_E_L_E_T_ = '' "
cQuery+= " AND BQ_BASE = '"+cBase+"' "
cQuery+= " ORDER BY BQ_BASE,BQ_ITEM,BQ_ID "
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)

oGetDados:aCols := {}

If !QRY->(eof())
	While QRY->(!eof())
		
		AADD(oGetDados:aCols,Array(Len(oGetDados:aHeader)+1))
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_FLAG"  	})] := oNo
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_ID"  	    })] := QRY->BQ_ID
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_CARACT"  	})] := QRY->BQ_CARACT
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_TAMANHO"  	})] := QRY->BQ_TAMANHO
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BP_DESCR"   	})] := QRY->BP_DESCR
		
		
		oGetDados:aCols[Len(oGetDados:aCols),Len(oGetDados:aHeader)+1 ] := .F.
		QRY->(DbSkip())
	EndDo
	lRet:= .T.
Else
	AADD(oGetDados:aCols,Array(Len(oGetDados:aHeader)+1))
	oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_FLAG"  	})] := oNo
	oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_ID"  	    })] := ""
	oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_CARACT"  })] := ""
	oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_TAMANHO"  	})] := 0
	oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BP_DESCR"   	})] := ""
	oGetDados:aCols[Len(oGetDados:aCols),Len(oGetDados:aHeader)+1 ] := .F.
	lRet:= .f.
EndIf

cCodigo:= cBase
oCodigo:refresh()
cDesc := ""
cDescDet:= ""
oDesc:Refresh()
oDescDet:Refresh()
oGetDados:Refresh()
oGetDados2:Refresh()
fChange(@oGetDados)
Odlg:Refresh()

If Select("QRY") > 0
	QRY->(dbCloseArea())
Endif

If lRet
	MsgRun("Carregando Dados GRID 2, aguarde...",,{|| fMSNewGe2() })
	//	MsgRun("Carregando Dados GRID 3, aguarde...",,{|| fMSNewGe3() })
Endif

Return

//------------------------------------------------
Static Function fMSNewGe2()
//------------------------------------------------
Local cQuery:= ""
Local lRet:= .F.
local _x
Local _i

if empty(cComboBo1)
	AADD(oGetDados2:aCols,Array(Len(oGetDados2:aHeader)+1))
	oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aHeader,{|aVet| Alltrim(aVet[2]) == "BS_FLAG"  	})] := oNo
	oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aHeader,{|aVet| Alltrim(aVet[2]) == "BS_DESCR"  })] := ""
	oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aHeader,{|aVet| Alltrim(aVet[2]) == "BS_CODIGO" })] := ""
	oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aHeader,{|aVet| Alltrim(aVet[2]) == "BS_DESCPRD"  })] := ""
	oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aHeader,{|aVet| Alltrim(aVet[2]) == "BS_XDESC"  })] := ""
	oGetDados2:aCols[Len(oGetDados2:aCols),Len(oGetDados2:aHeader)+1 ] := .F.
	oGetDados2:refresh()
	Return
Endif

If Select("QRY") > 0
	QRY->(dbCloseArea())
Endif

cQuery:= " SELECT *
cQuery+= " FROM "+RETSQLNAME("SBS")+" SBS"
cQuery+= " WHERE BS_FILIAL = '"+xFilial("SBS")+"' "
cQuery+= " AND SBS.D_E_L_E_T_ = '' "
cQuery+= " AND BS_BASE = '"+cBase+"' "
cQuery+= " AND BS_ID = '"+cId+"' "


if !empty(Alltrim(cOpcoes)) .and. SUBSTRING(cComboBo2,1,1) == '1'
	cQuery+= " AND BS_DESCR LIKE '"+Alltrim(cOpcoes)+"%' "
Elseif !empty(Alltrim(cOpcoes)) .and. SUBSTRING(cComboBo2,1,1) == '2'
	cQuery+= " AND BS_CODIGO LIKE '"+Alltrim(cOpcoes)+"%' "
Endif
cQuery+= " ORDER BY BS_BASE,BS_ID "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)
oGetDados2:aCols := {}

If !QRY->(eof())
	While QRY->(!eof())
		
		AADD(oGetDados2:aCols,Array(Len(oGetDados2:aHeader)+1))
		oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aHeader,{|aVet| Alltrim(aVet[2]) == "BS_FLAG"  	})] := oNo
		oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aHeader,{|aVet| Alltrim(aVet[2]) == "BS_DESCR"  })] := QRY->BS_DESCR
		oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aHeader,{|aVet| Alltrim(aVet[2]) == "BS_CODIGO"  })] := QRY->BS_CODIGO
		oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aHeader,{|aVet| Alltrim(aVet[2]) == "BS_DESCPRD"  })] := QRY->BS_DESCPRD
		oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aHeader,{|aVet| Alltrim(aVet[2]) == "BS_XDESC"  })] := QRY->BS_XDESC
		oGetDados2:aCols[Len(oGetDados2:aCols),Len(oGetDados2:aHeader)+1 ] := .F.
		QRY->(DbSkip())
	EndDo
	lRet:= .T.
Else
	AADD(oGetDados2:aCols,Array(Len(oGetDados2:aHeader)+1))
	oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aHeader,{|aVet| Alltrim(aVet[2]) == "BS_FLAG"  	})] := oNo
	oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aHeader,{|aVet| Alltrim(aVet[2]) == "BS_DESCR"  })] := ""
	oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aHeader,{|aVet| Alltrim(aVet[2]) == "BS_CODIGO" })] := ""
	oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aHeader,{|aVet| Alltrim(aVet[2]) == "BS_DESCPRD"  })] := ""
	oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aHeader,{|aVet| Alltrim(aVet[2]) == "BS_XDESC"  })] := ""
	oGetDados2:aCols[Len(oGetDados2:aCols),Len(oGetDados2:aHeader)+1 ] := .F.
	lRet:= .f.
EndIf

If Select("QRY") > 0
	QRY->(dbCloseArea())
Endif


//	aadd(aCodigo,{cBase,cId,cCodBs,nTam,cDesc,cDescDet})
if Len (aCodigo) > 0
	xPosIni:= 2
	if ascan(aCodigo,{|x| alltrim(x[2]) == alltrim(oGetDados:acols[oGetDados:nat,2]) }) > 0
		xConteudo:= aCodigo[ascan(aCodigo,{|x| alltrim(x[2]) == alltrim(oGetDados:acols[oGetDados:nat,2]) }) ,3]
		xTam:= acodigo[ascan(aCodigo,{|x| alltrim(x[2]) == alltrim(oGetDados:acols[oGetDados:nat,2]) }) ,4]
		
		For _x:=1 to len(oGetDados:aCols)
			if alltrim(oGetDados:aCols[_x,2]) == alltrim(oGetDados:acols[oGetDados:nat,2])
				Exit
			Else
				xPosIni+= oGetDados:aCols[_x,4]
			Endif
		Next _x
		
		if !empty(substring(cCodigo,xPosIni+1,xTam)) .and. substring(cCodigo,xPosIni+1,xTam) <> "_"
			xPosGet2:= aScan(oGetDados2:aCols,{|x| alltrim(x[3]) ==  substring(cCodigo,xPosIni+1,xTam) } )
			For _i := 1 To Len(oGetDados2:Acols)
				if _i == xPosGet2
					oGetDados2:aCols[_i,1]:= oOk
					oGetDados2:aCols[_i,6]:= "1"
				Elseif oGetDados2:aCols[_i,1]== oOk .and. _i <> xPosGet2
					oGetDados2:aCols[_i,1]:= oNo
					oGetDados2:aCols[_i,6]:= "2"
				Endif
			Next _i
		Endif
		
	Endif
	oGetDados2:refresh()
	
Endif


//MsgRun("Carregando Dados GRID 3, aguarde...",,{|| fMSNewGe3() })

oComboBo1:Refresh()
oGetDados:Refresh()
oGetDados2:Refresh()
oGetDados3:Refresh()
oDlg:Refresh()

Return


//------------------------------------------------
Static Function fMSNewGe3()
//------------------------------------------------
Local cQuery:= ""
Local lRet:= .F.

If Empty(cComboBo1)
	AADD(oGetDados3:aCols,Array(Len(oGetDados3:aHeader)+1))
	oGetDados3:aCols[Len(oGetDados3:aCols),aScan(oGetDados3:aHeader,{|aVet| Alltrim(aVet[2]) == "B1_FLAG" })] := oNo
	oGetDados3:aCols[Len(oGetDados3:aCols),aScan(oGetDados3:aHeader,{|aVet| Alltrim(aVet[2]) == "B1_COD"  })] := ""
	oGetDados3:aCols[Len(oGetDados3:aCols),aScan(oGetDados3:aHeader,{|aVet| Alltrim(aVet[2]) == "B1_DESC" })] := ""
	oGetDados3:aCols[Len(oGetDados3:aCols),Len(oGetDados3:aHeader)+1 ] := .F.
	oGetDados3:Refresh()
	Return .T.
EndIf



if Empty(cCodigo)
	cCodigo:= alltrim(cBase)
Endif

oCodigo:refresh()

If Select("QRY") > 0
	QRY->(dbCloseArea())
Endif

cQuery:= " SELECT *
cQuery+= " FROM "+RETSQLNAME("SB1")+" SB1"
cQuery+= " WHERE B1_FILIAL = '"+xFilial("SB1")+"' "
cQuery+= " AND SB1.D_E_L_E_T_ = '' "

if !empty(Alltrim(cOpcoes)) .and. SUBSTRING(cComboBo2,1,1) == '3'
	cQuery+= " AND B1_COD LIKE '"+Alltrim(cOpcoes)+"%' "
Else
	cQuery+= " AND B1_COD LIKE '"+cCodigo+"%' "
Endif
cQuery+= " ORDER BY B1_COD, B1_DESC
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)

oGetDados3:aCols := {}


If !QRY->(eof())
	While QRY->(!eof())
		AADD(oGetDados3:aCols,Array(Len(oGetDados3:aHeader)+1))
		IF alltrim(QRY->B1_COD) == alltrim(cCodigo)
			oGetDados3:aCols[Len(oGetDados3:aCols),aScan(oGetDados3:aHeader,{|aVet| Alltrim(aVet[2]) == "B1_FLAG" })] := oOk
			oGetDados3:aCols[Len(oGetDados3:aCols),aScan(oGetDados3:aHeader,{|aVet| Alltrim(aVet[2]) == "COR" })] := "1"
		Else
			oGetDados3:aCols[Len(oGetDados3:aCols),aScan(oGetDados3:aHeader,{|aVet| Alltrim(aVet[2]) == "B1_FLAG" })] := oNo
		Endif
		oGetDados3:aCols[Len(oGetDados3:aCols),aScan(oGetDados3:aHeader,{|aVet| Alltrim(aVet[2]) == "B1_COD"  })] := QRY->B1_COD
		oGetDados3:aCols[Len(oGetDados3:aCols),aScan(oGetDados3:aHeader,{|aVet| Alltrim(aVet[2]) == "B1_DESC" })] := QRY->B1_DESC
		oGetDados3:aCols[Len(oGetDados3:aCols),Len(oGetDados3:aHeader)+1 ] := .F.
		QRY->(DbSkip())
	EndDo
	lRet:= .T.
Else
	AADD(oGetDados3:aCols,Array(Len(oGetDados3:aHeader)+1))
	oGetDados3:aCols[Len(oGetDados3:aCols),aScan(oGetDados3:aHeader,{|aVet| Alltrim(aVet[2]) == "B1_FLAG" })] := oNo
	oGetDados3:aCols[Len(oGetDados3:aCols),aScan(oGetDados3:aHeader,{|aVet| Alltrim(aVet[2]) == "B1_COD"  })] := ""
	oGetDados3:aCols[Len(oGetDados3:aCols),aScan(oGetDados3:aHeader,{|aVet| Alltrim(aVet[2]) == "B1_DESC" })] := ""
	oGetDados3:aCols[Len(oGetDados3:aCols),Len(oGetDados3:aHeader)+1 ] := .F.
	lRet:= .f.
EndIf

oComboBo1:Refresh()
oGetDados:Refresh()
oGetDados2:Refresh()
oGetDados3:Refresh()
oDlg:Refresh()

If Select("QRY") > 0
	QRY->(dbCloseArea())
Endif

Return

Static Function fChange (oGetTmp)
Local _i
Local nPosFlag	:= aScan(oGetTmp:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_FLAG"  	})
Local nPosId    := aScan(oGetTmp:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_ID"  	})
Local nPosTam   := aScan(oGetTmp:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_TAMANHO"	})
Local nPosCor :=  aScan(oGetTmp:aHeader,{ |avet| aVet[2] == 'COR'  } )

If Empty(cComboBo1)
	Return
Endif

cOpcoes:= space(30)
oOpcoes:refresh()


For _i := 1 To Len(oGetTmp:Acols)
	if  _i == oGetTmp:nAt
		oGetTmp:aCols[_i,nPosCor]:= "1"
		cId:= oGetTmp:aCols[oGetTmp:nAt,nPosId]
		nTam:= oGetTmp:aCols[oGetTmp:nAt,nPosTam]
	Else
		if oGetDados:aCols[oGetDados:nAt,nPosFlag] <> oOk .or. (oGetDados:aCols[oGetDados:nAt,nPosFlag] == oOk .and. _i <> oGetTmp:nAt )
			oGetTmp:aCols[_i,nPosCor]:= "2"
		Endif
	Endif
Next _i

MsgRun("Carregando Dados GRID 2, aguarde...",,{|| fMSNewGe2() })

oGetTmp:refresh()


Return


Static Function fMark2(nOpc)
Local nPosFlag	:= aScan(oGetDados2:aHeader,{|aVet| Alltrim(aVet[2]) == "BS_FLAG"  	})
Local nPosCorBQ	:= aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "COR"  	})
Local nPosCor	:= aScan(oGetDados2:aHeader,{|aVet| Alltrim(aVet[2]) == "COR"  	})
Local nPosId    := aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_ID"  	})
Local nPosTam   := aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_TAMANHO"	})
Local nPosCod   := aScan(oGetDados2:aHeader,{|aVet| Alltrim(aVet[2]) == "BS_CODIGO"  	})
Local nPDescBP   := aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BP_DESCR"  	})
Local nPDescBS   := aScan(oGetDados2:aHeader,{|aVet| Alltrim(aVet[2]) == "BS_DESCPRD"  	})
Local nPDetaBS   := aScan(oGetDados2:aHeader,{|aVet| Alltrim(aVet[2]) == "BS_XDESC"  	})
Local _i
Local _y
Local aID :={}
Local cIds:= ""
Local lRet:= .T.

//Begin Transaction

oGetDados2:aCols[oGetDados2:nAt,nPosFlag]:= IIF(nOpc == 1,oOk,oNo)

IF oGetDados2:aCols[oGetDados2:nAt,nPosFlag] == oOk
	oGetDados2:aCols[oGetDados2:nAt,nPosCor]:= "1"
	cCodBs:= oGetDados2:aCols[oGetDados2:nAt,nPosCod]
	cDesc:= Alltrim(oGetDados2:aCols[oGetDados2:nAt,nPDescBS])+space(1)
	cDescDet:= Alltrim(oGetDados2:aCols[oGetDados2:nAt,nPDetaBS])+Space(1)
	
	nPosBQ:= ascan(oGetDados:acols,{|x| alltrim(x[nPosCorBQ]) == "1"})
	if oGetDados:aCols[nPosBQ,nPosFlag] <> oOk
		oGetDados:aCols[nPosBQ,nPosFlag] := oOk
		cId:= oGetDados:aCols[nPosBQ,nPosId]
		nTam:= oGetDados:aCols[nPosBQ,nPosTam]
	Endif
	
	
	if ascan(aCodigo,{|x| alltrim(x[2]) == alltrim(cId) })  > 0
		aCodigo[ascan(aCodigo,{|x| alltrim(x[2]) == alltrim(cId) }),3 ]:= cCodBs
		aCodigo[ascan(aCodigo,{|x| alltrim(x[2]) == alltrim(cId) }),5 ]:= cDesc
		aCodigo[ascan(aCodigo,{|x| alltrim(x[2]) == alltrim(cId) }),6 ]:= cDescDet
	Else
		aadd(aCodigo,{cBase,cId,cCodBs,nTam,cDesc,cDescDet})
	Endif
	
	cCodigo:= alltrim(cBase)
	cDesc := alltrim(oGetDados:aCols[1,nPDescBP] )+Space(1)
	cDescDet:= Alltrim(oGetDados:aCols[1,nPDetaBS])+Space(1)
	
	For _i:=1 to len(oGetDados:aCols)
		if oGetDados:aCols[_i,1] == oOk
			cCodigo+= ALLTRIM(aCodigo[ascan(aCodigo,{|x| VAL(x[2]) == _i}),3])
			cDesc +=  ALLTRIM(aCodigo[ascan(aCodigo,{|x| VAL(x[2]) == _i}),5])+Space(1)
			cDescDet+= ALLTRIM(aCodigo[ascan(aCodigo,{|x| VAL(x[2]) == _i}),6])+Space(1)
		Else
			cCodigo+= replicate("_", oGetDados:aCols[_i,4])
			
		Endif
	Next
Else
	///	Ao desmarcar limpar campo, cor, flag, etc...///
	oGetDados2:aCols[oGetDados2:nAt,nPosCor]:= "2"
	cCodBs:= oGetDados2:aCols[oGetDados2:nAt,nPosCod]
	cDesc:= ""
	cDescDet:= ""
	
	nPosBQ:= ascan(oGetDados:acols,{|x| alltrim(x[nPosCorBQ]) == "1"})
	//if oGetDados:aCols[nPosBQ,nPosFlag] == oOk
	oGetDados:aCols[nPosBQ,nPosFlag] := oNo
	cId:= oGetDados:aCols[nPosBQ,nPosId]
	nTam:= oGetDados:aCols[nPosBQ,nPosTam]
	//Endif
	
	
	if ascan(aCodigo,{|x| alltrim(x[2]) == alltrim(cId) })  > 0
		//ADEL( aCodigo,ascan(aCodigo,{|x| x[2] == cId }) )
		aCodigo[ascan(aCodigo,{|x| alltrim(x[2]) == alltrim(cId) }),3 ]:= ""
		aCodigo[ascan(aCodigo,{|x| alltrim(x[2]) == alltrim(cId) }),5 ]:= ""
		aCodigo[ascan(aCodigo,{|x| alltrim(x[2]) == alltrim(cId) }),6 ]:= ""
		
	Endif
	
	cCodigo:= alltrim(cBase)
	cDesc := alltrim(oGetDados:aCols[1,nPDescBP] )+Space(1)
	cDescDet:= Alltrim(oGetDados:aCols[1,nPDetaBS])+Space(1)
	
	For _i:=1 to len(oGetDados:aCols)
		if oGetDados:aCols[_i,1] == oOk
			cCodigo+= ALLTRIM(aCodigo[ascan(aCodigo,{|x| VAL(x[2]) == _i}),3])
			cDesc +=  ALLTRIM(aCodigo[ascan(aCodigo,{|x| VAL(x[2]) == _i}),5])+Space(1)
			cDescDet+= ALLTRIM(aCodigo[ascan(aCodigo,{|x| VAL(x[2]) == _i}),6])+Space(1)
		Else
			cCodigo+= replicate("_", oGetDados:aCols[_i,4])
			
		Endif
	Next
	
Endif


For _y := 1 To len(oGetDados:aCols)
	__ID:= alltrim(oGetDados:aCols[_y,2])
	
	if oGetDados:aCols[_y,nPosFlag] == oOk
		if Empty(cIds)
			cIds:= "ZZQ_CARACT LIKE '%"+alltrim(oGetDados:aCols[_y,2])+"%' "
		Else
			cIds+= "OR ZZQ_CARACT LIKE '%"+alltrim(oGetDados:aCols[_y,2])+"%' "
		Endif
	Endif
	
	nPosOk:= ascan(aCodigo,{|x| alltrim(x[2]) == __ID  })
	IF nPosOk > 0
		AADD(aID, {__ID, aCodigo[nPosOk,3]})
	Else
		AADD(aID, {__ID,"" })
	Endif
	
Next _y

FWMsgRun( , {|| IIf(!fVldRegra(aId,cBase, cIds), lRet:= .F., lRet:= .T.)},"Aguarde...","Verificando Regras")



If lRet
	For _i := 1 To Len(oGetDados2:Acols)
		if oGetDados2:aCols[_i,nPosFlag]== oOk .and. oGetDados2:nAt <> _i
			oGetDados2:aCols[_i,nPosFlag]:= oNo
			oGetDados2:aCols[_i,nPosCor]:= "2"
		Endif
	Next _i
	
	cDesc:= alltrim(StrTran(cDesc,"#","" ))
	cDesc:= alltrim(StrTran(cDesc,"COR OPT","CORD OPT" ))
	cDesc:= alltrim(StrTran(cDesc,"  "," " ))
	
	
	cDescDet:= StrTran(cDescDet,"#","" )
	cDescDet:= StrTran(cDescDet,"COR OPT","CORD OPT" )
	cDescDet:= StrTran(cDescDet,"  "," " )
Else
	//DisarmTransaction()
	///	Ao desmarcar limpar campo, cor, flag, etc...///
	oGetDados2:aCols[oGetDados2:nAt,nPosFlag]:= oNo
	oGetDados:aCols[oGetDados:nAt,nPosFlag]:= oNo
	oGetDados2:aCols[oGetDados2:nAt,nPosCor]:= "2"
	cCodBs:= oGetDados2:aCols[oGetDados2:nAt,nPosCod]
	cDesc:= ""
	cDescDet:= ""
	
	nPosBQ:= ascan(oGetDados:acols,{|x| alltrim(x[nPosCorBQ]) == "1"})
	//if oGetDados:aCols[nPosBQ,nPosFlag] == oOk
	oGetDados:aCols[nPosBQ,nPosFlag] := oNo
	cId:= oGetDados:aCols[nPosBQ,nPosId]
	nTam:= oGetDados:aCols[nPosBQ,nPosTam]
	//Endif
	
	
	if ascan(aCodigo,{|x| alltrim(x[2]) == alltrim(cId) })  > 0
		//ADEL( aCodigo,ascan(aCodigo,{|x| x[2] == cId }) )
		aCodigo[ascan(aCodigo,{|x| alltrim(x[2]) == alltrim(cId) }),3 ]:= ""
		aCodigo[ascan(aCodigo,{|x| alltrim(x[2]) == alltrim(cId) }),5 ]:= ""
		aCodigo[ascan(aCodigo,{|x| alltrim(x[2]) == alltrim(cId) }),6 ]:= ""
		
	Endif
	
	cCodigo:= alltrim(cBase)
	cDesc := alltrim(oGetDados:aCols[1,nPDescBP] )+Space(1)
	cDescDet:= Alltrim(oGetDados:aCols[1,nPDetaBS])+Space(1)
	
	For _i:=1 to len(oGetDados:aCols)
		if oGetDados:aCols[_i,1] == oOk
			cCodigo+= ALLTRIM(aCodigo[ascan(aCodigo,{|x| VAL(x[2]) == _i}),3])
			cDesc +=  ALLTRIM(aCodigo[ascan(aCodigo,{|x| VAL(x[2]) == _i}),5])+Space(1)
			cDescDet+= ALLTRIM(aCodigo[ascan(aCodigo,{|x| VAL(x[2]) == _i}),6])+Space(1)
		Else
			cCodigo+= replicate("_", oGetDados:aCols[_i,4])
			
		Endif
	Next
	
Endif

//End Transaction

fMSNewGe3()

oComboBo1:Refresh()
oGetDados:Refresh()
oGetDados2:Refresh()
oGetDados3:Refresh()
oDesc:Refresh()
oDescDet:Refresh()

oDlg:Refresh()
Return

Static Function fMark3(nOpc)
Local nPosFlag	:= aScan(oGetDados3:aHeader,{|aVet| Alltrim(aVet[2]) == "B1_FLAG"  	})
Local nPosCor	:= aScan(oGetDados3:aHeader,{|aVet| Alltrim(aVet[2]) == "COR"  	})
Local nPosCod	:= aScan(oGetDados3:aHeader,{|aVet| Alltrim(aVet[2]) == "B1_COD"  	})
Local nPosId	:= aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_ID"  	})
Local nPosTam	:= aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BQ_TAMANHO"  	})
//Local nPDescBP   := aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == "BP_DESCR"  	})
//Local nPDescBS   := aScan(oGetDados2:aHeader,{|aVet| Alltrim(aVet[2]) == "BS_DESCPRD"  	})
//Local nPDetaBS   := aScan(oGetDados2:aHeader,{|aVet| Alltrim(aVet[2]) == "BS_XDESC"  	})
Local _z


oGetDados3:aCols[oGetDados3:nAt,nPosFlag]:= IIF(nOpc == 1,oOk,oNo)

IF oGetDados3:aCols[oGetDados3:nAt,nPosFlag] == oOk
	oGetDados3:aCols[oGetDados3:nAt,nPosCor]:= "1"
	cCodigo:= oGetDados3:aCols[oGetDados3:nAt,nPosCod]
	oCodigo:refresh()
Endif


For _z:= 1 to len(oGetdados:aCols)
	
	cId:= oGetDados:aCols[_z,nPosId]
	nTam:= oGetDados:aCols[_z,nPosTam]
	
	if !empty(Substring(cCodigo,val(cId)+2,nTam)) .and. Substring(cCodigo,val(cId)+2,nTam)<> "_"
		oGetDados:aCols[_z,nPosflag]:= oOk
		SBS->(DbSetOrder(1))// BS_FILIAL, BS_BASE, BS_ID, BS_CODIGO, R_E_C_N_O_, D_E_L_E_T_
		
		_BASE	:= PADR(Substring(cCodigo,1,2),tamSX3("BS_BASE")[1])
		_ID		:= PADR(cId,tamSX3("BS_ID")[1])
		xCODIGO	:= PADR(Substring(cCodigo,val(cId)+2,nTam),tamSX3("BS_CODIGO")[1])
		
		
		if SBS->(DbSeek(xFilial("SBS")+_BASE +_ID +xCODIGO) )
			if ascan(aCodigo,{|x| alltrim(x[2]) == alltrim(cId)})  > 0
				aCodigo[ascan(aCodigo,{|x| alltrim(x[2]) == alltrim(cId) }),3 ]:= SBS->BS_CODIGO
				aCodigo[ascan(aCodigo,{|x| alltrim(x[2]) == alltrim(cId) }),5 ]:= SBS->BS_DESCPRD
				aCodigo[ascan(aCodigo,{|x| alltrim(x[2]) == alltrim(cId) }),6 ]:= SBS->BS_XDESC
			Else
				aadd(aCodigo,{ALLTRIM(SBS->BS_BASE),ALLTRIM(SBS->BS_ID),ALLTRIM(SBS->BS_CODIGO),nTam,ALLTRIM(SBS->BS_DESCPRD),ALLTRIM(SBS->BS_XDESC)})
			Endif
			
		Endif
	Endif
	
	
Next _z

oGetDados3:Refresh()
oDlg:Refresh()

MsgRun("Carregando Dados GRID 2, aguarde...",,{|| fMSNewGe2() })

Return


Static Function CorGd01(oGetTmp)
Local nRet := 16777215

If oGetTmp:aCols[oGetTmp:nAt,aScan(oGetTmp:aHeader,{|aVet| Alltrim(aVet[2]) == "COR"})] == c2Leg2
	nRet := n2Leg2
Endif

If  oGetTmp:aCols[oGetTmp:nAt,aScan(oGetTmp:aHeader,{|aVet| Alltrim(aVet[2]) == "COR"})] == c2Leg1
	nRet   := n2Leg1
Endif

Return nRet


User Function m010IncR(oSay)
//Local _i
Local lRet := .F.
Local _Codigo
Private oModel := Nil
Private lMsErroAuto := .F.
Private aRotina := {}

Public ALTERA := .F.
Public INCLUI := .T.

If RAT("_",cCodigo) > 0
	MsgAlert("Código Incompleto... Preencha corretamente!","Aviso")
	Return .F.
Endif

SB1->(DbSetOrder(1))
if SB1->(DbSeek(xFilial("SB1")+Alltrim(cCodigo))  )
	MsgAlert("Produto já cadastrado","Verifique o código")
	Return  .F.
Endif

_Codigo:= ALLTRIM(cCodigo)

/*
cRpcEmp    := "01"            // Código da empresa.
cRpcFil    := "01"            // Código da filial.
cEnvUser   := "Admin"         // Nome do usuário.
cEnvPass   := "OpusDomex"     // Senha do usuário.
cEnvMod    := "EST"           // 'FAT'  // Código do módulo.
cFunName   := "U_DOMCADI"  // 'RPC'  // Nome da rotina que será setada para retorno da função FunName().
aTables    := {}              // {}     // Array contendo as tabelas a serem abertas.
lShowFinal := .F.             // .F.    // Alimenta a variável publica lMsFinalAuto.
lAbend     := .T.             // .T.    // Se .T., gera mensagem de erro ao ocorrer erro ao checar a licença para a estação.
lOpenSX    := .T.             // .T.    // SE .T. pega a primeira filial do arquivo SM0 quando não passar a filial e realiza a abertura dos SXs.
lConnect   := .T.             // .T.    // Se .T., faz a abertura da conexao com servidor As400, SQL Server etc

RPCSetType(3)
RpcSetEnv(cRpcEmp,cRpcFil,cEnvUser,cEnvPass,cEnvMod,cFunName,aTables,lShowFinal,lAbend,lOpenSX,lConnect)

*/

oModel := FwLoadModel ("MATA010")

aCampos:= {}

aadd(aCampos, {"B1_COD",_Codigo})
aadd(aCampos, {"B1_TIPO","PA"})
aadd(aCampos, {"B1_DESC",ALLTRIM(cDesc)})
//aadd(aCampos,  {"B1_DXDESC2",ALLTRIM(cDescDet)})

ZZ3->(dbSetOrder(1))
ZZ3->(dbGoTop())
While ZZ3->(!eof())
	cRegra := ZZ3->ZZ3_REGRA
	_lGrava := &(Alltrim(cRegra))
	if _lGrava
		// SX3->( dbSetOrder(2))
		// SX3->(dbSeek(alltrim(ZZ3->ZZ3_CAMPO)))
		// RecLock("SX3",.F.)
		// SX3->X3_WHEN:= ".T."
		// SX3->( MsUnlock() )
		
		oSay:cCaption := ("Gravação REGRA  - Campo:" +alltrim(ZZ3->ZZ3_CAMPO) + " / Conteudo - "+alltrim(ZZ3->ZZ3_CONTEU))
		ProcessMessages()
		aadd(aCampos, {alltrim(ZZ3->ZZ3_CAMPO),&(ZZ3->ZZ3_CONTEUDO)})
		//oModel:SetValue('SB1MASTER',alltrim(ZZ3->ZZ3_CAMPO) ,&(ZZ3->ZZ3_CONTEUDO))
		
	Endif
	ZZ3->(dbSkip())
End

lMsErroAuto := .F.
Public __lAuto := .T.
__cInterNet := 'AUTOMATICO'

FWMVCRotAuto( oModel,"SB1",MODEL_OPERATION_INSERT,{{"SB1MASTER", aCampos}} ,,.T.)
__lAuto := .F.

__cInterNet := Nil

//ALTERADO
//Se houve erro no ExecAuto, mostra mensagem
If lMsErroAuto
	MostraErro()
	//Senão, mostra uma mensagem de inclusão
Else
	MsgInfo("Registro incluido!", "Atenção")
	lRet:= .T.
EndIf

Return lRet



Static Function fVldRegra(aId, cBase, cIDs)

Local lRet:= .T.
Local aRegs:={}
Local cRegs:= ""
Local _i
Local oError   := ErrorBlock({|e| MsgAlert( e:Description,"Aviso")})
	
IF SELECT("QRY") > 0
	QRY->(DbCloseArea())
ENDIF

cQuery:= " SELECT
cQuery+= " ISNULL(CAST(CAST(ZZQ_MREGRA AS VARBINARY(8000)) AS VARCHAR(8000)),'') ZZQ_MREGRA,
cQuery+= " ISNULL(CAST(CAST(ZZQ_MSG AS VARBINARY(8000)) AS VARCHAR(8000)),'') ZZQ_MSG
cQuery+= " FROM "+RetSqlName("ZZQ")+" ZZQ "
cQuery+= " WHERE ZZQ_BASE = '"+cBase+"'  "  
if !empty(cIds)
	cQuery+= " AND ("+cIds+")  "
Endif
cQuery+= " AND D_E_L_E_T_ = ''   "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)

While QRY->(!Eof())
	cRegs:= StrTran( QRY->ZZQ_MREGRA, "#[", "Alltrim(aId[" )
	cRegs:= StrTran( cRegs, "]", ",2]) " )  
	cRegs:= StrTran( cRegs, "#|", "'" )
	cRegs:= StrTran( cRegs, "|", "'" )
	cRegs:= Alltrim(cRegs)
	cMsg:= Alltrim(QRY->ZZQ_MSG)
	
	aadd(aRegs,{cRegs,cMsg} )
	QRY->(dbSkip())
End

For _i := 1 to len(aRegs)
	if &(aRegs[_i,1])
		MsgStop(aRegs[_i,2], "Atenção!" )
		lRet := .F.
	Endif
ErrorBlock(oError)
Next _i

Return lRet
