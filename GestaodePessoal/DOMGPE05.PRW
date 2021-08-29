//---------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//Gestão de Pessoal                                                                                                                                                    //
//Holerith                                                                                                                                                             //
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------//

#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "ap5mail.ch"
#Include "rwmake.ch"
#Include "colors.ch"

User Function DOMGPE05()

Private cBuffer,nHd13,nBtLidos,nHdl3,aLog,cEol
Private _dData,_cPara,_cCopia,nHdlChk,_aLog,_nSituacao
Private _cArquivo,_aProvento,_aDesconto,_aBase,cPerg
Private _nTotProv,_nTotDesc,_nLiquido,_cAno,_cMes,_cFolha,_nFGTS
Private _dDatPgt:=dDataBase
Private _cSemana
Private _nValorSal :=0
Private _cAttach
Private lEnviado := .F.

_dData      := Ctod("  /  /  ")
_cPara      := Space(50)
_cCopia     := Space(50)
_aLog       := {}
_aProvento  := {}
_aDesconto  := {}
_aBase      := {}
_aCampos    := {}
_cPerg      := "DOMGPE0502"
_nOpc       := 1
_nBaseIr    := 0
_nBaseDepIr := 0

fCriaPerg()

If Pergunte(_cPerg,.T.)
	
	_cCcDe    :=Mv_Par01
	_cCcAte   :=Mv_Par02
	_cMatDe   :=Mv_Par03
	_cMatAte  :=Mv_Par04
    _cNomDe  :=Upper(Mv_Par05)
    _cNomAte :=Upper(Mv_Par06)
	_nSituacao:=Mv_Par07
	_cProcesso:=Mv_Par08
	_cRoteiro :=Mv_Par09
	_cPeriodo :=Mv_Par10
	_cSemana  :=Mv_Par11


	RCH->(dbSetOrder(1))
	If RCH->(dbSeek(xFilial("RCH")+_cProcesso+_cPeriodo+_cSemana+_cRoteiro))
	   If RCH->RCH_STATUS == "5"
	      _nOpc :=2
	   EndIf   
	EndIf
	
	fGeraBrw()                                       
	
	DbSelectArea("TMP")
	DbGoTop()
	If RecCount() > 0
		
		aadd(_aCampos , {"RA_FILIAL"   ,"Filial"      ,"@!","02","0"})
		aadd(_aCampos , {"RA_MAT"	    ,"Matricula"   ,"@!","06","0"})
		aadd(_aCampos , {"RA_NOME"	    ,"Nome"        ,"@!","50","0"})
		aadd(_aCampos , {"RA_EMAIL2"   ,"Email"       ,"@!","40","0"})
		
		@ 000,013 To 420,850 Dialog oMov Title "Recibo de pagamento - Rosenberger - "+If(_cRoteiro=="FOL","Folha de Pagamento",If(_cRoteiro=="ADI","Adiantamento",If(_cRoteiro=="131","1a. Parcela 13o.",IIF(_cRoteiro=="PLR","PLR","2a. Parcela 13o."))))+' - '+AllTrim(MesExtenso(SubStr(_cPeriodo,5,2)))+'/'+Substr(_cPeriodo,1,4)
		@ 002,002 To 180,415 Browse "TMP" Fields _aCampos
		@ 188,210 Button "Enviar "  Size 55,15 Action Processa({|| fSendArq() },"Gerando arquivo...")
		@ 188,280 Button "Imprimir "  Size 55,15 Action Processa({|| fOkPrint() },"Gerando arquivo...")
		@ 188,350 Button "Fechar  "  Size 55,15 Action Close(oMov)
		
		Activate Dialog oMov Centered
		
		If Len(_aLog)>0
			fImpLog()
		EndIf
	Else
		MsgBox("Nao ha informacoes para exibir.","Atenção","STOP")
	Endif
EndIf
If Select("SQL") > 0
	SQL->(dbCloseArea())
EndIf
If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf
Return

//-------------------------------------------------------

Static Function fOkPrint()
oPrint:= TMSPrinter():New( "Recibo de pagamento Rosenberger" )
oPrint:SetPortrait() // SetLandscape() ou SetPortrait()
oPrint:StartPage()   // Inicia uma nova página
nX:=0

fOkProc(oPrint,{},{},{},{},{},{})

nX := nX + 1
oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir

Return

//-------------------------------------------------------

Static Function fOkProc(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
Local nReem
Local nOrder
Local cCondBus
Local nSavRec
Local aSavRec := {}
Local nLinObs := 0
Local cFiltro := ""

_npula:=0
_npag :=1

//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
//                        1      2 3  4    5  6  7   8  9   0
oFont7   := TFont():New("Courier New",9,7,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8   := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.) 
oFont9   := TFont():New("Courier New",9,9,.T.,.F.,5,.T.,5,.T.,.F.)
oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10n := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11  := TFont():New("Arial",9,11,.T.,.F.,5,.T.,5,.T.,.F.)
oFont11n := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14  := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)
cLogo    := "\Logo\RDT.png"

oPrint:Setup()

