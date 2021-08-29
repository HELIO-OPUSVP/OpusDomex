#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 20/07/01

User Function RNK_CN()        // incluido pelo assistente de conversao do AP5 IDE em 20/07/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CSTRING,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("TAMANHO,AORDEM,CPERG,ARETURN,NOMEPROG,NLASTKEY")
SetPrvt("M_PAG,WNREL,NCNTFOR,LIMPRIMIU,CCABEC1,CCABEC2")
SetPrvt("CBCONT,LI,ASITUACA,ACOMPONENT,ATOTAL,AQUEBRA")
SetPrvt("BQUEBRA,BCOND,LEND,CTITLEG,MEUTRAB,TRABCAMPOS")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RMK_CN   ³ Autor ³ Eduardo Riera         ³ Data ³ 14.01.97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alt. para RDMake     ³ Adriano Fernando Raposo dos Santos              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rela‡Æo de Or‡amentos de Venda                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MATR605()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±³ Rev A    ³ Gerardo  RDT  (AGO/02) - RANKING POR CLIENTE (CN)          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//Local wnrel
cString := "SCJ" 
Limite  := 220

#IFDEF WINDOWS
   Titulo  := OemToAnsi("Relacao dos Orcamento de Venda")
#ELSE
   Titulo  := "Relacao dos Orcamento de Venda"
#ENDIF  

#IFDEF WINDOWS
   cDesc1 :=OemToAnsi("Este relatorio ir  imprimir a rela‡„o dos Or‡amentos de Venda")
   cDesc2 :=OemToAnsi("conforme os parametros solicitados.                          ")
   cDesc3 :=OemToAnsi("")
#ELSE
   cDesc1 :="Este relatorio ir  imprimir a rela‡„o dos Or‡amentos de Venda"
   cDesc2 :="conforme os parametros solicitados.                          "
   cDesc3 :=""
#ENDIF

Tamanho  := "G"
aOrdem   := {"Numero","Cliente","Produto"} 
cPerg    := "MTR605"
aReturn  := { "Zebrado",1,"Administracao", 1, 2, 1, "",1 } 
nomeprog := "RNK_CN"
NomeCli  := ""  
NumOrca  := ""
nLastKey := 0

m_pag := 01
wnrel := "MATR605"            

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ DATA   ³ BOPS ³Prograd.³ALTERACAO                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³23.11.98³MELHOR³Viviani  ³Inclusao de pergunta e conversao de moeda     ³±±
±±³23.11.98³MELHOR³Viviani  ³Acerto do lay-out                             ³±±
±±³20.01.03³MELHOR³Fabrício ³Impressão por ordem de valor                  ³±±
±±ÀÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("MTR605",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                              ³
//³ mv_par01            // Cliente de  ?                              ³
//³ mv_par02            // Cliente ate ?                              ³   
//³ mv_par03            // Emissao de  ?                              ³
//³ mv_par04            // Emissao ate ?                              ³
//³ mv_par05            // Numero  de  ?                              ³
//³ mv_par06            // Numero  ate ?                              ³
//³ mv_par07            // Produto de  ?                              ³
//³ mv_par08            // Produto ate ?                              ³   
//³ mv_par09            // Grupo de  ?                                ³   
//³ mv_par10            // Grupo ate ?                                ³   
//³ mv_par11            // Lista Componente ( Sim/N„o ) ?             ³   
//³ mv_par12            // Lista Quais ? Todos/Aberto/Baixado/Cancel. ³   
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrdem,.F.,Tamanho)
If nLastKey == 27
	dbSelectArea(cString)
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27
	dbSelectArea(cString)
	Set Filter To
	Return
Endif

//RptStatus({|lEnd| C605Imp()})
//RptStatus(C605Imp())
RptStatus({|| C605IMP()})// Substituido pelo assistente de conversao do AP5 IDE em 20/07/01 ==> RptStatus({|| Execute(C605IMP)})

// C605IMP()
Return 

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Reseta Impressora                                        ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  @ 01,0 PSAY CHR(27)+"E"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CA605Imp ³ Autor ³ Eduardo Riera         ³ Data ³ 14.01.97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MTR605                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP5 IDE em 20/07/01 ==> Function C605Imp
Static Function C605Imp()

