/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  MT110GRV� Autor � Marcos Rezende        � Data � 21/01/11 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada apos grava��o da SC.                      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � MP8                                                        ���
���          � Necessario Criar Campo                                     ���
���          � Nome			Tipo	Tamanho	Titulo			OBS           ���
���          � C1_CODAPROV   C         6    Cod Aprovador                 ���
���          �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT110GRV()

Local aArea     := GetArea()
Local cRet := .T.

//��������������������������������������������������������Ŀ
//�Envia Workflow para aprovacao da Solicitacao de Compras �
//����������������������������������������������������������

//If INCLUI .OR. ALTERA //Verifica se e Inclusao ou Alteracao da Solicitacao
//	MsgRun("Enviando Workflow da Solicita��o...","",{|| CursorWait(), U_COMRD003() ,CursorArrow()})
//EndIf

RestArea(aArea)

Return cRet