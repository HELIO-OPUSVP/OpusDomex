#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#include 'parmtype.ch'

USER FUNCTION DOMRELC2()
Local oReport
Local aArea    	:= GetArea()
Private  cPerg   	:= "DOMRELCEI2"
Private aProds	 :={}
Private aEstrut 	:= {}
Private aDocs		:= {}
Private aRegras 	:= {}
Private cCodPai	:= ""

AjustaSX1(cPerg)
If Pergunte(cPerg,.T.)
	aProds  := fProds(MV_PAR01,MV_PAR02)
	oReport := ImpRptDef()
	oReport:PrintDialog()
EndIf
RestArea( aArea )

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMRELCEI ºAutor  ³Microsiga           º Data ³  07/25/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpRptDef()

Local oReport													// Objeto do relatorio
Local oSection1												// Objeto da secao 1
Local oSection2												// Objeto da secao 2
Local oSection3												// Objeto da secao 3
Local aOrdem	:= {}
Local cAliasRep := GetNextAlias()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gera a tela com os dados para a confirmação da geracao do relatorio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)
oReport := TReport():New("DOMRELCEI","Relatório comparativo Estrutura x Regras",cPerg,{|oReport| PrtRpt( oReport ,@cAliasRep )}, "Comparativo" )
oReport:nFontBody := 9
//oReport:SetCustomText( {|| CabecPak(oReport,cFilialDe,cFilialAte) })


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a secao1 do relatorio																				³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New( oReport,"Relatório comparativo Estrutura x Regras",{(cAliasRep)},aOrdem)

TRCell():New(oSection1,"PAI" 			, cAliasRep ,"PAI"			,"@R" 					,20		,/*lPixel*/	, /*{|| code-block de impressao }*/)
TRCell():New(oSection1,"TIP" 			, cAliasRep ,"TIP"			,"@R" 					,04		,/*lPixel*/	, /*{|| code-block de impressao }*/)

TRCell():New(oSection1,"E_PN" 		, cAliasRep ,"E.PN"			,"@R" 					,20		,/*lPixel*/	, /*{|| code-block de impressao }*/)
TRCell():New(oSection1,"E_QUANT" 	, cAliasRep ,"E.QUANT"		,"@E 999,999.9999"	,08		,/*lPixel*/	, /*{|| code-block de impressao }*/)
TRCell():New(oSection1,"E_ETIQ1" 	, cAliasRep ,"E.ETIQ1"		,"@E 999" 				,08		,/*lPixel*/	, /*{|| code-block de impressao }*/)
TRCell():New(oSection1,"E_ETIQ2"		, cAliasRep ,"E.ETIQ2"     ,"@E 999" 				,08		,/*lPixel*/	, /*{|| code-block de impressao }*/)
TRCell():New(oSection1,"E_NIVEL"		, cAliasRep ,"E.NIVEL"     ,"@R" 					,08		,/*lPixel*/	, /*{|| code-block de impressao }*/)

TRCell():New(oSection1,"R_PN" 		, cAliasRep ,"R.PN"			,"@R" 					,20		,/*lPixel*/	, /*{|| code-block de impressao }*/)
TRCell():New(oSection1,"R_QUANT" 	, cAliasRep ,"R.QUANT"		,"@E 999,999.9999"	,08		,/*lPixel*/	, /*{|| code-block de impressao }*/)
TRCell():New(oSection1,"R_ETIQ1" 	, cAliasRep ,"R.ETIQ1"		,"@E 999"			 	,08		,/*lPixel*/	, /*{|| code-block de impressao }*/)
TRCell():New(oSection1,"R_ETIQ2"		, cAliasRep ,"R.ETIQ2"     ,"@E 999" 				,08		,/*lPixel*/	, /*{|| code-block de impressao }*/)
TRCell():New(oSection1,"R_NIVEL"		, cAliasRep ,"R.NIVEL"     ,"@R" 					,08		,/*lPixel*/	, /*{|| code-block de impressao }*/)

Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMRELCEI ºAutor  ³Microsiga           º Data ³  07/25/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PrtRpt( oReport,cAliasRep )

Local oSection1:= oReport:Section(1)
Local _Enter   := chr(13) + chr(10)
Local _cQuery  := ""
Local aCampos	:= {}