nCntFor    := 0 
lImprimiu  := .F.
cCabec1    := ""
cCabec2    := ""
cbCont     := 0
Li         := 80
aSituaca   := { " ABERTO ","BAIXADO ","CANCEL." } 
aComponent := {}
aTotal     := { {  0 , 0 , 0 ,0 } ,{  0 , 0 , 0 ,0 } }
aQuebra    := { Nil }
bQuebra    := bCond := {|| Nil }
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Cabecalho                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//          1         2         3         4         5         6         7         8         9        10        11        12        13        14         15       16        17        18        19       20        21         
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//CN       |CLIENTE                                 |PRODUTO                                                                                              |OUTROS
//NUMERO IT|CODIGO LJ RAZAO SOCIAL                  |CODIGO          DESCRICAO                      QUANTIDADE PRECO VENDA     TOTAL      |PRAZO           OBS     DPT     SITUACAO CONTATO              TELEFONE       OF
//999999 XX 999999-99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999,999.99 9999,999.99 999,999,999.99  XXXXXXXXXXXXXXX XXXXXXX XXXXXXX XXXXXXXX XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXX  XXXXXX

//cCabec1 :="CN       |CLIENTE                               |PRODUTO                                                                                                 |OUTROS"
//cCabec2 :="NUMERO IT|CODIGO RAZAO SOCIAL                   |CODIGO        DESCRICAO                      QUANTIDADE PRECO VENDA     aqui  TOTAL     PRAZO        DATA   |OBS     DPT  SITUACAO      CONTATO            TELEFONE      OF"
cCabec1 :="Periodo: "+dtoc(mv_par03)+" ate "+dtoc(mv_par04)+"                                             Suporte Técnico             Vendedor                TOTAL"
cCabec2 := ""
Titulo  := Titulo + " (Ordem: " + aOrdem[aReturn[8]]+")" 
trabcampos := {}
valcont := { 0, 0, 0, 0, 0, 0 }
cncont := 0
aadd(trabcampos, { "TB_NUM", "C", 6, 0 } )
aadd(trabcampos, { "TB_NOMECLI", "C", 30, 0 } )  
aadd(trabcampos, { "TB_VEND", "C", 12, 0 } )
aadd(trabcampos, { "TB_SUP", "C", 14, 0 } )
aadd(trabcampos, { "TB_ATOTAL", "N", 15, 2 } )


meutrab := criatrab(trabcampos, .t.)
dbusearea(.t.,,meutrab,meutrab,.t.,.f.)
indregua(meutrab, meutrab, "TB_ATOTAL",,,"Criando indice ...")

dbSelectArea("SCK")
SetRegua(RecCount())

Do Case 
	Case aReturn[8] == 1
		dbSetOrder(1)
		dbSeek(xFilial()+MV_PAR05,.T.)
		bCond := {||!Eof() .And. xFilial("SCK") == SCK->CK_FILIAL .And. ;
						SCK->CK_NUM >= MV_PAR05 .And.;
						SCK->CK_NUM <= MV_PAR06 }
		bQuebra := {|| SCK->CK_NUM }
	Case aReturn[8] == 2
		dbSetOrder(2)
		dbSeek(xFilial()+MV_PAR01,.T.)
		bCond := {||!Eof() .And. xFilial("SCK") == SCK->CK_FILIAL .And. ;
						SCK->CK_CLIENTE >= MV_PAR01 .And.;
						SCK->CK_CLIENTE <= MV_PAR02 }
		bQuebra := {||SCK->CK_CLIENTE+SCK->CK_LOJA }
	Case aReturn[8] == 3
		dbSetOrder(3)
		dbSeek(xFilial()+MV_PAR07,.T.)
		bCond := {||!Eof() .And. xFilial("SCK") == SCK->CK_FILIAL .And. ;
 						SCK->CK_PRODUTO >= MV_PAR07 .And.;
						SCK->CK_PRODUTO <= MV_PAR08 }
		bQuebra := {|| SCK->CK_PRODUTO }
EndCase                 

