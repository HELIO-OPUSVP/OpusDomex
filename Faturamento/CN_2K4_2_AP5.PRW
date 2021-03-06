/*
Alterado dia 01/04/2011 por Juliano Ferreira
-Alterado Dados Cadastrais;
-Alterado local Fob

*/

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
			   
			   
User Function CN_2K4_2()        // incluido pelo assistente de conversao do AP5 IDE em 20/07/01

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,AORD")
SetPrvt("WNREL,NSEUCD,NNOSCD,ARETURN,NLASTKEY,CPERG")
SetPrvt("CIMPNORM,CIMPCOMP,TAMANHO,CRODATXT,NTIPO,NCNTIMPR")
SetPrvt("NTAM,NPOS,LINES,CEMPRESA,CENDERECO,CATT")
SetPrvt("CDPTO,CFONE,CFAX,CDATA,CVENDEDOR,CREF,CELABORADOR")
SetPrvt("CESTADO,CCIDADE,NTOTAL,NTTOTAL,CNUMORC,NVIAS,LFIRST")
SetPrvt("LNORMAL,LI,M_PAG,NNUMPG,CREVISAO,CAB1")
SetPrvt("CAB2,CAB3,NSEUDES,NOSSO,NVALOR,NHANDLE")
SetPrvt("TAMDOBUFFER,BUFFER,CORRIGE,RETSTRING,OPRN,OFNT")
SetPrvt("COU14B,U10S,U10B,C10S,C10B,C8S,C8B,U12B,C12S")


// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 20/07/01 ==> #Include "Laser.ch"

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 20/07/01 ==> #DEFINE PSAY SAY
#ENDIF
/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    � CN_2K2   � Autor 쿌driano F. R. Santos   � Data � 11/03/99 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o � Impressao de Orcamento segundo o padrao do cliente DOMEX   낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � SIGAFAT                                                    낢�
굇� Rev A    � Gerardo DOMEX (Jun/00) - Impressao na LJ 1100              낢�
굇� Rev B      Fabricio Mudan�a no Reajuste e Cabe�alho, Razao social     낢�     
굇� Rev C      GERARDO - ALTERACAO DO LAYOUT DA CN - (NOVA IMPRESSAO)     낢�     
굇� Rev D      Fabr�cio - Inclu�da acentua豫o no documento (Jan/2003)     낢�     
굇� Rev E      Fabr�cio - Adapta豫o para impress�o modo gr�fico (Abr/2004)낢�     
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis obrigatorias dos programas de relatorio            �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
/*titulo   := "Impressao de Orcamento"
cDesc1   := "Este programa tem a funcao de imprimir orcamentos segundo"
cDesc2   := "o padrao da Domex"
cDesc3   := " "
cString  := "SCJ"*/
aOrd     := {}
//wnrel    := "CN2002"
nseucd   := " "
nnoscd   := " "
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis padrao de todos os relatorios                                       �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
//aReturn:= { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nLastKey:= 0
cPerg := "DOORC"
/*cImpNorm  := chr(18)            //impressora - normal
cImpComp  := chr(15)            //         comprimido
cTamImp   := "(s15H"*/

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica as perguntas selecionadas                           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis utilizadas para parametros                         �
//� mv_par01     // De Orcamento                                 �
//� mv_par02     // Ate Orcamento                                �
//� mv_par03     // Numero de copias                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
if pergunte(cPerg,.T.) == .f.
  Return
endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Envia controle para a funcao SETPRINT                        �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

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
    //jfs iniicio
    // oprn:saybitmap(0,0,"CAPA_RDT.BMP",2480,3325)
    //fim jfs
    
    
   /*
   複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
   굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
   굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
   굇쿑un뇚o    � ORCImp   � Autor � Adriano F. R. Santos  � Data � 11/03/99 낢�
   굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
   굇쿏escri뇚o � Chamada do Relatorio                                       낢�
   굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
   굇� Uso      � DOMORC                                                     낢�
   굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
   굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�

   */
   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
   //� Variaveis locais exclusivas deste programa                   �
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
   Tamanho  := "P"
   cRodaTxt := "REGISTRO(S)"
   nTipo    := 0
   nCntImpr := 0
   nTam     := 80
   nPos     := 0
   LiNes    := 0

   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
   //� Variaveis do cabecalho do orcamento                          �
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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
   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
   //� Variaveis gerais desta funcao                                �
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
   nTotal    := 0  
   nTTotal   := 0
   cNumOrc   := Space(06)
   nVias     := 1
   lFirst    := .T.
   lNormal   := .T.


   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
   //� Inicializa variaveis para controlar cursor de progressao     �
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
   SetRegua(LastRec())

   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
   //� Inicializa os codigos de caracter Comprimido/Normal da impressora �
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//   nTipo  := IIF(aReturn[4]==1,15,18)

   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
   //� Contadores de linha e pagina                                 �
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
   //li     := 80
//   m_pag  := 0
   nNumPg := 0

  //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
  //� Reseta Impressora                                        �
  //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
//  @ 01,01 PSAY CHR(27)+"E"
  
//  @ 01,01 PSAY CHR(27)+"(19U"   //configura caracteres para Windows - Latin 1 (ANSI) - Fabr�cio Becherini (01/12/03)

   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
   //� Posiciona o Arquivo na ordem correta.                    �
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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
 
   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
   //� Cria texto do cabecalho do orcamento                     �
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
   dbSelectArea("SA1")
   dbSeek(xFilial("SA1")+SCJ->CJ_CLIENTE)
   cEmpresa   := SA1->A1_NOME + " " + SA1->A1_COD
   cEndereco  := SA1->A1_END
   cCidade    := SA1->A1_MUN
   cEstado    := SA1->A1_EST
   cVendedor  := SCJ->CJ_VEND 
   cElaborador :=SCJ->CJ_ELABORA
   cRevisao   := SCJ->CJ_REVISAO
   cAtt       := "Att : " + SU5->U5_CONTAT
   cDpto      := "Dpto: " + SCJ->CJ_DPTO
   cFone      := "Fone: " + SCJ->CJ_FONE
   cFax       := "Fax: "  + SCJ->CJ_FAX
   cData      := StrZero(Day(dDataBase),2) + " de " + ;
   MesExtenso(Month(dDataBase)) + " de " + Str(Year(dDataBase))

   cVendedor  := SCJ->CJ_VEND
   cElaborador:= SCJ->CJ_ELABORA
   cRef       := "Refer�ncia: PROPOSTA COMERCIAL " + SCJ->CJ_NUM + SCJ->CJ_REVISAO +;
   "/" + Right(Str(Year(dDataBase)),2)

   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
   //� Inicio da impressao                                      �
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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
         nTotal := 0   
         nTTotal:= 0
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
                  @ li+2,10 PSAY "      Atendendo sua solicita豫o, apresentamos abaixo nossa proposta comercial para o fornecimento"
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
            @ li,080 PSAY "TOTAL S/ICMS S/IPI R$  ==>" 
            @ li+01,080 PSAY "TOTAL C/ICMS C/IPI R$  ==>" 
//            @ li,108 PSAY nTotal Picture "@R 99,999,999.99"
            @ li,111 PSAY nTotal Picture "@R 99,999,999.99"
            li := li+1 
            @ li,111 PSAY  nTTotal Picture "@R 99,999,999.99"
         EndIf
         If !lNormal
            @ li,100 PSAY "TOTAL S/ICMS S/IPI R$  ==>"
            li := li+1 
            @ li,100 PSAY "TOTAL C/ICMS C/IPI R$  ==>"
            @ li,116 PSAY nTotal Picture "@R 99,999,999.99" 
            li := li+1
            @ li,116 PSAY  nTTotal  Picture "@R 99,999,999.99"
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
//        @ li,010 PSAY C10B+"OBSERVA합ES"+C10S
        @ li,010 PSAY "OBSERVA합ES" FONT c10b
        setafonte(c10s)
        
		LiNeS := 09
        testalinha()                                    

// *** AT
//		cTamImp := IMP17S()
// 	    @ li+1,01 PSAY CHR(27)+cTamImp
     setafonte(c8s)

