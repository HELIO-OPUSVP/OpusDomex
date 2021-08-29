//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Wederson L. Santana - 29/08/12 - OpusVp                                                                                                          //
//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Especifico Domex                                                                                                                                 //
//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Relatório para emissão dos produtos em estoque , sem movimentação .                                                                              //
//-------------------------------------------------------------------------------------------------------------------------------------------------//
#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"
#Include "protheus.ch"
#Include "colors.ch"

User Function DOMEST01()
Private _cPerg :="DOMEST01"+Space(02)
Private oReport
Private cFilterUser
Private oSection1
Private oSection2
Private _cAlias

fCriaPerg()
If Pergunte(_cPerg,.T.)
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf

Return

//-----------------------------------

Static Function ReportDef()
Local _cPictCusto := "@E@Z 999,999,999.99"
Local _cPictQtd   := "@E@Z 99,999,999"
Local _cPictMes   := "@E@Z 999.9"
Local oReport
Local oSection1
Local oSection2
Private _nMeses:= 0

oReport := TReport():New("DOMEST01","Produtos em estoque sem movimento",""/*_cPerg*/,{|oReport| ReportPrint(oReport)},"Este relatório exibirá os produtos em estoque sem movimentação a partir da data informada no parâmetro 'Data de Corte'.")

oReport:SetLandScape()

oSection1 := TRSection():New(oReport,"","SB1",{},.F./*aOrder*/,.F./*lLoadCells*/,""/*cTotalText*/,.F./*lTotalInCol*/,.F./*lHeaderPage*/,.F./*lHeaderBreak*/)

TRCell():New(oSection1,"B1_TIPO"        ,"SB1","Tipo"                ,           ,02,.F.,)
TRCell():New(oSection1,"B1_COD"         ,"SB1","Código"              ,           ,15,.F.,)
TRCell():New(oSection1,"B1_DESC"        ,"SB1","Descrição "          ,           ,60,.F.,)
TRCell():New(oSection1,"LOCAL"          ,""   ,"Local "              ,           ,02,.F.,)
TRCell():New(oSection1,"B1_IMPORT"      ,"SB1","Importado "          ,           ,01,.F.,)
TRCell():New(oSection1,"QTDATU"         ,"SB2","Qtd.Atual"           ,_cPictQtd  ,10,.F.,)
TRCell():New(oSection1,"VLRATU"         ,""   ,"Vr. Atual"           ,_cPictCusto,14,.F.,)
TRCell():New(oSection1,"DOCUMENTO"      ,""   ,"Documento "          ,           ,20,.F.,)
TRCell():New(oSection1,"DATA"           ,""   ,"Data "               ,           ,10,.F.,)
TRCell():New(oSection1,"FORNECEDOR"     ,""   ,"Cli./For."           ,           ,06,.F.,)
TRCell():New(oSection1,"QTD"            ,""   ,"Qtd. NFE "           ,_cPictQtd  ,10,.F.,)
TRCell():New(oSection1,"CUSTO"          ,""   ,"Custo "              ,_cPictCusto,14,.F.,)
TRCell():New(oSection1,"IPI"            ,""   ,"Vr. IPI"             ,_cPictCusto,14,.F.,)
TRCell():New(oSection1,"ICMS"           ,""   ,"Vr. ICMS"            ,_cPictCusto,14,.F.,)
TRCell():New(oSection1,"ICMSST"         ,""   ,"Vr. ICMS ST"         ,_cPictCusto,14,.F.,)

oSection1:SetHeaderPage(.T.)

oSection1:Cell("B1_TIPO"):SetHeaderAlign("LEFT" )
oSection1:Cell("B1_TIPO"):SetAlign("LEFT" )
oSection1:Cell("B1_TIPO"):SetSize(02)

oSection1:Cell("B1_COD")  :SetHeaderAlign("LEFT")
oSection1:Cell("B1_COD")  :SetAlign("LEFT")
oSection1:Cell("B1_COD")  :SetSize(15)

oSection1:Cell("B1_DESC")  :SetHeaderAlign("LEFT")
oSection1:Cell("B1_DESC")  :SetAlign("LEFT")
oSection1:Cell("B1_DESC")  :SetSize(60)

oSection1:Cell("LOCAL")  :SetHeaderAlign("LEFT")
oSection1:Cell("LOCAL")  :SetAlign("LEFT")
oSection1:Cell("LOCAL")  :SetSize(02)

oSection1:Cell("B1_IMPORT"):SetHeaderAlign("LEFT")
oSection1:Cell("B1_IMPORT"):SetAlign("LEFT")
oSection1:Cell("B1_IMPORT"):SetSize(01)

oSection1:Cell("QTDATU"):SetHeaderAlign("RIGHT")
oSection1:Cell("QTDATU"):SetAlign("RIGHT")
oSection1:Cell("QTDATU"):SetSize(10)

oSection1:Cell("VLRATU") :SetHeaderAlign("RIGHT" )
oSection1:Cell("VLRATU") :SetAlign("RIGHT" )
oSection1:Cell("VLRATU") :SetSize(14)