dbSelectArea("TMP")
dbGotop()
ProcRegua(RecCount())
Do While.Not.Eof()
	
	fGeraDados()	
	
	oPrint:StartPage()   // Inicia uma nova página
		
	_nX  := 1
	nRow1:= 0
	
	While _nX <=2
		//               linha,coluna,impressao,linha,coluna
		oPrint:SayBitmap(nRow1+0050,060,cLogo,254,212)//logo da empresa
		
		//Montando caixa superior
		oPrint:Line (nRow1+0030,050,nRow1+0030,2400)//= _________
		oPrint:Line (nRow1+0030,050,nRow1+0280,0050)//= |
		oPrint:Line (nRow1+0030,2400,nRow1+0280,2400)//= |
		oPrint:Line (nRow1+0280,050,nRow1+0280,2400)//= _________
		
		//Informações da empresa dentro da caixa superior
		oPrint:Say  (nRow1+0050,380,"Empresa: ",oFont10 )
		oPrint:Say  (nRow1+0050,550,alltrim(SM0->M0_NOMECOM),oFont10 )
		
		oPrint:Say  (nRow1+0050,1550,"CNPJ: ",oFont10n )
		oPrint:Say  (nRow1+0050,1680,substr(SM0->M0_CGC,1,2)+"."+substr(SM0->M0_CGC,3,3)+"."+substr(SM0->M0_CGC,6,3)+"/"+substr(SM0->M0_CGC,9,4)+"-"+substr(SM0->M0_CGC,13,2),oFont10n  )
		
		CTT->(DbSetOrder(1))
		CTT->(DbSeek(xFilial("CTT")+TMP->RA_CC))
		
		oPrint:Say  (nRow1+0100,380,"C.Custo: ",oFont10n )
		oPrint:Say  (nRow1+0100,550,Trim(TMP->RA_CC)+"-"+CTT->CTT_DESC01,oFont10 )
		
		oPrint:Say  (nRow1+0150,380,"Matricula: ",oFont10n )
		oPrint:Say  (nRow1+0150,550,TMP->RA_MAT,oFont10 )
		
		oPrint:Say  (nRow1+0150,1350,"Nome: ",oFont10n )
		oPrint:Say  (nRow1+0150,1480,TMP->RA_NOME,oFont10 )
		
		SRJ->(DbSetOrder(1))
		SRJ->(DbSeek(xFilial("SRJ")+TMP->RA_CODFUNC))
		
		oPrint:Say  (nRow1+0200,380,"Funcao: ",oFont10n )
		oPrint:Say  (nRow1+0200,550,TMP->RA_CODFUNC+"-"+SRJ->RJ_DESC,oFont10 )
		
		oPrint:Say  (nRow1+0200,1350,"Salário: ",oFont10n )
		oPrint:Say  (nRow1+0200,1480,Transform(_nValorSal,"@E 99,999,999.99"),oFont10 )
		
		//cabecalho
		oPrint:Line (nRow1+0290,0050,nRow1+0390,0050)//= |
		oPrint:Line (nRow1+0290,0050,nRow1+0290,2400)//= _________
		oPrint:Say  (nRow1+0320,0070,'Recibo - '+If(_cRoteiro=="FOL","Folha de Pagamento",If(_cRoteiro=="ADI","Adiantamento",If(_cRoteiro=="131","1a. Parcela 13o.",IIF(_cRoteiro=="PLR","PLR","2a. Parcela 13o."))))+' - '+AllTrim(MesExtenso(SubStr(_cPeriodo,5,2)))+'/'+Substr(_cPeriodo,1,4),oFont14n)		
		oPrint:Line (nRow1+0390,0050,nRow1+0390,2400)//= _________
		oPrint:Line (nRow1+0290,2400,nRow1+0390,2400)//= |
		
		oPrint:Line (nRow1+0400,0050,nRow1+0500,0050)//= |
		oPrint:Line (nRow1+0400,2400,nRow1+0500,2400)//= |
		oPrint:Line (nRow1+0400,1270,nRow1+0500,1270)// |
		oPrint:Line (nRow1+0400,0050,nRow1+0400,2400)//= _________
		oPrint:Line (nRow1+0500,0050,nRow1+0500,2400)//= _________
		oPrint:Say  (nRow1+0420,0070,"PROVENTOS",oFont14n)
		oPrint:Say  (nRow1+0420,1300,"DESCONTOS",oFont14n)
		
		_nDet  := nRow1+0500
		nRow1  := nRow1+0510
		_nCount:= 1
		_nProv := 1
		_nDeb  := 1
		
		_nTamMax:=If(Len(_aProvento)>Len(_aDesconto),Len(_aProvento),Len(_aDesconto))
		
		While _nCount <= _nTamMax
			If _nCount<=Len(_aProvento)
				oPrint:Say(nRow1,0070,_aProvento[_nCount][1]+" - "+_aProvento[_nCount][2],oFont9)
				If _aProvento[_nCount][5] == "H".And._nX==1//Converte centesimal para sexagenal
				   _nDecimal:=Val(SubStr(_aProvento[_nCount][4],AT(",",_aProvento[_nCount][4])+1)) 
				   _nHora   :=Round((_nDecimal/100)*60,0)
				   _aProvento[_nCount][4]:= SubStr(_aProvento[_nCount][4],1,AT(",",_aProvento[_nCount][4]))+StrZero(_nHora,2)
				EndIf
				oPrint:Say(nRow1,0890,_aProvento[_nCount][4],oFont9)
				oPrint:Say(nRow1,1085,_aProvento[_nCount][3],oFont9)
			EndIf
			If _nCount<=Len(_aDesconto)
				oPrint:Say(nRow1,1300,_aDesconto[_nCount][1]+" - "+_aDesconto[_nCount][2],oFont9)
				If _aDesconto[_nCount][5] == "H".And._nX==1//Converte centesimal para sexagenal
				   _nDecimal:=Val(SubStr(_aDesconto[_nCount][4],AT(",",_aDesconto[_nCount][4])+1)) 
				   _nHora   :=Round((_nDecimal/100)*60,0)
				   _aDesconto[_nCount][4]:= SubStr(_aDesconto[_nCount][4],1,AT(",",_aDesconto[_nCount][4]))+StrZero(_nHora,2)
				EndIf
				oPrint:Say(nRow1,2020,_aDesconto[_nCount][4],oFont9)				
				oPrint:Say(nRow1,2215,_aDesconto[_nCount][3],oFont9)
			EndIf
			_nCount ++
			If _nCount > _nTamMax
				Exit
			EndIf
			nRow1 += 45
		End
		_nCount:=_nTamMax
		oPrint:Line (_nDet,0050,(_nCount*45)+_nDet+200,0050)//= |
		oPrint:Line (_nDet,1270,(_nCount*45)+_nDet+200,1270)// |
		oPrint:Line (_nDet,2400,(_nCount*45)+_nDet+200,2400)//= |
		oPrint:Line ((_nCount*45)+_nDet+200,0050,(_nCount*45)+_nDet+200,2400)//= __
		nRow1 :=    ((_nCount*45)+_nDet+250)
		oPrint:Say  (nRow1,0070,"Total proventos",oFont10)
		oPrint:Say  (nRow1,1100,TransForm(_nTotProv,"@E 99,999.99"),oFont10)
		oPrint:Say  (nRow1,1300,"Total descontos",oFont10)
		oPrint:Say  (nRow1,2230,TransForm(_nTotDesc,"@E 99,999.99"),oFont10)
		nRow1 +=50
		oPrint:Line ((_nCount*45)+_nDet+200,0050,nRow1,0050)//= |
		oPrint:Line ((_nCount*45)+_nDet+200,1270,nRow1,1270)// |
		oPrint:Line ((_nCount*45)+_nDet+200,2400,nRow1,2400)//= |
		oPrint:Line (nRow1,0050,nRow1,2400)//= __
		nRow1 +=50
		oPrint:Say  (nRow1,0070,"Base IRRF",oFont8)                     
		oPrint:Say  (nRow1,0330,TransForm(_nBaseIr,"@E 99,999.99"),oFont8)
		oPrint:Say  (nRow1,0470,"Ded. Dep. IRRF",oFont8)            
		oPrint:Say  (nRow1,0760,TransForm(_nBaseDepIr,"@E 99,999.99"),oFont8)
		oPrint:Say  (nRow1,0900,"FGTS",oFont8)
		oPrint:Say  (nRow1,1150,TransForm(_nFGTS,"@E 99,999.99"),oFont8)
		oPrint:Say  (nRow1,1300,"LÍQUIDO",oFont11n)
		oPrint:Say  (nRow1,2150,"R$ "+TransForm(_nLiquido,"@E 99,999.99"),oFont11n)
		oPrint:Line (nRow1-50,0050,nRow1+50,0050)//= |
		oPrint:Line (nRow1-50,0460,nRow1+50,0460)//= |
		oPrint:Line (nRow1-50,0890,nRow1+50,0890)//= |
		oPrint:Line (nRow1-50,1270,nRow1+50,1270)//= |
		oPrint:Line (nRow1-50,2400,nRow1+50,2400)//= |
		oPrint:Line (nRow1+50,0050,nRow1+50,2400)//= __
		
		nRow1 +=100
		oPrint:Say  (nRow1,0070,"Data do pagamento",oFont10)
		oPrint:Say  (nRow1,1120,Dtoc(_dDatPgt),oFont10)
		
		If _nX ==1
			oPrint:Say  (nRow1,1300,"ASSINATURA",oFont11n)
			oPrint:Line (nRow1+50,1550,nRow1+50,2400)//= __
			nRow1 +=50
			oPrint:Say  (nRow1,0000,Replicate(".",1000),oFont11n)
			nRow1 +=50
		EndIf
		_nX ++
	End
	oPrint:EndPage()
	dbSelectArea("TMP")
	dbSkip()
	IncProc()
EndDo
dbSelectArea("TMP")
dbGotop()

Return
//-------------------------------------------------------

Static Function fSendArq()

