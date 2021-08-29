//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Wederson L. Santana 06/03/2013                                                                                                                   //
//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Específico Rosenberger Domex - Estoque/Custo                                                                                                     //
//Ponto de entrada no estorno do endereçamento.                                                                                                    //
//-------------------------------------------------------------------------------------------------------------------------------------------------//
User Function MTA265E()   
Local _aArea := GetArea()
dbSelectArea("XD1")
dbSetOrder(1)
If dbSeek(xFilial("XD1")+SDB->DB_XXPECA)
   Reclock("XD1",.F.)
   Replace XD1->XD1_LOCALI With ""
   XD1->( MsUnlock() )
EndIf   
RestArea(_aArea)
Return