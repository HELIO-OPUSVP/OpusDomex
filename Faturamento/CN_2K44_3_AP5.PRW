#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 20/07/01
//#Include "Laser.ch"
#include "print.ch"
#include "font.ch"
#include "colors.ch"
/*#IFNDEF WINDOWS
#DEFINE PSAY SAY
#ENDIF*/                    
    

#xcommand @ <nLinha>, <nColuna> PSAY <cTexto>;
			=> oprn:say((<nLinha>)*50+100, (<nColuna>)*18-(<nColuna>)/2+40, transform(<cTexto>, ''), ofnt,,;
			   CLR_BLACK)
			   
#xcommand @ <nLinha>, <nColuna> PSAY2 <cTexto>;
			=> oprn:say((<nLinha>)*50+100, (<nColuna>)*24/*-(<nColuna>)/2*/+40, transform(<cTexto>, ''), ofnt,,;
			   CLR_BLACK)
			   
#xcommand @ <nLinha>, <nColuna> PSAY <cTexto> FONT <oFonte>;
			=> oprn:say((<nLinha>)*50+100, (<nColuna>)*18-(<nColuna>)/2+40, transform(<cTexto>, ''), <oFonte>,,;
			   CLR_BLACK)

#xcommand @ <nLinha>, <nColuna> PSAY <cTexto> PICTURE <cPicture>;
			=> oprn:say((<nLinha>)*50+100, (<nColuna>)*18-(<nColuna>)/2+40, transform(<cTexto>, <cPicture>), ofnt,,;
			   CLR_BLACK)

#xcommand @ <nLinha>, <nColuna> PSAY2 <cTexto> PICTURE <cPicture>;
			=> oprn:say((<nLinha>)*50+100, (<nColuna>)*24/*-(<nColuna>)/2*/+40, transform(<cTexto>, <cPicture>), ofnt,,;
			   CLR_BLACK)

#xcommand @ <nLinha>, <nColuna> PSAY <cTexto> PICTURE <cPicture> FONT <oFonte>;
			=> oprn:say((<nLinha>)*50+100, (<nColuna>)*18-(<nColuna>)/2+40, transform(<cTexto>, <cPicture>), <oFonte>,,;
			   CLR_BLACK)
			   
		
			   
User Function CN_2K_3()        // incluido pelo assistente de conversao do AP5 IDE em 20/07/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,AORD")
SetPrvt("WNREL,NSEUCD,NNOSCD,ARETURN,NLASTKEY,CPERG")
SetPrvt("CIMPNORM,CIMPCOMP,TAMANHO,CRODATXT,NTIPO,NCNTIMPR")
SetPrvt("NTAM,NPOS,LINES,CEMPRESA,CENDERECO,CATT")
SetPrvt("CDPTO,CFONE,CFAX,CDATA,CVENDEDOR,CREF,CELABORADOR")
SetPrvt("CESTADO,CCIDADE,NTOTAL1,NTTOTAL2,NTTTOTAL3,CNUMORC,NVIAS,LFIRST")
SetPrvt("LNORMAL,LI,M_PAG,NNUMPG,CREVISAO,CAB1")
SetPrvt("CAB2,CAB3,NSEUDES,NOSSO,NVALOR,NHANDLE")
SetPrvt("TAMDOBUFFER,BUFFER,CORRIGE,RETSTRING,OPRN,OFNT")
SetPrvt("COU14B,U10S,U10B,C10S,C10B,C8S,C8B,U12B,C12S")


// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 20/07/01 ==> #Include "Laser.ch"

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 20/07/01 ==> #DEFINE PSAY SAY
#ENDIF
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CN_2K2   ³ Autor ³Adriano F. R. Santos   ³ Data ³ 11/03/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao de Orcamento segundo o padrao do cliente DOMEX   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFAT                                                    ³±±
±±³ Rev A    ³ Gerardo DOMEX (Jun/00) - Impressao na LJ 1100              ³±±
±±³ Rev B      Fabricio Mudança no Reajuste e Cabeçalho, Razao social     ³±±     
±±³ Rev C      GERARDO - ALTERACAO DO LAYOUT DA CN - (NOVA IMPRESSAO)     ³±±     
±±³ Rev D      Fabrício - Incluída acentuação no documento (Jan/2003)     ³±±     
±±³ Rev E      Fabrício - Adaptação para impressão modo gráfico (Abr/2004)³±±     
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis obrigatorias dos programas de relatorio            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*titulo   := "Impressao de Orcamento"
cDesc1   := "Este programa tem a funcao de imprimir orcamentos segundo"
cDesc2   := "o padrao da Domex"
cDesc3   := " "
cString  := "SCJ"*/
aOrd     := {}
//wnrel    := "CN2002"
nseucd   := " "
nnoscd   := " "
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis padrao de todos os relatorios                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//aReturn:= { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nLastKey:= 0
cPerg := "DOORC"
/*cImpNorm  := chr(18)            //impressora - normal
cImpComp  := chr(15)            //         comprimido
cTamImp   := "(s15H"*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01     // De Orcamento                                 ³
//³ mv_par02     // Ate Orcamento                                ³
//³ mv_par03     // Numero de copias                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if pergunte(cPerg,.T.) == .f.
  Return
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)

nLastKey:=IIf(LastKey()==27,27,nLastKey)
If nLastKey == 27
   Return
Endif
SetDefault(aReturn,cString)
nLastKey:=IIf(LastKey()==27,27,nLastKey)
If nLastKey == 27
   Return
Endif*/