Local CrLf	     := Chr(13)+Chr(10)
Local cMsg	     := ""
Local lOk        := .F.
Local _cAccount  := AllTrim(GetNewPar("MV_RELACNT",""))
Local _cPassword := AllTrim(GetNewPar("MV_RELPSW"," "))
Local _lAutentica:= GetMv("MV_RELAUTH",,.F.)

Local _cUserAut  := Alltrim(GetMv("MV_RELAUSR",,_cAccount))
Local _cPassAut  := Alltrim(GetMv("MV_RELAPSW",,_cPassword))
Local _cServer   := AllTrim(GetMv("MV_WFSMTP"))//AllTrim(GetMv('MV_RELSERV'))

Close(oMov)

PswOrder(1)
PswSeek(__cUserId,.T.)
_aUsuario:= PswRet()

DbSelectArea("SM0")
DbSelectArea("TMP")
DbGotop()
ProcRegua(RecCount())
Do While.Not.Eof()

	fGeraDados()
		
	If Len(_aProvento)>0
		_cTo       := Alltrim(_aUsuario[1,14])
		_cPara     := AllTrim(TMP->RA_EMAIL2)
		
		SRJ->(DbSetOrder(1))
		SRJ->(DbSeek(xFilial("SRJ")+TMP->RA_CODFUNC))
		
		CTT->(DbSetOrder(1))
		CTT->(DbSeek(xFilial("CTT")+TMP->RA_CC))
		
		cMsg := ''
		cMsg += '<html>'+CrLf
		
		cMsg +='<style type="text/css">'
		cMsg +='<!--'
		cMsg +='  h1 {font-family:Arial Unicode MS;font-size: 08px;font-weight: normal;}'
		cMsg +='  h2 {font-family:Arial Unicode MS;font-size: 09px;}'
		cMsg +='  h3 {font-family:Arial Unicode MS;font-size: 10px;font-weight: normal;}'
		cMsg +='  h4 {font-family:Arial Unicode MS;font-size: 09px;font-weight: bold;}'
		cMsg +='  table.bordasimples {border-collapse: collapse;}'
		cMsg +='  table.bordarodape {border-top: 2px solid #000;'
		cMsg +='                      border-bottom: 2px solid #000;}'
		cMsg +='  --></style>'
				
		cMsg += '<table border="1" width="100%" height="20" class="bordasimples">'
		cMsg += '<tr>'
		cMsg += '<th width="100%" height="20" bgcolor="#87CEFA" colspan="2">'   //#87CEFA
		cMsg += '<b><font size="2" align="Center" face="Arial Unicode MS">Recibo de Pagamento - '+If(_cRoteiro=="FOL","Folha de Pagamento",If(_cRoteiro=="ADI","Adiantamento",If(_cRoteiro=="131","1a. Parcela 13o.",IIF(_cRoteiro=="PLR","PLR","2a. Parcela 13o."))))+' - '+AllTrim(MesExtenso(SubStr(_cPeriodo,5,2)))+'/'+Substr(_cPeriodo,1,4)+'</font></b></th>'
		cMsg += '</tr>'
		cMsg += '</table>'
		cMsg += '<table border="0" width="100%" height="20"'
		cMsg += '<tr>'
		cMsg += '<td width="10%" align="left">'
		cMsg += '<h3>Empresa</font></td>'
		cMsg += '<td width="90%" align="left">'
		cMsg += '<h3>ROSENBERGER DOMEX </font></td>'
		cMsg += '<td align="left" height="60" valign="middle" width="30%">'
		cMsg += '<img src="http://www.zero12.com.br/wp-content/uploads/2012/04/RDT.png" height="66" width="125"> </td>'
		cMsg += '</tr>'
		cMsg += '<tr>'
		cMsg += '<td width="10%" align="left">'
		cMsg += '<h3>CNPJ</font></td>'
		cMsg += '<td width="90%" align="left">'
		cMsg += '<h3>'+TransForm(AllTrim(SM0->M0_CGC),"@R 99.999.999/9999-99")+'</font></td>'
		cMsg += '</tr>'
		cMsg += '<tr>'
		cMsg += '<td width="10%" align="left">'
		cMsg += '<h3>Unidade</font></td>'
		cMsg += '<td width="90%" align="left">'
		cMsg += '<h3>'+AllTrim(SM0->M0_FILIAL)+'</font></td>'
		cMsg += '</tr>'
		cMsg += '<tr>'
		cMsg += '<td width="10%" align="left">'
		cMsg += '<h3>C.Custo</font></td>'
		cMsg += '<td width="90%" align="left">'
		cMsg += '<h3>'+TMP->RA_CC+' - '+CTT->CTT_DESC01+'</font></td>'
		cMsg += '</tr>'
		cMsg += '<tr>'
		cMsg += '<td width="10%" align="left">'
		cMsg += '<h3>Funcionário</font></td>'
		cMsg += '<td width="90%" align="left">'
		cMsg += '<h3>'+TMP->RA_MAT+' - '+TMP->RA_NOME+'</font></td>'
		cMsg += '</tr>'
		cMsg += '<tr>'
		cMsg += '<td width="10%" align="left">'
		cMsg += '<h3>Função</font></td>'
		cMsg += '<td width="90%" align="left">'
		cMsg += '<h3>'+TMP->RA_CODFUNC+' - '+SRJ->RJ_DESC+'</font></td>'
		cMsg += '</tr>'
		cMsg += '<td width="10%" align="left">'
		cMsg += '<h3>Salário</font></td>'
		cMsg += '<td width="90%" align="left">'
		cMsg += '<h3>'+TransForm(_nValorSal,"@E 99,999,999.99")+'</font></td>'
		cMsg += '</tr>'
		cMsg += '</table>'  
      
      cMsg += '<table border="0" width="100%" height="20">'
		cMsg += '<tr>'
		cMsg += '<th width="22%" align="left" bgcolor="#87CEFA">'
		cMsg += '<h4>Proventos</font></th>'
		cMsg += '<th width="03%" align="right" bgcolor="#87CEFA">'
		cMsg += '<h4>Horas</font></th>'
		cMsg += '<th width="08%" align="right" bgcolor="#87CEFA">'
		cMsg += '<h4>Valor</font></th>'
		cMsg += '<th width="22%" align="left" bgcolor="#87CEFA">'
		cMsg += '<h4>Descontos</font></th>'
		cMsg += '<th width="03%" align="right" bgcolor="#87CEFA">'
		cMsg += '<h4>Horas</font></th>'
		cMsg += '<th width="08%" align="right" bgcolor="#87CEFA">'
		cMsg += '<h4>Valor</font></th>'
		cMsg += '<th width="23%" align="left" bgcolor="#87CEFA">'
		cMsg += '<h4>Base</font></th>'
		cMsg += '<th width="11%" align="right" bgcolor="#87CEFA">'
		cMsg += '<h4>Valor</font></th>'
		cMsg += '</tr>'
		
		i:=1
		cDados:=""
		dbSelectArea("SQL")
		While i <= RecCount("SQL")
			cDados += '<tr>'
			If i <= Len(_aProvento)
				If _aProvento[i][5] == "H"//Converte centesimal para sexagenal
				   _nDecimal:=Val(SubStr(_aProvento[i][4],AT(",",_aProvento[i][4])+1)) 
				   _nHora   :=Round((_nDecimal/100)*60,0)
				   _aProvento[i][4]:= SubStr(_aProvento[i][4],1,AT(",",_aProvento[i][4]))+StrZero(_nHora,2)
				EndIf
				cDados += '<td width="22%" align="left">'
				cDados += '<h2>'+AllTrim(_aProvento[i][2])+'</font></td>'
				cDados += '<td width="03%" align="right">'
				cDados += '<h2>'+_aProvento[i][4]+'</font></td>'
				cDados += '<td width="08%" align="right">'
				cDados += '<h2>'+_aProvento[i][3]+'</font></td>'
			Else
				cDados += '<td width="22%" align="left">'
				cDados += '<h2></font></td>'
				cDados += '<td width="03%" align="right">'
				cDados += '<h2></font></td>'
				cDados += '<td width="08%" align="right">'
				cDados += '<h2></font></td>'
			EndIf
			If i <= Len(_aDesconto)
				If _aDesconto[i][5] == "H"//Converte centesimal para sexagenal
				   _nDecimal:=Val(SubStr(_aDesconto[i][4],AT(",",_aDesconto[i][4])+1)) 
				   _nHora   :=Round((_nDecimal/100)*60,0)
				   _aDesconto[i][4]:= SubStr(_aDesconto[i][4],1,AT(",",_aDesconto[i][4]))+StrZero(_nHora,2)
				EndIf
				cDados += '<td width="22%" align="left">'
				cDados += '<h2>'+AllTrim(_aDesconto[i][2])+'</font></td>'
				cDados += '<td width="03%" align="right">'
				cDados += '<h2>'+_aDesconto[i][4]+'</font></td>'
				cDados += '<td width="08%" align="right">'
				cDados += '<h2>'+_aDesconto[i][3]+'</font></td>'
			Else
				cDados += '<td width="22%" align="left">'
				cDados += '<h2></font></td>'
				cDados += '<td width="03%" align="right">'
				cDados += '<h2></font></td>'
				cDados += '<td width="08%" align="right">'
				cDados += '<h2></font></td>'
			EndIf
			If i <= Len(_aBase)
				cDados += '<td width="23%" align="left">'
				cDados += '<h2>'+AllTrim(_aBase[i][2])+'</font></td>'
				cDados += '<td width="11%" align="right">'
				cDados += '<h2>'+_aBase[i][3]+'</font></td>'
			Else
				cDados += '<td width="23%" align="left">'
				cDados += '<h2></font></td>'
				cDados += '<td width="11%" align="right">'
				cDados += '<h2></font></td>'
			EndIf
			cDados += '</tr>'
			i++
		End
		
		cMsg += cDados + Crlf
		cMsg += '</table>'+Crlf+Crlf
		
		cMsg += '<table border="0" width="100%" height="20" class="bordarodape">'
		cMsg += '<tr>'
		cMsg += '<td width="24%" align="left" >'
		cMsg += '<h2>Total Proventos</font></td>'
		cMsg += '<td width="10%" align="right" >'
		cMsg += '<h2>R$ '+TransForm(_nTotProv,"@E 99,999.99")+'</font></td>'
		cMsg += '<td width="23%" align="left">'
		cMsg += '<h2>Total Descontos</font></td>'
		cMsg += '<td width="10%" align="right">'
		cMsg += '<h2>R$ '+TransForm(_nTotDesc,"@E 99,999.99")+'</font></td>'
		cMsg += '<th width="23%" align="left" bgcolor="#87CEFA">'
		cMsg += '<h2>LÍQUIDO</font></th>'
		cMsg += '<th width="10%" align="right" bgcolor="#87CEFA">'
		cMsg += '<h2>R$ '+TransForm(_nLiquido,"@E 99,999.99")+'</font></th>'
		cMsg += '</tr>'
		cMsg += '</table>'+Crlf
		
		cMsg += '<table border="0" width="100%" height="20">'
		cMsg += '<tr>'
		cMsg += '<td width="100%" align="left" >'
		cMsg += '<h2>Data/Hora : '+Substr(Dtos(dDataBase),7,2)+'/'+Substr(Dtos(dDataBase),5,2)+'/'+Substr(Dtos(dDataBase),1,4)+' às '+Time()+' hr.</font>' +CrLf
		cMsg += '</td>'
		cMsg += '</tr>'
		cMsg += '<tr>'
		cMsg += '<td width="100%" align="left" >'
		cMsg += '<h2> Rosenberger Domex  </font>' +CrLf
		cMsg += '</td>'
		cMsg += '</tr>'
		cMsg += '<tr>'
		cMsg += '<td width="100%" align="left" >'
		cMsg += '<h3> FAVOR NÃO RESPONDER ESTE E-MAIL. </si>' +CrLf
		cMsg += '</td>'
		cMsg += '</tr>'
		cMsg += '</table>'
		
		cMsg += '</body>'+CrLf
		cMsg += '</html>'+CrLf
		
		_cSubject :='Recibo - '+If(_cRoteiro=="FOL","Folha de Pagamento",If(_cRoteiro=="ADI","Adiantamento",If(_cRoteiro=="131","1a. Parcela 13o.",IIF(_cRoteiro=="PLR","PLR","2a. Parcela 13o."))))+' - '+AllTrim(MesExtenso(SubStr(_cPeriodo,5,2)))+'/'+Substr(_cPeriodo,1,4)
		
		//Connect Smtp Server _cServer Account _cAccount PassWord _cPassAut Result lConectou
		
		_cAttach := "\web\rh\"+Alltrim(TMP->RA_MAT)+"_"+AllTrim(MesExtenso(SubStr(_cPeriodo,5,2)))+'/'+Substr(_cPeriodo,1,4)+".html"
		nHdlChk	:=	MsFCreate(AllTrim(_cAttach))
      If! nHdlChk < 0        
          If File(_cAttach)
        	    FWrite(nHdlChk,cMsg,Len(cMsg))
        	    fClose(nHdlChk)
          EndIf	
      EndIf
		
		cCC := ""                                   
   	U_EnvMailto(_cSubject,cMsg,_cPara,cCC,_cAttach)
      
		/*
		If lConectou		
		   If _lAutentica
            If ( "@" $ _cUserAut )  
			// mauresi = Trecho abaixo retirado em 28/04/17 para tratar envio de emails, apos mudanca pars Office365            
          //      _cUserAut := Subs(_cUserAut,1,At("@",_cUserAut)-1)
            EndIf

			   If MailAuth(_cUserAut,_cPassAut)
			      SEND MAIL From _cAccount To _cPara SUBJECT _cSubject BODY cMsg ATTACHMENT _cAttach RESULT lEnviado
			   Else
				   AAdd(_aLog , {TMP->RA_FILIAL,TMP->RA_NOME,TMP->RA_EMAIL2,"Falha na Autenticação do Usuário -"+_cUserAut+"- "+AllTrim(MailGetErr()),TMP->RA_MAT})
			   EndIf
			Else    
// mauresi = Trecho abaixo retirado em 28/04/17 para tratar envio de emails, apos mudanca pars Office365	
//				 SEND MAIL From _cTo To _cPara SUBJECT _cSubject BODY cMsg ATTACHMENT _cAttach RESULT lEnviado
//				 _cAccount := _cTo   
				 SEND MAIL From _cAccount To _cPara SUBJECT _cSubject BODY cMsg ATTACHMENT _cAttach RESULT lEnviado				 
			EndIf   
		   AAdd(_aLog , {TMP->RA_FILIAL,TMP->RA_NOME,TMP->RA_EMAIL2,If(lEnviado,"E-mail enviado com sucesso","Nao foi possivel enviar o e-mail -"+_cAccount+"-"+AllTrim(MailGetErr())),TMP->RA_MAT})
	      Disconnect Smtp Server
		Else	
		   MsgInfo("Nao foi possivel conexao com o servidor-"+CrLf+AllTrim(GetMv('MV_RELSERV'))+"-"+AllTrim(MailGetErr()),"A T E N C A O")
			AAdd(_aLog , {TMP->RA_FILIAL,TMP->RA_NOME,TMP->RA_EMAIL2,"Nao foi possivel conexao com o servidor. "+AllTrim(GetMv('MV_RELSERV')),TMP->RA_MAT})
		EndIf
		*/
		
	Else
		AAdd(_aLog , {TMP->RA_FILIAL,TMP->RA_NOME,TMP->RA_EMAIL2,"Não foram encontrados dados para o período. E-mail não enviado.",TMP->RA_MAT})
	EndIf
	//If File(_cAttach)
	//   fErase(_cAttach)
   //EndIf	
	dbSelectArea("TMP")
	IncProc()
	dbSkip()