//        @ li+1,08 PSAY "Os cord�es �pticos produzidos pela Rosenberger Domex Telecom poder�o sofrer pequenas varia寤es no comprimento do cabo, cuja"     
        @ Li+1,07 Psay "1.Faturamento minino � de R$700,00 reais ."
        @ Li+2,07 Psay "2.Os prazos mencionados acima s�o todos em dias �teis."
        @ li+3,07 PSAY "3.Os cord�es �pticos produzidos pela Rosenberger Domex Telecom poder�o sofrer pequenas varia寤es no comprimento do cabo, cuja"
        @ lI+4,07 PSAY "toler�ncia m�xima � de:"
        @ li+5,20 PSAY " 0 a 10 metros   : +/- 3,0% de toler�ncia;"
	    @ li+6,20 PSAY "10 a 25 metros   : +/- 1,5% de toler�ncia;"
	    @ li+7,20 PSAY "25 metros ou mais: +/- 1,0% de toler�ncia."
	    @ li+8,07 PSAY "Para os cord�es com metragem  inferior a 10 metros, n�o aceitamos cancelamento do  pedido e/ou devolu寤es, por tratar-se de"
	    @ li+9,07 PSAY "material feito sobre encomenda." 
           
        li := li+10
		LiNeS := 04
        testalinha()                         
        
// *** AT
// 		cTamImp := IMP17S()
// 	    @ li  ,01 PSAY CHR(27)+cTamImp
		setafonte(c8s)

//        @ li  ,07 PSAY "OS PRE�OS S홒 V핶IDOS SOMENTE PARA ESTA PROPOSTA E NAS QUANTIDADES ACIMA REFERENCIADAS"
        @ li  ,06 PSAY "OS PRE�OS S홒 V핶IDOS SOMENTE PARA ESTA PROPOSTA E NAS QUANTIDADES ACIMA REFERENCIADAS"
        @ li+1,06 PSAY "INFORMAR NOSSA REFER�NCIA EM SEU PEDIDO DE COMPRA."
        @ li+2,06 PSAY "SOLICITAMOS INFORMAR EM SEU PEDIDO O DESTINO DO MATERIAL:"
        @ li+3,06 PSAY "[  ] REVENDA   [  ] INDUSTRIALIZA플O   [  ] CONSUMO   [  ] TRANSFORMA플O"
         
        li := li+4
        LiNes := 5
        TestaLinha()

        @ li   ,10 PSAY "DEMAIS CONDI합ES COMERCIAIS"
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
            //@ Li+04,16 Psay "MATERIAL SUJEITO � SUBSTITUI플O TRIBUT핾IA QUANDO SUA DESTINA플O FOR REVENDA DENTRO DO ESTADO DE S홒 PAULO  CONF.DECRETO 54251/09 ART.313-Z17 DE 17/04/09"
            ELSEIf ALLTRIM(SCJ->CJ_ICMS) == "I"
//                 @ li+03,16 PSAY "ICMS - Isento"
                 @ li+03,08 PSAY "ICMS - Isento"
            ELSE
//                 @ li+03,16 PSAY " ICMS - " + ALLTRIM(SCJ->CJ_ICMS) + "% ja incluso"
                 @ li+03,08 PSAY "ICMS - Conforme indicado em cada produto"
        Endif
                 @ li+04,08 PSAY "ICMS-ST: MATERIAL SUJEITO � SUBSTITUI플O TRIBUT핾IA QUANDO SUA DESTINA플O FOR REVENDA DENTRO DO ESTADO DE S홒 PAULO   
                 @ li+05,08 PSAY "CONF.DECRETO 54251/09 ART.313-Z17 DE 17/04/09"
                 @ li+06,08 PSAY "IPI  - Conforme indicado em cada produto"

         li := li + 8
         LiNes := 2
         TestaLinha()

// *** AT  
//         @ li   ,01 PSAY C10B
		 setafonte(c10b)
         @ li   ,10 PSAY "2. CONDI합ES DE PAGAMENTO (" + SCJ->CJ_CONDPAG +")"

