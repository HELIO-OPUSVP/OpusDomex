#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGNRETRANS บAutor  ณMichel A. Sander    บ Data ณ  20.04.2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Transmissใo automแtica da GNRE                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function GnreTrans(cGNREIni,cGNREFim,cAmbiente,lEnd,cUF)

local aXML			:= {}
local aGNRE			:= {}
local aFieldDt		:= {}
local aGnreOk		:= {}
local cRetorno		:= .T.
local cAliasSF6	:= "SF6"
local cFiltro		:= ""
local cIndex		:= ""
local cNumGNRE		:= ""
local cIdGNRE		:= ""
local cWhere		:= ""
local lStatus		:= .F.
local nA				:= 0
local nX				:= 0
local nY				:= 0
local nB				:= 0

local aArea       := GetArea()
local lRetorno    := .T.
local lOk         := .F.
local lRet        := .F.                      
local lRetCFG     := .F.

default cGNREIni	:= "ICM000000003"
default cGNREFim	:= "ICM000000003"
default cAmbiente	:= "1"
default lEnd      := .T.
default cUF       := "RS"

//RPCSetType(3)
//aAbreTab := {}
//RpcSetEnv("01","01",,,,,aAbreTab)

private aFilBrw	:= {} 
private cURL      := Padr(GetNewPar("MV_SPEDURL","http://"),250)
private cInscMun  := Alltrim(SM0->M0_INSCM)
private cIdEnt    := FSA095IDEnt()
private cVerTss   := ""
private lBtnFiltro:= .F.
private oWS		  := Nil
private oRetorno  := Nil 
private oXml	  := Nil
private cEstNota := cUF

//Realiza Conexใo com TSS

oWs:= WsSpedCfgNFe():New()
oWs:cUSERTOKEN      := "TOTVS"
oWs:cID_ENT         := cIdEnt
oWS:_URL            := AllTrim(cURL)+"/SPEDCFGNFe.apw"
lOk                 := oWs:CfgTSSVersao()

if lOk
	cVerTss := oWs:cCfgTSSVersaoResult 
else     
   lRetorno := .F.
	return ( lRetorno )
endif

if !(empty(cGNREIni) .and. empty(cGNREFim) .and. empty(cAmbiente))
	
	dbSelectArea("SF6")
	SF6->(dbSetOrder(1))
	lQuery    := .T.
	cAliasSF6 := GetNextAlias()
	
	aadd(aFieldDt,"F6_DTVENC")
	aadd(aFieldDt,"F6_DTPAGTO")
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSeleciona as guias	                                              ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cWhere := "%"
	cWhere += "SF6.F6_FILIAL='"+xFilial ("SF6")+"' AND"
	cWhere += " SF6.F6_NUMERO>='"+ cGNREIni +"' AND SF6.F6_NUMERO<='"+ cGNREFim +"' "
	cWhere += " AND (SF6.F6_TIPOIMP ='3' OR SF6.F6_TIPOIMP ='B') "
	if !empty(cEstNota)
		cWhere += "AND SF6.F6_EST = '"+cEstNota+"'"
	endif
	cWhere += "AND SF6.D_E_L_E_T_ = '' "
	cWhere += "%"
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณArquivo temporario com as guias                                    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	BeginSql Alias cAliasSF6
		
		SELECT * FROM
		%Table:SF6% SF6
		WHERE
		%Exp:cWhere%
		
		ORDER BY %Order:SF6%
	EndSql
	
	for nX := 1 To Len(aFieldDt)
		TcSetField(cAliasSF6,aFieldDt[nX],"D",8,0)
	next nX
	
	dbSelectArea (cAliasSF6)
	(cAliasSF6)->(dbGoTop ())
	
	while !(cAliasSF6)->(eof ()) .And. (xFilial("SF6") == (cAliasSF6)->F6_FILIAL)
		
		aadd(aXML,{})
		nY := Len(aXML)
		aXML[nY] := ExecBlock("GnreXMLEnv",.F.,.F.,{cAliasSF6})
		
		(cAliasSF6)->(dbSkip())
		
	enddo
	
	if len(aXML) > 0
		
		dbSelectArea("SF6")
		SF6->(dbSetOrder(1))
		
		//Gravo o Id na tabela SF6
		for nB:= 1 to len( aXML )
			
			cIdGN	  := alltrim( aXML[nB,1] )
			cUFGnre  := alltrim( substr(cIdGN,1,2)  )
			cNumGN	  := alltrim( substr(cIdGN,3,len(cIdGN)-2))
			cXml	  := aXML[nB,2]
			
			if dbSeek(xFilial("SF6")+cUFGnre+cNumGN)
				RecLock("SF6",.F.)
				SF6->F6_IDTSS  := cIdGN
				SF6->F6_XMLENV := cXml
				SF6->(MsUnlock())
			endif
		next
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณTransmissao da GNRE	                                              ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cRetorno := RemGnre(cAmbiente, aXML, @aGnreOk )
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAtualiza o status da GNRE                                          ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		if len( aGnreOk ) > 0
			for nY:=1 to len( aGnreOk )
				
				cIdGNRE  := alltrim( aGnreOk[nY,1] )
				cUFOk    := alltrim( substr(cIdGNRE,1,2)  )
				cNumGNRE := alltrim( substr(cIdGNRE,3,len(cIdGNRE)-2))
							
				if dbSeek(xFilial("SF6")+cUFOk+cNumGNRE)
					RecLock("SF6",.F.)
					SF6->F6_GNREWS := "T"
					SF6->F6_AMBIWS := cAmbiente
					SF6->F6_IDTSS  := cIdGNRE
					SF6->(MsUnlock())
				endif
			next
		endif
	Else
	   cRetorno := .F.
	endif
