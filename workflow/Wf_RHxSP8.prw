#Include "protheus.ch"
#Include "topconn.ch"
#Include "ap5mail.ch"
#Include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Wf_RHxSP8บAutor  ณ Felipe A. Melo     บ Data ณ  21/08/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Wf_RHxSP8

Local cQuery := ""
Local cKebra := Chr(13)+Chr(10)
Local aAbreTab := {"SP8","SRA","ZRA"}
Local aWfItens := {}
Local cChave   := ""

Local cWfEmp := "01"            
Local cWfFil := "01"

ConOut("Iniciano Job - Ponto Eletronico.")

//Prepara fun็ใo para ser executada via JOB/Schedule
RPCSetType(3)
aAbreTab := {}
RpcSetEnv(cWfEmp,cWfFil,,,,,aAbreTab)
SetUserDefault("000000")

cQuery := "SELECT MAX(P8_DATA) AS MAXDATA FROM " + RetSqlName("SP8") + " WHERE D_E_L_E_T_ = '' "

If Select("TEMP") <> 0
   TEMP->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "TEMP"

ConOut("Data processamento -> "+TEMP->MAXDATA+".")

//Monta Query
cQuery := cKebra+" SELECT  "
cQuery += cKebra+" P8_FILIAL, "
cQuery += cKebra+" P8_MAT, "
cQuery += cKebra+" ISNULL(RA_NOME,'MATRICULA NAO LOCALIZADA') RA_NOME, "
cQuery += cKebra+" P8_DATAAPO,  "
cQuery += cKebra+" (SELECT COUNT(*)  "
cQuery += cKebra+"      FROM SP8010 C  "
cQuery += cKebra+" 	 WHERE C.D_E_L_E_T_ <> '*' "
cQuery += cKebra+" 	   AND C.P8_FILIAL  = SP8.P8_FILIAL "
cQuery += cKebra+" 	   AND C.P8_MAT     = SP8.P8_MAT "
cQuery += cKebra+" 	   AND C.P8_TPMCREP <> 'D' "
cQuery += cKebra+" 	   AND C.P8_DATAAPO = SP8.P8_DATAAPO) AS QTD_APONT, "
cQuery += cKebra+" ISNULL(ZRA_CODIGO,'N/C') ZRA_CODIGO, 
cQuery += cKebra+" ISNULL(ZRA_NOME  ,'NAO DEFINIDO') ZRA_NOME,
cQuery += cKebra+" ISNULL(ZRA_EMAIL ,'') ZRA_EMAIL 
cQuery += cKebra+"  FROM "+RetSqlName("SP8")+" SP8(NOLOCK) "
cQuery += cKebra+"  LEFT JOIN "+RetSqlName("SRA")+" SRA(NOLOCK) ON SRA.D_E_L_E_T_ = '' AND SRA.RA_FILIAL = SP8.P8_FILIAL AND SRA.RA_MAT = SP8.P8_MAT "
cQuery += cKebra+"  LEFT JOIN "+RetSqlName("ZRA")+" ZRA(NOLOCK) ON ZRA.D_E_L_E_T_ = '' AND ZRA.ZRA_FILIAL = '"+xFilial("ZRA")+"' AND ZRA.ZRA_CODIGO = SRA.RA_XXSETOR "
cQuery += cKebra+" WHERE SP8.D_E_L_E_T_ = '' "
cQuery += cKebra+"   AND SP8.P8_DATAAPO < '"+DtoS(Date())+"' "
cQuery += cKebra+"   AND SP8.P8_DATAAPO < '"+TEMP->MAXDATA+"' "
cQuery += cKebra+"   AND SP8.P8_TPMCREP != 'D' "
cQuery += cKebra+"   AND ((SELECT COUNT(*)  "
cQuery += cKebra+"           FROM SP8010 B  "
cQuery += cKebra+" 	     WHERE B.D_E_L_E_T_ = ''  "
cQuery += cKebra+" 	       AND B.P8_FILIAL = SP8.P8_FILIAL "
cQuery += cKebra+" 	       AND B.P8_MAT = SP8.P8_MAT "
cQuery += cKebra+" 	       AND B.P8_TPMCREP != 'D' "
cQuery += cKebra+" 	       AND B.P8_DATAAPO = SP8.P8_DATAAPO)% 2) != 0 "
cQuery += cKebra+" GROUP BY ZRA_CODIGO, ZRA_NOME, ZRA_EMAIL, P8_FILIAL, P8_MAT, RA_NOME, P8_DATAAPO " //P8_FILIAL, P8_MAT, RA_NOME, P8_DATAAPO "
cQuery += cKebra+" ORDER BY ZRA_EMAIL, ZRA_CODIGO, ZRA_NOME, P8_FILIAL, P8_MAT, RA_NOME, P8_DATAAPO " //P8_FILIAL, P8_MAT, RA_NOME, P8_DATAAPO "

