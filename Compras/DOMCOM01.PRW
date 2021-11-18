//------------------------------------------------------------------------------------------------------------------------------------------------------//
//Wederson - OpusVp - 09/09/2014                                                                                                                        //
//------------------------------------------------------------------------------------------------------------------------------------------------------//
//Específico Rosenberger                                                                                                                                //  
//------------------------------------------------------------------------------------------------------------------------------------------------------//
//Relatório de compras.                                                                                                                                 //
//Conversão relatório 'Totvs Report'                                                                                                                    //
//------------------------------------------------------------------------------------------------------------------------------------------------------//
//
#include "Protheus.ch"
#include "topconn.ch"     
#include "tbiconn.ch"
#include "rwmake.ch"
#include "colors.ch"

#DEFINE ENTER CHR(10)+CHR(13)

User Function DOMCOM01()
Private _cPerg   := "DOMCOM01"+Space(02)
Private oReport
   
fCriaPerg(_cPerg)

If !Pergunte(_cPerg, .T.)
   Return
EndIf   

oReport:=ReportDef()
oReport:PrintDialog() 
    
Return

//------------------------------------------------------

Static Function ReportDef()
Local oReport
Local oSection
Local oBreak        

oFontN :=TFont():New("Courier New",,08,,.T.,,,,.T.,.F.)// Negrito
oFont  :=TFont():New("Courier New",,08,,.F.,,,,.F.,.F.)
 
oReport:=TReport():New("SQL","Pedido de Compras em Aberto",_cPerg,{|oReport| PrintReport(oReport)},"Relatório de Pedidos de Compras em Aberto.")
oReport:SetLandscape()
                                                        
oSec1 := TRSection():New(oReport,"Itens",{"SC7","SA2"})//,,.F.,.F.)     

TRCell():New(oSec1,"C7_NUM"          ,"SC7","Número PC"          ,X3PICTURE("C7_NUM")     ,TAMSX3("C7_NUM")[1]    ,.F.,)
TRCell():New(oSec1,"C7_ITEM"         ,"SC7","Item"               ,X3PICTURE("C7_ITEM")    ,TAMSX3("C7_ITEM")[1]   ,.F.,)
TRCell():New(oSec1,"C7_FORNECE"      ,"SC7","Fornecedor"         ,X3PICTURE("C7_FORNECE") ,TAMSX3("C7_FORNECE")[1],.F.,)
TRCell():New(oSec1,"C7_LOJA"         ,"SC7","Loja"               ,X3PICTURE("C7_LOJA")    ,TAMSX3("C7_LOJA")[1]   ,.F.,)
TRCell():New(oSec1,"A2_NREDUZ"       ,"SA2","N Fantasia"         ,X3PICTURE("A2_NREDUZ")  ,TAMSX3("A2_NREDUZ")[1] ,.F.,)
TRCell():New(oSec1,"A2_NOME"         ,"SA2","Razão Social"       ,X3PICTURE("A2_NOME")    ,TAMSX3("A2_NOME")[1]   ,.F.,)
TRCell():New(oSec1,"COMPRADOR"		 ," ","Comprador" ,/*Picture*/,40,/*lPixel*/,{||Alltrim(ImpCompr("SQL")) }) //"ENTREGA PREVISTA :  "
TRCell():New(oSec1,"C7_PRODUTO"      ,"SC7","Produto"            ,X3PICTURE("C7_PRODUTO") ,TAMSX3("C7_PRODUTO")[1],.F.,)
TRCell():New(oSec1,"C7_DESCRI"       ,"SC7","Descrição"          ,X3PICTURE("C7_DESCRI")  ,TAMSX3("C7_DESCRI")[1] ,.F.,)
TRCell():New(oSec1,"C7_QUANT"        ,"SC7","Quantidade"         ,X3PICTURE("C7_QUANT")   ,TAMSX3("C7_QUANT")[1]  ,.F.,)
TRCell():New(oSec1,"C7_QUJE"         ,"SC7","Qtd Entregue"       ,X3PICTURE("C7_QUJE")    ,TAMSX3("C7_QUJE")[1]   ,.F.,)
TRCell():New(oSec1,"C7_EMISSAO"      ,"SC7","Dt. Emissão"        ,X3PICTURE("C7_EMISSAO") ,TAMSX3("C7_EMISSAO")[1],.F.,)
TRCell():New(oSec1,"C7_DATPRF"       ,"SC7","Dt. Entrega"        ,X3PICTURE("C7_DATPRF")  ,TAMSX3("C7_DATPRF")[1] ,.F.,)
TRCell():New(oSec1,"C7_PRECO"        ,"SC7","Vlr Unitário"       ,X3PICTURE("C7_PRECO")   ,TAMSX3("C7_PRECO")[1]  ,.F.,)
TRCell():New(oSec1,"C7_TOTAL"        ,"SC7","Vlr Total"          ,X3PICTURE("C7_TOTAL")   ,TAMSX3("C7_TOTAL")[1]  ,.F.,)
TRCell():New(oSec1,"C7_DMXOB1"       ,"SC7","Follow Up 1 "       ,X3PICTURE("C7_DMXOB1")  ,TAMSX3("C7_DMXOB1")[1] ,.F.,)
TRCell():New(oSec1,"C7_DMXOB2"       ,"SC7","Follow Up 2 "       ,X3PICTURE("C7_DMXOB2")  ,TAMSX3("C7_DMXOB2")[1] ,.F.,)
TRCell():New(oSec1,"C7_DMXOB3"       ,"SC7","Follow Up 3 "       ,X3PICTURE("C7_DMXOB3")  ,TAMSX3("C7_DMXOB3")[1] ,.F.,)
TRCell():New(oSec1,"C7_OBS"          ,"SC7","Observação"         ,X3PICTURE("C7_OBS")     ,TAMSX3("C7_OBS")[1]    ,.F.,)
  
