#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"  
#Include "protheus.ch"
#Include "colors.ch"
#Include "font.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATR06   ºAutor  ³Marco Aurelio       º Data ³  12/06/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ SGP -                                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATR06
	Private oReport
	Private _cPerg :=Padr("RFATR06",10)
	
	fCriaPerg()
	If Pergunte(_cPerg,.T.)
		oReport:=ReportDef()
		oReport:PrintDialog()
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDef ºAutor  ³Marco Aurelio       º Data ³  31/07/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função principal Relatorio                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()
   
Local oBreak
Local _cTit 	:= ""
Local _cTitOrd	:= ""    
Local oSection1
Local oSection2
Local oSection3

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Definir Dados do Relatorio³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cTitulo    	:= "Relatório SGP  - " //+ dtoc(MV_PAR01) + " a " + dtoc(MV_PAR02)
	oReport := TReport():New("RFATR06",_cTitulo,"RFATR06",{|oReport| PrintReport(oReport)},"Relatório SGP")
	oReport:SetLandscape() 
	oReport:SetTotalInLine(.T.)
 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Define Secao 1 do Relatorio - SGP                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection1 :=TRSection():New(oReport,_cTitulo,{"QRY"}) 
	TRCell():New(oSection1,"XD5_NUMSGP" ,"QRY",						,,020,.F. ) // Numero SGP  
//	TRCell():New(oSection1,"XD5_SERIAL"	,"QRY",						,,018,.F. ) // Serial Domex
	TRCell():New(oSection1,"XD5_NUMOP"	,"QRY",						,,011,.F. ) // Numero da OP
	TRCell():New(oSection1,"XD5_SERIE"	,"QRY",						,,003,.F. ) // Serie
	TRCell():New(oSection1,"XD5_NOTA"	,"QRY",						,,009,.F. ) // Documento	
	TRCell():New(oSection1,"XD5_CLIENT"	,"QRY",						,,006,.F. ) // Cliente	
	TRCell():New(oSection1,"XD5_LOJA"	,"QRY",						,,002,.F. ) // Loja  
	TRCell():New(oSection1,"A1_NREDUZ"	,"QRY",						,,020,.F. ) // Loja  	
	TRCell():New(oSection1,"XD5_ITEM"	,"QRY",						,,004,.F. ) // Item  
	TRCell():New(oSection1,"XD5_PECA"	,"QRY",						,,013,.F. ) // Peca
	
 //	oBreak := TRBreak():New(oSection1,oSection1:Cell("A1_NOME"),"TOTAL LINHA ->",.F.)
	TRFunction():New(oSection1:Cell("XD5_NUMSGP")		,"Numero SGP ","COUNT"	,      ,,"@E 999,999"	,,.T.,.F.,.F.,oSection1) //FINAL DA SECAO
  

/*	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Define Secao 2 do Relatorio - Recebimentos       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection2 :=TRSection():New(oReport,_cTitulo,{"QRY"}) 
	TRCell():New(oSection2,"A1_NOME" 	,"QRY",						,,030,.F. ) // Nome Cliente
	TRCell():New(oSection2,"E5_PREFIXO"	,"QRY",						,,003,.F. ) // Serie
	TRCell():New(oSection2,"E5_NUMERO"	,"QRY",						,,009,.F. ) // Num. NF
	TRCell():New(oSection2,"E5_VALOR"	,"QRY","Vlr.Baixado"		,,010,.F. ) // Valor Baixado	
	TRCell():New(oSection2,"E5_VLACRES"	,"QRY","Acrescimo"		,,010,.F. ) // Valor ICMS
	TRCell():New(oSection2,"E5_VLDECRE"	,"QRY","Decrescimo"		,,010,.F. ) // Valor Decrescimo	
	TRCell():New(oSection2,"DT_EMISSAO"	,"QRY",						,,008,.F. ) // Dt Emissao
	TRCell():New(oSection2,"E5_DATA"		,"QRY",						,,008,.F. ) // Dt Baixa
	oBreak := TRBreak():New(oSection2,oSection2:Cell("A1_NOME"),"TOTAL LINHA ->",.F.)
	TRFunction():New(oSection2:Cell("E5_VALOR")		,"VLR TOTAL ","SUM"	,      ,,"@E 999,999,999,999.99"	,,.T.,.F.,.F.,oSection2) //FINAL DA SECAO

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Define Secao 3 do Relatorio - A receber          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection3 :=TRSection():New(oReport,_cTitulo,{"QRY"}) 
	TRCell():New(oSection3,"A1_NOME" 	,"QRY",						,,030,.F. ) // Nome Cliente
	TRCell():New(oSection3,"E1_PREFIXO"	,"QRY",						,,003,.F. ) // Serie
	TRCell():New(oSection3,"E1_NUMERO"	,"QRY",						,,009,.F. ) // Num. NF
	TRCell():New(oSection3,"E1_VALOR"	,"QRY","Vlr.Baixado"		,,010,.F. ) // Valor Baixado	
	TRCell():New(oSection3,"E1_VLACRES"	,"QRY","Acrescimo"		,,010,.F. ) // Valor ICMS
	TRCell():New(oSection3,"E1_VLDECRE"	,"QRY","Decrescimo"		,,010,.F. ) // Valor Decrescimo	
	TRCell():New(oSection3,"E1_EMISSAO"	,"QRY",						,,008,.F. ) // Dt Emissao
	TRCell():New(oSection3,"E1_VENCTO"	,"QRY",						,,008,.F. ) // Dt Vencimento
	oBreak := TRBreak():New(oSection3,oSection3:Cell("A1_NOME"),"TOTAL LINHA ->",.F.)
	TRFunction():New(oSection3:Cell("E1_VALOR")		,"VLR TOTAL ","SUM"	,      ,,"@E 999,999,999,999.99"	,,.T.,.F.,.F.,oSection3) //FINAL DA SECAO

*/
			
