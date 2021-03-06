#include "protheus.ch"
#include "topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �mt130FOR  �Autor  �Marcos Rezende      � Data �  10/29/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para escolher os Fornecedores conforme    ���
���          � amarra��o de Produto x Fornecedores                        ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
PARAMIXB[x][1] -> Codigo do Fornecedor
PARAMIXB[x][2] -> Codigo da Loja
PARAMIXB[x][3] -> Data Ultimo Fornecimento;
PARAMIXB[x][4] -> Sigla da Tabela SA2;
PARAMIXB[x][5] -> N�mero Registro Tabela SA2
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
