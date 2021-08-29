#include "rwmake.ch"

User Function MT410CPY()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT410CPY  ºAutor  ³Helio Ferreira      º Data ³  20/05/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada criado para zerar alguns campos na copia  º±±
±±º          ³ de Pedidos de Vendas                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

LOCAL _nPosCab,nCab,aCpcont:={} //Matriz com os dados do C6 que serão tratados
Local x, nItem
Local _nPosProd
Local _nPosGeraOP
Local aCusto    := {}
Local aAreaSB1  := SB1->( GetArea() )
Local _nPosCusto
Local _nPosStatus
Local nPC6PRCVEN
Local nPC6PRUNIT

//M->C5_PLFAT   := "S"                                      
M->C5_XXLIBFI   := '0'
M->C5_TIPOCLI   := space(01)
M->C5_ELABORA   := SUBSTR(CUSUARIO,7,15)                                  
M->C5_XAUTCC    := Space(Len(SC5->C5_XAUTCC)) 
M->C5_XDTAUT 	 := CtoD('  /  /  ')
M->C5_XVLRAUT	 := 0   
M->C5_XHREMIS   := Time()  

If SC5->( FieldPos("C5_USER") ) <> 0
	M->C5_USER      := Alltrim(__cUserId)
Endif


AADD(aCpcont,{"C6_LOTECTL" , SPACE(TAMSX3("C6_LOTECTL")[1]) })
AADD(aCpcont,{"C6_LOCALIZ" , "13EXPEDICAO"                  })
AADD(aCpcont,{"C6_ENTRE3"  , CtoD("  /  /  ")               })
AADD(aCpcont,{"C6_DTFATUR" , CtoD("  /  /  ")               })
AADD(aCpcont,{"C6_XXDTDEF" , CtoD("  /  /  ")               })
AADD(aCpcont,{"C6_XOPER"   , SPACE(TAMSX3("C6_XOPER")[1])   })
AADD(aCpcont,{"C6_ENTREG"  , CtoD("  /  /  ")               })

FOR nCab = 1 TO LEN(aCpcont)
	_nPosCab   := aScan(AHEADER,{ |x| Upper(AllTrim(x[2])) == aCpcont[nCab,1]})
	IF _nPoscab = 0
		ALERT("Erro dicionario campo " + aCpcont[nCab,1])
		RETURN
	ENDIF
	FOR nItem = 1 TO LEN(aCols)
		aCols[nItem,_nPoscab] := aCpcont[nCab,2]
	NEXT nItem
NEXT nCab


_nPosProd   := aScan(AHEADER,{ |x| Upper(AllTrim(x[2])) == "C6_PRODUTO"})
_nPosGeraOP := aScan(AHEADER,{ |x| Upper(AllTrim(x[2])) == "C6_XGERAOP"})
_nPosCusto  := aScan(AHEADER,{ |x| Upper(AllTrim(x[2])) == "C6_XCUSUNI"})
_nPosStatus := aScan(AHEADER,{ |x| Upper(AllTrim(x[2])) == "C6_XSTACUS"})
nPC6PRCVEN  := aScan(AHEADER,{ |x| Upper(AllTrim(x[2])) == "C6_PRCVEN" })
nPC6PRUNIT  := aScan(AHEADER,{ |x| Upper(AllTrim(x[2])) == "C6_PRUNIT" })

SB1->( dbSetOrder(01) )
For x := 1 To Len(aCols)                      
   SB1->( dbSeek(xFilial()+aCols[x,_nPosProd]))
   //If SB1->B1_TIPO == 'PR' 
   //   aCols[x,_nPosGeraOP] := '2'
   //Else 
   //   aCols[x,_nPosGeraOP] := '1'
   //EndIf

   If SB1->B1_TIPO == 'PA' 
      aCols[x,_nPosGeraOP] := '1'
   Else 
      aCols[x,_nPosGeraOP] := '2'
   EndIf

   //Recalcular o custo 
   aCusto               := U_RetCust(aCols[x,_nPosProd],'S')
   nCusMedio            := aCusto[1]
   cStatus              := aCusto[2]
   aCols[x,_nPosCusto]  := nCusMedio
   aCols[x,_nPosStatus] := cStatus
   aCols[x,nPC6PRUNIT]  := aCols[x,nPC6PRCVEN]

Next x

SC5->( dbGoBottom() )

While !SC5->( EOF() )
   SC5->( dbSkip() )
End

RestArea(aAreaSB1)

Return
