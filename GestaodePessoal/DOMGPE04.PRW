//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Wederson L. Santana - 05/02/14                                                                                                                   //
//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Especifico Domex                                                                                                                                 //
//                                                                                                                                                 //
//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Relatório para conferência das informações necessárias para o eSocial.                                                                           //
//Evento S-2100                                                                                                                                    //
//-------------------------------------------------------------------------------------------------------------------------------------------------//

#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"                                                 
#Include "protheus.ch"
#Include "colors.ch"

User Function DOMGPE04()
Private _cPerg :="DOMGPE04"+Space(02)
Private oReport
Private cFilterUser
Private oSection1
Private oSection2
Private _cArqTRB,_cInd1TRB
Private oFont , oFontN
Private cTitulo
Private _aSRA :={"RA_CIC","RA_PIS","RA_RACACOR","RA_CODMUNN","RA_NACIONC","RA_MAE","RA_PAI","RA_UFCP","RA_RG","RA_RGORG","RA_DTRGEXP","RA_HABILIT","RA_CNHORG","RA_DTEMCNH","RA_DTVCCNH","RA_LOGRTP","RA_LOGRDSC","RA_LOGRNUM","RA_BAIRRO","RA_CEP","RA_CODMUN","RA_TPPREVI","RA_CATEFD","RA_SALARIO","RA_TPCONTR","RA_DTFIMCT","RA_CARGO","RA_TPJORNA","RA_RNE","RA_RNEORG","RA_RNEDEXP","RA_DATCHEG","RA_DATNATU","RA_CASADBR","RA_FILHOBR","RA_TPCTDEP","RA_BCDEPSA","RA_CTDEPSA","RA_PORTDEF","RA_TELEFON","RA_EMAIL","RA_EMAIL2","RA_TPCTDEP"}//RA_EAPOSEN
Private _aSRB :={"RB_NOME","RB_DTNASC","RB_CIC","RB_TPDEP","RB_TIPIR","RB_TIPSF"}
Private _aSR8 :={"R8_NMMED","R8_CRMMED","R8_TPEFD"}
// Array _aSRA e _aSRB devem permanecer esta ordem.

fCriaPerg()
If Pergunte(_cPerg,.T.)
		oReport:=ReportDef()
		oReport:PrintDialog()
EndIf

Return

//-----------------------------------

Static Function ReportDef()
Local oSection1
Local oSection2
Private _nTotQtd:= 0

cTitulo:= "eSocial - Cadastramento inicial do vínculo Evento S-2100"

oFontN :=TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)// Negrito 
oFont  :=TFont():New("Times New Roman",08,08,,.F.,,,,.F.,.F.)

oReport:=TReport():New("DOMGPE04",cTitulo,""/*_cPerg*/,{|oReport| ReportPrint(oReport)},"Este relatório exibirá os campos do eSocial.")

oReport:SetLandScape(.T.)

oSectionSRA :=TRSection():New(oReport     ,"","SRA",{},.F./*aOrder*/,.F./*lLoadCells*/,""/*cTotalText*/,.F./*lTotalInCol*/,.F./*lHeaderPage*/,.F./*lHeaderBreak*/)
//oSectionSRAd:=TRSection():New(oSectionSRA ,"","SRA",{},.F./*aOrder*/,.F./*lLoadCells*/,""/*cTotalText*/,.F./*lTotalInCol*/,.F./*lHeaderPage*/,.F./*lHeaderBreak*/)

TRCell():New(oSectionSRA,"RA_MAT"         ,,"Matrícula"          , ,006,.F.,)
TRCell():New(oSectionSRA,"RA_NOME"        ,,"Nome"               , ,030,.F.,)
TRCell():New(oSectionSRA,"CAMPO"          ,,"Campo"              , ,010,.F.,)
TRCell():New(oSectionSRA,"DESCR"          ,,"Descrição"          , ,020,.F.,)
TRCell():New(oSectionSRA,"DEPENDENTE"     ,,"Dependente"         , ,030,.F.,)
TRCell():New(oSectionSRA,"CAMPOAF"        ,,"Campo"              , ,010,.F.,)
TRCell():New(oSectionSRA,"DESCRAF"        ,,"Descrição"          , ,020,.F.,)
TRCell():New(oSectionSRA,"DATAAF"         ,,"Data Afastamento"   , ,008,.F.,)

oSectionSRA:SetHeaderPage(.F.)