EndDo
dbSelectArea("TMP")
dbGotop()

Return

//----------------------------

Static Function fSalario()
Local _nSalHist:=0
                
cQuery := " Select TOP 1 R3_VALOR " 
cQuery += " From " + RetSqlName("SR3") +Chr(10)+Chr(13) 
cQuery += " Where R3_FILIAL = '" + xFilial("SR3") + "'"+Chr(10)+Chr(13)
cQuery += " And R3_MAT = '"+TMP->RA_MAT+"'"+Chr(10)+Chr(13)
cQuery += " And R3_DATA <= '"+Dtos(_dDatPgt)+"' "+Chr(10)+Chr(13)
cQuery += " And D_E_L_E_T_ = ' ' "+Chr(10)+Chr(13)
cQuery += " Order By R3_FILIAL, R3_MAT, R3_DATA DESC"

cQuery := ChangeQuery(cQuery)

If Select("TRB_SQL") > 0
	TRB_SQL->(dbCloseArea())
EndIf      

dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "TRB_SQL", .F., .F. )                    
                                
If Select("TRB_SQL")>0
   _nSalHist:=TRB_SQL->R3_VALOR
EndIf
Return(_nSalHist)

//-----------------------------

Static Function fGeraBrw()

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

_cQuery:="Select RA_FILIAL,RA_CC,RA_MAT,RA_NOME,RA_EMAIL2,RA_CODFUNC "+Chr(13)+Chr(10)
_cQuery+="From "+RetSqlName("SRA")+Chr(13)+Chr(10)
_cQuery+="Where D_E_L_E_T_ <> '*'                  "+Chr(13)+Chr(10)
_cQuery+="And RA_FILIAL = '"+xFilial("SRA")+"'     "+Chr(13)+Chr(10)
_cQuery+="And RA_CC >= '"+_cCcDe+"'                "+Chr(13)+Chr(10)
_cQuery+="And RA_CC <= '"+_cCcAte+"'               "+Chr(13)+Chr(10)
_cQuery+="And RA_MAT >= '"+_cMatDe+"'              "+Chr(13)+Chr(10)
_cQuery+="And RA_MAT <= '"+_cMatAte+"'             "+Chr(13)+Chr(10)
_cQuery+="And RA_NOME >= '"+_cNomDe+"'              "+Chr(13)+Chr(10)
_cQuery+="And RA_NOME <= '"+_cNomAte+"'             "+Chr(13)+Chr(10)

