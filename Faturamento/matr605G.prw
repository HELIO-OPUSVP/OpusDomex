#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 20/07/01

User Function matr605G()        // incluido pelo assistente de conversao do AP5 IDE em 20/07/01

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP5 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("CSTRING,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("TAMANHO,AORDEM,CPERG,ARETURN,NOMEPROG,NLASTKEY")
SetPrvt("M_PAG,WNREL,NCNTFOR,LIMPRIMIU,CCABEC1,CCABEC2")
SetPrvt("CBCONT,LI,ASITUACA,ACOMPONENT,ATOTAL,AQUEBRA")
SetPrvt("BQUEBRA,BCOND,LEND,CTITLEG,CCLASFUNIL,MFOLLOWUP")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑un뇚o    ? MATR605  ? Autor ? Eduardo Riera         ? Data ? 14.01.97 낢?
굇쳐컴컴컴컴컨컴컴컴컴컴탠컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿌lt. para RDMake     ? Adriano Fernando Raposo dos Santos              낢?
굇쳐컴컴컴컴컫컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿏escri뇚o ? Rela눯o de Or놹mentos de Venda                             낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿞intaxe   ? MATR605()                                                  낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Uso      ? Generico                                                   낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
/*/

//Local wnrel
cString := "SCK" 
Limite  := 220

#IFDEF WINDOWS
   Titulo  := OemToAnsi("Relacao dos Orcamento de Venda")
#ELSE
   Titulo  := "Relacao dos Orcamento de Venda"
#ENDIF  

#IFDEF WINDOWS
   cDesc1 :=OemToAnsi("Este relatorio ir? imprimir a rela뇙o dos Or놹mentos de Venda")
   cDesc2 :=OemToAnsi("conforme os parametros solicitados.                          ")
   cDesc3 :=OemToAnsi("")
#ELSE
   cDesc1 :="Este relatorio ir? imprimir a rela뇙o dos Or놹mentos de Venda"
   cDesc2 :="conforme os parametros solicitados.                          "
   cDesc3 :=""
#ENDIF

Tamanho  := "G"
aOrdem   := {"Numero","Cliente","Produto","Classifica豫o","Nome Cliente Reduzido",} 
cPerg    := "MTR605F"
aReturn  := { "Zebrado",1,"Administracao", 1, 2, 1, "",1 } 
nomeprog := "MATR605"
nLastKey := 0

m_pag := 01
wnrel := "MATR605"            

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇旼컴컴컴컫컴컴컴쩡컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커굇
굇? DATA   ? BOPS 쿛rograd.쿌LTERACAO                                      낢?
굇쳐컴컴컴컵컴컴컴탠컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇?23.11.98쿘ELHOR쿣iviani 쿔nclusao de pergunta e conversao de moeda      낢?
굇?23.11.98쿘ELHOR쿣iviani 쿌certo do lay-out                              낢?
굇?07.05.03쿘ELHOR쿑abr?cio쿔mpressao por Classificacao                    낢?
굇?26.05.04쿘ELHOR쿑abr?cio쿔mpressao por Nome Reduzido do Cliente         낢?
굇읕컴컴컴컨컴컴컴좔컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
/*/
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Verifica as perguntas selecionadas                           ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
pergunte("MTR605F",.F.)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Variaveis utilizadas para parametros                              ?
//? mv_par01            // Cliente de  ?                              ?
//? mv_par02            // Cliente ate ?                              ?   
//? mv_par03            // Emissao de  ?                              ?
//? mv_par04            // Emissao ate ?                              ?
//? mv_par05            // Numero  de  ?                              ?
//? mv_par06            // Numero  ate ?                              ?
//? mv_par07            // Produto de  ?                              ?
//? mv_par08            // Produto ate ?                              ?   
//? mv_par09            // Da Classificacao ?                         ?   
//? mv_par10            // Ate Classificacao                          ?   
//? mv_par11            // Do Nome Reduzido do Cliente ?              ?   
//? mv_par12            // Ate Nome Reduzido do Cliente ?             ?   
//? mv_par14            // Do Elaborador ?                            ?   
//? mv_par15            // Ate o Elaborador ?                         ?   
//? mv_par16            // Lista Quais ? Todos/Aberto/Baixado/Cancel. ?   
//? mv_par17            //                                            ?
//? mv_par19            //                                            ?   
//? mv_par20            //                                            ?
//? mv_par21           //                                             ?
   
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Envia controle para a funcao SETPRINT                        ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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

  //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  //? Reseta Impressora                                        ?
  //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
  @ 01,0 PSAY CHR(27)+"E"

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑un뇚o    ? CA605Imp ? Autor ? Eduardo Riera         ? Data ? 14.01.97 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escri뇚o ? Chamada do Relatorio                                       낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Uso      ? MTR605                                                     낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
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
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Define Cabecalho                                             ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
//          1         2         3         4         5         6         7         8         9        10        11        12        13        14         15       16        17        18        19       20        21         
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//CN       |CLIENTE                                 |PRODUTO                                                                                              |OUTROS
//NUMERO IT|CODIGO LJ RAZAO SOCIAL                  |CODIGO          DESCRICAO                      QUANTIDADE PRECO VENDA     TOTAL      |PRAZO           OBS     DPT     SITUACAO CONTATO              TELEFONE       OF
//999999 XX 999999-99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999,999.99 9999,999.99 999,999,999.99  XXXXXXXXXXXXXXX XXXXXXX XXXXXXX XXXXXXXX XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXX  XXXXXX

//cCabec1 :="CN       |CLIENTE                               |PRODUTO                                                                                                 |OUTROS"
//cCabec2 :="NUMERO IT|CODIGO RAZAO SOCIAL                   |CODIGO        DESCRICAO                      QUANTIDADE PRECO VENDA       TOTAL     PRAZO        DATA   |OBS     DPT  SITUACAO      CONTATO            TELEFONE      OF"
//cCabec1 :="CN       |CLIENTE                               |PRODUTO"
cCabec1 :="NUMERO IT| CODIGO RAZAO SOCIAL                    |CODIGO           DESCRICAO                            QUANTIDADE     PRECO VENDA     TOTAL       PRAZO      DATA         SUP.TECNICO       CONTATO              DDD TELEFONE"      
//Titulo  :=  //   Titulo   + //" (Ordem: " + aOrdem[aReturn[8]]+') - Cliente de "' + MV_PAR16 + '" at? "' + MV_PAR17 + '"'

dbselectarea("SCC")
dbsetorder(1)
dbSelectArea("SCJ")
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
	Case aReturn[8] == 4
		dbSetOrder(1)
		dbSeek(xFilial()+MV_PAR05,.T.)
		bCond := {||!Eof() .And. xFilial("SCK") == SCK->CK_FILIAL .And. ;
						SCK->CK_NUM >= MV_PAR05 .And.;
						SCK->CK_NUM <= MV_PAR06 }
		bQuebra := {|| SCK->CK_NUM } 
	Case aReturn[8] == 5
		dbSetOrder(2)
		dbSeek(xFilial()+MV_PAR01,.T.)
		bCond := {||!Eof() .And. xFilial("SCK") == SCK->CK_FILIAL .And. ;
						SCK->CK_CLIENTE >= MV_PAR01 .And.;
						SCK->CK_CLIENTE <= MV_PAR02 }
		bQuebra := {||SCK->CK_CLIENTE+SCK->CK_LOJA } 
		
			
	Case aReturn[8] == 6
		dbSetOrder(1)
		dbSeek(xFilial()+MV_PAR14,.T.)
		bCond := {||!Eof() .And. xFilial("SCJ") == SCJ->CJ_NUM .And. ;
					SCJ->CJ_ELABORA >= MV_PAR14 .And.;
			     	SCJ->CJ_ELABORA <= MV_PAR15 }
		bQuebra := {|| SCJ->SCJ_NUM }		
EndCase                 

While ( Eval(bCond) )

	#IFNDEF WINDOWS
		If LastKey() = 286  
			lEnd := .t.
                Else
                        lEnd := .f.
                Endif
	#ENDIF
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//? Posiciona Cabecalho do Or놹mento de Venda                    ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

	WHILE !EOF() .AND. (MV_PAR16==2) .AND. (!Empty(SCK->CK_NUMPV))
     DBSELECTAREA("SCK")
     SKIP 
    ENDDO    
    WHILE !EOF() .AND. (MV_PAR16==3) .AND. (SUBSTR(SCK->CK_NUMPV,1,2) <> "OF")
     DBSELECTAREA("SCK")
     SKIP
    ENDDO
    WHILE !EOF() .AND. (MV_PAR16==4) .AND. (ALLTRIM(SCK->CK_NUMPV) <> "MORTO") 
     DBSELECTAREA("SCK")	
     SKIP
    ENDDO                     
	       
/// Inserido por Fabr?cio
	dbselectarea("SA1")
	dbsetorder(1)
	dbseek(xfilial()+SCK->CK_CLIENTE+SCK->CK_LOJA)
	dbselectarea("SCK")
	while !eof() .and. !(SA1->A1_NREDUZ >= MV_PAR11 .and. SA1->A1_NREDUZ <= MV_PAR12)
	  dbskip()
	  dbselectarea("SA1")
	  dbseek(xfilial()+SCK->CK_CLIENTE+SCK->CK_LOJA)
 	  dbselectarea("SCK")
	enddo
/// Fim da inser豫o	  
 
    	
	dbSelectArea("SCJ")
	dbSetOrder(1)
	dbSeek(xFilial()+SCK->CK_NUM)

	If (  SCK->CK_CLIENTE >= MV_PAR01 .And. SCK->CK_CLIENTE <= MV_PAR02 .And.;
			SCJ->CJ_EMISSAO >= MV_PAR03 .And. SCJ->CJ_EMISSAO <= MV_PAR04 .And.;
			SCK->CK_NUM     >= MV_PAR05 .And. SCK->CK_NUM     <= MV_PAR06 .And.;
            SCK->CK_PRODUTO >= MV_PAR07 .And. SCK->CK_PRODUTO <= MV_PAR08 .And.; 
            SCJ->CJ_CLASSIF >= MV_PAR09 .And. SCJ->CJ_CLASSIF <= MV_PAR10 .And.; 
            SCJ->CJ_ELABORA >= MV_PAR14 .And. SCJ->CJ_ELABORA <= MV_PAR15 )/* .And.;
         	IF(MV_PAR12 == 2,SCJ->CJ_STATUS=="A",.T.)                     .And.;
			If(MV_PAR12 == 3,SCJ->CJ_STATUS=="B",.T.)                     .And.;
			If(MV_PAR12 == 4,SCJ->CJ_STATUS=="C",.T.) ) */

    		
		//lImprimiu := .T.
	   //	If ( MV_PAR11 == 1 ) // Lista Componente
		 //	aComponent := {}
		   //	dbSelectArea("SCL")
			//dbSetOrder(1)
			//dbSeek(xFilial()+SCK->CK_NUM+SCK->CK_ITEM,.T.)
		//EndIf


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

//            IF SUBSTR(SB1->B1_GRUPO,1,2) == "RF"

		@ li,000 PSAY SCK->CK_NUM+"-"+SCK->CK_ITEM 
		@ li,010 PSAY SCK->CK_CLIENTE
		@ li,18 PSAY SubStr(SA1->A1_NOME,1,30)
		@ li,048 PSAY SCK->CK_PRODUTO  
        @ li,66 PSAY SubStr(SCK->CK_DESCRI,1,30)
        @ li,101 PSAY SCK->CK_QTDVEN PICTURE TM(SCK->CK_PRCVEN,10,2)
        @ li,116 PSAY xMoeda(SCK->CK_PRCVEN,1,1,SCJ->CJ_EMISSAO)   PICTURE TM(SCK->CK_PRCVEN,11,2)
        @ li,127 PSAY xMoeda(SCK->CK_PRCVEN*SCK->CK_QTDVEN,1,1,SCJ->CJ_EMISSAO)   PICTURE TM(SCK->CK_VALOR ,14,2)
        @ li,146 PSAY SUBSTR(SCK->CK_PRAZO,1,10)
        @ li,159 PSAY SCJ->CJ_EMISSAO
//        cOBS := SUBSTR(SCK->CK_OBS,1,3)
//        cDPT := SUBSTR(SCK->CK_DPT,1,4)
//        @ li,154 PSAY cOBS 
//        @ li,161 PSAY cDPT
       // dbselectarea("SCC")
        //dbseek(xFilial("SCC")+SCJ->CJ_CLASSIF)
		//cClasFunil := SUBSTR(CC_NOME,1,12)
		//dbselectarea("SB1")  
		
		
	  //	if mv_par21 == 1
	//	@ li, 154 PSAY SCK->CK_MARGEM
	  //	@ li ,156 PSAY "%"
       // ENDIF                  
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//? Acumulo Totais                                               ?
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		

		For nCntFor := 1 To Len(aTotal)
                      aTotal[nCntFor,1] := aTotal[nCntFor,1] + SCK->CK_QTDVEN
                      aTotal[nCntFor,2] := aTotal[nCntFor,2] + xMoeda(SCK->CK_PRCVEN,1,1,SCJ->CJ_EMISSAO)
                      aTotal[nCntFor,3] := aTotal[nCntFor,3] + xMoeda(SCK->CK_PRCVEN,1,1,SCJ->CJ_EMISSAO)
                      aTotal[nCntFor,4] := aTotal[nCntFor,4] + xMoeda(SCK->CK_VALOR,1, 1,SCJ->CJ_EMISSAO)
		Next      
		
		        @li,166 PSAY SCJ->CJ_ELABORA 
                // Alteracao por Adriano em 26/01/00
                // para impressao correta da Situacao
                // @ li,169 PSAY aSituaca[Asc(SCJ->CJ_STATUS)-64]
//                If Empty(SCK->CK_NUMPV)
//                   @ li,167 PSAY "ABERTO"
//                Else     
//                   If (ALLTRIM(SCK->CK_NUMPV) <> "MORTO")
//                    @ li,167 PSAY "BAIXADO"
//                   else
//                    @ li,167 PSAY "MORTO"        
//                  endif   
//                EndIf
                                              
               //@ li,176 PSAY SUBSTR(SCJ->CJ_CONTATO,1,19)
                @ li,186 PSAY SCJ->CJ_CONTATO
                @ li,206 PSAY SUBSTR(SCJ->CJ_DDD,1,2)  
                @ li,208 PSAY "."
                @ li,209 PSAY SUBSTR(SCJ->CJ_FONE,1,14)   
                
           //     @ li,210 PSAY SUBSTR(SCJ->CJ_FONE,1,14)Picture 9999.9999
                li := li + 1           
//               EndIf
     
	EndIf   
	
	dbSelectArea("SCK")
	dbSkip()
	IncRegua()
	If ( aQuebra[1] != Eval(bQuebra) .And. aTotal[2,1] > 0 )
      li := li + 1
		If ( aReturn[8] == 1 )
  						if mv_par13 == 1
						  impfollowup()
		  				endif
                        @ li,000 PSAY "Total do Orcamento: "
		EndIf	
		If ( aReturn[8] == 2 )
                        @ li,000 PSAY "Total do Cliente: "
		EndIf	
		If ( aReturn[8] == 3 )
                        @ li,000 PSAY "Total do Produto: "
		EndIf			
		if (aReturn[8] == 4 )
						@ li,000 PSAY "Total do Orcamento: "
		EndIf
		@ li,104 PSAY aTotal[2,1]       PICTURE TM(aTotal[2,1],10,2)
		@ li,119 PSAY aTotal[2,2]       PICTURE TM(aTotal[2,2],11,2)
        @ li,130 PSAY aTotal[2,4]       PICTURE TM(aTotal[2,4],14,2)
      li := li + 1
		@ li,000 PSAY __prtfatline() //Repl("-",Limite)
      li := li + 2
		aTotal[2,1] := 0
		aTotal[2,2] := 0
		aTotal[2,3] := 0
		aTotal[2,4] := 0
	EndIf				
EndDo       
If lImprimiu
   li := li + 2
        @ li,000 PSAY "T O T A L  G E R A L --> "
        @ li,104 PSAY aTotal[1,1]       PICTURE TM(aTotal[1,1],10,2)
        @ li,119 PSAY aTotal[1,2]       PICTURE TM(aTotal[1,2],11,2)
        @ li,130 PSAY aTotal[1,4]       PICTURE TM(aTotal[1,4],14,2)

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

static function impfollowup()

@ li, 0 psay __prtthinline()
li := li + 1
@ li, 0 psay "Comentarios: "
li := li + 2
for i := 1 to mlcount(SCJ->CJ_DESC)
  if li > 56
    li := cabec(Titulo,cCabec1,cCabec2,nomeprog,Tamanho,15)
  endif
  @li, 0 psay memoline(SCJ->CJ_DESC,, i)
  li := li+1
next
if mlcount(SCJ->CJ_DESC) == 0
  li := li + 1
endif
@ li, 0 psay __prtthinline()
li := li + 2

return