oSection1:Cell("DOCUMENTO"):SetHeaderAlign("LEFT")
oSection1:Cell("DOCUMENTO"):SetAlign("LEFT")
oSection1:Cell("DOCUMENTO"):SetSize(20)

oSection1:Cell("DATA"):SetHeaderAlign("LEFT")
oSection1:Cell("DATA"):SetAlign("RIGHT")
oSection1:Cell("DATA"):SetSize(10)

oSection1:Cell("FORNECEDOR"):SetHeaderAlign("LEFT")
oSection1:Cell("FORNECEDOR"):SetAlign("LEFT")
oSection1:Cell("FORNECEDOR"):SetSize(06)

oSection1:Cell("QTD"):SetHeaderAlign("RIGHT")
oSection1:Cell("QTD"):SetAlign("RIGHT")
oSection1:Cell("QTD"):SetSize(10)

oSection1:Cell("CUSTO") :SetHeaderAlign("RIGHT" )
oSection1:Cell("CUSTO") :SetAlign("RIGHT" )
oSection1:Cell("CUSTO") :SetSize(14)

oSection1:Cell("IPI") :SetHeaderAlign("RIGHT" )
oSection1:Cell("IPI") :SetAlign("RIGHT" )
oSection1:Cell("IPI") :SetSize(14)

oSection1:Cell("ICMS") :SetHeaderAlign("RIGHT" )
oSection1:Cell("ICMS") :SetAlign("RIGHT" )
oSection1:Cell("ICMS") :SetSize(14)

oSection1:Cell("ICMSST") :SetHeaderAlign("RIGHT" )
oSection1:Cell("ICMSST") :SetAlign("RIGHT" )
oSection1:Cell("ICMSST") :SetSize(14)

Return oReport

//---------------------------------------------------------

Static Function ReportPrint(oReport)
Local oSection1 := oReport:Section(1)
Local nOrdem    := oSection1:GetOrder()
Private cLocal  := StrTran(StrTran(Alltrim(Mv_Par08),",","','"),"/","','")
Private cTitulo := "Produtos em estoque sem movimentação em - "+Dtoc(Mv_Par07)+" até "+Dtoc(dDataBase)+If(Empty(Mv_Par08)," - Almoxarifado de "+Mv_Par05+" até "+Mv_Par06+"."," - Almoxarifado(s) '"+cLocal+"'.")

oReport:SetTitle(cTitulo)
_cAlias  := GetNextAlias()
_cOrder  := "%B1_TIPO,B1_COD%"

If Empty(Mv_Par08)
   BeginSql Alias _cAlias
	   SELECT  B1_TIPO,B1_COD,B1_DESC,B1_IMPORT //,B2_QATU,B2_CM1,B2_LOCAL
	   FROM %table:SB1% SB1
	      , %table:SB2% SB2
	   WHERE B1_FILIAL = %Exp:xFilial("SB1")%
	   AND   B2_FILIAL = %Exp:xFilial("SB2")%
	   AND   B1_COD >= %Exp:Mv_Par01%
	   AND   B1_COD <= %Exp:Mv_Par02%
	   AND   B1_COD = B2_COD
	   AND   B2_LOCAL >= %Exp:Mv_Par05%
	   AND   B2_LOCAL <= %Exp:Mv_Par06%
	   AND   B2_QATU > 0
	   AND   SB2.%notDel%
	   AND   SB1.%notDel%
	   GROUP BY B1_TIPO,B1_COD,B1_DESC,B1_IMPORT
	   ORDER BY %Exp:_cOrder%
   EndSql
Else
   BeginSql Alias _cAlias
	   SELECT  B1_TIPO,B1_COD,B1_DESC,B1_IMPORT //,B2_QATU,B2_CM1,B2_LOCAL
	   FROM %table:SB1% SB1
	      , %table:SB2% SB2
	   WHERE B1_FILIAL = %Exp:xFilial("SB1")%
	   AND   B2_FILIAL = %Exp:xFilial("SB2")%
	   AND   B1_COD >= %Exp:Mv_Par01%
	   AND   B1_COD <= %Exp:Mv_Par02%
	   AND   B1_COD = B2_COD
	   AND   B2_LOCAL IN (%Exp:cLocal%)
	   AND   B2_QATU > 0
	   AND   SB2.%notDel%
	   AND   SB1.%notDel%
	   GROUP BY B1_TIPO,B1_COD,B1_DESC,B1_IMPORT
	   ORDER BY %Exp:_cOrder%	
	EndSql
EndIf

//TcSetField(_cAlias,"B2_QATU","N", 10, 0)
//TcSetField(_cAlias,"B2_CM1" ,"N", 14, 2)

