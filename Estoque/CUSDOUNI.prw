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

#DEFINE ENTER CHAR(13) + CHAR(10)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  CUSDOUNI  ºAutor  ³Jonas Pereira      º Data ³  25/07/2019   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Custo Unificado - Domex                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CUSDOUNI()     
Local oDlg                    
Local lHasButton 	:= .T.

Private dMvUlmes  := SuperGetMV("mv_ulmes") 
Private dGet1		:= dMvUlmes+1      //Date() // Variï¿½vel do tipo Data
Private dGet2 		:= LASTDAY(dMvUlmes+1) //Date() // Variï¿½vel do tipo Data
Private cPerAtu   := ""
Private cPerAnt   := ""
Private lLog      := .f.                      
Private cCabecalho:=" | Componente     |AM|Mov|DT Emiss|OP        |Produto OP      |"+SPACE(150) //" |Produto        |Data    |AM|Qtd. Negativa   |"                     
Private cLogCus   := ""
Private cFileNOK 	:= "\icons\check-blue-nok.png"     
Private cFileOK 	:= "\icons\check-blue-ok.png"     
Private cFileExe	:= "\icons\processar.png"
Private cFileAll	:= "\icons\all.png"
Private cFileExit	:= "\icons\exit.png"  
Private cFileLeg 	:= "\icons\leg.png"  
Private cFileVol 	:= "\icons\voltar.png"  
Private cFileAva 	:= "\icons\avancar.png"     
Private cFileRel 	:= "\icons\iconerel.png"
Private cFileBlq 	:= "\icons\cadeado.png"
Private aOptions  := {}
Private aSize 		:= {}
Private aObjects 	:= {}
Private aInfo 		:= {}
Private aPosObj 	:= {}
Private aPosGet	:= {}
Private cCadastro := "Rotina de Custo Medio Unificado Domex"
Private cTit		:= "Custo Medio / Processando"
Private lAll      := .F.
Private lOpt      := .F.                    
Private lPerAnt   := .f.
Private nContPer  := 0
Private oMemo1
Private cTxtMemo1   := ''
Private SaveTexto 
Private SaveProjet


Static oFWLayer
Static oWin1
Static oWin2
Static oWin3
Static oWin4
Static oWin5

Static aHeader    := {}
Static aCols      := {}                   
                                   
//X31UPDTABLE("ZZB")

aSize	            := MsAdvSize( .F. )
aInfo 	         := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }

AAdd( aObjects, { 100	, 050	, .T., .F. })
AAdd( aObjects, { 100	, 100	, .T., .T. })

aPosObj	         := MsObjSize(aInfo,aObjects)
aPosGet	         := MsObjGetPos((aSize[3]-aSize[1]),315,{{004,024,240,270}} )     
  
//CRIA NOVO PERIODO PARA GRAVACAO DO LOG
cPerAtu  :=	AnoMes(dGet1) 
cPerAnt  :=	AnoMes(MonthSub(dGet1,1))
ZZB->(dbsetorder(1))
If !ZZB->(DBSeek(xFilial("ZZB")+cPerAtu))
         cQuery := "SELECT * FROM ZZB010 (NOLOCK) WHERE D_E_L_E_T_='' AND ZZB_PERIOD='"+cPerAnt+"' AND ZZB_FILIAL='"+xFilial("ZZB")+"' ORDER BY ZZB_PERIOD, SEQPROC "           
			If Select("TMPZZB") <> 0
				TMPZZB->( dbCloseArea() )
			EndIf
			TCQUERY cQuery NEW ALIAS TMPZZB
			While TMPZZB->(!EOF()) .AND. TMPZZB->ZZB_PERIOD==cPerAnt
				Reclock("ZZB",.T.)
				ZZB->ZZB_LOG 	    := "Item nao processado"
				ZZB->ZZB_PERIOD    := cPerAtu       
				ZZB->ZZB_ROTINA    := TMPZZB->ZZB_ROTINA  
				ZZB->ZZB_DESCRI    := TMPZZB->ZZB_DESCRI       
				ZZB->SEQPROC       := TMPZZB->SEQPROC 
				ZZB->(MSUNLOCK()) 
				TMPZZB->(DBSkip())
			Enddo	
EndIf
                  

//DbSelectArea("ZZB")
ZZB->(dbsetorder(2))
If ZZB->(DBSeek(xFilial("ZZB")+cPerAtu))
	While ZZB->(!EOF()) .AND. ZZB->ZZB_PERIOD==cPerAtu .AND. ZZB->ZZB_FILIAL==fwfilial()
		AADD(aOptions, { alltrim(ZZB->ZZB_ROTINA), .f.,ZZB->( Recno() ) })
		ZZB->(dbskip())
	Enddo