print oprn preview               
define font cou14b name "Courier New" bold size 0,12 of oprn
/*
define font u10s name "Univers" size 0,11 of oprn
define font u10b name "Univers" bold size 0,11 of oprn
define font c10s name "CG Times" size 0,11 of oprn
define font c10b name "CG Times" bold size 0,11 of oprn
*/
define font u10s name "Courier New" size 0,9 of oprn
define font u10b name "Courier New" bold size 0,9 of oprn
define font c10s name "Courier New" size 0,9 of oprn
define font c10b name "Courier New" bold size 0,9 of oprn
define font c8s name "Courier New" size 0,6 of oprn
define font c8b name "Courier New" bold size 0,7 of oprn
//define font u14s name "Univers" size 0,14 of oprn
define font u12b name "Courier New" bold size 0,9 of oprn weight 8
define font c12s name "Courier New" size 0,9 of oprn weight 8

#IFDEF WINDOWS
RptStatus({|| ORCIMP2()})// Substituido pelo assistente de conversao do AP5 IDE em 20/07/01 ==> RptStatus({|| Execute(ORCIMP)})
// Substituido pelo assistente de conversao do AP5 IDE em 20/07/01 ==> FUNCTION ORCIMP
Static FUNCTION ORCIMP2()
   #ENDIF 
   // jfs iniicio
   //oprn:saybitmap(0,0,"CAPA_RDT.BMP",2480,3325)
   // fim jfs
 
   
   /*
   ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
   ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
   ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
   ±±³Fun‡…o    ³ ORCImp   ³ Autor ³ Adriano F. R. Santos  ³ Data ³ 11/03/99 ³±±
   ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
   ±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
   ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
   ±±³ Uso      ³ DOMORC                                                     ³±±
   ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
   ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
   
                  
     

   */
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Variaveis locais exclusivas deste programa                   ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   Tamanho  := "P"
   cRodaTxt := "REGISTRO(S)"
   nTipo    := 0
   nCntImpr := 0
   nTam     := 80
   nPos     := 0
   LiNes    := 0

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Variaveis do cabecalho do orcamento                          ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   cEmpresa   := Space(40)
   cEndereco  := Space(40)
   cAtt       := Space(30)
   cDpto      := Space(15)
   cFone      := Space(15)
   cFax       := Space(15)
   cData      := Space(08)
   cVendedor  := Space(15)
   cElaborador:= Space(20)
   cRef       := Space(28)
   cEstado    := Space(3)
   cCidade    := Space(30)
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Variaveis gerais desta funcao                                ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   nTotal1    := 0  
   nTTotal2   := 0 
   nTTTotal3  := 0
   cNumOrc   := Space(06)
   nVias     := 1
   lFirst    := .T.
   lNormal   := .T.


   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Inicializa variaveis para controlar cursor de progressao     ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   SetRegua(LastRec())

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Inicializa os codigos de caracter Comprimido/Normal da impressora ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//   nTipo  := IIF(aReturn[4]==1,15,18)

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Contadores de linha e pagina                                 ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   //li     := 80
//   m_pag  := 0
   nNumPg := 0

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Reseta Impressora                                        ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//  @ 01,01 PSAY CHR(27)+"E"
  
//  @ 01,01 PSAY CHR(27)+"(19U"   //configura caracteres para Windows - Latin 1 (ANSI) - Fabrício Becherini (01/12/03)

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Posiciona o Arquivo na ordem correta.                    ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   dbSelectArea("SA1")          //cadastro de clientes, nome cliente
   dbSetOrder(1)
   dbSelectArea("SA3")          //cadastro de vendedores, nome vendedor
   dbSetOrder(1)
   //dbSelectArea("SU5")          //cadastro de contatos, p/ cabecalho
   //dbSetOrder(1)
   dbSelectArea("SCK")          //itens orcamento
   dbSetOrder(1)
   dbSelectArea("SE4")
   dbSetOrder(1)
   dbSelectArea("SCJ")          //cabecalho orcamento
   dbSetOrder(1)

   dbSeek(xFilial("SCJ")+mv_par01)
   
   cNumOrc := SCJ->CJ_NUM
   cCodCont:=SCJ->CJ_CODCONT
  
   dbSelectArea("SU5")
   dbSeek(xFilial("SU5")+cCodCont)
   cNomCont:=SU5->U5_CONTAT  
 
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Cria texto do cabecalho do orcamento                     ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   dbSelectArea("SA1")
   dbSeek(xFilial("SA1")+SCJ->CJ_CLIENTE)
   cEmpresa   := SA1->A1_NOME + " " + SA1->A1_COD
   cEndereco  := SA1->A1_END
   cCidade    := SA1->A1_MUN
   cEstado    := SA1->A1_EST
   cVendedor  := SCJ->CJ_VEND 
   cElaborado := SCJ->CJ_ELABORA
   cRevisao   := SCJ->CJ_REVISAO
   cAtt       := "Att : " + SU5->U5_CONTAT
   cDpto      := "Dpto: " + SCJ->CJ_DPTO
   cFone      := "Fone: " + SCJ->CJ_FONE
   cFax       := "Fax: "  + SCJ->CJ_FAX
   cData      := StrZero(Day(dDataBase),2) + " de " + ;
   MesExtenso(Month(dDataBase)) + " de " + Str(Year(dDataBase))

   cVendedor  := SCJ->CJ_VEND
   cElaborador:= SCJ->CJ_ELABORA 
   cRef       := "Referência: PROPOSTA COMERCIAL " + SCJ->CJ_NUM + SCJ->CJ_REVISAO +;
   "/" + Right(Str(Year(dDataBase)),2)

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Inicio da impressao                                      ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   dbSelectArea("SCJ")
   While !Eof() .And. cNumOrc == SCJ->CJ_NUM .And. ;
      cNumOrc >= mv_par01 .And. cNumOrc <= mv_par02
      IncRegua()

      // Verificacao da existencia de preco especial
      dbSelectArea("SCK")
      dbSeek(xFilial("SCK") + cNumOrc)
      While !Eof() .And. cNumOrc == SCK->CK_NUM .And. lNormal
         //If !Empty(SCK->CK_PRCESP)
         //   lNormal := .F.
         //Endif
         dbSkip()
      EndDo
      dbSelectArea("SCJ")
      // Final da verificacao

      For nVias:=1 to mv_par03       // P/Imprimir n vias

         //LOGOTIPO()

         //@30,00 PSay "linha 30"
         lFirst := .T.
         li := 80
         nNumPg := 0
         nTotal1 := 0   
         nTTotal2:= 0 
         nTTTotal3:=0
         dbSelectArea("SCK")
         dbSeek(xFilial("SCK") + cNumOrc)
         //Eject
         While !Eof() .And. cNumOrc == SCK->CK_NUM
            
            dbSelectArea("SCJ")
            dbSeek(xFilial("SCJ")+cNumOrc)
            cCodCont:=SCJ->CJ_CODCONT

            dbSelectArea("SU5")
            dbSeek(xFilial("SU5")+cCodCont)
            cNomCont:=SU5->U5_CONTAT            
            
            If li > 45            // Impressao do Cabecalho

               //nNumPg := nNumPg+1
               //Cabec()
               LiNes := 10
               TestaLinha()
               li := 20
               If lFirst
                  @ li ,10 PSAY "Prezado(a), "+cNomCont //tirar
                  @ li+2,10 PSAY "      Atendendo sua solicitação, apresentamos abaixo nossa proposta comercial para o fornecimento"
                  @ li+3,10 PSAY "do(s) produto(s) abaixo discriminado(s):"
                  li := 24
                  lFirst := .F.
               Endif

            Endif     // Fim impressao do cabecalho
            dbSelectArea("SCK")