oSection1:EndQuery()
oSection1:Init()
dbSelectArea(_cAlias)
While !oReport:Cancel() .And. (_cAlias)->(!Eof())
	_nMeses:=0
	If oReport:Cancel()
		Exit
	EndIf
	
	lContinua := .F.
	If Empty(Mv_Par08)
	   SB2->( dbSeek( xFilial() + (_cAlias)->B1_COD ) )
	   While !SB2->( EOF() ) .and. (_cAlias)->B1_COD == SB2->B2_COD
		      If SB2->B2_QATU <> 0 .and. (SB2->B2_LOCAL >= Mv_par05) .and.  (SB2->B2_LOCAL <= Mv_par06)
			      lContinua := .T.
			      Exit
		      EndIf
		      SB2->( dbSkip() )
	   End
	Else
	   SB2->( dbSeek( xFilial() + (_cAlias)->B1_COD ) )
	   While !SB2->( EOF() ) .and. (_cAlias)->B1_COD == SB2->B2_COD
		      If SB2->B2_QATU <> 0 .and. (SB2->B2_LOCAL $ mv_par08)
			      lContinua := .T.
			      Exit
		      EndIf
		      SB2->( dbSkip() )
	   End
	EndIf
	
	If !lContinua
		(_cAlias)->( dbSkip() )
		Loop
	EndIf
	
	//-----Notas fiscais de entrada
	fSqlSd1()
	//
	
	//-----Movimentos internos
	fSqlSd3()
	//
	
	//-----Notas fiscais de saída
	fSqlSd2()
	//
	
	//Última movimentação no estoque.
	_dData  := SQL_SD1->D1_DTDIGIT
	_cOrigem := "SD1"
	
	If (_dData < SQL_SD2->D2_EMISSAO .and. !Empty(SQL_SD2->D2_EMISSAO)) .or. Empty(_dData)
		_dData  := SQL_SD2->D2_EMISSAO
		_cOrigem := "SD2"
	EndIf
	
	If (_dData < SQL_SD3->D3_EMISSAO .and. !Empty(SQL_SD3->D3_EMISSAO)) .or. Empty(_dData)
		_dData  := SQL_SD3->D3_EMISSAO
		_cOrigem := "SD3"
	EndIf
	
	If _dData < Mv_Par07 .and. !Empty(_dData)
		
		cLocal2 := ''
		If _cOrigem == "SD1" //SQL_SD1->D1_DTDIGIT < SQL_SD3->D3_EMISSAO
			//_dData:=SQL_SD1->D1_DTDIGIT
			cLocal2 := SQL_SD1->D1_LOCAL
			oSection1:Cell("LOCAL"):SetValue(SQL_SD1->D1_LOCAL)
			oSection1:Cell("DOCUMENTO"):SetValue("NF.Entr.:"+SQL_SD1->D1_DOC)
			oSection1:Cell("DATA"):SetValue(SQL_SD1->D1_DTDIGIT)
			oSection1:Cell("FORNECEDOR"):SetValue(SQL_SD1->D1_FORNECE+'/'+SQL_SD1->D1_LOJA)
			oSection1:Cell("QTD"):SetValue(SQL_SD1->D1_QUANT)
			oSection1:Cell("CUSTO"):SetValue(SQL_SD1->D1_CUSTO)
			oSection1:Cell("IPI"):SetValue(SQL_SD1->D1_VALIPI)
			oSection1:Cell("ICMS"):SetValue(SQL_SD1->D1_VALICM)
			oSection1:Cell("ICMSST"):SetValue(SQL_SD1->D1_ICMSRET)
		EndIf
		If _cOrigem == "SD3" //SQL_SD3->D3_EMISSAO < _dData
			//_dData:=SQL_SD3->D3_EMISSAO
			cLocal2 := SQL_SD3->D3_LOCAL
			oSection1:Cell("LOCAL"):SetValue(SQL_SD3->D3_LOCAL)
			oSection1:Cell("DOCUMENTO"):SetValue(If(SQL_SD3->D3_TIPO=="PA".or.SQL_SD3->D3_TIPO=="PI","OP:     "+SQL_SD3->D3_OP,"Sequenci.:"+SQL_SD3->D3_NUMSEQ))
			oSection1:Cell("DATA"):SetValue(SQL_SD3->D3_EMISSAO)
			oSection1:Cell("QTD"):SetValue(SQL_SD3->D3_QUANT)
			oSection1:Cell("CUSTO"):SetValue(SQL_SD3->D3_CUSTO1)
			oSection1:Cell("FORNECEDOR"):SetValue("")
			oSection1:Cell("QTD"):SetValue(0)
			oSection1:Cell("IPI"):SetValue(0)
			oSection1:Cell("ICMS"):SetValue(0)
			oSection1:Cell("ICMSST"):SetValue(0)
		EndIf
		If _cOrigem == "SD2"  //SQL_SD2->D2_EMISSAO < _dData
			//_dData:=SQL_SD2->D2_EMISSAO
			cLocal2 := SQL_SD2->D2_LOCAL
			oSection1:Cell("LOCAL"):SetValue(SQL_SD2->D2_LOCAL)
			oSection1:Cell("DOCUMENTO"):SetValue("NF.Saida:"+SQL_SD2->D2_DOC)
			oSection1:Cell("DATA"):SetValue(SQL_SD2->D2_EMISSAO)
			oSection1:Cell("QTD"):SetValue(SQL_SD2->D2_QUANT)
			oSection1:Cell("CUSTO"):SetValue(SQL_SD2->D2_CUSTO1)
			oSection1:Cell("FORNECEDOR"):SetValue(SQL_SD2->D2_CLIENTE)
			oSection1:Cell("IPI"):SetValue(SQL_SD2->D2_VALIPI)
			oSection1:Cell("ICMS"):SetValue(SQL_SD2->D2_VALICM)
			oSection1:Cell("ICMSST"):SetValue(SQL_SD2->D2_ICMSRET)
		EndIf
		
		cProduto := (_cAlias)->B1_COD
		SB2->( dbSeek( xFilial() + cProduto + cLocal2 ) )
		nSalEst := SB2->B2_QATU
		nValEst := SB2->B2_VATU1
		
		oSection1:Cell("B1_TIPO"):SetValue((_cAlias)->B1_TIPO)
		oSection1:Cell("B1_COD"):SetValue((_cAlias)->B1_COD)
		oSection1:Cell("B1_DESC"):SetValue((_cAlias)->B1_DESC)
		oSection1:Cell("B1_IMPORT"):SetValue((_cAlias)->B1_IMPORT)
		oSection1:Cell("QTDATU"):SetValue(nSalEst)
		oSection1:Cell("VLRATU"):SetValue(nValEst)
		
		oSection1:PrintLine()
		
		SB2->( dbSeek( xFilial() + cProduto ) )
		While !SB2->( EOF() ) .and. SB2->B2_COD == cProduto .and. SB2->B2_FILIAL == xFilial("SB2")
			If SB2->B2_LOCAL $ cLocal .and. SB2->B2_LOCAL <> cLocal2 .and. SB2->B2_QATU <> 0
				cAlmox := SB2->B2_LOCAL
				
				fSqlSd12()
				fSqlSd32()
				fSqlSd22()
				
				_dData  := SQL_SD1_2->D1_DTDIGIT
				_cOrigem := "SD1"
				
				If (_dData < SQL_SD2_2->D2_EMISSAO .and. !Empty(SQL_SD2_2->D2_EMISSAO)) .or. Empty(_dData)
					_dData  := SQL_SD2_2->D2_EMISSAO
					_cOrigem := "SD2"
				EndIf
				
				If (_dData < SQL_SD3_2->D3_EMISSAO .and. !Empty(SQL_SD3_2->D3_EMISSAO)) .or. Empty(_dData)
					_dData  := SQL_SD3_2->D3_EMISSAO
					_cOrigem := "SD3"
				EndIf
				
				If !Empty(_dData)
					If _cOrigem == "SD1"
						oSection1:Cell("LOCAL"):SetValue(SQL_SD1_2->D1_LOCAL)
						oSection1:Cell("DOCUMENTO"):SetValue("NF.Entr.:"+SQL_SD1_2->D1_DOC)
						oSection1:Cell("DATA"):SetValue(SQL_SD1_2->D1_DTDIGIT)
						oSection1:Cell("FORNECEDOR"):SetValue(SQL_SD1_2->D1_FORNECE+'/'+SQL_SD1_2->D1_LOJA)
						oSection1:Cell("QTD"):SetValue(SQL_SD1_2->D1_QUANT)
						oSection1:Cell("CUSTO"):SetValue(SQL_SD1_2->D1_CUSTO)
						oSection1:Cell("IPI"):SetValue(SQL_SD1_2->D1_VALIPI)
						oSection1:Cell("ICMS"):SetValue(SQL_SD1_2->D1_VALICM)
						oSection1:Cell("ICMSST"):SetValue(SQL_SD1_2->D1_ICMSRET)
					EndIf
					If _cOrigem == "SD3"
						oSection1:Cell("LOCAL"):SetValue(SQL_SD3_2->D3_LOCAL)
						oSection1:Cell("DOCUMENTO"):SetValue(If(SQL_SD3_2->D3_TIPO=="PA".or.SQL_SD3_2->D3_TIPO=="PI","OP:     "+SQL_SD3_2->D3_OP,"Sequenci.:"+SQL_SD3_2->D3_NUMSEQ))
						oSection1:Cell("DATA"):SetValue(SQL_SD3_2->D3_EMISSAO)
						oSection1:Cell("QTD"):SetValue(SQL_SD3_2->D3_QUANT)
						oSection1:Cell("CUSTO"):SetValue(SQL_SD3_2->D3_CUSTO1)
						oSection1:Cell("FORNECEDOR"):SetValue("")
						oSection1:Cell("QTD"):SetValue(0)
						oSection1:Cell("IPI"):SetValue(0)
						oSection1:Cell("ICMS"):SetValue(0)
						oSection1:Cell("ICMSST"):SetValue(0)
					EndIf
					If _cOrigem == "SD2"
						oSection1:Cell("LOCAL"):SetValue(SQL_SD2_2->D2_LOCAL)
						oSection1:Cell("DOCUMENTO"):SetValue("NF.Saida:"+SQL_SD2_2->D2_DOC)
						oSection1:Cell("DATA"):SetValue(SQL_SD2_2->D2_EMISSAO)
						oSection1:Cell("QTD"):SetValue(SQL_SD2_2->D2_QUANT)
						oSection1:Cell("CUSTO"):SetValue(SQL_SD2_2->D2_CUSTO1)
						oSection1:Cell("FORNECEDOR"):SetValue(SQL_SD2_2->D2_CLIENTE)
						oSection1:Cell("IPI"):SetValue(SQL_SD2_2->D2_VALIPI)
						oSection1:Cell("ICMS"):SetValue(SQL_SD2_2->D2_VALICM)
						oSection1:Cell("ICMSST"):SetValue(SQL_SD2_2->D2_ICMSRET)
					EndIf
					
					oSection1:Cell("B1_TIPO"):SetValue("")
					oSection1:Cell("B1_COD"):SetValue("")
					oSection1:Cell("B1_DESC"):SetValue("")
					//oSection1:Cell("B1_IMPORT"):SetValue("")
					oSection1:Cell("QTDATU"):SetValue(SB2->B2_QATU)
					oSection1:Cell("VLRATU"):SetValue(SB2->B2_VATU1)
					
					oSection1:PrintLine()
				EndIf
				
			EndIf
			SB2->( dbSkip() )
		End
		
		//EndIf
		
	EndIf
	
	dbSelectArea(_cAlias)
	dbSkip()
	oReport:IncMeter()
