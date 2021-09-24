#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Topconn.ch"
#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CADZZR    ºAlter   Jonas Pereira        º Data ³  24/03/21  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex inventario ciclico                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CADZZR()

	Local aCores :=  {}
	AADD(aCores,{ "ZZR_STATUS=='G'"     , 'BR_CINZA' 	  } )
	AADD(aCores,{ "ZZR_STATUS=='P'"	    , 'BR_VERDE'      } )


	Private cAlias := "ZZR"

	DbSelectArea(cAlias)
	aRotina := {}

	AADD(aRotina,{ "Pesquisar "                ,'AxPesqui'            , 0, 1  } )
	AADD(aRotina,{ "Visualizar"                ,'AxVisual'            , 0, 2  } )
	AADD(aRotina,{ "Gera Inventário"           ,"U_ZZRGER01"           , 0, 3  } )
//AADD(aRotina,{ "Classif. Inventário"       ,"U_ZZRCLA"		   	  , 0, 4  } )    
	AADD(aRotina,{ "Relatorio Conferência"     ,"U_RELINV01"		  , 0, 7  } )
	AADD(aRotina,{ "Relatorio Gerencial"       ,"U_RELINV02"		  , 0, 7  } )
	AADD(aRotina,{ "Legenda   "                ,"U_fLeg"+cAlias       , 0, 10 } )

//AxCadastro("ZZS", "TESTE" )

	cCadastro := "CAD"+cAlias+"() - Inventário Cíclico"


	mBrowse( 6, 1,22,75,cAlias,,,,,,aCores              ,,,,,,,,)


Return


User Function fLegZZR()

	BrwLegenda("","Legenda",{;
		{"BR_CINZA"      ,"Inventário Gerado" 							   },; // 1
	{"BR_VERDE"      ,"Inventário Realizado"                           }})  // 2


Return


User Function ZRRDELETA()

	RegToMemory(cAlias,.F.)

	FWMsgRun(, {|oSay| ValExcl(&(cAlias+"->ZQ_SCNUM")) }, "Processando", "Processando a rotina...")

Return

Static function ValExcl(cNUMSC)

Return lReturn


User Function ZZRCLA()


	FWMsgRun(, {|oSay| fProcCla() }, "Processando", "Classificando produtos...")

Return

Static function fProcCla()
	Local cQuery  := ""
	Local nQtd65A := 0
	Local nQtd25A := 0
	Local nQtd10A := 0
	Local nVlr80A := 0
	Local nVlr15A := 0
	Local nVlr05A := 0
	local nVLTOT  := 0
	local nQTTOT  := 0
	Local aClass  := {}
	Local nPos    := 0
	Local dUlmes  := GetMV("MV_ULMES")
	Local dFinal  := FirstDate(dDatabase) - 1
	Local dInicio := monthsub(dFinal, 11)
	Local cDescPr := ""
	Local cCodigo := GetSx8Num("ZZS", "ZZS_CODIGO")

	dInicio := FirstDate(dInicio)

	If MsgYesNo("Confirma a reclassificação da CURVA ABC dos produtos?")

		//classificando valor
		cQuery := " "
		cQuery += " SELECT PRODUTO.D3_FILIAL, CODIGO, DESCRICAO, SUM(VALOR_TOTAL_MOVIMENTO_NA_DATA) AS VALOR_TOTAL_MOVIMENTO_NA_DATA FROM "
		//  cQuery += " VLTOT.VLTOT AS TOTVL FROM "


		cQuery += " ( "