While ( Eval(bCond) )
	#IFNDEF WINDOWS
		If LastKey() = 286  
			lEnd := .t.
                Else
                        lEnd := .f.
                Endif
	#ENDIF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona Cabecalho do Or‡amento de Venda                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	WHILE !EOF() .AND. (MV_PAR12==2) .AND. (!Empty(SCK->CK_NUMPV))
     DBSELECTAREA("SCK")
     SKIP 
    ENDDO    
    WHILE !EOF() .AND. (MV_PAR12==3) .AND. (SUBSTR(SCK->CK_NUMPV,1,2) <> "OF")
     DBSELECTAREA("SCK")
     SKIP
    ENDDO
    WHILE !EOF() .AND. (MV_PAR12==4) .AND. (ALLTRIM(SCK->CK_NUMPV) <> "MORTO") 
     DBSELECTAREA("SCK")	
     SKIP
    ENDDO                     
	
	dbSelectArea("SCJ")
	dbSetOrder(1)
	dbSeek(xFilial()+SCK->CK_NUM)
	
		
	If (  SCK->CK_CLIENTE >= MV_PAR01 .And. SCK->CK_CLIENTE <= MV_PAR02 .And.;
			SCJ->CJ_EMISSAO >= MV_PAR03 .And. SCJ->CJ_EMISSAO <= MV_PAR04 .And.;
			SCK->CK_NUM     >= MV_PAR05 .And. SCK->CK_NUM     <= MV_PAR06 .And.;
            SCK->CK_PRODUTO >= MV_PAR07 .And. SCK->CK_PRODUTO <= MV_PAR08)/* .And.;
         	IF(MV_PAR12 == 2,SCJ->CJ_STATUS=="A",.T.)                     .And.;
			If(MV_PAR12 == 3,SCJ->CJ_STATUS=="B",.T.)                     .And.;
			If(MV_PAR12 == 4,SCJ->CJ_STATUS=="C",.T.) )                  */

    		
		lImprimiu := .T.
		If ( MV_PAR11 == 1 ) // Lista Componente
			aComponent := {}
			dbSelectArea("SCL")
			dbSetOrder(1)
			dbSeek(xFilial()+SCK->CK_NUM+SCK->CK_ITEM,.T.)
		EndIf


                // Impressao de Legenda (Adriano 28.10.99)
                If ( li > 56 )
                 cTitLeg := "LEGENDAS  " + Replicate("*",210)
                   //@ li,000 PSAY cTitLeg
                   //li := li + 1
                   //@ li,000 PSAY "MOTIVO DE PERDA:  CNC - Cotacao Cancelada    CPC - Cliente Perdeu Concorrencia    PJC - Projeto Cancelado    PRC - Perda por Preco     PRP - Preco por Prazo    DIV - Diversos"
                   //li := li + 1
                   //@ li,000 PSAY "MATERIAIS      :  FO  - Fibra Otica          RF  - Radio Frequencia              SENS - Sensor               WRL - Wireless            DIV - Diversos         "
                   li := cabec(Titulo,cCabec1,cCabec2,nomeprog,Tamanho,15)
                   li := li + 1
		Endif
		If ( aQuebra[1] != Eval(bQuebra) )
			aQuebra[1] := Eval(bQuebra)
		EndIf			
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+SCK->CK_CLIENTE+SCK->CK_LOJA)

		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SCK->CK_PRODUTO)