EndDo
oSection1:Finish()
oReport:EndPage()
Return

//--------------------------------------------------

Static Function fSqlSd1()

If Select("SQL_SD1") > 0
	SQL_SD1->(dbCloseArea())
EndIf

cQuery:="SELECT TOP 1 D1_DTDIGIT ,D1_DOC,D1_DTDIGIT,D1_FORNECE,D1_LOJA,D1_QUANT,D1_CUSTO,D1_VALIPI,D1_VALICM,D1_ICMSRET,D1_LOCAL "+Chr(10)+Chr(13)
cQuery+="From "+RetSqlName("SD1")+" SD1 "+Chr(10)+Chr(13)
cQuery+="    ,"+RetSqlName("SF4")+" SF4 "+Chr(10)+Chr(13)
cQuery+="Where D1_FILIAL = '"+xFilial("SD1")+"'"+Chr(10)+Chr(13)
cQuery+="And F4_FILIAL = '"+xFilial("SF4")+"'"+Chr(10)+Chr(13)
cQuery+="And D1_COD >='"+Mv_Par01+"'"+Chr(10)+Chr(13)
cQuery+="And D1_COD <='"+Mv_Par02+"'"+Chr(10)+Chr(13)
cQuery+="And D1_TP >='"+Mv_Par03+"'"+Chr(10)+Chr(13)
cQuery+="And D1_TP <='"+Mv_Par04+"'"+Chr(10)+Chr(13)
cQuery+="And D1_COD = '"+(_cAlias)->B1_COD+"'"+Chr(10)+Chr(13)
If Empty(Mv_Par08)
   cQuery+="And D1_LOCAL >= '"+Mv_Par05+"'"+Chr(10)+Chr(13)
   cQuery+="And D1_LOCAL <= '"+Mv_Par06+"'"+Chr(10)+Chr(13)
