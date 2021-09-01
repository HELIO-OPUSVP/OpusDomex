#INCLUDE "PROTHEUS.CH" 
#include "rwmake.ch" 
#Include "AP5Mail.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#Include "TOTVS.CH"
#INCLUDE "PRINT.CH"
#include "xmlxfun.ch"
#include "tryexception.ch"


#DEFINE VBOX      080
#DEFINE VSPACE    100
#DEFINE HSPACE    010
#DEFINE SAYVSPACE 008
#DEFINE SAYHSPACE 008
#DEFINE HMARGEM   100
#DEFINE HMARGEMT  040
#DEFINE VMARGEM   100
#DEFINE VMARGEMT  040


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFAT100   ºAutor  ³Marco Aurelio       º Data ³  18/12/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Impressao de Orcamento de Venda - DOMEX                   º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Versão sem as linhas.
*/

User Function RFAT100()

Local cQuery := ""
Local cAliasSCK := CriaTrab(NIL,.F.)
Private nPag	:= 1
Private nPagAtu	:= 1      
Private nQtdProd:= 0
Private nPagImpr:= 1
Private nItem 	:= 1
	
Private nTotalGeral := 0
Private nTotalGIPI  := 0
Private nTotalGICM 	:= 0
Private nTotalGPCO 	:= 0
Private nTotalGIST  := 0
Private nVlrFrete	:= 0
Private lIpi:=.F.  
Private nIpi:= 0 
Private nVlrIpi:= 0  
Private nTotal:= 0
Private nPosV       := VMARGEM                      
Private ncw     	:= 0
Private li      	:= 1
Private nLinMax	:= 2300  // Número máximo de Linhas  A4 - 2250 // Oficio - 2800
Private nColMax	:= 2950  // Número máximo de Colunas A4 - 3310 // Oficio - 3955
Private oPrint

Private oFont10
Private oFont10n
Private oFont12
Private oFont12n
Private oFont14
Private oFont14n                      
Private oFont16n
Private oFont18n
Private oFont20n
Private oFont25n
Private	oFnt13a
Private	oFnt35a
Private cA1XXORPR1 := ""
Private cA1XXORPR2 := ""
Private cA1XXORPR3 := ""
Private cDescPrc11 := ""
Private cDescPrc12 := ""
Private cDescPrc13 := ""
Private cDescPrc21 := ""
Private cDescPrc22 := ""
Private cDescPrc23 := ""
Private cDescPrc31 := ""
Private cDescPrc32 := ""
Private cDescPrc33 := ""
Private nA1XXORPR1 := 0
Private nA1XXORPR2 := 0
Private nA1XXORPR3 := 0
Private nQtdProdT := 0
Private cCliente 	:= ""
Private cLoja	 	:= ""
Private cTipo	 	:= ""
Private cTes       	:= ""

Private cLogo:=GetSrvProfString("Startpath","")+"logoprop.jpg" //verificar - era  .gif
//Private cLogo:=GetSrvProfString("Startpath","")+"domex.jpg" //verificar - era  .gif


_cPerg   := PADR("RFAT100",10)
// Cria Pergunta do relatorio


fCriaPerg(_cPerg)

MV_PAR01 := SCJ->CJ_NUM

If !Pergunte(_cPerg, .T.)
   Return
EndIf 

SCJ->(DbSetOrder(1))
If ! (SCJ->(DbSeek(xFilial("SCJ")+MV_PAR01)))
	Alert("Orcamento não encontrato")
	Return()
else
	If SCJ->CJ_NUM < "053150"
		Alert("Só é possivel imprimir a partir do orçamento Número : " + "053150" )
		Return()
	Endif
EndIf
    
lEmail := .f.
//If msgyesno("Deseja Receber o Orçamento por Email ?","Email Orçamento")
//	lEmail := .t.
//Endif
	

nRegSCJ:=SCJ->(Recno())

SCK->(DbSetOrder(1))
If (SCK->(DbSeek(xFilial("SCK")+SCJ->CJ_NUM)))

	cFilePrint := "Proposta_Comercial_" + SCJ->CJ_NUM	
	cPath := "C:\"
	cPatchSave := cGetFile("","Selecionar diretório:",1,cPath,.F.,nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.F., .T.)
	lAdjustToLegacy := .T.
	oPrint  	:= FWMSPrinter():New(cFilePrint,IMP_PDF, lAdjustToLegacy, /*cPathInServer*/, .T.)
	//oPrint		:Setup()	// Escolhe a impressora
	oPrint		:SetLandScape()
	oPrint  	:SetPaperSize(9,nLinMax,nColMax)   // 9=Papel A4 210x297 mm
	oPrint:cPathPDF := cPatchSave
	oFont08n   	:= TFont():New("Arial",9,8,.T.,.T.,5,.T.,5,.T.,.F.) 
	oFont10n   	:= TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)    
	oFont10  	:= TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont12n   	:= TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont12  	:= TFont():New("Arial",9,12,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont14n   	:= TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.) 
	oFont14  	:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.) 
	oFont16n   	:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont18n   	:= TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont20n   	:= TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)                                
	oFont25n   	:= TFont():New("Arial",9,25,.T.,.T.,5,.T.,5,.T.,.F.)
	oFnt13a		:= TFont():New( "Arial",,13,,.t.,,,,,.f.,.t. )      && Tam 13   italico
	oFnt35a		:= TFont():New( "Arial Black",,35,,.t.,,,,,.f. )	&& Tam 35 - Titulo
	
	// query que efetua a contagem de registros a serem processados
	cQuery := "SELECT count(*) as QTDE "
	cQuery += "FROM "+RetSqlName("SCK")+" SCK "	
	cQuery += "WHERE SCK.CK_FILIAL = '" + xFilial("SCK") + "' AND SCK.CK_NUM = '" + SCJ->CJ_NUM + "' AND "
	cquery += "SCK.D_E_L_E_T_=' ' "

	
	cQuery := ChangeQuery(cQuery)		
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSCK,.T.,.F.)
	
	If (cAliasSCK)->QTDE  <= 5
		nPag:= 2
	else
		nCalcPag :=round((cAliasSCK)->QTDE   / 7,1) 
		If nCalcPag - Int(nCalcPag) >= 0
			nPag := Int(nCalcPag) + 2
		Else
			nPag:= Int(nCalcPag) + 1
		EndIf
	EndIf 
	nQtdProdT:=(cAliasSCK)->QTDE   
	//Impressão do Cabeçalho
	
	MsgRun("Proposta Comercial","Imprimindo Cabeçalho",{|| R100CABEC(nRegSCJ,nPagAtu,nPag) })
	lTemObsItem := .F.
	//Impressao dos Itens
	While SCK->(!Eof()) .and. SCK->(CK_FILIAL+CK_NUM) == SCJ->CJ_FILIAL + SCJ->CJ_NUM
		

		If (nItem==1)
			nLinIt1 := 1000				
			nLinObs := 1120
			If !Empty(Alltrim(SCK->CK_OBS))
				lTemObsItem := .T.
				nLinObs := 1170
			EndIf							
			//R100ITENS(SCK->(Recno()),.T.,nLinIt1,nLinObs,nItem)
			MsgRun("Imprimindo Item: " + Strzero(nItem,2),"Proposta Comercial " + SCJ->CJ_NUM,{|| R100ITENS(SCK->(Recno()),.T.,nLinIt1,nLinObs,nItem) })
		else
			
			If nPagImpr <> nPagAtu
				nPagImpr := nPagAtu
				nLinIt1 := 1000				
				nLinObs := 1120			
			else				
				If lTemObsItem 
					If !Empty(Alltrim(SCK->CK_OBS))
						lTemObsItem := .T.
						nLinIt1 := nLinObs + 0140
						nLinObs += 0180					
					else
						lTemObsItem := .F.
						nLinIt1 := nLinObs + 0140
						nLinObs += 0120					
					EndIf
				else
					If !Empty(Alltrim(SCK->CK_OBS))
						lTemObsItem := .T.
						nLinIt1 := nLinObs + 0080								
						nLinObs += 0180
					else
						nLinIt1 := nLinObs + 080								
						nLinObs += 0180	
					EndIf					
				EndIf
			EndIf			
			MsgRun("Imprimindo Item: " + Strzero(nItem,2),"Proposta Comercial " + SCJ->CJ_NUM,{||R100ITENS(SCK->(Recno()),lPrimeiro,nLinIt1,nLinObs,nItem) })
		EndIf
		nQtdProd ++
		SCK->(DbSkip())	
		nItem ++
		If nQtdProd == 5 .And. nPag == 2 
			oPrint:EndPage()
			nPagAtu++	
			nQtdProd := 0	
			lPrimeiro := .T.	
			R100CABEC(nRegSCJ,nPagAtu,nPag)
		elseIf nQtdProd ==6  .And. nPag > 2 .And. (nPag - 1) <> nPagAtu
			oPrint:EndPage()
			nPagAtu++	
			nQtdProd := 0	
			lPrimeiro := .T.	
			R100CABEC(nRegSCJ,nPagAtu,nPag)
		else
			lPrimeiro := .F.	
		EndIf
	EndDo

	//Impressao do rodape
	//R100RODA(nRegSCJ,nPagAtu==nPag)	
	MsgRun("Imprimindo Rodapé","Proposta Comercial " + SCJ->CJ_NUM,{|| R100RODA(nRegSCJ,nPagAtu==nPag)})
	//Impressão das condições comerciais
	R100CABEC(nRegSCJ,nPagAtu+1,nPag,.T.)
	
	nLinCond := 800	
	//CONDCOMERC(nLinCond)
	MsgRun("Finalizando impressão da política comercial","Proposta Comercial " + SCJ->CJ_NUM,{|| CONDCOMERC(nLinCond)})