//      -- Material com OP
		cQuery += " SELECT D3_FILIAL,D3_COD AS CODIGO, B1_DESC AS DESCRICAO,  "
		cQuery += " Round(SUM(D3_CUSTO1),4) AS VALOR_TOTAL_MOVIMENTO_NA_DATA  "
		cQuery += " FROM SD3010 (NOLOCK) SD3, SB1010 (NOLOCK) SB1  "
		cQuery += " WHERE  "
		cQuery += " D3_COD = B1_COD  "
		cQuery += " AND D3_EMISSAO >= '"+DtoS(dInicio)+"' AND D3_EMISSAO <= '"+DtoS(dFinal)+"' "
		cQuery += " AND D3_ESTORNO = '' "
		cQuery += " AND D3_OP <> ''  "
		cQuery += " AND D3_CUSTO1<> 0 "
		cQuery += " AND SB1.D_E_L_E_T_ = '' AND SD3.D_E_L_E_T_ = '' "
		cQuery += " AND B1_FILIAL='' AND D3_FILIAL='"+xFilial("SD3")+"' "
		cQuery += " AND B1_TIPO<>'MO' "
		cQuery += " GROUP BY D3_FILIAL,D3_COD, B1_DESC "

		cQuery += " UNION ALL "

		//-- Material sem OP
		cQuery += " SELECT D3_FILIAL,D3_COD AS CODIGO, B1_DESC AS DESCRICAO,  "
		cQuery += " Round(SUM(D3_CUSTO1),4) AS VALOR_TOTAL_MOVIMENTO_NA_DATA  "
		cQuery += " FROM SD3010 (NOLOCK) SD3, SB1010 (NOLOCK) SB1 "
		cQuery += " WHERE  "
		cQuery += " D3_COD = B1_COD "
		cQuery += " AND D3_EMISSAO >= '"+DtoS(dInicio)+"' AND D3_EMISSAO <= '"+DtoS(dFinal)+"' "
		cQuery += " AND D3_ESTORNO = '' "
		cQuery += " AND D3_OP = ''  "
		cQuery += " AND D3_CUSTO1<> 0 "
		cQuery += " AND LEFT(D3_CF,2) IN ('RE')  "
		cQuery += " AND D3_TM <> '999' "
		cQuery += " AND SB1.D_E_L_E_T_ = '' AND SD3.D_E_L_E_T_ = ''  "
		cQuery += " AND B1_FILIAL='' AND D3_FILIAL='"+xFilial("SD3")+"' "
		cQuery += " AND B1_TIPO<>'MO' "
		cQuery += " GROUP BY D3_FILIAL,D3_COD, B1_DESC "

		cQuery += " UNION ALL "

		//-- Material saidas NF
		cQuery += " SELECT D2_FILIAL,D2_COD AS CODIGO, B1_DESC AS DESCRICAO,  "
		cQuery += " Round(SUM(D2_CUSTO1),4) AS VALOR_TOTAL_MOVIMENTO_NA_DATA  "
		cQuery += " FROM SD2010 (NOLOCK) SD2, SB1010 (NOLOCK) SB1 "
		cQuery += " WHERE  "
		cQuery += " D2_COD = B1_COD "
		cQuery += " AND D2_EMISSAO >= '"+DtoS(dInicio)+"' AND D2_EMISSAO <= '"+DtoS(dFinal)+"' "
		cQuery += " AND D2_CUSTO1<> 0 "
		cQuery += " AND SB1.D_E_L_E_T_ = '' AND SD2.D_E_L_E_T_ = '' "
		cQuery += " AND B1_FILIAL='' AND D2_FILIAL='"+xFilial("SD2")+"' "
		cQuery += " AND B1_TIPO<>'MO' "
		cQuery += " GROUP BY D2_FILIAL,D2_COD, B1_DESC  "

		cQuery += " UNION ALL "

		//      -- Material entradas NF
		cQuery += "     SELECT D1_FILIAL,D1_COD AS CODIGO, B1_DESC AS DESCRICAO, "
		cQuery += " Round(SUM(D1_CUSTO),4) AS VALOR_TOTAL_MOVIMENTO_NA_DATA  "
		cQuery += " FROM SD1010 (NOLOCK) SD1, SB1010 (NOLOCK) SB1, SF4010 (NOLOCK) SF4 "
		cQuery += " WHERE  "
		cQuery += " D1_COD = B1_COD  "
		cQuery += " AND D1_TES=F4_CODIGO AND F4_ESTOQUE='S' "
		cQuery += " AND D1_EMISSAO >= '"+DtoS(dInicio)+"' AND D1_EMISSAO <= '"+DtoS(dFinal)+"' "
		cQuery += " AND D1_CUSTO<> 0 "
		cQuery += " AND SB1.D_E_L_E_T_ = '' AND SD1.D_E_L_E_T_ = '' AND SF4.D_E_L_E_T_ = ''  "
		cQuery += " AND B1_FILIAL='' AND D1_FILIAL='"+xFilial("SD1")+"' AND F4_FILIAL='"+xFilial("SF4")+"'  "
		cQuery += " AND B1_TIPO<>'MO' "
		cQuery += " GROUP BY D1_FILIAL,D1_COD, B1_DESC  "

		cQuery += " ) AS PRODUTO "
