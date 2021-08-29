//------------------------------------------------------------------------------------------------------------------------------------------------//
//Wederson L. Santana - 10/10/2012                                                                                                                //
//------------------------------------------------------------------------------------------------------------------------------------------------//
//Especifico Domex                                                                                                                                //
//------------------------------------------------------------------------------------------------------------------------------------------------//
//                                                                                                                                                //
//------------------------------------------------------------------------------------------------------------------------------------------------//
#include "rwmake.ch"
#include "protheus.ch"

User Function DOMEST04()
Local aCores := {{'AllTrim(XD1_OCORRE)$"1"' , 'DISABLE'    },;	
	              {'AllTrim(XD1_OCORRE)$"2"' , 'BR_PRETO'   },;	
	              {'AllTrim(XD1_OCORRE)$"3"' , 'BR_AMARELO' },; 
	              {'AllTrim(XD1_OCORRE)$"4"' , 'BR_VERDE'   },;
	              {'AllTrim(XD1_OCORRE)$"5"' , 'BR_CINZA'   } }
	              
DbSelectArea("XD1")
aRotina := { { "Pesquisar       ",'AxPesqui'     , 0, 1 },;
             { "Visualizar      ",'AxVisual'     , 0, 2 },;
             { "Etiqueta Avulsa ",'U_DOMEST07(1)', 0, 3 },; 
             { "Importacao      ",'U_DOMEST07(3)', 0, 3 },;                           
             { "Etiq.Enderecos  ",'U_DOMEST07(2)', 0, 2 },; 
             { "Legenda         ",'U_fLegenda'   , 0, 2 } }

//           { "Reimpressao     ",'U_fReImp'     , 0, 2 },;              
//           { "Teste Impressora",'MSCBTestePort', 0, 2 },;

cCadastro := "Recebimento - Controle na impressão das etiquetas"

//SetKey(VK_F10, { || U_fReImp() } )

mBrowse( 6, 1,22,75,"XD1",,,,,,aCores,,,,,,,,)   
SetKey(VK_F10,Nil)
Return

//----------------------------------------------------------       

User Function fReImp()


Return

//------------------------------------------------------------

User Function fLegenda()

/*
1 (vermelha) Etiqueta de Pré-NF não classificada

2 (preta)    Etiqueta de NF classificada e em CQ

3 (amarela)  Etiqueta de NF Classificada, liberada pelo CQ e com pendência de Endereçamento

4 (verde)    Etiqueta endereçada e pronta para uso

5 (cinza)    Material já utilizado
*/

BrwLegenda("","Legenda",{ {"DISABLE"    ,"Etiqueta de Pré-NF não classificada"                                            },;  // 1
                          {"BR_PRETO"   ,"Etiqueta de NF classificada e em CQ"                                            },;  // 2
                          {"BR_AMARELO" ,"Etiqueta de NF Classificada, liberada pelo CQ e com pendência de Endereçamento" },;  // 3
                          {"ENABLE"     ,"Etiqueta endereçada e pronta para uso"                                          },;  // 4
                          {"BR_AZUL"    ,"Material já utilizado"                                                          }}) // 5

                          
                          /*{"BR_AMARELO","Reimpressa"   },;  // 2*/                          
//SX3-->1=Impresso;2=Reimpresso;3=Nao Impresso;4=Excluido;5=Avulsa;6=Armazenado;7=Consumido

Return                                                        