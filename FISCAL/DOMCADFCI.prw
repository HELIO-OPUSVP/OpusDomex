#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DOMCADFCI  � Autor � Mauricio  OPUS    � Data �  27/09/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro FCI                                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � DOMEX                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function DOMCADFCI

Local cVldAlt := ".T." // Validacao para permitir a alteracao. 
Local cVldExc := ".T." // Validacao para permitir a exclusao. 

Private cString  := "CFD"
Private aRotAdic :={}

dbSelectArea("CFD")
dbSetOrder(1)


aadd(aRotAdic,{ "Limpeza Tabela","U_DOMFCI", 0 , 6 })

AxCadastro(cString," Ficha de Conte�do de Importa��o (FCI) ",cVldExc     ,cVldAlt   , aRotAdic   )

Return