Do Case
	Case _nSituacao == 1
		_cQuery+="And RA_SITFOLH <> 'D'            "+Chr(13)+Chr(10)
	Case _nSituacao == 2
		_cQuery+="And RA_SITFOLH = 'D'             "+Chr(13)+Chr(10)
		_cQuery+="And (Select Count(*) From "+RetSqlName("SRD")+" SRD      "+Chr(13)+Chr(10)
		_cQuery+="     Where SRD.D_E_L_E_T_ <> '*' And SRD.RD_MAT = RA_MAT "+Chr(13)+Chr(10)
		_cQuery+="     And SRD.RD_FILIAL = RA_FILIAL                       "+Chr(13)+Chr(10)
		_cQuery+="     And SRD.RD_DATARQ = '"+AllTrim(_cAno)+AllTrim(_cMes)+"' )>=1 "+Chr(13)+Chr(10)
	Case _nSituacao == 3
		_cQuery+="And (Select Count(*) From "+RetSqlName("SRD")+" SRD      "+Chr(13)+Chr(10)
		_cQuery+="     Where SRD.D_E_L_E_T_ <> '*' And SRD.RD_MAT = RA_MAT "+Chr(13)+Chr(10)
		_cQuery+="     And SRD.RD_FILIAL = RA_FILIAL                       "+Chr(13)+Chr(10)
		_cQuery+="     And SRD.RD_DATARQ = '"+AllTrim(_cAno)+AllTrim(_cMes)+"' )>=1 "+Chr(13)+Chr(10)
End Case
	
_cQuery+="Order By RA_FILIAL,RA_MAT,RA_NOME,RA_EMAIL2"
	
TCQuery _cQuery ALIAS "TMP" NEW
	
cArqTMP := CriaTrab(NIL,.F.)
Copy To &cArqTMP
dbCloseArea()
dbUseArea(.T.,,cArqTMP,"TMP",.T.)
	
Return
	
//-----------------------------
	
Static Function fGeraDados()
_nTotProv   :=0
_nTotDesc   :=0
_nLiquido   :=0
_nFGTS      :=0
_nBaseIr    :=0
_nBaseDepIr :=0

_aProvento  :={}
_aDesconto  :={}
_aBase      :={}
	
If Select("SQL") > 0
	SQL->(dbCloseArea())
EndIf
	
