#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATCLIPRODºAutor  ³Juliano F. da Silva º Data ³  07/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de produtos faturados conforme NF                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FTCLIPRO()
Local oReport

oReport:= ReportDef()
oReport:PrintDialog()   
//oReport:PrintDialog()                 
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função principal Relatório.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function ReportDef()
Local oReport     
Local oSection
Local oBreak

oReport := TReport():New("FTCLIPRO","Itens Faturados","Z_FAT2",{|oReport| PrintReport(oReport)},"Relatorio de Itens Faturados")
//oReport:=SetLandscape()
oSection :=TRSection():New(oReport,"NOTAS FISCAIS",{"SD2","SC5","SC6","SA1"})

TRCell():New(oSection,"C5_EMISSAO" ,"SC5","Dt.Em.OF")
TRCell():New(oSection,"D2_PEDIDO"  ,"SD2","N. OF")
TRCell():New(oSection,"D2_DOC"     ,"SD2","Nr.Nt Fis")
TRCell():New(oSection,"D2_EMISSAO" ,"SD2","Dt NF")
TRCell():New(oSection,"D2_CLIENTE" ,"SD2","Cliente")
TRCell():New(oSection,"D2_COD"     ,"SD2","Cod.RDT")
TRCell():New(oSection,"C6_SEUCOD"  ,"SC6","Cod Cli")
TRCell():New(oSection,"C6_SEUDES"  ,"SC6","Item Cli")
TRCell():New(oSection,"D2_QUANT"   ,"SD2","Qtd.")
TRCell():New(oSection,"C6_PRCVEN"  ,"SC6","Vlr S/IPI")
TRCell():New(oSection,"D2_PRCVEN"  ,"SD2","Prc Ven")
TRCell():New(oSection,"D2_TOTAL"   ,"SD2","Vlr Total")
If !GetMV("MV_XXINVDT")   // tratado na segunda inversão
   //TRCell():New(oSection,"C6_DTFATUR" ,"SC6","Dt Fatur")  // Tratado
   TRCell():New(oSection,"C6_ENTRE3" ,"SC6","Dt Fatur")  // Tratado
Else
   TRCell():New(oSection,"C6_ENTREG"  ,"SC6","Dt Fatur")  // Tratado
EndIf
TRCell():New(oSection,"C5_ESP1"    ,"SC5","Ped. Cli")

Return oReport

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função de filtro dos Dados.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function PrintReport(oReport)
Local oSection := oReport:Section(1)
Local cPart
Local cFiltro   := ""

#IFDEF TOP
   //Transforma parametros do tipo Range em expressao SQL para ser utilizada na query
   MakeSqlExpr("Z_FAT2")
   oSection:BeginQuery()

If U_VALIDACAO("OSMAR")
   BeginSql alias "QRYSA1"
   SELECT 
   SD2.D2_PEDIDO, 
   SD2.D2_DOC, 
   SD2.D2_EMISSAO, 
   SD2.D2_CLIENTE, 
   SD2.D2_COD,
   SD2.D2_QUANT, 
   (SD2.D2_PRCVEN *((SD2.D2_IPI/100)+1)) AS D2_PRCVEN, 
   (SD2.D2_TOTAL*((SD2.D2_IPI/100)+1)) AS D2_TOTAL,
   SC5.C5_EMISSAO, 
   SC5.C5_ESP1,
   SC6.C6_SEUCOD, 
   SC6.C6_SEUDES, 
   SC6.C6_PRCVEN, 
   SC6.C6_DTFATUR,
   SC6.C6_ENTREG,
   SC6.C6_ENTRE3,
   SA1.A1_NOME
   FROM 
   %table:SD2% AS SD2, 
   %table:SC5% AS SC5,  
   %table:SC6% AS SC6,
   %table:SA1% AS SA1    
   WHERE SD2.D2_PEDIDO = SC5.C5_NUM 
   AND SC5.%notDel%  
   AND SD2.D2_PEDIDO = SC6.C6_NUM 
   AND SD2.D2_COD = SC6.C6_PRODUTO
   AND SD2.D2_ITEMPV =SC6.C6_ITEM
   AND SC6.%notDel%
   AND SD2.D2_CLIENTE = SA1.A1_COD   
   AND SD2.D2_LOJA    = SA1.A1_LOJA
   AND SD2.D2_EMISSAO >= %Exp:mv_par01%   
   AND SD2.D2_EMISSAO <= %Exp:mv_par02%
   AND SA1.A1_NOME >= %Exp:mv_par03%
   AND SA1.A1_NOME <= %Exp:mv_par04%
   AND SD2.%notDel%
   EndSql
Else
   BeginSql alias "QRYSA1"
   SELECT 
   SD2.D2_PEDIDO, 
   SD2.D2_DOC, 
   SD2.D2_EMISSAO, 
   SD2.D2_CLIENTE, 
   SD2.D2_COD,
   SD2.D2_QUANT, 
   (SD2.D2_PRCVEN *((SC6.C6_IPI/100)+1)) AS D2_PRCVEN, 
   (SD2.D2_TOTAL*((SC6.C6_IPI/100)+1)) AS D2_TOTAL,
   SC5.C5_EMISSAO, 
   SC5.C5_ESP1,
   SC6.C6_SEUCOD, 
   SC6.C6_SEUDES, 
   SC6.C6_PRCVEN, 
   SC6.C6_DTFATUR,
   SC6.C6_ENTREG,
   SC6.C6_ENTRE3,
   SA1.A1_NOME
   FROM 
   %table:SD2% AS SD2, 
   %table:SC5% AS SC5,  
   %table:SC6% AS SC6,
   %table:SA1% AS SA1    
   WHERE SD2.D2_PEDIDO = SC5.C5_NUM 
   AND SC5.%notDel%  
   AND SD2.D2_PEDIDO = SC6.C6_NUM 
   AND SD2.D2_COD = SC6.C6_PRODUTO
   AND SD2.D2_ITEMPV =SC6.C6_ITEM
   AND SC6.%notDel%
   AND SD2.D2_CLIENTE = SA1.A1_COD   
   AND SD2.D2_LOJA    = SA1.A1_LOJA
   AND SD2.D2_EMISSAO >= %Exp:mv_par01%   
   AND SD2.D2_EMISSAO <= %Exp:mv_par02%
   AND SA1.A1_NOME >= %Exp:mv_par03%
   AND SA1.A1_NOME <= %Exp:mv_par04%
   AND SD2.%notDel%
   EndSql
EndIf
   oSection:EndQuery()

   //oSection2:SetParentQuery()
   //oSection2:SetParentFilter({|cParam| QRYSA3->A1_VEND >= cParam .and. QRYSA3->A1_VEND <= cParam},{|| QRYSA3->A3_COD})
   /*
   Prepara relatorio para executar a query gerada pelo Embedded SQL passando como
   parametro a pergunta ou vetor com perguntas do tipo Range que foram alterados
   pela funcao MakeSqlExpr para serem adicionados a query
   */
   //    oSection:EndQuery()
#ELSE

#ENDIF   

oSection:Print()

Return
