//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Wederson L. Santana - 12/09/13                                                                                                                   //
//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Especifico Domex                                                                                                                                 //
//                                                                                                                                                 //
//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Relatório para conferência folha de pagamento.                                                                                                   //
//-------------------------------------------------------------------------------------------------------------------------------------------------//

#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"                                                 
#Include "protheus.ch"
#Include "colors.ch"

User Function DOMGPE03()
Private _cPerg :="DOMGPE03"+Space(02)
Private oReport
Private cFilterUser
Private oSection1
Private oFont , oFontN
Private cTitulo

fCriaPerg()
If Pergunte(_cPerg,.T.)
	oReport:=ReportDef()
	oReport:PrintDialog()
EndIf

Return

//-----------------------------------

Static Function ReportDef()
Local _cPictTit := "@E@Z 99999,999.99"
Local _cPictTot := "@E 99,999,999.99"
Local oSection1

cTitulo:= ""
oFontN :=TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)// Negrito 
oFont  :=TFont():New("Times New Roman",08,08,,.F.,,,,.F.,.F.)

oReport   :=TReport():New("DOMGPE03",cTitulo,""/*_cPerg*/,{|oReport| ReportPrint(oReport)},"Este relatório exibirá os valores para conferência da folha de pagamento.")

oReport:SetLandScape()

oSection1:=TRSection():New(oReport,"","SRC",{},.F./*aOrder*/,.F./*lLoadCells*/,""/*cTotalText*/,.F./*lTotalInCol*/,.F./*lHeaderPage*/,.F./*lHeaderBreak*/)

TRCell():New(oSection1,"RC_FILIAL"       ,,"Filial"                , ,002,.F.,)
TRCell():New(oSection1,"RC_CC"           ,,"C.Custo"               , ,009,.F.,)
TRCell():New(oSection1,"CTT_DESC01"      ,,"Descrição C.Custo"     , ,040,.F.,)
TRCell():New(oSection1,"RC_MAT"          ,,"Matrícula"             , ,006,.F.,)
TRCell():New(oSection1,"RA_NOME"         ,,"Nome"                  , ,030,.F.,)
TRCell():New(oSection1,"RA_CATFUNC"      ,,"Categoria"             , ,001,.F.,)
TRCell():New(oSection1,"RA_CBO"          ,,"CBO"                   , ,005,.F.,)
TRCell():New(oSection1,"RJ_DESC"         ,,"Função"                , ,020,.F.,)
TRCell():New(oSection1,"RA_DEPIR"        ,,"Dep. IRRF"             , ,008,.F.,)
TRCell():New(oSection1,"RA_DEPSF"        ,,"Dep. Sal.Família"      , ,008,.F.,)
TRCell():New(oSection1,"RA_SALARIO"      ,,"Salário"               , ,010,.F.,)
TRCell():New(oSection1,"RC_PD"           ,,"Verba"                 , ,003,.F.,)
TRCell():New(oSection1,"RV_DESC"         ,,"Descrição Verba"       , ,030,.F.,)
TRCell():New(oSection1,"RC_HORAS"        ,,"Horas"                 , ,006,.F.,)
TRCell():New(oSection1,"RC_VALOR"        ,,"Valor"                 , ,010,.F.,)
TRCell():New(oSection1,"RC_DATA"         ,,"Data"                  , ,010,.F.,)

oSection1:SetHeaderPage()

oSection1:Cell("RC_FILIAL"):SetHeaderAlign("LEFT")
oSection1:Cell("RC_FILIAL"):SetAlign("LEFT")
oSection1:Cell("RC_FILIAL"):SetSize(02)

oSection1:Cell("RC_CC"):SetHeaderAlign("RIGHT")
oSection1:Cell("RC_CC"):SetAlign("RIGHT")
oSection1:Cell("RC_CC"):SetSize(09)

oSection1:Cell("CTT_DESC01"):SetHeaderAlign("LEFT")
oSection1:Cell("CTT_DESC01"):SetAlign("LEFT")
oSection1:Cell("CTT_DESC01"):SetSize(40)

oSection1:Cell("RC_MAT"):SetHeaderAlign("LEFT" )
oSection1:Cell("RC_MAT"):SetAlign("LEFT" )
oSection1:Cell("RC_MAT"):SetSize(06)

oSection1:Cell("RA_NOME"):SetHeaderAlign("LEFT" )
oSection1:Cell("RA_NOME"):SetAlign("LEFT" )
oSection1:Cell("RA_NOME"):SetSize(30)