EndIF

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd STYLE nOR( WS_VISIBLE,WS_POPUP ) PIXEL

	oDlg:lEscClose := .F.
	                                                               	
	oFWLayer := FWLayer():New()		
	oFWLayer:Init(oDlg,.F.)
                                        
	oFWLayer:AddLine( "UP",      18, .F. ) 
	oFWLayer:AddLine( "MEDIUM",  64, .F. ) 
	oFWLayer:AddLine( "DOWN",    18, .F. ) 
	
	oFWLayer:AddCollumn("Col01",100,.T.,"UP"    )
	oFWLayer:AddCollumn("Col02",50,.T. ,"MEDIUM")
	oFWLayer:AddCollumn("Col03",50,.T. ,"MEDIUM")
	oFWLayer:AddCollumn("Col04",50,.T. ,"DOWN"  )
  	oFWLayer:AddCollumn("Col05",50,.T. ,"DOWN"  )	

	
	oFWLayer:AddWindow("Col01","Win01"	,"Parametros do Fechamento"	,100,.F.,.F.,/*bAction*/     ,"UP"    /*cIDLine*/,/*bGotFocus*/)	
	oFWLayer:AddWindow("Col02","Win02"	,"Selecione as opcoes "	      ,100,.F.,.F., 					  ,"MEDIUM"/*cIDLine*/,/*bGotFocus*/)
	oFWLayer:AddWindow("Col03","Win03"	,"Log"								,100,.F.,.F.,/*bAction*/     ,"MEDIUM"/*cIDLine*/,/*bGotFocus*/)	
	oFWLayer:AddWindow("Col04","Win04"	,"         Voltar                                 Legenda                                   Executar                                      Sair                                 Avancar" ,100,.F.,.F.,/*bAction*/     ,"DOWN"  /*cIDLine*/,/*bGotFocus*/)		
  	oFWLayer:AddWindow("Col05","Win05"	,"       Relatorio Mensal                         Contabil Domex                                Modelo 7                                 Estoque Analitico" ,100,.F.,.F.,/*bAction*/     ,"DOWN"  /*cIDLine*/,/*bGotFocus*/) 
	
	oWin1 := oFWLayer:GetWinPanel('Col01','Win01',"UP")
	oWin2 := oFWLayer:GetWinPanel('Col02','Win02',"MEDIUM")
	oWin3 := oFWLayer:GetWinPanel('Col03','Win03',"MEDIUM")
	oWin4 := oFWLayer:GetWinPanel('Col04','Win04',"DOWN")
	oWin5 := oFWLayer:GetWinPanel('Col05','Win05',"DOWN")
    
   
	oGetUlmes:= TGet():New(010, 001, { | u | If( PCount() == 0, dMvUlmes, dMvUlmes := u ) },oWin1, ;
 	045, 010, "@D",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F. ,,"dMvUlmes",,,,lHasButton  )   
   
   oGetUlmes:Disable()
      
   oSay3:= TSay():New(01,01,{||'DT. Ulmes'},oWin1,,oFont,,,,.T.,CLR_HGRAY,CLR_WHITE,200,20) 
        
	oGet1:= TGet():New(010, 055, { | u | If( PCount() == 0, dGet1, dGet1 := u ) },oWin1, ;
 	060, 010, "@D",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dGet1",,,,lHasButton  )
	
	oSay4:= TSay():New(01,55,{||'DT. Inicio'},oWin1,,oFont,,,,.T.,CLR_HGRAY,CLR_WHITE,200,20) 
	   
  //	oGet2:= TGet():New(010, 115, { | u | If( PCount() == 0, dGet2, dGet2 := u ) },oWin1, ;
 //q	060, 010, "@D",, 0, 16777215,,.F.,,.T.,,.F.,.T.,.F.,.F.,,.F.,.F. ,"dGet2",,,,.T.  ) 
 	
 	
   oGet2:=TGet():New( 010, 115, { | u | If( PCount() == 0, dGet2, dGet2 := u ) },oWin1, ;   
   060, 010,"@D",/*cValid*/{||.T.},0,16777215,,.F.,,.T.,  ,.F.,/*cWhen*/{||.T.},.F.,.F.,,.F.,.F.,"dGet1",,,,,.f.)
 	
 	oSay5:= TSay():New(01,115,{||'DT. Fim'},oWin1,,oFont,,,,.T.,CLR_HGRAY,CLR_WHITE,200,20) 
	          
	// Botï¿½es da tela
   
	oTBitmapVoltar := TBitmap():New(02,010,100,50,,cFileVol,.T.,oWin4, {|| fVoltar() },,.F.,.F.,,,.F.,,.T.,,.F.)
   oTBitmapVoltar:lAutoSize := .T. 
  	
   oTBitmapLegenda := TBitmap():New(02,080,100,50,,cFileLeg,.T.,oWin4, {|| ZZBLeg() },,.F.,.F.,,,.F.,,.T.,,.F.)
   oTBitmapLegenda:lAutoSize := .T. 
  	
  	oTBitmapExe     := TBitmap():New(01,150,100,50,,cFileExe,.T.,oWin4,   {||  IF(fExeCust(),,MSGSTOP("Selecione uma das opï¿½ï¿½es para processamento")) },,.F.,.F.,,,.F.,,.T.,,.F.)
   oTBitmapExe:lAutoSize := .T. 
       
   oTBitmapSair    := TBitmap():New(02,220,100,50,,cFileExit,.T.,oWin4,   {|| oDlg:End() },,.F.,.F.,,,.F.,,.T.,,.F.)
   oTBitmapSair:lAutoSize := .T. 
   
	oTBitmapAvancar := TBitmap():New(02,290,100,50,,cFileAva,.T.,oWin4,    {|| fAvancar()  },,.F.,.F.,,,.F.,,.T.,,.F.)
   oTBitmapAvancar:lAutoSize := .T. 
     	

	oTBitmapRelMensal  := TBitmap():New(02,025,100,50,,cFileRel,.T.,oWin5, {||U_RMENCUST() },,.F.,.F.,,,.F.,,.T.,,.F.)
   oTBitmapRelMensal:lAutoSize := .T. 
  	
   oTBitmapRelContabil:= TBitmap():New(02,100,100,50,,cFileRel,.T.,oWin5, {||U_R1CTBCUS() },,.F.,.F.,,,.F.,,.T.,,.F.)
   oTBitmapRelContabil:lAutoSize := .T. 
  	
  	oTBitmapRelModelo7 := TBitmap():New(02,180,100,50,,cFileRel,.T.,oWin5, {|| MATR460() },,.F.,.F.,,,.F.,,.T.,,.F.)
   oTBitmapRelModelo7:lAutoSize := .T. 
       
   oTBitmapEstoqueAna := TBitmap():New(02,260,100,50,,cFileRel,.T.,oWin5, {|| MATR260()  },,.F.,.F.,,,.F.,,.T.,,.F.) 
   oTBitmapEstoqueAna:lAutoSize := .T.                                                                         

   oTBitmapBloqueio := TBitmap():New(07,640,100,50,,cFileBlq,.T.,oWin1,   {|| BLQEST()  },,.F.,.F.,,,.F.,,.T.,,.F.) 
   oTBitmapBloqueio:lAutoSize := .T.                                                                         
   

  	 // Cria Fonte para visualizaï¿½ï¿½o
 	oFont  := TFont():New('Courier new',,-18,.T.)
 	oFMemo := TFont():New('Courier new',,-13,.T.)
   
  
	oTButton1 := TButton():New( 001, 001, "ALL",oWin2,{||fbmpcontrol()}, 13,14,,,.F.,.T.,.F.,,.F.,,,.F. )  
 
   oTBitmap1 := TBitmap():New(17,01,100,50,,cFileNOK,.T.,oWin2,   {|| IIF(oTBitmap1:cBmpFile==cFileNOK ,  fOption("ACERTASB9",.t.,"oTBitmap1:Load(NIL, cFileOK)") ,  fOption("ACERTASB9",.f.,"oTBitmap1:Load(NIL, cFileNOK)") ) },,.F.,.F.,,,.F.,,.T.,,.F.)
   oTBitmap1:lAutoSize := .T.     
         
   oTBitmap2 := TBitmap():New(25,01,100,50,,cFileNOK,.T.,oWin2,   {|| IIF(oTBitmap2:cBmpFile==cFileNOK,   fOption("SLDINICI",.t.,"oTBitmap2:Load(NIL, cFileOK)"),    fOption("SLDINICI",.f.,"oTBitmap2:Load(NIL, cFileNOK)")) },,.F.,.F.,,,.F.,,.T.,,.F.)
   oTBitmap2:lAutoSize := .T.            
       	   
   oTBitmap3 := TBitmap():New(34,01,100,50,,cFileNOK,.T.,oWin2,   {|| IIF(oTBitmap3:cBmpFile==cFileNOK,   fOption("SLDLTEND",.t.,"oTBitmap3:Load(NIL, cFileOK)"),    fOption("SLDLTEND",.f.,"oTBitmap3:Load(NIL, cFileNOK)"))   },,.F.,.F.,,,.F.,,.T.,,.F.)
   oTBitmap3:lAutoSize := .T.   
      
   oTBitmap4 := TBitmap():New(42,01,100,50,,cFileNOK,.T.,oWin2,   {|| IIF(oTBitmap4:cBmpFile==cFileNOK,  fOption("RECURSIVIDADE",.t.,"oTBitmap4:Load(NIL, cFileOK)"), fOption("RECURSIVIDADE",.f.,"oTBitmap4:Load(NIL, cFileNOK)"))   },,.F.,.F.,,,.F.,,.T.,,.F.)
   oTBitmap4:lAutoSize := .T.   

   oTBitmap5 := TBitmap():New(50,01,100,50,,cFileNOK,.T.,oWin2,   {|| IIF(oTBitmap5:cBmpFile==cFileNOK,  fOption("PRXRE",.t.,"oTBitmap5:Load(NIL, cFileOK)") ,    fOption("PRXRE",.f.,"oTBitmap5:Load(NIL, cFileNOK)")) },,.F.,.F.,,,.F.,,.T.,,.F.)
   oTBitmap5:lAutoSize := .T.            
                                                                    
   oTBitmap6 := TBitmap():New(59,01,100,50,,cFileNOK,.T.,oWin2,   {|| IIF(oTBitmap6:cBmpFile==cFileNOK,  fOption("SEMMOVB9",.t.,"oTBitmap6:Load(NIL, cFileOK)") , fOption("SEMMOVB9",.f.,"oTBitmap6:Load(NIL, cFileNOK)")) },,.F.,.F.,,,.F.,,.T.,,.F.)
   oTBitmap6:lAutoSize := .T.       
                                                            
   oTBitmap7 := TBitmap():New(68,01,100,50,,cFileNOK,.T.,oWin2,   {|| IIF(oTBitmap7:cBmpFile==cFileNOK,  fOption("ESTNEG",.t.,"oTBitmap7:Load(NIL, cFileOK)") ,   fOption("ESTNEG", .f.,"oTBitmap7:Load(NIL, cFileNOK)")) },,.F.,.F.,,,.F.,,.T.,,.F.)
   oTBitmap7:lAutoSize := .T.            
                               
   oTBitmap8 := TBitmap():New(76,01,100,50,,cFileNOK,.T.,oWin2,   {|| IIF(oTBitmap8:cBmpFile==cFileNOK,  fOption("VALCUS",.t.,"oTBitmap8:Load(NIL, cFileOK)"),  fOption("VALCUS", .f.,"oTBitmap8:Load(NIL, cFileNOK)")) },,.F.,.F.,,,.F.,,.T.,,.F.)
   oTBitmap8:lAutoSize := .T.                                                                                                                           
      
   oTBitmap9 := TBitmap():New(84,01,100,50,,cFileNOK,.T.,oWin2,   {|| IIF(oTBitmap9:cBmpFile==cFileNOK,  fOption("JOBM330",.t.,"oTBitmap9:Load(NIL, cFileOK)"),  fOption("JOBM330",.f.,"oTBitmap9:Load(NIL, cFileNOK)")) },,.F.,.F.,,,.F.,,.T.,,.F.)
   oTBitmap9:lAutoSize := .T.            
                                                                    
   oTBitmap10 := TBitmap():New(93,01,100,50,,cFileNOK,.T.,oWin2,   {|| IIF(oTBitmap10:cBmpFile==cFileNOK, fOption("SEQCALC",.t.,"oTBitmap10:Load(NIL, cFileOK)") , fOption("SEQCALC",.f.,"oTBitmap10:Load(NIL, cFileNOK)")) },,.F.,.F.,,,.F.,,.T.,,.F.)
   oTBitmap10:lAutoSize := .T.       
                                                            
   oTBitmap11 := TBitmap():New(101,01,100,50,,cFileNOK,.T.,oWin2,  {|| IIF(oTBitmap11:cBmpFile==cFileNOK, fOption("CORDIFCU",.t.,"oTBitmap11:Load(NIL, cFileOK)")  , fOption("CORDIFCU", .f.,"oTBitmap11:Load(NIL, cFileNOK)")) },,.F.,.F.,,,.F.,,.T.,,.F.)
   oTBitmap11:lAutoSize := .T.            
                               
   oTBitmap12 := TBitmap():New(110,01,100,50,,cFileNOK,.T.,oWin2, {|| IIF(oTBitmap12:cBmpFile==cFileNOK,  fOption("PROXREQ",.t.,"oTBitmap12:Load(NIL, cFileOK)")  , fOption("PROXREQ", .f.,"oTBitmap12:Load(NIL, cFileNOK)")) },,.F.,.F.,,,.F.,,.T.,,.F.)
   oTBitmap12:lAutoSize := .T.                                                                                                                           
       
   oTBitmap13 := TBitmap():New(119,01,100,50,,cFileNOK,.T.,oWin2, {|| IIF(oTBitmap13:cBmpFile==cFileNOK, fOption("JOBM331",.t.,"oTBitmap13:Load(NIL, cFileOK)")  , fOption("JOBM331", .f.,"oTBitmap13:Load(NIL, cFileNOK)")) },,.F.,.F.,,,.F.,,.T.,,.F.)
   oTBitmap13:lAutoSize := .T.                                                                                                                           

   oTBitmap14 := TBitmap():New(128,01,100,50,,cFileNOK,.T.,oWin2, {|| IIF(oTBitmap14:cBmpFile==cFileNOK, fOption("JOBM280",.t.,"oTBitmap14:Load(NIL, cFileOK)") ,  fOption("JOBM280", .f.,"oTBitmap14:Load(NIL, cFileNOK)")) },,.F.,.F.,,,.F.,,.T.,,.F.)
   oTBitmap14:lAutoSize := .T.                                                                                                                           
                                                               
	oSayMemo       := TSay():New(01,01,{||cCabecalho},oWin3,,oFMemo,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)                                                                
   oMemo1         := TMultiGet():New(10,01,{|u|if(Pcount()>0,cTxtMemo1:=u,cTxtMemo1)},oWin3, 325, 162,oFMemo,.F., NIL, NIL, NIL,.T., NIL,.F.,{||.T.}, .F.,.F., NIL, NIL,{||}, .F., NIL, NIL)
   
 	oGet2:SetFocus()
 	
 	lOpt := .t. 
	                                    

	//GETDADOS INICIO
	cGetOpc        := Nil                              // GD_INSERT+GD_DELETE+GD_UPDATE
	cLinhaOk       := AllwaysTrue()                    // Funcao executada para validar o contexto da linha atual do aCols
	cTudoOk        := AllwaysTrue()                    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
	cIniCpos       := Nil                              // Nome dos campos do tipo caracter que utilizarao incremento automatico.
	nFreeze        := Nil                              // Campos estaticos na GetDados.
	nMax           := 999                              // Numero maximo de linhas permitidas. Valor padrao 99
	cCampoOk       := Nil                              // Funcao executada na validacao do campo
	cSuperApagar   := Nil                              // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
	cApagaOk       := "U_CadYYYDel"                    // Funcao executada para validar a exclusao de uma linha do aCols
	aHeader        := {}                               // Array do aHeader
	aCols          := {}                               // Array do aCols

	aHeader := {}
	//             X3_TITULO          , X3_CAMPO  , X3_PICTURE        ,X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT

	aadd(aHeader, {""     			 , "LEGENDA"   , "@BMP"             , 01       , 0         ,""       , ""      , "C"    , ""        ,,})
	aadd(aHeader, {"Rotina"        , "DESCRI"    , "@!"               , 30       , 0         ,""       , ""      , "C"    , ""        ,,})
	aadd(aHeader, {"Periodo"       , "PERIOD"    , "@!"               , 6        , 0         ,""       , ""      , "C"    , ""        ,,})
	aadd(aHeader, {"Usuario"       , "USUARIO"   , "@!"               , 15       , 0         ,""       , ""      , "C"    , ""        ,,})
	aadd(aHeader, {"Data"          , "DATA"      , "@!"               , 10       , 0         ,""       , ""      , "C"    , ""        ,,})
	aadd(aHeader, {"Hora"          , "HORA"      , "@!"               , 08       , 0         ,""       , ""      , "C"    , ""        ,,})
	aadd(aHeader, {"Interno"       , "RECNO"     , "@E"               , 01       , 0         ,""       , ""      , "C"    , ""        ,,})
          


	aAdd(aCols,Array(Len(aHeader)+1))
	aCols[Len(aCols),Len(aHeader)+1] := .F.

	//Execuï¿½ï¿½o das rotinas
	oGetDados := MsNewGetDados():New(01,15,180,330,cGetOpc,cLinhaOk,cTudoOk,cIniCpos,,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oWin2,aHeader,aCols)

	SaveProjet   := aClone(oGetDados:aCols)

	oGetDados:oBrowse:bChange := { |nIndo| fMudaLinha(oGetDados,oGetDados:oBrowse:nat,nIndo) }

	fGetdados()

		
ACTIVATE MSDIALOG oDlg CENTERED
                                            

Return Nil            

Static Function fMudaLinha(oGetDados,nEstou,nIndo)   
Local nPosition 
naCols := oGetDados:oBrowse:nat     
nPosition := IIF(TYPE("oGetDados:aCols[naCols,7]")=="N",oGetDados:aCols[naCols,7],VAL(oGetDados:aCols[naCols,7]))
DbSelectArea("ZZB")   
//If ZZB->(RECNO()) <> nPosition 
	ZZB->( DBGOTO( nPosition   ) ) //.and. !Empty(cCodOS)
		If alltrim(ZZB->ZZB_ROTINA)=="ESTNEG"
			cCabecalho:= " |Produto        |Data    |AM|Qtd. Negativa   |" 
		ElseIf alltrim(ZZB->ZZB_ROTINA)=="RECURSIVIDADE"
	  		cCabecalho:= " | Componente    |AM|Mov|DT Emiss|OP        |Produto OP      |"    
	 	ElseIf alltrim(ZZB->ZZB_ROTINA)=="PRXRE"
	  		cCabecalho:= " |OP         |Produto        |CF |NumSeq|" 
	   ElseIf alltrim(ZZB->ZZB_ROTINA)=="VALCUS"
	  		cCabecalho:= " |Produto        |TM      |AM|Valor           |" 	  
	   ElseIf alltrim(ZZB->ZZB_ROTINA)=="CORDIFCU"
	  		cCabecalho:= " |Produto        |TM      |AM|Valor           |" 	  	 	   
	   ElseIf alltrim(ZZB->ZZB_ROTINA)=="SLDINICI"	   	
	  		cCabecalho:= " |Produto        |AM|Saldo SB9       |Saldo SBJ       |Saldo SBK       |"
	  	ElseIf alltrim(ZZB->ZZB_ROTINA)=="SLDLTEND"     
	  	   cCabecalho:= " |Produto        |AM|Lote      |Saldo SBJ       |Saldo SBK       |"
	  	ElseIf alltrim(ZZB->ZZB_ROTINA)=="JOBM330"     
	  	   cCabecalho:= " |Log de execucao (CV8) da rotina de Custo Medio (MATA330)                  |" 
	  	ElseIf alltrim(ZZB->ZZB_ROTINA)=="JOBM331"     
	  	   cCabecalho:= " |Log de execucao (CV8) da rotina de Contabilizacao do Custo Medio (MATA331)|" 
	  	ElseIf alltrim(ZZB->ZZB_ROTINA)=="JOBM280"     
	  	   cCabecalho:= " |Log de execucao (CV8) da rotina de virada de saldos (MATA280)             |" 	
		ElseIf alltrim(ZZB->ZZB_ROTINA)=="SEQCALC"
	  		cCabecalho:= " |Emissao    |Produto        |CF |NumSeq|" 
	  	ElseIf alltrim(ZZB->ZZB_ROTINA)=="PROXREQ"
	  		cCabecalho:= " |OP         |Valor PR        |Custo RE        |Diferenca PR-RE |" 	  			
		ElseIf alltrim(ZZB->ZZB_ROTINA)=="ACERTASB9"
	  		cCabecalho:= " |OP         |Valor PR        |Custo RE        |Diferenca PR-RE |" 	  					
		ElseIf alltrim(ZZB->ZZB_ROTINA)=="SEMMOVB9"
	  		cCabecalho:= " |Produto        |Data    |AM|Custo Medio CM1 |"   						
		EndIf	              
		
		If Empty(ZZB->ZZB_LOG)
			cTxtMemo1 := ''
		Else
			cTxtMemo1 := ZZB->ZZB_LOG
		EndIf 	
//EndIf
/*                             
DbSelectArea("ZZB")
If ZZB->( DBGOTO(  oGetDados:aCols[naCols,3] ) ) //.and. !Empty(cCodOS)
	If Empty(ZZB->ZZB_LOG)
		cTxtMemo1 := ''
	Else
		cTxtMemo1 := Empty(ZZB->ZZB_LOG)
	EndIf                                      
	ZZB->(DbCloseArea())
  	oMemo1:Refresh()  
//	CONOUT("JONAS")
EndIf
  */        

oSayMemo:Refresh()  
oMemo1:Refresh()  
SaveTexto  := cTxtMemo1
SaveProjet := aClone(oGetDados:aCols)

Return

Static function fGetdados()
local cQuery := ""

cQuery += "  SELECT * FROM " + RetSqlName("ZZB") + " (NOLOCK) WHERE D_E_L_E_T_='' AND ZZB_PERIOD='"+cPerAtu+"' AND ZZB_FILIAL='"+xFilial("ZZB")+"' ORDER BY ZZB_PERIOD, SEQPROC "  

If Select("QUERYLT") <> 0
	QUERYLT->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYLT"


QUERYLT->(dbgotop())
oGetDados:aCols := {}


While !QUERYLT->( EOF() )
	
	aAdd(oGetDados:aCols,Array(Len(aHeader)+1))
	oGetDados:aCols[Len(oGetDados:aCols),1] :=  IIf(EMPTY(QUERYLT->ZZB_STATUS) ,"BR_CINZA",IF (QUERYLT->ZZB_STATUS=="F","BR_VERDE", "BR_VERMELHO"))
	oGetDados:aCols[Len(oGetDados:aCols),2] :=  SUBSTR(QUERYLT->ZZB_DESCRI,1,30)
	oGetDados:aCols[Len(oGetDados:aCols),3] :=  QUERYLT->ZZB_PERIOD
	oGetDados:aCols[Len(oGetDados:aCols),4] :=  QUERYLT->ZZB_USUARI
	oGetDados:aCols[Len(oGetDados:aCols),5] :=  DTOC(STOD(QUERYLT->ZZB_DATA))
	oGetDados:aCols[Len(oGetDados:aCols),6] :=  QUERYLT->ZZB_HORA
	oGetDados:aCols[Len(oGetDados:aCols),7] :=  QUERYLT->R_E_C_N_O_
	oGetDados:aCols[Len(oGetDados:aCols),Len(aHeader)+1] := .F.
	oGetDados:Refresh()
	QUERYLT->( dbSkip() )

Enddo

QUERYLT->(dbCloseArea())

return 

Static Function EstNeg()
Local cQuery 

cLogCus := "Log de Analise de produtos com saldo de estoque negativo"+ENTER

cQuery := " SELECT PROD, EMI, LOC, round(B9_QINI+QTDSUB+QTDSUM,2)  AS QTDATU FROM "
cQuery += " ( "
cQuery += " SELECT LINHA, PROD, EMI, LOC, D3_QUANT, ( CASE WHEN B9_QINI IS NULL THEN 0 ELSE B9_QINI END) AS B9_QINI, (CASE WHEN QTDSUM IS NULL THEN 0 ELSE QTDSUM END) AS QTDSUM, (CASE WHEN QTDSUB IS NULL THEN 0 ELSE QTDSUB END) AS QTDSUB "
cQuery += " FROM "
cQuery += " ( "
cQuery += " SELECT *, "
//INICIO QTDSUM QUERY COM PARAMETROS DO SELECT 1 --FILTRANDO UM CAMPO QTDSUM COM PARAMETROS DA QUERY INICIAL
cQuery += " ( "
cQuery += " SELECT   SUM(D3_QUANT) AS D3_QUANT FROM "
cQuery += " ( "
cQuery += " SELECT D3_COD,D3_EMISSAO, D3_LOCAL, SUM(D3_QUANT) AS D3_QUANT FROM ( "
cQuery += " SELECT D3_COD, D3_EMISSAO, D3_LOCAL, SUM(D3_QUANT) AS D3_QUANT "
cQuery += " FROM SB1010       (NOLOCK) AS SB1 "
cQuery += " LEFT JOIN SD3010 (NOLOCK) AS SD3 ON B1_COD=D3_COD AND D3_EMISSAO BETWEEN '"+DTOS(dGet1)+"' AND '"+DTOS(dGet2)+"'  AND SB1.D_E_L_E_T_='' AND B1_FILIAL='"+xFilial("SB1")+"' "
cQuery += " WHERE D3_ESTORNO='' AND SD3.D_E_L_E_T_='' AND D3_FILIAL='"+xFilial("SD3")+"' AND D3_TM<='499' "
cQuery += " AND D3_COD=PROD  AND D3_LOCAL=LOC AND D3_EMISSAO<=EMI "
cQuery += " GROUP BY D3_COD, D3_EMISSAO, D3_TM, D3_LOCAL "
cQuery += " UNION ALL "
cQuery += " SELECT D1_COD, D1_DTDIGIT, D1_LOCAL, SUM(CASE WHEN F4_ESTOQUE = 'S' THEN D1_QUANT ELSE 0 END ) AS D3_QUANT  "
cQuery += " FROM SB1010       (NOLOCK) AS SB1 "
cQuery += " LEFT JOIN SD1010 (NOLOCK) AS SD1 ON B1_COD=D1_COD AND D1_DTDIGIT BETWEEN '"+DTOS(dGet1)+"' AND '"+DTOS(dGet2)+"'  AND SB1.D_E_L_E_T_='' AND B1_FILIAL='"+xFilial("SB1")+"' "
cQuery += " LEFT JOIN SF4010 (NOLOCK) AS SF4 ON D1_TES=F4_CODIGO AND SF4.D_E_L_E_T_='' "//AND F4_ESTOQUE='S' "
cQuery += " WHERE  SD1.D_E_L_E_T_='' AND D1_FILIAL='"+xFilial("SD1")+"' "
cQuery += " AND D1_COD=PROD  AND D1_LOCAL=LOC AND D1_DTDIGIT<=EMI AND D1_TES<='499' "
cQuery += " GROUP BY D1_COD, D1_DTDIGIT,  D1_LOCAL "
cQuery += " UNION ALL "
cQuery += " SELECT D2_COD, D2_EMISSAO, D2_LOCAL, SUM(CASE WHEN F4_ESTOQUE = 'S' THEN D2_QUANT ELSE 0 END ) AS D3_QUANT   "
cQuery += " FROM SB1010       (NOLOCK) AS SB1 "
cQuery += " LEFT JOIN SD2010 (NOLOCK) AS SD2 ON B1_COD=D2_COD AND D2_EMISSAO BETWEEN '"+DTOS(dGet1)+"' AND '"+DTOS(dGet2)+"'  AND SB1.D_E_L_E_T_='' AND B1_FILIAL='"+xFilial("SB1")+"' "
cQuery += " LEFT JOIN SF4010 (NOLOCK) AS SF4 ON D2_TES=F4_CODIGO AND SF4.D_E_L_E_T_=''"//AND F4_ESTOQUE='S' "
cQuery += " WHERE  SD2.D_E_L_E_T_='' AND D2_FILIAL='"+xFilial("SD2")+"' "
cQuery += " AND D2_COD=PROD  AND D2_LOCAL=LOC AND D2_EMISSAO<=EMI AND D2_TES<='499' "
cQuery += " GROUP BY D2_COD, D2_EMISSAO,  D2_LOCAL "

cQuery += " ) AS SOM GROUP BY D3_COD,D3_EMISSAO, D3_LOCAL "

cQuery += " ) AS MOV "

cQuery += " ) AS QTDSUM, "
//FIM QTDSUM

//INICIO QTDNEG QUERY COM PARAMETROS DO SELECT 1 --FILTRANDO UM CAMPO QTDNEG COM PARAMETROS DA QUERY INICIAL
cQuery += " ( "

cQuery += " SELECT   SUM(D3_QUANT) AS D3_QUANT FROM "
cQuery += " ( "

cQuery += " SELECT D3_COD,D3_EMISSAO, D3_LOCAL, SUM(D3_QUANT) AS D3_QUANT FROM ( "

cQuery += " SELECT D3_COD, D3_EMISSAO, D3_LOCAL, SUM(D3_QUANT) AS D3_QUANT  "
cQuery += " FROM SB1010       (NOLOCK) AS SB1 "
cQuery += " LEFT JOIN SD3010 (NOLOCK) AS SD3 ON B1_COD=D3_COD AND D3_EMISSAO BETWEEN '"+DTOS(dGet1)+"' AND '"+DTOS(dGet2)+"'  AND SB1.D_E_L_E_T_='' AND B1_FILIAL='"+xFilial("SB1")+"' "

cQuery += " WHERE D3_ESTORNO='' AND SD3.D_E_L_E_T_='' AND D3_FILIAL='"+xFilial("SD3")+"' AND D3_TM>'499' "
cQuery += " AND D3_COD=PROD  AND D3_LOCAL=LOC AND D3_EMISSAO<=EMI "

cQuery += " GROUP BY D3_COD, D3_EMISSAO, D3_TM, D3_LOCAL "

cQuery += " UNION ALL "

cQuery += " SELECT D1_COD, D1_DTDIGIT, D1_LOCAL, SUM(CASE WHEN F4_ESTOQUE = 'S' THEN D1_QUANT ELSE 0 END ) AS D3_QUANT    "
cQuery += " FROM SB1010       (NOLOCK) AS SB1 "
cQuery += " LEFT JOIN SD1010 (NOLOCK) AS SD1 ON B1_COD=D1_COD AND D1_DTDIGIT BETWEEN '"+DTOS(dGet1)+"' AND '"+DTOS(dGet2)+"'  AND SB1.D_E_L_E_T_='' AND B1_FILIAL='"+xFilial("SB1")+"' "
cQuery += " LEFT JOIN SF4010 (NOLOCK) AS SF4 ON D1_TES=F4_CODIGO AND SF4.D_E_L_E_T_='' "//AND F4_ESTOQUE='S' "
cQuery += " WHERE  SD1.D_E_L_E_T_='' AND D1_FILIAL='"+xFilial("SD1")+"'  "
cQuery += " AND D1_COD=PROD  AND D1_LOCAL=LOC AND D1_DTDIGIT<=EMI AND D1_TES>'499' "
cQuery += " GROUP BY D1_COD, D1_DTDIGIT,  D1_LOCAL "


cQuery += " UNION ALL "

cQuery += " SELECT D2_COD, D2_EMISSAO, D2_LOCAL, SUM(CASE WHEN F4_ESTOQUE = 'S' THEN D2_QUANT ELSE 0 END ) AS D3_QUANT    "
cQuery += " FROM SB1010       (NOLOCK) AS SB1 "
cQuery += " LEFT JOIN SD2010 (NOLOCK) AS SD2 ON B1_COD=D2_COD AND D2_EMISSAO BETWEEN '"+DTOS(dGet1)+"' AND '"+DTOS(dGet2)+"'  AND SB1.D_E_L_E_T_='' AND B1_FILIAL='"+xFilial("SB1")+"' "
cQuery += " LEFT JOIN SF4010 (NOLOCK) AS SF4 ON D2_TES=F4_CODIGO AND SF4.D_E_L_E_T_='' " //--AND F4_ESTOQUE='S' "
cQuery += " WHERE  SD2.D_E_L_E_T_='' AND D2_FILIAL='"+xFilial("SD2")+"'  "
cQuery += " AND D2_COD=PROD  AND D2_LOCAL=LOC AND D2_EMISSAO<=EMI AND D2_TES>'499' "
cQuery += " GROUP BY D2_COD, D2_EMISSAO,  D2_LOCAL "
cQuery += " ) AS NEG GROUP BY D3_COD,D3_EMISSAO, D3_LOCAL "
cQuery += " ) AS MOV "
cQuery += " )*-1 AS QTDSUB "
//FIM

cQuery += " FROM ( "
cQuery += " SELECT ROW_NUMBER() OVER(ORDER BY D3_COD, D3_LOCAL, D3_EMISSAO) AS LINHA, D3_COD AS PROD, D3_EMISSAO AS EMI, "
cQuery += " D3_LOCAL AS LOC, SUM(D3_QUANT) AS D3_QUANT FROM "
cQuery += " ( "
cQuery += " SELECT D3_COD, D3_EMISSAO, D3_LOCAL,SUM(D3_QUANT) AS D3_QUANT  "
cQuery += " FROM SB1010       (NOLOCK) AS SB1 "
cQuery += " LEFT JOIN SD3010  (NOLOCK) AS SD3 ON B1_COD=D3_COD AND D3_EMISSAO  BETWEEN '"+DTOS(dGet1)+"' AND '"+DTOS(dGet2)+"'  AND SB1.D_E_L_E_T_='' AND B1_FILIAL='"+xFilial("SB1")+"' "
cQuery += " LEFT JOIN SD2010  (NOLOCK) AS SD2 ON B1_COD=D2_COD AND D2_EMISSAO BETWEEN '"+DTOS(dGet1)+"' AND '"+DTOS(dGet2)+"'  AND SB1.D_E_L_E_T_='' AND B1_FILIAL='"+xFilial("SB1")+"' "
cQuery += " LEFT JOIN SD1010  (NOLOCK) AS SD1 ON B1_COD=D1_COD AND D1_DTDIGIT BETWEEN '"+DTOS(dGet1)+"' AND '"+DTOS(dGet2)+"'  AND SB1.D_E_L_E_T_='' AND B1_FILIAL='"+xFilial("SB1")+"' "
cQuery += " LEFT JOIN SF4010  (NOLOCK) AS SF4 ON D2_TES=SF4.F4_CODIGO AND SF4.F4_ESTOQUE='S' "
cQuery += " LEFT JOIN SF4010  (NOLOCK) AS SFB ON D1_TES=SFB.F4_CODIGO AND SFB.F4_ESTOQUE='S' "
cQuery += " WHERE D3_ESTORNO='' AND SD3.D_E_L_E_T_='' AND D3_FILIAL='"+xFilial("SD3")+"' "
cQuery += " GROUP BY D3_COD, D3_EMISSAO, D3_TM, D3_LOCAL "

cQuery += " ) AS MOV  "
cQuery += " GROUP BY D3_COD, D3_EMISSAO, D3_LOCAL "

cQuery += " ) AS TOT "

cQuery += " ) AS AJUSTE "
cQuery += " LEFT JOIN SB9010 (NOLOCK) AS SB9 ON B9_COD=PROD AND B9_DATA= '"+DTOS(dMvUlmes)+"' AND B9_LOCAL=LOC AND SB9.D_E_L_E_T_=''AND B9_FILIAL='"+xFilial("SB9")+"' "

cQuery += " ) AS RESULTADO "
cQuery += " WHERE round(B9_QINI+QTDSUB+QTDSUM,2)  < 0 "       
cQuery += " ORDER BY PROD, LOC, EMI "

If Select("NEG") <> 0
	NEG->( dbCloseArea() )
EndIf
                                                                                                         
TCQUERY cQuery NEW ALIAS "NEG"

While	NEG->(!EOF())                   
	If SB1->(DBSEEK(xFilial("SB1")+NEG->PROD))
		If SB1->B1_TIPO=="MO" 
			NEG->( DbSkip() )
			loop						
		EndIf
	EndIf
	
	If !lLog
		cLogCus += "Foram encontrados itens com divegencia: "	+ ENTER     
		cLogCus += "+---------------+--------+--+----------------+" + ENTER  
	EndIf 
	cLogCus += '|' +NEG->PROD+ '|' +DTOC(STOD(NEG->EMI))+ '|' + NEG->LOC+ '|' +  TRANSFORM(NEG->QTDATU, "@E 9,999,999,999.99")  + '|' + ENTER
	lLog	:= .t.
	NEG->( DbSkip() )
Enddo

If !lLog
	cLogCus += "Nao foram encontrados itens NEGATIVOS "	+ ENTER
Else
	cLogCus += "+---------------+--------+--+----------------+" + ENTER  
EndIf

//Sleep( 10000 )

Return                                                                     
          
//Verifica recursividade para execuï¿½ï¿½o do custo medio, rotina original MATR331
Static Function RECUR001()
//Local oSection1	:= oReport:Section(1) 
Local cAliasSD3	:= "SD3"
Local cArqTemp		:= "" 
Local aArqTemp		:= {}
Local nx				:= 0
Local nRegSD3		:= 0
Local aListaReg	:= {}
Local lRet			:= .T.
Local lImp			:= .F. // Indica se algo foi impresso
Local oTempTable 	:= NIL                                  


cLogCus := "Log de Analise de Recursividade"+ENTER
                                        

// Montagem do arquivo de trabalho
AADD(aArqTemp,{"CODIGO"		   ,"C",Len(SB1->B1_COD),0})
AADD(aArqTemp,{"COMPONENTE"	,"C",Len(SB1->B1_COD),0})
AADD(aArqTemp,{"OP"				,"C",Len(SD3->D3_OP),0})
AADD(aArqTemp,{"ARMAZEM"		,"C",Len(SD3->D3_LOCAL),0})
AADD(aArqTemp,{"MOVIMENTO"		,"C",Len(SD3->D3_TM),0})
AADD(aArqTemp,{"EMISSAO"		,"D",8,0})
AADD(aArqTemp,{"DOCUMENTO"		,"C",Len(SD3->D3_DOC),0})
AADD(aArqTemp,{"REGISTRO"		,"N",20,0})
AADD(aArqTemp,{"G1NIVEL"		,"C",2,0})
AADD(aArqTemp,{"G1NIVINV"		,"C",2,0})

cArqTemp := GetNextAlias()

oTempTable := FWTemporaryTable():New( cArqTemp )
oTempTable:SetFields( aArqTemp )
oTempTable:AddIndex("indice1", {"CODIGO","COMPONENTE","OP"} )
oTempTable:Create()

// Leitura para gravacao de dados no arquivo de trabalho
dbSelectArea("SC2")
dbSetOrder(1)

//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
//ï¿½Filtragem do relatï¿½rio                                                  ï¿½
//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½

//MakeSqlExpr(oReport:uParam)

cAliasSD3 := GetNextAlias()
//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
//ï¿½Query do relatï¿½rio da secao 1                                           ï¿½
//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
//oReport:Section(1):BeginQuery()	

BeginSql Alias cAliasSD3

	SELECT D3_FILIAL,D3_OP,D3_LOCAL,D3_TM,D3_DOC,D3_COD,D3_EMISSAO,SD3.R_E_C_N_O_ SD3RECNO

	FROM %table:SD3% SD3			

	WHERE	D3_FILIAL   = %xFilial:SD3% AND
			D3_ESTORNO <> 'S' AND
			D3_OP      <> 	'' AND
			D3_CF      <> 'PR0' AND D3_CF <> 'PR1' AND
			D3_EMISSAO >= %Exp:Dtos(dGet1)% AND D3_EMISSAO  <= %Exp:Dtos(dGet2)%  AND 
			SD3.%NotDel% 
			
	ORDER BY D3_FILIAL,D3_OP,D3_COD,D3_EMISSAO

EndSql 
//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
//ï¿½Metodo EndQuery ( Classe TRSection )                                    ï¿½
//ï¿½                                                                        ï¿½
//ï¿½Prepara o relatï¿½rio para executar o Embedded SQL.                       ï¿½
//ï¿½                                                                        ï¿½
//ï¿½ExpA1 : Array com os parametros do tipo Range                           ï¿½
//ï¿½                                                                        ï¿½
//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
//oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
	

//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
//ï¿½Inicio da impressao do fluxo do relatorio                               ï¿½
//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½

dbSelectArea(cAliasSD3)
//oReport:SetMeter(SD3->(LastRec()))

// Grava no arquivo de trabalho
While !(cAliasSD3)->(Eof())
	// Movimenta regua
	//oReport:IncMeter()
	nRegSD3:= (cAliasSD3)->SD3RECNO
	// Posiciona na ordem de producao
	If SC2->(dbSeek(xFilial("SC2")+(cAliasSD3)->D3_OP))
		// Grava relacionamento no arquivo de trabalho
		dbSelectArea(cArqTemp)
		If !dbSeek(SC2->C2_PRODUTO+(cAliasSD3)->D3_COD+(cAliasSD3)->D3_OP)
			RecLock(cArqTemp,.T.)
			Replace CODIGO		With SC2->C2_PRODUTO
			Replace COMPONENTE  With (cAliasSD3)->D3_COD
			Replace OP			With (cAliasSD3)->D3_OP
			Replace ARMAZEM     With (cAliasSD3)->D3_LOCAL
			Replace MOVIMENTO   With (cAliasSD3)->D3_TM 
			Replace EMISSAO     With STOD((cAliasSD3)->D3_EMISSAO)
			Replace DOCUMENTO   With (cAliasSD3)->D3_DOC 
			Replace REGISTRO    With nRegSD3
			Replace G1NIVEL     With "01"
			Replace G1NIVINV    With "99"
			MsUnLock()
		EndIf
	EndIf
	dbSelectArea(cAliasSD3)
	dbSkip()
End

// Varre com recursividade o arquivo de trabalho
dbSelectArea(cArqTemp)
//oReport:SetMeter(SD3->(LastRec()))
dbGotop()

//oSection1:Init()

While (cArqTemp)->(!Eof())
	// Movimenta regua
	//oReport:IncMeter()
	// Checa recursividade
	IF G1NIVEL == "01"
		aListaReg:={}
		lRet := MR331Nivel(COMPONENTE,G1NIVEL,cArqTemp,aListaReg)
		IF !lRet
			nRegSD3:=Recno()
			// Imprime caso exista problema
			For nx:=1 to Len(aListaReg)
				// Checa impressao do separador
				//If nx == 1 .And. lImp
            	//	oReport:ThinLine()
				//EndIf
				// Posiciona o registro
				(cArqTemp)->(dbGoto(aListaReg[nx]))			
				// Imprime a informacao desejada
				cLogCus += ENTER
				If !lLog
					cLogCus += "Corrija o movimento que gerou recursividade" + ENTER
					cLogCus += "+---------------+--+---+--------+----------+----------------+" + ENTER  
				EndIf
				cLogCus += "|"+COMPONENTE+"|"+ARMAZEM+"|"+MOVIMENTO+"|"+DTOC(EMISSAO)+"|"+SUBSTR(OP,1,11)+"|"+CODIGO+"|"+ ENTER
//							  "| Componente     |AM|Mov|DT Emiss|OP        |Produto OP      |"
				lLog    := .t.
				//oSection1:Cell("D3_COD"):SetValue(COMPONENTE)
				//oSection1:Cell("D3_LOCAL"):SetValue(ARMAZEM)
				//oSection1:Cell("D3_TM"):SetValue(MOVIMENTO)
				//oSection1:Cell("D3_DOC"):SetValue(DOCUMENTO)
				//oSection1:Cell("D3_EMISSAO"):SetValue(EMISSAO)
				//oSection1:Cell("D3_OP"):SetValue(OP)
				//oSection1:Cell("C2_PRODUTO"):SetValue(CODIGO)
				//oSection1:PrintLine()			
				lImp := .T.
			Next                                                               
			If !lLog
				cLogCus += "Nao foi encontrado movimento de producao com recursividade" + ENTER
			Else
				cLogCus += "+---------------+--+---+--------+----------+----------------+" + ENTER  
			EndIF
			dbGoto(nRegSD3)
		Endif
	EndIf
	dbSkip()
Enddo
//oSection1:Finish()			

//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
//ï¿½ Apaga Arquivos temporarios                                   ï¿½
//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
oTempTable:Delete()

Return NIL
/*
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿ï¿½ï¿½
ï¿½ï¿½ï¿½Funï¿½ï¿½o    ï¿½MR331Nivelï¿½ Autor ï¿½Rodrigo de A Sartorio  ï¿½ Data ï¿½ 25/04/06 ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä´ï¿½ï¿½
ï¿½ï¿½ï¿½Descriï¿½ï¿½o ï¿½ Acerta os niveis das estruturas no temporario              ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä´ï¿½ï¿½
ï¿½ï¿½ï¿½ Uso      ï¿½ MATR331                                                    ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ù±ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
*/
Static Function MR331Nivel(cComp,cNivel,cAliasPr,aListaReg)
Local nRec   := Recno()
Local nSalRec:= 0
Local lRet   := .T.
Local lEof   := .F.
Local nAcho  := 0
Local cSeek  := ""

If dbSeek(cComp)
	While !Eof() .and. cComp==CODIGO
		nSalRec:=Recno()
		cSeek  := COMPONENTE
		dbSeek(cSeek)	
		lEof := Eof()
		dbGoto(nSalRec)

		IF Val(cNivel) >= 98  // Testa Erro de estrutura
			lRet := .F.
		Endif

		If Val(cNivel)+1 > Val(G1NIVEL) .and. lRet
			RecLock(cAliasPr,.F.)
			Replace G1NIVEL  With Strzero(Val(cNivel)+1,2)
			Replace G1NIVINV With Strzero(100-Val(G1NIVEL),2,0)
			MsUnLock()
			If !lEof
				lRet := MR331NIVEL(COMPONENTE,G1NIVEL,cAliasPr,aListaReg)
			Endif
		Endif	
		IF !lRet
			IF Val(cNivel) < 98  // Houve erro (no nivel posterior)
				nAcho  := ASCAN(aListaReg,nSalRec)
				// Adiciona, na lista, o registro que originou o erro
				If nAcho == 0
					AADD(aListaReg,nSalRec)
				EndIf
			EndIf		
			Exit
		Endif
		dbSkip()
	End
EndIf
(cAliasPr)->(dbGoto(nRec))
Return(lRet)          

                                             
//Rotina de validaï¿½ï¿½o saldo lotes x enderecos (iniciais)
//Rotina de validaï¿½ï¿½o de SALDOS INICIAIS
Static Function SLDLTEND()   
Local cQuery := ""
//QUERY LOTE X ENDERECO
cQuery := " SELECT CODIGO, ARM, LOTE, QTDBJ, QTDBK FROM "
cQuery += " ( "
cQuery += " SELECT CODIGO, ARM, LOTE "
cQuery += " ,ROUND((SELECT SUM(BJ_QINI) FROM SBJ010 (NOLOCK) WHERE BJ_FILIAL='"+xFilial("SBJ")+"' AND BJ_LOTECTL=LOTE AND BJ_COD = CODIGO AND BJ_LOCAL = ARM AND BJ_DATA = '"+DTOS(dMvUlmes)+"' AND D_E_L_E_T_=''),4) AS QTDBJ "
cQuery += " ,ROUND((SELECT SUM(BK_QINI) FROM SBK010 (NOLOCK) WHERE BK_FILIAL='"+xFilial("SBK")+"' AND BK_LOTECTL=LOTE AND BK_COD = CODIGO AND BK_LOCAL = ARM AND BK_DATA = '"+DTOS(dMvUlmes)+"' AND D_E_L_E_T_=''),4) AS QTDBK "
cQuery += " FROM "
cQuery += " (  "
cQuery += " SELECT BJ_COD AS CODIGO , BJ_LOCAL AS ARM, BJ_LOTECTL AS LOTE FROM SBJ010 (NOLOCK) WHERE BJ_FILIAL='"+xFilial("SBJ")+"' AND BJ_DATA = '"+DTOS(dMvUlmes)+"' AND D_E_L_E_T_ = '' "
cQuery += " UNION "
cQuery += " SELECT BK_COD AS CODIGO, BK_LOCAL  AS ARM, BK_LOTECTL AS LOTE FROM SBK010 (NOLOCK) WHERE BK_FILIAL='"+xFilial("SBK")+"' AND BK_DATA = '"+DTOS(dMvUlmes)+"' AND D_E_L_E_T_ = '' "
cQuery += " ) TMP "
cQuery += " ) TMP2 "
cQuery += " WHERE QTDBJ <> QTDBK "
cQuery += " ORDER BY ARM, CODIGO "

If Select("SLDINILT") <> 0
	SLDINILT->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "SLDINILT"

While	SLDINILT->(!EOF())      
	If !lLog
		cLogCus += "Foram encontrados itens com divegencia: "	+ ENTER     
		cLogCus += "+---------------+--+----------+----------------+----------------+"+ ENTER    
	EndIf
	cLogCus += '|' +SLDINILT->CODIGO+ '|' +SLDINILT->ARM+ '|' + (SLDINILT->LOTE) + '|' + TRANSFORM(SLDINILT->QTDBJ, "@E 9,999,999,999.99") + '|' + TRANSFORM(SLDINILT->QTDBK, "@E 9,999,999,999.99") + '|' +  ENTER 
	lLog	:= .t.
	SLDINILT->( DbSkip() )
Enddo

If !lLog
	cLogCus += "Nao foram encontrados itens com divergencia "	+ ENTER                     
Else
	cLogCus += "+---------------+--+----------+----------------+----------------+" + ENTER    
EndIf

Return

//Rotina de validaï¿½ï¿½o de SALDOS INICIAIS
Static Function SLDINICI()   
Local cQuery := ""


//Quey ARMAZEM - LOTE - ENDERECO
cQuery += " SELECT CODIGO, ARM, QTDB9, QTDBJ, QTDBK FROM  "
cQuery += " (  "
cQuery += " SELECT CODIGO, ARM  "
cQuery += " ,ROUND((SELECT B9_QINI FROM SB9010 (NOLOCK) WHERE B9_FILIAL='"+xFilial("SB9")+"' AND B9_COD = CODIGO AND B9_LOCAL = ARM AND B9_DATA = '"+DTOS(dMvUlmes)+"' AND D_E_L_E_T_=''),4) AS QTDB9 "
cQuery += " ,ROUND((SELECT SUM(BJ_QINI) FROM SBJ010 (NOLOCK) WHERE BJ_FILIAL='"+xFilial("SBJ")+"' AND BJ_COD = CODIGO AND BJ_LOCAL = ARM AND BJ_DATA = '"+DTOS(dMvUlmes)+"' AND D_E_L_E_T_=''),4) AS QTDBJ "
cQuery += " ,ROUND((SELECT SUM(BK_QINI) FROM SBK010 (NOLOCK) WHERE BK_FILIAL='"+xFilial("SBK")+"' AND  BK_COD = CODIGO AND BK_LOCAL = ARM AND BK_DATA = '"+DTOS(dMvUlmes)+"' AND D_E_L_E_T_=''),4) AS QTDBK "
cQuery += " FROM  "
cQuery += " ( "
cQuery += " SELECT B9_COD AS CODIGO, B9_LOCAL AS ARM FROM SB9010 (NOLOCK) WHERE B9_FILIAL='"+xFilial("SB9")+"' AND B9_DATA = '"+DTOS(dMvUlmes)+"' AND D_E_L_E_T_ = '' "
cQuery += " UNION  "
cQuery += " SELECT BJ_COD AS CODIGO , BJ_LOCAL AS ARM FROM SBJ010 (NOLOCK) WHERE BJ_FILIAL='"+xFilial("SBJ")+"' AND BJ_DATA = '"+DTOS(dMvUlmes)+"' AND D_E_L_E_T_ = '' "
cQuery += " UNION  "
cQuery += " SELECT BK_COD AS CODIGO, BK_LOCAL AS ARM FROM SBK010 (NOLOCK) WHERE BK_FILIAL='"+xFilial("SBK")+"' AND BK_DATA = '"+DTOS(dMvUlmes)+"' AND D_E_L_E_T_ = '' "
cQuery += " ) TMP "
cQuery += " ) TMP2  "
cQuery += " WHERE QTDBJ <> QTDB9 OR QTDBJ <> QTDBK OR QTDB9 <> QTDBK "
cQuery += " ORDER BY ARM, CODIGO "

If Select("SLDINI") <> 0
	SLDINI->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "SLDINI"

While	SLDINI->(!EOF())      
	If !lLog
		cLogCus += "Foram encontrados itens com divegencia: "	+ ENTER
		cLogCus += "+---------------+--+----------------+----------------+----------------+"+ ENTER    
	EndIf
	cLogCus += '|' +SLDINI->CODIGO+ '|' +SLDINI->ARM + '|' + TRANSFORM(SLDINI->QTDB9, "@E 9,999,999,999.99") + '|' + TRANSFORM(SLDINI->QTDBJ, "@E 9,999,999,999.99") + '|' + TRANSFORM(SLDINI->QTDBK, "@E 9,999,999,999.99") + '|' + ENTER
	lLog	:= .t.
	SLDINI->( DbSkip() )
Enddo

If !lLog
	cLogCus += "Nao foram encontrados itens com divergencia "	+ ENTER
Else
	cLogCus += "+---------------+--+----------------+----------------+----------------+"+ ENTER
EndIf

Return
  
//Rotina de validaï¿½ï¿½o de produï¿½ï¿½es x requisicoes
Static Function PRXREVLD()   
local cQuery := ""    
            
//RE SEM PR
cQuery += " SELECT D3_OP, D3_COD, D3_CF, D3_NUMSEQ FROM " + RetSqlName("SD3") + " (NOLOCK) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D_E_L_E_T_=''  "
cQuery += " AND D3_ESTORNO=''  "
cQuery += " AND D3_EMISSAO BETWEEN '"+DTOS(dGet1)+"'  AND '"+DTOS(dGet2)+"'  AND D3_OP<>'' "
cQuery += " AND LEFT(D3_CF,2) = 'RE'  "
cQuery += " AND D3_TM = '999'  "
cQuery += " AND D3_OP NOT IN  "
cQuery += " (SELECT D3_OP FROM " + RetSqlName("SD3") + "  WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D_E_L_E_T_=''  "
cQuery += " AND D3_ESTORNO='' "
cQuery += " AND D3_EMISSAO BETWEEN '"+DTOS(dGet1)+"'  AND '"+DTOS(dGet2)+"'  AND D3_OP<>'' "
cQuery += " AND LEFT(D3_CF,2) = 'PR') "

cQuery += " UNION ALL  "

//PR SEM RE
cQuery += " SELECT D3_OP AS OP, D3_COD, D3_CF, D3_NUMSEQ FROM " + RetSqlName("SD3") + " (NOLOCK) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D_E_L_E_T_=''  "
cQuery += " AND D3_ESTORNO=''  "
cQuery += " AND D3_EMISSAO BETWEEN '"+DTOS(dGet1)+"'  AND '"+DTOS(dGet2)+"'  AND D3_OP<>'' "
cQuery += " AND LEFT(D3_CF,2) = 'PR'   "
cQuery += " AND D3_OP NOT IN  "
cQuery += " (SELECT D3_OP FROM " + RetSqlName("SD3") + " (NOLOCK) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D_E_L_E_T_=''  "
cQuery += " AND D3_ESTORNO=''  "
cQuery += " AND D3_EMISSAO BETWEEN '"+DTOS(dGet1)+"'  AND '"+DTOS(dGet2)+"'  AND D3_OP<>''  "
cQuery += " AND LEFT(D3_CF,2) = 'RE') "

If Select("PRXRE") <> 0
	PRXRE->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "PRXRE"

While	PRXRE->(!EOF())      
	If !lLog
		cLogCus += "Foram encontrados itens com divegencia: "	+ ENTER 
		cLogCus += "+-----------+---------------+---+------+" + ENTER
	EndIf
	cLogCus += '|' +SUBSTR(PRXRE->D3_OP,1,11)+ '|' +PRXRE->D3_COD+ '|' + PRXRE->D3_CF+ '|' + PRXRE->D3_NUMSEQ + '|' + ENTER
	lLog	:= .t.
	PRXRE->( DbSkip() )
Enddo

If !lLog
	cLogCus += "Nao foram encontrados itens com divergencia "	+ ENTER      
Else
	cLogCus += "+-----------+---------------+---+------+" + ENTER  
EndIf

Return     



//Verifica itens sem SEQCALC
Static Function SEQCALC()   
local cQuery := ""    


cQuery += " SELECT TOP(1000) D3_EMISSAO, D3_COD, D3_CF, D3_NUMSEQ FROM " + RetSqlName("SD3") + " (NOLOCK) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D_E_L_E_T_=''  "
cQuery += " AND D3_ESTORNO='' AND D3_SEQCALC=''  "
cQuery += " AND D3_EMISSAO BETWEEN '"+DTOS(dGet1)+"'  AND '"+DTOS(dGet2)+"' "

       
If Select("SEQ") <> 0
	SEQ->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "SEQ"

While	SEQ->(!EOF())      
	If !lLog
		cLogCus += "Foram encontrados itens com divegencia: "	+ ENTER 
		cLogCus += "+----------+---------------+---+------+" + ENTER
	EndIf
	cLogCus += '|' +DTOC(STOD(SEQ->D3_EMISSAO))+ '|' +SEQ->D3_COD+ '|' + SEQ->D3_CF+ '|' + SEQ->D3_NUMSEQ + '|' + ENTER
	lLog	:= .t.
	SEQ->( DbSkip() )
Enddo

If !lLog
	cLogCus += "Nao foram encontrados itens com divergencia "	+ ENTER      
Else
	cLogCus += "+----------+---------------+---+------+" + ENTER  
EndIf

Return


//Verifica itens sem SEQCALC
Static Function PROXREQ()   
local cQuery := ""                            

cQuery += " SELECT OP, CUSTPR, CUSTRE, ROUND(CUSTPR-CUSTRE,2) AS DIF  FROM "
cQuery += " ( "
cQuery += " SELECT D3_OP AS OP,  ROUND(SUM(D3_CUSTO1),2) AS CUSTPR, "
cQuery += " ( "
cQuery += " SELECT ROUND(SUM(D3_CUSTO1),2) "
cQuery += " FROM SD3010 (NOLOCK) AS SD3B WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D_E_L_E_T_='' "
cQuery += " AND D3_OP=SD3A.D3_OP "
cQuery += " AND LEFT(D3_CF,2)='RE' AND D3_ESTORNO<>'S' AND SD3B.D_E_L_E_T_='' "
cQuery += " AND D3_EMISSAO BETWEEN '"+DTOS(dGet1)+"'  AND '"+DTOS(dGet2)+"' "
cQuery += " GROUP BY D3_OP "
cQuery += " ) AS CUSTRE  "
cQuery += " FROM SD3010 (NOLOCK) AS SD3A WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D_E_L_E_T_='' AND D3_NUMSEQ<>'' AND D3_OP<>''  "
cQuery += " AND D3_EMISSAO BETWEEN '"+DTOS(dGet1)+"'  AND '"+DTOS(dGet2)+"' "
cQuery += " AND LEFT(D3_CF,2)='PR' AND D3_ESTORNO<>'S' AND SD3A.D_E_L_E_T_='' "
cQuery += " GROUP BY D3_OP  "
cQuery += " ) AS PRODREQ  "
cQuery += " WHERE CUSTRE<>CUSTPR "     
cQuery += " ORDER BY DIF DESC "
       
If Select("PROXREQ") <> 0
	PROXREQ->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "PROXREQ"

While	PROXREQ->(!EOF())      
	If !lLog
		cLogCus += "Foram encontrados itens com divegencia: "	+ ENTER 
		cLogCus += "+-----------+----------------+----------------+----------------+" + ENTER
	EndIf
	cLogCus += '|' + SUBSTR(PROXREQ->OP,1,11) + '|' + TRANSFORM(PROXREQ->CUSTPR, "@E 9,999,999,999.99") + '|' + TRANSFORM(PROXREQ->CUSTRE, "@E 9,999,999,999.99") + '|' + 	TRANSFORM(PROXREQ->DIF, "@E 9,999,999,999.99") + '|' + ENTER        
	
	lLog	:= .t.
	PROXREQ->( DbSkip() )
Enddo

If !lLog
	cLogCus += "Nao foram encontrados itens com divergencia "	+ ENTER      
Else
	cLogCus += "+-----------+----------------+----------------+----------------+" + ENTER  
EndIf

Return


//Cria vetor com itens que serão executados
Static Function fOption(cTipo,lValid,oBtn)
Local aArea  := GetArea()
Local nPos   := ASCAN(aOptions, {|aVal| aVal[1] == cTipo})                  

If nPos > 0
	If nPos < 14
		If !lValid .and. aOptions[nPos+1][2]== .t.
			MSGINFO("Atenção, há uma atividade posterior selecionada")
			//aOptions[nPos][2] := .t.
			RestArea(aArea)
			Return .f. 
		EndIf
	EndIf
	If nPos > 1
		If aOptions[nPos-1][2] == .f.
			ZZB->( dbGoTo(aOptions[nPos-1][3]) )
			If Empty(ZZB->ZZB_STATUS)   
				If lValid
					MSGINFO("Atenção, é necessario executar primeiro a rotina anterior")
					aOptions[nPos][2] := .f. 
				Else
					aOptions[nPos][2] := lValid 
					&oBtn
				EndIf				
			Else
				aOptions[nPos][2] := lValid 
				&oBtn
			EndIf 
		Else
			aOptions[nPos][2] := lValid
			&oBtn
		EndIf
	Else
		aOptions[nPos][2] := lValid
		&oBtn
	EndIf
	
EndIf    

RestArea(aArea)

Return .t.                                                  
        


//rotina do custo medio
Static Function JOBM330()


//Local lCPParte  := .F.   //-- Define que nï¿½o serï¿½ processado o custo em partes
//Local lBat 		 := .T. 	 //-- Define que a rotina serï¿½ executada em Batch
//Local aListaFil := {}    //-- Carrega Lista com as Filiais a serem processadas
//Local cCodFil   := ''    //-- Cï¿½digo da Filial a ser processada 
//Local cNomFil   := ''    //-- Nome da Filial a ser processada
//Local cCGC      := ''    //-- CGC da filial a ser processada
//Local aParAuto  := {}    //-- Carrega a lista com os 21 parï¿½metros                            
Local cHora     := Time()         
Local dData     := DATE()
Local cQuery    := ''                    
Local aArea     := GetArea()
Local aBkpPerg  := {}

Pergunte("MTA330    ",.F.,,,,,@aBkpPerg)
	
//Altera conteúdo de alguma pergunta	
MV_PAR01  := dGet2            //MV_PAR01 = Data Limite Final     
MV_PAR02  := 2 		          //MV_PAR02 = Mostra lanctos. Contï¿½beis         1 SIM 2 NAO
MV_PAR03  := 2                //MV_PAR03 = Aglutina Lanctos Contï¿½beis   	   1 SIM 2 NAO
MV_PAR04  := 1                //MV_PAR04 = Atualizar Arq. de Movimentos  	   1 SIM 2 NAO
MV_PAR05  := 0                //MV_PAR05 = % de aumento da MOD
MV_PAR06  := 2                //MV_PAR06 = Centro de Custo 					   1 Contabil 2 Extracontabil
MV_PAR07  := "               "//MV_PAR07 = Conta Contï¿½bil a inibir de
MV_PAR08  := "               "//MV_PAR08 = Conta Contï¿½bil a inibir atï¿½
MV_PAR09  := 1		          //MV_PAR09 = Apagar estornos  				   1 SIM 2 NAO
MV_PAR10  := 3                //MV_PAR010 = Gerar Lancto. Contï¿½bil 	       1 SIM 2 NAO 3 MANTEM
MV_PAR11  := 1                //MV_PAR011 = Gerar estrutura pela Moviment      1 SIM 2 NAO
MV_PAR12  := 3                //MV_PAR012 = Contabilizaï¿½ï¿½o On-Line Por     1 CONSUMO 2 PRODUCAO 3 AMBAS
MV_PAR13  := 2                //MV_PAR013 = Calcula mï¿½o-de-Obra   	       1 SIM 2 NAO
MV_PAR14  := 2                //MV_PAR014 = Mï¿½todo de apropriaï¿½ï¿½o        1 SEQUENCIAL 2 MENSAL 3 DIARIA
MV_PAR15  := 2                //MV_PAR015 = Recalcula Nï¿½vel de Estrut        1 SIM 2 NAO
MV_PAR16  := 1                //MV_PAR016 = Mostra sequï¿½ncia de Cï¿½lculo    1 NAO MOSTRAR 2 CUSRO MEDIO 3 FIFO
MV_PAR17  := 2                //MV_PAR017 = Seq Processamento FIFO             1 DATA + SEQUENCIA 2 CUSTO MEDIO
MV_PAR18  := 2                //MV_PAR018 = Mov Internos Valorizados           1 ANTES 2 DEPOIS
MV_PAR19  := 2                //MV_PAR019 = Recï¿½lculo Custo transportes      1 SIM 2 NAO
MV_PAR20  := 2                //MV_PAR020 = Cï¿½lculo de custos por            1 TODAS FILIAIS 2 FILIAL CORRENTE 3 SELECIONA FILIAIS
MV_PAR21  := 2                //MV_PAR021 = Calcular Custo em Partes           1 SIM 2 NAO

SaveMVVars(.T.)

__SaveParam("MTA330    ", aBkpPerg)  

/*
//PARAMETROS PARA EXECUï¿½ï¿½O DO CUSTO MEDIO
AADD(aParAuto, dGet2				  ) //MV_PAR01 = Data Limite Final     
AADD(aParAuto, 2    				  ) //MV_PAR02 = Mostra lanctos. Contï¿½beis    						 1 SIM 2 NAO
AADD(aParAuto, 2                ) //MV_PAR03 = Aglutina Lanctos Contï¿½beis   						 1 SIM 2 NAO
AADD(aParAuto, 1                ) //MV_PAR04 = Atualizar Arq. de Movimentos  						 1 SIM 2 NAO
AADD(aParAuto, 0                ) //MV_PAR05 = % de aumento da MOD
AADD(aParAuto, 2                ) //MV_PAR06 = Centro de Custo 										 1 Contabil 2 Extracontabil
AADD(aParAuto, "               ") //MV_PAR07 = Conta Contï¿½bil a inibir de
AADD(aParAuto, "               ") //MV_PAR08 = Conta Contï¿½bil a inibir atï¿½
AADD(aParAuto, 1				) //MV_PAR09 = Apagar estornos  										 1 SIM 2 NAO
AADD(aParAuto, 3                ) //MV_PAR010 = Gerar Lancto. Contï¿½bil 								 1 SIM 2 NAO 3 MANTEM
AADD(aParAuto, 1                ) //MV_PAR011 = Gerar estrutura pela Moviment 					 1 SIM 2 NAO
AADD(aParAuto, 3                ) //MV_PAR012 = Contabilizaï¿½ï¿½o On-Line Por 						 1 CONSUMO 2 PRODUCAO 3 AMBAS
AADD(aParAuto, 2                ) //MV_PAR013 = Calcula mï¿½o-de-Obra   								 1 SIM 2 NAO
AADD(aParAuto, 2                ) //MV_PAR014 = Mï¿½todo de apropriaï¿½ï¿½o 								 1 SEQUENCIAL 2 MENSAL 3 DIARIA
AADD(aParAuto, 2                ) //MV_PAR015 = Recalcula Nï¿½vel de Estrut  					    1 SIM 2 NAO
AADD(aParAuto, 1                ) //MV_PAR016 = Mostra sequï¿½ncia de Cï¿½lculo 						 1 NAO MOSTRAR 2 CUSRO MEDIO 3 FIFO
AADD(aParAuto, 2                ) //MV_PAR017 = Seq Processamento FIFO                        1 DATA + SEQUENCIA 2 CUSTO MEDIO
AADD(aParAuto, 2                ) //MV_PAR018 = Mov Internos Valorizados                      1 ANTES 2 DEPOIS
AADD(aParAuto, 2                ) //MV_PAR019 = Recï¿½lculo Custo transportes                   1 SIM 2 NAO
AADD(aParAuto, 2                ) //MV_PAR020 = Cï¿½lculo de custos por                         1 TODAS FILIAIS 2 FILIAL CORRENTE 3 SELECIONA FILIAIS
AADD(aParAuto, 2                ) //MV_PAR021 = Calcular Custo em Partes                      1 SIM 2 NAO

//-- Adiciona filial a ser processada
dbSelectArea("SM0")
dbSeek(cEmpAnt)
Do While ! Eof() .And. SM0->M0_CODIGO == cEmpAnt 

	cCodFil := SM0->M0_CODFIL
	cNomFil := SM0->M0_FILIAL
	cCGC    := SM0->M0_CGC

	//-- Somente adiciona a Filial 01 e Filial 02
	If cCodFil == "01"
		//-- Adiciona a filial na lista de filiais a serem processadas
		Aadd(aListaFil,{.T.,cCodFil,cNomFil,cCGC,.F.,})
	EndIf 
	
	dbSkip()
EndDo

//-- Executa a rotina de recï¿½lculo do custo mï¿½dio
MATA330(lBat,aListaFil,lCPParte, aParAuto)
//ConOut("Tï¿½rmino da execuï¿½ï¿½o do JOBM330")        
  */

MATA330()

cQuery += " SELECT * FROM " + RetSqlName("CV8") + " (NOLOCK) WHERE CV8_FILIAL='"+xFilial("CV8")+"' AND D_E_L_E_T_=''  "
cQuery += " AND CV8_DATA>='"+DTOS(dData)+"' AND CV8_HORA>='"+SUBSTR(cHORA,1,5)+"' AND CV8_PROC='MATA330' "


If Select("MTA330") <> 0
	MTA330->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "MTA330"

cLogCus := "|--------+-----+------------------------------------------------------------|" + ENTER
While	MTA330->(!EOF())   
   If len(alltrim(MTA330->CV8_MSG)) > 60
		cLogCus += '|' + MTA330->CV8_DATA + '|' + MTA330->CV8_HORA + '|' + SUBSTR(alltrim(MTA330->CV8_MSG),1, 60) + '|' + ENTER
		cLogCus += '|' + SUBSTR(alltrim(MTA330->CV8_MSG),60,60) + SPACE(75-Len(SUBSTR(alltrim(MTA330->CV8_MSG),60,60))) + '|' + ENTER
	Else
		cLogCus += '|' + MTA330->CV8_DATA + '|' + MTA330->CV8_HORA + '|' + alltrim(MTA330->CV8_MSG)+ SPACE(60-LEN(alltrim(MTA330->CV8_MSG))) + '|' + ENTER
	Endif
	lLog	:= .t.
	MTA330->( DbSkip() )	
Enddo
cLogCus += "|--------+-----+------------------------------------------------------------|" + ENTER

RestArea(aArea)
Return

//rotina de contabilizaï¿½ï¿½o do custo medio
Static Function JOBM331()
//Local lCPParte  := .F.   //-- Define que nï¿½o serï¿½ processado o custo em partes
//Local lBat 		 := .t. 	 //-- Define que a rotina serï¿½ executada em Batch
//Local aListaFil := {}    //-- Carrega Lista com as Filiais a serem processadas
//Local cCodFil   := ''    //-- Cï¿½digo da Filial a ser processada 
//Local cNomFil   := ''    //-- Nome da Filial a ser processada
//Local cCGC      := ''    //-- CGC da filial a ser processada
//Local aParAuto  := {}    //-- Carrega a lista com os 21 parï¿½metros                            
Local cHora     := Time()         
Local dData     := DATE()
Local cQuery    := ''                            
Local aArea     := GetArea()
Local aBkpPerg  := {}



Pergunte("MTA330    ",.F.,,,,,@aBkpPerg)
	
//Altera conteúdo de alguma pergunta	
MV_PAR01  := dGet2            //MV_PAR01 = Data Limite Final     
MV_PAR02  := 2 		          //MV_PAR02 = Mostra lanctos. Contï¿½beis         1 SIM 2 NAO
MV_PAR03  := 2                //MV_PAR03 = Aglutina Lanctos Contï¿½beis   	   1 SIM 2 NAO
MV_PAR04  := 1                //MV_PAR04 = Atualizar Arq. de Movimentos  	   1 SIM 2 NAO
MV_PAR05  := 0                //MV_PAR05 = % de aumento da MOD
MV_PAR06  := 2                //MV_PAR06 = Centro de Custo 					   1 Contabil 2 Extracontabil
MV_PAR07  := "               "//MV_PAR07 = Conta Contï¿½bil a inibir de
MV_PAR08  := "               "//MV_PAR08 = Conta Contï¿½bil a inibir atï¿½
MV_PAR09  := 1		          //MV_PAR09 = Apagar estornos  				   1 SIM 2 NAO
MV_PAR10  := 1                //MV_PAR010 = Gerar Lancto. Contï¿½bil 	       1 SIM 2 NAO 3 MANTEM
MV_PAR11  := 1                //MV_PAR011 = Gerar estrutura pela Moviment      1 SIM 2 NAO
MV_PAR12  := 3                //MV_PAR012 = Contabilizaï¿½ï¿½o On-Line Por     1 CONSUMO 2 PRODUCAO 3 AMBAS
MV_PAR13  := 2                //MV_PAR013 = Calcula mï¿½o-de-Obra   	       1 SIM 2 NAO
MV_PAR14  := 2                //MV_PAR014 = Mï¿½todo de apropriaï¿½ï¿½o        1 SEQUENCIAL 2 MENSAL 3 DIARIA
MV_PAR15  := 2                //MV_PAR015 = Recalcula Nï¿½vel de Estrut        1 SIM 2 NAO
MV_PAR16  := 1                //MV_PAR016 = Mostra sequï¿½ncia de Cï¿½lculo    1 NAO MOSTRAR 2 CUSRO MEDIO 3 FIFO
MV_PAR17  := 2                //MV_PAR017 = Seq Processamento FIFO             1 DATA + SEQUENCIA 2 CUSTO MEDIO
MV_PAR18  := 2                //MV_PAR018 = Mov Internos Valorizados           1 ANTES 2 DEPOIS
MV_PAR19  := 2                //MV_PAR019 = Recï¿½lculo Custo transportes      1 SIM 2 NAO
MV_PAR20  := 2                //MV_PAR020 = Cï¿½lculo de custos por            1 TODAS FILIAIS 2 FILIAL CORRENTE 3 SELECIONA FILIAIS
MV_PAR21  := 2                //MV_PAR021 = Calcular Custo em Partes           1 SIM 2 NAO

SaveMVVars(.T.)

__SaveParam("MTA330    ", aBkpPerg)  

/*
//PARAMETROS PARA EXECUï¿½ï¿½O DO CUSTO MEDIO
AADD(aParAuto, dGet2				  ) //MV_PAR01 = Data Limite Final     
AADD(aParAuto, 2    				  ) //MV_PAR02 = Mostra lanctos. Contï¿½beis    						 1 SIM 2 NAO
AADD(aParAuto, 2                ) //MV_PAR03 = Aglutina Lanctos Contï¿½beis   						 1 SIM 2 NAO
AADD(aParAuto, 1                ) //MV_PAR04 = Atualizar Arq. de Movimentos  						 1 SIM 2 NAO
AADD(aParAuto, 0                ) //MV_PAR05 = % de aumento da MOD
AADD(aParAuto, 2                ) //MV_PAR06 = Centro de Custo 										 1 Contabil 2 Extracontabil
AADD(aParAuto, "               ") //MV_PAR07 = Conta Contï¿½bil a inibir de
AADD(aParAuto, "               ") //MV_PAR08 = Conta Contï¿½bil a inibir atï¿½
AADD(aParAuto, 2				) //MV_PAR09 = Apagar estornos  										 1 SIM 2 NAO
AADD(aParAuto, 1                ) //MV_PAR010 = Gerar Lancto. Contï¿½bil 								 1 SIM 2 NAO 3 MANTEM
AADD(aParAuto, 1                ) //MV_PAR011 = Gerar estrutura pela Moviment 					 1 SIM 2 NAO
AADD(aParAuto, 3                ) //MV_PAR012 = Contabilizaï¿½ï¿½o On-Line Por 						 1 CONSUMO 2 PRODUCAO 3 AMBAS
AADD(aParAuto, 2                ) //MV_PAR013 = Calcula mï¿½o-de-Obra   								 1 SIM 2 NAO
AADD(aParAuto, 2                ) //MV_PAR014 = Mï¿½todo de apropriaï¿½ï¿½o 								 1 SEQUENCIAL 2 MENSAL 3 DIARIA
AADD(aParAuto, 1                ) //MV_PAR015 = Recalcula Nï¿½vel de Estrut  					    1 SIM 2 NAO
AADD(aParAuto, 1                ) //MV_PAR016 = Mostra sequï¿½ncia de Cï¿½lculo 						 1 NAO MOSTRAR 2 CUSRO MEDIO 3 FIFO
AADD(aParAuto, 2                ) //MV_PAR017 = Seq Processamento FIFO                        1 DATA + SEQUENCIA 2 CUSTO MEDIO
AADD(aParAuto, 1                ) //MV_PAR018 = Mov Internos Valorizados                      1 ANTES 2 DEPOIS
AADD(aParAuto, 2                ) //MV_PAR019 = Recï¿½lculo Custo transportes                   1 SIM 2 NAO
AADD(aParAuto, 2                ) //MV_PAR020 = Cï¿½lculo de custos por                         1 TODAS FILIAIS 2 FILIAL CORRENTE 3 SELECIONA FILIAIS
AADD(aParAuto, 2                ) //MV_PAR021 = Calcular Custo em Partes                      1 SIM 2 NAO

//-- Adiciona filial a ser processada
dbSelectArea("SM0")
dbSeek(cEmpAnt)
Do While ! Eof() .And. SM0->M0_CODIGO == cEmpAnt 

	cCodFil := SM0->M0_CODFIL
	cNomFil := SM0->M0_FILIAL
	cCGC    := SM0->M0_CGC

	//-- Somente adiciona a Filial 01 e Filial 02
	If cCodFil == "01"
		//-- Adiciona a filial na lista de filiais a serem processadas
		Aadd(aListaFil,{.T.,cCodFil,cNomFil,cCGC,.F.,})
	EndIf 
	
	dbSkip()
EndDo

//-- Executa a rotina de recï¿½lculo do custo mï¿½dio
//MATA331(lBat,aListaFil,lCPParte, aParAuto)
//ConOut("Tï¿½rmino da execuï¿½ï¿½o do JOBM331")        

*/


cRpcEmp    := "01"            // Código da empresa.
cRpcFil    := Fwfilial()            // Código da filial.
cEnvUser   := "Admin"         // Nome do usuário.
cEnvPass   := "OpusDomex"     // Senha do usuário.
cEnvMod    := "EST"           // 'FAT'  // Código do módulo.
cFunName   := "MATA331"       // 'RPC'  // Nome da rotina que será setada para retorno da função FunName().
aTables    := {}              // {}     // Array contendo as tabelas a serem abertas.
lShowFinal := .F.             // .F.    // Alimenta a variável publica lMsFinalAuto.
lAbend     := .T.             // .T.    // Se .T., gera mensagem de erro ao ocorrer erro ao checar a licença para a estação.
lOpenSX    := .T.             // .T.    // SE .T. pega a primeira filial do arquivo SM0 quando não passar a filial e realiza a abertura dos SXs.
lConnect   := .T.             // .T.    // Se .T., faz a abertura da conexao com servidor As400, SQL Server etc

RpcSetEnv(cRpcEmp,cRpcFil,cEnvUser,cEnvPass,cEnvMod,cFunName,aTables,lShowFinal,lAbend,lOpenSX,lConnect) //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"

cInternBkp := __cInternet
__cInternet := Nil
	
MATA331()
//startjob("MATA331",getenvserver(), .F. )

cQuery += " SELECT * FROM " + RetSqlName("CV8") + " (NOLOCK) WHERE CV8_FILIAL='"+xFilial("CV8")+"' AND  D_E_L_E_T_=''  "
cQuery += " AND CV8_DATA>='"+DTOS(dData)+"' AND CV8_HORA>='"+SUBSTR(cHORA,1,5)+"' AND CV8_PROC='MATA331' "


If Select("MTA331") <> 0
	MTA331->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "MTA331"

cLogCus := "|--------+-----+------------------------------------------------------------|" + ENTER
While	MTA331->(!EOF())   
   If len(alltrim(MTA331->CV8_MSG)) > 60
		cLogCus += '|' + MTA331->CV8_DATA + '|' + MTA331->CV8_HORA + '|' + SUBSTR(alltrim(MTA331->CV8_MSG),1, 60) + '|' + ENTER
		cLogCus += '|' + SUBSTR(alltrim(MTA331->CV8_MSG),60,60) + SPACE(75-Len(SUBSTR(alltrim(MTA331->CV8_MSG),60,60))) + '|' + ENTER
	Else
		cLogCus += '|' + MTA331->CV8_DATA + '|' + MTA331->CV8_HORA + '|' + alltrim(MTA331->CV8_MSG)+ SPACE(60-LEN(alltrim(MTA331->CV8_MSG))) + '|' + ENTER
	Endif
	lLog	:= .t.
	MTA331->( DbSkip() )	
Enddo
cLogCus += "|--------+-----+------------------------------------------------------------|" + ENTER
           
RestArea(aArea)
Return                   



//rotina de contabilizaï¿½ï¿½o da VIRADA DE SALDO
Static Function JOBM280()
Local lBat     := .T.  //-- Caso a rotina seja rodada em batch(.T.), senï¿½o (.F.)
Local dDataFec := dGet2 
Local cArq1    := "ARQF1"  //-- Arquivo onde serï¿½o descarregados os dados do arquivo SF1
Local cArq2    := "ARQD1"  //-- Arquivo onde serï¿½o descarregados os dados do arquivo SD1
Local cArq3    := "ARQF2"  //-- Arquivo onde serï¿½o descarregados os dados do arquivo SF2
Local cArq4    := "ARQD2"  //-- Arquivo onde serï¿½o descarregados os dados do arquivo SD2
Local cArq5    := "ARQD3"  //-- Arquivo onde serï¿½o descarregados os dados do arquivo SD3
Local cArq6    := "ARQC2"  //-- Arquivo onde serï¿½o descarregados os dados do arquivo SC2
Local cArq7    := "ARQF9"  //-- Arquivo onde serï¿½o descarregados os dados do arquivo AF9
Local cHora     := Time()         
Local dData     := DATE()
Local cQuery    := ''                            

Local aArea     := GetArea()
                         
If MsgYesNo("Deseja rodar a rotina de virada de saldo de "+cMonth(dDataFec)+" ? ")                   

	MATA280(lBat,dDataFec,cArq1,cArq2,cArq3,cArq4,cArq5,cArq6,cArq7)
	
	cQuery += " SELECT * FROM " + RetSqlName("CV8") + " (NOLOCK) WHERE CV8_FILIAL='"+xFilial("CV8")+"' AND D_E_L_E_T_=''  "
	cQuery += " AND CV8_DATA>='"+DTOS(dData)+"' AND CV8_HORA>='"+SUBSTR(cHORA,1,5)+"' AND CV8_PROC='MATA280' "


	If Select("MTA280") <> 0
		MTA280->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "MTA280"

	cLogCus := "|--------+-----+------------------------------------------------------------|" + ENTER
	While	MTA280->(!EOF())   
   	If len(alltrim(MTA280->CV8_MSG)) > 60
			cLogCus += '|' + MTA280->CV8_DATA + '|' + MTA280->CV8_HORA + '|' + SUBSTR(alltrim(MTA280->CV8_MSG),1, 60) + '|' + ENTER
			cLogCus += '|' + SUBSTR(alltrim(MTA280->CV8_MSG),60,60) + SPACE(75-Len(SUBSTR(alltrim(MTA280->CV8_MSG),60,60))) + '|' + ENTER
		Else
			cLogCus += '|' + MTA280->CV8_DATA + '|' + MTA280->CV8_HORA + '|' + alltrim(MTA280->CV8_MSG)+ SPACE(60-LEN(alltrim(MTA280->CV8_MSG))) + '|' + ENTER
		Endif
		lLog	:= .t.
		MTA280->( DbSkip() )	
	Enddo
	cLogCus += "|--------+-----+------------------------------------------------------------|" + ENTER           
EndIf

      
RestArea(aArea)
Return                

//correcoes pos custo medio
Static Function CORDIFCU()                
Local cQuery  := "" 

cQuery  := " SELECT B2_FILIAL, B2_COD, B2_LOCAL,  B2_VFIM1, B2_QFIM AS B2_QFIM, R_E_C_N_O_ AS REC FROM SB2010 (NOLOCK) "
cQuery  += " WHERE B2_QFIM=0 AND B2_VFIM1<>0 AND D_E_L_E_T_='' AND B2_FILIAL='"+xFilial("SB2")+"' "

If Select("TMP") <> 0
	TMP->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "TMP"     

If TMP->(EOF())
	Alert("Nï¿½o hï¿½ itens a serem corrigidos!")
EndIf

While !TMP->(EOF())
	TMATA241(TMP->B2_COD, TMP->B2_LOCAL, TMP->B2_QFIM, dGet1, TMP->B2_VFIM1, TMP->REC)	                            
	TMP->(dbSKIP())
Enddo		   


Return                                

Static Function TMATA241(cCodProd, cLocal, nQtdFim, dDT, nValFim, nREC )
Local _aCab1    := {}
Local _aItem    := {}
Local _atotitem := {}             
Local cCodigoTM := SPACE(3)

Private lMsHelpAuto := .t. // se .t. direciona as mensagens de help
Private lMsErroAuto := .f. //necessario a criacao

cLogCus := ""

If	nQtdFim>0
	cCodigoTM   := "502"   
	nValFim			:= If(nValFim<0, nValFim  * -1,nValFim)
ElseiF nQtdFim<0  
	nQtdFim			:= If(nQtdFim<0, nQtdFim  * -1,nQtdFim)  
	nValFim			:= If(nValFim<0, nValFim  * -1,nValFim)
	cCodigoTM   := "002"
ElseiF nQtdFim=0 .AND. nValFim<0
	nQtdFim			:= If(nQtdFim<0, nQtdFim  * -1,nQtdFim)  
	nValFim			:= If(nValFim<0, nValFim  * -1,nValFim)
	cCodigoTM   := "002"
ElseiF nQtdFim=0 .AND. nValFim>0
	nQtdFim			:= If(nQtdFim<0, nQtdFim  * -1,nQtdFim)  
	nValFim			:= If(nValFim<0, nValFim  * -1,nValFim)
	cCodigoTM   := "502"
endIf    

SB1->(dbSeek(xFilial("SB1")+cCodProd))
	
_aCab1 := { {"D3_TM" ,cCodigoTM      , NIL},;
			   {"D3_EMISSAO" ,dDT       , NIL}}
	
_aItem := { ;
			   {"D3_COD"     ,cCodProd   ,NIL},;
			   {"D3_UM"      ,SB1->B1_UM ,NIL},;
			   {"D3_QUANT"   ,nQtdFim	  ,NIL},; 
			   {"D3_CUSTO1"  ,nValFim	  ,NIL},; 
			   {"D3_LOCAL"   ,cLocal     ,NIL}}

aadd(_atotitem,_aitem)
MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_atotitem,3)