Return(oReport)
  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PrintReport ºAutor ³Marco Aurelio      º Data ³  21/06/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de filtro dos Dados                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PrintReport(oReport)

Local cQuery			:= ""
Local aCusto			:= {}
Local aCustoT			:= {}

Private oSection1		:= oReport:Section(1)
//Private oSection2		:= oReport:Section(2)
//Private oSection3		:= oReport:Section(3)
Private _cAlias1		:= GetNextAlias()			// Movimento do Dia 
//Private _cAlias2		:= GetNextAlias()			// Movimento do Dia Anterior
//Private _cAlias3		:= GetNextAlias()			// Movimento do Mes      
//Private _cAlias4		:= GetNextAlias()			// Movimento FINANCEIRO - Dia

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definir Query Principal do Relatorio - Mov. Dia ATUAL   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

xQuery1()

oReport:StartPage()
oReport:Skipline()
oReport:Thinline()

oSection1:Init()
oSection1:SetTotalInLine(.F.)


dbSelectArea(_cAlias1)

While !oReport:Cancel() .And. (_cAlias1)->(!Eof())
	
	If oReport:Cancel()
		Exit
	EndIf
	
	oSection1:Cell("XD5_NUMSGP")		:SetValue((_cAlias1)->XD5_NUMSGP	)
//	oSection1:Cell("XD5_SERIAL") 		:SetValue((_cAlias1)->XD5_SERIAL	)
	oSection1:Cell("XD5_NUMOP")		:SetValue((_cAlias1)->XD5_NUMOP	)
	oSection1:Cell("XD5_NOTA")			:SetValue((_cAlias1)->XD5_NOTA	)
   oSection1:Cell("XD5_SERIE")		:SetValue((_cAlias1)->XD5_SERIE	)
   oSection1:Cell("XD5_CLIENT")		:SetValue((_cAlias1)->XD5_CLIENT	)    
	oSection1:Cell("XD5_LOJA")			:SetValue((_cAlias1)->XD5_LOJA   )
	oSection1:Cell("A1_NREDUZ")		:SetValue((_cAlias1)->A1_NREDUZ  )    
	oSection1:Cell("XD5_ITEM")			:SetValue((_cAlias1)->XD5_ITEM   )  
	oSection1:Cell("XD5_PECA")			:SetValue((_cAlias1)->XD5_PECA   )  		                                                                   
		
   oSection1:PrintLine()
//	oReport:ThinLine()        //linha de Separacao
	(_cAlias1)->(dbSkip()	)
		   
EndDo

// Finaliza Secao e Imprime o Total Geral, Definido no TRFUNCTION
oSection1:Finish()
oReport:EndPage()



//--------------------------------------------------------------------------------------------