Else   
   cQuery+="And D1_LOCAL IN ('"+cLocal+"') "
EndIf   
cQuery+="And D1_TES = F4_CODIGO"+Chr(10)+Chr(13)
//cQuery+="And D1_DTDIGIT >= '"+Dtos(Mv_Par07)+"'"+Chr(10)+Chr(13)
cQuery+="And D1_DTDIGIT <= '"+Dtos(dDataBase)+"'"+Chr(10)+Chr(13)
cQuery+="And F4_ESTOQUE = 'S'"+Chr(10)+Chr(13)
cQuery+="And SD1.D_E_L_E_T_ <> '*'"+Chr(10)+Chr(13)
cQuery+="And SF4.D_E_L_E_T_ <> '*'"+Chr(10)+Chr(13)
cQuery+="ORDER BY D1_DTDIGIT DESC "

TCQuery cQuery ALIAS "SQL_SD1" NEW

TCSetField("SQL_SD1","D1_DTDIGIT" ,"D",08,0)
TCSetField("SQL_SD1","D1_CUSTO" ,"N",14,2)
TCSetField("SQL_SD1","D1_VALIPI" ,"N",14,2)
TCSetField("SQL_SD1","D1_VALICM" ,"N",14,2)
TCSetField("SQL_SD1","D1_ICMSRET" ,"N",14,2)

DbSelectArea("SQL_SD1")

Return

//------------------------------------

Static Function fSqlSd3()

If Select("SQL_SD3") > 0
	SQL_SD3->(dbCloseArea())
EndIf