If lMsErroAuto
	MOSTRAERRO()
Else
   SB2->( DBGOTO(nREC) )
	If SB2->B2_COD==cCodProd .AND. SB2->B2_LOCAL==cLocal 
		Reclock("SB2",.F.)
		//SB2->B2_QFIM  := 0
		SB2->B2_VFIM1 := 0
		SB2->( MSUNLOCK() )			
	EndIF
	If !lLog
			cLogCus += "Foram corrigidos os itens abaixo: "	+ ENTER     
			cLogCus += "+---------------+--------+--+----------------+" + ENTER  
	EndIf 
	cLogCus += '|' +cCodProd+ '| TM '+cCodigoTM+' |' + cLocal+ '|' +  TRANSFORM(nValFim, "@E 9,999,999,999.99")  + '|' + ENTER
	lLog	:= .t.
	
EndIf

Return 

Static Function fAvancar()

If nContPer=0
	MSGSTOP("Atenção este é o último período com LOG gerado")
Else                                                
	nContPer := nContPer + 1
	cPerAtu  := AnoMes(MonthSub(dGet1,(nContPer*-1)))
//	cPerAnt  :=	AnoMes(MonthSub(dGet1,((1+nContPer)*-1)))
	fGetdados()
Endif

Return                                             


Static Function fVoltar()
      