//Fecha Alias se estiver em Uso
If Select("SQL") > 0 ; SQL->(dbCloseArea()) ; Endif

//Monta Area de Trabalho executando a Query
TcQuery cQuery ALIAS "SQL" NEW
TcSetField("SQL","P8_DATAAPO", "D", 8, 0)

dbSelectArea("SQL")
DbGoTop()

If SQL->(!Eof())
	cChave := AllTrim(SQL->ZRA_EMAIL)
EndIf

While SQL->(!Eof())
   ConOut("Processando dados -> "+SQL->RA_NOME+".")
	If cChave != AllTrim(SQL->ZRA_EMAIL)
		//Envia Wf caso conta de e-mail preenchido
		If !Empty(aWfItens[01][08])
		   fEnviaWf(cWfEmp,aWfItens)
		EndIf
		
		//Atualiza variaveis
		aWfItens := {}
		cChave   := AllTrim(SQL->ZRA_EMAIL)
	EndIf

	//Alimenta array
	aAdd(aWfItens,Array(08))
	aWfItens[Len(aWfItens)][01] := SQL->P8_MAT
	aWfItens[Len(aWfItens)][02] := SQL->RA_NOME
	aWfItens[Len(aWfItens)][03] := DtoC(SQL->P8_DATAAPO)
	aWfItens[Len(aWfItens)][04] := StrZero(SQL->QTD_APONT,2)
	aWfItens[Len(aWfItens)][05] := "Erro: Marca็ใo Impar" // - Email Gestor: "+Alltrim(Lower(alltrim(SQL->ZRA_EMAIL)))
	aWfItens[Len(aWfItens)][06] := SQL->ZRA_CODIGO
	aWfItens[Len(aWfItens)][07] := SQL->ZRA_NOME
   aWfItens[Len(aWfItens)][08] := Alltrim(Lower(alltrim(SQL->ZRA_EMAIL)))

	SQL->(DbSkip())
End

SQL->(dbCloseArea())

//Dispara WF do ultima cliente
If Len(aWfItens) > 0 .And. !Empty(aWfItens[01][08])
	//Envia Wf para Cliente
	fEnviaWf(cWfEmp,aWfItens)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fEnviaWf บAutor  ณ Felipe A. Melo     บ Data ณ  21/08/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fEnviaWf(cWfEmp,aWfEnvia)

Local x := 0

//Monta workflow e dispara envio
oProcess:=TWFProcess():New("000001",OemToAnsi("RH - Divergencia de Apontamentos"))
oProcess:NewTask("000001","\workflow\html\Wf_RHxSP8.htm")
oHtml   := oProcess:oHtml

oProcess:ClientName(cUserName)
oProcess:UserSiga := "000000"
oProcess:cSubject := "[WF Protheus] RH - Divergencia de Apontamentos"

oProcess:cTo      := AllTrim(aWfEnvia[01][08])

oProcess:cFromName:= "WF Rosenberger"  //UsrRetName(__cUserID)
oProcess:cFromAddr:= "siga@rosenbergerdomex.com.br" //UsrRetMail(__cUserID)

oProcess:oHtml:ValByName( "cSupCodigo"		, aWfEnvia[01][06] )
oProcess:oHtml:ValByName( "cSupNome"		, aWfEnvia[01][07] )

For x:=1 To Len(aWfEnvia)
   ConOut("E-mail -> "+aWfEnvia[x][02]+".")
	aAdd((oHtml:ValByName("a.FuncCod"  )) ,aWfEnvia[x][01])
	aAdd((oHtml:ValByName("a.FuncNome" )) ,aWfEnvia[x][02])
	aAdd((oHtml:ValByName("a.DataDiv"  )) ,aWfEnvia[x][03])
	aAdd((oHtml:ValByName("a.QtdApont" )) ,aWfEnvia[x][04])
	aAdd((oHtml:ValByName("a.Obs"      )) ,aWfEnvia[x][05])
Next x

//Envia e-mail
oProcess:Start()
oProcess:Finish()
WFSendMail({"01","01"})

Return