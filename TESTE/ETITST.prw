/*
���Fun��o    �MSCBPRINTER � Autor � ALEX SANDRO VALARIO � Data �  05/98   ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Confirgura qual a impressora e a saida utilizada           ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ModelPrt  = String com o modelo de impressara Zebra        ���
���          � cPorta    = String com a porta   ex.: "COM2:9600,e,7,2"    ���
���          � nDensidade= Numero com a densidade ref qtde de pixel por mm���
���          � nTamanho  = Tamhado da etiqueta em mm.                     ���
���          � lSrv      = Se .t. imprime no server,.f. no client         ���
���          � nPorta    = numero da porta de outro server                ���
���          � cServer   = enderdeco IP de outro server                   ���
���          � cEnv      = enviroment do outro server            


If MSCbModelo('ZPL',ModelPrt)
   oP:= MSCBZPL():New(ModelPrt,cPorta,nDensidade,nTamanho,lSrv,nPorta,cServer,cEnv,nMemoria,cFila,lDrvWin,cPathIni) 
ElseIf MSCbModelo('DPL',ModelPrt)
   oP:= MSCBDPL():New(ModelPrt,cPorta,nDensidade,nTamanho,lSrv,nPorta,cServer,cEnv,nMemoria,cFila,lDrvWin,cPathIni) 
ElseIf MSCbModelo('EPL',ModelPrt)
   oP:= MSCBEPL():New(ModelPrt,cPorta,nDensidade,nTamanho,lSrv,nPorta,cServer,cEnv,nMemoria,cFila,lDrvWin,cPathIni) 
ElseIf MSCbModelo('IPL',ModelPrt)
   oP:= MSCBIPL():New(ModelPrt,cPorta,nDensidade,nTamanho,lSrv,nPorta,cServer,cEnv,nMemoria,cFila,lDrvWin,cPathIni) 
Else         
   // modelo nao encontado, portanto default zebra com densidade 6
	oP:= MSCBZPL():New("S500-6",cPorta,nDensidade,nTamanho,lSrv,nPorta,cServer,cEnv,nMemoria,cFila,lDrvWin,cPathIni)    
EndIf        
*/


/*
Parametros� ModelPrt  = String com o modelo de impressara Zebra        ���
          � cPorta    = String com a porta   ex.: "COM2:9600,e,7,2"    ���
          � nDensidade= Numero com a densidade ref qtde de pixel por mm���
          � nTamanho  = Tamhado da etiqueta em mm.                     ���
          � lSrv      = Se .t. imprime no server,.f. no client         ���
          � nPorta    = numero da porta de outro server                ���
          � cServer   = enderdeco IP de outro server                   ���
          � cEnv      = enviroment do outro server            
MSCBPRINTER(ModelPrt,cPorta,nDensidade,nTamanho,lSrv,nPorta,cServer,cEnv,nMemoria,cFila,lDrvWin,cPathIni)          

*/


#include "rwmake.ch"

User Function ETITST

Local nX
Local cPorta
Local nXLocal 
	                         
cPorta :='LPT1'

//MSCBPRINTER("TLP 2844",cPorta,,,.F.)
//MSCBBEGIN(1,6)                               	
//MSCBSAY(5,05,"TLP 2844","N","4","1,2")
//MSCBSAY(20,05,"DESCRICAO:","N")
//MSCBEND()
//MSCBCLOSEPRINTER()

//MSCBPRINTER("ZEBRA",cPorta,,,.F.)

//MSCBPRINTER("INTERMEC",cPorta,40,300,.F.,,,,,,.T.)
//MSCBPRINTER(ModelPrt  ,cPorta,nDensidade,nTamanho,lSrv,nPorta,cServer,cEnv,nMemoria,cFila,lDrvWin,cPathIni)          
  MSCBPRINTER("INTERMEC",cPorta,40        ,300     ,.F. ,      ,       ,    ,        ,     ,.T.)