nContPer := nContPer-1
cPerAtu  := AnoMes(MonthSub(dGet1,(nContPer*-1)))			
//cPerAnt  := AnoMes(MonthSub(dGet1,((nContPer-1)*-1)))			
If cPerAtu=="201907"
	nContPer := nContPer + 1
	cPerAtu  := AnoMes(MonthSub(dGet1,(nContPer*-1)))
	MSGSTOP("Não há períodos anteriores com LOG gerado")
Endif 
fGetdados()

Return



Static Function fBmpControl()
                                
If !lAll .and. lOpt
	oTBitmap1:Load(NIL, cFileOK)   
	oTBitmap2:Load(NIL, cFileOK)
	oTBitmap3:Load(NIL, cFileOK)
	oTBitmap4:Load(NIL, cFileOK)
	oTBitmap5:Load(NIL, cFileOK)
	oTBitmap6:Load(NIL, cFileOK)
	oTBitmap7:Load(NIL, cFileOK)
	oTBitmap8:Load(NIL, cFileOK)
	oTBitmap9:Load(NIL, cFileOK)
	oTBitmap10:Load(NIL, cFileOK)
	oTBitmap11:Load(NIL, cFileOK)
	oTBitmap12:Load(NIL, cFileOK)
	oTBitmap13:Load(NIL, cFileOK)
	oTBitmap14:Load(NIL, cFileOK)