// *** AT
//            @ li,01 PSAY COU14B         // Impressao do cabecalho em tamanho compactado
			setafonte(cou14b)
            If lNormal    
               LiNeS := 12
               TestaLinha()
               ImpItens()
               LiNes := 3
               TestaLinha()
            EndIf

// *** AT
//            @ li,01 PSAY U10S           // Impressao do cabecalho em tamanho normal
		 setafonte(u10s)         

         EndDo

         // Final do Relatorio : Totalizacao
// *** AT
//         @ li,01 PSAY U10B           // Impressao do cabecalho em tamanho compactado negrito
		 setafonte(u10b)
         If lNormal
            @ li,080 PSAY "TOTAL C/ICMS C/IPI R$  ==>"
            @ li+01,080 PSAY "TOTAL ICMS ST R$  ==>"  
            @ li+02,080 PSAY "TOTAL C/ICMS ST C/IPI  R$  ==>" 
//            @ li,108 PSAY nTotal Picture "@R 99,999,999.99"
            @ li,111 PSAY nTotal1 Picture "@R 99,999,999.99"
            li := li+1
            @ li,111 PSAY  nTTTotal3 Picture "@R 99,999,999.99"
            li := li+1 
            @ li,111 PSAY  nTTotal2 Picture "@R 99,999,999.99"
         EndIf
         If !lNormal
            @ li,100 PSAY "TOTAL C/ICMS C/IPI R$  ==>"
            li := li+1 
            @ li,100 PSAY "TOTAL ICMS/ST R$  ==>"
            li := li+1
            @ li,100 PSAY "TOTAL C/ICMS ST C/IPI R$  ==>"
            @ li,116 PSAY nTotal1 Picture "@R 99,999,999.99" 
            li := li+1         
            @ li,116 PSAY  nTTTotal3  Picture "@R 99,999,999.99"
            li := li+1
            @ li,116 PSAY  nTTotal2  Picture "@R 99,999,999.99"
         EndIf
// *** AT
//         @ li,01 PSAY C10S             // Impressao do cabecalho em tamanho normal
         setafonte(c10s)

         li := li+2
         LiNes := 6
         TestaLinha()

            If !Empty(SCJ->CJ_OBS1)
               li := li+1
               @ li  ,18 PSAY SCJ->CJ_OBS1
            EndIf
            If !Empty(SCJ->CJ_OBS2)
               li := li+1
               @ li  ,18 PSAY SCJ->CJ_OBS2
            EndIf
            If !Empty(SCJ->CJ_OBS3)
               li := li+1
               @ li  ,18 PSAY SCJ->CJ_OBS3
            EndIf
            If !Empty(SCJ->CJ_OBS4)
               li := li+1
               @ li  ,18 PSAY SCJ->CJ_OBS4
            EndIf

		IF !Empty(SCJ->CJ_OBS1) .OR. !Empty(SCJ->CJ_OBS2) .OR. !Empty(SCJ->CJ_OBS3) .OR. !Empty(SCJ->CJ_OBS4)
	        li:= li+2
	    EndIF    
          
// *** AT
//        @ li,010 PSAY C10B+"OBSERVAÇÕES"+C10S
        @ li,010 PSAY "OBSERVAÇÕES" FONT c10b
        setafonte(c10s)
        
		LiNeS := 09
        testalinha()                                    

// *** AT
//		cTamImp := IMP17S()
// 	    @ li+1,01 PSAY CHR(27)+cTamImp
        setafonte(c8s)