endif

dbSelectArea(cAliasSF6)
dbCloseArea()

return ( cRetorno )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRemGNRE   บAutor  ณMichel A. Sander    บ Data ณ  20.04.2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia o XML da GNRE				                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static function RemGnre(cAmbiente, aXML, aGnreOk )

local aErroGnre	:= {}
local cRetorno		:= .T.
local cHoraIni		:= Time()
local dDataIni		:= date()
local nX				:= 0
local nY				:= 0

default cAmbiente	:= ""
default aXML		:= {}
default aGnreOk	:= {}

if len( aXML ) > 0
	oWS := WSTSSGNRE():New()
	oWS:cUSERTOKEN:= "TOTVS"
	oWS:cIDENT 	:= cIdEnt
	oWS:cAMBIENTE := cAmbiente
	oWS:cUF		:= cEstNota
	oWS:_URL		:= AllTrim(cURL)+"/TSSGNRE.apw"
	oWS:oWSDOCS:oWSDOCUMENTOS := TSSGNRE_ARRAYOFREMESSADOCUMENTO():New()
	
	
	for nX:= 1 to len(aXML)
		aadd(oWS:OWSDOCS:OWSDOCUMENTOS:OWSREMESSADOCUMENTO,TSSGNRE_REMESSADOCUMENTO():NEW())
		oWS:OWSDOCS:OWSDOCUMENTOS:OWSREMESSADOCUMENTO[nX]:CID := aXML[nX][1]
		oWS:OWSDOCS:OWSDOCUMENTOS:OWSREMESSADOCUMENTO[nX]:CXML:= aXML[nX][2]
	next
	
	lOk := oWS:REMESSA()
	
	if (lOk <> nil .Or. lOk )
		for nY:= 1 to len( oWS:OWSREMESSARESULT:OWSDOCUMENTOS:OWSREMESSARETDOC )
			
			if type("oWS:OWSREMESSARESULT:OWSDOCUMENTOS:OWSREMESSARETDOC["+Str(nY)+"]:LSUCESSO")<>"U"
				if !(oWS:OWSREMESSARESULT:OWSDOCUMENTOS:OWSREMESSARETDOC[nY]:LSUCESSO)
					aadd(aErroGnre,{oWS:OWSREMESSARESULT:OWSDOCUMENTOS:OWSREMESSARETDOC[nY]:CID})
				else
					aadd(aGnreOk,{oWS:OWSREMESSARESULT:OWSDOCUMENTOS:OWSREMESSARETDOC[nY]:CID})
				endif
			endif
		next
		//cRetorno := "Voc๊ concluํu com sucesso a transmissใo do Protheus para o Totvs Services SPED."+Chr(13)+Chr(10)
		//cRetorno += "Consulte o Status da(s) GNRE(s) utilizando a rotina 'Monitor'."
		//cRetorno += "Foram transmitidas " +AllTrim(Str(Len(aGnreOk),18))+" GNRE(s) em "+IntToHora(SubtHoras(dDataIni,cHoraIni,Date(),Time()))+Chr(13)+Chr(10)+Chr(13)+Chr(10)
		cRetorno := .T.
	else
		//cRetorno := "Houve erro durante a transmissใo da GNRE para o Totvs Services SPED."
		cRetorno := .F.
	endif
	
	if len( aErroGnre ) > 0
		//cRetorno += "As GNRes abaixo foram recusadas, verifique a rotina 'Monitor' para saber os motivos."+Chr(13)+Chr(10)+Chr(13)+Chr(10)
		//for nX:= 1 to len ( aErroGnre )
		//	cRetorno += aErroGnre[nX,1] + CRLF +  CRLF
		//next
		cRetorno := .F.
	endif
	