//	oTBitmap9:Load(NIL, cFileOK)
	lAll := .t.     
	oWin2:Refresh()
Elseif lOpt
	oTBitmap1:Load(NIL, cFileNOK)
	oTBitmap2:Load(NIL, cFileNOK)
	oTBitmap3:Load(NIL, cFileNOK)
	oTBitmap4:Load(NIL, cFileNOK)
	oTBitmap5:Load(NIL, cFileNOK)
	oTBitmap6:Load(NIL, cFileNOK)
	oTBitmap7:Load(NIL, cFileNOK)
	oTBitmap8:Load(NIL, cFileNOK)
	oTBitmap9:Load(NIL, cFileNOK)
	oTBitmap10:Load(NIL, cFileNOK)
	oTBitmap11:Load(NIL, cFileNOK)
	oTBitmap12:Load(NIL, cFileNOK)
	oTBitmap13:Load(NIL, cFileNOK)
	oTBitmap14:Load(NIL, cFileNOK)
//	oTBitmap9:Load(NIL, cFileNOK)
	lAll := .f.   
	oWin2:Refresh()
EndIf


Return

//Execuï¿½ï¿½o das rotinas
Static function fExeCust()
Local lRet   := .f.  

If DTOC(dGet2) == "  /  /  "
	MSGSTOP("Data de processamento em branco, insira uma data para continuar!")  
	Return .t. 