/*            IF SUBSTR(SB1->B1_GRUPO,1,2) == "RF"

		@ li,000 PSAY SCK->CK_NUM+"-"+SCK->CK_ITEM 
		@ li,010 PSAY SCK->CK_CLIENTE
		@ li,017 PSAY SubStr(SA1->A1_NOME,1,30)
		@ li,048 PSAY SCK->CK_PRODUTO  
        @ li,063 PSAY SubStr(SCK->CK_DESCRI,1,30)
        @ li,094 PSAY SCK->CK_QTDVEN PICTURE TM(SCK->CK_PRCVEN,10,2)
        @ li,105 PSAY xMoeda(SCK->CK_PRCVEN,1,1,SCJ->CJ_EMISSAO)   PICTURE TM(SCK->CK_PRCVEN,11,2)
        @ li,115 PSAY xMoeda(SCK->CK_PRCVEN*SCK->CK_QTDVEN,1,1,SCJ->CJ_EMISSAO)   PICTURE TM(SCK->CK_VALOR ,14,2)
        @ li,131 PSAY SUBSTR(SCK->CK_PRAZO,1,10)
        @ li,144 PSAY SCJ->CJ_EMISSAO
        cOBS := SUBSTR(SCK->CK_OBS,1,3)
        cDPT := SUBSTR(SCK->CK_DPT,1,4)
        @ li,154 PSAY cOBS 
        @ li,161 PSAY cDPT
   
*/   
                         
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Acumulo Totais                                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	   	NomeCLi := SubStr(SA1->A1_NREDUZ,1,30)  
	   	NomeVen := SubStr(SCJ->CJ_VEND,1,12)  
	   	NomeSup := SubStr(SCJ->CJ_ELABORA,1,14) 
	
		//For nCntFor := 1 To Len(aTotal)
                      //aTotal[nCntFor,1] := aTotal[nCntFor,1] + SCK->CK_QTDVEN
                      //aTotal[nCntFor,2] := aTotal[nCntFor,2] + xMoeda(SCK->CK_PRCVEN,1,1,SCJ->CJ_EMISSAO)
                      //aTotal[nCntFor,3] := aTotal[nCntFor,3] + xMoeda(SCK->CK_PRCVEN,1,1,SCJ->CJ_EMISSAO)
                      //aTotal[nCntFor,4] := aTotal[nCntFor,4] + xMoeda(SCK->CK_VALOR,1, 1,SCJ->CJ_EMISSAO)
	   //	Next 
		
			NumOrca := SubStr(SCJ->CJ_NUM,6,0)  
	
		For nCntFor := 1 To Len(aTotal)
                      aTotal[nCntFor,1] := aTotal[nCntFor,1] + SCK->CK_QTDVEN
                      aTotal[nCntFor,2] := aTotal[nCntFor,2] + xMoeda(SCK->CK_PRCVEN,1,1,SCJ->CJ_EMISSAO)
                      aTotal[nCntFor,3] := aTotal[nCntFor,3] + xMoeda(SCK->CK_PRCVEN,1,1,SCJ->CJ_EMISSAO)
                      aTotal[nCntFor,4] := aTotal[nCntFor,4] + xMoeda(SCK->CK_VALOR,1, 1,SCJ->CJ_EMISSAO)
		Next
		
                // Alteracao por Adriano em 26/01/00
                // para impressao correta da Situacao
                // @ li,169 PSAY aSituaca[Asc(SCJ->CJ_STATUS)-64]

/*

                If Empty(SCK->CK_NUMPV)
                   @ li,167 PSAY "ABERTO"
                Else     
                   If (ALLTRIM(SCK->CK_NUMPV) <> "MORTO")
                    @ li,167 PSAY "BAIXADO"        
                   else
                    @ li,167 PSAY "MORTO"        
                   endif 
                EndIf
                                              
                @ li,176 PSAY SUBSTR(SCJ->CJ_CONTATO,1,19)
                @ li,196 PSAY SUBSTR(SCJ->CJ_FONE,1,14)
                @ li,212 PSAY ALLTRIM(SCK->CK_NUMPV)
                li := li + 1           
  
*/

     //            EndIf


	EndIf   
	
	dbSelectArea("SCK")
	dbSkip()
	IncRegua()
	If ( aQuebra[1] != Eval(bQuebra) .And. aTotal[2,1] > 0 )
	dbselectarea(meutrab)
	reclock(meutrab,.t.)
/*      li := li + 1
		If ( aReturn[8] == 1 )
                        @ li,000 PSAY "Total do Orcamento: "
		EndIf	
		If ( aReturn[8] == 2 )
                        @ li,000 PSAY "Total do Cliente: "
		EndIf	
		If ( aReturn[8] == 3 )
                        @ li,000 PSAY "Total do Produto: "
		EndIf			*/