////--Intermec - INTERMEC, 3400-8, 3400-16, 3600-8, 4440-16, 7421C-8 
MSCBBEGIN(5,6)
//Parametro � nX1mm     = Posi��o X1 em Milimetros                       ���
//          � nY1mm     = Posi��o Y1 em Milimetros                       ���
//          � nX2mm     = Posi��o X2 em Milimetros                       ���
//          � nY2mm     = Posi��o Y2 em Milimetros                       ���
//          � nExpessura= Numero com a expessura em pixel                ���
//          � cCor      = String com a Cor Branco ou Preto  ("W" ou "B") ���
//MSCBBOX(1,0.5,16.5,10,05,"B")
//Intermec - (0,1,7,20,21,22,27)
MSCBSAY(02,01 ,"DOMEX TESTE FONTE A","N","0","020,030")
MSCBSAY(12,02 ,"DOMEX TESTE FONTE B","N","1","020,030")
MSCBSAY(22,03 ,"DOMEX TESTE FONTE C","N","7","020,030")
MSCBSAY(32,04 ,"DOMEX TESTE FONTE D","N","20","020,030")
MSCBSAY(42,05 ,"DOMEX TESTE FONTE E","N","21","020,030")
MSCBSAY(52,06 ,"DOMEX TESTE FONTE F","N","22","020,030")
MSCBSAY(62,07 ,"DOMEX G"            ,"N","27","020,030")


MSCBEND()
MSCBCLOSEPRINTER()

return

MSCBPRINTER("INTERMEC",cPorta,40        ,300     ,.F. ,      ,       ,    ,        ,     ,.F.)
MSCBBEGIN(1,6)
MSCBSAY(02,01 ,"DOMEX TESTE FONTE A","N","0","020,030")
MSCBSAY(12,02 ,"DOMEX TESTE FONTE B","N","1","020,030")
MSCBSAY(22,03 ,"DOMEX TESTE FONTE C","N","7","020,030")
MSCBSAY(32,04 ,"DOMEX TESTE FONTE D","N","20","020,030")
MSCBSAY(42,05 ,"DOMEX TESTE FONTE E","N","21","020,030")
MSCBSAY(52,06 ,"DOMEX TESTE FONTE F","N","22","020,030")
MSCBSAY(62,07 ,"DOMEX G"            ,"N","27","020,030")


MSCBEND()
MSCBCLOSEPRINTER()


return

//Intermec - INTERMEC, 3400-8, 3400-16, 3600-8, 4440-16, 7421C-8 
//Intermec - (0,1,7,20,21,22,27)
MSCBPRINTER("3400-8",cPorta,,,.F.)
MSCBBEGIN(1,6)                               	
MSCBSAY(5,05,"3400-8","N","1","1,2")
MSCBSAY(20,05,"DESCRICAO:","N")
MSCBEND()
MSCBCLOSEPRINTER()

MSCBPRINTER("3400-16",cPorta,,120,.F.,,,,,,.T.)
MSCBBEGIN(1,6)                               	
MSCBSAY(5,05,"3400-16","N","1","1,2")
MSCBSAY(20,05,"DESCRICAO:","N")
MSCBEND()
MSCBCLOSEPRINTER()

MSCBPRINTER("3600-8",cPorta,,120,.F.,,,,,,.T.)
MSCBBEGIN(1,6)                               	
MSCBSAY(5,05,"3600-8","N","1","1,2")
MSCBSAY(20,05,"DESCRICAO:","N")
MSCBEND()
MSCBCLOSEPRINTER()
////--Intermec - INTERMEC, 3400-8, 3400-16, 3600-8, 4440-16, 7421C-8 

MSCBPRINTER("4440-16",cPorta,,120,.F.,,,,,,.T.)
MSCBBEGIN(1,6)                               	
MSCBSAY(5,05,"4440-16","N","1","1,2")
MSCBSAY(20,05,"DESCRICAO:","N")
MSCBEND()
MSCBCLOSEPRINTER()

MSCBPRINTER("7421C-8",cPorta,,120,.F.,,,,,,.T.)
MSCBBEGIN(1,6)                               	
MSCBSAY(5,05,"7421C-8 ","N","1","1,2")
MSCBSAY(20,05,"DESCRICAO:","N")
MSCBEND()
MSCBCLOSEPRINTER()