// *** AT
//         cTamImp := IMP15S()

//		 @ li+01,01 PSAY CHR(27)+cTamImp         
		setafonte(c8b)

         dbSelectArea("SE4")
         dbSeek(xFilial("SE4") + SCJ->CJ_CONDPAG)

//         @ li+01,17 PSAY SE4->E4_DESCRI + ", ap�s a entrega do material"
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
            @ li+04,30 PSAY "FOB - Ca�apava - SP."
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

//         @ li+02,21 PSAY "Caso ocorra, dentro do prazo de validade desta proposta, altera寤es na pol�tica econ�mica vigente e/ou altera寤es cambiais"
         @ li+02,10 PSAY "Caso ocorra, dentro do prazo de validade desta proposta, altera寤es na pol�tica econ�mica vigente e/ou altera寤es cambiais"
         @ li+03,10 PSAY "superior ou igual a +/-5% (mais ou menos cinco por cento), os valores e prazos contidos nesta proposta dever�o ser reajus-"
         @ li+04,10 PSAY "tados, de comum acordo entre a  Rosenberger  Telecom e o Cliente, preservando-se o  equil�brio financeiro de ambas as                 
         @ li+05,10 PSAY "partes. Os pre�os acima tem como base a cota豫o da moeda nesta data, publicada pelo Jornal Gazeta Mercantil."

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

//         @ li+02,22 PSAY "No caso de atraso de pagamento ser쟧mputado juros, salvo se o motivo for gerado pela RDT S/A"
         @ li+02,10 PSAY "No caso de atraso de pagamento ser쟧mputado juros, salvo se o motivo for gerado pela RDT S/A"

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
         @ li+03,10 PSAY "fabrica豫o dentro de um per�odo de 12 meses ap�s a entrega dos mesmos sem �nus a sua empresa, desde que utiliza-"
         @ li+04,10 PSAY "dos em condi寤es normais e apropriadas ao servi�o. Ficam  exclu�dos dessa garantia os danos provenientes de ins-"
         @ li+05,10 PSAY "tala豫o e manuseio inadequados e/ou decorrentes de avarias por acidentes."

         li := li+6
         LiNes := 8
         TestaLinha()

// *** AT
//         @ li+01,01 PSAY C10B
//         @ li+01,10 PSAY "8. DEVOLU플O:"+C10S
         @ li+01,10 PSAY "8. DEVOLU플O:" FONT c10b

// *** AT
//         cTamImp := IMP17S()
//		 @ li+02,01 PSAY CHR(27)+cTamImp  
		setafonte(c8s)

//         @ li+02,22 PSAY "Qualquer devolu豫o de  material fica condicionada  a recebimento pela  Rosenberger Domex Telecom do relat�rio de"
         @ li+02,10 PSAY "Qualquer devolu豫o de  material fica condicionada  a recebimento pela  Rosenberger Domex Telecom do relat�rio de"
         @ li+03,10 PSAY "n�o conformidade para an�lise e solu豫o do processo, de comum acordo."

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

//         @ li+02,22 PSAY "Inclusa nos pre�os propostos."
         @ li+02,10 PSAY "Inclusa nos pre�os propostos."

         li := li+3
         LiNes := 13
         TestaLinha()

// *** AT
//         @ li+01,01 PSAY C10B
//         @ li+01,10 PSAY "10. ALTERA합ES DA POL�TICA ECON�MICA:"+C10S
         @ li+01,10 PSAY "10. ALTERA합ES DA POL�TICA ECON�MICA:" FONT c10b

// *** AT
//         cTamImp := IMP17S()
//		 @ li+02,01 PSAY CHR(27)+cTamImp  
		setafonte(c8s)