/*
	cQuery += " LEFT OUTER JOIN "

    //Soma TOTAIS
    cQuery += " ( "
	  
    cQuery += " SELECT D3_FILIAL, SUM(VALOR_TOTAL) AS VLTOT FROM "
	cQuery += " ( "
	//SOma Material com OP
    cQuery += " SELECT D3_FILIAL, Round(SUM(D3_CUSTO1),4) AS VALOR_TOTAL "
    cQuery += " FROM SD3010 (NOLOCK) SD3, SB1010 (NOLOCK) SB1  "
    cQuery += " WHERE  "
    cQuery += " D3_COD = B1_COD  "
    cQuery += " AND D3_EMISSAO >= '"+DtoS(dInicio)+"' AND D3_EMISSAO <= '"+DtoS(dFinal)+"' "   
    cQuery += " AND D3_ESTORNO = '' "
    cQuery += " AND D3_OP <> ''  "	
    cQuery += " AND D3_CUSTO1<> 0 "  
    cQuery += " AND SB1.D_E_L_E_T_ = '' AND SD3.D_E_L_E_T_ = '' "
    cQuery += " AND B1_FILIAL='' AND D3_FILIAL='"+xFilial("SD3")+"' "
    cQuery += " GROUP BY D3_FILIAL "

	cQuery += " UNION ALL "
 
    //Soma Material sem OP
    cQuery += "     SELECT D3_FILIAL, Round(SUM(D3_CUSTO1),4) AS VALOR_TOTAL "
    cQuery += " FROM SD3010 (NOLOCK) SD3, SB1010 (NOLOCK) SB1 "
    cQuery += " WHERE " 
    cQuery += " D3_COD = B1_COD  "
    cQuery += " AND D3_EMISSAO >= '"+DtoS(dInicio)+"' AND D3_EMISSAO <= '"+DtoS(dFinal)+"' "   
    cQuery += " AND D3_ESTORNO = '' "
    cQuery += " AND D3_OP = ''  "
    cQuery += " AND D3_CUSTO1<> 0 "
    cQuery += " AND LEFT(D3_CF,2) IN ('RE')  "
	cQuery += " AND D3_TM <> '999' "
    cQuery += " AND SB1.D_E_L_E_T_ = '' AND SD3.D_E_L_E_T_ = ''  "
    cQuery += " AND B1_FILIAL='' AND D3_FILIAL='"+xFilial("SD3")+"' "
    cQuery += " GROUP BY D3_FILIAL "

    cQuery += " UNION ALL "
 
    //Soma Material saidas NF
    cQuery += " SELECT D2_FILIAL, Round(SUM(D2_CUSTO1),4) AS VALOR_TOTAL "
    cQuery += " FROM SD2010 (NOLOCK) SD2, SB1010 (NOLOCK) SB1 "
    cQuery += " WHERE " 
    cQuery += " D2_COD = B1_COD "       
    cQuery += " AND D2_EMISSAO >= '"+DtoS(dInicio)+"' AND D2_EMISSAO <= '"+DtoS(dFinal)+"' "   
    cQuery += " AND D2_CUSTO1<> 0  "
    cQuery += " AND SB1.D_E_L_E_T_ = '' AND SD2.D_E_L_E_T_ = '' "
    cQuery += " AND B1_FILIAL='' AND D2_FILIAL='"+xFilial("SD2")+"' "  
    cQuery += " GROUP BY D2_FILIAL "

	cQuery += " UNION ALL "
 
    //Soma Material entradas NF
    cQuery += " SELECT D1_FILIAL, Round(SUM(D1_CUSTO),4) AS VALOR_TOTAL "
    cQuery += " FROM SD1010 (NOLOCK) SD1, SB1010 (NOLOCK) SB1, SF4010 (NOLOCK) SF4 "
    cQuery += " WHERE " 
    cQuery += " D1_COD = B1_COD "       
    cQuery += " AND D1_TES=F4_CODIGO AND F4_ESTOQUE='S' "
    cQuery += " AND D1_EMISSAO >= '"+DtoS(dInicio)+"' AND D1_EMISSAO <= '"+DtoS(dFinal)+"' "   
    cQuery += " AND D1_CUSTO<> 0 "
    cQuery += " AND SB1.D_E_L_E_T_ = '' AND SD1.D_E_L_E_T_ = '' AND SF4.D_E_L_E_T_='' "
    cQuery += " AND B1_FILIAL='' AND D1_FILIAL='"+xFilial("SD1")+"' AND F4_FILIAL='"+xFilial("SF4")+"' "  
    cQuery += " GROUP BY D1_FILIAL "
	  
    //group por tipo de filtro
    cQuery += " ) AS TOT "
    //group total dos 4 filtros
    cQuery += " GROUP BY D3_FILIAL "
    cQuery += " ) VLTOT ON VLTOT.D3_FILIAL = PRODUTO.D3_FILIAL "
    */
		//group do total e valores individuais dos produtos
		cQuery += " GROUP BY PRODUTO.D3_FILIAL, CODIGO, DESCRICAO "//, VLTOT.VLTOT "
		cQuery += " ORDER BY VALOR_TOTAL_MOVIMENTO_NA_DATA DESC "


		If Select("TMP") <> 0
			TMP->( dbCloseArea() )
		EndIf

		TCQUERY cQuery NEW ALIAS "TMP"

		While TMP->(!EOF())
			nVLTOT += TMP->VALOR_TOTAL_MOVIMENTO_NA_DATA
			TMP->(dbskip())
		Enddo

		If nVLTOT > 0
			nVlr80A := nVLTOT * 0.80
			nVlr15A := nVLTOT * 0.15
			nVlr05A := nVLTOT * 0.05
		EndIF

		TMP->(DBGOTOP())
		While TMP->(!EOF())
			If nVlr80A >= TMP->VALOR_TOTAL_MOVIMENTO_NA_DATA .AND. nVlr80A > 0
				AADD( aClass, {TMP->CODIGO, "A", "",TMP->VALOR_TOTAL_MOVIMENTO_NA_DATA, nVLTOT, 0, 0 })
				nVlr80A -= TMP->VALOR_TOTAL_MOVIMENTO_NA_DATA
			ElseIf nVlr15A >= TMP->VALOR_TOTAL_MOVIMENTO_NA_DATA .AND. nVlr15A > 0
				AADD( aClass, {TMP->CODIGO, "B", "",TMP->VALOR_TOTAL_MOVIMENTO_NA_DATA, nVLTOT, 0, 0})
				nVlr15A -= TMP->VALOR_TOTAL_MOVIMENTO_NA_DATA
				nVlr80A := 0
			Else
				AADD(aClass, {TMP->CODIGO, "C", "",TMP->VALOR_TOTAL_MOVIMENTO_NA_DATA, nVLTOT, 0, 0})
				nVlr15A := 0
			Endif
			TMP->(dbskip())
		Enddo


		//classificando QUANTIDADE
		cQuery := " "
		cQuery += " SELECT PRODUTO.D3_FILIAL, CODIGO, DESCRICAO, SUM(NUM_OPS) AS NUM_OPS FROM " //, TOTOP.TOTOP AS TOTOP

		cQuery += " ( "
		// Material com OP
		cQuery += " SELECT D3_FILIAL,D3_COD AS CODIGO, B1_DESC AS DESCRICAO,  "
		cQuery += " (SELECT COUNT(*) FROM "
		cQuery += " ( SELECT D3_OP FROM SD3010 (NOLOCK) WHERE D3_EMISSAO >= '"+dtos(dInicio)+"' AND D3_EMISSAO <= '"+dtos(dFinal)+"' AND D3_ESTORNO = '' "
		cQuery += " AND D3_OP <> '' AND SD3010.D_E_L_E_T_ = '' AND D3_COD = SD3.D3_COD GROUP BY D3_OP ) TMP1 ) NUM_OPS "
		cQuery += " FROM SD3010 (NOLOCK) SD3, SB1010 (NOLOCK) SB1  "
		cQuery += " WHERE  "
		cQuery += " D3_COD = B1_COD  "
		cQuery += " AND D3_EMISSAO >= '"+dtos(dInicio)+"' AND D3_EMISSAO <= '"+dtos(dFinal)+"'  "
		cQuery += " AND D3_ESTORNO = '' "
		cQuery += " AND D3_OP <> ''  "
		cQuery += " AND D3_CUSTO1<> 0 "
		cQuery += " AND SB1.D_E_L_E_T_ = '' AND SD3.D_E_L_E_T_ = '' "
		cQuery += " AND B1_FILIAL='' AND D3_FILIAL='"+xFilial("SD3")+"' "
		cQuery += " AND B1_TIPO<>'MO' "
		cQuery += " GROUP BY D3_FILIAL,D3_COD, B1_DESC "

		cQuery += " UNION ALL "

		//Material sem OP
		cQuery += "     SELECT D3_FILIAL,D3_COD AS CODIGO, B1_DESC AS DESCRICAO,  "
		cQuery += " (SELECT COUNT(*) FROM "
		cQuery += " ( SELECT R_E_C_N_O_ FROM SD3010 (NOLOCK) WHERE D3_EMISSAO >= '"+dtos(dInicio)+"' AND D3_EMISSAO <= '"+dtos(dFinal)+"' AND D3_ESTORNO = '' "
		cQuery += " AND D3_OP = ''  AND D3_ESTORNO = ''  AND LEFT(D3_CF,2) IN ('RE') AND D3_TM <> '999'  AND SD3010.D_E_L_E_T_ = '' AND D3_COD = SD3.D3_COD GROUP BY R_E_C_N_O_ ) TMP1 ) NUM_OPS "
		cQuery += " FROM SD3010 (NOLOCK) SD3, SB1010 (NOLOCK) SB1 "
		cQuery += " WHERE  "
		cQuery += " D3_COD = B1_COD  "
		cQuery += " AND D3_EMISSAO >= '"+dtos(dInicio)+"' AND D3_EMISSAO <= '"+dtos(dFinal)+"'  "
		cQuery += " AND D3_ESTORNO = '' "
		cQuery += " AND D3_OP = ''  "
		cQuery += " AND LEFT(D3_CF,2) IN ('RE')  "
		cQuery += " AND D3_TM <> '999' "
		cQuery += " AND D3_CUSTO1<> 0 "
		cQuery += " AND SB1.D_E_L_E_T_ = '' AND SD3.D_E_L_E_T_ = ''  "
		cQuery += " AND B1_FILIAL='' AND D3_FILIAL='"+xFilial("SD3")+"' "
		cQuery += " AND B1_TIPO<>'MO' "
		cQuery += " GROUP BY D3_FILIAL,D3_COD, B1_DESC "

		cQuery += " UNION ALL "

		//Material saidas NF
		cQuery += " SELECT D2_FILIAL,D2_COD AS CODIGO, B1_DESC AS DESCRICAO,  "

		cQuery += " (SELECT COUNT(*) FROM "
		cQuery += " ( SELECT R_E_C_N_O_ FROM SD2010 (NOLOCK) WHERE D2_EMISSAO >= '"+dtos(dInicio)+"' AND D2_EMISSAO <= '"+dtos(dFinal)+"' "
		cQuery += " AND D2_CUSTO1<> 0   AND SD2010.D_E_L_E_T_ = '' AND D2_COD = SD2.D2_COD GROUP BY R_E_C_N_O_ ) TMP1 ) NUM_OPS "

		cQuery += "       FROM SD2010 (NOLOCK) SD2, SB1010 (NOLOCK) SB1 "
		cQuery += " WHERE  "
		cQuery += " D2_COD = B1_COD  "
		cQuery += " AND D2_EMISSAO >= '"+dtos(dInicio)+"' AND D2_EMISSAO <= '"+dtos(dFinal)+"'  "
		cQuery += " AND D2_CUSTO1<> 0 "
		cQuery += " AND SB1.D_E_L_E_T_ = '' AND SD2.D_E_L_E_T_ = '' "
		cQuery += " AND B1_FILIAL='' AND D2_FILIAL='"+xFilial("SD2")+"' "
		cQuery += " AND B1_TIPO<>'MO' "
		cQuery += " GROUP BY D2_FILIAL,D2_COD, B1_DESC  "

		cQuery += " UNION ALL "

		//Material entradas NF
		cQuery += " SELECT D1_FILIAL,D1_COD AS CODIGO, B1_DESC AS DESCRICAO,  "
		cQuery += " (SELECT COUNT(*) FROM "
		cQuery += " ( SELECT R_E_C_N_O_ FROM SD1010 (NOLOCK) WHERE D1_EMISSAO >= '"+dtos(dInicio)+"' AND D1_EMISSAO <= '"+dtos(dFinal)+"' "
		cQuery += " AND D1_CUSTO<> 0   AND SD1010.D_E_L_E_T_ = '' AND D1_COD = SD1.D1_COD GROUP BY R_E_C_N_O_ ) TMP1 ) NUM_OPS "
		cQuery += " FROM SD1010 (NOLOCK) SD1, SB1010 (NOLOCK) SB1, SF4010 (NOLOCK) SF4 "
		cQuery += " WHERE  "
		cQuery += " D1_COD = B1_COD  "
		cQuery += " AND D1_TES=F4_CODIGO AND F4_ESTOQUE='S' "
		cQuery += " AND D1_EMISSAO >= '"+dtos(dInicio)+"' AND D1_EMISSAO <= '"+dtos(dFinal)+"'  "
		cQuery += " AND D1_CUSTO<> 0  "
		cQuery += " AND SB1.D_E_L_E_T_ = '' AND SD1.D_E_L_E_T_ = '' AND SF4.D_E_L_E_T_='' "
		cQuery += " AND B1_FILIAL='' AND D1_FILIAL='"+xFilial("SD1")+"' AND F4_FILIAL='"+xFilial("SF4")+"' "
		cQuery += " AND B1_TIPO<>'MO' "
		cQuery += " GROUP BY D1_FILIAL,D1_COD, B1_DESC  "
		cQuery += " ) AS PRODUTO "
		cQuery += " GROUP BY PRODUTO.D3_FILIAL, CODIGO, DESCRICAO "//, TOTOP.TOTOP "
		cQuery += " ORDER BY NUM_OPS DESC "

		If Select("TMP") <> 0
			TMP->( dbCloseArea() )
		EndIf

		TCQUERY cQuery NEW ALIAS "TMP"

		While TMP->(!EOF())
			nQTTOT +=  TMP->NUM_OPS
			TMP->(dbskip())
		Enddo

		IF nQTTOT > 0
			nQtd65A := nQTTOT * 0.65
			nQtd25A := nQTTOT * 0.25
			nQtd10A := nQTTOT * 0.10
		EndIf

		TMP->(DBGOTOP())
		While TMP->(!EOF())
			If nQtd65A >= TMP->NUM_OPS .AND. nQtd65A > 0
				nPos  := aScan(aClass,{|x|Alltrim(x[1])==alltrim(TMP->CODIGO)})
				If !Empty(nPos)
					aClass[nPos][3] := "A"
					aClass[nPos][6] := TMP->NUM_OPS
					aClass[nPos][7] := nQTTOT
				EndIf
				nQtd65A -= TMP->NUM_OPS
			ElseIf nQtd25A >= TMP->NUM_OPS .AND. nQtd25A > 0
				nPos  := aScan(aClass,{|x|Alltrim(x[1])==alltrim(TMP->CODIGO)})
				If !Empty(nPos)
					aClass[nPos][3] := "B"
					aClass[nPos][6] := TMP->NUM_OPS
					aClass[nPos][7] := nQTTOT
				EndIf
				nQtd25A -= TMP->NUM_OPS
				nQtd65A := 0
			Else
				nPos  := aScan(aClass,{|x|Alltrim(x[1])==alltrim(TMP->CODIGO)})
				If !Empty(nPos)
					aClass[nPos][3] := "C"
					aClass[nPos][6] := TMP->NUM_OPS
					aClass[nPos][7] := nQTTOT
				EndIf
			Endif
			TMP->(dbskip())
		Enddo
	EndIf



	If len(aClass) > 0

		cQuery := " SELECT B9_COD FROM SB9010 (NOLOCK) "
		cQuery += " WHERE D_E_L_E_T_='' AND B9_DATA='"+DTOS(dUlmes)+"' AND B9_FILIAL='01' AND B9_VINI1<>0 "
		cQuery += " GROUP BY B9_COD "

		If Select("TMPS") <> 0
			TMPS->( dbCloseArea() )
		EndIf

		TCQUERY cQuery NEW ALIAS "TMPS"

		While TMPS->(!EOF())
			nPos  := aScan(aClass,{|x|Alltrim(x[1])==alltrim(TMPS->B9_COD)})
			If Empty(nPos)
				AADD( aClass, {TMPS->B9_COD, "S", "M",0, 0, 0, 0}) //SLOW MOVE
			EndIf
			TMPS->(dbskip())
		Enddo

		For x := 1 to len(aClass)

			If SB1->(DbSeek(xFilial()+aClass[x][1]))
				cDescPr := SB1->B1_DESC

				RecLock("SB1",.F.)
				SB1->B1_XCLASIN := aClass[x][2]+''+aClass[x][3]
				SB1->(MsUnlock())

				Reclock("ZZS",.T.)
				ZZS->ZZS_FILIAL := xFilial("ZZS")
				ZZS->ZZS_CODIGO := cCodigo
				ZZS->ZZS_DATA   := dDatabase
				ZZS->ZZS_PRODUT := aClass[x][1]
				ZZS->ZZS_DESCRI := cDescPr
				ZZS->ZZS_CLASV  := aClass[x][2]
				ZZS->ZZS_CLASQ  := aClass[x][3]
				ZZS->ZZS_VLPROD := aClass[x][4]
				ZZS->ZZS_VLTOT  := aClass[x][5]
				ZZS->ZZS_QTPROD := aClass[x][6]
				ZZS->ZZS_QTTOT  := aClass[x][7]
				ZZS->(MsUnlock())

			EndIf


		Next x

	EndIf


	CONOUT("Fim")
	aClass := {}