Endif                

If nContPer<>0
	MSGSTOP("Volte ao perï¿½odo atual para executar o fechamento!")  
	Return .t. 
EndIf

//Processa itens
For x:= 1 to len(aOptions)
   If aOptions[x][2] .and. aOptions[x][1]     == "RECURSIVIDADE"
  		FWMsgRun(oWin3, {|oSay| RECUR001() },    "Processando", "Processando rotina de recursividade..."				)	    
  	ElseIf aOptions[x][2] .and. aOptions[x][1] == "ESTNEG"
  		FWMsgRun(oWin3, {|oSay| ESTNEG()   },    "Processando", "Processando rotina de estoque negativo..."			)	         	
  	ElseIf aOptions[x][2] .and. aOptions[x][1] == "VALCUS"
  		FWMsgRun(oWin3, {|oSay| VALCUS()   },    "Processando", "Processando custo 0,01..."			)	         	  	
  	ElseIf aOptions[x][2] .and. aOptions[x][1] == "SLDINICI"
  		FWMsgRun(oWin3, {|oSay| SLDINICI()   },    "Processando", "Processando rotina de saldos iniciais..."			)	         	
  	ElseIf aOptions[x][2] .and. aOptions[x][1] == "SLDLTEND"
  		FWMsgRun(oWin3, {|oSay| SLDLTEND()   },    "Processando", "Processando rotina de saldos Lote X Enderecos...")	         	
  	ElseIf aOptions[x][2] .and. aOptions[x][1] == "PRXRE"
  		FWMsgRun(oWin3, {|oSay| PRXREVLD()   },    "Processando", "Processando rotina de requisicoes x produções...")	         	
   ElseIf aOptions[x][2] .and. aOptions[x][1] == "JOBM330"
  		FWMsgRun(oWin3, {|oSay| JOBM330()   },    "Processando", "Processando rotina de Custo Medio |MATA330|..."   )	         	
  	ElseIf aOptions[x][2] .and. aOptions[x][1] == "JOBM331"
  		FWMsgRun(oWin3, {|oSay| JOBM331()   },    "Processando", "Processando rotina de Contabilização |MATA331|...")	         	  		
  	ElseIf aOptions[x][2] .and. aOptions[x][1] == "SEQCALC"
  		FWMsgRun(oWin3, {|oSay| SEQCALC()   },    "Processando", "Verificando itens sem SEQCALC..."						)	         	
  	ElseIf aOptions[x][2] .and. aOptions[x][1] == "CORDIFCU"
  		FWMsgRun(oWin3, {|oSay| CORDIFCU()   },    "Processando", "Corrigingo itens divergencias de custos QTD ZERO e VALOR...")	         	
  	ElseIf aOptions[x][2] .and. aOptions[x][1] == "PROXREQ"
  		FWMsgRun(oWin3, {|oSay| PROXREQ()   },    "Processando" , "Verificando valor Requisitado x Produzido..."		)	         	
	ElseIf aOptions[x][2] .and. aOptions[x][1] == "JOBM280"
  		FWMsgRun(oWin3, {|oSay| JOBM280()   },    "Processando" , "Processando rotina de Virada de saldos |MATA280|...")	         	  	
	ElseIf aOptions[x][2] .and. aOptions[x][1] == "ACERTASB9"
  		FWMsgRun(oWin3, {|oSay| ACERTASB9()   },    "Processando" , "Processando rotina de PÓS Virada de saldo...")	         	  	
    ElseIf aOptions[x][2] .and. aOptions[x][1] == "SEMMOVB9"
  		FWMsgRun(oWin3, {|oSay| SEMMOVB9()   },    "Processando" , "Processando rotina de CORREÇÃO de itens com primeiro movimento...")	         	  	
  	EndIf      
  	    
  	If aOptions[x][2] 
  		FWMsgRun(oWin3, {|oSay| GravaLog(aOptions[x][1]) },    "Processando", "Gravando LOG...")	         	
  		lRet := .t.
  	EndIf                                              
  	
	oGetDados:oBrowse:bChange := { |nIndo| fMudaLinha(oGetDados,oGetDados:oBrowse:nat,nIndo) }
  	
Next x      

Return lRet

//gravaï¿½ï¿½o de log das rotinas
Static Function GravaLog(cRotina)
Local aArea := GetArea()
ZZB->(dbsetorder(1))                                              
If ZZB->(dbSeek(xFilial("ZZB")+cPerAtu+cRotina))
	If lLog .and. cRotina <> "VALCUS"  	              
		Reclock("ZZB",.F.)
		ZZB->ZZB_LOG       := cLogCus   
		ZZB->ZZB_DATA   	 := DATE()
		ZZB->ZZB_STATUS    := "E"       
		ZZB->ZZB_HORA   	 := Time()   
		ZZB->ZZB_USUARI    := Subs(cUsuario,7,12)
		ZZB->(MSUNLOCK())       
	Else      		               
	  	Reclock("ZZB",.F.)
	  	ZZB->ZZB_LOG 	    := cLogCus
		ZZB->ZZB_STATUS    := "F"       
		ZZB->ZZB_DATA   	 := DATE()
		ZZB->ZZB_HORA   	 := Time()   
		ZZB->ZZB_USUARI    := Subs(cUsuario,7,12)
		ZZB->(MSUNLOCK())       		
	EndIf
Else
  Alert('rotina ' + cRotina + ' nï¿½o encontrada no ZZB')
EndIF     

lLog 		:= .f.     
cLogCus  := ""
      
fGetdados()             
oMemo1:Refresh()     
oWin3:Refresh()  
oGetDados:Refresh()  
RestArea(aArea)
Return

//Legenda
Static Function ZZBLeg()

	BrwLegenda(cCadastro,"legenda",{{"BR_CINZA"     ,"Processo nao executado"   		 } ,;    
	                                {"BR_VERMELHO"  ,"Processo executado com erros"   }	,;
										     {"BR_VERDE"     ,"Processo executado sem erros"   }} )
Return(.T.)
      
/*
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í»ï¿½ï¿½
ï¿½ï¿½ï¿½Programa  ï¿½RMENCUST  ï¿½Autor  ï¿½Jonas Pereira      ï¿½ Data ï¿½  25/10/19    ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Desc.     ï¿½ Relatï¿½rio de Custo			                           ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½          ï¿½                                                            ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Uso       ï¿½ AP                                                         ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¼ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
*/

User Function RMENCUST() 
Local lExec := .F. 

If MsgYesNo("Deseja exportar os dados do fechamento do perï¿½odo "+cPerAtu+" ? ")  
	lExec := .t.                 
EndIf          

If lExec
	MsgRun("Exportando Dados...","Fechamento Mensal",{|| U_fdadosfe() })
Endif

Return Nil

//--------------------------------
//
//--------------------------------
User Function fdadosfe()
Local oFwMsEx := NIL     
Local cArq 			:= ""
Local cDirTmp 		:= GetTempPath()
Local cQry 			:= ""                                         
Local dCalc       := CTOD('01/'+SUBSTR(cPerAtu,5,2)+'/'+SUBSTR(cPerAtu,1,4))    
Local cPeriodoIni := ""
Private cCadastro := "Gerar XLS" 
           


//cPerAtu  	:=	AnoMes(dGet1) 
cPeriodoIni :=	AnoMes(MonthSub(dCalc,1))                                           
aWorkSheet  := "Periodo_"+cPerAtu   
bWorkSheet  := cPerAtu+"_X_"+cPerAnt
cWorkSheet  := "Produtos_500"   
dWorkSheet  := "SD3-Transferencias"   
aTable      := ""
bTable      := ""
cTable      := ""
dTable      := ""
	   	                           	   	   	   	   
oFwMsEx := FWMsExcel():New()
oFwMsEx:AddWorkSheet( aWorkSheet )      
oFwMsEx:AddTable( aWorkSheet, aTable )	
                                                                                                                    
oFwMsEx:AddColumn( aWorkSheet, aTable , "PRODUTO" 	 			, 1,1)
oFwMsEx:AddColumn( aWorkSheet, aTable , "ARMAZEM" 				, 1,1)
oFwMsEx:AddColumn( aWorkSheet, aTable , "QUANTIDADE FINAL" 	, 1,1)
oFwMsEx:AddColumn( aWorkSheet, aTable , "VALOR FINAL" 		, 1,1)
oFwMsEx:AddColumn( aWorkSheet, aTable , "CUSTO MEDIO " 		, 1,1)

If nContPer == 0   
	cQry := " SELECT B2_COD AS PRODUTO, B2_LOCAL AS ARMAZEM, replace(B2_QFIM, '.',',') AS QFIM, replace(B2_VFIM1, '.',',') AS VFIM, replace(B2_CM1,'.',',') AS CM  FROM SB2010 AS SB2 "
	cQry += " WHERE SB2.D_E_L_E_T_='' "
	cQry += " AND B2_QFIM<>0 "
