#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Rwmake.ch"
#include "Topconn.ch"
#include "Protheus.ch"          
#include "Apwebex.ch"

//Desoneração folha de pagammento. Wederson 07/04/14

User Function DOMFAT03()
Private _aCab       :={}     
Private _aDados     :={}
Private lMsHelpAuto :=.T.
Private lMsErroAuto :=.F.
Private _nCntLidos  :=0
Private _nCntInc    :=0
Private _nCntAlt    :=0
Private _cPath      :="\UTIL\LOG\Desoneracao\" 

If MsgYesNo("Desoneração."+Chr(13)+;
            "Complemento do produto - Correção do código de atividade."+Chr(13)+;
            "Período :"+SubStr(AllTrim(GetMv("MV_FOLMES")),5,2)+"/"+SubStr(AllTrim(GetMv("MV_FOLMES")),1,4)+Chr(13)+;
            "Inicia o processo ?","Desoneração")
   Processa({|lEnd| fOkProc()},"Verificando cadastro do produto/complemento.Faturamento período "+GetMv("MV_FOLMES"))

   Processa({|lEnd| fOkGrava()})

   MsgInfo("Total "+Transform(_nCntLidos,"@E 999,999")+Chr(13)+Chr(10)+" Alterados: "+Transform(_nCntAlt,"@E 999,999")+Chr(13)+Chr(10)+;
           "Incluídos :"+Transform(_nCntInc,"@E 999,999"),"Desoneração")
EndIf
Return             

//-----------------------

Static Function fOkProc()

Iif(Select('TMP_SQL')>0,TMP_SQL->(dbCloseArea()),Nil)

OPEN QUERY "SELECT D2_COD FROM "+RetSqlName("SD2")+" SD2 "+;
            "WHERE SD2.D_E_L_E_T_ = '' "+;
            "AND SubString(D2_EMISSAO,1,6) = '"+AllTrim(GetMv("MV_FOLMES"))+"' "+;
            "AND D2_CF IN('5101','5102','5103','5104','5105','5106','5109','5110','5111','5112','5113','5114','5115','5116','5117','5118','5119'"+;
            ",'5120','5122','5123','5124','5125','5251','5525','5253','5254','5255','5256','5257','5301','5302','5303','5304','5305','5306','5307'"+;
            ",'5351','5352','5353','5354','5305','5306','5307','5351','5352','5353','5354','5355','5356','5357','5359','5401','5402','5403','5405'"+;
            ",'5651','5652','5653','5654','5655','5656','6101','6102','6103','6104','6105','6106','6107','6108','6109','6110','6111','6112','6113'"+;
            ",'6114','6115','6116','6117','6118','6119','6120','6122','6123','6124','6125','6251','6252','6253','6254','6255','6256','6257','6258'"+;
            ",'6301','6302','6303','6304','6305','6306','6307','6351','6352','6353','6354','6355','6356','6357','6359','6401','6402','6403','6404'"+;
            ",'6501','6502','6651','6652','6653','6654','6655','6656','7101','7102','7105','7106','7127','7251','7301','7358','7501','7651','7664'"+;
            ",'5933','6933')"+;
            "GROUP BY D2_COD"+;
            "ORDER BY D2_COD " ALIAS "TMP_SQL"
Return

//--------------------------------------------

Static Function fOkGrava()
Local _cAlias
Local _lLog :=.F.

dbSelectArea("TMP_SQL")
dbGotop()
ProcRegua(RecCount())
Do While.Not.Eof()
   _nCntLidos ++
   
   dbSelectArea("SB1")
   dbSetOrder(1)
   If dbSeek(xFilial("SB1")+TMP_SQL->D2_COD)
   
      dbSelectArea("CG1")//Tabela 5.1.1 preparada 
      dbSetOrder(1)
      If dbSeek(xFilial("CG1")+Alltrim(SB1->B1_POSIPI))
         
         dbSelectArea("SB5")
         dbSetOrder(1)
         If! dbSeek(xFilial("SB5")+SB1->B1_COD)
             If dDataBase >=CG1->CG1_DTINI.And.dDataBase<=CG1->CG1_DTFIM

                _aCab:= { {"B5_COD"     ,SB1->B1_COD     ,Nil},;	// Código identificador do produto			
                          {"B5_CEME"    ,SB1->B1_DESC    ,Nil},;   // Nome cientifico do produto						
                          {"B5_CODATIV" ,CG1->CG1_CODIGO ,Nil},;   // Código atividade
                          {"B5_INDPETR" ,"0"             ,Nil},;
                          {"B5_INSPAT"  ,"1" ,Nil}}                // 
                             
                MSExecAuto({|x,y| Mata180(x,y)},_aCab,3)

                If lMsErroAuto	
                   MostraErro(_cPath)
                   _lLog :=.T.
                Else   
                    _nCntInc ++                                                                         
                    lMsErroAuto :=.F.	
                EndIf 
                
             EndIf         
         Else //Existe cadastro de complemento , atualiza com as informações corretas.
             If Alltrim(SB5->B5_CODATIV) <> Alltrim(SB1->B1_POSIPI).Or.SB5->B5_INSPAT <> "1" 
                Reclock("SB5",.F.)
                If dDataBase >=CG1->CG1_DTINI.And.dDataBase<=CG1->CG1_DTFIM //Atividade é válida.
                   Replace SB5->B5_INSPAT  With "1"    
                   Replace SB5->B5_CODATIV With CG1->CG1_CODIGO
                Else
                   Replace SB5->B5_INSPAT  With "2"    
                EndIf
                MsUnlock()
                _nCntAlt ++
             EndIf    
         EndIf        
      Else    //Não exista na CG1 ,não desonerado, mas está como sim no complemento.Atualiza para não.
         dbSelectArea("SB5")
         dbSetOrder(1)
         If dbSeek(xFilial("SB5")+SB1->B1_COD)    
            If SB5->B5_INSPAT == "1"
               Reclock("SB5",.F.)
               Replace SB5->B5_INSPAT  With "2"
               MsUnlock()
               _nCntAlt ++
            EndIf   
         EndIf
      EndIf   
   End  
   dbSelectArea("TMP_SQL")    
   dbSkip()
   IncProc()
EndDo         

If _lLog
   MsgInfo("Existem erro(s) ao atualizar o cadastro."+Chr(13)+;
           "Verifique arquivo de LOG em "+_cPath,"A T E N Ç Ã O")
EndIf
Return