Return

//Funcao para geração de inventario
User Function ZZRGER01()


    FWMsgRun(, {|oSay| fProcCla() }, "Processando", "Classificando produtos...")         
	FWMsgRun(, {|oSay| fProcInv() }, "Processando", "Gerando inventario...")

Return



Static function fProcInv()
	Local cQuery    := ""
	Local cPeriodo  := ""
	Local dUltInv   := CTOD("  /  /  ")
	Local aLstInv   := {}
	Local aTPClas   := {}
	Local nPosProd  := 1
	Local nPosDesc  := 2
	Local nPosArm   := 3
	Local nPosDInv  := 4
	Local nPosClas  := 5
	Local nPosTP    := 6
	Local dInv4x    := CTOD("  /  /  ")
	Local dInv2x    := CTOD("  /  /  ")
	Local dInv1x    := CTOD("  /  /  ")
	Local nPos      := 0
	Local dUltDia   := LastDate(monthsub(dDataBase,1))               //Getmv("MV_ULMES")
	Local aSaldoEst := {}
	local dInvUlt   := CTOD("  /  /  ")
	local aLstFinal := {}
	local aLSTDias  := {}
	local dDiaIni   := ctod("  /  /  ")
	local dDiaFim   := LastDate(DDATABASE)
	Local dPriDiaAno := STOD(str(YEAR(DATE()))+'0101') 
	Local nCount     := 0
	