//  		@ li,017 PSAY NomeCli 
	TB_NOMECLI := NomeCli 
	TB_NUM     := SCJ-> CJ_NUM 
	TB_SUP     := SCJ-> CJ_ELABORA
	TB_VEND    := SCJ-> CJ_VEND

   //	TB_DEMISSA := DataEmissao
//        @ li,115 PSAY aTotal[2,4]       PICTURE TM(aTotal[2,4],14,2)
	TB_ATOTAL := aTotal[2,4]
/*      li := li + 1
		@ li,000 PSAY Repl("-",Limite)
      li := li + 1*/
		aTotal[2,1] := 0
		aTotal[2,2] := 0
		aTotal[2,3] := 0
		aTotal[2,4] := 0
    msunlock()
    dbskip()
    dbselectarea("SCK")
	EndIf				
EndDo 
     
 

dbselectarea(meutrab)
dbgobottom()
while !bof()
  li := li + 1
  If ( aReturn[8] == 1 )
    @ li,000 PSAY "Total do Orcamento: "    
  EndIf	
  If ( aReturn[8] == 2 )
    @ li,000 PSAY "Total do Cliente: "
  EndIf	
  If ( aReturn[8] == 3 )
    @ li,000 PSAY "Total do Produto: "
  EndIf		
  if aReturn[8] == 1
    @ li,019 PSAY TB_NOMECLI  

  else
    @ li,017 PSAY TB_NOMECLI
  
  endif    
  
  if aReturn[8] == 1
    @ li,060 PSAY TB_NUM 

  else
    @ li,058 PSAY TB_NUM
  
  endif    
  if aReturn[8] == 1
    @ li,074 PSAY TB_SUP 

  else
    @ li,072 PSAY TB_SUP
  
  endif 
  if aReturn[8] == 1
    @ li,100 PSAY TB_VEND 

  else
    @ li,102 PSAY TB_VEND
  
  endif    
  
  for i := 1 to mlcount(SCJ->CJ_DESC)
      if li > 56
//        eject()
//        fCabec()
        li := cabec(titulo,cabec1,cabec2,wnrel,Tamanho) + 1
      endif
      @li, 53 psay memoline(SCJ->CJ_DESC,, i)
      li := li+1
    next
    if mlcount(SCJ->CJ_DESC) == 0
      li := li + 1
    endif
    @li, 0 psay CHR(27)+CHR(5)+CHR(1)+replicate("-",132)+CHR(27)+CHR(5)+CHR(2)
    li := li+1
 // endif
  dbskip()
//enddo
       
  @ li,115 PSAY TB_ATOTAL       PICTURE TM(aTotal[2,4],14,2)  
  li := li + 1
    @ li,000 PSAY Repl("-",Limite)
  li := li + 1
  dbskip(-5)
enddo
dbclosearea()
ferase(meutrab+".DBF") 
   
   

If lImprimiu
   li := li + 2
        @ li,000 PSAY "T O T A L  G E R A L --> "
//        @ li,094 PSAY aTotal[1,1]       PICTURE TM(aTotal[1,1],10,2)
//        @ li,105 PSAY aTotal[1,2]       PICTURE TM(aTotal[1,2],11,2)
        @ li,115 PSAY aTotal[1,4]       PICTURE TM(aTotal[1,4],14,2)

       // Impressao de Legenda (Adriano 28.10.99)
       li := 57
       cTitLeg := "LEGENDAS  " + Replicate("*",210)
       @ li,000 PSAY cTitLeg
       li := li + 1
       @ li,000 PSAY "MOTIVO DE PERDA:  CNC - Cotacao Cancelada    CPC - Cliente Perdeu Concorrencia    PJC - Projeto Cancelado    PRC - Perda por Preco    PRP - Preco por Prazo    DIV - Diversos"
       li := li + 1
       @ li,000 PSAY "MATERIAIS      :  FO  - Fibra Otica          RF  - Radio Frequencia              SENS - Sensor               WRL - Wireless           DIV - Diversos         "

       Roda(CbCont,"",Tamanho)
EndIf

Set Device To Screen

If ( aReturn[5] == 1 )
	Set Printer To 
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()
Return(.T.)