//MSCBPRINTER("INTERMEC",cPorta,,)
//MSCBCHKStatus(.T.)
////MSCBINFOETI("3600-8","MODELO 1")
//MSCBBEGIN(1,6)
//MSCBSAY(20,05,"DESCRICAO:","N","1","1,2"/*, "12" "020,030"*/)
//MSCBSAY(20,05,"DESCRICAO:","N","1","1,2")
//MSCBEND()           
//MSCBCLOSEPRINTER()


MSCBPRINTER("TLP 2844","LPT1",,59,.F.)   //MSCBPRINTER("TLP 2844","LPT1",,221,.F.)
MSCBCHKSTATUS(.F.)
MSCBBEGIN(1,6)
MSCBBOX(12,17,88,49)     // Inicio BOX Monta BOX (x,y,x,y,espessura)
MSCBSAY    (14,03,"Rosemberger","N","1","2,2")  //MSCBLINEH  (01,16,78,03,"B")                              // LINHA HORIZONTAL//MSCBSAY    (08,06,"OF:","N","2","2,3")             // TITULO FORNECEDOR
MSCBSAY    (28,07,"Domex","N","1","2,2")        //MSCBLINEH  (01,16,78,03,"B")

MSCBEND()
MSCBCLOSEPRINTER() 

cModelo    := "Z4M"  
cPorta     := "LPT1"
lPrinOK    := MSCBModelo("IPL","INTERMEC")
//msgalert(lPrinOK)
lPrinOK    := MSCBModelo("ZPL",cModelo)
//msgalert(lPrinOK)

MSCBPRINTER(cModelo,cPorta,,,.F.)
MSCBChkStatus(.F.)

MSCBBEGIN(1,5)
MSCBSAY(045,10+(10*04) -1   ,StrZero(10,4)+" Unidade(s)"                                                          ,'N',"0","40,50")

MSCBEND()

MSCBCLOSEPRINTER()

Return

/*
MSCBSayBar
Tipo: Impress�o
     Imprime C�digo de Barras


Sintaxe

MSCBSAYBAR(<nXmm>,<nYmm>,<cConteudo>,<cRotacao>,<cTypePrt>,<nAltura>, ;
<lDigVer>,<lLinha>,<lLinBaixo>,<cSubSetIni>,<nLargura>,<nRelacao>, ;
<lCompacta>,<lSerial>,<cIncr>,<lZerosL>)

Par�metros
     nXmm             = Posi��o X em Mil�metros                        
     nYmm             = Posi��o Y em Mil�metros                        
     cConteudo         = String a ser impressa                          
     cRota��o          = String com o tipo de Rota��o
     cTypePrt          = String com o Modelo de C�digo de Barras
                  Zebra:     
                    2 - Interleaved 2 of 5
                    3 - Code 39
                    8 - EAN 8
                    E - EAN 13
                    U - UPC A
                    9 - UPC E
                    C - CODE 128
                  Allegro:
                    D - Interleaved 2 of 5
                    A - Code 39
                    G - EAN 8
                    F - EAN 13
                    B - UPC A
                    C - UPC E
                    E - CODE 128
                  Eltron:
                    2   - Interleaved 2 of 5
                    3   - Code 39
                    E80 - EAN 8
                    E30 - EAN 13
                    UA0 - UPC A
                    UE0 - UPC E
                    1   - CODE 128
                   
[nAltura]        = Altura do c�digo de Barras em Mil�metros       
*[ lDigver]      = Imprime d�gito de verifica��o              
[lLinha]         = Imprime a linha de c�digo                   
*[lLinBaixo]     = Imprime a linha de c�digo acima das barras
[cSubSetIni]     = Utilizado no code128                           
[nLargura]      = Largura da barra mais fina em pontos default 3
[nRelacao]      = Rela��o entre as barras finas e grossas em pontos default 2
[lCompacta]     = Compacta o c�digo de barra                    
[lSerial]     = Serializa o c�digo                            
[cIncr]        = Incrementa quando for serial positivo ou negativo
      *[lZerosL]      = Coloca zeros a esquerda no numero serial       


Exemplo
     MSCBSAYBAR(20,22,AllTrim(SB1->B1_CODBAR),"N","C",13)