//SELECIONA ULTIMO INVENTARIO CICLICO GERADO
	cQuery := " SELECT (CASE WHEN MAX(ZZR_DTPLAN) IS NULL THEN CONVERT(VARCHAR(10), DATEADD(month, -1, GETDATE()), 112) ELSE MAX(ZZR_DTPLAN) END) AS DTULT FROM ZZR010 (NOLOCK) WHERE D_E_L_E_T_='' AND ZZR_FILIAL='"+xFilial("ZZR")+"' "


	If Select("TMP") <> 0
		TMP->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "TMP"

	If TMP->(!EOF())
		dUltInv  := STOD(TMP->DTULT)
		cPeriodo := ANOMES(MONTHSUM(dUltInv,1)) + "01"
	EndIF

	
	If STOD(cPeriodo) > DDATABASE
		APMSGINFO("ATENÇÃO !!!! Já existe inventário gerado para o perÍodo ATUAL ")
		Return
	EndIf

	ZZR->(dbSetOrder(1))
	If ZZR->(dbSeek(xFilial("ZZR") + cPeriodo ))
		APMSGINFO("ATENÇÃO !!!! Já existe inventário gerado para o perÍodo "+SUBSTR(cPeriodo,1,4))
		Return
	EndIf


    cQuery := " SELECT * FROM SB1010 (NOLOCK) WHERE D_E_L_E_T_='' AND B1_XCLASIN <> '' AND B1_FILIAL='"+xFilial("SB1")+"' ORDER BY B1_XCLASIN "

	//cQuery := " SELECT ZZS_PRODUT AS PRODUTO, ZZS_DESCRI AS DESCRICAO, ZZS_CLASV++ZZS_CLASQ AS CLAS FROM ZZS010 (NOLOCK) "
	//cQuery += " WHERE D_E_L_E_T_='' AND ZZS_CODIGO='000007' "//AND ZZS_PRODUT='10118SM20125PR' "
	//cQuery += " GROUP BY ZZS_PRODUT, ZZS_DESCRI, ZZS_CLASV,ZZS_CLASQ "
	//cQuery += " ORDER BY ZZS_CLASV, ZZS_CLASQ "


	If Select("INV") <> 0
		INV->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "INV"

	SB2->(dbSetOrder(1))
	While INV->(!EOF())
		If SB2->(DbSeek(xFilial("SB2")+INV->B1_COD)) 
			While SB2->(!EOF()) .AND. xFilial("SB2") == SB2->B2_FILIAL .AND. SB2->B2_COD == INV->B1_COD
				//Armazens excluidos da contagem
				If SB2->B2_LOCAL == "  " .OR. alltrim(SB2->B2_LOCAL) $ "03/04/05/06/07/08/09/10/11/12/14/19/30/50/60/92/93/95/96/97/98/99/  /CA/RE/PI" 
					SB2->(dbskip())
					LOOP
				EndIF
				//SB1->(DbSeek(xFilial("SB1")+INV->B1_COD))		
				//PA COM OU SEM SALDO NO 13 NAO GERA CONTAGEM		
				If INV->B1_TIPO == 'PA' .AND. alltrim(SB2->B2_LOCAL) = "13" 
					SB2->(dbskip())
					LOOP
				EndIF

				If SB9->(dbSeek(xFilial("SB9") + SB2->B2_COD + SB2->B2_LOCAL + DTOS(dUltDia)))
					If SB9->B9_QINI != 0
						dInvUlt := fultinv(SB2->B2_COD, SB2->B2_LOCAL)
						dInvUlt := if(Empty(dInvUlt),if(SB2->B2_DINVENT<dPriDiaAno,ctod('  /  /  '),SB2->B2_DINVENT),dInvUlt)
						If Empty(dInvUlt) 
							AADD(aLstInv, {SB2->B2_COD, INV->B1_DESC, SB2->B2_LOCAL, dInvUlt, INV->B1_XCLASIN, INV->B1_TIPO } )
						Else
							If INV->B1_XCLASIN == 'SM' 
								AADD(aLstInv, {SB2->B2_COD, INV->B1_DESC, SB2->B2_LOCAL, dInvUlt, INV->B1_XCLASIN, INV->B1_TIPO } )
							Else
								If fultmov(SB2->B2_COD, SB2->B2_LOCAL, dInvUlt)
									AADD(aLstInv, {SB2->B2_COD, INV->B1_DESC, SB2->B2_LOCAL, dInvUlt, INV->B1_XCLASIN, INV->B1_TIPO } )
								EndIf
							EndIf
						EndIf						
				    EndIf
				Else
					aSaldoEst := CalcEst(SB2->B2_COD, SB2->B2_LOCAL, dUltDia + 1 )
					If aSaldoEst[1] != 0
						dInvUlt := fultinv(SB2->B2_COD, SB2->B2_LOCAL)
						dInvUlt := if(Empty(dInvUlt),if(SB2->B2_DINVENT<dPriDiaAno,ctod('  /  /  '),SB2->B2_DINVENT),dInvUlt)
						If Empty(dInvUlt)  
							AADD(aLstInv, {SB2->B2_COD, INV->B1_DESC, SB2->B2_LOCAL, dInvUlt, INV->B1_XCLASIN, INV->B1_TIPO } )
						Else
							If INV->B1_XCLASIN == 'SM' 
								AADD(aLstInv, {SB2->B2_COD, INV->B1_DESC, SB2->B2_LOCAL, dInvUlt, INV->B1_XCLASIN, INV->B1_TIPO } )
							Else
								If fultmov(SB2->B2_COD, SB2->B2_LOCAL, dInvUlt)
									AADD(aLstInv, {SB2->B2_COD, INV->B1_DESC, SB2->B2_LOCAL, dInvUlt, INV->B1_XCLASIN, INV->B1_TIPO } )
								EndIf
							EndIf
						EndIf
					EndIF
				EndIf			
			SB2->(dbskip())
		  	EndDo
	    EndIf
		INV->(dbskip())
	EndDo

	dInv4x := LastDate(monthsub(STOD(cPeriodo),4))
	dInv2x := LastDate(monthsub(STOD(cPeriodo),7))
	dInv1x := LastDate(monthsub(STOD(cPeriodo),13))

	AADD(aTPClas, {"AA", dInv4x } )
	AADD(aTPClas, {"AB", dInv2x } )
	AADD(aTPClas, {"AC", dInv2x } )
	AADD(aTPClas, {"BA", dInv2x } )
	AADD(aTPClas, {"BB", dInv2x } )
	AADD(aTPClas, {"BC", dInv1x } )
	AADD(aTPClas, {"CA", dInv2x } )
	AADD(aTPClas, {"CB", dInv1x } )
	AADD(aTPClas, {"CC", dInv1x } )
	AADD(aTPClas, {"SM", dInv1x } )

	For x := 1 to len(aLstInv)
		nPos := aScan(aTPClas,{|aVet| aVet[1] == aLstInv[x][nPosClas]})
		If !Empty(nPos)
			If aLstInv[x][nPosDInv] <= aTPClas[nPos][2]
				
                AADD(aLstFinal,{xFilial("ZZR"),STOD(cPeriodo), aLstInv[x][nPosProd], aLstInv[x][nPosDesc],aLstInv[x][nPosArm],aLstInv[x][nPosClas], "G", aLstInv[x][nPosTP] }) 
            /*
				Reclock("ZZR",.t.)
				ZZR->ZZR_FILIAL  := xFilial("ZZR")
				ZZR->ZZR_DTPLAN  := STOD(cPeriodo)
				ZZR->ZZR_PRODUT  := aLstInv[x][nPosProd]
				ZZR->ZZR_DESCRI  := aLstInv[x][nPosDesc]
				ZZR->ZZR_LOCAL   := aLstInv[x][nPosArm]
				ZZR->ZZR_CLASSI  := aLstInv[x][nPosClas]
				ZZR->ZZR_STATUS  := "G"
				ZZR->(MsUnlock())
			*/
            EndIf
		EndIf
	Next x

	dDiaIni := STOD(cPeriodo)
	
	For Nv := dDiaIni to dDiaFim
		If dow(Nv) != 1 .AND. dow(Nv) != 7
			AADD(aLSTDias, {Nv, 0} )			
		EndIf
	Next Nv

	nNumero := ROUND(len(aLstFinal) / len(aLSTDias),2)
	nNumero := INT(nNumero)

	For y := 1 to len(aLSTDias)		
		aLSTDias[y][2] := nNumero
	Next y

	For Nz := 1 to Len(aLstFinal)
		For Nx := 1 To Len(aLSTDias)
			If Nx < Len(aLSTDias)
				If aLSTDias[Nx][2] != 0 	
				    nCount	+= 1			
					Reclock("ZZR",.t.)
					ZZR->ZZR_FILIAL  := aLstFinal[Nz][1]
					ZZR->ZZR_DTPLAN  := aLSTDias[Nx][1]
					ZZR->ZZR_PRODUT  := aLstFinal[Nz][3]
					ZZR->ZZR_DESCRI  := aLstFinal[Nz][4]
					ZZR->ZZR_LOCAL   := aLstFinal[Nz][5]
					ZZR->ZZR_CLASSI  := aLstFinal[Nz][6]
					ZZR->ZZR_TIPO    := aLstFinal[Nz][8]
					ZZR->ZZR_PERIOD  := SUBSTR(cPeriodo,1,6)
					ZZR->ZZR_SEQ     := STRZERO(nCount,4)
					ZZR->ZZR_STATUS  := "G"
					ZZR->(MsUnlock())			
					aLSTDias[Nx][2] := aLSTDias[Nx][2] - 1
					Exit
				EndIf
			ElseIf  Nx == Len(aLSTDias)
				nCount	+= 1
				Reclock("ZZR",.t.)
				ZZR->ZZR_FILIAL  := aLstFinal[Nz][1]
				ZZR->ZZR_DTPLAN  := aLSTDias[Nx][1]
				ZZR->ZZR_PRODUT  := aLstFinal[Nz][3]
				ZZR->ZZR_DESCRI  := aLstFinal[Nz][4]
				ZZR->ZZR_LOCAL   := aLstFinal[Nz][5]
				ZZR->ZZR_CLASSI  := aLstFinal[Nz][6]
				ZZR->ZZR_TIPO    := aLstFinal[Nz][8]
				ZZR->ZZR_PERIOD  := SUBSTR(cPeriodo,1,6)
				ZZR->ZZR_SEQ     := STRZERO(nCount,4)
				ZZR->ZZR_STATUS  := "G"
				ZZR->(MsUnlock())	
				aLSTDias[Nx][2] := aLSTDias[Nx][2] - 1
				Exit
			EndIf
		Next Nx	
	Next Nz	

	ZZR->(dbSetOrder(1))
	If ZZR->(dbSeek(xFilial("ZZR") + cPeriodo ))
		APMSGINFO("Inventário cíclico gerado, perÍodo "+SUBSTR(cPeriodo,1,4))
	EndIf

