#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#DEFINE VKTAB CHAR(9)


User Function DMXTSTTB()
Private cGetTab := SPACE(20)
Private cGetTab2 := SPACE(20)
Define MsDialog oDlg title 'Analise Tab' from 0,0 to 300,400 pixel

@ 013,002 to 78,250 label 'Analise' of oDlg pixel
@ 030,010 say '  Digite o valor desejado ' size 65,10 of oDlg pixel
@ 080,010 MSGET oGetTab var cGetTab    Valid ValdidTab() size 80,10 of oDlg pixel
@ 080,100 MSGET oGetTab2 var cGetTab2  Valid ValdidTab() size 80,10 of oDlg pixel

   

@ 120, 010 BUTTON oImprime    PROMPT "Imprimir" 					  ACTION Processa( {||  } ) SIZE 080,20 PIXEL OF oDlg

Activate MsDialog oDlg Center //On Init //EnchoiceBar(oDlg,bok,bcancel)


Static Function ValdidTab()

 
//cTstTab := "123456" + char(9) + "88898786X"
nPosTab := At(char(13),cGetTab)

iF LastKey() == 9 //VKTAB
    nPosTab := At(VKTAB,cGetTab)
    cTstTab1 := Substring(cGetTab,1,nPosTab-1)
    cTstTab2 := Substring(cGetTab,nPosTab+1)
EndIf

Return .T.