Else
    cQry := " SELECT B9_COD AS PRODUTO, B9_LOCAL AS ARMAZEM, replace(B9_QINI, '.',',') AS QFIM, replace(B9_VINI1, '.',',') AS VFIM, replace(B9_CM1,'.',',') AS CM  FROM SB9010 AS SB9 "
	 cQry += " WHERE SB9.D_E_L_E_T_='' AND LEFT(B9_DATA,6)='"+cPerAtu+"' "
	 cQry += " AND B9_QINI<>0 "
EndIf
If Select("SUPP")>0
	SUPP->( DbCloseArea() )
EndIf

dbusearea(.t.,"TOPCONN",TCGenQRY(,,cQry),"SUPP",.f.,.t.)

ProcRegua(0)
           
SUPP->(dbGoTop()) 
While SUPP->(!EOF())    
               
   	vProduto 		:= SUPP->PRODUTO
   	vArmazem  		:= SUPP->ARMAZEM
   	vQfim				:= SUPP->QFIM 
   	vVfim 			:= SUPP->VFIM
   	vCM    			:= SUPP->CM

      oFwMsEx:AddRow( aWorkSheet, aTable, {;
   		 								vProduto,;
							      	   vArmazem,; 
							      	   vQfim,;  
					   				 	vVfim,; 
							      		vCM})  
   		 
SUPP->( dbskip() )
	
EndDo

oFwMsEx:AddWorkSheet( bWorkSheet )      
oFwMsEx:AddTable( bWorkSheet, bTable )	                                                                                                                    
oFwMsEx:AddColumn( bWorkSheet, bTable , "PRODUTO" 	 						, 1,1)
oFwMsEx:AddColumn( bWorkSheet, bTable , "ARMAZEM" 							, 1,1)
oFwMsEx:AddColumn( bWorkSheet, bTable , "QUANTIDADE MES ANTERIOR" 	, 1,1)  
oFwMsEx:AddColumn( bWorkSheet, bTable , "VALOR MES ANTERIOR" 			, 1,1)     
oFwMsEx:AddColumn( bWorkSheet, bTable , "CUSTO MEDIO MES ANTERIOR " 	, 1,1)
oFwMsEx:AddColumn( bWorkSheet, bTable , "QUANTIDADE MES ATUAL" 		, 1,1)  
oFwMsEx:AddColumn( bWorkSheet, bTable , "VALOR MES ATUAL" 				, 1,1)     
oFwMsEx:AddColumn( bWorkSheet, bTable , "CUSTO MEDIO MES ATUAL " 		, 1,1)
                                           

If nContPer == 0     
	cQry := " SELECT B9A.B9_COD as PRODUTO, SB2.B2_LOCAL AS ARMAZEM, REPLACE(B9A.B9_QINI, '.',',') AS QTD_MESANTERIOR, REPLACE(B9A.B9_VINI1, '.',',') VL_MESANTERIOR, "
	cQry += " REPLACE(B9A.B9_CM1, '.',',') CM_MESANTERIOR, REPLACE(SB2.B2_QFIM, '.',',') AS QTD_MESATUAL, REPLACE(SB2.B2_VFIM1, '.',',') VL_MESATUAL, "
	cQry += " REPLACE(SB2.B2_CM1, '.',',') AS CM_MESATUAL "   
	cQry += " FROM SB9010 AS B9A "
	cQry += " INNER JOIN SB2010 As SB2 ON B9A.B9_COD=SB2.B2_COD AND B9A.B9_LOCAL=SB2.B2_LOCAL "
	cQry += " WHERE B9A.D_E_L_E_T_='' AND B9A.B9_DATA='"+DTOS(dMvUlmes)+"' "
	cQry += " AND SB2.D_E_L_E_T_='' " 
	cQry += " AND B9A.B9_QINI>0 "     
Else
	cQry := " SELECT B9A.B9_COD as PRODUTO, SB9.B9_LOCAL AS ARMAZEM, REPLACE(B9A.B9_QINI, '.',',') AS QTD_MESANTERIOR, REPLACE(B9A.B9_VINI1, '.',',') VL_MESANTERIOR, "
	cQry += " REPLACE(B9A.B9_CM1, '.',',') CM_MESANTERIOR, REPLACE(SB9.B9_QINI, '.',',') AS QTD_MESATUAL, REPLACE(SB9.B9_VINI1, '.',',') VL_MESATUAL, "
	cQry += " REPLACE(SB9.B9_CM1, '.',',') AS CM_MESATUAL  "
	cQry += " FROM SB9010 AS B9A "
	cQry += " INNER JOIN SB9010 As SB9 ON B9A.B9_COD=SB9.B9_COD AND B9A.B9_LOCAL=SB9.B9_LOCAL and LEFT(SB9.B9_DATA,6)='"+cPerAtu+"'  "
	cQry += " WHERE B9A.D_E_L_E_T_='' AND left(B9A.B9_DATA,6)='"+cPeriodoIni+"'  "  //cPerAnt  :=	AnoMes(MonthSub(dGet1,((1+nContPer)*-1)))
	cQry += " AND SB9.D_E_L_E_T_='' "
	cQry += " AND B9A.B9_QINI>0 "     
EndIf
If Select("SUPP")>0
	SUPP->( DbCloseArea() )
EndIf

dbusearea(.t.,"TOPCONN",TCGenQRY(,,cQry),"SUPP",.f.,.t.)

ProcRegua(0)
           
SUPP->(dbGoTop()) 
While SUPP->(!EOF())    
               
   	vProduto 		:= SUPP->PRODUTO
   	vArmazem  		:= SUPP->ARMAZEM
   	vQfim				:= SUPP->QTD_MESANTERIOR 
   	vVfim 			:= SUPP->VL_MESANTERIOR
   	vCM    			:= SUPP->CM_MESANTERIOR   
   	vQfimAtu			:= SUPP->QTD_MESATUAL 
   	vVfimAtu			:= SUPP->VL_MESATUAL
   	vCMAtu  			:= SUPP->CM_MESATUAL

      oFwMsEx:AddRow( bWorkSheet, bTable, {;
   		 								vProduto,;
							      	   vArmazem,; 
							      	   vQfim,;  
					   				 	vVfim,; 
					   				 	vCM,;       
					   				 	vQfimAtu,; 
							      	   vVfimAtu,;  
					   				 	vCMAtu})
							      	  
   		 
SUPP->( dbskip() )
	
EndDo

oFwMsEx:AddWorkSheet( cWorkSheet )      
oFwMsEx:AddTable( cWorkSheet, cTable )	
                                                                                                                    
oFwMsEx:AddColumn( cWorkSheet, cTable , "PRODUTO" 	 			, 1,1)
oFwMsEx:AddColumn( cWorkSheet, cTable , "ARMAZEM" 				, 1,1)
oFwMsEx:AddColumn( cWorkSheet, cTable , "QUANTIDADE FINAL" 	, 1,1)
oFwMsEx:AddColumn( cWorkSheet, cTable , "VALOR FINAL" 		, 1,1)
oFwMsEx:AddColumn( cWorkSheet, cTable , "CUSTO MEDIO " 		, 1,1)
                                         
    
If nContPer == 0   
	cQry := " SELECT B2_COD AS PRODUTO, B2_LOCAL AS ARMAZEM, replace(B2_QFIM, '.',',') AS QFIM, replace(B2_VFIM1, '.',',') AS VFIM, replace(B2_CM1,'.',',') AS CM  FROM SB2010 AS SB2 "
	cQry += " WHERE SB2.D_E_L_E_T_='' "
	cQry += " AND B2_QFIM<>0 "
	cQry += " and B2_COD IN ('50010100','50010100D','50010100DR','50010100F','50010100J','50010100T') "
Else
    cQry := " SELECT B9_COD AS PRODUTO, B9_LOCAL AS ARMAZEM, replace(B9_QINI, '.',',') AS QFIM, replace(B9_VINI1, '.',',') AS VFIM, replace(B9_CM1,'.',',') AS CM  FROM SB9010 AS SB9 "
	 cQry += " WHERE SB9.D_E_L_E_T_='' AND LEFT(B9_DATA,6)='"+cPerAtu+"' "
	 cQry += " AND B9_QINI<>0 "
    cQry += " and B9_COD IN ('50010100','50010100D','50010100DR','50010100F','50010100J','50010100T') "
EndIf
    
If Select("SUPP")>0
	SUPP->( DbCloseArea() )
EndIf

dbusearea(.t.,"TOPCONN",TCGenQRY(,,cQry),"SUPP",.f.,.t.)

ProcRegua(0)
           
SUPP->(dbGoTop()) 
While SUPP->(!EOF())    
               
   	vProduto 		:= SUPP->PRODUTO
   	vArmazem  		:= SUPP->ARMAZEM
   	vQfim				:= SUPP->QFIM 
   	vVfim 			:= SUPP->VFIM
   	vCM    			:= SUPP->CM

      oFwMsEx:AddRow( cWorkSheet, cTable, {;
   		 								vProduto,;
							      	   vArmazem,; 
							      	   vQfim,;  
					   				 	vVfim,; 
							      		vCM})  
   		 
SUPP->( dbskip() )
	
EndDo

oFwMsEx:AddWorkSheet( dWorkSheet )      
oFwMsEx:AddTable( dWorkSheet, dTable )	                                                                                                                    
oFwMsEx:AddColumn( dWorkSheet, dTable , "TM" 	 				, 1,1)
oFwMsEx:AddColumn( dWorkSheet, dTable , "PRODUTO" 				, 1,1)
oFwMsEx:AddColumn( dWorkSheet, dTable , "UN" 					, 1,1)  
oFwMsEx:AddColumn( dWorkSheet, dTable , "QUANTIDADE" 			, 1,1)     
oFwMsEx:AddColumn( dWorkSheet, dTable , "CF" 					, 1,1)
oFwMsEx:AddColumn( dWorkSheet, dTable , "CONTA" 				, 1,1)  
oFwMsEx:AddColumn( dWorkSheet, dTable , "OP" 					, 1,1)     
oFwMsEx:AddColumn( dWorkSheet, dTable , "LOCAL" 				, 1,1)       
oFwMsEx:AddColumn( dWorkSheet, dTable , "DOC" 					, 1,1)
oFwMsEx:AddColumn( dWorkSheet, dTable , "EMISSAO" 				, 1,1)  
oFwMsEx:AddColumn( dWorkSheet, dTable , "HORA" 					, 1,1)     
oFwMsEx:AddColumn( dWorkSheet, dTable , "GRUPO" 				, 1,1)    
oFwMsEx:AddColumn( dWorkSheet, dTable , "CUSTO1" 			 	, 1,1)
oFwMsEx:AddColumn( dWorkSheet, dTable , "NUMSEQ" 				, 1,1)  
oFwMsEx:AddColumn( dWorkSheet, dTable , "TIPO" 					, 1,1)     
oFwMsEx:AddColumn( dWorkSheet, dTable , "USUARIO" 				, 1,1)
oFwMsEx:AddColumn( dWorkSheet, dTable , "LOTECTL" 				, 1,1)     
oFwMsEx:AddColumn( dWorkSheet, dTable , "LOCALIZACAO" 		, 1,1)

If nContPer == 0       
	cQry := " SELECT D3_TM, D3_COD, D3_UM, REPLACE(D3_QUANT, '.',',') AS D3_QUANT, D3_CF, D3_CONTA, D3_OP, D3_LOCAL, D3_DOC, D3_EMISSAO, D3_HORA, D3_GRUPO, "
	cQry += " REPLACE(D3_CUSTO1, '.',',') AS D3_CUSTO1, D3_NUMSEQ, D3_TIPO, D3_USUARIO, D3_LOTECTL, D3_LOCALIZ "
	cQry += " FROM SD3010 (NOLOCK) AS SD3 "
	cQry += " WHERE SD3.D_E_L_E_T_='' AND D3_EMISSAO BETWEEN '"+DTOS(dGet1)+"'  AND '"+DTOS(dGet2)+"' AND D3_ESTORNO<>'S' "
	cQry += " AND D3_CF IN ('RE4','DE4') "        
Else
	cQry := " SELECT D3_TM, D3_COD, D3_UM, REPLACE(D3_QUANT, '.',',') AS D3_QUANT, D3_CF, D3_CONTA, D3_OP, D3_LOCAL, D3_DOC, D3_EMISSAO, D3_HORA, D3_GRUPO, "
	cQry += " REPLACE(D3_CUSTO1, '.',',') AS D3_CUSTO1, D3_NUMSEQ, D3_TIPO, D3_USUARIO, D3_LOTECTL, D3_LOCALIZ "
	cQry += " FROM SD3010 (NOLOCK) AS SD3 "
	cQry += " WHERE SD3.D_E_L_E_T_='' AND LEFT(D3_EMISSAO,6)= '"+cPerAtu+"'   AND D3_ESTORNO<>'S' "
	cQry += " AND D3_CF IN ('RE4','DE4') "        
EndIf

If Select("SUPP")>0
	SUPP->( DbCloseArea() )
EndIf

dbusearea(.t.,"TOPCONN",TCGenQRY(,,cQry),"SUPP",.f.,.t.)

ProcRegua(0)
           
SUPP->(dbGoTop()) 
While SUPP->(!EOF())    
               
   	vTM		 		:= SUPP->D3_TM
   	vProduto  		:= SUPP->D3_COD
   	vUM				:= SUPP->D3_UM 
   	vQuant 			:= SUPP->D3_QUANT
   	vCF    			:= SUPP->D3_CF   
   	vConta			:= SUPP->D3_CONTA 
   	vOP				:= SUPP->D3_OP         
   	vLocal			:= SUPP->D3_LOCAL         
   	vDoc				:= SUPP->D3_DOC            	
   	vEMISSAO 		:= SUPP->D3_EMISSAO    
   	vHORA 			:= SUPP->D3_HORA
   	vGRUPO 			:= SUPP->D3_GRUPO
      vCUSTO1 			:= SUPP->D3_CUSTO1
      vNUMSEQ 			:= SUPP->D3_NUMSEQ                  
   	vTIPO 			:= SUPP->D3_TIPO
   	vUSUARIO 		:= SUPP->D3_USUARIO
      vLOTECTL 		:= SUPP->D3_LOTECTL
      vLOCALIZ 		:= SUPP->D3_LOCALIZ
      
      
    oFwMsEx:AddRow( dWorkSheet, dTable, {;
   		 								vTM,;
							      	   vProduto,; 
							      	   vUM,;  
					   				 	vQuant,; 
					   				 	vCF,;       
					   				 	vConta,; 
							      	   vOP,;       
							      	   vLocal,;
							      	   vDoc,;
					   				 	vEMISSAO,;					   				 	 
									   	vHORA,;
									   	vGRUPO,;
									      vCUSTO1,;
									      vNUMSEQ,;
									   	vTIPO,;	
									   	vUSUARIO,;
									      vLOTECTL,;
									      vLOCALIZ})
							      	     		 
SUPP->( dbskip() )
	
EndDo

		oFwMsEx:Activate()	
      cArq := ("Daily_order_book"+DTOS(DATE())+".xml")
		LjMsgRun( "Gerando o arquivo, aguarde...", cCadastro, {|| oFwMsEx:GetXMLFile( cArq ) } )
		If __CopyFile( cArq, cDirTmp + cArq )
		////	If aRet[3]
				oExcelApp := MsExcel():New()
				oExcelApp:WorkBooks:Open( cDirTmp + cArq )
				oExcelApp:SetVisible(.T.)
		////	Else
		///		MsgInfo( "Arquivo " + cArq + " gerado com sucesso no diretï¿½rio " + cDir )
		////	Endif
		Else
			MsgInfo( "Arquivo nï¿½o copiado para temporï¿½rio do usuï¿½rio." )
		Endif
	//Else
	//	MsgInfo( "Tabela nï¿½o localizada" )
	//Endif  
    SUPP->(dbCloseArea())	             
Return(Nil)

Static Function BLQEST()

Local dBlq := GETMV('MV_DBLQMOV')      
Local dFin := GETMV('MV_DATAFIN')

Define MsDialog oDlgLst Title "Bloqueia Movimentos" From 0,0 To 175,330 Pixel

@ 015,002 	Say OemToAnsi("Estoque:") of oDlgLst PIXEL SIZE 50,9
@ 013,038 	MsGet oReq   VAR dBlq   When .T. SIZE 80,10 of oDlgLst PIXEL  


@ 037,002 	Say OemToAnsi("Financeiro:") of oDlgLst PIXEL SIZE 50,9
@ 034,038 	MsGet oReq   VAR dFin   When .T. SIZE 80,10 of oDlgLst PIXEL


//@ 050,002 	Say OemToAnsi("Bx. Financeiro:") of oDlgLst PIXEL SIZE 50,9
//@ 047,038 	MsGet oReq   VAR dbFin   When .T. SIZE 80,10 of oDlgLst PIXEL

Define SButton From 033,135 Type 1 Action (FWMsgRun(, {|oSay| fOkProc(dBlq,dFin) }, "Processando", "Processando a rotina..."),oDlgLst:End()) Enable Of oDlgLst
Activate MsDialog oDlgLst Center
                                       
Return

Static Function fOkProc(dLim,dfLim)     
If MsgYesNo("A data limite para inclusao de movimentos serï¿½ atualizada,"+Chr(13)+Chr(10)+"Deseja continuar ?","A T E N ï¿½ ï¿½ O")
	PutMv('MV_DBLQMOV', dLim)  
	PutMv('MV_DATAFIN', dfLim)  
  //	PutMv('MV_BXDTFIN', dbxLim)
EndIf
Return .t.

