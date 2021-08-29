#include "protheus.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³mt130FOR  ºAutor  ³Marcos Rezende      º Data ³  10/29/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para escolher os Fornecedores conforme    º±±
±±º          ³ amarração de Produto x Fornecedores                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
PARAMIXB[x][1] -> Codigo do Fornecedor
PARAMIXB[x][2] -> Codigo da Loja
PARAMIXB[x][3] -> Data Ultimo Fornecimento;
PARAMIXB[x][4] -> Sigla da Tabela SA2;
PARAMIXB[x][5] -> Número Registro Tabela SA2
*/


user function mt130FOR()
Local aFornOLD := PARAMIXB
Local Aforn := {}

cQry := "SELECT SA2.R_E_C_N_O_ 'A2RECNO',SA5.R_E_C_N_O_ 'A5RECNO',* FROM SA5010 SA5 "
cQry += CRLF+"INNER JOIN SA2010 SA2 ON A2_COD=A5_FORNECE AND A2_LOJA = A5_LOJA AND SA2.D_E_L_E_T_=' '"
cQry += CRLF+"WHERE A5_MSBLQL<>'1' and SA5.D_E_L_E_T_=' ' and A5_PRODUTO='"+sc1->c1_produto+"'"
if select("TMPSQL") > 0
	TMPSQL->(dbClosearea())
endif
tcquery cQRY NEW ALIAS "TMPSQL"

WHILE tmpsql->(!eof())
	aADD(aForn,{TMPSQL->A2_COD,TMPSQL->A2_LOJA,'Ultimo fornecimento em : '+dtoc(stod(TMPSQL->A2_ULTCOM)),'SA5',TMPSQL->A5RECNO})
	TMPSQL->(DBSKIP())
ENDDO

return aForn