oSection1:Cell("RA_CATFUNC"):SetHeaderAlign("LEFT" )
oSection1:Cell("RA_CATFUNC"):SetAlign("LEFT" )
oSection1:Cell("RA_CATFUNC"):SetSize(01)

oSection1:Cell("RA_CBO"):SetHeaderAlign("LEFT")
oSection1:Cell("RA_CBO"):SetAlign("LEFT")
oSection1:Cell("RA_CBO"):SetSize(05)

oSection1:Cell("RJ_DESC"):SetHeaderAlign("LEFT")
oSection1:Cell("RJ_DESC"):SetAlign("LEFT")
oSection1:Cell("RJ_DESC"):SetSize(20)

oSection1:Cell("RA_DEPIR"):SetHeaderAlign("RIGHT")
oSection1:Cell("RA_DEPIR"):SetAlign("RIGHT")
oSection1:Cell("RA_DEPIR"):SetSize(08)
oSection1:Cell("RA_DEPIR"):SetPicture("@E 9999,999",08)

oSection1:Cell("RA_DEPSF"):SetHeaderAlign("RIGHT")
oSection1:Cell("RA_DEPSF"):SetAlign("RIGHT")
oSection1:Cell("RA_DEPSF"):SetSize(08)
oSection1:Cell("RA_DEPSF"):SetPicture("@E 9999,999",08)

oSection1:Cell("RA_SALARIO"):SetHeaderAlign("RIGHT")
oSection1:Cell("RA_SALARIO"):SetAlign("RIGHT")
oSection1:Cell("RA_SALARIO"):SetSize(10)
oSection1:Cell("RA_SALARIO"):SetPicture("@E 99,9999,99",10)

oSection1:Cell("RC_PD"):SetHeaderAlign("RIGHT")
oSection1:Cell("RC_PD"):SetAlign("RIGHT")
oSection1:Cell("RC_PD"):SetSize(03)

oSection1:Cell("RV_DESC"):SetHeaderAlign("LEFT")
oSection1:Cell("RV_DESC"):SetAlign("LEFT")
oSection1:Cell("RV_DESC"):SetSize(30)

oSection1:Cell("RC_HORAS"):SetHeaderAlign("RIGHT")
oSection1:Cell("RC_HORAS"):SetAlign("RIGHT")
oSection1:Cell("RC_HORAS"):SetSize(06)
oSection1:Cell("RC_HORAS"):SetPicture("@E 999,99",06)

oSection1:Cell("RC_VALOR"):SetHeaderAlign("RIGHT")
oSection1:Cell("RC_VALOR"):SetAlign("RIGHT")
oSection1:Cell("RC_VALOR"):SetSize(10)
oSection1:Cell("RC_VALOR"):SetPicture("@E 999,999,99",10)

Return oReport

//---------------------------------------------------------

Static Function ReportPrint(oReport)
Local oSection1 := oReport:Section(1)
Local nOrdem    := oSection1:GetOrder()
Local _cAlias   := GetNextAlias()
Local _cOrder   := "%RC_FILIAL,RC_CC,RC_MAT,RC_PD%"   

oReport:SetTitle(cTitulo)

BeginSql Alias _cAlias                                                             

        SELECT RC_FILIAL ,RC_CC ,CTT_DESC01 ,RC_MAT ,RA_NOME ,RA_CATFUNC ,RA_CBO ,RJ_DESC ,RA_CATFUNC ,RA_DEPIR ,RA_DEPSF ,RA_SALARIO ,RC_PD ,RV_DESC ,RC_HORAS ,RC_VALOR , RC_DATA
        FROM %table:SRC% SRC
            ,%table:SRV% SRV
            ,%table:SRA% SRA
            ,%table:CTT% CTT
            ,%table:SRJ% SRJ
         WHERE SRC.%notDel%		
         AND SRV.%notDel%		
         AND SRA.%notDel%		
         AND CTT.%notDel%		
         AND SRJ.%notDel%		
         AND RC_PD = RV_COD
         AND RC_FILIAL = RA_FILIAL                                           
         AND RC_MAT = RA_MAT 
         AND RA_CC = CTT_CUSTO 
         AND RA_CODFUNC = RJ_FUNCAO
         AND RC_MAT >= %Exp:mv_par01%
         AND RC_MAT <= %Exp:mv_par02%
         AND RC_CC >= %Exp:mv_par03%
         AND RC_CC <= %Exp:mv_par04%
         AND RC_PD >= %Exp:mv_par05%
         AND RC_PD <= %Exp:mv_par06%
       ORDER BY %Exp:_cOrder%
