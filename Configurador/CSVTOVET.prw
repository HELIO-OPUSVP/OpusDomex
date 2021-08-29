#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCSVTOVET  บAutor  ณHelio Ferreira      บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#DEFINE N_BUFFER 1000000
#DEFINE ENTER CHR(10)+CHR(13)

User Function CSVTOVET(cArquivo)

Local aArquivo := Nil
Local	aLinha
Local	cTexto
Local c_buffer
Local H_ler
Local nX
Local nY
Local X
Local Y

If !Empty(cArquivo)
	c_buffer := space(N_BUFFER)
	H_ler    := fOpen(cArquivo, 0)
	
	fRead(H_Ler,@c_Buffer,N_BUFFER)
	fClose(H_ler)
	
	aArquivo := {}
	aLinha   := {}
	cTexto   := c_buffer
	
	nX := 1
	For x := 1 to Len(cTexto)
		If Subs(cTexto,x,1) == Chr(10)
			cLinha := Subs(cTexto,nX,x-nX)
			nY := 1
			For y := 1 to Len(cLinha)
				If Subs(cLinha,Y,1) == ';'
					cConteudo := Subs(cLinha,nY,y-nY)
					AADD(aLinha,cConteudo)
					nY := y+1
				EndIf
			Next y
			AADD(aArquivo,aClone(aLinha))
			nX := x+1
			aLinha := {}
		EndIf
	Next x
EndIf

Return aArquivo