Return oReport

//------------------------------------------------------

Static Function PrintReport(oReport) 
Local cSql     := ""
Local oSec1    := oReport:Section(1) 
Local cDataDe  := Dtos(MV_PAR01) 
Local cDataAte := Dtos(MV_PAR02) 
Local cFornDe  := MV_PAR03 
Local cFornAte := MV_PAR04     
Local cComprDe := MV_PAR05
Local cComprAt := MV_PAR06

cSql := "SELECT * FROM  " + RetSqlName("SC7") + " SC7 ," + ENTER
cSql += RetSqlName("SA2") + " SA2 " + ENTER
cSql += " WHERE C7_FORNECE = A2_COD" + ENTER

cSql += " AND C7_LOJA = A2_LOJA" + ENTER
cSql += " AND C7_EMISSAO BETWEEN '" + (cDataDe) + "' AND '" + (cDataAte) + "'"  + ENTER   
cSql += " AND C7_FORNECE BETWEEN '" + (cFornDe) + "' AND '" + (cFornAte) + "'"  + ENTER   
cSql += " AND C7_QUANT > C7_QUJE"  + ENTER   
cSql += " AND C7_ENCER <>  'E'"  + ENTER   
cSql += " AND C7_RESIDUO <> 'S'"  + ENTER   
cSql += " AND SC7.D_E_L_E_T_ = ' ' 
cSql += " AND SA2.D_E_L_E_T_ = ' ' 
cSql += " AND C7_USER BETWEEN '" + cComprDe + "' AND '" +  cComprAt + "' "
cSql += " ORDER BY C7_NUM,C7_ITEM "

dbUseArea(.T., "TOPCONN", TcGenQry(,,cSql), "SQL", .T., .T.)

TcSetField("SQL","C7_EMISSAO"   ,"D",  8, 0)
TcSetField("SQL","C7_DATPRF"    ,"D",  8, 0)
TcSetField("SQL","C7_RDTEMB"    ,"D",  8, 0)

dbSelectArea("SQL")
dbGotop()
oSec1:Init() 
oReport:SetMeter(RecCount())             
While !Eof()               
      oSec1:Cell("C7_NUM"          ):SetValue(SQL->C7_NUM)
      oSec1:Cell("C7_ITEM"         ):SetValue(SQL->C7_ITEM)
      oSec1:Cell("C7_FORNECE"      ):SetValue(SQL->C7_FORNECE)
      oSec1:Cell("C7_LOJA"         ):SetValue(SQL->C7_LOJA)
      oSec1:Cell("A2_NREDUZ"       ):SetValue(SQL->A2_NREDUZ)
      oSec1:Cell("A2_NOME"         ):SetValue(SQL->A2_NOME)
      oSec1:Cell("C7_PRODUTO"      ):SetValue(SQL->C7_PRODUTO)
      oSec1:Cell("C7_DESCRI"       ):SetValue(SQL->C7_DESCRI)
      oSec1:Cell("C7_QUANT"        ):SetValue(SQL->C7_QUANT)
      oSec1:Cell("C7_QUJE"         ):SetValue(SQL->C7_QUJE)
      oSec1:Cell("C7_EMISSAO"      ):SetValue(SQL->C7_EMISSAO)
      oSec1:Cell("C7_DATPRF"       ):SetValue(SQL->C7_DATPRF)
//      oSec1:Cell("C7_RDTEMB"       ):SetValue(SQL->C7_RDTEMB)
      oSec1:Cell("C7_PRECO"        ):SetValue(SQL->C7_PRECO)
      oSec1:Cell("C7_TOTAL"        ):SetValue(SQL->C7_TOTAL)
      oSec1:Cell("C7_DMXOB1"       ):SetValue(SQL->C7_DMXOB1)
      oSec1:Cell("C7_DMXOB2"       ):SetValue(SQL->C7_DMXOB2)
      oSec1:Cell("C7_DMXOB3"       ):SetValue(SQL->C7_DMXOB3)     
      oSec1:Cell("C7_OBS"          ):SetValue(SQL->C7_OBS)     
      oSec1:PrintLine()
      oReport:IncMeter()                       
      dbSkip()
End   
oSec1:Finish()
oSec1:SetPageBreak(.T.)
dbSelectArea("SQL")  
DbCloseArea()   
Return          

//------------------------------------------------------

Static Function fCriaPerg()
aSvAlias:={Alias(),IndexOrd(),Recno()}
i:=j:=0
aRegistros:={}
//                1      2    3               4  5     6      7  8  9  10 11  12 13         14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43
AADD(aRegistros,{_cPerg,"01","Data de Emissão de ?  ","","","mv_ch1","D",08,00,00,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"02","Data de Emissão ate ? ","","","mv_ch2","D",08,00,00,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"03","Fornecedor de ?       ","","","mv_ch3","C",06,00,00,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","","",""})
AADD(aRegistros,{_cPerg,"04","Fornecedor ate ?      ","","","mv_ch4","C",06,00,00,"G","","Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","","",""})

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



Static Function ImpCompr(cAliasSC7)

Local aArea   := GetArea()
Local cComprador := ""

DbSelectArea("SY1")
SY1->(DbSetOrder(3))
If SY1->(DbSeek(xFilial("SY1") + (cAliasSC7)->C7_USER))
	cComprador := UPPER(ALLTRIM(SY1->Y1_NOME))
EndIf                                 

RestArea(aArea)

Return(cComprador)