EndIf	

SCJ->(dbGoTo(nRegSCJ))

cStartPath       := GetSrvProfString("Startpath","")
cArq := CriaTrab(,.f.)
oPrint:SaveAllAsJPEG(cStartPath+cArq,1200,1000,130)
oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir
If lEmail         
	aArqs := {}
	Adir(cStartPath+cArq+"*.jpg",aArqs)
	cAnexo := ''	
	For ni := 1 To Len(aArqs)
		cAnexo += (cStartPath+aArqs[ni] +';')
	Next
	
//	EnvMail(cStartPath+cArq+'_pag1.jpg', MV_PAR01)
	EnvMail(cAnexo, MV_PAR01)
Endif	
FErase(cStartPath+cArq+'_pag1.jpg')
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³R100CABEC   ºAutor  ³Marco Aurelio     º Data ³  18/12/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function R100CABEC(nReg,nPagAtu,nPag,lCondicom)
Local nColCab1 := 150  
Local nColCab2 := 1280 
Local nColcab3 := 2280
Local nFatorLCab := 40
Local nLinIniCab := 515
Local nLinIncCab := 0

Default lCondicom := .F.

DbSelectArea("SCJ")
DbGoTo(nreg)

oPrint      :StartPage() // Inicia Nova página

Li:=VSPACE

oPrint:Box(VMARGEM,HMARGEM,nLinMax,nColMax)

// Cabeçalho / Dados da Empresa

oPrint:Box(li,HMARGEM,500,nColMax/3)
oPrint:Box(li,HMARGEM,500,nColMax)
//oPrint:Line(350,(nColMax/3)-300,350,nColMax)
oPrint:Line(350,HMARGEM,350,nColMax)

Li:=li+50
If !lEmail
	oPrint:SayBitmap(li - 30,HMARGEM+50,cLogo,550,140)	
Else
	oPrint:Say(li,HMARGEM+50,ALLTRIM(SM0->M0_NOMECOM),oFont08n,,,,1)
Endif

oPrint:Say(li,nColMax-600,ALLTRIM(SM0->M0_ENDCOB) + " - " + ALLTRIM(SM0->M0_BAIRCOB) + " - " + ALLTRIM(SM0->M0_CIDCOB) + " - " + SM0->M0_ESTCOB,oFont10n,,,,1)
oPrint:Say(li:=li+40,nColMax-600,"CEP: " + TransForm(SM0->M0_CEPCOB,"@r 99999-999"),oFont10n,,,,1)
oPrint:Say(li:=li+40,nColMax-600,"Tel: " + "(12) 3221-8500" /* TransForm(SUBSTR(SM0->M0_TEL,1,3),"@r (999)") +Substr(SM0->M0_TEL,4) */,oFont10n,,,,1)
oPrint:Say(li:=li+40,nColMax-600,"CNPJ.: " +TransForm(SM0->M0_CGC,"@r 99.999.999/9999-99") + "  -  " + "IE: " +TransForm(SM0->M0_INSC,"@r 999.999.999-99"),oFont10n,,,,1)
                                       
oPrint:Say(200,nColMax/3+HMARGEM,"PROPOSTA COMERCIAL",oFont25n /*oFnt35a*/,,,,0)                                       
oPrint:Say(300,nColMax/2.5+HMARGEM,"Nro.: " + Alltrim(SCJ->CJ_NUM) + IIF(!Empty(Alltrim(SCJ->CJ_REVISAO)), " / " + Alltrim(SCJ->CJ_REVISAO),""),oFont25n,,CLR_HRED,,2)   

//Vendedor
SA3->(dbSelectArea("SA3"))
SA3->(DBSETORDER(1)) 
If SA3->(DbSeek(xFilial("SA3")+SCJ->CJ_VEND1))
	cVendedor:=NoAcento(Alltrim(SA3->A3_NOME))
	cEmailVen:=Alltrim(SA3->A3_EMAIL)
	cFoneVend:="(" + AlltriM(SA3->A3_DDDTEL)+ ") " +  Alltrim(SA3->A3_TEL)
Else
	cVendedor:=""
	cEmailVen:=""
	cFoneVend:=""
EndIf

//Elaborador
cCodUser 	:= SCJ->CJ_SUPORTE//RetCodUsr()
cElabNome 	:=NoAcento(Alltrim(UsrRetName(cCodUser)))
cElabEMail	:= UsrRetMail(cCodUser)
cElabTel	:= "(12) 3221-8500"

oPrint:Say (380,nColCab1,"Vendedor: " + cVendedor,oFont12n,,,,0)   
oPrint:Say (420,nColcab1,"E-mail: " + cEmailVen,oFont12n,,,,0)   
oPrint:Say (460,nColcab1,"Telefone: " + cFoneVend,oFont12n,,,,0)   

oPrint:Say (380,nColcab2,"Elaborador: " + cElabNome,oFont12n,,,,0)   
oPrint:Say (420,nColCab2,"E-mail: " 	+ cElabEMail,oFont12n,,,,0)   
oPrint:Say (460,nColCab2,"Telefone: " + cElabTel,oFont12n,,,,0)   

oPrint:Say (400,nColMax-HMARGEM-200,"Data: " + DTOC(SCJ->CJ_EMISSAO),oFont12n,,,,0)   
oPrint:Say (440,nColMax-HMARGEM-200,"Pagina: " + Alltrim(strzero(nPagAtu,2)) + "/" +Alltrim(Strzero(nPag,2)),oFont12n,,,,2)  



//Dados do Cliente                   

SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA))
cCliente := SA1->A1_COD
cLoja	 := SA1->A1_LOJA
cTipo	 := SCJ->CJ_TIPOCLI
cRazao	:= Alltrim(SA1->A1_NOME)
cEnd:= MyGetEnd(SA1->A1_END,"SA1")[1]
cBairro:= SA1->A1_BAIRRO
cCidade:= SA1->A1_MUN
cContato:= "("+ Alltrim(SA1->A1_DDD) + ")" + SPACE(1) + IIF(LEN(Alltrim(SA1->A1_TEL)) == 9, Transform(Alltrim(SA1->A1_TEL),"@r 99999-9999"),Transform(Alltrim(SA1->A1_TEL),"@r 9999-9999"))
cCNPJ:= SA1->A1_CGC
cIE:=SA1->A1_INSCR
cNr:= IIF(MyGetEnd(SA1->A1_END,"SA1")[2]<>0,MyGetEnd(SA1->A1_END,"SA1")[2],"SN")
cEstado:= SA1->A1_EST
cCep:= SA1->A1_CEP

//Preço de Orçamentos
/*
1 - PRECO UNIT. SEM PIS/ COFINS, ICMS E IPI                
2 - PRECO UNIT. COM PIS/ COFINS, SEM ICMS E IPI            
3 - PRECO UNIT. COM PIS/ COFINS E ICMS, SEM IPI            
4 - PRECO UNIT. COM PIS/ COFINS, ICMS E IPI                
5 - PRECO UNIT. COM PIS/ COFINS, ICMS, IPI E ST            
*/
cA1XXORPR1 := SA1->A1_XXORPR1
cA1XXORPR2 := SA1->A1_XXORPR2
cA1XXORPR3 := SA1->A1_XXORPR3