oSectionSRA:Cell("RA_MAT"):SetHeaderAlign("LEFT")
oSectionSRA:Cell("RA_MAT"):SetAlign("LEFT")
//oSectionSRA:Cell("RA_MAT"):SetSize(06)

oSectionSRA:Cell("RA_NOME"):SetHeaderAlign("LEFT")
oSectionSRA:Cell("RA_NOME"):SetAlign("LEFT")
//oSectionSRA:Cell("RA_NOME"):SetSize(30)

oSectionSRA:Cell("CAMPO"):SetHeaderAlign("LEFT")
oSectionSRA:Cell("CAMPO"):SetAlign("LEFT")

oSectionSRA:Cell("DESCR"):SetHeaderAlign("LEFT")
oSectionSRA:Cell("DESCR"):SetAlign("LEFT")

oSectionSRA:Cell("DEPENDENTE"):SetHeaderAlign("LEFT")
oSectionSRA:Cell("DEPENDENTE"):SetAlign("LEFT")

oSectionSRA:Cell("CAMPOAF"):SetHeaderAlign("LEFT")
oSectionSRA:Cell("CAMPOAF"):SetAlign("LEFT")

oSectionSRA:Cell("DESCRAF"):SetHeaderAlign("LEFT")
oSectionSRA:Cell("DESCRAF"):SetAlign("LEFT")

oSectionSRA:Cell("DATAAF"):SetHeaderAlign("LEFT")
oSectionSRA:Cell("DATAAF"):SetAlign("RIGHT")

Return oReport

//---------------------------------------------------------

Static Function ReportPrint(oReport)
Local oSectionSRA  := oReport:Section(1)
//Local oSectionSRAd := oReport:Section(1):Section(1)
Local nOrdem       := oSectionSRA:GetOrder()
Local _cAlias      := GetNextAlias()
Local _nTpImpr     := oReport:nDevice
Local _cOrder      := "%RA_MAT%"   

oReport:SetTitle(cTitulo)

BeginSql Alias _cAlias       

         SELECT  RA_MAT,RA_NOME,RA_CIC,RA_PIS,RA_RACACOR,RA_CODMUNN,RA_NACIONC,RA_MAE,RA_PAI,RA_UFCP,RA_RG,RA_RGORG,RA_DTRGEXP,RA_HABILIT,RA_CNHORG
                 ,RA_DTEMCNH,RA_CARGO,RA_DTVCCNH,RA_LOGRTP,RA_LOGRDSC,RA_LOGRNUM,RA_BAIRRO,RA_CEP,RA_CODMUN,RA_TPPREVI,RA_CATEFD,RA_SALARIO,RA_TPCONTR,RA_DTFIMCT
                 ,RA_RNE,RA_RNEORG,RA_RNEDEXP,RA_DATCHEG,RA_DATNATU,RA_CASADBR,RA_FILHOBR,RA_TPCTDEP,RA_BCDEPSA,RA_CTDEPSA,RA_PORTDEF
                 ,RA_TELEFON,RA_EMAIL,RA_EMAIL2,RA_NACIONA,RA_CATFUNC,RA_TPCTDEP,RA_BCDEPSA,RA_CTDEPSA
		   FROM %table:SRA% SRA
	      WHERE RA_SITFOLH <> 'D' 
	      AND RA_MAT >= %Exp:mv_par01%
	      AND RA_MAT <= %Exp:mv_par02%
       	AND RA_CC >= %Exp:mv_par03%
       	AND RA_CC <= %Exp:mv_par04%
         AND SRA.%notDel%		
    		ORDER BY %Exp:_cOrder%
EndSql

oSectionSRA:EndQuery()
_nLinha :=1
oSectionSRA:Init()

