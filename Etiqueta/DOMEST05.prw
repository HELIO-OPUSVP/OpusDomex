//Zebra ZM400
User Function DOMEST05(_lStatus)                     
//Local _cPorta:="LPT1"           
Local _aArea :=GetArea()
Local _cNome :=CriaVar("A2_NREDUZ")

SA2->(dbSetOrder(1))
If SA2->(dbSeek(xFilial("SA2")+XD1->XD1_FORNEC+XD1->XD1_LOJA))
   _cNome :=SubStr(SA2->A2_NREDUZ,1,15)
EndIf

SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial("SB1")+XD1->XD1_COD))

If!Empty(XD1->XD1_DOC)
   MSCBSay(29,02,"NF:"+XD1->XD1_DOC,"N","B","45,15") 
EndIf                                         
MSCBSay(53,02,"Prod:"+XD1->XD1_COD,"N","B","45,15")
MSCBSay(29,08,SubStr(SB1->B1_DESC,1,33),"N","B","42,12")
If!Empty(_cNome)
   MSCBSay(29,14,"Forn:"+XD1->XD1_FORNEC+"/"+XD1->XD1_LOJA+"-"+_cNome,"N","B","45,12")
EndIf   
MSCBSayBar(32,21,AllTrim(XD1->XD1_XXPECA) ,"MB07","C",13.36,.T.,.T.,.F.,,3,2)    

MSCBEnd()            
Sleep(500)
RestArea(_aArea)
Return