/*
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í»ï¿½ï¿½
ï¿½ï¿½ï¿½Programa  ï¿½Custo001     ï¿½Autor  ï¿½Helio Ferreira   ï¿½ Data ï¿½  26/09/12   ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Desc.     ï¿½ Programa criado para converter o custo unitario de todo    ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½          ï¿½ saldo de produtos nos almox 05/06/07/09/12/14  para 0.01   ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Uso       ï¿½ AP                                                        ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¼ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
*/

Static Function VALCUS()
	Local cTexto
	Private cAlmox := "05/06/07/09/12/14"

	cTexto := "Este programa tem como objetivo alterar o custo unitï¿½rios de todos os produtos que estiverem nos almoxarifados " + cAlmox + " "
	cTexto += "para 0,01 na data base do sistema. Ou seja, se houver 10 PC em estoque na data base, seu valor total serï¿½ 0,10. " + Chr(13) + Chr(10) + Chr(13) + Chr(10)
	cTexto += "DataBase do sistema: " + DtoC(dDataBase)+Chr(13)+Chr(10)+ Chr(13) + Chr(10)
	cTexto += "Tipos de Movimentaï¿½ï¿½es (TM) utilizadas: 002 - Devoluï¿½ï¿½o e 502 - Requisiï¿½ï¿½o"

	BatchProcess("Acerta Custo Unit. para 0,01 - CUSTO001.PRW",cTexto,"",{ || Processa({|lEnd| ProcRun() },OemToAnsi("Acerta Custo Unit. para 0,01"),OemToAnsi("Calculando os estoque/valores atuais..."),.F.)})

Return

Static Function ProcRun()


cLogCus := "Log de Analise de produtos com VALOR UNITARIO igual a 0"+ENTER


	SB2->( dbGoTop() )
	ProcRegua(SB2->( LastRec() ))

	While !SB2->( EOF() )
		If SB2->B2_LOCAL $ cAlmox
			aSaldo     := CalcEst(SB2->B2_COD, SB2->B2_LOCAL, dDataBase+1 )
			nSaldo     := aSaldo[1]
			vSaldo     := aSaldo[2]

			nValorOK   := 	Round(nSaldo * (0.01),2)

			If nValorOK <> vSaldo
			    
			    Private lMsHelpAuto := .T.
				Private lMsErroAuto := .F.
					
				If nValorOK > vSaldo .and. (Round(nValorOK - vSaldo,2) > 0 )  // Devoluï¿½ï¿½o de valor
					
					aVetor := {}
					AADD(aVetor,{"D3_TM"        , '002'                            , NIL })
					AADD(aVetor,{"D3_COD"       , SB2->B2_COD                      , NIL })
					AADD(aVetor,{"D3_EMISSAO"   , ddatabase                        , NIL })
					AADD(aVetor,{"D3_QUANT"     , 0                                , NIL })
					AADD(aVetor,{"D3_LOCAL"     , SB2->B2_LOCAL                    , NIL })
					AADD(aVetor,{"D3_CUSTO1"    , Round(nValorOK - vSaldo,2)       , NIL })
               

					MSExecAuto({|x,y| mata240(x,y)},aVetor,3)   	 // Movimentaï¿½ï¿½o Interna

					If lMsErroAuto
						Mostraerro()
					Else
						If !lLog
							cLogCus += "Foram corrigidos os itens abaixo: "	+ ENTER     
							cLogCus += "+---------------+--------+--+----------------+" + ENTER  
						EndIf 
						cLogCus += '|' +SB2->B2_COD+ '| TM 002 |' + SB2->B2_LOCAL+ '|' +  TRANSFORM(Round(nValorOK - vSaldo,2), "@E 9,999,999,999.99")  + '|' + ENTER
						lLog	:= .t.
					EndIf
				EndIf

				If (nValorOK < vSaldo)  .and. (Round(vSaldo - nValorOK,2) > 0 )  // Requisiï¿½ï¿½o de valor
					
					aVetor := {}
					AADD(aVetor,{"D3_TM"        , '502'                            , NIL })
					AADD(aVetor,{"D3_COD"       , SB2->B2_COD                      , NIL })
					AADD(aVetor,{"D3_EMISSAO"   , ddatabase                        , NIL })
					AADD(aVetor,{"D3_QUANT"     , 0                                , NIL })
					AADD(aVetor,{"D3_LOCAL"     , SB2->B2_LOCAL                    , NIL })
					AADD(aVetor,{"D3_CUSTO1"    , Round(vSaldo - nValorOK,2)       , NIL })

					MSExecAuto({|x,y| mata240(x,y)},aVetor,3)   	 // Movimentaï¿½ï¿½o Interna

					If lMsErroAuto
						Mostraerro()
					Else
						If !lLog
							cLogCus += "Foram corrigidos os itens abaixo: "	+ ENTER     
							cLogCus += "+---------------+--------+--+----------------+" + ENTER  
						EndIf 
						cLogCus += '|' +SB2->B2_COD+ '| TM 502 |' + SB2->B2_LOCAL+ '|' +  TRANSFORM(Round(vSaldo - nValorOK,2), "@E 9,999,999,999.99")  + '|' + ENTER
						lLog	:= .t.					
					EndIf
				EndIf
			EndIf
		EndIf
		IncProc()
		SB2->( dbSkip() )
	End

Return


//ROTINA ORIGINAL AUTOR HELIO

Static Function AcertaSB9()
/*
cTexto := "Este programa tem o objetivo de calcular o saldos dos produtos nas datas em que foram realizados os fechamentos de estoque "
cTexto += "no intervalo de datas dos parâmetros e comparar com os saldos iniciais do próximo período (SB9) gerados pelo sistema. Caso os "
cTexto += "saldos em quantidade ou valor calculados pelos movimentos do estoque (função CalcEst()) estejam diferentes do SB9, esta rotina "
cTexto += "irá apresentar os saldos calculados e os gravados no SB9 e dará a possibilidade de alteração imediata. Caso não deseje efetuar "
cTexto += "a alteração, será possível cancelar a continuação do programa. ESTE PROGRAMA DEVERÁ SER EXECUTADO APÓS O FECHAMENTO PARA VALIDAR "
cTexto += "SE O MESMO FOI FEITO CORRETAMENTE."

BatchProcess("Acerto dos Saldos Iniciais (SB9)",cTexto,"ACERTASB9",{ || Processa({|lEnd| Procsb9() },OemToAnsi("Acerto dos Saldos Iniciais (SB9)"),OemToAnsi("Varrendo os fechamentos de estoque (SB9)"),.F.)})
*/
Procsb9()


Return

Static Function Procsb9()
Private lCorrige := .T.

SBJ->( dbSetOrder(1) )

cQuery := "SELECT COUNT(*) AS NTOTAL FROM SB9010 WHERE B9_FILIAL = '"+xFilial("SB9")+"' AND B9_DATA >= '"+DtoS(dMvUlmes)+"' AND B9_DATA <= '"+DtoS(dMvUlmes)+"' AND D_E_L_E_T_ = '' "
//cQuery += " AND B9_COD >= '"+mv_par03+"' AND B9_COD <= '"+mv_par04+"' "

If Select("CONTAGEM") <> 0
	CONTAGEM->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "CONTAGEM"

PROCREGUA(CONTAGEM->NTOTAL)

cQuery := "SELECT R_E_C_N_O_ FROM SB9010 WHERE B9_FILIAL = '"+xFilial("SB9")+"' AND B9_DATA >= '"+DtoS(dMvUlmes)+"' AND B9_DATA <= '"+DtoS(dMvUlmes)+"' AND D_E_L_E_T_ = '' "
//cQuery += " AND B9_COD >= '"+mv_par03+"' AND B9_COD <= '"+mv_par04+"' "

If Select("QUERYSB9") <> 0
	QUERYSB9->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYSB9"

While !QUERYSB9->( EOF() )
	SB9->( dbGoTo(QUERYSB9->R_E_C_N_O_) )
	If SB9->( Recno() ) == QUERYSB9->R_E_C_N_O_
		cProduto := SB9->B9_COD
		cLocal   := SB9->B9_LOCAL
		dData    := (SB9->B9_DATA + 1)
		nQini    := SB9->B9_QINI
		nVini    := SB9->B9_VINI1
		
		If Reclock("SB9",.F.)
			SB9->( dbDelete() )
			SB9->( msUnlock() )
			aSaldoEst := CalcEst(cProduto, cLocal, dData )
			TCSQLEXEC("UPDATE SB9010 SET D_E_L_E_T_ = '', R_E_C_D_E_L_ = 0 WHERE R_E_C_N_O_ = "+Str(QUERYSB9->R_E_C_N_O_) )
			SB9->( dbGoTo(QUERYSB9->R_E_C_N_O_) )
			If SB9->( Recno() ) == QUERYSB9->R_E_C_N_O_
				If aSaldoEst[1] <> nQini .or. aSaldoEst[2] <> nVini
					lCorrige := .T.
					//If mv_par05 == 1
					//	If !MsgYesNo('Produto: '+SB9->B9_COD+' Local: '+SB9->B9_LOCAL+' Data: '+DtoC(SB9->B9_DATA)+Chr(13)+'Qtd SB9: ' + Alltrim(Str(SB9->B9_QINI)) + ' Qtd Calc: ' + Alltrim(Str(aSaldoEst[1])) + ' Vlr SB9 ' + Alltrim(Str(SB9->B9_VINI1)) + ' Vlr Calc: ' + Alltrim(Str(aSaldoEst[2]))+Chr(13)+'Deseja corrigir o SB9 Recno(): '+Alltrim(Str(SB9->(Recno())))+'?')
					//		lCorrige := .F.
					//	EndIf
					//EndIf
					If lCorrige
						Reclock("SB9",.F.)
						SB9->B9_QINI  := aSaldoEst[1]
						SB9->B9_VINI1 := aSaldoEst[2]
						SB9->( msUnlock() )
					Else
						If MsgYesNo('Deseja sair do programa?')
							Return
						EndIf
					EndIf
				EndIf
				If Rastro(SB9->B9_COD) .and. lCorrige
					nQtdB8 := 0

					cQuery := "SELECT * FROM "+RetSqlName("SB8")+" WHERE B8_FILIAL = '"+xFilial("SB8")+"' AND B8_PRODUTO = '"+SB9->B9_COD+"' AND B8_LOCAL = '"+SB9->B9_LOCAL+"' AND D_E_L_E_T_ = '' "
					
					If Select("QUERYSB8") <> 0
						QUERYSB8->( dbCloseArea() )
					EndIf
					
					TCQUERY cQuery NEW ALIAS "QUERYSB8"
					
					While !QUERYSB8->( EOF() )
						cProduto  := QUERYSB8->B8_PRODUTO
						cLocal    := QUERYSB8->B8_LOCAL
						cLoteCtl  := QUERYSB8->B8_LOTECTL
						cLote     := QUERYSB8->B8_NUMLOTE
						cLocaliza := ''
						cNumSerie := ''
						
						If SBJ->( dbSeek( xFilial("SBJ") + cProduto + cLocal + cLoteCtl + cLote + DtoS(SB9->B9_DATA) ) )
							nRecSBJ := SBJ->( Recno() )
						Else
							nRecSBJ := 0
						EndIf
						
						If !Empty(nRecSBJ)
							If Reclock("SBJ",.F.)
								SBJ->( dbDelete() )
								SBJ->( msUnlock() )
							Else
								MsgStop('Não foi possível travar o SBJ, recno: ' + Str(SBJ->( Recno() )))
								If MsgYesNo('Deseja sair do programa?')
									Return
								EndIf
							EndIf
						EndIf
						
						aSaldo    := CalcEstL(cProduto, cLocal, dData,cLoteCtl,cLote,cLocaliza,cNumSerie)
						
						If !Empty(nRecSBJ)
						   TCSQLEXEC("UPDATE SBJ010 SET D_E_L_E_T_ = '', R_E_C_D_E_L_ = 0 WHERE R_E_C_N_O_ = "+Str(nRecSBJ) )
						EndIf
						
						nQtdB8 += aSaldo[1]

						QUERYSB8->( dbSkip() )
					End
					   
					If nQtdB8 <> aSaldoEst[1]
					  // Alert('Erro saldo por lote')
					EndIf
				EndIf
			Else
				MsgStop('Recno não encontrado no SB9: ' + Str(QUERYSB9->R_E_C_N_O_))
				If MsgYesNo('Deseja sair do programa?')
					Return
				EndIf
			EndIf
		Else
			MsgStop('Não foi possível travar o SB9')
			If MsgYesNo('Deseja sair do programa?')
				Return
			EndIf
		EndIf
	Else
		MsgStop('Recno não encontrado no SB9: ' + Str(QUERYSB9->R_E_C_N_O_))
		If MsgYesNo('Deseja sair do programa?')
			Return
		EndIf
	EndIf
	QUERYSB9->( dbSkip() )
	IncProc()
End

MsgStop('Fim da execução da validação.')

Return


//CORRIGE ITENS COM PRIMEIRO MOVIMENTO, SEM CM1 GRAVADO NO SB9
Static Function SEMMOVB9()
Local cQuery 

cLogCus := "Log de Analise de produtos sem CM1 no SB9"+ENTER


//SELECIONA TODOS LOCAL DISPONIVEIS
cQuery := " SELECT ARM, PRODUTO, ROUND(SUM(CUSTO)/SUM(QTD),4) AS CM1 FROM "
cQuery += " ( "
cQuery += " SELECT D3_LOCAL AS ARM, D3_COD AS PRODUTO, SUM(D3_QUANT) AS QTD, SUM(D3_CUSTO1) AS CUSTO FROM SD3010 (NOLOCK) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D_E_L_E_T_='' AND D3_ESTORNO <>'S' AND D3_EMISSAO BETWEEN '"+DTOS(dGet1)+"' AND '"+DTOS(dGet2)+"' AND D3_LOCAL='01' AND D3_CUSTO1<>0 AND D3_QUANT<>0 GROUP BY D3_LOCAL, D3_COD "
cQuery += " UNION ALL "
cQuery += " SELECT D1_LOCAL AS ARM, D1_COD AS PRODUTO, SUM(D1_QUANT) AS QTD, SUM(D1_CUSTO) AS CUSTO FROM SD1010 (NOLOCK) WHERE D1_FILIAL='"+xFilial("SD1")+"' AND D_E_L_E_T_=''  AND D1_DTDIGIT BETWEEN '"+DTOS(dGet1)+"' AND '"+DTOS(dGet2)+"' AND D1_LOCAL='01' AND D1_CUSTO<>0 AND D1_QUANT<>0 GROUP BY D1_LOCAL, D1_COD "
cQuery += " UNION ALL "
cQuery += " SELECT D2_LOCAL AS ARM, D2_COD AS PRODUTO, SUM(D2_QUANT) AS QTD, SUM(D2_CUSTO1) AS CUSTO  FROM SD2010 (NOLOCK) WHERE D2_FILIAL='"+xFilial("SD2")+"' AND D_E_L_E_T_='' AND D2_EMISSAO BETWEEN '"+DTOS(dGet1)+"' AND '"+DTOS(dGet2)+"' AND D2_LOCAL='01' AND D2_CUSTO1<>0  AND D2_QUANT<>0 GROUP BY D2_LOCAL, D2_COD "
cQuery += " ) AS AGL_LOCAL "
cQuery += " GROUP BY ARM, PRODUTO "


If Select("MOVB9") <> 0
	MOVB9->( dbCloseArea() )
EndIf
                                                                                                         
TCQUERY cQuery NEW ALIAS "MOVB9"

While	MOVB9->(!EOF())                   
	If SB9->(DBSEEK(xFilial("SB9")+MOVB9->PRODUTO+MOVB9->ARM) )
    	while SB9->(!EOF()) .AND. SB9->B9_LOCAL=MOVB9->ARM .and. SB9->B9_COD=MOVB9->PRODUTO
        	If EMPTY(SB9->B9_DATA) .OR. DTOS(SB9->B9_DATA)==DTOS(dMvUlmes)
            	Reclock("SB9",.F.)
            	SB9->B9_CM1 := MOVB9->CM1
            	SB9->(msunlock())
				If !lLog
					cLogCus += "Foram encontrados itens com divegencia: "	+ ENTER     
					cLogCus += "+---------------+--------+--+----------------+" + ENTER  
				EndIf 
				cLogCus += '|' +MOVB9->PRODUTO+ '|' +DTOC(SB9->B9_DATA)+ '|' + MOVB9->ARM+ '|' +  TRANSFORM(MOVB9->CM1, "@E 9,999,999,999.99")  + '|' + ENTER
				lLog	:= .t.
            	Exit
        	EndIf
       		SB9->( DBsKIP())    
    	End
	else
    	Reclock("SB9",.T.)
    	SB9->B9_FILIAL  := xFilial("SB9")
    	SB9->B9_COD     := MOVB9->PRODUTO
    	SB9->B9_LOCAL   := MOVB9->ARM
    	SB9->B9_MCUSTD  := "1"
    	SB9->B9_CM1     := MOVB9->CM1
    	SB9->(msunlock())            
		If !lLog
			cLogCus += "Foram encontrados itens com divegencia: "	+ ENTER     
			cLogCus += "+---------------+--------+--+----------------+" + ENTER  
		EndIf 
		cLogCus += '|' +MOVB9->PRODUTO+ '|' +DTOC(SB9->B9_DATA)+ '|' + MOVB9->ARM+ '|' +  TRANSFORM(MOVB9->CM1, "@E 9,999,999,999.99")  + '|' + ENTER
		lLog	:= .t.
	ENDIF
	MOVB9->( DbSkip() )
Enddo

If !lLog
	cLogCus += "Nao foram encontrados itens SEM CM1 "	+ ENTER
Else
	cLogCus += "+---------------+--------+--+----------------+" + ENTER  
EndIf

//Sleep( 10000 )

Return                                                                    
