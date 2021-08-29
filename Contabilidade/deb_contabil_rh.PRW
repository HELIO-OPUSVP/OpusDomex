***********
* Debito  *
***********
User Function deb_contabil()
If Type("lContabCC" ) == "U"    //Verifica se a variável existe , tratamento para a validação do cadastro da LP --Wederson 18/08/2016
   lContabCC :=.T.
EndIf

cConta := Space(20) 

If lContabCC //Por CC
   Do Case
	   Case Substr(SRZ->RZ_CC,1,1) = "4"  //CUSTO
		     cConta := FDESC("SRV",SRZ->RZ_PD,"RV_XXDBCUS") 
	   Case Substr(SRZ->RZ_CC,1,1) = "5"  //DESPESA
		     cConta := FDESC("SRV",SRZ->RZ_PD,"RV_XXDBDES") 
   EndCase
Else   //Por matrícula
   If SRA->RA_CATFUNC <> "P"
      Do Case
	      Case Substr(SRZ->RZ_CC,1,1) = "4"  //CUSTO
		        cConta := FDESC("SRV",SRZ->RZ_PD,"RV_XXDBCUS") 
	      Case Substr(SRZ->RZ_CC,1,1) = "5"  //DESPESA
		        cConta := FDESC("SRV",SRZ->RZ_PD,"RV_XXDBDES") 
      EndCase          
   Else
      If SRV->(FieldPos("RV_XXDBPRO"))>0
         cConta := FDESC("SRV",SRZ->RZ_PD,"RV_XXDBPRO") 
      EndIf
   EndIf      
EndIf

Return(cConta)


***********
* Credito *
***********
User Function cre_contabil()
If Type("lContabCC" ) == "U" //Verifica se a variável existe , tratamento para a validação do cadastro da LP --Wederson 18/08/2016
   lContabCC :=.T.
EndIf

cConta := Space(20)

If lContabCC  //Por CC
   Do Case
	   Case Substr(SRZ->RZ_CC,1,1) = "4"  //CUSTO
		     cConta := FDESC("SRV",SRZ->RZ_PD,"RV_XXCRCUS") 
   	Case Substr(SRZ->RZ_CC,1,1) = "5"  //DESPESA
		     cConta := FDESC("SRV",SRZ->RZ_PD,"RV_XXCRDES") 
   EndCase
Else        //Por matrícula
    If SRA->RA_CATFUNC <> "P"
       Do Case
	       Case Substr(SRZ->RZ_CC,1,1) = "4"  //CUSTO
		         cConta := FDESC("SRV",SRZ->RZ_PD,"RV_XXCRCUS") 
   	    Case Substr(SRZ->RZ_CC,1,1) = "5"  //DESPESA
		         cConta := FDESC("SRV",SRZ->RZ_PD,"RV_XXCRDES") 
       EndCase
    Else
        If SRV->(FieldPos("RV_XXCRPRO"))>0
           cConta := FDESC("SRV",SRZ->RZ_PD,"RV_XXCRPRO") 
        EndIf 
    EndIf   
EndIf

Return(cConta)