aCampos :={}

AADD(aCampos,{"PAI"  	,"C",20,0})
AADD(aCampos,{"TIP"  	,"C",04,0})
AADD(aCampos,{"E_PN"  	,"C",20,0})
AADD(aCampos,{"E_QUANT" ,"N",08,0})
AADD(aCampos,{"E_ETIQ1" ,"N",08,0})
AADD(aCampos,{"E_ETIQ2" ,"N",08,0})
AADD(aCampos,{"E_NIVEL"	,"C",08,0})

AADD(aCampos,{"R_PN"  	,"C",20,0})
AADD(aCampos,{"R_QUANT" ,"N",08,0})
AADD(aCampos,{"R_ETIQ1" ,"N",08,0})
AADD(aCampos,{"R_ETIQ2" ,"N",08,0})
AADD(aCampos,{"R_NIVEL"	,"C",08,0})

if SELECT(cAliasRep) > 0
	(cAliasRep)->(DbCloseArea())
Endif

cArq:= Criatrab(aCampos,.T.)
DBUseArea(.T.,,cArq,cAliasRep,.T.)
cIndex	:= Left(cArq,7)
cKey:= "PAI"
IndRegua(cAliasRep,cIndex,cKey,,,OemToAnsi("Selecionando Registros..."))

DbClearIndex()
DbSetIndex(cIndex + OrdBagExt())



For _j:= 1 To len(aProds)
	aEstrut 	:= {}
	aDocs		:= {}
	aRegras 	:= {}
	fVldEstrut(aProds[_j,1])
	
	_cPai:= aProds[_j,1]
	
	
	For _x := 1 to len (aEstrut)
		_lRet:= .F.
		
		If MV_PAR03 == 1
			If ALLTRIM(aEstrut[_x,1]) == ALLTRIM(aEstrut[_x,7])
				_lRet:= .T.
			Endif
		ElseIf MV_PAR03 == 2
			If ALLTRIM(aEstrut[_x,1]) <> ALLTRIM(aEstrut[_x,7])
				_lRet:= .T.
			Endif
		Else
			_lRet:= .T.
		ENDIF
		
		IF _lRet
			
			DBSelectArea(cAliasRep)
			RecLock(cAliasRep,.T.)
			PAI		:= _cPai
			TIP		:= "COD"
			E_PN		:= aEstrut[_x,1]
			E_QUANT	:= aEstrut[_x,2]
			E_ETIQ1	:= aEstrut[_x,3]
			E_ETIQ2	:= aEstrut[_x,4]
			E_NIVEL	:= aEstrut[_x,6]
			
			R_PN		:= aEstrut[_x,7]
			R_QUANT	:= aEstrut[_x,8]
			R_ETIQ1	:= aEstrut[_x,9]
			R_ETIQ2	:= aEstrut[_x,10]
			R_NIVEL	:= aEstrut[_x,11]
			
			MsUnlock()
		Endif
	Next _x
	
	For _z := 1 to len (aDocs)
		_lRet:= .F.
		If MV_PAR03 == 1
			If ALLTRIM(aDocs[_z,1]) == ALLTRIM(aDocs[_z,2])
				_lRet:= .T.
			Endif
		ElseIf MV_PAR03 == 2
			If ALLTRIM(aDocs[_z,1]) <> ALLTRIM(aDocs[_z,2])
				_lRet:= .T.
			Endif
		Else
			_lRet:= .T.
		ENDIF
		if _lRet
			DBSelectArea(cAliasRep)
			RecLock(cAliasRep,.T.)
			PAI	:= _cPai
			TIP		:= "DOC"
			E_PN 	:= aDocs[_z,1]
			R_PN 	:= aDocs[_z,2]
			MsUnlock()
		Endif
	Next _z
	
Next _j




dbSelectArea(cAliasRep)
(cAliasRep)->(dbGoTop())

oSection1:SetHeaderSection(.T.) //Define que imprime cabeçalho das células na quebra de seção
oSection1:SetHeaderBreak(.T.)

oBreak := TRBreak():New(oSection1, {|| (cAliasRep)->PAI })
oReport:SkipLine()
oReport:SetMeter((cAliasRep)->(RecCount()))
oSection1:Init()