//         @ li+02,22 PSAY "Os pre�os e condi寤es desta proposta foram fixados  de acordo com a sistem�tica econ�mico/financeira ditada pela"
         @ li+02,10 PSAY "Os pre�os e condi寤es desta proposta foram fixados  de acordo com a sistem�tica econ�mico/financeira ditada pela"
         @ li+03,10 PSAY "pol�tica vigente. Portanto, na eventualidade de ocorrerem altera寤es econ�micas/financeiras entre a data da pro-"
         @ li+04,10 PSAY "posta e a data da entrega do material, as condi寤es ora propostas, dever�o ser revistas de modo a restabelecer a"
         @ li+05,10 PSAY "rela豫o que as partes pactuaram inicialmente,  objetivando a manuten豫o do  incial equil�brio econ�mico e finan-"
         @ li+06,10 PSAY "ceiro da proposta."

         li := li+6

         @ li+01,13 PSAY "Atenciosamente,"

         li := li+2

         If nTotal <= 15000
            @ li+02,010 PSAY "________________________"
            @ li+02,097 PSAY "________________________"
            @ li+03,017 PSAY "Emitente"
            @ li+03,100 PSAY "Eng. Vendas"
            Else
               @ li+02,010 PSAY "________________________"
               @ li+03,017 PSAY "Diretoria"
         Endif  
         
          If nTTotal <= 15000
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

      //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
      //� Impressao da ultima pagina do orcamento                  �
      //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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
      dbSelectArea("SCJ")
      dbSeek(xFilial("SCJ")+SCJ->CJ_ELABORA)
      cElaborador := SCJ->CJ_ELABORA
        
      cRef       := "Refer�ncia: PROPOSTA COMERCIAL " + SCJ->CJ_NUM + ;
      "/" + Right(Str(Year(dDataBase)),2)
      dbSelectArea("SCJ")
      lNormal := .T.
   Enddo
//   eject     RETIRADO POR MARCIA EM 08/08/01
   SetPrc(0,0) 
   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
   //� Fim de impressao                                         �
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
   //� Devolve as ordens originais do arquivo                       �
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
   RetIndex("SCJ")
   Set Filter to

   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
   //� Apaga indice de trabalho                                     �
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

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
   複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
   굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
   굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
   굇쿑un뇚o    � ImpItens � Autor � Adriano F. R. Santos  � Data � 11/03/99 낢�
   굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
   굇쿏escri뇚o � Impressao dos itens do orcamento (sem preco especial)      낢�
   굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
   굇� Uso      � DOMORC                                                     낢�
   굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
   굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
   賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
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

   @ Li,005 PSAY2 "C�digo do Produto / Part Number/: "   
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

   @ li,003 PSAY2 "| UM |  Quantidade  | Valor Unit   | ICMS  |  Valor Unit  | IPI |   Valor Unit   |  Total Geral |    Prazo        |"  
   
   li := li + 1
   
   @ li,003 PSAY2 "|    |              | S/ICMS S/IPI |       | C/ICMS S/IPI |     |  C/ICMS C/IPI  | C/ICMS C/IPI |                 |"
   
//                 56789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//                     1         2         3         4         5         6         7         8         9
   
   
   
   li := li + 1   
   
  // @ li,001 PSAY2 "|"
   @ Li,005 PSAY2 SB1->B1_UM    
 //  @ li,007 PSAY2 "|"
   dbSelectArea("SCK")   
   @ li,011 PSAY2 StrZero (SCK->CK_QTDVEN,6)
 // @ li,020 PSAY2 "|"
   @ li,019 PSAY2 (SCK->CK_PRCVEN * ((100-SCK->CK_ICMS)/100))   Picture "@R 999,999.99"     //alterado para aceitar valor na CN 29/08/01 Fabr�cio
