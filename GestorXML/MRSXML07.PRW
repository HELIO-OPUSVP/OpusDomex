#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"
#Include "protheus.ch"
#Include "colors.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MRSXML07  ºAutor  ³Marco Aurelio       º Data ³  18/09/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ GestorXML - Altera Vencimento de Titulo no Financeiro      º±±                 
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MRSXML07()
      

Local	aCores := {}
Private aRotina   :=   {{"Pesquisar"  	,"AxPesqui", 0, 1} ,;				
						{"Visualizar" 	,"AxVisual", 0, 2},; 
						{"Alterar"		,"ALTSE2", 0, 4 }}											

Private aRegs     := {}
Private cCadastro := "Altera Data de Titulo - Contas a Pagar"
Private cPerg     := "ALTERSE2"


//Somente o usuário ADMIN pode alterar vencimento de Titulos
If !(__cUserID $ "000000#"+Alltrim(GetMV("MX_MRUSR03")))	// "000000=Administrador
	MsgAlert("Somente os usuários autorizados, podem alterar Vencimento de Titulos no Financeiro através do GestorXML. [ MRUSR03 ]")
	Return()
EndIf


mBrowse( 6,1,22,75,"SE2",,,,,,aCores)
dbSelectArea("SE2")
SE2->(dbSetOrder(1))                             


Return                                        



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALTERSE2  ºAutor  ³Microsiga           º Data ³  09/17/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


//Static Function ALTSE2(cCodCliFor,cLojCliFor,cNomCliFor,cCadOPER,cCadTES)
Static Function ALTSE2

//Variaveis do tamanho a tela
Local aDlgTela     := {000,000,343,505} //{000,000,410,505} //{000,000,343,505}

//Divisões dentro da tela
Local aDlgCabc     := {005,005,040,250}
Local aDlgCorp1    := {045,005,092,250}
Local aDlgCorp2    := {097,005,130,250} //{097,005,144,250}
Local aDlgCorp3    := {149,005,174,250}
Local aDlgRodp     := {145,005,165,250}  //{179,005,199,250}

Local nQtdCpo      := 5
Local nTamBtn      := (aDlgRodp[4] / nQtdCpo)
Local aBtn01       := {aDlgRodp[1]+04,   aDlgRodp[2] + (nTamBtn * 3) + (005) ,  nTamBtn-10, 012}
Local aBtn02       := {aDlgRodp[1]+04,   aDlgRodp[2] + (nTamBtn * 4) + (000) ,  nTamBtn-10, 012}

Local oDialg
Local cStrCad      := "SE2"
Local cTitCad      := "Alteração de Vencimento de Titulos " 
Local cPrtCad      := cTitCad+" ["+cStrCad+"]"
Local cCpoXml      := SE2->E2_FORNECE +"-"+ SE2->E2_LOJA   //cCodCliFor +"-"+ cLojCliFor    

Local _cFornec	   := SE2->E2_FORNECE //cCodCliFor
Local _cLojaFor    := SE2->E2_LOJA //cLojCliFor

Local nOpcao       := 0
Local lExiste      := .F.
Local lReturn      := .T.
Local lLoop        := .T.

Local cNumTitulo   := ""  
Local cVencto	   := ""
Local dVencREA   	:= CTOD("  /  /  ")

While lLoop
       
	cNumTitulo  := SE2->E2_PREFIXO + "-" + SE2->E2_NUM + "-" + SE2->E2_PARCELA 
	cVencto		:= "Vencto.Original: " + DTOC(SE2->E2_VENCTO) + " Vencto. Real: " + DTOC(SE2->E2_VENCREA) 
	dVencREA	:= STOD(SE2->E2_VENCREA)
		
	// Montagem da tela que serah apresentada para usuario (lay-out)
	Define MsDialog oDialg Title cPrtCad From aDlgTela[1],aDlgTela[2] To aDlgTela[3],aDlgTela[4] Pixel //Of oMainWnd
	
	//Cabec
	@ aDlgCabc[1], aDlgCabc[2] To aDlgCabc[3], aDlgCabc[4] LABEL " GestorXML: Dados do Fornecedor " COLOR CLR_BLUE,CLR_WHITE Of oDialg Pixel
	
	@ aDlgCabc[1]+010,aDlgCabc[2]+005 Say "Codigo"            Size 030 ,008 Pixel Of oDialg
	@ aDlgCabc[1]+009,aDlgCabc[2]+035 MsGet cCpoXml           Size 085 ,008 Pixel When .F. Of oDialg
	
	@ aDlgCabc[1]+022,aDlgCabc[2]+005 Say "Nome"              Size 030 ,008 Pixel Of oDialg
	@ aDlgCabc[1]+021,aDlgCabc[2]+035 MsGet cNomCliFor        Size 205 ,008 Pixel When .F. Of oDialg
	
	//Corpo 01
	@ aDlgCorp1[1], aDlgCorp1[2] To aDlgCorp1[3], aDlgCorp1[4] LABEL " GestorXML: Dados do Titulo " COLOR CLR_BLUE,CLR_WHITE Of oDialg Pixel
	
	@ aDlgCorp1[1]+010,aDlgCorp1[2]+005 Say "Titulo"           Size 030 ,008 Pixel Of oDialg
	@ aDlgCorp1[1]+009,aDlgCorp1[2]+035 MsGet cNumTitulo        Size 085 ,008 Pixel When .F. Of oDialg
	
	@ aDlgCorp1[1]+034,aDlgCorp1[2]+005 Say "Vencimento"         Size 030 ,008 Pixel Of oDialg
	@ aDlgCorp1[1]+033,aDlgCorp1[2]+035 MsGet cVencto        Size 205 ,008 Pixel When .F. Of oDialg
	
	//Corpo 02
	@ aDlgCorp2[1], aDlgCorp2[2] To aDlgCorp2[3], aDlgCorp2[4] LABEL " Informe a nova Data de Vencimento do Titulo " COLOR CLR_BLUE,CLR_WHITE Of oDialg Pixel
	
	@ aDlgCorp2[1]+010+3,aDlgCorp2[2]+005 Say "Vencto. Real"          Size 030 ,008 Pixel Of oDialg
	@ aDlgCorp2[1]+009+3,aDlgCorp2[2]+035 MsGet dVencREA          Size 085 ,008 Pixel When .T. Of oDialg  

	//Rodapé / Botões
	@ aBtn01[1],aBtn01[2] Button "Gravar"    Size aBtn01[3],aBtn01[4] Pixel Of oDialg Action (nOpcao:=1,oDialg:End())
	@ aBtn02[1],aBtn02[2] Button "Cancelar"  Size aBtn02[3],aBtn02[4] Pixel Of oDialg Action (nOpcao:=2,oDialg:End())
	
	Activate MsDialog oDialg Centered
	
	//Verifica se operação foi cancelada
	If nOpcao != 1
		lLoop   := .F.
		lReturn := .F.
	EndIf
	
	//Valida TES / OPERACAO
	If nOpcao == 1 .And. lReturn
		If Empty(dVencREA) 
			MsgStop("A Data de Vencimento devem ser preenchida.")
			lReturn := .F.
		EndIf
	EndIf 
				
	//Caso lReturn OK, então sair do Loop
	If lLoop .And. lReturn    
		lLoop   := .F.
	EndIf
	
End


If nOpcao == 1 .And. lReturn

	lExiste := .F.
	lReturn := .T.
   
	RecLock("SE2",.F.) 
		SE2->E2_VENCREA	:= dVencREA
	SE2->( msUnlock() )		     
 
EndIf

Return(lReturn)