While (cAliasRep)->(!Eof())
	If (cAliasRep)->PAI <> cCodPai
		cCodPai	:= (cAliasRep)->PAI
		oSection1:Init()
		oReport:SkipLine()
		oSection1:PrintLine()
	EndIf
	
	oReport:IncMeter(1)
	If oReport:Cancel()
		Exit
	EndIf
	oSection1:PrintLine()
	(cAliasRep)->(DbSkip())
EndDo

oSection1:Finish()
(cAliasRep)->(DbCloseArea())


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMRELCEI2ºAutor  ³Microsiga           º Data ³  07/25/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fProds(cProdDe, cProdAte)
Local aProdutos:= {}

If SELECT("QRY") > 0
	QRY->(dbCloseArea())
Endif

cQuery:= " SELECT  B1_COD FROM "+RETSQLNAME("SB1")+" SB1"
cQuery+= " WHERE B1_COD BETWEEN '"+AllTrim(cProdDe)+"' AND '"+AllTrim(cProdAte)+"' "
cQuery+= " AND SB1.D_E_L_E_T_ = '' "
cQuery+= " ORDER BY 1 "
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QRY",.F.,.T.)

While QRY->(!Eof())
	aAdd(aProdutos,{QRY->B1_COD})

	
	QRY->(dbSkip())
End


Return aProdutos

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMRELCEI2ºAutor  ³Microsiga           º Data ³  07/25/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static Function fVldEstrut(_CODIGO)

Local cQuery 	:= ""
Local nPos		:= 0
Local lGrava	:= .T.
Local oDlg3     := Nil
Local cTitulo  := "Validação de estrutura"
Local cCabec
Local oLbx2		:= Nil         
Local cRegra	:= ""
Private oError   := ErrorBlock({|e| MsgAlert("Regra inválida: " +chr(10)+ e:Description)})

aEstrut 	:= {}
aDocs		:= {}
aRegras 	:= {}

dbSelectArea("SG1")
dbSetOrder(1) // G1_FILIAL, G1_COD, G1_COMP
dbSeek(xFilial("SG1")+_CODIGO)
While SG1->(!eOF()) .and. SG1->G1_COD == _CODIGO
	aAdd(aEstrut,{alltrim(SG1->G1_COMP), SG1->G1_QUANT,SG1->G1_XXQTET1,SG1->G1_XXQTET2,SG1->G1_XPESEMB,SG1->G1_XXEMBNI,"",0,0,0,"","",""})
	SG1->(DbSkip())
End

dbSelectArea("SZV")
dbSetOrder(2) // ZV_FILIAL, ZV_CHAVE, ZV_ARQUIVO
dbSeek(xFilial("SZV")+alltrim(_CODIGO))
While SZV->(!eOF()) .and. alltrim(SZV->ZV_CHAVE) == alltrim(_CODIGO)
	aAdd(aDocs,{alltrim(SZV->ZV_ARQUIVO),"",""})
	SZV->(DbSkip())
End

If Select("QRY2") > 0
	QRY2->(dbCloseArea())
Endif
cQuery:= " SELECT ZZA_BASE,ZZA_PN,ZZA_DESCR,ZZA_QUANT,ZZA_TIPO,ZZA_QETQ1,ZZA_QETQ2,ZZA_EMB,ZZA_PSEMB,ZZA_CONTEU, "
cQuery+= " R_E_C_N_O_, D_E_L_E_T_ = '', "
cQuery+= " ISNULL(CAST(CAST(ZZA_MREGRA AS VARBINARY(8000)) AS VARCHAR(8000)),'') ZZA_REGRA "
cQuery+= " FROM "+RETSQLNAME("ZZA")+" "
cQuery+= " WHERE ZZA_BASE = '"+Substring(_CODIGO,1,2)+"'"
cQuery+= " AND D_E_L_E_T_ = ''
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY2",.T.,.T.)

If !QRY2->(eof())
	While QRY2->(!eof())
		aAdd(aRegras,{QRY2->ZZA_TIPO ,alltrim(QRY2->ZZA_PN) , QRY2->ZZA_QUANT , QRY2->ZZA_REGRA , QRY2->ZZA_QETQ1 , QRY2->ZZA_QETQ2 , QRY2->ZZA_EMB , QRY2->ZZA_PSEMB})
		QRY2->(DbSkip())
	End