EndSql

/*         AND RV_FILIAL = %Exp:xFilial("SRV")%
         AND RV_FILIAL = %Exp:xFilial("SRC")%
         AND RV_FILIAL = %Exp:xFilial("SRA")%
         AND RV_FILIAL = %Exp:xFilial("CTT")%
         AND RV_FILIAL = %Exp:xFilial("SRJ")%         */

//TcSetField(_cAlias,"RC_DATA"    ,"D",  8, 0)

oSection1:EndQuery()

oSection1:Init()

dbSelectArea(_cAlias)
While !oReport:Cancel() .And. (_cAlias)->(!Eof())
	
	If oReport:Cancel()
		Exit
	EndIf
	
   oSection1:Cell("RC_FILIAL")  :SetValue((_cAlias)->RC_FILIAL)
	oSection1:Cell("RC_CC")      :SetValue((_cAlias)->RC_CC)
	oSection1:Cell("CTT_DESC01") :SetValue((_cAlias)->CTT_DESC01)
	oSection1:Cell("RC_MAT")     :SetValue((_cAlias)->RC_MAT)
	oSection1:Cell("RA_NOME")    :SetValue((_cAlias)->RA_NOME)
	oSection1:Cell("RA_CATFUNC") :SetValue((_cAlias)->RA_CATFUNC)
   oSection1:Cell("RA_CBO")     :SetValue((_cAlias)->RA_CBO)	   
   oSection1:Cell("RJ_DESC")    :SetValue((_cAlias)->RJ_DESC)	   
	oSection1:Cell("RA_DEPIR")   :SetValue((_cAlias)->RA_DEPIR)
	oSection1:Cell("RA_DEPSF")   :SetValue((_cAlias)->RA_DEPSF)
	oSection1:Cell("RA_SALARIO") :SetValue((_cAlias)->RA_SALARIO)
   oSection1:Cell("RC_PD")      :SetValue((_cAlias)->RC_PD)	   
   oSection1:Cell("RV_DESC")    :SetValue((_cAlias)->RV_DESC)	   
	oSection1:Cell("RC_HORAS")   :SetValue((_cAlias)->RC_HORAS)
	oSection1:Cell("RC_VALOR")   :SetValue((_cAlias)->RC_VALOR)
	oSection1:Cell("RC_DATA")    :SetValue(SubStr((_cAlias)->RC_DATA,7,2)+"/"+SubStr((_cAlias)->RC_DATA,5,2)+"/"+SubStr((_cAlias)->RC_DATA,1,4))
	
   oSection1:PrintLine()
   
	dbSelectArea(_cAlias)
	dbSkip()
   oReport:IncMeter()
   oReport:SkipLine()
EndDo
oSection1:Finish()
oReport:EndPage()
Return

//-----------------------------------------------------------

Static Function fCriaPerg()
aSvAlias:={Alias(),IndexOrd(),Recno()}
i:=j:=0
aRegistros:={}
//                1      2    3                  4  5      6     7  8  9  10  11  12 13     14  15    16 17 18 19 20     21  22 23 24 25   26 27 28 29  30       31 32 33 34 35  36 37 38 39    40 41 42 43 44
AADD(aRegistros,{_cPerg,"01","Da Matricula         ?","","","mv_ch1","C",06,00,00,"G","","mv_par01",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","SRA","","","","",""})
AADD(aRegistros,{_cPerg,"02","Ate a Matricula      ?","","","mv_ch2","C",06,00,00,"G","","mv_par02",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","SRA","","","","",""})
AADD(aRegistros,{_cPerg,"03","Do C.Custo           ?","","","mv_ch3","C",09,00,00,"G","","mv_par03",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","CTT","","","","",""})
AADD(aRegistros,{_cPerg,"04","Ate o C.Custo        ?","","","mv_ch4","C",09,00,00,"G","","mv_par04",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","CTT","","","","",""})
AADD(aRegistros,{_cPerg,"05","Da Verba             ?","","","mv_ch5","C",03,00,00,"G","","mv_par05",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","SRV","","","","",""})
AADD(aRegistros,{_cPerg,"06","Ate a Verba          ?","","","mv_ch6","C",03,00,00,"G","","mv_par06",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","SRV","","","","",""})

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