Do Case 
	Case cA1XXORPR1 == "1"						
		cDescPrc11  := "|Preco Unit.Sem"  
		cDescPrc12	:= "|  PIS/COFINS, "
		cDescPrc13  := "|   ICMS e IPI "
	Case cA1XXORPR1 == "2"						
		cDescPrc11  := "|Preco Unit.Com"  
		cDescPrc12	:= "|  PIS/COFINS, "
		cDescPrc13  := "|Sem ICMS e IPI"
	Case cA1XXORPR1 == "3"						
		cDescPrc11  := "|Preco Unit.Com"  
		cDescPrc12	:= "|  PIS/COFINS e"
		cDescPrc13  := "| ICMS, Sem IPI"
	Case cA1XXORPR1 == "4"						
		cDescPrc11  := "|Preco Unit.Com"  
		cDescPrc12	:= "|  PIS/COFINS, "
		cDescPrc13  := "|   ICMS e IPI "
	Case cA1XXORPR1 == "5"						
		cDescPrc11  := "|Preco Unit.Com"  
		cDescPrc12	:= "|   PIS/COFINS,"
		cDescPrc13  := "| ICMS,IPI e ST"
	OTHERWISE
		cA1XXORPR1  := "3"						
		cDescPrc11  := "|Preco Unit.Com"  
		cDescPrc12	:= "|  PIS/COFINS e"
		cDescPrc13  := "| ICMS, Sem IPI"
End Case			



Do Case 
	Case cA1XXORPR2 == "1"						
		cDescPrc21  := "|Preco Unit.Sem"  
		cDescPrc22	:= "|  PIS/COFINS, "
		cDescPrc23  := "|   ICMS e IPI "
	Case cA1XXORPR2 == "2"						
		cDescPrc21  := "|Preco Unit.Com"  
		cDescPrc22	:= "|  PIS/COFINS, "
		cDescPrc23  := "|Sem ICMS e IPI"
	Case cA1XXORPR2 == "3"						
		cDescPrc21  := "|Preco Unit.Com"  
		cDescPrc22	:= "|  PIS/COFINS e"
		cDescPrc23  := "| ICMS, Sem IPI"
	Case cA1XXORPR2 == "4"						
		cDescPrc21  := "|Preco Unit.Com"  
		cDescPrc22	:= "|  PIS/COFINS, "
		cDescPrc23  := "|   ICMS e IPI "
	Case cA1XXORPR2 == "5"						
		cDescPrc21  := "|Preco Unit.Com"  
		cDescPrc22	:= "|  PIS/COFINS, "
		cDescPrc23  := "| ICMS,IPI e ST"
	OTHERWISE
		cA1XXORPR2  := "4"						
		cDescPrc21  := "|Preco Unit.Com"  
		cDescPrc22	:= "|  PIS/COFINS, "
		cDescPrc23  := "|   ICMS e IPI "	
End Case			


Do Case 
	Case cA1XXORPR3 == "1"						
		cDescPrc31  := "|Preco Unit.Sem"  
		cDescPrc32	:= "|  PIS/COFINS, "
		cDescPrc33  := "|  ICMS e IPI  " 
	Case cA1XXORPR3 == "2"						
		cDescPrc31  := "|Preco Unit.Com"  
		cDescPrc32	:= "| PIS e COFINS,"
		cDescPrc33  := "|Sem ICMS e IPI"
	Case cA1XXORPR3 == "3"						
		cDescPrc31  := "|Preco Unit.Com"  
		cDescPrc32	:= "|  PIS/COFINS e"
		cDescPrc33  := "| ICMS, Sem IPI"
	Case cA1XXORPR3 == "4"						
		cDescPrc31  := "|Preco Unit.Com"  
		cDescPrc32	:= "|  PIS/COFINS, "
		cDescPrc33  := "|  ICMS e IPI  "
	Case cA1XXORPR3 == "5"						
		cDescPrc31  := "|Preco Unit.Com"  
		cDescPrc32	:= "|  PIS/COFINS, "
		cDescPrc33  := "| ICMS,IPI e ST"
	OTHERWISE
		cA1XXORPR3 := "5"						
		cDescPrc31  := "|Preco Unit.Com"  
		cDescPrc32	:= "|  PIS/COFINS, "
		cDescPrc33  := "| ICMS,IPI e ST"
End Case



oPrint:Box(480,HMARGEM,700,nColMax)      

nLinIncCab := nLinIniCab
oPrint:Say (/*540*/nLinIncCab,/*HMARGEM+50*/nColCab1,"Cliente:",oFont12n,,,,0)   
nLinIncCab += nFatorLCab
oPrint:Say (/*610*/nLinIncCab,/*HMARGEM+50*/nColCab1,"End.:",oFont12n,,,,0)   
nLinIncCab += nFatorLCab
oPrint:Say (/*680*/nLinIncCab,/*HMARGEM+50*/nColCab1,"Bairro.:",oFont12n,,,,0)   
nLinIncCab += nFatorLCab
oPrint:Say (/*750*/nLinIncCab,/*HMARGEM+50*/nColCab1,"Cidade:",oFont12n,,,,0)   
nLinIncCab += nFatorLCab
oPrint:Say (/*820*/nLinIncCab,/*HMARGEM+50*/nColCab1,"Telefone:",oFont12n,,,,0)    
nLinIncCab += nFatorLCab

nLinIncCab := nLinIniCab 

oPrint:Say (/*540*/nLinIncCab,/*HMARGEM+250*/nColCab1+200,cRazao + " - " +cCliente,oFont12,,,,0)   
nLinIncCab += nFatorLCab
oPrint:Say (/*610*/nLinIncCab,/*HMARGEM+250*/nColCab1+200,cEnd,oFont12,,,,0)   
nLinIncCab += nFatorLCab
oPrint:Say (/*680*/nLinIncCab,/*HMARGEM+250*/nColCab1+200,cBairro,oFont12,,,,0)   
nLinIncCab += nFatorLCab
oPrint:Say (/*750*/nLinIncCab,/*HMARGEM+250*/nColCab1+200,cCidade,oFont12,,,,0)   
nLinIncCab += nFatorLCab
oPrint:Say (/*820*/nLinIncCab,/*HMARGEM+250*/nColCab1+200,cContato,oFont12,,,,0)    


nLinIncCab := nLinIniCab 
oPrint:Say (/*540*/nLinIncCab,/*nColMax-(nColMax/4)*/nColCab2,"CNPJ:",oFont12n,,,,0)   
nLinIncCab += nFatorLCab
oPrint:Say (/*610*/nLinIncCab,/*nColMax-(nColMax/4)*/nColCab2,"Nr.:",oFont12n,,,,0)   
nLinIncCab += nFatorLCab
oPrint:Say (/*680*/nLinIncCab,/*nColMax-(nColMax/4)*/nColCab2,"Estado:",oFont12n,,,,0)   
nLinIncCab += nFatorLCab
oPrint:Say (/*750*/nLinIncCab,/*nColMax-(nColMax/4)*/nColCab2,"CEP:",oFont12n,,,,0)   
nLinIncCab += nFatorLCab
oPrint:Say (/*820*/nLinIncCab,/*nColMax-(nColMax/4)*/nColCab2,"I.E.:",oFont12n,,,,0)   

nLinIncCab := nLinIniCab
oPrint:Say (/*540*/nLinIncCab,/*nColMax-(nColMax/4)*/nColCab2+150,TransForm(cCnpj,"@r 99.999.999/9999-99"),oFont12,,,,0)   
nLinIncCab += nFatorLCab
oPrint:Say (/*610*/nLinIncCab,/*nColMax-(nColMax/4)*/nColCab2+150,cValToChar(cNr),oFont12,,,,0)   
nLinIncCab += nFatorLCab
oPrint:Say (/*680*/nLinIncCab,/*nColMax-(nColMax/4)*/nColCab2+150,cEstado,oFont12,,,,0)   
nLinIncCab += nFatorLCab
oPrint:Say (/*750*/nLinIncCab,/*nColMax-(nColMax/4)*/nColCab2+150,TransForm(cCep,"@r 99999-999"),oFont12,,,,0)   
nLinIncCab += nFatorLCab
oPrint:Say (/*820*/nLinIncCab,/*nColMax-(nColMax/4)*/nColCab2+150,cIE,oFont12,,,,0)   