//        @ li+1,08 PSAY "Os cordões ópticos produzidos pela Rosenberger Domex Telecom poderão sofrer pequenas variações no comprimento do cabo, cuja"     
        @ Li+1,07 Psay "1.Faturamento minino é de R$700,00 reais ."
        @ Li+2,07 Psay "2.Os prazos mencionados acima são todos em dias úteis."
        @ li+3,07 PSAY "3.Os cordões ópticos produzidos pela Rosenberger Domex Telecom poderão sofrer pequenas variações no comprimento do cabo, cuja"
        @ lI+4,07 PSAY "tolerância máxima é de:"
        @ li+5,20 PSAY " 0 a 10 metros   : +/- 3,0% de tolerância;"
	    @ li+6,20 PSAY "10 a 25 metros   : +/- 1,5% de tolerância;"
	    @ li+7,20 PSAY "25 metros ou mais: +/- 1,0% de tolerância."
	    @ li+8,07 PSAY "Para os cordões com metragem  inferior a 10 metros, não aceitamos cancelamento do  pedido e/ou devoluções, por tratar-se de"
	    @ li+9,07 PSAY "material feito sobre encomenda." 
           
        li := li+10
		LiNeS := 04
        testalinha()                                    
        
// *** AT
// 		cTamImp := IMP17S()
// 	    @ li  ,01 PSAY CHR(27)+cTamImp
		setafonte(c8s)

//        @ li  ,07 PSAY "OS PREÇOS SÃO VÁLIDOS SOMENTE PARA ESTA PROPOSTA E NAS QUANTIDADES ACIMA REFERENCIADAS"
        @ li  ,06 PSAY "OS PREÇOS SÃO VÁLIDOS SOMENTE PARA ESTA PROPOSTA E NAS QUANTIDADES ACIMA REFERENCIADAS"
        @ li+1,06 PSAY "INFORMAR NOSSA REFERÊNCIA EM SEU PEDIDO DE COMPRA."
        @ li+2,06 PSAY "SOLICITAMOS INFORMAR EM SEU PEDIDO O DESTINO DO MATERIAL:"
        @ li+3,06 PSAY "[  ] REVENDA   [  ] INDUSTRIALIZAÇÃO   [  ] CONSUMO   [  ] TRANSFORMAÇÃO"
         
        li := li+4
        LiNes := 5
        TestaLinha()

        @ li   ,10 PSAY "DEMAIS CONDIÇÕES COMERCIAIS"
// *** AT
//        @ li+02,01 PSAY C10B
		setafonte(c10b)
        @ li+02,10 PSAY "1. IMPOSTOS"

// *** AT
//        cTamImp := IMP15S()
//		@ li+03,01 PSAY CHR(27)+cTamImp
		setafonte(c8b)

        If ALLTRIM(SCJ->CJ_ICMS) == "X"
            @ li+03,08 PSAY "ICMS - Conforme Indicado em cada Produto" 
            //@ Li+04,16 Psay "MATERIAL SUJEITO À SUBSTITUIÇÃO TRIBUTÁRIA QUANDO SUA DESTINAÇÃO FOR REVENDA DENTRO DO ESTADO DE SÃO PAULO  CONF.DECRETO 54251/09 ART.313-Z17 DE 17/04/09"
            ELSEIf ALLTRIM(SCJ->CJ_ICMS) == "I"
//                 @ li+03,16 PSAY "ICMS - Isento"
                 @ li+03,08 PSAY "ICMS - Isento"
            ELSE
//                 @ li+03,16 PSAY " ICMS - " + ALLTRIM(SCJ->CJ_ICMS) + "% ja incluso"
                 @ li+03,08 PSAY "ICMS - Conforme indicado em cada produto"
        Endif
                 @ li+04,08 PSAY "ICMS-ST: MATERIAL SUJEITO À SUBSTITUIÇÃO TRIBUTÁRIA QUANDO SUA DESTINAÇÃO FOR REVENDA DENTRO DO ESTADO DE SÃO PAULO   
                 @ li+05,08 PSAY "CONF.DECRETO 54251/09 ART.313-Z17 DE 17/04/09"
                 @ li+06,08 PSAY "IPI  - Conforme indicado em cada produto"

         li := li + 8
         LiNes := 2
         TestaLinha()

// *** AT  
//         @ li   ,01 PSAY C10B
		 setafonte(c10b)
         @ li   ,10 PSAY "2. CONDIÇÕES DE PAGAMENTO (" + SCJ->CJ_CONDPAG +")"

// *** AT
//         cTamImp := IMP15S()

//		 @ li+01,01 PSAY CHR(27)+cTamImp         
		setafonte(c8b)

         dbSelectArea("SE4")
         dbSeek(xFilial("SE4") + SCJ->CJ_CONDPAG)

//         @ li+01,17 PSAY SE4->E4_DESCRI + ", após a entrega do material"
         @ li+01,10 PSAY SE4->E4_DESCRI 
         
         LiNes := 4
         TestaLinha()

// *** AT
//         @ li+03,01 PSAY C10B
		setafonte(c10b)
         @ li+03,10 PSAY "3. LOCAL DE ENTREGA"

// *** AT
//         cTamImp := IMP15S()
//		 @ li+04,01 PSAY CHR(27)+cTamImp
		setafonte(c8b)

//         @ li+04,17 PSAY "Modalidade :"
         @ li+04,10 PSAY "Modalidade :"

         If SCJ->CJ_DMFRETE == "CIF"            ///Tirar
            @ li+04,30 PSAY "CIF - " + SCJ->CJ_LOCAL
         Endif
         If SCJ->CJ_DMFRETE == "FOB"
            @ li+04,30 PSAY "FOB - Caçapava - SP."
         Endif

         li:=li+05
         LiNes := 2
         TestaLinha()

// *** AT
//         @ li+01,01 PSAY C10B
		setafonte(c10b)
         @ li+01,10 PSAY "4. VALIDADE DA PROPOSTA:"

// *** AT
//         cTamImp := IMP15S()
//		 @ li+02,01 PSAY CHR(27)+cTamImp
		setafonte(c8b)

//         @ li+02,17 PSAY SCJ->CJ_VALPROP  /// Tirar
         @ li+02,10 PSAY SCJ->CJ_VALPROP  /// Tirar

         li := li+3