Else
   cRetorno := .F.
endif

return(cRetorno)                          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMonitGnre บAutor  ณMichel A. Sander    บ Data ณ  20.04.2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monitora a GNRE					                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static function MonitGnre(cUrl, cGnreIni, cGnreFim, cAmbGNRE, aRetErro)

local oOk			:= LoadBitMap(GetResources(), "ENABLE")
local oNo			:= LoadBitMap(GetResources(), "DISABLE")

local aRetorno		:= {}
local aListBox		:= {}
local aRetErro		:= {}
local aIdTss		:= {}
local cAviso		:= ''
local cIdIni		:= ''
local cIdFim		:= ''
local cId			:= ''
local cProtocolo	:= ''
local cRecomendacao	:= ''
local cAmbiente		:= ''
local cStatusTSS	:= ''  
local cNumControl	:= ''    
local cCodBarras	:= ''
local cWhere		:= ''
local cFiltro		:= ''
local cIndex		:= ''
local cAliasSF6		:= 'F0N'
local nX			:= 0
local nY			:= 0
local nA			:= 0

default cAmbGNRE	:= ''
default cGnreIni	:= ''
default cGnreFim	:= ''
default cUrl		:= ''


if !(empty(cUrl) .And. empty(cGnreIni) .And. empty(cGnreFim) .And. empty(cAmbGNRE))
	
	//Id para enviar para o TSS
	if empty(cEstNota)
		dbselectarea('SF6')
		SF6->(dbsetorder(1))
	
		#IFDEF TOP
	
			if (TcSrvType ()<>"AS/400")
				lQuery    := .T.
				cAliasSF6 := GetNextAlias()
	
				cWhere := "%"		
				cWhere += "SF6.F6_FILIAL = '"+xFilial ("SF6")+"' AND"
				cWhere += " SF6.F6_NUMERO>= '"+ cGnreIni +"' AND SF6.F6_NUMERO<= '"+ cGnreFim +"' "
				cWhere += " AND SF6.F6_IDTSS <> '' AND SF6.D_E_L_E_T_ = ''" 
				cWhere += "%"	
	
	
				BeginSql Alias cAliasSF6
					SELECT SF6.F6_FILIAL, SF6.F6_EST, SF6.F6_NUMERO, SF6.F6_IDTSS
					FROM %Table:SF6% SF6 WHERE %Exp:cWhere% ORDER BY %Order:SF6%
				EndSql
				
			else
		#EndIf
				cIndex  := CriaTrab(NIL,.F.)
				cFiltro := 'F6_FILIAL=="'+xFilial ("SF6")+'".And.'
				cFiltro += 'F6_NUMERO >="'+ cGnreIni +'".And. SF6.F6_NUMERO <="'+ cGnreFim +'" '
				cFiltro += '.And. F6_IDTSS <> "" '
				indregua (cAliasSF6, cIndex, SF6->(IndexKey ()),, cFiltro)
				nIndex := retindex(cAliasSF6)
				#IFNDEF TOP
					dbSetIndex(cIndex+OrdBagExt())
				#ENDIF
				dbSelectArea (cAliasSF6)
				dbSetOrder (nIndex+1)
		#IFDEF TOP
			endif
		#EndIf  
	
	
		dbSelectArea (cAliasSF6)
		(cAliasSF6)->(dbGoTop ())
		 
		while !(cAliasSF6)->(eof ())
			
			aadd(aIdTss,{})	
			nA := len(aIdTss)
				
			aadd(aIdTss[nA],alltrim((cAliasSF6)->F6_IDTSS))
			
			(cAliasSF6)->(dbSkip())
		enddo	
		
		if len(aIdTss) > 0 //pego o primeiro e o ultimo id
			cIdIni		:= aIdTss[1,1]
			cIdFim		:= aIdTss[len(aIdTss),1]
		endif
		
	else // Informou UF
	
		cIdIni	:= cEstNota + cGnreIni
		cIdFim	:= cEstNota + cGnreFim

	endif

	//Comunica็ใo com o TSS
	aRetorno	:= RetMonitor(cUrl, cIdIni, cIdFim, cAmbGNRE ,@cAviso)

	if empty(cAviso)
	
		for nX := 1 to len(aRetorno)
			
			cId				:= alltrim( aRetorno[nX][1] )
			cAmbiente		:= alltrim( aRetorno[nX][2] )
			cRecomendacao	:= alltrim( aRetorno[nX][3] )
			cProtocolo		:= alltrim( aRetorno[nX][4]	) 
			cStatusTSS		:= alltrim( aRetorno[nX][7]	)	
			cErroXML		:= alltrim( aRetorno[nX][14])
			cNumControl	:= alltrim( aRetorno[nX][15]) 
			cCodBarras		:= alltrim( aRetorno[nX][16])
			
							
			aadd(aListBox,{	iif(cStatusTSS<>"5",oNo,oOk),;
								cId,;
								iif(cAmbiente == "1","Produ็ใo","Homologa็ใo"),; 							
								cProtocolo,;
								cRecomendacao,;
								cNumControl})
								
			//Se tiver erro, gravo o Id e o XML para apresentar nas Mensagens do lote
			if ! empty( cErroXML )			
				aadd(aRetErro,{ cId, cErroXML})
			endif
			
			//Se o retorno for Nใo autorizado / Autorizado pela SEFAZ atualizo a SF6
			if cStatusTSS $"4#5"					
	
				dbSelectArea("SF6")
				SF6->(dbSetOrder(1))
					
				if dbseek(xFilial("SF6")+ subStr(cId,1,2)+ subStr(cId,3,len(cId)-2))
					RecLock("SF6")
						SF6->F6_GNREWS := iif(cStatusTSS=='5',"S","N")
						SF6->F6_RECIBO := cProtocolo   
						SF6->F6_CDBARRA:= cCodBarras
						SF6->F6_NUMCTRL:= cNumControl
					MsUnlock()		
				endif							
			endif
		next	
    
	    if empty(aListBox[1,2]) 
	    	Aviso("GNRE","Nใo hแ dados",{"Ok"}) //   
	    endif
	else
		Aviso("GNRE","Nใo hแ dados",{"Ok"})	 //
	endif