nLinIncCab := nLinIniCab 
oPrint:Say (/*540*/nLinIncCab,/*nColMax-(nColMax/4)*/nColCab3,"Contato:",oFont12n,,,,0)   
nLinIncCab += nFatorLCab
oPrint:Say (/*610*/nLinIncCab,/*nColMax-(nColMax/4)*/nColCab3,"Depto:",oFont12n,,,,0)   
nLinIncCab += nFatorLCab
oPrint:Say (/*680*/nLinIncCab,/*nColMax-(nColMax/4)*/nColCab3,"E-Mail:",oFont12n,,,,0)   
nLinIncCab += nFatorLCab
oPrint:Say (/*750*/nLinIncCab,/*nColMax-(nColMax/4)*/nColCab3,"Telefone:",oFont12n,,,,0)   

nLinIncCab := nLinIniCab
oPrint:Say (/*540*/nLinIncCab,/*nColMax-(nColMax/4)*/nColCab3+150,Alltrim(SCJ->CJ_CONTATO),oFont12,,,,0)   
nLinIncCab += nFatorLCab
oPrint:Say (/*610*/nLinIncCab,/*nColMax-(nColMax/4)*/nColCab3+150,Alltrim(SCJ->CJ_DPTO),oFont12,,,,0)   
nLinIncCab += nFatorLCab
oPrint:Say (/*680*/nLinIncCab,/*nColMax-(nColMax/4)*/nColCab3+150,Alltrim(SCJ->CJ_EMAIL),oFont12,,,,0)   
nLinIncCab += nFatorLCab
oPrint:Say (/*750*/nLinIncCab,/*nColMax-(nColMax/4)*/nColCab3+150,TransForm(SCJ->CJ_DDD+SCJ->CJ_FONE,"@r (99) 9999-9999"),oFont12,,,,0)   

//Dados do Orcamento (SCJ)
oPrint:Box(699,HMARGEM,0955,nColMax)
oPrint:Box(699,HMARGEM,0760,nColMax)
oPrint:Box(759,HMARGEM,0820,nColMax)

oPrint:Say (735,HMARGEM+50,"Tipo Frete:",oFont12n,,,,0)   
oPrint:Say (735,HMARGEM+200,Alltrim(SCJ->CJ_DMFRETE),oFont12n,,CLR_HRED,,0)   

nVlrFrete	 	:= SCJ->CJ_FRETE

oPrint:Say (735,HMARGEM+400,NoAcento("Condição de Pagamento:"),oFont12n,,,,0)          
oPrint:Say (735,HMARGEM+725,POSICIONE("SE4",1,xFilial("SE4")+SCJ->CJ_CONDPAG,"E4_DESCRI"),oFont12n,,CLR_HRED,,0)           

oPrint:Say (735,HMARGEM+1200,"Validade da Proposta:" ,oFont12n,,,,0)   
oPrint:Say (735,HMARGEM+1605,ALLTRIM(SCJ->CJ_VALPROP),oFont12n,,CLR_HRED,,0)   

oPrint:Say (735,HMARGEM+2100,"Moeda:",oFont12n,,,,0)   
oPrint:Say (735,HMARGEM+2200,"BRL",oFont12n,,CLR_HRED,,0)   

oPrint:Say (735,HMARGEM+2450,"Destinação:",oFont12n,,,,0)   
oPrint:Say (735,HMARGEM+2600,IIF(cTipo=="F","Consumo",IIF(cTipo=="R","Industrializar",IIF(cTipo=="S","Revender","Outros"))),oFont12n,,CLR_HRED,,0)   

If !lCondicom
	oPrint:Say (805,HMARGEM+50,"Referência da Proposta:",oFont14n,,,,0)   
	oPrint:Say (805,HMARGEM+450,Alltrim(SCJ->CJ_REFEREN),oFont14n,,CLR_HRED,,0)   
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFAT100   ºAutor  ³Microsiga           º Data ³  12/16/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function R100ITENS (nReg,lPrimeiro,nLinIt1,nLinObs,nItem)

DbSelectArea("SCK")
SCK->(DbGoTo(nReg))

Default nLinIt1 := 0975
Default nLinObs := 1065

nFatorCol := 0200
nColDaMarg:= 1300

//Dados dos Itens (SCK)
If lPrimeiro 
	If nQtdProdT > 5
		If (nPag -1) == nPagAtu
			oPrint:Box(nLinIt1-65,HMARGEM,1980,nColMax)
		Else
			oPrint:Box(nLinIt1-65,HMARGEM,nLinMax,nColMax)
		EndIf		
	else
		oPrint:Box(nLinIt1-65,HMARGEM,1980,nColMax)
	EndIf
	oPrint:Say (nLinIt1-070,HMARGEM+30,"Item" + SPACE(05) + "PN Rosenberger" + SPACE(03) + "Código Cliente + Descrição do Produto" ,oFont12n,,,,0)   
	nColDaMarg += nFatorCol
	oPrint:Say(nLinIt1-070,HMARGEM + nColDaMarg  + 04 ,"Quant.",oFont12n,,,,0)   
	nColDaMarg += nFatorCol-50
	oPrint:Say(nLinIt1-100,HMARGEM + nColDaMarg  + 03,"ICMS",oFont12n,,,,0)  	
	oPrint:Say(nLinIt1-70,HMARGEM + nColDaMarg  + 03,"  %",oFont12n,,,,0)  	
	nColDaMarg += nFatorCol
	oPrint:Say(nLinIt1-100,HMARGEM + nColDaMarg  - 105,"IPI",oFont12n,,,,0)  	
	oPrint:Say(nLinIt1-070,HMARGEM + nColDaMarg  - 105," %",oFont12n,,,,0)  
	
	If !Empty(cA1XXORPR1)
		oPrint:Say(nLinIt1-135,HMARGEM + nColDaMarg  ,cDescPrc11,oFont12n,,,,0)   
		oPrint:Say(nLinIt1-100,HMARGEM + nColDaMarg  ,cDescPrc12,oFont12n,,,,0)   
		oPrint:Say(nLinIt1-070,HMARGEM + nColDaMarg  ,cDescPrc13,oFont12n,,,,0)   
		nColDaMarg += nFatorCol
	EndIf

	If !Empty(cA1XXORPR2)
		oPrint:Say(nLinIt1-135,HMARGEM + nColDaMarg  ,cDescPrc21,oFont12n,,,,0)   
		oPrint:Say(nLinIt1-100,HMARGEM + nColDaMarg  ,cDescPrc22,oFont12n,,,,0)   
		oPrint:Say(nLinIt1-070,HMARGEM + nColDaMarg  ,cDescPrc23,oFont12n,,,,0)   
		nColDaMarg += nFatorCol
	EndIf
	
	If !Empty(cA1XXORPR3)
		oPrint:Say(nLinIt1-135,HMARGEM + nColDaMarg  ,cDescPrc31,oFont12n,,,,0)   
		oPrint:Say(nLinIt1-100,HMARGEM + nColDaMarg  ,cDescPrc32,oFont12n,,,,0)   
		oPrint:Say(nLinIt1-070,HMARGEM + nColDaMarg  ,cDescPrc33,oFont12n,,,,0)   
		nColDaMarg += nFatorCol
	EndIf
	nColDaMarg += nFatorCol
	oPrint:Say(nLinIt1-70,HMARGEM + nColDaMarg  - 200 ,"| Total do Item",oFont12n,,,,0)  
	nColDaMarg += nFatorCol
	oPrint:Say(nLinIt1-70,HMARGEM + nColDaMarg  - 170 ,"Prazo",oFont12n,,,,0)  
	nColDaMarg += nFatorCol
	
	nLinIt1 += 40
	nColDaMarg:= 1300
else
	//iF !Empty(Alltrim(SCK->CK_OBS)
	//nLinIt1 += 40
EndiF

//oPrint:Box(1150,nColMax-(nColMax/7),1240,nColMax/6)  
//oPrint:Box(1150,nColMax-(nColMax/6),1240,nColMax/5)  
//oPrint:Box(1150,nColMax-(nColMax/5),1240,nColMax/4)  
//oPrint:Box(1150,nColMax-(nColMax/4),1240,nColMax/3)  
//oPrint:Box(1150,nColMax-(nColMax/3),1240,nColMax)  
SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial("SB1") + SCK->CK_PRODUTO))