dbSelectArea(_cAlias)
While !oReport:Cancel() .And. (_cAlias)->(!Eof())
	
	If oReport:Cancel()
		Exit
	EndIf
	   _cTpContr:=""
	   _cNaciona:=""
	   
	   For i:=1 To Len(_aSRA)    
	       _cCampo:=_aSRA[i]     

          If AllTrim(_cCampo) == "RA_TPCONTR"
             _cTpContr:=(_cAlias)->&_cCampo
          EndIf
          
          If AllTrim(_cCampo) == "RA_NACIONA"
             _cNaciona:=(_cAlias)->&_cCampo
          EndIf
          
	       If Empty((_cAlias)->&_cCampo)  
	          If AllTrim(_cCampo) == "RA_DTFIMCT"
	             If _cTpContr == "2"
	             	 oSectionSRA:Cell("RA_MAT") :SetValue((_cAlias)->RA_MAT)
	                oSectionSRA:Cell("RA_NOME"):SetValue((_cAlias)->RA_NOME)
	   	          oSectionSRA:Cell("CAMPO") :SetValue(_cCampo)
	                oSectionSRA:Cell("DESCR") :SetValue(Posicione("SX3",2,_cCampo ,"X3_TITULO"))
	                oSectionSRA:PrintLine()
	             EndIf
	          EndIf   
	          If AllTrim(_cCampo) $ "RA_RNE/RA_RNEORG/RA_RNEDEXP/RA_DATCHEG/RA_DATNATU/RA_CASADBR/RA_FILHOBR"
	             If _cNaciona == "10"
	             	 oSectionSRA:Cell("RA_MAT") :SetValue((_cAlias)->RA_MAT)
	                oSectionSRA:Cell("RA_NOME"):SetValue((_cAlias)->RA_NOME)
	   	          oSectionSRA:Cell("CAMPO") :SetValue(_cCampo)
	                oSectionSRA:Cell("DESCR") :SetValue(Posicione("SX3",2,_cCampo ,"X3_TITULO"))
	                oSectionSRA:PrintLine()
	             EndIf
             Else
                 Do Case 
                    Case AllTrim(_cCampo) == "RA_CATEFD"  
                         Do Case
                            Case (_cAlias)->RA_CATFUNC == "E" .OR.(_cAlias)->RA_CATFUNC == "G"
                                 If (_cAlias)->RA_CATEFD <> "901"
	          	                     oSectionSRA:Cell("RA_MAT") :SetValue((_cAlias)->RA_MAT)
	                                 oSectionSRA:Cell("RA_NOME"):SetValue((_cAlias)->RA_NOME)
   	                              oSectionSRA:Cell("CAMPO")  :SetValue(_cCampo)
	                                 oSectionSRA:Cell("DESCR")  :SetValue(Posicione("SX3",2,_cCampo ,"X3_TITULO")+" "+(_cAlias)->RA_CATEG)
                                    oSectionSRA:PrintLine()
                                 EndIf
                            Case (_cAlias)->RA_CATEG == "  ".And.(_cAlias)->RA_CATEFD <> "101"
                                 oSectionSRA:Cell("RA_MAT") :SetValue((_cAlias)->RA_MAT)
	                              oSectionSRA:Cell("RA_NOME"):SetValue((_cAlias)->RA_NOME)
   	                           oSectionSRA:Cell("CAMPO")  :SetValue(_cCampo)
	                              oSectionSRA:Cell("DESCR")  :SetValue(Posicione("SX3",2,_cCampo ,"X3_TITULO")+" "+(_cAlias)->RA_CATEG)
                                 oSectionSRA:PrintLine()
                         EndCase
                    OtherWise
	          	          oSectionSRA:Cell("RA_MAT") :SetValue((_cAlias)->RA_MAT)
	                      oSectionSRA:Cell("RA_NOME"):SetValue((_cAlias)->RA_NOME)
   	                   oSectionSRA:Cell("CAMPO")  :SetValue(_cCampo)
	                      oSectionSRA:Cell("DESCR")  :SetValue(Posicione("SX3",2,_cCampo ,"X3_TITULO"))
                         oSectionSRA:PrintLine()
                 EndCase    
             EndIf     
   		 EndIf
   		 Do Case
             Case AllTrim(_cCampo) == "RA_TPCTDEP"
                  If Empty((_cAlias)->RA_BCDEPSA) .AND. Empty((_cAlias)->RA_CTDEPSA) //funcionário com vínculo tem que informar dados da cc.                 
                     oSectionSRA:Cell("RA_MAT") :SetValue((_cAlias)->RA_MAT)
                     oSectionSRA:Cell("RA_NOME"):SetValue((_cAlias)->RA_NOME)
                     oSectionSRA:Cell("CAMPO")  :SetValue(_cCampo)
                     oSectionSRA:Cell("DESCR")  :SetValue(Posicione("SX3",2,_cCampo ,"X3_TITULO")+" - Dados bancários - Bco/Age/CC")
                     oSectionSRA:PrintLine()
                  EndIf
          EndCase
 	   Next
 	   
	   dbSelectArea("SRB")
	   dbSetOrder(1)
	   If dbSeek(xFilial("SRB")+(_cAlias)->RA_MAT)
	      Do While.Not.Eof().And.xFilial("SRB")+(_cAlias)->RA_MAT == SRB->RB_FILIAL+SRB->RB_MAT
	              _dDtNasc := Ctod("//")
	              _cCpf    := ""
	              _lDtNasc := .F.
	              _lCpf    := .F.
	         	  For i:=1 To Len(_aSRB)    
	                   _cCampo:=_aSRB[i]     

                      If AllTrim(_cCampo) == "RB_DTNASC"
                         _dDtNasc:=SRB->&_cCampo
                         _lDtNasc:=.T.
                      EndIf
          
                      If AllTrim(_cCampo) == "RB_CIC"
                         _cCpf:=SRB->&_cCampo
                         _lCpf:=.T.
                      EndIf
                     
                      If _lDtNasc .And. _lCpf 
                         If (dDataBase - _dDtNasc) >= 6570
                            If Empty(_cCpf)
    	   	                   oSectionSRA:Cell("CAMPO"):SetValue(_cCampo)
	                            oSectionSRA:Cell("DESCR"):SetValue(Posicione("SX3",2,_cCampo ,"X3_TITULO"))
	                            oSectionSRA:Cell("DEPENDENTE"):SetValue(SRB->RB_NOME)
	                            oSectionSRA:PrintLine()
                            EndIf
                         EndIf
        	                _lDtNasc := .F.
	                      _lCpf    := .F.
                      Else
	                       If Empty(SRB->&_cCampo)  	                      
	   	                    oSectionSRA:Cell("CAMPO"):SetValue(_cCampo)
	                          oSectionSRA:Cell("DESCR"):SetValue(Posicione("SX3",2,_cCampo ,"X3_TITULO"))
                             oSectionSRA:Cell("DEPENDENTE"):SetValue(SRB->RB_NOME)	                          
                             oSectionSRA:PrintLine()
	                       EndIf   
	                   EndIf    
	              Next
	              dbSkip()
	   	        oSectionSRA:Cell("CAMPO") :SetValue("")
	              oSectionSRA:Cell("DESCR") :SetValue("")
	              oSectionSRA:Cell("DEPENDENTE") :SetValue("")
         EndDo
	   EndIf
	   
	   // 01, 02, 03, 04, 06 e 11
 	   // Afastamento
 	   dbSelectArea("SR8")
 	   dbSetOrder(1) //R8_FILIAL, R8_MAT, R8_DATAINI, R8_TIPO, R_E_C_N_O_, D_E_L_E_T_
 	   If dbSeek(xFilial("SR8")+(_cAlias)->RA_MAT)
 	      Do While.Not.Eof().And.xFilial("SR8")+(_cAlias)->RA_MAT == SR8->R8_FILIAL+SR8->R8_MAT
 	              For i:=1 To Len(_aSR8)    
	                  _cCampo:=_aSR8[i]     

	                  If Empty(SR8->&_cCampo)  	                      
	   	                    oSectionSRA:Cell("CAMPOAF"):SetValue(_cCampo)
	                          oSectionSRA:Cell("DESCRAF"):SetValue(Posicione("SX3",2,_cCampo ,"X3_TITULO"))
                             oSectionSRA:Cell("DATAAF") :SetValue(SR8->R8_DATA)	                          
                             oSectionSRA:PrintLine()
	                  EndIf    
	              Next
 	         
 	         dbSkip()
 	      EndDo
 	   EndIf
		
	   dbSelectArea(_cAlias)
	   dbSkip()
      oReport:IncMeter()
      oReport:SkipLine()
EndDo
oSectionSRA:Finish()
oReport:EndPage()
Return

//-----------------------------------------------------------

Static Function fCriaPerg()
aSvAlias:={Alias(),IndexOrd(),Recno()}
i:=j:=0
aRegistros:={}
//                1      2    3                  4  5      6     7  8  9  10  11  12 13     14  15    16 17 18 19 20     21  22 23 24 25   26 27 28 29  30       31 32 33 34 35  36 37 38 39    40 41 42 43 44
AADD(aRegistros,{_cPerg,"01","Matricula de       ?","","","mv_ch1","C",06,00,00,"G","","mv_par01",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","SRA","","","","",""})
AADD(aRegistros,{_cPerg,"02","Matricula ate      ?","","","mv_ch2","C",06,00,00,"G","","mv_par02",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","SRA","","","","",""})
AADD(aRegistros,{_cPerg,"03","C.Custo de         ?","","","mv_ch3","C",09,00,00,"G","","mv_par03",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","CTT","","","","",""})
AADD(aRegistros,{_cPerg,"04","C.Custo ate        ?","","","mv_ch4","C",09,00,00,"G","","mv_par04",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","CTT","","","","",""})

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