Return

Static function fultinv(cProd, cArm)
	Local dInv := CTOD('  /  /  ')

	cQuery := " SELECT MAX(ZZR_DTREAL) AS DTINV FROM ZZR010 (NOLOCK) WHERE D_E_L_E_T_='' AND ZZR_FILIAL='"+xFilial("ZZR")+"' AND ZZR_PRODUT='"+cProd+"' AND ZZR_LOCAL='"+cArm+"' "
	cQuery += " AND ZZR_DTREAL>= (convert(varchar, year(getdate()))+'0101') "

	If Select("TMP") <> 0
		TMP->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "TMP"

	If TMP->(!EOF())
		dInv := STOD(TMP->DTINV)
	EndIf

Return dInv

Static function fultmov(cProd, cArm, dDta)

//MOVIMENTO PRODUCAO
	cQuery := " SELECT TOP 1 R_E_C_N_O_ AS REC FROM SD3010 (NOLOCK) WHERE D_E_L_E_T_='' AND D3_ESTORNO='' AND D3_FILIAL='"+xFilial("SD3")+"' AND D3_COD='"+cProd+"' AND D3_LOCAL='"+cArm+"' AND D3_EMISSAO>='"+dtos(dDta)+"' "

	If Select("TMP") <> 0
		TMP->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "TMP"

	If TMP->(!EOF())
		Return .T.
	EndIf

//NF ENTRADA
	cQuery := " SELECT TOP 1 R_E_C_N_O_ AS REC FROM SD1010 (NOLOCK) WHERE D_E_L_E_T_=''  AND D1_FILIAL='"+xFilial("SD1")+"' AND D1_COD='"+cProd+"' AND D1_LOCAL='"+cArm+"' AND D1_DTDIGIT>='"+dtos(dDta)+"' "

	If Select("TMP") <> 0
		TMP->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "TMP"

	If TMP->(!EOF())
		Return .T.
	EndIf


//NF SAIDA
	cQuery := " SELECT TOP 1 R_E_C_N_O_ AS REC FROM SD2010 (NOLOCK) WHERE D_E_L_E_T_=''  AND D2_FILIAL='"+xFilial("SD2")+"' AND D2_COD='"+cProd+"' AND D2_LOCAL='"+cArm+"' AND D2_EMISSAO>='"+dtos(dDta)+"' "

	If Select("TMP") <> 0
		TMP->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "TMP"

	If TMP->(!EOF())
		Return .T.
	EndIf


Return .F.