//   @ li,036 PSAY2 
   @ li,034 PSAY2 SCK->CK_ICMS 
   @ li,035 PSAY2 " %" 
   @ li,039 PSAY2 SCK->CK_PRCVEN Picture "@R 999,999.99"          
   @ Li,053 PSAY2 SCK->CK_IPI
   @ LI,054 PSAY2 " % "
   @ li,059 PSAY2 (SCK->CK_PRCVEN + (SCK->CK_IPI/100 * SCK->CK_PRCVEN)) Picture "@R 999,999.99"
   @ li,068 PSAY2 (SCK->CK_VALOR  + (SCK->CK_IPI/100 * SCK->CK_VALOR ))  Picture "@R 999,999,999.99"
                                                                  

   nTotal := nTotal +  (SCK ->CK_VALOR * ((100 - SCK->CK_ICMS)/100))

   nTTotal := nTTotal + (SCK->CK_VALOR + (SCK->CK_IPI/100 * SCK->CK_VALOR)) 

  // @ li,059 PSAY2 "|"
     @li,085 PSAY2 SUBSTR(SCK->CK_PRAZO,1,13)
  // @ li,076 PSAY2 "|"

   li := li+1

   //@ li,003 PSAY2 "+"
   @ li,004 PSAY2 Replicate("-",115)
  // @ li,076 PSAY2 "+"           

   li := li+1
           
   IF !EMPTY(SCK->CK_SEUCOD) .OR. !Empty(SCK->CK_SEUDES)
   
	   @ li,005 PSAY2 "|            C�digo do Cliente            |        N�mero do Desenho do Cliente        |"
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
   logo() // Inclu�do por Fabr�cio (29/04/04)
   
   page // Inclu�do por Fabr�cio (27/04/04)
   Li := 1                                                                 
// *** AT
//   @ Li+01,000 PSAY U10B
//   @ Li+01,104 PSAY "ROSENBERGER DOMEX TELECOM LTDA" FONT u10b
   @ Li+01,65 PSAY "ROSENBERGER DOMEX TELECOM LTDA" FONT u10b
// *** AT
//   @ Li+02,001 PSAY U10S        // Impressao do cabecalho em tamanho normal
	setafonte(u10s)
//   @ Li+02,148 PSAY "Pag. " + StrZero(nNumPg,2)
   @ Li+02,098 PSAY "P�g. " + StrZero(nNumPg,2)
  // li:= 2
   @ Li+05,010 PSAY "Ca�apava, "+ cData
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
   @ Li+10,090 PSAY "Sup.Tecnico : " + cElaborador
   @ Li+11,010 PSAY cDpto
   if !Empty(SCJ->CJ_REVISAO)
      @ LI+11,060    PSAY "Revis�o: "+ cRevisao
   endif
   @ Li+12,010 PSAY cFone
   @ Li+12,075 PSAY cFax
   If !Empty(SCJ->CJ_REFEREN)
      @ Li+14,010 PSAY "Sua Ref.: "+SCJ->CJ_REFEREN
      ELSE
      @ Li+14,010 PSAY "Sua Ref.: Seu Pedido de Cota豫o"
   Endif
// *** AT
//   @ Li+16,001 PSAY U10B
   @ Li+16,010 PSAY cRef FONT u10b
// *** AT
//   @ Li+16,064 PSAY U10S
   @ Li+17,010 PSAY Replicate("-",200) //Mudan�a no cabe�alho (22/09)
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
   @ li+02,010 PSAY "Nota:Informamos nosso  No. do CNPJ: 54.821.137/0001-36"
   @ li+03,020 PSAY "              Insc. Est.: 645.098.041.112   "
   @ li+05,010 PSAY "Email : vendas@rdt.com.br  Fone: +55 12 3221-8500   Fax: +55 12 3878-4600"
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
/*   @ li+03,010 PSAY "Rua Miracema, 781 - Ch�caras Reunidas - S�o Jos� dos Campos - SP - Brasil - CEP 12.238-360"
   @ li+04,010 PSAY "Fone: +55 12 3935-6500     Fax: +55 12 3933-1631     E-mail:vendas@rdt.com.br"
   @ li+05,010 PSAY "                                         http://www.rdt.com.br" */
   @ li+03,015 PSAY "Av Cabletech, 601 - B. Guamirim - Ca�apava - SP - Brasil - CEP 12.295-230"
   @ li+04,015 PSAY "Fone: +55 12 3221-8500     Fax: +55 12 3221-8543     E-mail:vendas@rdt.com.br"
   @ li+05,015 PSAY "                                         http://www.rdt.com.br"    
// *** AT
//   @ li+06,010 PSAY U10S         

   Return( NIL )

static function setafonte(ofntobj)

ofnt := ofntobj

return

static function logo()

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