nLinQuebra := 70

cDescrProd := Alltrim(SB1->B1_XDESC)

If Empty(Alltrim(cDescrProd))
	cDescrProd := IIF(!Empty(Alltrim(SCK->CK_SEUCOD)),Alltrim(SCK->CK_SEUCOD) + " - ","") + Alltrim(SB1->B1_DESCR1) + Alltrim(SB1->B1_DESCR2) + Alltrim(SB1->B1_DESCR3)  +  Alltrim(SB1->B1_DESCR4) + Alltrim(SB1->B1_DESCR5)  + "-NCM: " + Alltrim(SB1->B1_POSIPI)
else
	cDescrProd :=	IIF(!Empty(Alltrim(SCK->CK_SEUCOD)),Alltrim(SCK->CK_SEUCOD) + " - ","") + cDescrProd + "-NCM: " + Alltrim(SB1->B1_POSIPI)
EndIf

oPrint:Say (nLinIt1,HMARGEM+030, StrZero(nItem,3) + " | " ,oFont12,,,,0)   
oPrint:Say (nLinIt1,HMARGEM+100, PADR(Alltrim(SCK->CK_PRODUTO),TAMSX3("CK_PRODUTO")[1],"") ,oFont12,,,,0)   
oPrint:Say (nLinIt1,HMARGEM+320,  "  |",oFont12,,,,0)   

oPrint:Say (nLinIt1-45,HMARGEM+350,  Substr(Alltrim(cDescrProd),1,nLinQuebra),oFont12,,,,0)   
oPrint:Say (nLinIt1-05,HMARGEM+350,  Substr(Alltrim(cDescrProd),nLinQuebra+1,nLinQuebra),oFont12,,,,0)   
oPrint:Say (nLinIt1+35,HMARGEM+350,  Substr(Alltrim(cDescrProd),nLinQuebra+nLinQuebra+2,nLinQuebra),oFont12,,,,0)   
oPrint:Say (nLinIt1+75,HMARGEM+350,  Substr(Alltrim(cDescrProd),nLinQuebra+nLinQuebra+nLinQuebra+2,nLinQuebra),oFont12,,,,0)   

nColDaMarg += nFatorCol

IF !Empty(Alltrim(SCK->CK_OBS))
	oPrint:Say (nLinObs+30,HMARGEM+30,"Obs.: " + Alltrim(SCK->CK_OBS),oFont12,,,,0)   
	nLinObs += 35
	oPrint:Line(nLinObs,HMARGEM,nLinObs,nColMax)
else
	//nLinObs += 35
	oPrint:Line(nLinObs,HMARGEM,nLinObs,nColMax)	
ENDIF

//Valores do Item
lIpi:=.F.  
nIpi:= 0 
nIcm:= 0
nPiscof := 9.25
nVlrIpi:= 0  
nTotal:= SCK->CK_VALOR  //+ SCK->CK_FRETE
cProduto:= SCK->CK_PRODUTO
cTes 	:= SCK->CK_TES
nQtd 	:= SCK->CK_QTDVEN 
nPrc 	:= SCK->CK_PRCVEN
nQtdPeso := SCK->CK_QTDVEN*SB1->B1_PESO
//nDesconto := A410Arred(nPrcLista*TMP1->CK_QTDVEN,"D2_DESCON")-nValMerc

If lPrimeiro
	// -------------------------------------------------------------------
	// Realiza os calculos necessários
	// -------------------------------------------------------------------
	IF nItem == 1
		MaFisSave()
		MaFisEnd()
	
		MaFisIni(cCliente,;										// 01- Codigo Cliente/Fornecedor
					cLoja,;										// 02- Loja do Cliente/Fornecedor
					"C",;											// 03- C: Cliente / F: Fornecedor
					"N",;											// 04- Tipo da NF
					cTipo,;										// 05- Tipo do Cliente/Fornecedor
					MaFisRelImp("MATA461",{"SCJ","SCK"}),;			// 06- Relacao de Impostos que suportados no arquivo
					,;												// 07- Tipo de complemento
					,;												// 08- Permite incluir impostos no rodape (.T./.F.)
					"SB1",;										// 09- Alias do cadastro de Produtos - ("SBI" para Front Loja)
					"MATA461")										// 10- Nome da rotina que esta utilizando a funcao
		/*
		MaFisIni(cCliente,;// 1-Codigo Cliente/Fornecedor
			cLoja,;		// 2-Loja do Cliente/Fornecedor
			"C",;				// 3-C:Cliente , F:Fornecedor
			"N",;				// 4-Tipo da NF
			cTipo,;		// 5-Tipo do Cliente/Fornecedor
			Nil,;
			Nil,;
			Nil,;
			Nil,;
			"MATA461",;
			Nil,;
			Nil,;
			"")
		*/
	EndIf
EndIf
// -------------------------------------------------------------------
// Monta o retorno para a MaFisRet
// -------------------------------------------------------------------
MaFisAdd(cProduto,cTes,nQtd,nPrc,0,"","",,0,0,0,0,nTotal,0)

//SF4->(DbSetOrder(1))
//SF4->(DbSeek(xFilial("SF4")+cTes))
//If SF4->F4_CREDIPI=="S"
lIpi	:=.T.
nIpi	:= POSICIONE("SB1",1,xFilial("SB1")+SCK->CK_PRODUTO,"B1_IPI")	
If nIpi > 0
	nVlrIpi	:= MaFisRet(nItem,"IT_VALIPI")	//(nIpi * SCK->CK_VALOR)/100
Endif


nIcm		:= MaFisRet(nItem,"IT_ALIQICM")
nVlrIcms 	:= MaFisRet(nItem,"IT_VALICM") //IIF(nIcm > 0 ,ROUND((SCK->CK_VALOR - (SCK->CK_VALOR * ((100 - nIcm) /100))),0),0)
nVlrPisCof 	:= MaFisRet(nItem,"IT_VALPS2")	+ MaFisRet(1,"IT_VALCF2")	//ROUND((SCK->CK_VALOR - (SCK->CK_VALOR * ((100 - nPiscof) /100))),2)
nValIcmSt 	:= MaFisRet(nItem,"IT_VALSOL")//SCK->CK_PICMRET
nVIcmPorPC	:= Round(nVlrIcms / nQtd,2)

//nTotal := MaFisRet(,"NF_TOTAL")

nTotal		:= SCK->CK_VALOR + nVlrIpi + nValIcmSt//+ SCJ->CJ_FRETE

//Endif
	
/*
Definição dos valores totais dos produtos que constarão na proposta
1 - PRECO UNIT. SEM PIS/ COFINS, ICMS E IPI                
2 - PRECO UNIT. COM PIS/ COFINS, SEM ICMS E IPI            
3 - PRECO UNIT. COM PIS/ COFINS E ICMS, SEM IPI            
4 - PRECO UNIT. COM PIS/ COFINS, ICMS E IPI                
5 - PRECO UNIT. COM PIS/ COFINS, ICMS, IPI E ST            
*/
Do Case
	Case cA1XXORPR1 == "1"
		nA1XXORPR1 := Round((SCK->CK_PRCVEN * ((100 - ( nPiscof)) /100)) - nVIcmPorPC ,2)
	Case cA1XXORPR1 == "2"
		nA1XXORPR1 := Round(SCK->CK_PRCVEN  - nVIcmPorPC,2) //* ((100 - nIcm) / 100),2) 
	Case cA1XXORPR1 == "3"
		nA1XXORPR1 := SCK->CK_PRCVEN 
	Case cA1XXORPR1 == "4"
		nA1XXORPR1 := ROUND(SCK->CK_PRCVEN * (1+(nIpi /100)),2)
	Case cA1XXORPR1 == "5"
		nA1XXORPR1 := ROUND((SCK->CK_PRCVEN * (1+(nIpi /100))) + Round(nValIcmSt/ nQtd,3),2)
End Case