If _nOpc == 2
	_cQuery:="SELECT 'MATRICULA'=RD_MAT     "+Chr(10)+Chr(13)
	_cQuery+=",CTT_DESC01                   "+Chr(10)+Chr(13)
	_cQuery+=",RD_PD                        "+Chr(10)+Chr(13)
	_cQuery+=",RV_CODFOL                    "+Chr(10)+Chr(13)
	_cQuery+=",RV_TIPOCOD                   "+Chr(10)+Chr(13)
	_cQuery+=",RV_DESC                      "+Chr(10)+Chr(13)
	_cQuery+=",RD_VALOR                     "+Chr(10)+Chr(13)
   _cQuery+=",RD_HORAS                     "+Chr(10)+Chr(13)
	_cQuery+=",RD_DATPGT                    "+Chr(10)+Chr(13)
   _cQuery+=",RV_TIPO                      "+Chr(10)+Chr(13)	
   _cQuery+=",SRD.R_E_C_N_O_ AS SRDRECNO   "+Chr(10)+Chr(13)	
	_cQuery+="FROM "+RetSqlName("SRD")+" SRD"+Chr(10)+Chr(13)
	_cQuery+="    ,"+RetSqlName("SRV")+" SRV"+Chr(10)+Chr(13)
	_cQuery+="    ,"+RetSqlName("CTT")+" CTT"+Chr(10)+Chr(13)
	_cQuery+="WHERE SRD.D_E_L_E_T_ <> '*'    "+Chr(10)+Chr(13)
	_cQuery+="AND SRV.D_E_L_E_T_ <> '*'      "+Chr(10)+Chr(13)
	_cQuery+="AND CTT.D_E_L_E_T_ <> '*'      "+Chr(10)+Chr(13)
	_cQuery+="AND SRD.RD_PD = SRV.RV_COD                "+Chr(10)+Chr(13)
	_cQuery+="AND SRD.RD_FILIAL = '"+xFilial("SRD")+"'  "+Chr(10)+Chr(13)
	_cQuery+="AND CTT.CTT_FILIAL = '"+xFilial("CTT")+"' "+Chr(10)+Chr(13)
	_cQuery+="AND SRV.RV_FILIAL = '"+xFilial("SRV")+"' "+Chr(10)+Chr(13)
	_cQuery+="AND SRD.RD_CC = CTT.CTT_CUSTO              "+Chr(10)+Chr(13)
	_cQuery+="AND SRD.RD_MAT = '"+TMP->RA_MAT+"'         "+Chr(10)+Chr(13)
	_cQuery+="AND SRD.RD_PROCES = '"+_cProcesso+"'       "+Chr(10)+Chr(13)
   _cQuery+="AND SRD.RD_ROTEIR = '"+_cRoteiro+"'        "+Chr(10)+Chr(13)
   _cQuery+="AND SRD.RD_PERIODO = '"+_cPeriodo+"'       "+Chr(10)+Chr(13)
   _cQuery+="AND SRD.RD_SEMANA = '"+_cSemana+"'         "+Chr(10)+Chr(13)
   
	_cQuery+="Order By RD_PD"
	
	TCQuery _cQuery ALIAS "SQL" NEW
		
	TCSetField("SQL","RD_VALOR"  ,"N",14,2)
	TCSetField("SQL","RD_DATPGT" ,"D",08,0)
		
	cArqTmp := CriaTrab(NIL,.F.)
	Copy To &cArqTmp
	DbCloseArea()
	DbUseArea(.T.,,cArqTmp,"SQL",.T.)
		
	DbSelectArea("SQL")
	DbGotop()
	Do While.Not.Eof()
	   Do Case
		   Case RV_TIPOCOD $ "1"
		        Do Case
			        Case _cRoteiro == "FOL"
				          aadd(_aProvento,{RD_PD,SubStr(RV_DESC,1,25),TransForm(RD_VALOR,"@E 99,999.99"),TransForm(RD_HORAS,"@E 999.99"),RV_TIPO})
				          _nTotProv += RD_VALOR
			     	  Case _cRoteiro == "ADI"
				          aadd(_aProvento,{RD_PD,SubStr(RV_DESC,1,25),TransForm(RD_VALOR,"@E 99,999.99"),TransForm(RD_HORAS,"@E 999.99"),RV_TIPO})
				          _nTotProv += RD_VALOR
				     Case _cRoteiro == "PLR"
				          aadd(_aProvento,{RD_PD,SubStr(RV_DESC,1,25),TransForm(RD_VALOR,"@E 99,999.99"),TransForm(RD_HORAS,"@E 999.99"),RV_TIPO})
				          _nTotProv += RD_VALOR			       
			        Case _cRoteiro == "132"
					       aadd(_aProvento,{RD_PD,SubStr(RV_DESC,1,25),TransForm(RD_VALOR,"@E 99,999.99"),TransForm(RD_HORAS,"@E 999.99"),RV_TIPO})
					       _nTotProv += RD_VALOR
			     EndCase
		   Case RV_TIPOCOD $ "2"
		        Do Case
			        Case _cRoteiro == "FOL"
				          aadd(_aDesconto,{RD_PD,SubStr(RV_DESC,1,25),TransForm(RD_VALOR,"@E 99,999.99"),TransForm(RD_HORAS,"@E 999.99"),RV_TIPO})
				          _nTotDesc += RD_VALOR
			        Case _cRoteiro == "ADI"
				          aadd(_aDesconto,{RD_PD,SubStr(RV_DESC,1,25),TransForm(RD_VALOR,"@E 99,999.99"),TransForm(RD_HORAS,"@E 999.99"),RV_TIPO})
				          _nTotDesc += RD_VALOR
				     Case _cRoteiro == "PLR"
				          aadd(_aDesconto,{RD_PD,SubStr(RV_DESC,1,25),TransForm(RD_VALOR,"@E 99,999.99"),TransForm(RD_HORAS,"@E 999.99"),RV_TIPO})
				          _nTotDesc += RD_VALOR			         
			        Case _cRoteiro == "132"
				          aadd(_aDesconto,{RD_PD,SubStr(RV_DESC,1,25),TransForm(RD_VALOR,"@E 99,999.99"),TransForm(RD_HORAS,"@E 999.99"),RV_TIPO})
					       _nTotDesc += RD_VALOR
			     EndCase
		   Case RV_TIPOCOD $ "3"
		        Do Case
			        Case _cRoteiro == "FOL"
				          If AllTrim(RV_CODFOL) $ "0018"
					          _nFGTS :=RD_VALOR
				          EndIf
				          If AllTrim(RV_CODFOL) $ "0015"
				             _nBaseIr:=RD_VALOR
				          EndIf
  				          If AllTrim(RV_CODFOL) $ "0059"
				             _nBaseDepIr:=RD_VALOR
				          EndIf
				          If AllTrim(RV_CODFOL) $ "0013/0017/0018"
					          aadd(_aBase,{RD_PD,SubStr(RV_DESC,1,25),TransForm(RD_VALOR,"@E 99,999.99")})
				          EndIf	  
			        Case _cRoteiro == "ADI"
				          aadd(_aBase,{RD_PD,SubStr(RV_DESC,1,25),TransForm(RD_VALOR,"@E 99,999.99")})
				     Case _cRoteiro == "PLR"
				          aadd(_aBase,{RD_PD,SubStr(RV_DESC,1,25),TransForm(RD_VALOR,"@E 99,999.99")})			       
			        Case _cRoteiro == "132"
				          If AllTrim(RV_CODFOL)$"0027/0062/0108/0109/0169"
					          aadd(_aBase,{RD_PD,SubStr(RV_DESC,1,25),TransForm(RD_VALOR,"@E 99,999.99")})
				          EndIf
			     EndCase    
		EndCase
		If _cRoteiro == "FOL"
			If RV_CODFOL == "0047"
				_nLiquido :=RD_VALOR
				_dDatPgt  :=RD_DATPGT
			EndIf
		EndIf
		If _cRoteiro == "ADI"
			/*If RV_CODFOL == "0021"
				_nLiquido :=RD_VALOR
				_dDatPgt  :=RD_DATPGT
			EndIf*/
			_nLiquido := _nTotProv - _nTotDesc
		Else
			_nLiquido := _nTotProv - _nTotDesc
		EndIf
		DbSkip()
	EndDo
	_nValorSal:=fSalario()