// *** AT
//         @ li   ,01 PSAY U10S
		setafonte(u10s)

         LiNes := 6
         TestaLinha()

// *** AT
//         @ li+01,01 PSAY C10B        
//         @ li+01,10 PSAY "5. REAJUSTE:"+C10S
         @ li+01,10 PSAY "5. REAJUSTE:" FONT c10b

// *** AT
//         cTamImp := IMP17S()
//		 @ li+02,01 PSAY CHR(27)+cTamImp
		setafonte(c8s)

//         @ li+02,21 PSAY "Caso ocorra, dentro do prazo de validade desta proposta, alterações na política econômica vigente e/ou alterações cambiais"
         @ li+02,10 PSAY "Caso ocorra, dentro do prazo de validade desta proposta, alterações na política econômica vigente e/ou alterações cambiais"
         @ li+03,10 PSAY "superior ou igual a +/-5% (mais ou menos cinco por cento), os valores e prazos contidos nesta proposta deverão ser reajus-"
         @ li+04,10 PSAY "tados, de comum acordo entre a  Rosenberger  Telecom e o Cliente, preservando-se o  equilíbrio financeiro de ambas as                 
         @ li+05,10 PSAY "partes. Os preços acima tem como base a cotação da moeda nesta data, publicada pelo Jornal Gazeta Mercantil."

         li := li+6
         LiNes := 2                                                           
         TestaLinha()

// *** AT
//         @ li+01,01 PSAY C10B
//         @ li+01,10 PSAY "6. ATRASO DE PAGAMENTO:"+C10S
         @ li+01,10 PSAY "6. ATRASO DE PAGAMENTO:" FONT c10b

// *** AT
//         cTamImp := IMP17S()
//		 @ li+02,01 PSAY CHR(27)+cTamImp  
		setafonte(c8s)

//         @ li+02,22 PSAY "No caso de atraso de pagamento ser imputado juros, salvo se o motivo for gerado pela RDT S/A"
         @ li+02,10 PSAY "No caso de atraso de pagamento ser imputado juros, salvo se o motivo for gerado pela RDT S/A"

         li := li+3
         LiNes := 6
         TestaLinha()

// *** AT
//         @ li+01,01 PSAY C10B
//         @ li+01,10 PSAY "7. GARANTIA: 12 MESES"+C10S
         @ li+01,10 PSAY "7. GARANTIA: 12 MESES" FONT c10b

// *** AT
//         cTamImp := IMP17S()
//		 @ li+02,01 PSAY CHR(27)+cTamImp  
		setafonte(c8s)  
		
		 @ li+02,10 PSAY "Rosenberger Domex Telecom compromete-se a substituir qualquer quantidade  de material que  apresentar defeito de"
//         @ li+02,22 PSAY "Rosenberger Domex Telecom compromete-se a substituir qualquer quantidade  de material que  apresentar defeito de"       
         @ li+03,10 PSAY "fabricação dentro de um período de 12 meses após a entrega dos mesmos sem ônus a sua empresa, desde que utiliza-"
         @ li+04,10 PSAY "dos em condições normais e apropriadas ao serviço. Ficam  excluídos dessa garantia os danos provenientes de ins-"
         @ li+05,10 PSAY "talação e manuseio inadequados e/ou decorrentes de avarias por acidentes."

         li := li+6
         LiNes := 8
         TestaLinha()

// *** AT
//         @ li+01,01 PSAY C10B
//         @ li+01,10 PSAY "8. DEVOLUÇÃO:"+C10S
         @ li+01,10 PSAY "8. DEVOLUÇÃO:" FONT c10b

// *** AT
//         cTamImp := IMP17S()
//		 @ li+02,01 PSAY CHR(27)+cTamImp  
		setafonte(c8s)

//         @ li+02,22 PSAY "Qualquer devolução de  material fica condicionada  a recebimento pela  Rosenberger Domex Telecom do relatório de"
         @ li+02,10 PSAY "Qualquer devolução de  material fica condicionada  a recebimento pela  Rosenberger Domex Telecom do relatório de"
         @ li+03,10 PSAY "não conformidade para análise e solução do processo, de comum acordo."

         li := li+4
         LiNes := 2
         TestaLinha()

// *** AT
//         @ li+01,01 PSAY C10B
//         @ li+01,10 PSAY "9. EMBALAGEM:"+C10S
         @ li+01,10 PSAY "9. EMBALAGEM:" FONT c10b

// *** AT
//         cTamImp := IMP17S()
//		 @ li+02,01 PSAY CHR(27)+cTamImp  
		setafonte(c8s)

//         @ li+02,22 PSAY "Inclusa nos preços propostos."
         @ li+02,10 PSAY "Inclusa nos preços propostos."

         li := li+3
         LiNes := 13
         TestaLinha()

// *** AT
//         @ li+01,01 PSAY C10B
//         @ li+01,10 PSAY "10. ALTERAÇÕES DA POLíTICA ECONÔMICA:"+C10S
         @ li+01,10 PSAY "10. ALTERAÇÕES DA POLíTICA ECONÔMICA:" FONT c10b

// *** AT
//         cTamImp := IMP17S()
//		 @ li+02,01 PSAY CHR(27)+cTamImp  
		setafonte(c8s)