Do Case
	Case cA1XXORPR2 == "1"
		nA1XXORPR2 := Round((SCK->CK_PRCVEN * ((100 - ( nPiscof)) /100)) - nVIcmPorPC ,2)
	Case cA1XXORPR2 == "2"
		nA1XXORPR2 := Round(SCK->CK_PRCVEN  - nVIcmPorPC,2) //* ((100 - nIcm) / 100),2) 
	Case cA1XXORPR2 == "3"
		nA1XXORPR2 := SCK->CK_PRCVEN 
	Case cA1XXORPR2 == "4"
		nA1XXORPR2 := ROUND(SCK->CK_PRCVEN * (1+(nIpi /100)),2)
	Case cA1XXORPR2 == "5"
		nA1XXORPR2 := ROUND((SCK->CK_PRCVEN * (1+(nIpi /100))) + Round(nValIcmSt/ nQtd,3),2)
End Case

Do Case
	Case cA1XXORPR3 == "1"
		nA1XXORPR3 := Round((SCK->CK_PRCVEN * ((100 - ( nPiscof)) /100)) - nVIcmPorPC ,2)
	Case cA1XXORPR3 == "2"
		nA1XXORPR3 := Round(SCK->CK_PRCVEN  - nVIcmPorPC,2) //* ((100 - nIcm) / 100),2) 
	Case cA1XXORPR3 == "3"
		nA1XXORPR3 := SCK->CK_PRCVEN 
	Case cA1XXORPR3 == "4"
		nA1XXORPR3 := ROUND(SCK->CK_PRCVEN * (1+(nIpi /100)),2)
	Case cA1XXORPR3 == "5"
		nA1XXORPR3 := ROUND((SCK->CK_PRCVEN * (1+(nIpi /100))) + Round(nValIcmSt/ nQtd,3),2)
End Case


nTotalGeral:= nTotalGeral +  nTotal     
nTotalGIPI := nTotalGIPI + nVlrIpi
nTotalGICM := nTotalGICM + nVlrIcms
nTotalGPCO := nTotalGPCO + nVlrPisCof
nTotalGIST := nTotalGIST + nValIcmSt

oPrint:Say(nLinIt1,(HMARGEM + nColDaMarg) - 10 ,"|",oFont12n,,,,0)   

oPrint:Say(nLinIt1,HMARGEM + nColDaMarg  ,PadL(Alltrim(Transform(SCK->CK_QTDVEN, "@E 9,999,999.99")),TAMSX3("CK_QTDVEN")[1],""),oFont12,,,,2)   
nColDaMarg += nFatorCol -50
oPrint:Say(nLinIt1,(HMARGEM + nColDaMarg) - 25 ,"|",oFont12n,,,,0)   


oPrint:Say(nLinIt1,HMARGEM + nColDaMarg ,Padl(Alltrim(Transform(nIcm,PesqPict("SB1","B1_PICM"))),5,""),oFont12,,,,2)  
nColDaMarg += nFatorCol - 100
oPrint:Say(nLinIt1,(HMARGEM + nColDaMarg) - 25 ," |",oFont12n,,,,0)   


oPrint:Say(nLinIt1,HMARGEM + nColDaMarg + 10 ,Padl(IIF(lIpi,Alltrim(Transform(nIpi, PesqPict("SB1","B1_IPI"))),"0"),5,""),oFont12,,,,2	)  
nColDaMarg += (nFatorCol -100)
oPrint:Say(nLinIt1,(HMARGEM + nColDaMarg) - 10  ," |",oFont12,,,,2)   

If !Empty(cA1XXORPR1)
	oPrint:Say(nLinIt1,HMARGEM + nColDaMarg,Padl(Alltrim(Transform(nA1XXORPR1, "@E 999,999,999.99")),TamSx3("CK_PRCVEN")[1],""),oFont12,,,,2)   
	nColDaMarg += nFatorCol
	oPrint:Say(nLinIt1,(HMARGEM + nColDaMarg) - 07 ,"|",oFont12,,,,2)   
EndIf

If !Empty(cA1XXORPR2)
	oPrint:Say(nLinIt1,HMARGEM + nColDaMarg,Padl(Alltrim(Transform(nA1XXORPR2, "@E 999,999,999.99")),TamSx3("CK_PRCVEN")[1],""),oFont12,,,,2)   
	nColDaMarg += nFatorCol
	oPrint:Say(nLinIt1,(HMARGEM + nColDaMarg) - 07 ,"|",oFont12,,,,2)   
EndIf

If !Empty(cA1XXORPR3)
	oPrint:Say(nLinIt1,HMARGEM + nColDaMarg,Padl(Alltrim(Transform(nA1XXORPR3, "@E 999,999,999.99")),TamSx3("CK_PRCVEN")[1],""),oFont12,,,,2)   
	nColDaMarg += nFatorCol
	oPrint:Say(nLinIt1,(HMARGEM + nColDaMarg) - 07 ,"|",oFont12,,,,2)   
EndIf


oPrint:Say(nLinIt1,HMARGEM + nColDaMarg ,PADL(Alltrim(Transform(nTotal, PesqPict("SCK","CK_VALOR"))),TamSx3("CK_VALOR")[1],""),oFont12,,,,2)
nColDaMarg += nFatorCol
oPrint:Say(nLinIt1,(HMARGEM + nColDaMarg) - 10 ,"|",oFont12,,,,2)   

oPrint:Say(nLinIt1,HMARGEM + nColDaMarg ,Alltrim(SCK->CK_PRAZO),oFont12,,,,2)
If nItem == nQtdProdT
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Indica os valores do cabecalho               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MaFisAlt("NF_FRETE",SCJ->CJ_FRETE)
	MaFisAlt("NF_SEGURO",SCJ->CJ_SEGURO)
	MaFisAlt("NF_AUTONOMO",SCJ->CJ_FRETAUT)
	MaFisAlt("NF_DESPESA",SCJ->CJ_DESPESA)
	MaFisAlt("NF_DESCONTO",MaFisRet(,"NF_DESCONTO")+MaFisRet(,"NF_VALMERC")*SCJ->CJ_PDESCAB/100)
	MaFisAlt("NF_DESCONTO",MaFisRet(,"NF_DESCONTO")+SCJ->CJ_DESCONT)
	MaFisWrite(1)
	nTotalGeral := MaFisRet(,"NF_TOTAL")
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFAT100   ºAutor  ³Microsiga           º Data ³  12/17/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function R100RODA (nReg,lSub,nLinAtu)                                       

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Indica os valores do cabecalho               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MaFisAlt("NF_FRETE",SCJ->CJ_FRETE)
MaFisAlt("NF_SEGURO",SCJ->CJ_SEGURO)
MaFisAlt("NF_AUTONOMO",SCJ->CJ_FRETAUT)
MaFisAlt("NF_DESPESA",SCJ->CJ_DESPESA)
MaFisAlt("NF_DESCONTO",MaFisRet(,"NF_DESCONTO")+MaFisRet(,"NF_VALMERC")*SCJ->CJ_PDESCAB/100)
MaFisAlt("NF_DESCONTO",MaFisRet(,"NF_DESCONTO")+SCJ->CJ_DESCONT)
MaFisWrite(1)


//Observações Gerais
oPrint:Box(1980,HMARGEM,2170,nColMax)
oPrint:Box(1980,HMARGEM,1982,nColMax)
oPrint:Say (2010,HMARGEM+50,"Observações Gerais: " + Alltrim(SCJ->CJ_OBS1),oFont12,,,,0)       
oPrint:Say (2050,HMARGEM+50,Alltrim(SCJ->CJ_OBS2),oFont12,,,,0)       
oPrint:Say (2090,HMARGEM+50,Alltrim(SCJ->CJ_OBS3),oFont12,,,,0)       
oPrint:Say (2130,HMARGEM+50,Alltrim(SCJ->CJ_OBS4),oFont12,,,,0)       

//Rodapé
oPrint:Box(2170,HMARGEM,nLinMax,nColMax)
oPrint:Box(1980,nColMax-(nColMax/4),nLinMax,nColMax)

oPrint:Say (2200,HMARGEM+50,"Em caso de confirmação, favor retornar assinado ou",oFont12n,,,,0)  
oPrint:Say (2240,HMARGEM+50,"responder o e-mail com 'orçamento aprovado'.",oFont12n,,,,0)         

oPrint:Say (2250,(nColMax/2+(nColMax/8)) -60,"________________________________",oFont10n,,,,2)  
oPrint:Say (2280,(nColMax/2+(nColMax/8)) -35,"   Assinatura do Cliente",oFont10n,,,,2)  



