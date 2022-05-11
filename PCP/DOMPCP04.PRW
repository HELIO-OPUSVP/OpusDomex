#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"
#Include "protheus.ch"
#Include "colors.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMPCP04  ºAutor  ³Helio Ferreira      º Data ³  18/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório de Planejamento de Produção                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMPCP04()
	Private cPerg  := "DOMPCP04"
	Private oReport
	Private cFilterUser
	Private oSection1
	Private oFont , oFontN
	Private cTitulo
	Private cXXREVIM := ''
	Private mv_par05orig
	Private nMinMax :=0     // MLS 13/06/2017
	Private SC2Filial := xFilial("SC2")

	If Pergunte(cPerg,.T.)
		oReport:=ReportDef()
		oReport:PrintDialog()
	EndIf

Return


Static Function ReportDef()

    //Local _cPictTit := "@E@Z 99999,999.99"
	Local oSection1

	cTitulo:= "Planejamento de Produção Filial: " + xFilial("SC2")
	oFontN :=TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)// Negrito
	oFont  :=TFont():New("Times New Roman",08,08,,.F.,,,,.F.,.F.)

	oReport   :=TReport():New("DOMPCP04",cTitulo,cPerg,{|oReport| ReportPrin(oReport)},"Este relatório exibirá as OPs e suas respectivas datas de Produção.")

	mv_par05orig := mv_par05

	If Alltrim(mv_par05) == 'DIO'
		mv_par05 := "DIO','DIOE"
	ElseIf Alltrim(mv_par05) == 'TRUE' .Or. Alltrim(mv_par05) == 'TRUN'
		mv_par05 := "TRUE','TRUN"
	Else
		If Alltrim(mv_par05) == 'CORD'
			mv_par05 := "CORD"
		EndIf
	EndIf

	oReport:SetLandScape()

	oSection1:=TRSection():New(oReport,"","SC2",{},.F./*aOrder*/,.F./*lLoadCells*/,""/*cTotalText*/,.F./*lTotalInCol*/,.F./*lHeaderPage*/,.F./*lHeaderBreak*/)

	TRCell():New(oSection1,"C2_XXDTPRO"       ,,"Data Produção"      , ,020,.F.,)
	TRCell():New(oSection1,"C2_PRIOR"         ,,"Prior." 				  , ,010,.F.,)
	TRCell():New(oSection1,"C2_OP"            ,,"Ordem Produção"  	  , ,025,.F.,)
	TRCell():New(oSection1,"B1_GRUPO"         ,,"Grupo"              , ,008,.F.,)
	TRCell():New(oSection1,"C2_PRODUTO"       ,,"Produto"            , ,030,.F.,)
	TRCell():New(oSection1,"B1_DESC"          ,,"Descrição"          , ,070,.F.,)
	TRCell():New(oSection1,"C2_QUANT"         ,,"Qtd. Original"      , ,015,.F.,)
	TRCell():New(oSection1,"SALDO"            ,,"Saldo"              , ,015,.F.,)
	TRCell():New(oSection1,"MINUTOS"          ,,"Minutos"            , ,020,.F.,)
	TRCell():New(oSection1,"C2_CLIENT"        ,,"Cliente"            , ,015,.F.,)
	TRCell():New(oSection1,"C2_NCLIENT"       ,,"Nome"               , ,042,.F.,)
	TRCell():New(oSection1,"C2_PEDIDO"        ,,"Pedido"             , ,020,.F.,)
	TRCell():New(oSection1,"C2_ITEMPV"        ,,"Item"               , ,008,.F.,)
	TRCell():New(oSection1,"DTFAT"            ,,"Dt. Fatura"         , ,020,.F.,)
	TRCell():New(oSection1,"C2_OBS"           ,,"Obs"                , ,032,.F.,)

	oSection1:SetHeaderPage(.T.)

	oSection1:Cell("C2_XXDTPRO"):SetHeaderAlign("RIGHT")
	oSection1:Cell("C2_XXDTPRO"):SetAlign("LEFT")
	oSection1:Cell("C2_XXDTPRO"):SetSize(20)  //25

	oSection1:Cell("C2_PRIOR"):SetHeaderAlign("LEFT")
	oSection1:Cell("C2_PRIOR"):SetAlign("LEFT")
	oSection1:Cell("C2_PRIOR"):SetSize(10)

	oSection1:Cell("C2_OP"):SetHeaderAlign("LEFT")
	oSection1:Cell("C2_OP"):SetAlign("LEFT")
	oSection1:Cell("C2_OP"):SetSize(25)

	oSection1:Cell("B1_GRUPO"):SetHeaderAlign("LEFT")
	oSection1:Cell("B1_GRUPO"):SetAlign("LEFT")
	oSection1:Cell("B1_GRUPO"):SetSize(08)

	oSection1:Cell("C2_PRODUTO"):SetHeaderAlign("LEFT")
	oSection1:Cell("C2_PRODUTO"):SetAlign("LEFT")
	oSection1:Cell("C2_PRODUTO"):SetSize(30)  //35

	oSection1:Cell("B1_DESC"):SetHeaderAlign("LEFT")
	oSection1:Cell("B1_DESC"):SetAlign("LEFT")
	oSection1:Cell("B1_DESC"):SetSize(70)  //62

	oSection1:Cell("C2_QUANT"):SetHeaderAlign("RIGHT")
	oSection1:Cell("C2_QUANT"):SetAlign("RIGHT")
	oSection1:Cell("C2_QUANT"):SetSize(15)
	oSection1:Cell("C2_QUANT"):SetPicture("@R")

	oSection1:Cell("SALDO"):SetHeaderAlign("RIGHT")
	oSection1:Cell("SALDO"):SetAlign("RIGHT")
	oSection1:Cell("SALDO"):SetSize(15)
	oSection1:Cell("SALDO"):SetPicture("@R")

	oSection1:Cell("MINUTOS"):SetHeaderAlign("RIGHT")
	oSection1:Cell("MINUTOS"):SetAlign("RIGHT")
	oSection1:Cell("MINUTOS"):SetSize(20)
	oSection1:Cell("MINUTOS"):SetPicture("@E 99,999.9")

	oSection1:Cell("Cliente"):SetHeaderAlign("LEFT")
	oSection1:Cell("Cliente"):SetAlign("LEFT")
	oSection1:Cell("Cliente"):SetSize(15)

	oSection1:Cell("Nome"):SetHeaderAlign("LEFT")
	oSection1:Cell("Nome"):SetAlign("LEFT")
	oSection1:Cell("Nome"):SetSize(42)

	oSection1:Cell("Pedido"):SetHeaderAlign("LEFT")
	oSection1:Cell("Pedido"):SetAlign("LEFT")
	oSection1:Cell("Pedido"):SetSize(20)

	oSection1:Cell("Item"):SetHeaderAlign("LEFT")
	oSection1:Cell("Item"):SetAlign("LEFT")
	oSection1:Cell("Item"):SetSize(08)

	oSection1:Cell("Dt. Fatura"):SetHeaderAlign("LEFT")
	oSection1:Cell("Dt. Fatura"):SetAlign("LEFT")
	oSection1:Cell("Dt. Fatura"):SetSize(20)

	oSection1:Cell("Obs"):SetHeaderAlign("LEFT")
	oSection1:Cell("Obs"):SetAlign("LEFT")
	oSection1:Cell("Obs"):SetSize(32)

