User Function DOMEST08()
Private _cPerg  := "DOMEST08"+Space(02)

fCriaPerg()

If Pergunte(_cPerg,.T.)

   SB9->(dbSetOrder(1))                                    
   If SB9->(dbSeek(xFilial("SB9")+Mv_Par01+"08"+Dtos(GetMv("MV_ULMES"))))
      If MsgYesNo("Correção Saldo Inicial "+Chr(10)+Chr(13)+"Produto :"+SB9->B9_COD+Chr(10)+Chr(13)+" Data :"+Dtoc(SB9->B9_DATA)+Chr(10)+Chr(13)+" Local : 08")
         Reclock("SB9",.F.)
         Replace SB9->B9_QINI  With Mv_Par02
         Replace SB9->B9_VINI1 With Mv_Par03
         MsUnlock()
      EndIf
   EndIf

EndIf

Return Nil        

//-----------------------------------------------------------

Static Function fCriaPerg()
aSvAlias:={Alias(),IndexOrd(),Recno()}
i:=j:=0
aRegistros:={}
//                1      2    3                  4  5      6     7  8  9  10  11  12 13     14  15    16 17 18 19 20     21  22 23 24 25   26 27 28 29  30       31 32 33 34 35  36 37 38 39    40 41 42 43 44
AADD(aRegistros,{_cPerg,"01","Produto            ?","","","mv_ch1","C",15,00,00,"G","","mv_par01",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","ZSB1","","","","",""})
AADD(aRegistros,{_cPerg,"02","Quantidade         ?","","","mv_ch2","N",10,02,00,"G","","mv_par02",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"03","Valor              ?","","","mv_ch3","N",16,04,00,"G","","mv_par03",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","","","","","",""})

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