endif

if empty( cEstNota )
	#IFDEF TOP
		dbSelectArea(cAliasSF6)
		dbCloseArea()
	#ELSE
		dbSelectArea(cAliasSF6)
		RetIndex(cAliasSF6)
		ferase(nIndex+OrdBagExt())
	#ENDIF
endif

Return aListBox

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetMonitor บAutor  ณMichel A. Sander    บ Data ณ  20.04.2017บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorno do Monitoramento da GNRE                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function RetMonitor(cUrl, cIdIni, cIdFim, cAmbGNRE ,cAviso)

local aRetMnt		:= {}
local cIdGNRE		:= ""   
local cAmb			:= ""  
local cDesc			:= ""  
local cRecibo		:= ""  
local cResultado	:= ""  
local cLote			:= ""  
local cStatus		:= ""  
local cHrEnvSef		:= ""  
local cHrEnvTSS		:= ""  
local cHrRecSef		:= "" 
local cXMLErro		:= ""  
local cNumContro	:= "" 
local cCodBarras	:= ""
local dDtEnvSef		:= SToD ("  /  /  ")
local dDtEnvTSS		:= SToD ("  /  /  ")
local dDtRecSef		:= SToD ("  /  /  ")  
local lOk			:= .F. 
local nX			:= 0 