Return oReport

//---------------------------------------------------------

Static Function ReportPrin(oReport)
	Local oSection1 := oReport:Section(1)
	//Local nOrdem    := oSection1:GetOrder()
	Local _cAlias   := GetNextAlias()
//Local _cOrder   := "%C2_PRIOR%"//"%C2_XXREVIM,B1_GRUPO,C2_XXDTPRO,C2_NUM,C2_ITEM,C2_SEQUEN%"
//Local _cOrder   := "%C2_XXREVIM,B1_GRUPO,C2_XXDTPRO,C2_NUM,C2_ITEM,C2_SEQUEN%"
	Local _cOrder   := "%C2_XXDTPRO,C2_XXREVIM,C2_PRIOR,B1_GRUPO,C2_NUM,C2_ITEM,C2_SEQUEN%"

//Documentando CASE no meio da SELECT
//CASE B1_GRUPO 	WHEN 'DIOE' THEN 'DIO'
//					   WHEN 'TRUE' THEN 'CORD'
//ELSE B1_GRUPO   END as B1_GRUPO,

	oReport:SetTitle(cTitulo)
	
	If mv_par07 == 1  // inclui OPs encerradas
		BeginSql Alias _cAlias
		SELECT  C2_PRIOR,C2_XXDTPRO, C2_NUM+C2_ITEM+C2_SEQUEN AS C2_OP,C2_PRODUTO,B1_DESC, C2_QUANT, C2_QUANT - C2_QUJE AS SALDO,
		B1_GRUPO,C2_CLIENT,C2_NCLIENT,C2_PEDIDO,C2_ITEMPV,C2_OBS,SC2.R_E_C_N_O_ AS C2_RECNO,C2_XXREVIM
		FROM %table:SC2% SC2, %table:SB1% SB1
		WHERE SC2.%notDel% AND SB1.%notDel%
		AND B1_COD = C2_PRODUTO
		AND C2_NUM+C2_ITEM+C2_SEQUEN >= %Exp:mv_par01%
		AND C2_NUM+C2_ITEM+C2_SEQUEN <= %Exp:mv_par02%
		AND C2_XXDTPRO               >= %Exp:mv_par03%
		AND C2_XXDTPRO               <= %Exp:mv_par04%
		AND ( B1_GRUPO                IN (%Exp:mv_par05%) )
		AND C2_FILIAL                 = %Exp:SC2Filial%
		ORDER BY %Exp:_cOrder%
		EndSql

		// Armazenando as maiores revisões
		TcSetField(_cAlias,"C2_XXDTPRO","D",  8, 0)
		aDtMaxRev := {}
		While (_cAlias)->(!Eof())
			nTemp := aScan(aDtMaxRev,{|aVet| aVet[1] == (_cAlias)->C2_XXDTPRO })
			If nTemp == 0
				AADD(aDtMaxRev,{(_cAlias)->C2_XXDTPRO,(_cAlias)->C2_XXREVIM})
			Else
				If (_cAlias)->C2_XXREVIM > aDtMaxRev[nTemp,2]
					aDtMaxRev[nTemp,2] := (_cAlias)->C2_XXREVIM
				EndIf
			EndIf
			(_cAlias)->( dbSkip() )
		EndDo

		// Gravando o número das revisões
		(_cAlias)->(dbGoTop())
		While (_cAlias)->(!Eof())
			If Empty((_cAlias)->C2_XXREVIM)
				nTemp := aScan(aDtMaxRev,{|aVet| aVet[1] == (_cAlias)->C2_XXDTPRO })
				SC2->( dbGoTo((_cAlias)->C2_RECNO) )
				If SC2->( Recno() ) == (_cAlias)->C2_RECNO
					Reclock("SC2",.F.)
					SC2->C2_XXREVIM := Soma1(aDtMaxRev[nTemp,2])
					SC2->( msUnlock() )
				EndIf
			EndIf
			(_cAlias)->( dbSkip() )
		EndDo

		//Rodando a Query novamente
		(_cAlias)->( dbCloseArea() )
		BeginSql Alias _cAlias
		SELECT  C2_PRIOR,C2_XXDTPRO, C2_NUM+C2_ITEM+C2_SEQUEN AS C2_OP,C2_PRODUTO,B1_DESC, C2_QUANT, C2_QUANT - C2_QUJE AS SALDO,
		B1_GRUPO,C2_CLIENT,C2_NCLIENT,C2_PEDIDO,C2_ITEMPV,C2_OBS,SC2.R_E_C_N_O_ AS C2_RECNO,C2_XXREVIM
		FROM %table:SC2% SC2, %table:SB1% SB1
		WHERE SC2.%notDel% AND SB1.%notDel%
		AND B1_COD = C2_PRODUTO
		AND C2_NUM+C2_ITEM+C2_SEQUEN >= %Exp:mv_par01%
		AND C2_NUM+C2_ITEM+C2_SEQUEN <= %Exp:mv_par02%
		AND C2_XXDTPRO               >= %Exp:mv_par03%
		AND C2_XXDTPRO               <= %Exp:mv_par04%
		AND ( B1_GRUPO                IN (%Exp:mv_par05%) )
		AND C2_FILIAL                 = %Exp:SC2Filial%
		ORDER BY %Exp:_cOrder%
		EndSql
		TcSetField(_cAlias,"C2_XXDTPRO","D",  8, 0)
	Else
		BeginSql Alias _cAlias
		SELECT  C2_PRIOR,C2_XXDTPRO, C2_NUM+C2_ITEM+C2_SEQUEN AS C2_OP,C2_PRODUTO,B1_DESC, C2_QUANT, C2_QUANT - C2_QUJE AS SALDO,
		B1_GRUPO,C2_CLIENT,C2_NCLIENT,C2_PEDIDO,C2_ITEMPV,C2_OBS,SC2.R_E_C_N_O_ AS C2_RECNO,C2_XXREVIM
		FROM %table:SC2% SC2, %table:SB1% SB1
		WHERE SC2.%notDel% AND SB1.%notDel%
		AND B1_COD = C2_PRODUTO
		AND C2_NUM+C2_ITEM+C2_SEQUEN >= %Exp:mv_par01%
		AND C2_NUM+C2_ITEM+C2_SEQUEN <= %Exp:mv_par02%
		AND C2_XXDTPRO               >= %Exp:mv_par03%
		AND C2_XXDTPRO               <= %Exp:mv_par04%
		AND ( B1_GRUPO               IN (%Exp:mv_par05%) )
		AND C2_DATRF                  = ''
		AND C2_FILIAL                 = %Exp:SC2Filial%
		ORDER BY %Exp:_cOrder%
		EndSql

		// Armazenando as maiores revisões
		TcSetField(_cAlias,"C2_XXDTPRO","D",  8, 0)
		aDtMaxRev := {}
		While (_cAlias)->(!Eof())
			nTemp := aScan(aDtMaxRev,{|aVet| aVet[1] == (_cAlias)->C2_XXDTPRO })
			If nTemp == 0
				AADD(aDtMaxRev,{(_cAlias)->C2_XXDTPRO,(_cAlias)->C2_XXREVIM})
			Else
				If (_cAlias)->C2_XXREVIM > aDtMaxRev[nTemp,2]
					aDtMaxRev[nTemp,2] := (_cAlias)->C2_XXREVIM
				EndIf
			EndIf
			(_cAlias)->( dbSkip() )
		EndDo

		// Gravando o número das revisões
		(_cAlias)->(dbGoTop())
		While (_cAlias)->(!Eof())
			If Empty((_cAlias)->C2_XXREVIM)
				nTemp := aScan(aDtMaxRev,{|aVet| aVet[1] == (_cAlias)->C2_XXDTPRO })
				SC2->( dbGoTo((_cAlias)->C2_RECNO) )
				If SC2->( Recno() ) == (_cAlias)->C2_RECNO
					Reclock("SC2",.F.)
					SC2->C2_XXREVIM := Soma1(aDtMaxRev[nTemp,2])
					SC2->( msUnlock() )
				EndIf
			EndIf
			(_cAlias)->( dbSkip() )
		EndDo

		(_cAlias)->( dbCloseArea() )
		BeginSql Alias _cAlias
		SELECT  C2_PRIOR,C2_XXDTPRO, C2_NUM+C2_ITEM+C2_SEQUEN AS C2_OP,C2_PRODUTO,B1_DESC, C2_QUANT, C2_QUANT - C2_QUJE AS SALDO,
		B1_GRUPO,C2_CLIENT,C2_NCLIENT,C2_PEDIDO,C2_ITEMPV,C2_OBS,SC2.R_E_C_N_O_ AS C2_RECNO,C2_XXREVIM
		FROM %table:SC2% SC2, %table:SB1% SB1
		WHERE SC2.%notDel% AND SB1.%notDel%
		AND B1_COD = C2_PRODUTO
		AND C2_NUM+C2_ITEM+C2_SEQUEN >= %Exp:mv_par01%
		AND C2_NUM+C2_ITEM+C2_SEQUEN <= %Exp:mv_par02%
		AND C2_XXDTPRO               >= %Exp:mv_par03%
		AND C2_XXDTPRO               <= %Exp:mv_par04%
		AND ( B1_GRUPO               IN (%Exp:mv_par05%) )
		AND C2_DATRF                  = ''
		AND C2_FILIAL                 = %Exp:SC2Filial%
		ORDER BY %Exp:_cOrder%
		EndSql

	EndIf

	oSection1:EndQuery()

	oSection1:Init()

	SG1->( dbSetOrder(1) )
	SB1->( dbSetOrder(1) )
	SC6->( dbSetOrder(1) )

	dbSelectArea(_cAlias)

	_nTotMinutos := 0

	cXXREVIM  := (_cAlias)->C2_XXREVIM
	cXXREVIM2 := (_cAlias)->C2_XXREVIM