Else
	If _cRoteiro $ "FOL/ADI/131/132/PLR"
		cQuery:="SELECT 'MATRICULA'=RC_MAT "+;
		",CTT_DESC01"+;
		",RC_PD"+;
		",RV_CODFOL"+;
		",RV_TIPOCOD"+;
		",RV_DESC"+;
		",RC_VALOR "+;
		",RC_HORAS "+;
		",RC_DATA "+;
		",RV_TIPO "+;
		"FROM "+RetSqlName("SRC")+" SRC"+;
		"    ,"+RetSqlName("SRV")+" SRV"+;
		"    ,"+RetSqlName("CTT")+" CTT "+;
		"WHERE SRC.D_E_L_E_T_ <> '*' "+;
		"AND SRV.D_E_L_E_T_ <> '*' "+;		
		"AND CTT.D_E_L_E_T_ <> '*' "+;
		"AND SRC.RC_PD = SRV.RV_COD "+;
		"AND SRC.RC_FILIAL = '"+xFilial("SRC")+"' "+;
		"AND CTT.CTT_FILIAL = '"+xFilial("CTT")+"' "+;
		"AND SRV.RV_FILIAL = '"+xFilial("SRV")+"' "+;
		"AND SRC.RC_CC = CTT.CTT_CUSTO "+;
		"AND SRC.RC_MAT = '"+TMP->RA_MAT+"' "+;
	    "AND SRC.RC_PROCES = '"+_cProcesso+"' "+;
 	    "AND SRC.RC_ROTEIR = '"+_cRoteiro+"' "+;
   	    "AND SRC.RC_PERIODO = '"+_cPeriodo+"' "+;
   	    "AND SRC.RC_SEMANA = '"+_cSemana+"' "+;
		"Order By RV_TIPOCOD,RV_CODFOL"
		
		TCQuery cQuery ALIAS "SQL" NEW
		
		TCSetField("SQL","RC_VALOR" ,"N",14,2)
		TCSetField("SQL","RC_DATA" ,"D",08,0)
	Else
		cQuery:="SELECT 'MATRICULA'=RI_MAT "+;
		",CTT_DESC01"+;
		",RI_PD"+;
		",RV_CODFOL"+;
		",RV_TIPOCOD"+;
		",RV_DESC"+;
		",RI_VALOR "+;
		",RI_HORAS "+;
		",RI_DATA "+;
		",RV_TIPO "+;
		"FROM "+RetSqlName("SRI")+" SRI"+;
		"    ,"+RetSqlName("SRV")+" SRV"+;
		"    ,"+RetSqlName("CTT")+" CTT "+;
		"WHERE SRI.D_E_L_E_T_ <> '*' "+;
		"AND SRV.D_E_L_E_T_ <> '*' "+;
		"AND CTT.D_E_L_E_T_ <> '*' "+;
		"AND SRI.RI_PD = SRV.RV_COD "+;
		"AND SRI.RI_FILIAL = '"+xFilial("SRI")+"' "+;
		"AND CTT.CTT_FILIAL = '"+xFilial("CTT")+"' "+;
		"AND SRV.RV_FILIAL = '"+xFilial("SRV")+"' "+;
		"AND SRI.RI_CC = CTT.CTT_CUSTO "+;
		"AND SRI.RI_MAT = '"+TMP->RA_MAT+"' "+;
		"Order By RV_TIPOCOD,RV_CODFOL"
		
		TCQuery cQuery ALIAS "SQL" NEW
		
		TCSetField("SQL","RI_VALOR" ,"N",14,2)
		TCSetField("SQL","RI_DATA"  ,"D",08,0)		
	EndIf
	
	cArqTmp := CriaTrab(NIL,.F.)
	Copy To &cArqTmp
	DbCloseArea()
	DbUseArea(.T.,,cArqTmp,"SQL",.T.)
		
	dbSelectArea("SQL")
	dbGotop()
	Do While.Not.Eof()
	   Do Case
		   Case RV_TIPOCOD == "1"
			     If _cRoteiro == "FOL"
				     aadd(_aProvento,{RC_PD,SubStr(RV_DESC,1,25),TransForm(RC_VALOR,"@E 99,999.99"),TransForm(RC_HORAS,"@E 999.99"),RV_TIPO})
				     _nTotProv += RC_VALOR
			     EndIf
			     If _cRoteiro == "ADI"
				     If AllTrim(RV_CODFOL) $ "0006"
					     aadd(_aProvento,{RC_PD,SubStr(RV_DESC,1,25),TransForm(RC_VALOR,"@E 99,999.99"),TransForm(RC_HORAS,"@E 999.99"),RV_TIPO})
					     _nTotProv += RC_VALOR
				     EndIf
				     If AllTrim(RV_CODFOL) $ "1329"
					     aadd(_aProvento,{RC_PD,SubStr(RV_DESC,1,25),TransForm(RC_VALOR,"@E 99,999.99"),TransForm(RC_HORAS,"@E 999.99"),RV_TIPO})
					     _nTotProv += RC_VALOR
				     EndIf
			     EndIf
			     If _cRoteiro == "131"
				     If AllTrim(RV_CODFOL) $ "0022"
					     aadd(_aProvento,{RC_PD,SubStr(RV_DESC,1,25),TransForm(RC_VALOR,"@E 99,999.99"),TransForm(RC_HORAS,"@E 999.99"),RV_TIPO})
					     _nTotProv += RC_VALOR
				     EndIf
			     EndIf                
			     If _cRoteiro == "131"
				     If AllTrim(RV_CODFOL) $ "1434"
					     aadd(_aProvento,{RC_PD,SubStr(RV_DESC,1,25),TransForm(RC_VALOR,"@E 99,999.99"),TransForm(RC_HORAS,"@E 999.99"),RV_TIPO})
					     _nTotProv += RC_VALOR
				     EndIf
			     EndIf
			     
			     If _cRoteiro == "132"
				     aadd(_aProvento,{RC_PD,SubStr(RV_DESC,1,25),TransForm(RC_VALOR,"@E 99,999.99"),TransForm(RC_HORAS,"@E 999.99"),RV_TIPO})
				     _nTotProv += RC_VALOR
			     EndIf
			     If _cRoteiro == "PLR"
				     aadd(_aProvento,{RC_PD,SubStr(RV_DESC,1,25),TransForm(RC_VALOR,"@E 99,999.99"),TransForm(RC_HORAS,"@E 999.99"),RV_TIPO})
				     _nTotProv += RC_VALOR
			     EndIf
		   Case RV_TIPOCOD == "2"
			     If _cRoteiro == "FOL"
				     aadd(_aDesconto,{RC_PD,SubStr(RV_DESC,1,25),TransForm(RC_VALOR,"@E 99,999.99"),TransForm(RC_HORAS,"@E 999.99"),RV_TIPO})
				     _nTotDesc += RC_VALOR
			     EndIf
			     If _cRoteiro == "ADI"
				     If AllTrim(RV_CODFOL) $ "0007/0008"
					     aadd(_aProvento,{RC_PD,SubStr(RV_DESC,1,25),TransForm(RC_VALOR,"@E 99,999.99"),TransForm(RC_HORAS,"@E 999.99"),RV_TIPO})
					     _nTotProv += RC_VALOR
			        EndIf
				     If AllTrim(RV_CODFOL) $ "0009"
					     aadd(_aDesconto,{RC_PD,SubStr(RV_DESC,1,25),TransForm(RC_VALOR,"@E 99,999.99"),TransForm(RC_HORAS,"@E 999.99"),RV_TIPO})
					     _nTotDesc += RC_VALOR
				     EndIf
			     EndIf
			     If _cRoteiro == "132"
				     aadd(_aDesconto,{RC_PD,SubStr(RV_DESC,1,25),TransForm(RC_VALOR,"@E 99,999.99"),TransForm(RC_HORAS,"@E 999.99"),RV_TIPO})
				     _nTotDesc += RC_VALOR
			     EndIf
			     If _cRoteiro == "PLR"
				     aadd(_aDesconto,{RC_PD,SubStr(RV_DESC,1,25),TransForm(RC_VALOR,"@E 99,999.99"),TransForm(RC_HORAS,"@E 999.99"),RV_TIPO})
				     _nTotDesc += RC_VALOR
			     EndIf
		   Case RV_TIPOCOD == "3"
		        Do Case
			        Case _cRoteiro == "FOL"
				          If AllTrim(RV_CODFOL) $ "0018"
					          _nFGTS :=RC_VALOR
				          EndIf                                                                                      
  				          If AllTrim(RV_CODFOL) $ "0015"
					          _nBaseIr :=RC_VALOR
				          EndIf                                                                                      
  				          If AllTrim(RV_CODFOL) $ "0059"
					          _nBaseDepIr :=RC_VALOR
				          EndIf                                                                                      
				          If AllTrim(RV_CODFOL) $ "0013/0017/0018"
					          aadd(_aBase,{RC_PD,SubStr(RV_DESC,1,25),TransForm(RC_VALOR,"@E 99,999.99")})
				          EndIf	
			        Case _cRoteiro == "ADI"
				          If AllTrim(RV_CODFOL)$"0010"
					          aadd(_aBase,{RC_PD,SubStr(RV_DESC,1,25),TransForm(RC_VALOR,"@E 99,999.99")})
				          EndIf
				          If AllTrim(RV_CODFOL) $ "0012"
					          aadd(_aDesconto,{RC_PD,SubStr(RV_DESC,1,25),TransForm(RC_VALOR,"@E 99,999.99"),TransForm(RC_HORAS,"@E 999.99"),RV_TIPO})
					          _nTotDesc += RC_VALOR
				          EndIf
			        Case _cRoteiro == "131"
				          If AllTrim(RV_CODFOL)$"0108/0109"
					          aadd(_aBase,{RC_PD,SubStr(RV_DESC,1,25),TransForm(RC_VALOR,"@E 99,999.99")})
				          EndIf             
				     Case _cRoteiro == "PLR"
				    		aadd(_aBase,{RC_PD,SubStr(RV_DESC,1,25),TransForm(RC_VALOR,"@E 99,999.99")})				         
			        Case _cRoteiro == "132"
				          If AllTrim(RV_CODFOL) $ "0109"
					          _nFGTS :=RC_VALOR
				          EndIf
  				          If AllTrim(RV_CODFOL) $ "0027"
					          _nBaseIr :=RC_VALOR
				          EndIf                                                                                      
  				          If AllTrim(RV_CODFOL) $ "0062"
					          _nBaseDepIr :=RC_VALOR
				          EndIf      
			          	 aadd(_aBase,{RC_PD,SubStr(RV_DESC,1,25),TransForm(RC_VALOR,"@E 99,999.99")})                                                                                
			     EndCase
		EndCase
		If _cRoteiro == "FOL"
			If RV_CODFOL == "0047"
				_nLiquido :=RC_VALOR
				_dDatPgt  :=RC_DATA
			EndIf
		EndIf
		If _cRoteiro == "132"
			If RV_CODFOL == "0021"
				_nLiquido :=RC_VALOR
  			   _dDatPgt  :=RC_DATA
			EndIf
		Else
			_nLiquido := _nTotProv - _nTotDesc
		EndIf
		DbSkip()
	EndDo
	_nValorSal:=Posicione("SRA",1,xFilial("SRA")+TMP->RA_MAT,"RA_SALARIO")