//         @ li+02,22 PSAY "Os preços e condições desta proposta foram fixados  de acordo com a sistemática econômico/financeira ditada pela"
         @ li+02,10 PSAY "Os preços e condições desta proposta foram fixados  de acordo com a sistemática econômico/financeira ditada pela"
         @ li+03,10 PSAY "política vigente. Portanto, na eventualidade de ocorrerem alterações econômicas/financeiras entre a data da pro-"
         @ li+04,10 PSAY "posta e a data da entrega do material, as condições ora propostas, deverão ser revistas de modo a restabelecer a"
         @ li+05,10 PSAY "relação que as partes pactuaram inicialmente,  objetivando a manutenção do  incial equilíbrio econômico e finan-"
         @ li+06,10 PSAY "ceiro da proposta."

         li := li+6

         @ li+01,13 PSAY "Atenciosamente,"

         li := li+2

         If nTotal1 <= 15000
            @ li+02,010 PSAY "________________________"
            @ li+02,097 PSAY "________________________"
            @ li+03,017 PSAY "Emitente"
            @ li+03,100 PSAY "Eng. Vendas"
            Else
               @ li+02,010 PSAY "________________________"
               @ li+03,017 PSAY "Diretoria"
         Endif  
         
          If nTTotal2 <= 15000
            @ li+02,010 PSAY "________________________"
            @ li+02,097 PSAY "________________________"
            @ li+03,017 PSAY "Emitente"
            @ li+03,100 PSAY "Eng. Vendas"
            Else
               @ li+02,010 PSAY "________________________"
               @ li+03,017 PSAY "Diretoria"
         Endif
         
         // FIM IMPRESSAO DE CONDICOES COMERCIAIS

         li := li+4

         Rodape2()

      Next nVias

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Impressao da ultima pagina do orcamento                  ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
      @ li+22,01 PSAY "FQ.03.02 - Revisao 01 (05/10/1999)"

*/

      dbSelectArea("SCJ")
      dbSkip()
      If cNumOrc <> SCJ->CJ_NUM
         cNumOrc := SCJ->CJ_NUM
      Endif
      // Impressao de um novo orcamento (p/ parametros de:ate)
      dbSelectArea("SA1")
      dbSeek(xFilial("SA1")+SCJ->CJ_CLIENTE)
      cEmpresa   := "EMPRESA: " + SA1->A1_NOME + " " + SA1->A1_COD
      dbSelectArea("SU5")
      dbSeek(xFilial("SU5")+SU5->U5_CODCONT)
      cAtt       := "Att: " + SU5->U5_CONTAT
      cDpto      := "Dpto: " + SCJ->CJ_DPTO
      cFone      := "Fone: " + SCJ->CJ_FONE
      cFax       := "Fax: "  + SCJ->CJ_FAX
      cData      := "Data:" + StrZero(Day(dDataBase),2) + " de " + ;
      MesExtenso(Month(dDataBase)) + " de " + Str(Year(dDataBase))
      dbSelectArea("SA3")
      dbSeek(xFilial("SA3")+SCJ->CJ_VEND)
      cVendedor  := SA3->A3_NREDUZ    
      dbSelectArea("SA3")
      dbSeek(xFilial("SA3")+SCJ->CJ_ELABORA)
      cElaborador:= SCJ->CJ_ELABORA
      cRef       := "Referência: PROPOSTA COMERCIAL DT" + SCJ->CJ_NUM + ;
      "/" + Right(Str(Year(dDataBase)),2)
      dbSelectArea("SCJ")
      lNormal := .T.
   Enddo
//   eject     RETIRADO POR MARCIA EM 08/08/01
   SetPrc(0,0) 
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Fim de impressao                                         ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Devolve as ordens originais do arquivo                       ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   RetIndex("SCJ")
   Set Filter to

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Apaga indice de trabalho                                     ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*   Set Device to Screen

   If aReturn[5] == 1
      Set Printer To
      dbCommitAll()
      OurSpool(wnrel)
   Endif

   MS_FLUSH()*/

   endprint
   cou14b:end()
   u10s:end()
   u10b:end()
   c10s:end()
   c10b:end()
   c8s:end()
   c8b:end()
   u12b:end()
   c12s:end()
   
   Return

   /*
   ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
   ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
   ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
   ±±³Fun‡…o    ³ ImpItens ³ Autor ³ Adriano F. R. Santos  ³ Data ³ 11/03/99 ³±±
   ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
   ±±³Descri‡…o ³ Impressao dos itens do orcamento (sem preco especial)      ³±±
   ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
   ±±³ Uso      ³ DOMORC                                                     ³±±
   ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
   ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
   ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
   */
// Substituido pelo assistente de conversao do AP5 IDE em 20/07/01 ==> Function ImpItens
Static Function ImpItens()
// ==>> Impressao dos itens do orcamento sem preco especial

// *** AT
//   @ Li,000 PSAY U10S                          
	setafonte(u10s)
   
   dbSelectArea("SB1")
   dbSeek(xFilial("SB1") + SCK->CK_PRODUTO)


    LiNeS := 12                                                               
	TestaLinha()

    Li := Li + 1

// *** AT
//    cTamImp := IMP12S()
//	@ li,01 PSAY CHR(27)+cTamImp         

// *** AT
//   @ LI,000 PSAY U10B
	setafonte(u10b)
   @ LI,006 PSAY "Item "	
   @ Li,011 PSAY SCK->CK_ITEM  
// *** AT   
//   @ LI,015 PSAY U10S
	setafonte(c12s)

    Li := Li + 1

// *** AT
//   @ Li,014 PSAY CHR(27)+cTamImp         
                
   @ Li,006 PSAY2 (alltrim(SB1->B1_DESCR1))+" "+(alltrim(SB1->B1_DESCR2))

   if !empty (SB1->B1_DESCR3) .OR. !EMPTY (SB1->B1_DESCR4) 
      Li := Li + 1
      @ Li,005 PSAY2 SB1->B1_DESCR3  
      @ Li,047 PSAY2 SB1->B1_DESCR4  
   EndIF

   if !empty (SB1->B1_DESCR5)
      Li := Li + 1
      @ Li,005 PSAY2 SB1->B1_DESCR5  

   EndIF                  
   
   Li := Li + 1        

   @ Li,005 PSAY2 "Código do Produto / Part Number/: "   
