#INCLUDE "RWMAKE.CH"
#include "ap5mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDMXTXT01  บAutor  ณMarco Aurelio       บ Data ณ  23/05/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera arquivo CSV p/ Integracao                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DMXTXT01()

PRIVATE cPerg := "DMXTXT01"


ValidPerg()

If Pergunte(cPerg)
	Processa({|| TXT01A() },"Aguarde! Selecionando Registros...",,.T.)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTXT01A    บAutor  ณMarco Aurelio        บ Data ณ  23/05/17  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TXT01A()

Local variavel
Local nInvoice := 0 
Local nValTot	:= 0
Local	cDel		:= ";"
Local cSeqArq   := "01"
Local lFim      := .F.
Local cArq		:= ""
Local dData     := DtoS(dDatabase)

 
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณBUSCA OS DADOS DA NOTAณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := " SELECT E2_PREFIXO,E2_NUM,E2_TIPO,E2_FORNECE,E2_LOJA,E2_EMISSAO,E2_VENCREA,E2_VALOR,E2_SALDO,A2_CGC, A2_NOME "
cQuery += " FROM " + RetSqlName("SE2") + " SE2 "    
cQuery += " LEFT JOIN " + RetSqlName("SA2") + " SA2 "    
cQuery += " ON E2_FORNECE+E2_LOJA = A2_COD+A2_LOJA " 
cQuery += " WHERE E2_EMISSAO BETWEEN '" +DTOS(MV_PAR01)  + "' AND '"+DTOS(MV_PAR02)+"' "
cQuery += " AND   E2_NUM     BETWEEN '" +MV_PAR04+         "' AND '"+MV_PAR05      +"' "
cQuery += " AND   E2_PREFIXO BETWEEN '" +MV_PAR06+         "' AND '"+MV_PAR07      +"' "
if !empty(MV_PAR03)
	cQuery += " AND E2_FORNECE = '"+MV_PAR03+"' "
endif
cQuery += " AND SE2.D_E_L_E_T_ = '' "
cQuery += " ORDER BY E2_FORNECE,E2_EMISSAO,E2_NUM "

cQuery := ChangeQuery(cQuery)
Iif(Select('SQL')>0,TRB->(dbCloseArea()),Nil)
dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), "TRB", .F., .T. )   //"TRB", .F., .F. )