/*
xQuery2()

oReport:StartPage()
oReport:Skipline()
oReport:Thinline()

oSection2:Init()
oSection2:SetTotalInLine(.F.)


dbSelectArea(_cAlias2)

While !oReport:Cancel() .And. (_cAlias2)->(!Eof())
	
	If oReport:Cancel()
		Exit
	EndIf

	oSection2:Cell("A1_NOME")		:SetValue((_cAlias2)->A1_NOME	)
	oSection2:Cell("E5_PREFIXO") 	:SetValue((_cAlias2)->E5_PREFIXO	)
	oSection2:Cell("E5_NUMERO")	:SetValue((_cAlias2)->E5_NUMERO	)
	oSection2:Cell("E5_VALOR")		:SetValue((_cAlias2)->E5_VALOR	)
   oSection2:Cell("E5_VLACRES")	:SetValue((_cAlias2)->E5_VLACRES	)
   oSection2:Cell("E5_VLDECRE")	:SetValue((_cAlias2)->E5_VLDECRE	)    
	oSection2:Cell("DT_EMISSAO")	:SetValue((_cAlias2)->E5_DATA   	)//  M U D A R  PAR  DATA  CORRERA ################################
	oSection2:Cell("E5_DATA")		:SetValue((_cAlias2)->E5_DATA   	)
		
   oSection2:PrintLine()
//	oReport:ThinLine()        //linha de Separacao
	(_cAlias2)->(dbSkip()	)
		   
EndDo

// Finaliza Secao e Imprime o Total Geral, Definido no TRFUNCTION
oSection2:Finish()
oReport:EndPage()

//--------------------------------------------------------------------------------------------------


xQuery3()

oReport:StartPage()
oReport:Skipline()
oReport:Thinline()

oSection3:Init()
oSection3:SetTotalInLine(.F.)


dbSelectArea(_cAlias3)

While !oReport:Cancel() .And. (_cAlias3)->(!Eof())
	
	If oReport:Cancel()
		Exit
	EndIf

	oSection3:Cell("A1_NOME")		:SetValue((_cAlias3)->A1_NOME	)
	oSection3:Cell("E1_PREFIXO") 	:SetValue((_cAlias3)->E1_PREFIXO	)
	oSection3:Cell("E1_NUMERO")	:SetValue((_cAlias3)->E1_NUMERO	)
	oSection3:Cell("E1_VALOR")		:SetValue((_cAlias3)->E1_VALOR		)
   oSection3:Cell("E1_VLACRES")	:SetValue((_cAlias3)->E1_VLACRES		)
   oSection3:Cell("E1_VLDECRE")	:SetValue((_cAlias3)->E1_VLDECRE	)    
	oSection3:Cell("E1_EMISSAO")	:SetValue((_cAlias3)->E1_EMISSAO   	)
	oSection3:Cell("E1_VENCTO")	:SetValue((_cAlias3)->E1_VENCTO   	)
		
   oSection3:PrintLine()
//	oReport:ThinLine()        //linha de Separacao
	(_cAlias3)->(dbSkip()	)
		   
EndDo

// Finaliza Secao e Imprime o Total Geral, Definido no TRFUNCTION
oSection3:Finish()
  
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Finalida o Relatorio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:EndPage()

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCriaPerg   ºAutor ³Marco Aurelio      º Data ³  21/06/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Perguntas do Relatorio                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fCriaPerg()
aSvAlias:={Alias(),IndexOrd(),Recno()}
i:=j:=0
aRegistros:={}
//                1      2    3                  4  5      6     7  8  9  10  11  12 13     14  15    16 17 18 19 20     21  22 23 24 25   26 27 28 29  30       31 32 33 34 35  36 37 38 39    40 41 42 43 44
AADD(aRegistros,{_cPerg,"01","NF de         ?","","","mv_ch1","C",09,00,00,"G","","mv_par01",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","SF2","","","","",""})
AADD(aRegistros,{_cPerg,"02","NF Ate        ?","","","mv_ch2","C",09,00,00,"G","","mv_par02",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","SF2","","","","",""})
AADD(aRegistros,{_cPerg,"03","OP de         ?","","","mv_ch3","C",11,00,00,"G","","mv_par03",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","SC2","","","","",""})
AADD(aRegistros,{_cPerg,"04","OP Ate        ?","","","mv_ch4","C",11,00,00,"G","","mv_par04",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","SC2","","","","",""})


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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraQry     ºAutor ³Marco Aurelio      º Data ³  21/06/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa Queries do Relatorio                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query com Notas Fiscais Emitidas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function xQuery1

   MakeSqlExpr(_cAlias1)   
   oSection1:BeginQuery()
      
   BeginSql alias _cAlias1
 
		SELECT XD5.*,A1_NREDUZ
		FROM  %table:XD5% AS XD5
		    LEFT JOIN %table:SA1% AS SA1 
		     ON XD5_CLIENT+XD5_LOJA = A1_COD+A1_LOJA
		WHERE XD5.%notDel%
			AND XD5_NOTA  BETWEEN %Exp:MV_PAR01%  AND  %Exp:MV_PAR02%   
			AND XD5_SERIE = 001
			AND XD5_NUMOP BETWEEN %Exp:MV_PAR03%  AND  %Exp:MV_PAR04%
			
   EndSql
   
	oSection1:EndQuery()

Return(_cAlias1)         

/*

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query - Tit. Baixados         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function xQuery2

   MakeSqlExpr(_cAlias2)   
   oSection2:BeginQuery()
      
   BeginSql alias _cAlias2     
   
	   SELECT * 
	   FROM %table:SE5% AS SE5 
	   WHERE 
	   	E5_DATA BETWEEN %Exp:mv_dat01%  AND  %Exp:mv_dat02%
			AND D_E_L_E_T_ = ''
			AND E5_RECPAG = 'R'
			AND SE5.%notDel%			

   EndSql

	oSection2:EndQuery()

Return(_cAlias2)         


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query - Tit. a receber        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function xQuery3

   MakeSqlExpr(_cAlias3)   
   oSection3:BeginQuery()
      
   BeginSql alias _cAlias3    
    
	   SELECT A1_NOME,E1_PREFIXO,E1_VALOR,E1_VLACRES,E1_VLDECRE,E1_EMISSAO,E1_VENCTO
	   FROM 
				%table:SE1% AS SE1, %table:SA1% AS SA1
	   WHERE 
		   E1_EMISSAO BETWEEN  %Exp:mv_dat01%  AND  %Exp:mv_dat02%
			AND E1_SALDO >0
			AND E1_CLIENTE+E1_LOJA=A1_COD+A1_LOJA
			AND SE1.%notDel%
			AND SA1.%notDel%
   EndSql

	oSection3:EndQuery()

Return(_cAlias3)         
*/