default cUrl		:= ""
default cIdIni		:= ""
default cIdFim 		:= ""
default cAmbGNRE	:= ""
default cAviso		:= "" 

oWS:= WSTSSGNRE():New()
oWS:cUSERTOKEN:= "TOTVS"
oWS:cIDENT 	:= cIdEnt
oWS:cAMBIENTE := cAmbGNRE
oWS:_URL		:= AllTrim(cURL)+"/TSSGNRE.apw"
oWS:cIDINI		:= cIdIni
oWS:cIDFIM		:= cIdFim
oWS:oWSMONITORRESULT:oWSDOCUMENTOS := TSSGNRE_ARRAYOFMONITORRETDOC():New()

aadd(oWS:oWSMONITORRESULT:oWSDOCUMENTOS:oWSMONITORRETDOC,TSSGNRE_MONITORRETDOC():New())

 	lOk := oWS:MONITOR()
 	 	
 	if (lOk <> nil .Or. lOk) .And. type("oWS:OWSMONITORRESULT:OWSDOCUMENTOS:OWSMONITORRETDOC")<>"U"	
    
    	oRetorno:=	oWS:OWSMONITORRESULT:OWSDOCUMENTOS:OWSMONITORRETDOC
    		
   		for nX:= 1 to len( oRetorno ) 
			
			cIdGNRE	:= oRetorno[nX]:CID   
			cAmb		:= oRetorno[nX]:CAMBIENTE
			cDesc		:= oRetorno[nX]:CDESCRICAO
			cRecibo		:= oRetorno[nX]:CRECIBO	
			cResultado	:= oRetorno[nX]:CRESULTADO
			cLote		:= oRetorno[nX]:CLOTE
			cStatus		:= oRetorno[nX]:CSTATUS
			cHrEnvSef	:= oRetorno[nX]:CHRENVSEF
			cHrEnvTSS	:= oRetorno[nX]:CHRENVTSS
			cHrRecSef	:= oRetorno[nX]:CHRRECSEF
			dDtEnvSef	:= oRetorno[nX]:DDTENVSEF
			dDtEnvTSS	:= oRetorno[nX]:DDTENVTSS
			dDtRecSef	:= oRetorno[nX]:DDTRECSEF  
			cXMLErro	:= oRetorno[nX]:CXMLERRO
			cNumContro	:= oRetorno[nX]:CNUMCONTRO
			cCodBarras	:= oRetorno[nX]:CCODBARRAS
			                                           
			//dados para atualiza็ใo da base
			aadd(aRetMnt, {	cIdGNRE,;
								cAmb,;
								cDesc,;
								cRecibo,;	
								cResultado,;
								cLote,;
								cStatus,;
								cHrEnvSef,;
								cHrEnvTSS,;
								cHrRecSef,;
								dDtEnvSef,;
								dDtEnvTSS,;
								dDtRecSef,;
								cXMLErro,;
								cNumContro,;
								cCodBarras})
		next  
	else
		cAviso := iif( empty(getWscError(3)),getWscError(1),getWscError(3) )
	endif  
	
return aRetMnt