cQuery:="SELECT TOP 1 D3_EMISSAO,D3_DOC,D3_EMISSAO,D3_OP,D3_TIPO,D3_QUANT,D3_CUSTO1,D3_LOCAL,D3_NUMSEQ  "+Chr(10)+Chr(13)
cQuery+="From "+RetSqlName("SD3")+Chr(10)+Chr(13)
cQuery+="Where D3_FILIAL = '"+xFilial("SD3")+"'"+Chr(10)+Chr(13)
cQuery+="And D3_COD >='"+Mv_Par01+"'"+Chr(10)+Chr(13)
cQuery+="And D3_COD <='"+Mv_Par02+"'"+Chr(10)+Chr(13)
cQuery+="And D3_TIPO >='"+Mv_Par03+"'"+Chr(10)+Chr(13)
cQuery+="And D3_TIPO <='"+Mv_Par04+"'"+Chr(10)+Chr(13)
cQuery+="And D3_COD = '"+(_cAlias)->B1_COD+"'"+Chr(10)+Chr(13)
If Empty(Mv_Par08)
   cQuery+="And D3_LOCAL >= '"+Mv_Par05+"'"+Chr(10)+Chr(13)
   cQuery+="And D3_LOCAL <= '"+Mv_Par06+"'"+Chr(10)+Chr(13)
Else   
   cQuery+="And D3_LOCAL IN ('"+cLocal+"') "
EndIf   
//cQuery+="And D3_EMISSAO >= '"+Dtos(Mv_Par07)+"'"+Chr(10)+Chr(13)
cQuery+="And D3_EMISSAO <= '"+Dtos(dDataBase)+"'"+Chr(10)+Chr(13)
cQuery+="And D3_TM+D3_CF NOT IN ('999RE6','499DE6') "
cQuery+="And D_E_L_E_T_ <> '*'"+Chr(10)+Chr(13)
cQuery+="ORDER BY D3_EMISSAO DESC "

TCQuery cQuery ALIAS "SQL_SD3" NEW

TCSetField("SQL_SD3","D3_EMISSAO" ,"D",08,0)

DbSelectArea("SQL_SD3")

Return

//-------------------------------------

Static Function fSqlSd2()

If Select("SQL_SD2") > 0
	SQL_SD2->(dbCloseArea())
EndIf

cQuery:="SELECT TOP 1 D2_EMISSAO ,D2_DOC,D2_CLIENTE,D2_LOJA,D2_QUANT,D2_CUSTO1,D2_VALIPI,D2_VALICM,D2_ICMSRET,D2_LOCAL  "+Chr(10)+Chr(13)
cQuery+="From "+RetSqlName("SD2")+" SD2 "+Chr(10)+Chr(13)
cQuery+="    ,"+RetSqlName("SF4")+" SF4 "+Chr(10)+Chr(13)
cQuery+="Where D2_FILIAL = '"+xFilial("SD2")+"'"+Chr(10)+Chr(13)
cQuery+="And F4_FILIAL = '"+xFilial("SF4")+"'"+Chr(10)+Chr(13)
cQuery+="And D2_COD >='"+Mv_Par01+"'"+Chr(10)+Chr(13)
cQuery+="And D2_COD <='"+Mv_Par02+"'"+Chr(10)+Chr(13)
cQuery+="And D2_TP >='"+Mv_Par03+"'"+Chr(10)+Chr(13)
cQuery+="And D2_TP <='"+Mv_Par04+"'"+Chr(10)+Chr(13)
If Empty(Mv_Par08)
   cQuery+="And D2_LOCAL >= '"+Mv_Par05+"'"+Chr(10)+Chr(13)
   cQuery+="And D2_LOCAL <= '"+Mv_Par06+"'"+Chr(10)+Chr(13)
Else   
   cQuery+="And D2_LOCAL IN ('"+cLocal+"') "
EndIf   
//cQuery+="And D2_EMISSAO >= '"+Dtos(Mv_Par07)+"'"+Chr(10)+Chr(13)
cQuery+="And D2_EMISSAO <= '"+Dtos(dDataBase)+"'"+Chr(10)+Chr(13)
cQuery+="And D2_COD = '"+(_cAlias)->B1_COD+"'"+Chr(10)+Chr(13)
cQuery+="And D2_TES = F4_CODIGO"+Chr(10)+Chr(13)
cQuery+="And F4_ESTOQUE = 'S'"+Chr(10)+Chr(13)
cQuery+="And SD2.D_E_L_E_T_ <> '*'"+Chr(10)+Chr(13)
cQuery+="And SF4.D_E_L_E_T_ <> '*'"+Chr(10)+Chr(13)
cQuery+="ORDER BY D2_EMISSAO DESC "

TCQuery cQuery ALIAS "SQL_SD2" NEW

TCSetField("SQL_SD2","D2_EMISSAO" ,"D",08,0)

DbSelectArea("SQL_SD2")

Return

//-----------------------------------------------------------

