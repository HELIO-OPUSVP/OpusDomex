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
  
  /*
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
				ZZB->ZZB_FILIAL    := xFilial("ZZB")
				ZZB->ZZB_LOG 	   := "Item nao processado"
				ZZB->ZZB_PERIOD    := cPerAtu       
				ZZB->ZZB_ROTINA    := TMPZZB->ZZB_ROTINA  
				ZZB->ZZB_DESCRI    := TMPZZB->ZZB_DESCRI       
				ZZB->SEQPROC       := TMPZZB->SEQPROC 
				ZZB->ZZB_STATUS    := '' //IF(TMPZZB->SEQPROC == 1, 'F','')
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
*/
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

//	oGetDados:oBrowse:bChange := { |nIndo| fMudaLinha(oGetDados,oGetDados:oBrowse:nat,nIndo) }

	//fGetdados()
      
		
ACTIVATE MSDIALOG oDlg CENTERED
                                            

Return Nil            