EndIf

Return
	
//-----------------------------------------------
	
Static Function fCriaPerg()
aSvAlias:={Alias(),IndexOrd(),Recno()}
i:=j:=0
aRegistros:={}
//                1      2    3               4  5     6      7  8  9  10 11  12 13         14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43
AADD(aRegistros,{_cPerg,"01","Do C.Custo     ","","","mv_ch1","C",20,00,00,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","CTT","","","","",""})
AADD(aRegistros,{_cPerg,"02","Ate C.Custo    ","","","mv_ch2","C",20,00,00,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","CTT","","","","",""})
AADD(aRegistros,{_cPerg,"03","Da Matricula   ","","","mv_ch3","C",06,00,00,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","","","",""})
AADD(aRegistros,{_cPerg,"04","Ate Matricula  ","","","mv_ch4","C",06,00,00,"G","","Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","","","",""})
AADD(aRegistros,{_cPerg,"05","Do Nome        ","","","mv_ch5","C",30,00,00,"G","","Mv_Par05","","","","","","","","","","","","","","","","","","","","","","","","","SRA002","","","","",""})
AADD(aRegistros,{_cPerg,"06","Ate Nome       ","","","mv_ch6","C",30,00,00,"G","","Mv_Par06","","","","","","","","","","","","","","","","","","","","","","","","","SRA002","","","","",""})
AADD(aRegistros,{_cPerg,"07","Situação       ","","","mv_cha","N",01,00,00,"C","","Mv_Par07","Situacao Normal" ,"","","","","Demitidos","","","","","Ambos","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"08","Processo       ","","","mv_chc","C",05,00,00,"G","","Mv_Par08","","","","","","","","","","","","","","","","","","","","","","","","","RCJ2","","","","",""})
AADD(aRegistros,{_cPerg,"09","Roteiro        ","","","mv_chc","C",03,00,00,"G","","Mv_Par09","","","","","","","","","","","","","","","","","","","","","","","","","RCHGPR","","","","",""})
AADD(aRegistros,{_cPerg,"10","Periodo        ","","","mv_chd","C",06,00,00,"G","","Mv_Par10","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"11","Numero de pagamento ","","","mv_chb","C",02,00,00,"G","","Mv_Par11","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

dbSelectArea("SX1")
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

//----------------------------------------------
	
Static Function fImpLog()

SetPrvt("cString,cDesc1,cDesc2,cDesc3,cTamanho,aReturn")
SetPrvt("aOrd,cNomeProg,aLinha,nLastKey,nOrdem,cTitulo")
SetPrvt("cCabec,cCabec2,cCancel,m_pag,wNrel,cPerg")
SetPrvt("nLin,cIni,cFim,cArqTRB,_nCont,_aDetail,_aCabec")

cString  := "SRA"
cDesc1   := "Este programa tem como objetivo emitir os "
cDesc2   := ""
cDesc3   := ""
cTamanho := "G"
aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
aOrd     := {}
cNomeProg:= "fImpLog"
aLinha   := {}
nLastKey := 0
nOrdem   := 0
cCabec 	 := "Unidade  Matricula      Nome                          E-mail                                            Observação"
//           123456789D123456789V123456789T123456789Q123456789C123456789S123456789S123456789O123456789N123456789*123456789d123456789v123456789t123456789q123456789c123456789s123456789s123456789o123456789n123456789*123456789d123456789v
cCabec2  := ""
cCancel  := "***** CANCELADO PELO OPERADOR *****"
wnrel    := "fImpLog"            //Nome Default do relatorio em Disco
cPerg    := ""
m_pag    :=1
_aDetail :={}
_aCabec  :={}
cTitulo  := "Log de envio dos recibos da(o) "+If(_cRoteiro=="FOL","Folha de Pagamento",If(_cRoteiro=="ADI","Adiantamento",If(_cRoteiro=="131","1a. Parcela 13o.",IIF(_cRoteiro=="PLR","PLR","2a. Parcela 13o."))))+' - '+AllTrim(MesExtenso(SubStr(_cPeriodo,5,2)))+'/'+Substr(_cPeriodo,1,4)

SetPrint(cString,wnrel,cPerg,cTitulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)

If nLastKey == 27
	Set Filter To
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus( {|| fImprime()} )

If aReturn[5] == 1
	Set Printer To
	Commit
	OurSpool(wnRel)
Endif

MS_FLUSH()

Return

//-------------------------------------------------------

Static Function fImprime()
nLin:=100

For i:=1 To Len(_aLog)
	If nLin >= 058
		Cabec(cTitulo,cCabec,cCabec2,cNomeProg,cTamanho,GetMv("MV_COMP"))
		nLin := 008
	Endif
	
	@ nLin,001 Psay _aLog[i][1]
	@ nLin,010 Psay _aLog[i][5]
	@ nLin,025 Psay _aLog[i][2]
	@ nLin,055 Psay _aLog[i][3]
	@ nLin,105 Psay _aLog[i][4]
	
	nLin++
	
Next
nLin++
roda(0,Space(10),cTamanho)
nLin++

Return