// *** AT
//   @ Li,090 PSAY U10B
   @ Li,055 PSAY B1_COD FONT u12b
   @ Li,100 PSAY "NCM" + " " + B1_POSIPI FONT u12b
// *** AT   
//   @ Li,110 PSAY U10S

// *** AT
//   cTamImp := IMP12S()
//   @ li,01 PSAY CHR(27)+cTamImp         

                
   Li := Li + 1        

  // @ li,003 PSAY2 "+"
   @ li,004 PSAY2 Replicate("-",115)
  // @ li,090 PSAY2 "+"           
   
   li := li + 1

   @ li,003 PSAY2 "| UM |  Quantidade  | Valor Unit   | ICMS  |  Valor Unit     | IPI |   Valor Unit    |  Total Geral    |    Prazo     |"  
   
   li := li + 1
   
   @ li,003 PSAY2 "|    |              | C/ICMS S/IPI |       | C/ICMS  C/IPI   |     |  C/ICMS ST C/IPI| C/ICMS ST C/IPI |              |"
   
//                 56789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//                     1         2         3         4         5         6         7         8         9
   
   
   
   li := li + 1   
   
  // @ li,001 PSAY2 "|"
   @ Li,005 PSAY2 SB1->B1_UM    
 //  @ li,007 PSAY2 "|"
   dbSelectArea("SCK")   
   @ li,011 PSAY2 StrZero (SCK->CK_QTDVEN,6)
 // @ li,020 PSAY2 "|"
   @ li,019 PSAY2 SCK->CK_PRCVEN Picture "@R 999,999.99"  
//   @ li,036 PSAY2 
   @ li,034 PSAY2 SCK->CK_ICMS 
   @ li,035 PSAY2 " %" 
   @ li,039 PSAY2 SCK->CK_PRCVEN +(SCK->CK_IPI/100 * SCK->CK_PRCVEN)  Picture "@R 999,999.99"       
   @ Li,055 PSAY2 SCK->CK_IPI
   @ LI,057 PSAY2 " % "
   @ li,059 PSAY2 (SCK->CK_PRCVEN + (SCK->CK_IPI/100 * SCK->CK_PRCVEN)+ (SCK->CK_ICMSRET/SCK->CK_QTDVEN )) Picture "@R 999,999.99"
   @ li,072 PSAY2 (SCK->CK_VALOR  + (SCK->CK_IPI/100 * SCK->CK_VALOR )+SCK->CK_ICMSRET )  Picture "@R 999,999,999.99"
                                                                  

 //  nTotal1 := nTotal1 + (SCK->CK_VALOR * ((100-SCK->CK_ICMS)/100))-(((SCK->CK_VALOR + (SCK->CK_IPI/100 * SCK->CK_VALOR))-SCK->CK_VALOR)*(SCK->CK_ICMS/100))
   nTotal1 := nTotal1 + (SCK->CK_VALOR + (SCK->CK_IPI/100 * SCK->CK_VALOR))
  
   nTTTotal3 := nTTTotal3+(SCK->CK_ICMSRET)

   nTTotal2 := nTotal1+nTTTotal3 

  // @ li,059 PSAY2 "|"
     @li,090 PSAY2 SUBSTR(SCK->CK_PRAZO,1,13)
  // @ li,076 PSAY2 "|"

   li := li+1

   //@ li,003 PSAY2 "+"
   @ li,004 PSAY2 Replicate("-",115)
  // @ li,076 PSAY2 "+"           

   li := li+1
           
   IF !EMPTY(SCK->CK_SEUCOD) .OR. !Empty(SCK->CK_SEUDES)
   
	   @ li,005 PSAY2 "|            Código do Cliente            |        Número do Desenho do Cliente        |"
	//                5678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	//                     1         2         3         4         5         6         7         8         9
	   dbSelectArea("SCK")

		Li := Li + 1
//       @ Li,003 PSAY2 "|" 
	   @ li,016 PSAY2 SCK->CK_SEUCOD
//	   @ Li,045 PSAY2 "|"
       @ li,058 PSAY2 SCK->CK_SEUDES
//       @ Li,090 PSAY2 "|"
   
      li := li+1                 

   @ li,003 PSAY2 "+"
   @ li,004 PSAY2 Replicate("-",086)
   @ li,074 PSAY2 "+"           

   li := li+1

   EndIf
      
   dbSkip()

   Return

*****************
// Substituido pelo assistente de conversao do AP5 IDE em 20/07/01 ==> Function Cabec
Static Function Cabec()
**************
   //Logotipo()  
   
   logo() // Incluído por Fabrício (29/04/04)
  
   page // Incluído por Fabrício (27/04/04)
   Li := 1      

                                                                 
// *** AT
//   @ Li+01,000 PSAY U10B
//   @ Li+01,104 PSAY "ROSENBERGER DOMEX TELECOM LTDA" FONT u10b
   @ Li+01,65 PSAY "ROSENBERGER DOMEX TELECOM LTDA" FONT u10b
// *** AT
//   @ Li+02,001 PSAY U10S        // Impressao do cabecalho em tamanho normal
	setafonte(u10s)
//   @ Li+02,148 PSAY "Pag. " + StrZero(nNumPg,2)
   @ Li+02,098 PSAY "Pág. " + StrZero(nNumPg,2)
  // li:= 2
   @ Li+05,010 PSAY "Caçapava, "+ cData
// *** AT
//   @ Li+07,001 PSAY U10B
   @ Li+07,010 PSAY cEmpresa FONT u10b