oPrint:Say (2020,nColMax-(nColMax/4)+30,"Valor s/ impostos:",oFont16n,,,,0)  
oPrint:Say (2020,nColMax-HMARGEM-200,Transform(nTotalGeral - (nTotalGIPI+nTotalGICM+nTotalGPCO+nTotalGIST+nVlrFrete),PesqPict("SCK","CK_VALOR")),oFont16n,,,,2)  
oPrint:Say (2060,nColMax-(nColMax/4)+30,"Valor IPI:",oFont16n,,,,0)  
oPrint:Say (2060,nColMax-HMARGEM-200,Transform(nTotalGIPI, PesqPict("SCK","CK_VALOR")),oFont16n,,,,2)  
oPrint:Say (2100,nColMax-(nColMax/4)+30,"Valor ICMS",oFont16n,,,,0)  
oPrint:Say (2100,nColMax-HMARGEM-200,Transform(nTotalGICM, PesqPict("SCK","CK_VALOR")),oFont16n,,,,2)  
oPrint:Say (2140,nColMax-(nColMax/4)+30,"Valor  Pis/Cofins:",oFont16n,,,,0)  
oPrint:Say (2140,nColMax-HMARGEM-200,Transform(nTotalGPCO, PesqPict("SCK","CK_VALOR")),oFont16n,,,,2)  
oPrint:Say (2180,nColMax-(nColMax/4)+30,"Valor ICMS-ST",oFont16n,,,,0)  
oPrint:Say (2180,nColMax-HMARGEM-200,Transform(nTotalGIST, PesqPict("SCK","CK_VALOR")),oFont16n,,,,2)  
oPrint:Say (2220,nColMax-(nColMax/4)+30,"Valor Frete:",oFont16n,,,,0)  
oPrint:Say (2220,nColMax-HMARGEM-200,Transform(nVlrFrete, PesqPict("SCK","CK_VALOR")),oFont16n,,,,2)  
oPrint:Say (2260,nColMax-(nColMax/4)+30,"Valor Total:",oFont16n,,,,0)  
oPrint:Say (2260,nColMax-HMARGEM-200,Transform(nTotalGeral, PesqPict("SCK","CK_VALOR")),oFont16n,,,,2)  


//oPrint:Say (2280,nColMax-HMARGEM-150,DTOC(DDATABASE) + " - " + TIME(),oFont10n,,,,2)
  
Ms_Flush()
oPrint:EndPage()     // Finaliza a página

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MyGetEnd  ³ Autor ³ Liber De Esteban             ³ Data ³ 19/03/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se o participante e do DF, ou se tem um tipo de endereco ³±±
±±³          ³ que nao se enquadra na regra padrao de preenchimento de endereco  ³±±
±±³          ³ por exemplo: Enderecos de Area Rural (essa verificção e feita     ³±±
±±³          ³ atraves do campo ENDNOT).                                         ³±±
±±³          ³ Caso seja do DF, ou ENDNOT = 'S', somente ira retornar o campo    ³±±
±±³          ³ Endereco (sem numero ou complemento). Caso contrario ira retornar ³±±
±±³          ³ o padrao do FisGetEnd                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Obs.     ³ Esta funcao so pode ser usada quando ha um posicionamento de      ³±±
±±³          ³ registro, pois será verificado o ENDNOT do registro corrente      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIS                                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function MyGetEnd(cEndereco,cAlias)

Local cCmpEndN	:= SubStr(cAlias,2,2)+"_ENDNOT"
Local cCmpEst	:= SubStr(cAlias,2,2)+"_EST"
Local aRet		:= {"",0,"",""}

//Campo ENDNOT indica que endereco participante mao esta no formato <logradouro>, <numero> <complemento>
//Se tiver com 'S' somente o campo de logradouro sera atualizado (numero sera SN)
If (&(cAlias+"->"+cCmpEst) == "DF") .Or. ((cAlias)->(FieldPos(cCmpEndN)) > 0 .And. &(cAlias+"->"+cCmpEndN) == "1")
	aRet[1] := cEndereco
	aRet[3] := "SN"
Else
	aRet := FisGetEnd(cEndereco)
EndIf
Return aRet



Static Function EnvMail(cAnexo,cOrc)

Private mCorpo       := ''
Private cAssunto     := 'Orçamento  - ' + AllTrim(SA1->A1_NOME) + ' - No. ' + cOrc
Private nLineSize    := 60
Private nTabSize     := 3
Private lWrap        := .T. 
Private nLine        := 0
Private cTexto       := ""
Private lServErro	   := .T.
Private cServer  := Trim(GetMV("MV_RELSERV")) // smtp.tecnotron.ind.br
//Private cDe 	:= If(!Empty(UsrRetMail(RetCodUsr())),UsrRetMail(RetCodUsr()),Trim(GetMV("MV_RELACNT")))
Private cDe 	:= Trim(GetMV("MV_RELACNT"))
Private cPass    := Trim(GetMV("MV_RELPSW"))  // 
Private lAutentic	:= GetMv("MV_RELAUTH",,.F.)

Private cPara      := "jackson.santos@opusvp.com.br" //SA1->A1_XMAIL
Private cCC        := "jackson.santos@opusvp.com.br" //Posicione("SA3",1,xFilial("SA3")+SCJ->CJ_XVEND1,"A3_EMAIL")// Space(250)

mCorpo += 'Segue Anexo Orçamento: ' + cOrc +Chr(13)+Chr(10)+Chr(13)+Chr(10)
mCorpo += 'No Aguardo de Sua Confirmação, ficamos a disposição.'+Chr(13)+Chr(10)+Chr(13)+Chr(10)
mCorpo += 'Atenciosamente, '+Chr(13)+Chr(10)+Chr(13)+Chr(10)
//mCorpo += Capital(Posicione("SA3",1,xFilial("SA3")+SCJ->CJ_XVEND1,'A3_NOME'))+Chr(13)+Chr(10)+Chr(13)+Chr(10)
mCorpo += SA3->A3_EMAIL+Chr(13)+Chr(10)+Chr(13)+Chr(10)
mCorpo += 'Depto.Comercial'+Chr(13)+Chr(10)+Chr(13)+Chr(10)
mCorpo += ALLTRIM(SM0->M0_NOMECOM)+Chr(13)+Chr(10)
mCorpo += 'Fone: 012 3221-8500'+Chr(13)+Chr(10)
mCorpo += 'E-Mail: vendas@rosenberger.com'+Chr(13)+Chr(10)
mCorpo += 'Site: www.rosenberger.com'+Chr(13)+Chr(10)






                         


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Interface                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 122,67 To 531,733 Dialog maildlg Title OemToAnsi("Envio de E-Mail ")
@ 2,4 To 78,324
@ 80,4 To 182,324
@ 11,15 Say OemToAnsi("De :") Size 30,8
@ 23,15 Say OemToAnsi("Para :") Size 25,8
@ 35,15 Say OemToAnsi("CC :") Size 30,8
@ 47,15 Say OemToAnsi("Assunto :") Size 30,8
@ 59,15 Say OemToAnsi("Anexos :") Size 30,8
@ 10,40 Get cDe Size 270,10  When .F.
@ 22,40 Get cPara Size 270,10 Object oPara
@ 34,40 Get cCC Size 270,10   Object oCC
@ 46,40 Get cAssunto Size 270,10
@ 58,40 Get cAnexo  Size 270,10  //When .f.    
/*@ 186,015 Say "Validade :" 
@ 186,40 Get _nValidade valid _nValidade > 0
@ 186,070 Say "Entrega  :" 
@ 186,105 Get _nEntrega valid _nEntrega > 0
@ 186,100 Say "Condicao de Pagamento:"
@ 186,135 Get _cCondPag valid !Empty(_cCondpag) F3 "SE4" */
@ 88,9 Get mCorpo MEMO Size 310,90
@ 187,276 Button OemToAnsi("_Enviar") Size 36,16 Action IIF(!Empty(cPara),Close(maildlg),MsgAlert("E-Mail sem destinatario !!","Envio de E-mail"))
Activate Dialog maildlg centered

lServERRO 	:= .F.
                    
CONNECT SMTP                         ;
SERVER 	 GetMV("MV_RELSERV"); 	// Nome do servidor de e-mail
ACCOUNT  GetMV("MV_RELACNT"); 	// Nome da conta a ser usada no e-mail
PASSWORD GetMV("MV_RELPSW") ; 	// Senha
Result lConectou    

lRet := .f.
lEnviado := .f.
If lAutentic
	lRet := Mailauth(cDe,cPass)
Endif