Else
	msgAlert("Não foi encontrada nenhuma regra para a base " + Substring(_CODIGO,1,2) ,"Aviso")
	Return
EndIf

For _i:= 1 to len(aRegras)
	Begin Sequence
	cRegra := StrTran( aRegras[_i,4], "#(", "SUBS(_CODIGO," ) 
	lGrava := &(Alltrim(cRegra))
	//lGrava := &(Alltrim(aRegras[_i,4]))
	If lGrava
		if aRegras[_i,1] == "1"
			nPos:= aScan(aEstrut,{|aVet| aVet[1] == ALLTRIM(aRegras[_i,2]) })
			IF nPos > 0
				aEstrut[nPos,7]:= alltrim(aRegras[_i,2])
				aEstrut[nPos,8]:= aRegras[_i,3]
				aEstrut[nPos,9]:= aRegras[_i,5]
				aEstrut[nPos,10]:= aRegras[_i,6]
				aEstrut[nPos,11]:= aRegras[_i,7]
				aEstrut[nPos,12]:= aRegras[_i,8]
			Else
				aAdd(aEstrut,{"",0,0,0,"","",alltrim(aRegras[_i,2]),aRegras[_i,3],aRegras[_i,5],aRegras[_i,6],aRegras[_i,7],aRegras[_i,8],""})
			Endif
		Else
			nPos:= aScan(aDocs,{|aVet| aVet[1] == ALLTRIM(aRegras[_i,2]) })
			IF nPos > 0
				aDocs[nPos,2]:= alltrim(aRegras[_i,2])
			Else
				aAdd(aDocs,{"",alltrim(aRegras[_i,2]),""})
			Endif
		EndIf
	Endif
	End Sequence
	
	ErrorBlock(oError)
	
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


//ASORT(aEstrut,,,{ | x,y | x[5] < y[5] } )
//ASORT(aDocs,,,{ | x,y | x[3] < y[3] } )

Return (aEstrut,aDocs)

Static Function AjustaSX1(cPerg)

DbSelectArea("SX1")
DbSetOrder(1)
aRegs :={}
aAdd(aRegs, {cPerg, "01", "Produto De  ?",              "", "", "mv_ch1", "C",30, 0, 0, "G", "", "MV_PAR01", ""     , "" , "" , "" , "", "" , "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", "SB1", "" , "", "","","",""})
aAdd(aRegs, {cPerg, "02", "Produto Ate ?",              "", "", "mv_ch2", "C",30, 0, 0, "G", "", "MV_PAR02", ""     , "" , "" , "" , "", "" , "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", "SB1", "" , "", "","","",""})
aAdd(aRegs, {cPerg, "03", "Filtrar 		 ",				  "", "", "mv_ch3", "N",03, 0, 0, "C", "", "MV_PAR03","Iguais", "" , "" , "" , "", "Diferente" , "", "", "", "", "Ambos" 		 , "", "", "", "", ""	 , "", "", "", "", "", "", "", "", ""   , "" , "", "","",""})
fAjuSx1(cPerg,aRegs)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³EtAjuSx1  ³ Autor ³ Anderson              ³ Data ³ 30/09/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria uma pergunta usando rotina padrao                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fAjuSx1(cPerg,aRegs)

Local _nTamX1, _nTamPe, _nTamDf := 0

DbSelectArea("SX1")
DbSetOrder(1)

// Indo ao Primeiro Registro do SX1, apenas para descobrir o tamanho do campo com o nome da PERGUNTA
// Campo chamado X1_GRUPO
DbGoTop()
_nTamX1	:= Len(SX1->X1_GRUPO)
_nTamPe	:= Len(Alltrim(cPerg))
_nTamDf	:= _nTamX1 - _nTamPe

// Adequando o Tamanho para Efetuar a Pesquisa no SX1
If _nTamDf > 0
	cPerg := cPerg + Space(_nTamDf)
ElseIf _nTamDf == 0
	cPerg := cPerg
Else
	Return()
EndIf

// Criando Perguntas caso NAO existam no SX1
For i:=1 to Len(aRegs)
	
	If !DbSeek(cPerg+aRegs[i,2])
		
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
		
		DbCommit()
	Endif
Next

Return()

