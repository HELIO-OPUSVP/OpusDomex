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
±±ºPrograma  CTBEIC02  ºAutor  ³Jonas Pereira      º Data ³  11/02/2022   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Conferencia de contabilizacao                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CTBEIC02()     

Local lHasButton 	:= .T.
Local oDlg           
  

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
Private cCadastro := "Check List de Importação"
Private cTit		:= "Check List de Importação / Processando"
Private lAll      := .F.
Private lOpt      := .F.                    
Private lPerAnt   := .f.
Private nContPer  := 0
Private oMemo1
Private cTxtMemo1   := ''
Private SaveTexto 
Private SaveProjet
Private bSaveProjet
Private cFornece := ' - '
Private lfirst := .t.
Private nProcessos := 0

Static oFWLayer
Static oWin1
Static oWin2
Static oWin3
Static oWin4
Static oWin5

Static aHeader    := {}
Static aCols      := {}      


Static baHeader    := {}
Static baCols      := {}   
                                   
//X31UPDTABLE("ZZB")

aSize	            := MsAdvSize( .F. )
aInfo 	         := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }

AAdd( aObjects, { 100	, 050	, .T., .F. })
AAdd( aObjects, { 100	, 100	, .T., .T. })

aPosObj	         := MsObjSize(aInfo,aObjects)
aPosGet	         := MsObjGetPos((aSize[3]-aSize[1]),315,{{004,024,240,270}} )     
  
 
DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd STYLE nOR( WS_VISIBLE,WS_POPUP ) PIXEL

	oDlg:lEscClose := .F.
	                                                               	
	oFWLayer := FWLayer():New()		
	oFWLayer:Init(oDlg,.F.)
                                        
	//oFWLayer:AddLine( "UP",      18, .F. ) 
	oFWLayer:AddLine( "MEDIUM",  82, .F. ) 
	oFWLayer:AddLine( "DOWN",    18, .F. ) 
	
	//oFWLayer:AddCollumn("Col01",100,.T.,"UP"    )
	oFWLayer:AddCollumn("Col02",40,.T. ,"MEDIUM")
	oFWLayer:AddCollumn("Col03",60,.T. ,"MEDIUM")
	oFWLayer:AddCollumn("Col04",50,.T. ,"DOWN"  )
  	oFWLayer:AddCollumn("Col05",50,.T. ,"DOWN"  )	

	//oFWLayer:AddWindow("Col01","Win01"	,"Periodo"	,100,.F.,.F.,/*bAction*/     ,"UP"    /*cIDLine*/,/*bGotFocus*/)	
	oFWLayer:AddWindow("Col02","Win02"	,"Processos EIC "	    ,100,.F.,.F., 					  ,"MEDIUM"/*cIDLine*/,/*bGotFocus*/)
	oFWLayer:AddWindow("Col03","Win03"	,"Detalhes do processo"						,100,.F.,.F.,/*bAction*/     ,"MEDIUM"/*cIDLine*/,/*bGotFocus*/)	
	oFWLayer:AddWindow("Col04","Win04"	,"Periodo" ,100,.F.,.F.,/*bAction*/     ,"DOWN"  /*cIDLine*/,/*bGotFocus*/)		
  	oFWLayer:AddWindow("Col05","Win05"	,"Ações" ,100,.F.,.F.,/*bAction*/     ,"DOWN"  /*cIDLine*/,/*bGotFocus*/) 
	
	//oWin1 := oFWLayer:GetWinPanel('Col01','Win01',"UP")
	oWin2 := oFWLayer:GetWinPanel('Col02','Win02',"MEDIUM")
	oWin3 := oFWLayer:GetWinPanel('Col03','Win03',"MEDIUM")
	oWin4 := oFWLayer:GetWinPanel('Col04','Win04',"DOWN")
	oWin5 := oFWLayer:GetWinPanel('Col05','Win05',"DOWN")




	oTBitmapExe     := TBitmap():New(01,020,100,50,,cFileExe,.T.,oWin5,   {||  U_ProcTB01(dGet1, dGet1, oGetDados:aCols[oGetDados:oBrowse:nat][2] ) },,.F.,.F.,,,.F.,,.T.,,.F.)
   oTBitmapExe:lAutoSize := .T. 

   oTBitmapSair    := TBitmap():New(02,270,001,50,,cFileExit,.T.,oWin5,   {|| oDlg:End() },,.F.,.F.,,,.F.,,.T.,,.F.)
   oTBitmapSair:lAutoSize := .T. 



   	oGetDTIni:= TGet():New(010, 001, { | u | If( PCount() == 0, dGet1, dGet1 := u ) },oWin4, ;
 	045, 010, "@D",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dGet1",,,,lHasButton  )   

	
	oGetDTFim:= TGet():New(010, 050, { | u | If( PCount() == 0, dGet2, dGet2 := u ) },oWin4, ;
 	045, 010, "@D", , 0, 16777215,,.F.,,.T.,,.F.,,.f., .f.,,.F.,.F. ,,"dGet2",,,,lHasButton  )  
	
	oFont  := TFont():New('Courier new',,-18,.T.)
	oSay3:= TSay():New(010,100,{||str(nProcessos)+' Processos filtrados'},oWin4,,oFont,,,,.T.,CLR_HRED,CLR_WHITE,200,20) 
		
    
   /*
	oGetUlmes:= TGet():New(010, 001, { | u | If( PCount() == 0, dMvUlmes, dMvUlmes := u ) },oWin1, ;
 	045, 010, "@D",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F. ,,"dMvUlmes",,,,lHasButton  )   
   
   oGetUlmes:Disable()
      
   oSay3:= TSay():New(01,01,{||'DT. Ulmes'},oWin1,,oFont,,,,.T.,CLR_HGRAY,CLR_WHITE,200,20) 
        
	oGet1:= TGet():New(010, 055, { | u | If( PCount() == 0, dGet1, dGet1 := u ) },oWin1, ;
 	060, 010, "@D",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dGet1",,,,lHasButton  )
	
	oSay4:= TSay():New(01,55,{||'DT. Inicio'},oWin1,,oFont,,,,.T.,CLR_HGRAY,CLR_WHITE,200,20) 
	   
 	
   oGet2:=TGet():New( 010, 115, { | u | If( PCount() == 0, dGet2, dGet2 := u ) },oWin1, ;   
   060, 010,"@D",/*cValid*//*{||.T.},0,16777215,,.F.,,.T.,  ,.F.,/*cWhen*/ /*{||.T.},.F.,.F.,,.F.,.F.,"dGet1",,,,,.f.)*/
 	/*
 	oSay5:= TSay():New(01,115,{||'DT. Fim'},oWin1,,oFont,,,,.T.,CLR_HGRAY,CLR_WHITE,200,20) 
	          
   
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
   */


  	 // Cria Fonte para visualizaï¿½ï¿½o
 	oFont  := TFont():New('Courier new',,-18,.T.)
 	oFMemo := TFont():New('Courier new',,-13,.T.)
   
  /*
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
	             */                       

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

	aadd(aHeader, {""     		   		  , "LEGENDA"   , "@BMP"             , 01       , 0         ,""       , ""      , "C"    , ""        ,,})
	aadd(aHeader, {"Imp. N"        		  , "DESCRI"    , "@!"               , 17       , 0         ,""       , ""      , "C"    , ""        ,,})
	aadd(aHeader, {"Data"       		  , "PERIOD"    , "@!"               , 10       , 0         ,""       , ""      , "C"    , ""        ,,})
	aadd(aHeader, {"Conferido por:"       , "USUARIO"   , "@!"               , 15       , 0         ,""       , ""      , "C"    , ""        ,,})
	aadd(aHeader, {"Data"          		  , "DATA"      , "@!"               , 10       , 0         ,""       , ""      , "C"    , ""        ,,})
	aadd(aHeader, {"Hora"          		  , "HORA"      , "@!"               , 08       , 0         ,""       , ""      , "C"    , ""        ,,})
	//aadd(aHeader, {"Interno"       , "RECNO"     , "@E"               , 01       , 0         ,""       , ""      , "C"    , ""        ,,})
          


	aAdd(aCols,Array(Len(aHeader)+1))
	aCols[Len(aCols),Len(aHeader)+1] := .F.

	//Execuï¿½ï¿½o das rotinas
	oGetDados := MsNewGetDados():New(01,01,221,262,cGetOpc,cLinhaOk,cTudoOk,cIniCpos,,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oWin2,aHeader,aCols)

	SaveProjet   := aClone(oGetDados:aCols)

	//oGetDados:oBrowse:bChange := { |nIndo| fGetnf(oGetDados:aCols[oGetDados:oBrowse:nat][2]) }

	oGetDados:oBrowse:bChange := { |nIndo| fGetnf(oGetDados:aCols,oGetDados:oBrowse:nat) }

	fGetdados()
      
    
	//GETDADOS INICIO 2
	bcGetOpc        := Nil                              // GD_INSERT+GD_DELETE+GD_UPDATE
	bcLinhaOk       := AllwaysTrue()                    // Funcao executada para validar o contexto da linha atual do aCols
	bcTudoOk        := AllwaysTrue()                    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
	bcIniCpos       := Nil                              // Nome dos campos do tipo caracter que utilizarao incremento automatico.
	bnFreeze        := Nil                              // Campos estaticos na GetDados.
	bnMax           := 999                              // Numero maximo de linhas permitidas. Valor padrao 99
	bcCampoOk       := Nil                              // Funcao executada na validacao do campo
	bcSuperApagar   := Nil                              // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
	bcApagaOk       := "U_CadYYYDel"                    // Funcao executada para validar a exclusao de uma linha do aCols
	baHeader        := {}                               // Array do aHeader
	baCols          := {}                               // Array do aCols

	baHeader := {}
	//             X3_TITULO          , X3_CAMPO  , X3_PICTURE        ,X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT

	aadd(baHeader, {"Processo"            , "HAWB"         , "@!"               , 15       , 0                               ,""           , ""              , "C"             , ""        ,,})
	aadd(baHeader, {"Nota / Serie"        , "DOC"          , "@!"               , 15       , 0                               ,""           , ""              , "C"             , ""        ,,})
	aadd(baHeader, {"Fornecedor:"         , "FORNECEDOR"   , "@!"               , 40       , 0                               ,""           , ""              , "C"             , ""        ,,})
	aadd(baHeader, {"Valor Nota:" 	  	  , "VLRNF"        , "@E 999,999,999.99", 10       , fX3Ret("CT2_VALOR","X3_DECIMAL"), ""          , "€€€€€€€€€€€€€€", "N"             , ""        ,,})
	aadd(baHeader, {"Valor Baixa:" 	  	  , "VLRBAIXA"     , "@E 999,999,999.99", 10       , fX3Ret("CT2_VALOR","X3_DECIMAL"), ""          , "€€€€€€€€€€€€€€", "N"             , ""        ,,})
	aadd(baHeader, {"CFOP"                , "CF"           , "@!"               , 4       , 0                               ,""           , ""              , "C"             , ""        ,,})	//aadd(baHeader, {"CFOP"                , "CF"           , "@!"               , 4        , 0                               ,""           , ""              , "C"             , ""        ,,})
	
	//aadd(aHeader, {"Interno"       , "RECNO"     , "@E"               , 01       , 0         ,""       , ""      , "C"    , ""        ,,})
          


	aAdd(baCols,Array(Len(baHeader)+1))
	baCols[Len(baCols),Len(baHeader)+1] := .F.

	//Execuï¿½ï¿½o das rotinas
	oGetDadosb := MsNewGetDados():New(01,01,085,396,bcGetOpc,bcLinhaOk,bcTudoOk,bcIniCpos,,bnFreeze,bnMax,bcCampoOk,bcSuperApagar,bcApagaOk,oWin3,baHeader,baCols)
	bSaveProjet   := aClone(oGetDadosb:aCols)
//get 2 fim


	//GETDADOS INICIO 3
	ccGetOpc        := Nil                              // GD_INSERT+GD_DELETE+GD_UPDATE
	ccLinhaOk       := AllwaysTrue()                    // Funcao executada para validar o contexto da linha atual do aCols
	ccTudoOk        := AllwaysTrue()                    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
	ccIniCpos       := Nil                              // Nome dos campos do tipo caracter que utilizarao incremento automatico.
	cnFreeze        := Nil                              // Campos estaticos na GetDados.
	cnMax           := 999                              // Numero maximo de linhas permitidas. Valor padrao 99
	ccCampoOk       := Nil                              // Funcao executada na validacao do campo
	ccSuperApagar   := Nil                              // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
	ccApagaOk       := "U_CadYYYDel"                    // Funcao executada para validar a exclusao de uma linha do aCols
	caHeader        := {}                               // Array do aHeader
	caCols          := {}                               // Array do aCols

	caHeader := {}
	//             X3_TITULO          , X3_CAMPO  , X3_PICTURE        ,X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT

	aadd(caHeader, {"Fornecedor:"         , "FORNECEDOR"   , "@!"               , 40       , 0                               ,""           , ""              , "C"             , ""        ,,})
	aadd(caHeader, {"DI (R$)"             , "VALDI"        , "@E 999,999,999.99", 10       , fX3Ret("CT2_VALOR","X3_DECIMAL"), ""          , "€€€€€€€€€€€€€€", "N"             , ""        ,,})
	aadd(caHeader, {"Cob Camb?"           , "COB"          , "@!"               , 3        , 0                               ,""           , ""              , "C"             , ""        ,,})
	aadd(caHeader, {"DT DI"               , "DTDI"         , "@!"               , 10       , 0                               ,""           , ""              , "C"             , ""        ,,})	
	aadd(caHeader, {"Moeda"               , "MOEDA"        , "@!"               , 3        , 0                               ,""           , ""              , "C"             , ""        ,,})
	aadd(caHeader, {"TX"        	  	  , "TX"           , "@E 99.99"			, 4        , fX3Ret("CT2_VALOR","X3_DECIMAL"), ""          , "€€€€€€€€€€€€€€", "N"             , ""        ,,})
	aadd(caHeader, {"Valor Moeda" 	  	  , "VLRMOEDA"     , "@E 999,999,999.99", 10       , fX3Ret("CT2_VALOR","X3_DECIMAL"), ""          , "€€€€€€€€€€€€€€", "N"             , ""        ,,})
	//aadd(aHeader, {"Interno"       , "RECNO"     , "@E"               , 01       , 0         ,""       , ""      , "C"    , ""        ,,})
          


	aAdd(caCols,Array(Len(caHeader)+1))
	caCols[Len(caCols),Len(caHeader)+1] := .F.

	//Execuï¿½ï¿½o das rotinas
	oGetDadosc := MsNewGetDados():New(085,01,118,396,ccGetOpc,ccLinhaOk,ccTudoOk,ccIniCpos,,cnFreeze,cnMax,ccCampoOk,ccSuperApagar,ccApagaOk,oWin3,caHeader,caCols)
	cSaveProjet   := aClone(oGetDadosc:aCols)
//get 3 fim


	//GETDADOS INICIO 4
	dcGetOpc        := Nil                              // GD_INSERT+GD_DELETE+GD_UPDATE
	dcLinhaOk       := AllwaysTrue()                    // Funcao executada para validar o contexto da linha atual do aCols
	dcTudoOk        := AllwaysTrue()                    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
	dcIniCpos       := Nil                              // Nome dos campos do tipo caracter que utilizarao incremento automatico.
	dnFreeze        := Nil                              // Campos estaticos na GetDados.
	dnMax           := 999                              // Numero maximo de linhas permitidas. Valor padrao 99
	dcCampoOk       := Nil                              // Funcao executada na validacao do campo
	dcSuperApagar   := Nil                              // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
	dcApagaOk       := "U_CadYYYDel"                    // Funcao executada para validar a exclusao de uma linha do aCols
	daHeader        := {}                               // Array do aHeader
	daCols          := {}                               // Array do aCols

	daHeader := {}
	//             X3_TITULO          , X3_CAMPO  , X3_PICTURE        ,X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT

	aadd(daHeader, {"Capatazia" 	  	  , "CAPATAZIA"       , "@E 999,999,999.99", 09       , fX3Ret("CT2_VALOR","X3_DECIMAL"), ""          , "€€€€€€€€€€€€€€", "N"             , ""        ,,})
	aadd(daHeader, {"Armazenagem" 	  	  , "ARMAZENAGEM"     , "@E 999,999,999.99", 09       , fX3Ret("CT2_VALOR","X3_DECIMAL"), ""          , "€€€€€€€€€€€€€€", "N"             , ""        ,,})
	aadd(daHeader, {"Seguro"    	  	  , "SEGURO"          , "@E 999,999,999.99", 09       , fX3Ret("CT2_VALOR","X3_DECIMAL"), ""          , "€€€€€€€€€€€€€€", "N"             , ""        ,,})
	aadd(daHeader, {"Frete Nacional"  	  , "DESPACHANTE"     , "@E 999,999,999.99", 09       , fX3Ret("CT2_VALOR","X3_DECIMAL"), ""          , "€€€€€€€€€€€€€€", "N"             , ""        ,,})
	//aadd(daHeader, {"Nacionalizacao" 	  , "NACIONA" 		  , "@E 999,999,999.99", 09       , fX3Ret("CT2_VALOR","X3_DECIMAL"), ""          , "€€€€€€€€€€€€€€", "N"             , ""        ,,})
	aadd(daHeader, {"Emissao LI" 	  	  , "LI" 		      , "@E 999,999,999.99", 09       , fX3Ret("CT2_VALOR","X3_DECIMAL"), ""          , "€€€€€€€€€€€€€€", "N"             , ""        ,,})
	//aadd(daHeader, {"Taxa Embarque" 	  , "TXEMB"		      , "@E 999,999,999.99", 09       , fX3Ret("CT2_VALOR","X3_DECIMAL"), ""          , "€€€€€€€€€€€€€€", "N"             , ""        ,,})

	//aadd(aHeader, {"Interno"       , "RECNO"     , "@E"               , 01       , 0         ,""       , ""      , "C"    , ""        ,,})
          


	aAdd(daCols,Array(Len(daHeader)+1))
	daCols[Len(daCols),Len(daHeader)+1] := .F.

	//Execuï¿½ï¿½o das rotinas
	oGetDadosd := MsNewGetDados():New(119,01,152,396,dcGetOpc,dcLinhaOk,dcTudoOk,dcIniCpos,,dnFreeze,dnMax,dcCampoOk,dcSuperApagar,dcApagaOk,oWin3,daHeader,daCols)
	dSaveProjet   := aClone(oGetDadosd:aCols)
//get 4 fim




	//GETDADOS INICIO 5
	ecGetOpc        := Nil                              // GD_INSERT+GD_DELETE+GD_UPDATE
	ecLinhaOk       := AllwaysTrue()                    // Funcao executada para validar o contexto da linha atual do aCols
	ecTudoOk        := AllwaysTrue()                    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
	ecIniCpos       := Nil                              // Nome dos campos do tipo caracter que utilizarao incremento automatico.
	enFreeze        := Nil                              // Campos estaticos na GetDados.
	enMax           := 999                              // Numero maximo de linhas permitidas. Valor padrao 99
	ecCampoOk       := Nil                              // Funcao executada na validacao do campo
	ecSuperApagar   := Nil                              // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
	ecApagaOk       := "U_CadYYYDel"                    // Funcao executada para validar a exclusao de uma linha do aCols
	eaHeader        := {}                               // Array do aHeader
	eaCols          := {}                               // Array do aCols

	eaHeader := {}
	//             X3_TITULO          , X3_CAMPO  , X3_PICTURE        ,X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT

	aadd(eaHeader, {"Demonstrativo" 	  , "DEMONSTRAT"      , "@!"               , 10       , 0                               ,""           , ""              , "C"             , ""        ,,})
	aadd(eaHeader, {"Serv. Despa." 	  	  , "SERVDES" 		  , "@E 999,999,999.99", 09       , fX3Ret("CT2_VALOR","X3_DECIMAL"), ""          , "€€€€€€€€€€€€€€", "N"             , ""        ,,})
	aadd(eaHeader, {"PCC Servico" 	  	  , "PCC"             , "@E 999,999,999.99", 09       , fX3Ret("CT2_VALOR","X3_DECIMAL"), ""          , "€€€€€€€€€€€€€€", "N"             , ""        ,,})
	aadd(eaHeader, {"IR Servico"    	  , "IR"              , "@E 999,999,999.99", 09       , fX3Ret("CT2_VALOR","X3_DECIMAL"), ""          , "€€€€€€€€€€€€€€", "N"             , ""        ,,})
	aadd(eaHeader, {"Vlr S/ Cobertura R$ "   , "VLRSCOBR"     , "@E 999,999,999.99", 09       , fX3Ret("CT2_VALOR","X3_DECIMAL"), ""          , "€€€€€€€€€€€€€€", "N"             , ""        ,,})
	aadd(eaHeader, {"Vlr S/ Cobertura    "   , "VLRSCOBE"     , "@E 999,999,999.99", 09       , fX3Ret("CT2_VALOR","X3_DECIMAL"), ""          , "€€€€€€€€€€€€€€", "N"             , ""        ,,})
	
	
	//aadd(aHeader, {"Interno"       , "RECNO"     , "@E"               , 01       , 0         ,""       , ""      , "C"    , ""        ,,})
          


	aAdd(eaCols,Array(Len(eaHeader)+1))
	eaCols[Len(eaCols),Len(eaHeader)+1] := .F.

	//Execuï¿½ï¿½o das rotinas
	oGetDadose := MsNewGetDados():New(153,01,186,396,ecGetOpc,ecLinhaOk,dcTudoOk,ecIniCpos,,enFreeze,enMax,ecCampoOk,ecSuperApagar,ecApagaOk,oWin3,eaHeader,eaCols)
	eSaveProjet   := aClone(oGetDadose:aCols)
//get 5 fim



	//GETDADOS INICIO 6
	fcGetOpc        := Nil                              // GD_INSERT+GD_DELETE+GD_UPDATE
	fcLinhaOk       := AllwaysTrue()                    // Funcao executada para validar o contexto da linha atual do aCols
	fcTudoOk        := AllwaysTrue()                    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
	fcIniCpos       := Nil                              // Nome dos campos do tipo caracter que utilizarao incremento automatico.
	fnFreeze        := Nil                              // Campos estaticos na GetDados.
	fnMax           := 999                              // Numero maximo de linhas permitidas. Valor padrao 99
	fcCampoOk       := Nil                              // Funcao executada na validacao do campo
	fcSuperApagar   := Nil                              // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
	fcApagaOk       := "U_CadYYYDel"                    // Funcao executada para validar a exclusao de uma linha do aCols
	faHeader        := {}                               // Array do aHeader
	faCols          := {}                               // Array do aCols

	faHeader := {}
	//             X3_TITULO          , X3_CAMPO  , X3_PICTURE        ,X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT

	aadd(faHeader, {"Agente Carga:"       , "AGENTE"          , "@!"               , 40       , 0                               ,""           , ""              , "C"             , ""        ,,})
	aadd(faHeader, {"Vlr. Fatura:" 	  	  , "FATURA"          , "@E 999,999,999.99", 09       , fX3Ret("CT2_VALOR","X3_DECIMAL"), ""          , "€€€€€€€€€€€€€€", "N"             , ""        ,,})
	aadd(faHeader, {"Frete DI:"   	  	  , "FRETEDI"         , "@E 999,999,999.99", 09       , fX3Ret("CT2_VALOR","X3_DECIMAL"), ""          , "€€€€€€€€€€€€€€", "N"             , ""        ,,})
	aadd(faHeader, {"Diferencial Frete:"  , "DIFFRETE"        , "@E 999,999,999.99", 09       , fX3Ret("CT2_VALOR","X3_DECIMAL"), ""          , "€€€€€€€€€€€€€€", "N"             , ""        ,,})
	aadd(faHeader, {"Bx. Fr. Entrep.:" 	  , "BXFREENT" 		  , "@E 999,999,999.99", 09       , fX3Ret("CT2_VALOR","X3_DECIMAL"), ""          , "€€€€€€€€€€€€€€", "N"             , ""        ,,})
	

	//aadd(aHeader, {"Interno"       , "RECNO"     , "@E"               , 01       , 0         ,""       , ""      , "C"    , ""        ,,})
          


	aAdd(faCols,Array(Len(faHeader)+1))
	faCols[Len(faCols),Len(faHeader)+1] := .F.

	//Execuï¿½ï¿½o das rotinas
	oGetDadosf := MsNewGetDados():New(187,01,220,396,fcGetOpc,fcLinhaOk,fcTudoOk,fcIniCpos,,fnFreeze,fnMax,fcCampoOk,fcSuperApagar,fcApagaOk,oWin3,faHeader,faCols)
	fSaveProjet   := aClone(oGetDadosf:aCols)
//get 6 fim




ACTIVATE MSDIALOG oDlg CENTERED
                                            

Return Nil           



Static function fGetitems(cNumProc)
local cQuery := ""



cQuery += "  SELECT W6_HAWB, "
cQuery += "  W6_FOB_GER AS VALTOT,  "                                                   // Valor DI         "
cQuery += "  CASE WHEN COB.COBERTURA IS NULL THEN 'SIM' ELSE 'NAO' END AS COBCAMB, "     // Cobertura Cambial "
cQuery += "  CASE WHEN INV.TXINV IS NULL THEN 0 ELSE INV.TXINV END AS TX,	"          // Taxa               "         
cQuery += "  CASE WHEN INV.MOEDAINV IS NULL THEN '' ELSE INV.MOEDAINV END AS MOEDA,   "             // Moeda "
cQuery += "  CASE WHEN INV.TXINV IS NULL OR INV.TXINV <= 0  OR  W6_FOB_GER IS NULL  OR  W6_FOB_GER <= 0 "
cQuery += "  THEN 0 ELSE ROUND(W6_FOB_GER/INV.TXINV,2)  END AS VALDI, "                          // Valor DI MOEDA ESTRANGEIRA   "                     
cQuery += "  W6_VLSEGMN AS SEGEST,	"												   // Seguro Estocagem "
cQuery += "  W6_DT_NF AS DTPROCE,   "                                                  // Data DI "
cQuery += "  W6_REF_DES AS NADEMONST,   "                                                // Demonstrativo "
cQuery += "  CASE WHEN WD721.VALOR721 IS NULL THEN 0 ELSE WD721.VALOR721 END AS VAL721, " // Emissao LI "
cQuery += "  CASE WHEN WD721.VALOR721 IS NULL THEN 0 ELSE WD721.VALOR721 END AS VAL721, " // Emissao LI "
cQuery += "  CASE WHEN WD416.VALOR416 IS NULL THEN 0 ELSE WD416.VALOR416 END AS VAL416, " // Armazenagem "
cQuery += "  CASE WHEN WD333.VALOR333 IS NULL THEN 0 ELSE WD333.VALOR333 END AS VAL333, "// Taxa Embarque "
cQuery += "  CASE WHEN WD431.VALOR431 IS NULL THEN 0 ELSE WD431.VALOR431 END AS VAL431, "// Capatazia "
cQuery += "  CASE WHEN WD406.VALOR406 IS NULL THEN 0 ELSE WD406.VALOR406 END AS VAL406, "// Despachante "
cQuery += "  CASE WHEN WD623.VALOR623 IS NULL THEN 0 ELSE WD623.VALOR623 END AS VAL623, "// PCC Servico  "
cQuery += "  CASE WHEN WD626.VALOR626 IS NULL THEN 0 ELSE WD626.VALOR626 END AS VAL626, "// ir do Servico  "
cQuery += "  CASE WHEN WD404.VALOR404 IS NULL THEN 0 ELSE WD404.VALOR404 END AS VAL404, "// Servico Despachante "
cQuery += "  CASE WHEN COB.VLRCOBER IS NULL THEN 0 ELSE COB.VLRCOBER END AS VALSCOB,   " // Valor s/ cobertura cambial "
cQuery += "  CASE WHEN COB.VALORMOE IS NULL THEN 0 ELSE COB.VALORMOE END AS VALMOEDCOB,  "// Valor s/ cobertura cambial MOEDA ESTRAGEIRA "


cQuery += " CASE WHEN ENTRE.ENTHAWB IS NOT NULL THEN 0 ELSE (CASE WHEN WD718.VALOR718 IS NULL THEN 0 ELSE WD718.VALOR718 END) END AS VAL718, "//VLR transp inter
cQuery += "  CASE WHEN WD718.TRANPINT IS NULL THEN (CASE WHEN A2_COD IS NULL THEN '' ELSE A2_COD+'/'+A2_LOJA+' '+A2_NREDUZ END) ELSE WD718.TRANPINT END AS TRANSPINT, "//transp inter
cQuery += " CASE WHEN ENTRE.ENTHAWB IS NOT NULL THEN 0 ELSE (ROUND(W6_VLFRECC * W6_TX_FRET,2)) END AS FRETEDI, "//PROVISAO FRETE ENTREPOSTO
cQuery += " CASE WHEN ENTRE.ENTHAWB IS NOT NULL THEN 0 ELSE (CASE WHEN  WD718.VALOR718 IS NOT NULL  THEN ROUND(WD718.VALOR718 - (W6_VLFRECC * W6_TX_FRET),2) ELSE 0 END) END  AS DIFFRETE, "
cQuery += " CASE WHEN ENTRE.ENTHAWB IS NOT NULL THEN (ROUND(W6_VLFRECC * W6_TX_FRET,2)) ELSE 0 END  AS FRENT " //FRETE ENTREPOSTO



cQuery += "  FROM  " + RetSqlName("SW6") + "  (NOLOCK) AS SW6 "

cQuery += "  LEFT OUTER JOIN "
cQuery += "  ( "
cQuery += "  SELECT WD_HAWB, CASE WHEN WD_VALOR_R IS NULL THEN 0 ELSE WD_VALOR_R END AS VALOR721 FROM  " + RetSqlName("SWD") + "  (NOLOCK)  "
cQuery += "  WHERE D_E_L_E_T_='' AND WD_FILIAL='"+xFilial("SWD")+"' AND WD_HAWB='"+alltrim(cNumProc)+"' AND WD_DESPESA='721' "// Emissao LI "
cQuery += "  ) AS WD721 ON  WD721.WD_HAWB=SW6.W6_HAWB "

cQuery += "  LEFT OUTER JOIN "
cQuery += "  ( "
cQuery += "  SELECT WD_HAWB, CASE WHEN WD_VALOR_R IS NULL THEN 0 ELSE WD_VALOR_R END AS VALOR416 FROM  " + RetSqlName("SWD") + "  (NOLOCK) "
cQuery += "  WHERE D_E_L_E_T_='' AND WD_FILIAL='"+xFilial("SWD")+"' AND WD_HAWB='"+alltrim(cNumProc)+"' AND WD_DESPESA='416' "// Armazenagem
cQuery += "  ) AS WD416 ON  WD416.WD_HAWB=SW6.W6_HAWB "

cQuery += "  LEFT OUTER JOIN "
cQuery += "  ( "
cQuery += "  SELECT WD_HAWB, CASE WHEN WD_VALOR_R IS NULL THEN 0 ELSE WD_VALOR_R END AS VALOR333 FROM  " + RetSqlName("SWD") + "  (NOLOCK) "
cQuery += "  WHERE D_E_L_E_T_='' AND WD_FILIAL='"+xFilial("SWD")+"' AND WD_HAWB='"+alltrim(cNumProc)+"' AND WD_DESPESA='333' "// Taxa Embarque
cQuery += "  ) AS WD333 ON  WD333.WD_HAWB=SW6.W6_HAWB "

cQuery += "  LEFT OUTER JOIN "
cQuery += "  ( "
cQuery += "  SELECT WD_HAWB, CASE WHEN WD_VALOR_R IS NULL THEN 0 ELSE WD_VALOR_R END AS VALOR431 FROM  " + RetSqlName("SWD") + "  (NOLOCK) "
cQuery += "  WHERE D_E_L_E_T_='' AND WD_FILIAL='"+xFilial("SWD")+"' AND WD_HAWB='"+alltrim(cNumProc)+"' AND WD_DESPESA='431' "// Capatazia
cQuery += "  ) AS WD431 ON  WD431.WD_HAWB=SW6.W6_HAWB "

cQuery += "  LEFT OUTER JOIN "
cQuery += "  ( "
cQuery += "  SELECT WD_HAWB, CASE WHEN WD_VALOR_R IS NULL THEN 0 ELSE WD_VALOR_R END AS VALOR406 FROM  " + RetSqlName("SWD") + "  (NOLOCK) "
cQuery += "  WHERE D_E_L_E_T_='' AND WD_FILIAL='"+xFilial("SWD")+"' AND WD_HAWB='"+alltrim(cNumProc)+"' AND WD_DESPESA='406' "// Despachante
cQuery += "  ) AS WD406 ON  WD406.WD_HAWB=SW6.W6_HAWB "

cQuery += "  LEFT OUTER JOIN "
cQuery += "  ( "
cQuery += "  SELECT WD_HAWB, CASE WHEN WD_VALOR_R IS NULL THEN 0 ELSE WD_VALOR_R END AS VALOR623 FROM  " + RetSqlName("SWD") + "  (NOLOCK) "
cQuery += "  WHERE D_E_L_E_T_='' AND WD_FILIAL='"+xFilial("SWD")+"' AND WD_HAWB='"+alltrim(cNumProc)+"' AND WD_DESPESA='623' "// PCC Servico 
cQuery += "  ) AS WD623 ON  WD623.WD_HAWB=SW6.W6_HAWB "

cQuery += "  LEFT OUTER JOIN "
cQuery += "  ( "
cQuery += "  SELECT WD_HAWB, CASE WHEN WD_VALOR_R IS NULL THEN 0 ELSE WD_VALOR_R END AS VALOR626 FROM  " + RetSqlName("SWD") + "  (NOLOCK)  "
cQuery += "  WHERE D_E_L_E_T_='' AND WD_FILIAL='"+xFilial("SWD")+"' AND WD_HAWB='"+alltrim(cNumProc)+"' AND WD_DESPESA='626' "// ir do Servico 
cQuery += "  ) AS WD626 ON  WD626.WD_HAWB=SW6.W6_HAWB "

cQuery += "  LEFT OUTER JOIN "
cQuery += "  ( "
cQuery += "  SELECT WD_HAWB, CASE WHEN WD_VALOR_R IS NULL THEN 0 ELSE WD_VALOR_R END AS VALOR404 FROM  " + RetSqlName("SWD") + "  (NOLOCK)  "
cQuery += "  WHERE D_E_L_E_T_='' AND WD_FILIAL='"+xFilial("SWD")+"' AND WD_HAWB='"+alltrim(cNumProc)+"' AND WD_DESPESA='404' "// Servico Despachante
cQuery += "  ) AS WD404 ON  WD404.WD_HAWB=SW6.W6_HAWB "

cQuery += "  LEFT OUTER JOIN "
cQuery += "  ( "
cQuery += "  SELECT W9_FOB_TOT * W9_TX_FOB AS VLRCOBER, W9_FOB_TOT AS VALORMOE,  W9_HAWB, W9_HAWB AS 'COBERTURA' FROM  " + RetSqlName("SW9") + "  (NOLOCK) "
cQuery += "  	WHERE W9_HAWB='"+alltrim(cNumProc)+"' AND D_E_L_E_T_='' AND W9_FILIAL='"+xFilial("SW9")+"' AND W9_DIAS_PA=0 "
cQuery += "  ) AS COB ON COB.W9_HAWB=SW6.W6_HAWB "

cQuery += "  LEFT OUTER JOIN "
cQuery += "  ( "
cQuery += "  SELECT TOP 1 W9_MOE_FOB AS MOEDAINV,  W9_TX_FOB AS TXINV, W9_HAWB  FROM  " + RetSqlName("SW9") + "  (NOLOCK) "
cQuery += "  	WHERE W9_HAWB='"+alltrim(cNumProc)+"' AND D_E_L_E_T_='' AND W9_FILIAL='"+xFilial("SW9")+"'  "
cQuery += "  ) AS INV ON INV.W9_HAWB=SW6.W6_HAWB "


cQuery += "    LEFT JOIN SY4010 (NOLOCK) SY4 ON W6_AGENTE=Y4_COD AND SY4.D_E_L_E_T_='' "
cQuery += "    LEFT JOIN SA2010 (NOLOCK) SA2 ON A2_COD=Y4_FORN AND A2_LOJA=Y4_LOJA AND SA2.D_E_L_E_T_=''  "
cQuery += "    LEFT OUTER JOIN   "
cQuery += "    (   "
cQuery += "    SELECT WD_HAWB, CASE WHEN WD_VALOR_R IS NULL THEN 0 ELSE WD_VALOR_R END AS VALOR718, A2_COD+'/'+A2_LOJA+' '+A2_NREDUZ AS TRANPINT FROM   SWD010   (NOLOCK)  AS SWD  "
cQuery += "    LEFT JOIN SA2010 (NOLOCK) SA2 ON A2_COD=WD_FORN AND A2_LOJA=WD_LOJA AND SWD.D_E_L_E_T_=''  "
cQuery += "    WHERE SA2.D_E_L_E_T_='' AND WD_FILIAL='"+xFilial("SWD")+"' AND WD_HAWB='"+alltrim(cNumProc)+"' AND WD_DESPESA='718'  "//-- transpinter 
cQuery += "    ) AS WD718 ON  WD718.WD_HAWB=SW6.W6_HAWB  "
cQuery += "    LEFT OUTER JOIN  "
cQuery += "    (  "
cQuery += "    	SELECT W6_HAWB AS ENTHAWB, W6_PO_NUM, MIN(R_E_C_N_O_) AS MRECNO FROM SW6010 (NOLOCK)   "
cQuery += "  	WHERE D_E_L_E_T_='' AND LEFT(W6_PO_NUM,2)='DA' AND W6_PO_NUM IN  "
cQuery += "  	(   "
cQuery += "  select  W6_PO_NUM from SW6010  (NOLOCK) WHERE D_E_L_E_T_='' AND W6_PO_NUM<> '' AND W6_DT_HAWB >= '20010101'   "
cQuery += "  	and W6_HAWB LIKE '%"+alltrim(cNumProc)+"%'  "
cQuery += "  GROUP BY  W6_HAWB, W6_PO_NUM  "
cQuery += "  	)  "
cQuery += "  GROUP BY W6_HAWB, W6_PO_NUM  "
cQuery += "  HAVING COUNT(*)>1  "
cQuery += "  	) AS ENTRE ON  ENTRE.ENTHAWB=SW6.W6_HAWB  "

cQuery += "  WHERE SW6.D_E_L_E_T_='' AND W6_FILIAL='"+xFilial("SW6")+"' AND W6_HAWB ='"+alltrim(cNumProc)+"'  "

If Select("QUERYLT") <> 0
	QUERYLT->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYLT"


QUERYLT->(dbgotop())
oGetDadosc:aCols := {}

If !QUERYLT->( EOF() )
	While !QUERYLT->( EOF() )

		aAdd(oGetDadosc:aCols,Array(Len(caHeader)+1))	
		oGetDadosc:aCols[Len(oGetDadosc:aCols),1] :=  cFornece
		oGetDadosc:aCols[Len(oGetDadosc:aCols),2] :=  QUERYLT->VALTOT
		oGetDadosc:aCols[Len(oGetDadosc:aCols),3] :=  QUERYLT->COBCAMB
		oGetDadosc:aCols[Len(oGetDadosc:aCols),4] :=  DTOC(STOD(QUERYLT->DTPROCE))
		oGetDadosc:aCols[Len(oGetDadosc:aCols),5] :=  QUERYLT->MOEDA
		oGetDadosc:aCols[Len(oGetDadosc:aCols),6] :=  QUERYLT->TX
		oGetDadosc:aCols[Len(oGetDadosc:aCols),7] :=  QUERYLT->VALDI

		oGetDadosc:aCols[Len(oGetDadosc:aCols),Len(caHeader)+1] := .F.
		oGetDadosc:Refresh()
		QUERYLT->( dbSkip() )

	Enddo
else
		aAdd(oGetDadosc:aCols,Array(Len(caHeader)+1))	
		oGetDadosc:aCols[Len(oGetDadosc:aCols),1] :=  '' 
		oGetDadosc:aCols[Len(oGetDadosc:aCols),2] :=  ''
		oGetDadosc:aCols[Len(oGetDadosc:aCols),3] :=  ''
		oGetDadosc:aCols[Len(oGetDadosc:aCols),4] :=  '  /  /  '
		oGetDadosc:aCols[Len(oGetDadosc:aCols),5] :=  ''
		oGetDadosc:aCols[Len(oGetDadosc:aCols),6] :=  ''
		oGetDadosc:aCols[Len(oGetDadosc:aCols),7] :=  ''

		oGetDadosc:aCols[Len(oGetDadosc:aCols),Len(caHeader)+1] := .F.
		oGetDadosc:Refresh()
		QUERYLT->( dbSkip() )

EndIf




///GETDADOS 4
QUERYLT->(dbgotop())
oGetDadosd:aCols := {}

If !QUERYLT->( EOF() )
	While !QUERYLT->( EOF() )

		aAdd(oGetDadosd:aCols,Array(Len(daHeader)+1))	
		oGetDadosd:aCols[Len(oGetDadosd:aCols),1] :=  QUERYLT->VAL431
		oGetDadosd:aCols[Len(oGetDadosd:aCols),2] :=  QUERYLT->VAL416
		oGetDadosd:aCols[Len(oGetDadosd:aCols),3] :=  QUERYLT->SEGEST
		oGetDadosd:aCols[Len(oGetDadosd:aCols),4] :=  QUERYLT->VAL406
		oGetDadosd:aCols[Len(oGetDadosd:aCols),5] :=  QUERYLT->VAL721
		//oGetDadosd:aCols[Len(oGetDadosd:aCols),6] :=  QUERYLT->VAL333

		oGetDadosd:aCols[Len(oGetDadosd:aCols),Len(daHeader)+1] := .F.
		oGetDadosd:Refresh()
		QUERYLT->( dbSkip() )

	Enddo
else
		aAdd(oGetDadosd:aCols,Array(Len(daHeader)+1))	
		oGetDadosd:aCols[Len(oGetDadosd:aCols),1] :=  0
		oGetDadosd:aCols[Len(oGetDadosd:aCols),2] :=  0
		oGetDadosd:aCols[Len(oGetDadosd:aCols),3] :=  0
		oGetDadosd:aCols[Len(oGetDadosd:aCols),4] :=  0
		oGetDadosd:aCols[Len(oGetDadosd:aCols),5] :=  0
		//oGetDadosd:aCols[Len(oGetDadosd:aCols),6] :=  0

		oGetDadosd:aCols[Len(oGetDadosd:aCols),Len(daHeader)+1] := .F.
		oGetDadosd:Refresh()
		QUERYLT->( dbSkip() )

EndIf


///GETDADOS 5
QUERYLT->(dbgotop())
oGetDadose:aCols := {}

If !QUERYLT->( EOF() )
	While !QUERYLT->( EOF() )

		aAdd(oGetDadose:aCols,Array(Len(eaHeader)+1))	
		oGetDadose:aCols[Len(oGetDadose:aCols),1] :=  QUERYLT->NADEMONST
		oGetDadose:aCols[Len(oGetDadose:aCols),2] :=  QUERYLT->VAL404
		oGetDadose:aCols[Len(oGetDadose:aCols),3] :=  QUERYLT->VAL623
		oGetDadose:aCols[Len(oGetDadose:aCols),4] :=  QUERYLT->VAL626
		oGetDadose:aCols[Len(oGetDadose:aCols),5] :=  QUERYLT->VALSCOB
		oGetDadose:aCols[Len(oGetDadose:aCols),6] :=  QUERYLT->VALMOEDCOB
		

		oGetDadose:aCols[Len(oGetDadose:aCols),Len(eaHeader)+1] := .F.
		oGetDadose:Refresh()
		QUERYLT->( dbSkip() )

	Enddo
else
		aAdd(oGetDadose:aCols,Array(Len(eaHeader)+1))	
		oGetDadose:aCols[Len(oGetDadose:aCols),1] :=  ''
		oGetDadose:aCols[Len(oGetDadose:aCols),2] :=  0
		oGetDadose:aCols[Len(oGetDadose:aCols),3] :=  0
		oGetDadose:aCols[Len(oGetDadose:aCols),4] :=  0
		oGetDadose:aCols[Len(oGetDadose:aCols),5] :=  0
		oGetDadose:aCols[Len(oGetDadose:aCols),6] :=  0
		

		oGetDadose:aCols[Len(oGetDadose:aCols),Len(eaHeader)+1] := .F.
		oGetDadose:Refresh()
		QUERYLT->( dbSkip() )

EndIf



///GETDADOS 6
QUERYLT->(dbgotop())
oGetDadosf:aCols := {}

If !QUERYLT->( EOF() )
	While !QUERYLT->( EOF() )

		aAdd(oGetDadosf:aCols,Array(Len(faHeader)+1))	
		oGetDadosf:aCols[Len(oGetDadosf:aCols),1] :=  QUERYLT->TRANSPINT
		oGetDadosf:aCols[Len(oGetDadosf:aCols),2] :=  QUERYLT->VAL718
		oGetDadosf:aCols[Len(oGetDadosf:aCols),3] :=  QUERYLT->FRETEDI
		oGetDadosf:aCols[Len(oGetDadosf:aCols),4] :=  QUERYLT->DIFFRETE
		oGetDadosf:aCols[Len(oGetDadosf:aCols),5] :=  QUERYLT->FRENT
		
		oGetDadosf:aCols[Len(oGetDadosf:aCols),Len(faHeader)+1] := .F.
		oGetDadosf:Refresh()
		QUERYLT->( dbSkip() )

	Enddo
else
		aAdd(oGetDadosf:aCols,Array(Len(faHeader)+1))	
		oGetDadosf:aCols[Len(oGetDadosf:aCols),1] :=  ''
		oGetDadosf:aCols[Len(oGetDadosf:aCols),2] :=  0
		oGetDadosf:aCols[Len(oGetDadosf:aCols),3] :=  0
		oGetDadosf:aCols[Len(oGetDadosf:aCols),4] :=  0
		oGetDadosf:aCols[Len(oGetDadosf:aCols),5] :=  0
	
		oGetDadosf:aCols[Len(oGetDadosf:aCols),Len(faHeader)+1] := .F.
		oGetDadosf:Refresh()
		QUERYLT->( dbSkip() )

EndIf



QUERYLT->(dbCloseArea())

return 



Static function fGetdados()
local cQuery := ""

/*
If lfirst
	lfirst := .f.
	Return .t.
EndIf
*/
cQuery += "  select * from  " + RetSqlName("SW6") + " (NOLOCK)  WHERE D_E_L_E_T_='' AND W6_DT_NF BETWEEN '"+DTOS(dGet1)+"' AND '"+DTOS(dGet2)+"' AND W6_FILIAL='"+xFilial("SW6")+"' "

If Select("QUERYLT") <> 0
	QUERYLT->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYLT"

QUERYLT->(dbgotop())
While !QUERYLT->( EOF() )
	nProcessos += 1
	QUERYLT->(DBSKIP())
ENDDO

oSay3:Refresh()

QUERYLT->(dbgotop())
oGetDados:aCols := {}

If !QUERYLT->( EOF() )
	While !QUERYLT->( EOF() )
		aAdd(oGetDados:aCols,Array(Len(aHeader)+1))
		//oGetDados:aCols[Len(oGetDados:aCols),1] :=  IIf(EMPTY(QUERYLT->ZZB_STATUS) ,"BR_CINZA",IF (QUERYLT->ZZB_STATUS=="F","BR_VERDE", "BR_VERMELHO"))
		oGetDados:aCols[Len(oGetDados:aCols),1] :=  ''
		oGetDados:aCols[Len(oGetDados:aCols),2] :=  QUERYLT->W6_HAWB
		oGetDados:aCols[Len(oGetDados:aCols),3] :=  DTOC(STOD(QUERYLT->W6_DT_NF))
		//oGetDados:aCols[Len(oGetDados:aCols),6] :=  QUERYLT->ZZB_HORA
		//oGetDados:aCols[Len(oGetDados:aCols),7] :=  QUERYLT->R_E_C_N_O_
		oGetDados:aCols[Len(oGetDados:aCols),Len(aHeader)+1] := .F.
		oGetDados:Refresh()
		QUERYLT->( dbSkip() )
	Enddo
else
		aAdd(oGetDados:aCols,Array(Len(aHeader)+1))
		//oGetDados:aCols[Len(oGetDados:aCols),1] :=  IIf(EMPTY(QUERYLT->ZZB_STATUS) ,"BR_CINZA",IF (QUERYLT->ZZB_STATUS=="F","BR_VERDE", "BR_VERMELHO"))
		oGetDados:aCols[Len(oGetDados:aCols),1] :=  ''
		oGetDados:aCols[Len(oGetDados:aCols),2] :=  ''
		oGetDados:aCols[Len(oGetDados:aCols),3] :=  '  /  /  '
		//oGetDados:aCols[Len(oGetDados:aCols),6] :=  QUERYLT->ZZB_HORA
		//oGetDados:aCols[Len(oGetDados:aCols),7] :=  QUERYLT->R_E_C_N_O_
		oGetDados:aCols[Len(oGetDados:aCols),Len(aHeader)+1] := .F.
		oGetDados:Refresh()
EndIf

QUERYLT->(dbCloseArea())

return .t.



Static function fGetnf(aDados, nPos)
local cQuery   := ""
Local cProc    := aDados[nPos][2]
Local nTOT     := 0
Local nTOTnf   := 0


cQuery += "  SELECT * FROM ( "
cQuery += "  SELECT F1_DOC +'/'+ F1_SERIE as DOC,F1_HAWB AS PROCESSO, F1_FORNECE+'/'+F1_LOJA+' '+ (SELECT A2_NREDUZ FROM SA2010 WHERE A2_COD=F1_FORNECE AND A2_LOJA=F1_LOJA AND D_E_L_E_T_='' ) AS NFORNECE,   "
cQuery += "  (F1_VALBRUT)-(F1_FOB_R) AS VLRBX, F1_VALBRUT AS VALNF, D1_CF AS CF FROM SF1010 (NOLOCK) AS SF1 INNER JOIN SD1010 AS SD1 ON D1_DOC=F1_DOC AND D1_SERIE=F1_SERIE AND "
cQuery += "    D1_FORNECE=F1_FORNECE AND D1_LOJA=F1_LOJA AND SD1.D_E_L_E_T_='' "
cQuery += "  WHERE "
cQuery += "  SF1.D_E_L_E_T_='' "
cQuery += "  AND F1_HAWB='"+alltrim(cPROC)+"' "
cQuery += "  )AS FINAL GROUP BY DOC, PROCESSO, NFORNECE, VLRBX, VALNF, CF "



If Select("QUERYLT") <> 0
	QUERYLT->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYLT"


QUERYLT->(dbgotop())
oGetDadosb:aCols := {}

If !QUERYLT->( EOF() )

	While !QUERYLT->( EOF() )
	
		aAdd(oGetDadosb:aCols,Array(Len(baHeader)+1))
		oGetDadosb:aCols[Len(oGetDadosb:aCols),1] :=  QUERYLT->PROCESSO
		oGetDadosb:aCols[Len(oGetDadosb:aCols),2] :=  QUERYLT->DOC
		oGetDadosb:aCols[Len(oGetDadosb:aCols),3] :=  QUERYLT->NFORNECE
		oGetDadosb:aCols[Len(oGetDadosb:aCols),4] :=  QUERYLT->VALNF	
		oGetDadosb:aCols[Len(oGetDadosb:aCols),5] :=  QUERYLT->VLRBX	
		oGetDadosb:aCols[Len(oGetDadosb:aCols),6] :=  QUERYLT->CF
		oGetDadosb:aCols[Len(oGetDadosb:aCols),Len(baHeader)+1] := .F.
		cFornece := QUERYLT->NFORNECE
		oGetDadosb:Refresh()

		nTOT   += QUERYLT->VLRBX
		nTOTNF += QUERYLT->VALNF
		QUERYLT->( dbSkip() )

		If QUERYLT->( EOF() )

			aAdd(oGetDadosb:aCols,Array(Len(baHeader)+1))
			oGetDadosb:aCols[Len(oGetDadosb:aCols),1] :=  "TOTAL"
			oGetDadosb:aCols[Len(oGetDadosb:aCols),2] :=  ""
			oGetDadosb:aCols[Len(oGetDadosb:aCols),3] :=  ""
			oGetDadosb:aCols[Len(oGetDadosb:aCols),4] :=  nTOTnf	
			oGetDadosb:aCols[Len(oGetDadosb:aCols),5] :=  nTOT	
			oGetDadosb:aCols[Len(oGetDadosb:aCols),6] :=  ""
			oGetDadosb:aCols[Len(oGetDadosb:aCols),Len(baHeader)+1] := .F.
			oGetDadosb:Refresh()

		EndIf

	Enddo
else

	aAdd(oGetDadosb:aCols,Array(Len(baHeader)+1))
	oGetDadosb:aCols[Len(oGetDadosb:aCols),1] :=  alltrim(cPROC)
	oGetDadosb:aCols[Len(oGetDadosb:aCols),2] :=  ' - '
	oGetDadosb:aCols[Len(oGetDadosb:aCols),3] :=  ' - '
	oGetDadosb:aCols[Len(oGetDadosb:aCols),4] :=  ''
	oGetDadosb:aCols[Len(oGetDadosb:aCols),5] :=  ''
	oGetDadosb:aCols[Len(oGetDadosb:aCols),6] :=  ''
	oGetDadosb:aCols[Len(oGetDadosb:aCols),Len(baHeader)+1] := .F.
	oGetDadosb:Refresh()
	cFornece := ' - '
EndIf

QUERYLT->(dbCloseArea())


fGetitems(alltrim(cProc))

return 



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fX3Ret    ºAutor  ³Felipe Aurelio      º Data ³  27/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fX3Ret(cCampo,cRet)

	Default cCampo := ""
	Default cRet   := ""

	SX3->(DbSetOrder(2))
	If SX3->(MsSeek(cCampo))
		cRet := &("SX3->"+cRet)
	EndIf

	If ValType(cRet) == "C"
		cRet := AllTrim(cRet)
	EndIf

Return(cRet)

Static Function FCARGA()

	FWMsgRun(, {|oWin2| fGetdados() }, "Processando", "Processos...")
	FWMsgRun(, {|oWin3| fGetnf(oGetDados:aCols,oGetDados:oBrowse:nat) }, "Processando", "Nfs...")	
	
Return .T.
