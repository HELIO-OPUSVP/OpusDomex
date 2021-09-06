#include "protheus.ch"
#DEFINE CRLF Chr(13)+Chr(10) 
/*/{Protheus.doc} VLDLAYOUT
//TODO Descrição: função para validar layout Zebra Designer
@author Ricardo Roda
@since 14/03/2019
@version undefined
@example
(examples)
@see (links_or_references)
/*/

User Function ZDESIGNER(aVetor,cLayout,cImpres)

Local cLinha  := ""
Local lPrim   := .T.
Local aLayout := {}
Local aVarEtq  := {}
Local ctexto:= ""
Local oFont    := NIL
Local oMemo    := NIL
Local oDlg     := NIL
Local cFile		:= NomeAutoLog()
Local nVar		:= 0
Local cMask    := "Arquivos Texto" + "(*.TXT)|*.txt|"
Local cTCBuild := "TCGetBuild"
Local lContinua:= .T.
Private lRet	:= .T.
Private cEOL   := "CHR(13)+CHR(10)"
Private nHdl
Private cPacth := GetSrvProfString('Startpath','')
Private cLocaliz := cPacth+'\Layout Zebra\'

cArq := cLocaliz+cLayout+".prn"
nHdl    := fOpen(cArq,68)

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Endif

If nHdl == -1
	MsgAlert("O arquivo nao pode ser aberto! Verifique","Atencao!")
	Return .F.
Endif


FT_FUSE(cArq)
FT_FGOTOP()


aVarEtq  := {}
While !FT_FEOF()
	cLinha := FT_FREADLN()
	AADD(aVarEtq,cLinha)
	FT_FSKIP()
EndDo

FT_FUSE()

FClose(nHdl)                 


For _i:= 1 to len(aVarEtq) 
	IF AT("aVetor",aVarEtq[_i]) > 0                  
	  	nVar+= 1
	  if val(substr(aVarEtq[_i],AT("aVetor",aVarEtq[_i])+7,2)) > len(aVetor)
			cVarVetor:= "*** CAMPO aVetor["+substr(aVarEtq[_i],AT("aVetor",aVarEtq[_i])+7,2)+"] NÃO INFORMADO ***"
			msgStop("***O CAMPO aVetor["+substr(aVarEtq[_i],AT("aVetor",aVarEtq[_i])+7,2)+"] FOI INFORMADO NO LAYOUT DA ETIQUETA,"+CRLF+" MAS NÃO FOI INFORMADO NO VETOR DO PROGRAMA ***","AVISO" )
	  		lContinua:= .F.	
	  Else
			cVarVetor:= &(substr(aVarEtq[_i],AT("aVetor",aVarEtq[_i]),10))
     Endif
			cStrIni:= "'"+substr(aVarEtq[_i],1,AT("aVetor",aVarEtq[_i])-1)
			cStrFim:= substr(aVarEtq[_i],AT("aVetor",aVarEtq[_i])+10,len(aVarEtq[_i]))+"'"
			AADD(aLayout,cStrIni+cVarVetor+cStrFim)		  
	Else
		AADD(aLayout,aVarEtq[_i])
	Endif                  

Next _i
          
    if  nVar <> len(aVarEtq)                                                                                         
      _msg:= "***A QUANTIDADE DE VARIAVEIS DO PROGRAMA É DIFERENTE DA QUANTIDADE DE VARIAVEIS DA ETIQUETA***"+CRLF   
      _msg+= "QUANTIDADE DE VARIAVEIS NO PROGRAMA: "+cValToChar(nVar)+CRLF
      _msg+= "QUANTIDADE DE VARIAVEIS NA ETIQUETA: "+cValToChar(len(aVarEtq))+CRLF
      _msg+= "VERIFIQUE"
    	msgStop(_msg,"AVISO" )
    Endif    

 


Return aLayout  


User Function TSTLAYOUT()
       
 Local aVetor:={}
 Local cLayout:= "ETIQ.MODELO2"
 Local aVetor2:= {}
 
  AADD(aVetor,"00003884874")//CODIGO DE PRODUTO
  AADD(aVetor,"TEXTO 2")//DESCRIÇÃO DE PRODUTO 
  AADD(aVetor,"TEXTO 3")//QUANTIDADE 
  AADD(aVetor,"TEXTO 4")//DATA
  AADD(aVetor,"TEXTO 5")//MODELO
  AADD(aVetor,"TEXTO 6")//SERIAL NUMBER
  AADD(aVetor,"TEXTO 7")//TEXTO1
  AADD(aVetor,"TEXTO 8")//TEXTO2
  AADD(aVetor,"TEXTO 9")//TEXTO3
  AADD(aVetor,"TEXTO 10")//CODIGO DE BARRAS
  
 
  //vetor que será retornado   
  aVetor2:= U_ZDESIGNER(aVetor,cLayout)
      
      
Return //aVetor2