//While !oReport:Cancel() .And. (_cAlias)->(!Eof())
//	IF (_cAlias)->C2_XXREVIM > cXXREVIM
//		cXXREVIM:=(_cAlias)->C2_XXREVIM
//	ENDIF
//	(_cAlias)->( dbSkip() )
//EndDo

//cXXREVIM:= Soma1(cXXREVIM,1,.T.,.T.)

	(_cAlias)->( DBGOTOP() )

	oSection1:Cell("C2_XXDTPRO") :SetValue("Revisão")
	oSection1:Cell("C2_PRIOR")   :SetValue("")
	IF (_cAlias)->C2_XXREVIM == 'XXX'
		oSection1:Cell("C2_OP")      :SetValue('001')
	ELSE
		oSection1:Cell("C2_OP")      :SetValue((_cAlias)->C2_XXREVIM)
	ENDIF
	oSection1:Cell("B1_GRUPO")   :SetValue("")
	oSection1:Cell("C2_PRODUTO") :SetValue("")
	oSection1:Cell("B1_DESC")    :SetValue("")
	oSection1:Cell("C2_QUANT")   :SetValue("")
	oSection1:Cell("SALDO")      :SetValue("")
	oSection1:Cell("MINUTOS")    :SetValue("")
	oSection1:Cell("C2_CLIENT")  :SetValue("")
	oSection1:Cell("C2_NCLIENT") :SetValue("")
	oSection1:Cell("C2_PEDIDO")  :SetValue("")
	oSection1:Cell("C2_ITEMPV")  :SetValue("")
	oSection1:Cell("DTFAT")      :SetValue("")
	oSection1:Cell("C2_OBS")     :SetValue("")
	oSection1:PrintLine()
	oReport:SkipLine()

	While !oReport:Cancel() .And. (_cAlias)->(!Eof())

		If oReport:Cancel()
			Exit
		EndIf

		IF cXXREVIM2 <> ((_cAlias)->C2_XXREVIM)
			oReport:SkipLine()
			oReport:Box( oReport:Row(),010,oReport:Row(), oReport:PageWidth() )
			oReport:SkipLine()
			IF EMPTY((_cAlias)->C2_XXREVIM)
				oSection1:Cell("C2_XXDTPRO") :SetValue("Revisão")
				oSection1:Cell("C2_PRIOR")   :SetValue("")
				oSection1:Cell("C2_OP")      :SetValue(cXXREVIM)
			ELSE
				oSection1:Cell("C2_XXDTPRO") :SetValue("Revisão")
				oSection1:Cell("C2_PRIOR")   :SetValue("")
				oSection1:Cell("C2_OP")      :SetValue((_cAlias)->C2_XXREVIM)
			ENDIF
			oSection1:Cell("B1_GRUPO")   :SetValue("")
			oSection1:Cell("C2_PRODUTO") :SetValue("")
			oSection1:Cell("B1_DESC")    :SetValue("")
			oSection1:Cell("C2_QUANT")   :SetValue("")
			oSection1:Cell("SALDO")      :SetValue("")
			oSection1:Cell("MINUTOS")    :SetValue("")
			oSection1:Cell("C2_CLIENT")  :SetValue("")
			oSection1:Cell("C2_NCLIENT") :SetValue("")
			oSection1:Cell("C2_PEDIDO")  :SetValue("")
			oSection1:Cell("C2_ITEMPV")  :SetValue("")
			oSection1:Cell("DTFAT")      :SetValue("")
			oSection1:Cell("C2_OBS")     :SetValue("")
			oSection1:PrintLine()
			oReport:SkipLine()
			cXXREVIM2 := ((_cAlias)->C2_XXREVIM)
		ENDIF


		if mv_par05 $ "TRUE|TRUN" .OR. mv_par05orig $ "TRUE|TRUN"
			SG1->( dbSeek( xFilial() + (_cAlias)->C2_PRODUTO + "50010100T" ) )
		ElseIf mv_par05 $ "PCON" .OR. mv_par05orig $ "PCON"
			SG1->( dbSeek( xFilial() + (_cAlias)->C2_PRODUTO + "50010100PC"        ) )
		ElseIf mv_par05 $ "DROP" .OR. mv_par05orig $ "DROP"
			SG1->( dbSeek( xFilial() + (_cAlias)->C2_PRODUTO + "50010100DR"        ) )
		ElseIf mv_par05 $ "JUMPER" .OR. mv_par05orig $ "JUMPER"
			SG1->( dbSeek( xFilial() + (_cAlias)->C2_PRODUTO + "50010100J"        ) )
		ElseIf mv_par05 $ "FTTA" .OR. mv_par05orig $ "FTTA"
			SG1->( dbSeek( xFilial() + (_cAlias)->C2_PRODUTO + "50010100FTTA"        ) )					
		ElseIf mv_par05 $ "CMTP" .OR. mv_par05orig $ "CMTP" 
			SG1->( dbSeek( xFilial() + (_cAlias)->C2_PRODUTO + "50010100DC"        ) )					
		Else
			SG1->( dbSeek( xFilial() + (_cAlias)->C2_PRODUTO + "50010100"        ) )
		Endif

		SB1->( dbSeek( xFilial() + (_cAlias)->C2_PRODUTO                     ) )

		SC6->( dbSeek( xFilial() + (_cAlias)->C2_PEDIDO + (_cAlias)->C2_ITEMPV ) )

		oSection1:Cell("C2_XXDTPRO") :SetValue((_cAlias)->C2_XXDTPRO)
		oSection1:Cell("C2_PRIOR")   :SetValue((_cAlias)->C2_PRIOR)
		oSection1:Cell("C2_OP")      :SetValue((_cAlias)->C2_OP)
		oSection1:Cell("B1_GRUPO")   :SetValue((_cAlias)->B1_GRUPO)
		oSection1:Cell("C2_PRODUTO") :SetValue((_cAlias)->C2_PRODUTO)
		oSection1:Cell("B1_DESC")    :SetValue((_cAlias)->B1_DESC)
		oSection1:Cell("C2_QUANT")   :SetValue(Transform((_cAlias)->C2_QUANT,"@E 999,999,999.99"))
		oSection1:Cell("SALDO")      :SetValue(Transform((_cAlias)->SALDO,"@E 999,999,999.99"))
		oSection1:Cell("MINUTOS")    :SetValue(Round((SG1->G1_QUANT/If(Empty(SB1->B1_QB),1,SB1->B1_QB)) * (_cAlias)->SALDO,1))
		oSection1:Cell("C2_CLIENT")  :SetValue((_cAlias)->C2_CLIENT)
		oSection1:Cell("C2_NCLIENT") :SetValue((_cAlias)->C2_NCLIENT)
		oSection1:Cell("C2_PEDIDO")  :SetValue((_cAlias)->C2_PEDIDO)
		oSection1:Cell("C2_ITEMPV")  :SetValue((_cAlias)->C2_ITEMPV)
		oSection1:Cell("DTFAT")      :SetValue(DtoC(SC6->C6_ENTREG))
		oSection1:Cell("C2_OBS")     :SetValue((_cAlias)->C2_OBS)

		If (_cAlias)->C2_XXREVIM == 'XXX' .and. mv_par08 == 1
			cQUERYREV:=" UPDATE SC2010 SET C2_XXREVIM='"+cXXREVIM+"' WHERE R_E_C_N_O_="+alltrim(str((_cAlias)->C2_RECNO)) // +" AND C2_XXREVIM='' "
			TCSQLEXEC(cQUERYREV)
		EndIf

		_nTotMinutos += Round((SG1->G1_QUANT/If(Empty(SB1->B1_QB),1,SB1->B1_QB)) * (_cAlias)->SALDO,1)

		oSection1:PrintLine()
		oReport:IncMeter()
		oReport:SkipLine()

		_dData  := (_cAlias)->C2_XXDTPRO
		nMinMax := Posicione("SBM",1,xFilial("SBM")+mv_par05orig,"BM_XXPRDIA")

		(_cAlias)->( dbSkip() )             // BM_XXPRDIA

		If _dData  <> (_cAlias)->C2_XXDTPRO .and. !(_cAlias)->( EOF() )
			oSection1:Cell("C2_XXDTPRO") :SetValue("Total Grupo")
			oSection1:Cell("C2_PRIOR")   :SetValue("")
			oSection1:Cell("C2_OP")      :SetValue("")
			oSection1:Cell("B1_GRUPO")   :SetValue("")
			oSection1:Cell("C2_PRODUTO") :SetValue("")
			oSection1:Cell("B1_DESC")    :SetValue("Min. diarios do Grupo: " + Alltrim(Transform(nMinMax,"@E 999,999,999")) + " - " + Alltrim(Transform((_nTotMinutos/nMinMax)*100,"@E 999.99")) + "%")
			oSection1:Cell("C2_QUANT")   :SetValue("")
			oSection1:Cell("SALDO")      :SetValue("")
			oSection1:Cell("MINUTOS")    :SetValue(_nTotMinutos)
			oSection1:Cell("C2_CLIENT")  :SetValue("")
			oSection1:Cell("C2_NCLIENT") :SetValue("")
			oSection1:Cell("C2_PEDIDO")  :SetValue("")
			oSection1:Cell("C2_ITEMPV")  :SetValue("")
			oSection1:Cell("DTFAT")      :SetValue("")
			oSection1:Cell("C2_OBS")     :SetValue("")

			oSection1:PrintLine()
			oReport:IncMeter()
			oReport:SkipLine()
		EndIf

	EndDo

	oSection1:Cell("C2_XXDTPRO") :SetValue("Total Grupo")
	oSection1:Cell("C2_PRIOR")   :SetValue("")
	oSection1:Cell("C2_OP")      :SetValue("")
	oSection1:Cell("B1_GRUPO")   :SetValue("")
	oSection1:Cell("C2_PRODUTO") :SetValue("")
	oSection1:Cell("B1_DESC")    :SetValue("Min. diarios do Grupo: " + Alltrim(Transform(nMinMax,"@E 999,999,999")) + " - " + Alltrim(Transform((_nTotMinutos/nMinMax)*100,"@E 999.99")) + "%")
	oSection1:Cell("C2_QUANT")   :SetValue("")
	oSection1:Cell("SALDO")      :SetValue("")
	oSection1:Cell("MINUTOS")    :SetValue(_nTotMinutos)
	oSection1:Cell("C2_CLIENT")  :SetValue("")
	oSection1:Cell("C2_NCLIENT") :SetValue("")
	oSection1:Cell("C2_PEDIDO")  :SetValue("")
	oSection1:Cell("C2_ITEMPV")  :SetValue("")
	oSection1:Cell("DTFAT")      :SetValue("")
	oSection1:Cell("C2_OBS")     :SetValue("")

	oSection1:PrintLine()
	oReport:IncMeter()
	oReport:SkipLine()

	oSection1:Finish()
	oReport:EndPage()

Return