Count To nRec
ProcRegua(nRec)

	dbSelectArea("TRB")
	dbGoTop()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณINSTRUMENTS HEADERณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_Instr01	:= "INSTR"	+cDel 		//1	INSTR	Identifier for the record	M	A	5	Fixed value expected: INSTR
	_Instr02	:= "PAY"		+cDel		//2	Instrument Type	Type of instrument	M	P	3	Fixed value expected: PAY
	_Instr03	:= ""    	+cDel // 3	Buyer reference no	Buyer's reference number for payable	O	A	32		
 	_Instr04	:= ""			+cDel		//4	Filler	Reserved for future use	O	A	8	Leave as blank
	_Instr05	:= ""			+cDel		//5	Filler	Reserved for future use	O	A	8	Leave as blank
	_Instr06	:= ""			+cDel		//6	Filler	Reserved for future use	O	A	8	Leave as blank
	_Instr07	:= ""			+cDel		//7	Filler	Reserved for future use	O	A	8	Leave as blank
	_Instr08	:= ""			+cDel		//8	Fill4er	Reserved for future use	O	A	8	Leave as blank
	_Instr09	:= ""			+cDel		//9	Filler	Reserved for future use	O	A	8	Leave as blank
	_Instr10	:= Alltrim(TRB->A2_CGC)			+cDel		//  ???????    10	Counterparty ERP ID	ID of the seller, in the buyer's ERP system	M	A	32	
 	_Instr11	:= "BR011ROSENB"+cDel	//11	Buyer Org ID	FSC Org ID of Buyer	M	A	15	This id will be provided by DB to the buyer
	_Instr12	:= "OA"		+cDel		//12	Terms of Payment	Terms agreed between the Buyer and Seller for settling the transaction	O	A	2	Fixed value expected: OA
	_Instr13	:= ""						//13	Program ID	ID of the financing program	O	A	30	Mandatory in case the buyer org is registered for multiple programs. This value will be provided by DB if required.

	//grava o INTR
	variavel := _Instr01+_Instr02+_Instr03+_Instr04+_Instr05+_Instr06+_Instr07+_Instr08+_Instr09+_Instr10+_Instr11+_Instr12+_Instr13
	variavel += (CHR(13)+CHR(10)) //pula a linha


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPAYABLE INVOICEณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cOldCfg := __SetPicture("AMERICAN")

	While !TRB->(EOF())
		IncProc()

		_Inv01	:=	"INV"					+cDel	//1	INV	Record identifier	M	P	3	Fixed value expected: INV
		_Inv02	:= TRB->E2_PREFIXO+TRB->E2_NUM	+cDel	// CNPJ //2	Invoice no	Seller's invoice reference number	M	A	32	
		_Inv03	:= TRB->E2_EMISSAO	+cDel	//3	Issue date		M	D	8	
		_Inv04	:= ""						+cDel	//4	Reference Date		O	D	8	If not provided, will consider Issue date as invoice reference date
		_Inv05	:= TRB->E2_VENCREA	+cDel	//5	Due Date		M	D	8	
		_Inv06	:= ""						+cDel	//6	Filler	Reserved for future use	O	D	8	Leave as blank
		_Inv07	:= "BRL"					+cDel	//7	Currency	Invoice currency	M	P	3	3 letter ISO code should be used    
		_Inv08	:= Alltrim(Transform(TRB->E2_SALDO,"@E 999999999999.99")) 			+cDel		//8	Amount		M	N	19.2	
		_Inv09	:= ""						+cDel		//9	Custom Field Name	Reserved for future use	O	A	128	
		_Inv10	:= ""					  				//10	Custom Field Value	Reserved for future use	O	A	256	

		variavel += _Inv01+_Inv02+_Inv03+_Inv04+_Inv05+_Inv06+_Inv07+_Inv08+_Inv09+_Inv10
		variavel += (CHR(13)+CHR(10)) //pula a linha	

		nInvoice ++
		nValTot	+= TRB->E2_SALDO
		
		TRB->(dbSkip())
	End


		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณFILE TRAILERณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤู
		
		_Ft01		:=	"FT"	+cDel											//1	File Trailer	Identifier for the record	M	P	2	Fixed value expected: FT
		_Ft02		:=	StrZero(nInvoice,04)	+cDel						//2	Total Invoices and Adjustment	Number of INV and INSTR-ADJ records in the file	M	N	8	
		_Ft03		:=	Alltrim(Transform(nValTot,"@E 999999999999.99")) 	//3	Amount checksum	Total of all INV and INSTR-ADJ  amounts (regardless of currency)	M	N	19.2	

		variavel += _Ft01+_Ft02+_Ft03
		variavel += (CHR(13)+CHR(10)) //pula a linha			
	
	TRB->(dbCloseArea())
	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณGrava็ใo do Arquivoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Path := "\SYSTEM\DMX_INTEGRA\"
	
	While ! lFim
		cArq := "DMX" + dData +"_"+cSeqArq+".CSV"
		
		If File(Path + cArq)
			cSeqArq := Soma1(cSeqArq,2)
		Else
			lFim := .T.
		Endif
	End

	Path := "\SYSTEM\DMX_INTEGRA\"+cArq
	MemoWrite(Path,variavel)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณEnvia e-mail ao departamento Financeiro sobre Arquivo Banco        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cAssunto  := "Domex - Arquivo Banco: " + cArq
	cTexto    := "Gerado Novo Arquivo para Transmissใo Bancแria: " + Path + Chr(13)+Chr(10)
	cTexto    += Chr(13)+Chr(10)
	cTexto    += "Titulos   :   " + StrZero(nInvoice,04)  + Chr(13)+Chr(10)
	cTexto    += "Total R$  :   " + TransForm(nValTot,"@E 999,999,999.99")
	cPara     := ";patricia.vieira@rdt.com.br;denis.vieira@rdt.com.br;"   + UsrRetMail(__cUserId)
	cCC       := ""
	cArquivo	 := Path
	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณMicrosiga           บ Data ณ  11/20/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria as perguntas no SX1                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidPerg()
Private i,j
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs:={}
// Grupo/Ordem/Pergunta/Perg.Espanhol/Perg.Ingles/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSPA1/DefIng1/Cnt01/Var02/Def02/DefSPA2/DefIng2/Cnt02/Var03/Def03/DefSPA3/DefIng3/Cnt03/Var04/Def04/DefSPA4/DefIng4/Cnt04/Var05/Def05/DefSPA5/DefIng5/Cnt05/Alias/Grupo

AADD(aRegs,{cPerg,"01","Data de Emissใo de  ? ","","","mv_ch1","D",08,00,00,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Data de Emissใo ate ? ","","","mv_ch2","D",08,00,00,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Fornecedor          ? ","","","mv_ch3","C",06,00,00,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","","",""})
AADD(aRegs,{cPerg,"04","Titulo de           ? ","","","mv_ch4","C",09,00,00,"G","","Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Titulo Ate          ? ","","","mv_ch5","C",09,00,00,"G","","Mv_Par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Prefixo de          ? ","","","mv_ch6","C",03,00,00,"G","","Mv_Par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Prefixo Ate         ? ","","","mv_ch7","C",03,00,00,"G","","Mv_Par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.t.)
		For j:=1 to len(aRegs[i])
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
		dbCommit()
	Endif
Next
Return