If lRet  
	
	cPara   := Rtrim(cPara)
	cCC		:= Rtrim(cCC)    
	cAssunto:= Rtrim(cAssunto)  
	
	SEND MAIL 	FROM cDe ;
		 		To cPara ;
	    	    CC cCc;
		 		SUBJECT	cAssunto ; 
		 		Body mCorpo;		
		 		ATTACHMENT cAnexo;
		 		RESULT lEnviado
		
	DISCONNECT SMTP SERVER
Endif
If !(lConectou .AND. lEnviado)
	cMensagem := ""
	GET MAIL ERROR cMensagem 
Endif          
Return                      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ fCriaPerg³ Autor ³                       ³ Data ³ 22/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fCriaPerg(_cPerg)
aSvAlias:={Alias(),IndexOrd(),Recno()}
i:=j:=0
aRegistros:={}
//                1      2    3               4  5     6      7  8  9  10 11  12 13         14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43
AADD(aRegistros,{_cPerg,"01","Orçamento           ? ","","","mv_ch1","C",06,00,00,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","SCJ","","","","",""})


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


Static Function CONDCOMERC(nLinCond)
Local lREt := .T.
Local nFatorLin := 35

oPrint:Box(nLinCond,HMARGEM,nLinMax,nColMax)
oPrint:Say (nLinCond-3,HMARGEM+030, "Condições Comerciais:" ,oFont16n,,,,0)   
nLinCond += nFatorLin
oPrint:Say (nLinCond,HMARGEM+100,"Os preços e prazos são validos somente para esta proposta e nas quantidades acima referenciadas.",oFont14,,,,0)   
nLinCond += nFatorLin
oPrint:Say (nLinCond,HMARGEM+100,"Favor mencionar em seu pedido, o número da nossa proposta acima, bem como os dados cadastrais necessários para faturamento.",oFont14,,,,0)   
//nLinCond += nFatorLin
//oPrint:Say (nLinCond,HMARGEM+100,"Solicitamos informar em seu pedido o destino do material:",oFont14,,,,0)   
//nLinCond += nFatorLin
//oPrint:Say (nLinCond,HMARGEM+100,"[  ] REVENDA   [  ] INDUSTRIALIZAÇÃO   [  ] CONSUMO   [  ] TRANSFORMAÇÃO",oFont14n,,,,0)   
nLinCond += nFatorLin *2

oPrint:Say (nLinCond,HMARGEM+030,"1. Impostos:" ,oFont16n,,,,0)   
nLinCond += nFatorLin
oPrint:Say (nLinCond,HMARGEM+100,"ICMS: Conforme indicado em cada produto",oFont14,,,,0)   
nLinCond += nFatorLin
oPrint:Say (nLinCond,HMARGEM+100,"IPI: Conforme indicado em cada produto",oFont14,,,,0)
nLinCond += nFatorLin
oPrint:Say (nLinCond,HMARGEM+100,"Qualquer alteração a partir desta data na atual legislação fiscal que venha a criar novos impostos/taxas ou alterar alíquotas em vigor, resultará em uma correspondente ",oFont14,,,,0)
nLinCond += nFatorLin
oPrint:Say (nLinCond,HMARGEM+100,"alteração nos preços de maneira a adequá-los a nova situação.",oFont14,,,,0)
nLinCond += nFatorLin *2

oPrint:Say (nLinCond,HMARGEM+30,"2. Frete:",oFont16n,,,,0)
nLinCond += nFatorLin
oPrint:Say (nLinCond,HMARGEM+100,"A entrega da mercadoria acontecerá no endereço indicado no pedido de compras do cliente, no piso térreo. É de responsabilidade do cliente o recebimento do material",oFont14,,,,0)
nLinCond += nFatorLin
oPrint:Say (nLinCond,HMARGEM+100,"no piso térreo e o transporte para o piso desejado. Caso o cliente não tenha disponibilidade  em fazer  esta movimentação, terá  que se responsabilizar pelo custo extra",oFont14,,,,0)
nLinCond += nFatorLin
oPrint:Say (nLinCond,HMARGEM+100,"cobrado pela transportadora, a ser negociado no ato da entrega.",oFont14,,,,0)
nLinCond += nFatorLin *2

oPrint:Say (nLinCond,HMARGEM+30,"3. Reajuste:",oFont16n,,,,0)
nLinCond += nFatorLin
oPrint:Say (nLinCond,HMARGEM+100,"Caso ocorra, dentro do prazo de validade desta proposta, alterações na política econômica vigente e/ou alterações cambiais ou superior ou igual a +/-5%(mais ou menos",oFont14,,,,0)
nLinCond += nFatorLin
oPrint:Say (nLinCond,HMARGEM+100,"cinco por cento), os  valores e  prazos contidos  nesta  proposta deverão ser reajustados, de comum acordo entre a Rosenberger Domex Telecomunicações e o Cliente,",oFont14,,,,0)
nLinCond += nFatorLin
oPrint:Say (nLinCond,HMARGEM+100,"preservando-se o equilíbrio financeiro de ambas as partes. Os preços acima têm como base a cotação da moeda nesta data, publicada pelo Banco Central do Brasil.",oFont14,,,,0)
nLinCond += nFatorLin *2

oPrint:Say (nLinCond,HMARGEM+30,"4. Atraso de Pagamento:",oFont16n,,,,0)
nLinCond += nFatorLin
oPrint:Say (nLinCond,HMARGEM+100,"No caso de atraso de pagamento será imputado juros, salvo se o motivo for gerado pela RDT.",oFont14,,,,0)
nLinCond += nFatorLin *2

oPrint:Say (nLinCond,HMARGEM+30,"5. Garantia:",oFont16n,,,,0)
nLinCond += nFatorLin
oPrint:Say (nLinCond,HMARGEM+100,"12 meses",oFont14,,,,0)
nLinCond += nFatorLin
oPrint:Say (nLinCond,HMARGEM+100,"Rosenberger Domex Telecomunicações compromete-se a substituir qualquer quantidade de material que apresentar defeito de fabricação dentro de um período de 12",oFont14,,,,0)
nLinCond += nFatorLin
oPrint:Say (nLinCond,HMARGEM+100,"meses  após a  entrega  dos  mesmos  sem  ônus  a sua  empresa,  desde que utilizados em  condições  normais ao serviço. Ficam excluídos dessa garantia os danos",oFont14,,,,0)
nLinCond += nFatorLin
oPrint:Say (nLinCond,HMARGEM+100,"provenientes de instalação e manuseio inadequados e/ou decorrentes de avarias por acidentes.",oFont14,,,,0)
nLinCond += nFatorLin *2

oPrint:Say (nLinCond,HMARGEM+30,"6. Devolução:",oFont16n,,,,0)
nLinCond += nFatorLin
oPrint:Say (nLinCond,HMARGEM+100,"Qualquer devolução de material fica condicionada a recebimento pela Rosenberger Domex Telecomunicações do relatório de não conformidade para análise e solução",oFont14,,,,0)
nLinCond += nFatorLin
oPrint:Say (nLinCond,HMARGEM+100,"do processo, de comum acordo.",oFont14,,,,0)

nLinCond += nFatorLin *2

oPrint:Say (nLinCond,HMARGEM+30,"7. Embalagem:",oFont16n,,,,0)
nLinCond += nFatorLin
oPrint:Say (nLinCond,HMARGEM+100,"Inclusa nos preços propostos.",oFont14,,,,0)
nLinCond += nFatorLin *2

oPrint:Say (nLinCond,HMARGEM+30,"8. Alteração da Política Econômica:",oFont16n,,,,0)
nLinCond += nFatorLin
oPrint:Say (nLinCond,HMARGEM+100,"Os preços  e  condições  desta  proposta foram  fixados de acordo  com a sistemática econômico/financeira ditada pela política  vigente. Portanto, na eventualidade de",oFont14,,,,0)
nLinCond += nFatorLin
oPrint:Say (nLinCond,HMARGEM+100,"ocorrerem alterações  econômicas/financeiras  entre a data da  proposta e a  data da entrega do material, as condições ora propostas, deverão ser revistas de modo a ",oFont14,,,,0)
nLinCond += nFatorLin
oPrint:Say (nLinCond,HMARGEM+100,"restabelecer a relação que as partes pactuaram inicialmente, objetivando a manutenção do inicial equilíbrio econômico e financeiro da proposta.",oFont14,,,,0)


oPrint:EndPage()
Return lRet