Static Function fCriaPerg()
aSvAlias:={Alias(),IndexOrd(),Recno()}
i:=j:=0
aRegistros:={}
//                1      2    3                  4  5      6     7  8  9  10  11  12 13     14  15    16 17 18 19 20     21  22 23 24 25   26 27 28 29  30       31 32 33 34 35  36 37 38 39    40 41 42 43 44
AADD(aRegistros,{_cPerg,"01","Produto de                 ?","","","mv_ch1","C",15,00,00,"G","","mv_par01",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","SB1","","","","",""})
AADD(aRegistros,{_cPerg,"02","Produto ate                ?","","","mv_ch2","C",15,00,00,"G","","mv_par02",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","SB1","","","","",""})
AADD(aRegistros,{_cPerg,"03","Tipo de                    ?","","","mv_ch3","C",02,00,00,"G","","mv_par03",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","02","","","","",""})
AADD(aRegistros,{_cPerg,"04","Tipo ate                   ?","","","mv_ch4","C",02,00,00,"G","","mv_par04",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","02","","","","",""})
AADD(aRegistros,{_cPerg,"05","Almoxarifado de            ?","","","mv_ch5","C",02,00,00,"G","","mv_par05",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"06","Almoxarifado ate           ?","","","mv_ch6","C",02,00,00,"G","","mv_par06",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"07","Data de Corte              ?","","","mv_ch7","D",08,00,00,"G","","mv_par07",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"08","Almoxarifados a considerar ?","","","mv_ch8","C",99,00,00,"G","","mv_par08",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","","","","","",""})

DbSelectArea("SX1")
For i := 1 to Len(aRegistros)
	If !dbSeek(aRegistros[i,1]+aRegistros[i,2])
		While !RecLock("SX1",.T.)
		End
		For j:=1 to FCount()
			FieldPut(j,aRegistros[i,j])
		Next
		MsUnlock()
	Endif
Next i

dbSelectArea(aSvAlias[1])
dbSetOrder(aSvAlias[2])
dbGoto(aSvAlias[3])
Return(Nil)

//-------------------------------------------------------------

Static Function fSqlSd12()

If Select("SQL_SD1_2") > 0
	SQL_SD1_2->(dbCloseArea())
EndIf

cQuery:="SELECT TOP 1 D1_DTDIGIT ,D1_DOC,D1_DTDIGIT,D1_FORNECE,D1_LOJA,D1_QUANT,D1_CUSTO,D1_VALIPI,D1_VALICM,D1_ICMSRET,D1_LOCAL "+Chr(10)+Chr(13)
cQuery+="From "+RetSqlName("SD1")+" SD1 "+Chr(10)+Chr(13)
cQuery+="    ,"+RetSqlName("SF4")+" SF4 "+Chr(10)+Chr(13)
cQuery+="Where D1_FILIAL = '"+xFilial("SD1")+"'"+Chr(10)+Chr(13)
cQuery+="And F4_FILIAL = '"+xFilial("SF4")+"'"+Chr(10)+Chr(13)
cQuery+="And D1_COD >='"+Mv_Par01+"'"+Chr(10)+Chr(13)
cQuery+="And D1_COD <='"+Mv_Par02+"'"+Chr(10)+Chr(13)
cQuery+="And D1_TP >='"+Mv_Par03+"'"+Chr(10)+Chr(13)
cQuery+="And D1_TP <='"+Mv_Par04+"'"+Chr(10)+Chr(13)
cQuery+="And D1_COD = '"+(_cAlias)->B1_COD+"'"+Chr(10)+Chr(13)
cQuery+="And D1_LOCAL = '"+cAlmox+"' "
cQuery+="And D1_TES = F4_CODIGO"+Chr(10)+Chr(13)
//If Empty(Mv_Par08)
//   cQuery+="And D1_LOCAL >= '"+Mv_Par05+"'"+Chr(10)+Chr(13)
//   cQuery+="And D1_LOCAL <= '"+Mv_Par06+"'"+Chr(10)+Chr(13)
//Else   
//   cQuery+="And D1_LOCAL IN ('"+cLocal+"') "
//EndIf   
//cQuery+="And D1_DTDIGIT >= '"+Dtos(Mv_Par07)+"'"+Chr(10)+Chr(13)
cQuery+="And D1_DTDIGIT <= '"+Dtos(dDataBase)+"'"+Chr(10)+Chr(13)
cQuery+="And F4_ESTOQUE = 'S'"+Chr(10)+Chr(13)
cQuery+="And SD1.D_E_L_E_T_ <> '*'"+Chr(10)+Chr(13)
cQuery+="And SF4.D_E_L_E_T_ <> '*'"+Chr(10)+Chr(13)
cQuery+="ORDER BY D1_DTDIGIT DESC "

TCQuery cQuery ALIAS "SQL_SD1_2" NEW

TCSetField("SQL_SD1_2","D1_DTDIGIT" ,"D",08,0)
TCSetField("SQL_SD1_2","D1_CUSTO" ,"N",14,2)
TCSetField("SQL_SD1_2","D1_VALIPI" ,"N",14,2)
TCSetField("SQL_SD1_2","D1_VALICM" ,"N",14,2)
TCSetField("SQL_SD1_2","D1_ICMSRET" ,"N",14,2)

DbSelectArea("SQL_SD1_2")

Return

//------------------------------------

Static Function fSqlSd32()

If Select("SQL_SD3_2") > 0
	SQL_SD3_2->(dbCloseArea())
EndIf

cQuery:="SELECT TOP 1 D3_EMISSAO,D3_DOC,D3_EMISSAO,D3_OP,D3_TIPO,D3_QUANT,D3_CUSTO1,D3_LOCAL,D3_NUMSEQ  "+Chr(10)+Chr(13)
cQuery+="From "+RetSqlName("SD3")+Chr(10)+Chr(13)
cQuery+="Where D3_FILIAL = '"+xFilial("SD3")+"'"+Chr(10)+Chr(13)
cQuery+="And D3_COD >='"+Mv_Par01+"'"+Chr(10)+Chr(13)
cQuery+="And D3_COD <='"+Mv_Par02+"'"+Chr(10)+Chr(13)
cQuery+="And D3_TIPO >='"+Mv_Par03+"'"+Chr(10)+Chr(13)
cQuery+="And D3_TIPO <='"+Mv_Par04+"'"+Chr(10)+Chr(13)
cQuery+="And D3_COD = '"+(_cAlias)->B1_COD+"'"+Chr(10)+Chr(13)
cQuery+="And D3_LOCAL = '"+cAlmox+"' "
//If Empty(Mv_Par08)
//   cQuery+="And D3_LOCAL >= '"+Mv_Par05+"'"+Chr(10)+Chr(13)
//   cQuery+="And D3_LOCAL <= '"+Mv_Par06+"'"+Chr(10)+Chr(13)
//Else   
//   cQuery+="And D3_LOCAL IN ('"+cLocal+"') "
//EndIf   
//cQuery+="And D3_EMISSAO >= '"+Dtos(Mv_Par07)+"'"+Chr(10)+Chr(13)
cQuery+="And D3_EMISSAO <= '"+Dtos(dDataBase)+"'"+Chr(10)+Chr(13)
cQuery+="And D3_TM+D3_CF NOT IN ('999RE6','499DE6') "
cQuery+="And D_E_L_E_T_ <> '*'"+Chr(10)+Chr(13)
cQuery+="ORDER BY D3_EMISSAO DESC "

TCQuery cQuery ALIAS "SQL_SD3_2" NEW

TCSetField("SQL_SD3_2","D3_EMISSAO" ,"D",08,0)

DbSelectArea("SQL_SD3_2")

Return

//-------------------------------------

Static Function fSqlSd22()

If Select("SQL_SD2_2") > 0
	SQL_SD2_2->(dbCloseArea())
EndIf

cQuery:="SELECT TOP 1 D2_EMISSAO ,D2_DOC,D2_CLIENTE,D2_LOJA,D2_QUANT,D2_CUSTO1,D2_VALIPI,D2_VALICM,D2_ICMSRET,D2_LOCAL  "+Chr(10)+Chr(13)
cQuery+="From "+RetSqlName("SD2")+" SD2 "+Chr(10)+Chr(13)
cQuery+="    ,"+RetSqlName("SF4")+" SF4 "+Chr(10)+Chr(13)
cQuery+="Where D2_FILIAL = '"+xFilial("SD2")+"'"+Chr(10)+Chr(13)
cQuery+="And F4_FILIAL = '"+xFilial("SF4")+"'"+Chr(10)+Chr(13)
cQuery+="And D2_COD >='"+Mv_Par01+"'"+Chr(10)+Chr(13)
cQuery+="And D2_COD <='"+Mv_Par02+"'"+Chr(10)+Chr(13)
cQuery+="And D2_TP >='"+Mv_Par03+"'"+Chr(10)+Chr(13)
cQuery+="And D2_TP <='"+Mv_Par04+"'"+Chr(10)+Chr(13)
//If Empty(Mv_Par08)
//   cQuery+="And D2_LOCAL >= '"+Mv_Par05+"'"+Chr(10)+Chr(13)
//   cQuery+="And D2_LOCAL <= '"+Mv_Par06+"'"+Chr(10)+Chr(13)
//Else   
//   cQuery+="And D2_LOCAL IN ('"+cLocal+"') "
//EndIf   
cQuery+="And D2_LOCAL = '"+cAlmox+"' "                         
//cQuery+="And D2_EMISSAO >= '"+Dtos(Mv_Par07)+"'"+Chr(10)+Chr(13)
cQuery+="And D2_EMISSAO <= '"+Dtos(dDataBase)+"'"+Chr(10)+Chr(13)
cQuery+="And D2_COD = '"+(_cAlias)->B1_COD+"'"+Chr(10)+Chr(13)
cQuery+="And D2_TES = F4_CODIGO"+Chr(10)+Chr(13)
cQuery+="And F4_ESTOQUE = 'S'"+Chr(10)+Chr(13)
cQuery+="And SD2.D_E_L_E_T_ <> '*'"+Chr(10)+Chr(13)
cQuery+="And SF4.D_E_L_E_T_ <> '*'"+Chr(10)+Chr(13)
cQuery+="ORDER BY D2_EMISSAO DESC "

TCQuery cQuery ALIAS "SQL_SD2_2" NEW

TCSetField("SQL_SD2_2","D2_EMISSAO" ,"D",08,0)

DbSelectArea("SQL_SD2_2")

Return