// *** AT
//   @ Li+07,065 PSAY U10S
   @ Li+08,010 PSAY cEndereco
   @ Li+08,080 PSAY cCidade
   @ Li+08,098 PSAY cEstado
   @ Li+10,010 PSAY cAtt
   @ Li+10,060 PSAY "Vendedor : " + cVendedor  
   @ Li+10,090 PSAY "Elaborador: " + cElaborador
   @ Li+11,010 PSAY cDpto
   if !Empty(SCJ->CJ_REVISAO)
      @ LI+11,060    PSAY "Revisão: "+ cRevisao
   endif
   @ Li+12,010 PSAY cFone
   @ Li+12,075 PSAY cFax
   If !Empty(SCJ->CJ_REFEREN)
      @ Li+14,010 PSAY "Sua Ref.: "+SCJ->CJ_REFEREN
      ELSE
      @ Li+14,010 PSAY "Sua Ref.: Seu Pedido de Cotação"
   Endif
// *** AT
//   @ Li+16,001 PSAY U10B
   @ Li+16,010 PSAY cRef FONT u10b
// *** AT
//   @ Li+16,064 PSAY U10S
   @ Li+17,010 PSAY Replicate("-",200) //Mudança no cabeçalho (22/09)
   Li := 20
   Return( NIL )

*******************
// Substituido pelo assistente de conversao do AP5 IDE em 20/07/01 ==> Function TestaLinha
Static Function TestaLinha()
*******************
   If (Li + LiNes) >= 55
      nNumPg := nNumPg+1
//      if li > 80
//         Eject  
//         Endif
//      RETIRADO POR MARCIA NATALE EM 08/08/01
//                            
      IF nNumPg > 1
         timbre()
      ENDIF   
      endpage
      Cabec()
   EndIf

   Return( NIL )

*****************
// Substituido pelo assistente de conversao do AP5 IDE em 20/07/01 ==> Function Rodape
Static Function Rodape2()
*****************
   Li := 52
// *** AT
//   @ li+02,001 PSAY U10B
	setafonte(u10b)
   @ li+02,010 PSAY "Nota:Informamos nosso  No. do CGC: 54.821.137/0001-36"
   @ li+03,020 PSAY "              Insc. Est.: 645.098.041.112   "
   @ li+05,010 PSAY "Email : vendas@rdt.com.br  Fone: +55 12 3935-6500   Fax: +55 12 3933-1631"
// *** AT
//   @ li+06,001 PSAY U10S                          
   @ li+07,001 PSAY "FQ.03.02" FONT u10s

   Return( NIL )


Static Function timbre()
*****************
   Li := 53
// *** AT
//   @ li+02,001 PSAY U10B
	setafonte(u10b)
//                   123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                            1         2         3         4         5         6         7         8         9
//   @ li+02,010 PSAY "                                        ROSENBERGER DOMEX TELECOM S/A"
/*   @ li+03,010 PSAY "Rua Miracema, 781 - Chácaras Reunidas - São José dos Campos - SP - Brasil - CEP 12.238-360"
   @ li+04,010 PSAY "Fone: +55 12 3935-6500     Fax: +55 12 3933-1631     E-mail:vendas@rdt.com.br"
   @ li+05,010 PSAY "                                         http://www.rdt.com.br" */
   @ li+03,015 PSAY "Av Cabletech, 601 - B. Guamirim - Caçapava - SP - Brasil - CEP 12.295-230"
   @ li+04,015 PSAY "Fone: +55 12 3221-8500     Fax: +55 12 3221-8543    E-mail:vendas@rdt.com.br"
   @ li+05,015 PSAY "                                         http://www.rdt.com.br"    
// *** AT
//   @ li+06,010 PSAY U10S         

   Return( NIL )

static function setafonte(ofntobj)

ofnt := ofntobj

return

static function logo()                 
    
//oprn:saybitmap(827,827,"CAPA_RDT.PDF",1127,1127)
oprn:saybitmap(150,215,"LOGO_RDT.BMP",667,200)


return

/*Static Function IMP12S()
*****************
    cTamImp  := "(s12H"
	If SubStr( __DRIVER, 1, 4) == "HPLJ"
	   _cTipImp := "L"
	   cTamImp  := "(s0p12h0T"
	ElseIf SubStr( __DRIVER, 1, 2) == "HP"
	   _cTipImp := "J"       
	   cTamImp  := "(s12H"
	ElseIf SubStr( __DRIVER, 1, 4) == "EPSO"
	   _cTipImp := "M"
	    Else
	   _cTipImp := "J"   
	EndIf

   Return( cTamImp )

Static Function IMP15S()
*****************
    cTamImp  := "(s15H"
	If SubStr( __DRIVER, 1, 4) == "HPLJ"
	   _cTipImp := "L"
	   cTamImp  := "(s0p15h0T"
	ElseIf SubStr( __DRIVER, 1, 2) == "HP"
	   _cTipImp := "J"       
	   cTamImp  := "(s15H"
	ElseIf SubStr( __DRIVER, 1, 4) == "EPSO"
	   _cTipImp := "M"
	    Else
	   _cTipImp := "J"   
	EndIf

   Return( cTamImp )

Static Function IMP17S()
*****************
    cTamImp  := "(s15H"
	If SubStr( __DRIVER, 1, 4) == "HPLJ"
	   _cTipImp := "L"
	   cTamImp  := "(s0p17.50h0T"
	ElseIf SubStr( __DRIVER, 1, 2) == "HP"
	   _cTipImp := "J"       
	   cTamImp  := "(s15H"
	ElseIf SubStr( __DRIVER, 1, 4) == "EPSO"
	   _cTipImp := "M"
	    Else
	   _cTipImp := "J"   
	EndIf

   Return( cTamImp )*/
