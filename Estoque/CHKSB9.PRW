#INCLUDE "Protheus.ch"
#INCLUDE "RwMake.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "Tbiconn.ch"
#INCLUDE "FwBrowse.ch"
#INCLUDE "fwmvcdef.ch"
#include "MSOle.Ch"
#Include "colors.ch"
#Include "FWPrintSetup.ch"
#Include "RPTDEF.CH"   
#Include "totvs.ch"

//
User Function CHKSB9()
Local cQuery := ""
Local aDados := {}
PRIVATE aDIF    := {}

cQuery := "select * from SB9010 WHERE B9_DATA='20191031' AND D_E_L_E_T_='' AND B9_LOCAL='01' "

If Select("TEMP") > 0
    TEMP-> (DBCLOSEAREA())    
EndIf 


TCQUERY cQuery NEW ALIAS "TEMP"

while TEMP->(!EOF())
    AADD(aDados,{TEMP->B9_COD,TEMP->B9_LOCAL,CTOD('31/10/2019')+1,TEMP->B9_QINI,TEMP->B9_VINI1, TEMP->R_E_C_N_O_})
    TEMP->(DBSKIP())
end

FWMsgRun(, {|oSay| PROCRUN(aDados)   },    "Processando" , "Processando CALCEST |SB9 x Final|...")	         	  	


Return

Static Function ProcRun(aSB9)
Local aResult := {}
//Local aDIF    := {}


FOR x := 1 to Len(aSB9)
//passa os dados produto / local / data
    aResult := CalcEst(aSB9[x][1],aSB9[x][2],aSB9[x][3])
    If aSB9[x][4]<>aResult[1]
                 //PRODUTOB9, LOCALB9,    DATAB9,     QINIB9,    VINIB9,   RECNOB9,  QCALCES,   VCALCEST    
        AADD(aDif,{aSB9[x][1],aSB9[x][2],aSB9[x][3],aSB9[x][4],aSB9[x][5],aSB9[x][6],aResult[1],aResult[2]})
    EndIf
NEXT X


fdados()

Return 

Static Function fdados()
Local cArq

cArq := MntArq()

OpenExcel(cArq)

Return Nil


Static Function OpenExcel(cArq)

If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")
	Return
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cArq)
oExcelApp:SetVisible(.T.)

Return Nil


Static Function MntArq()
Local cArquivo  := CriaTrab(,.F.)
Local cDirDocs  := MsDocPath()
Local cPath		  := AllTrim(GetTempPath())
Local nHandle
Local cBuffer := "" 

cArquivo += ".CSV"

nHandle := FCreate(cDirDocs + "\" + cArquivo)

If nHandle == -1
	MsgStop("Erro na criação do arquivo na estação local. Contate o administrador do sistema")
	Return
EndIf
                   
//Linha de Cabeçalho 

cBuffer += "Relatório de Estoque SHA;"
cBuffer += CRLF
cBuffer += UsrRetName(RetCodUsr())    
cBuffer += dtoc(date())
cBuffer += Time()
              
cBuffer += CRLF               


cBuffer += "PRODUTO B9;"
cBuffer += "ARMAZEM B9;"
cBuffer += "QUANTIDADE B9;"
cBuffer += "VALOR B9;"
cBuffer += "RECNO B9;"
cBuffer += "QTD CALCEST;"
cBuffer += "VLR CALCEST;"



cBuffer += CRLF               

FWRITE(nHandle, cBuffer) 


RunQry(nHandle)

FClose(nHandle)

CpyS2T(cDirDocs + "\" + cArquivo, cPath, .T.)

Return cPath+cArquivo

Static Function RunQry(nHandle)
Local cBuffer              

INCLUI := .F.


For x := 1 to len(aDif)    
	
	cBuffer := ""  
	cBuffer += ValtoXlx(aDif[x][1])+";"
	cBuffer += ValtoXls(aDif[x][2])+";"
	cBuffer += ValtoXls(aDif[x][4])+";"	
	cBuffer += ValtoXls(aDif[x][5])+";"
	cBuffer += ValtoXls(aDif[x][6])+";"
	cBuffer += ValtoXls(aDif[x][7])+";"
	cBuffer += ValtoXls(aDif[x][8])+";"
	cBuffer += CRLF               
	//

	FWRITE(nHandle,cBuffer)
	
next x

Return Nil

//Tratando o tipo do dado
Static Function ValToXls(xValue)
Do Case
	Case ValType(xValue) == "C"
		xValue := StrTran(xValue, Chr(34), Chr(34) + Chr(34))
		xValue := StrTran(xValue,Chr(10),'')
		xValue := StrTran(xValue,Chr(13),'')		
		xValue := Chr(34) + AllTrim(xValue) + Chr(34)
		
	Case ValType(xValue) == "N"
		xValue := Strtran(AllTrim(Str(xValue)),".",",")
		
	Case ValType(xValue) == "D"
		xValue := DToC(xValue)
		
	Case ValType(xValue) == "U"
		xValue := ""
EndCase          

Return xValue                        



//Tratando o tipo do dado
Static Function ValToXlx(xValue)
Do Case
	Case ValType(xValue) == "C"
		xValue := StrTran(xValue, Chr(34), Chr(34) + Chr(34))
		xValue := StrTran(xValue,Chr(10),'')
		xValue := StrTran(xValue,Chr(13),'')		
		xValue := Chr(34) + AllTrim(xValue) + Chr(34)
		
	Case ValType(xValue) == "N"
		xValue := Strtran(AllTrim(Str(xValue)),".",",") 
		xValue := SPACE(1)+xValue
		
	Case ValType(xValue) == "D"
		xValue := DToC(xValue)
		
	Case ValType(xValue) == "U"
		xValue := ""
EndCase          

Return xValue