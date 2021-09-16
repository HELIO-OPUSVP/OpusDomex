/***********************************************************************************
* Programa.........:   PONAP160.PRW							                       *

***********************************************************************************/

#INCLUDE "PROTHEUS.CH" 
#INCLUDE "AP5MAIL.CH"
#INCLUDE "MSOLE.CH"  
                                                   
User Function PONAP160()
Private aInc 		:={}
Private aExc 		:={}
Private aAlt 		:={}
Private cAssunto	:=""
Private nOpc   		:=0
Private cBody		:=""
Private cEmail		:= "claudia.silvestre@rdt.com.br;stephanie.gamt@rosenberdomex.com.br;aline.maciel@rosenbergerdomex.com.br;wagnerlima1@hotmail.com;" 



If !IsInCallStack('PONA161TRFALL')
	For i:=len(aCols) To len(aCols)
		if (Empty(aCols[i][12]))//inclusão
			//DATA[1] /TURNO DE [2]/ TURNO PARA [3] 
			AADD(aInc,{acols[i][1],acols[i][2],acols[i][3],"",acols[i][8]})
			//           1        ,2          ,3          ,4 ,5
		elseif(aCols[i][Len(aCols[i])] ==.T.) // exlusão
			//DATA[1] /TURNO DE [2]/ TURNO PARA [3] 
			AADD(aExc,{acols[i][1],acols[i][2],acols[i][3],"",acols[i][8]})      
		endif
	Next
	aAlt := Compara()

	if Len(aInc)>0
		nOpc:=1   
		//MntEmail()
		//U_EnvMailto(cAssunto,cBody,cEmail,"",/*cArquivo*/)
		ImpTurn()
	endif
	if Len(aExc)>0   
		nOpc:=2
		//MntEmail()
		//U_EnvMailto(cAssunto,cBody,cEmail,"",/*cArquivo*/)
	endif
EndIf
Return Nil

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Comapra para verificar se ocorreu alteração de turno                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Compara()

	For i:=1 To len(aColsAnt)
		if aCols[i][1] <> aColsAnt[i][1].Or.;
			aCols[i][2] <> aColsAnt[i][2].Or.;
			aCols[i][3] <> aColsAnt[i][3].Or.;
			aCols[i][4] <> aColsAnt[i][4].Or.;
			aCols[i][5] <> aColsAnt[i][5].Or.;
			aCols[i][6] <> aColsAnt[i][6].Or.;
			aCols[i][7] <> aColsAnt[i][7]
			//DATA         TURNO DE       SEQ            TURNO PA       REGRA          05             05
			//AADD(aAlt,{aColsAnt[i][1],aColsAnt[i][2],aColsAnt[i][3],aColsAnt[i][4],aColsAnt[i][5],aColsAnt[i][6],aColsAnt[i][7],""})
			AADD(aAlt,{aCols[i][1]   ,aCols[i][2]   ,aCols[i][3]   ,aCols[i][4]   ,aCols[i][5]   ,aCols[i][6]   ,aCols[i][7]   ,"",""})
		endif
	Next   

Return(aAlt)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Funcao utilizada para montar o email                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function MntEmail()

Local   cVTrans :="Sim"
Private cDescTo :=""
Private cDescTd :=""

cBody :=""

//monta mensagem incl
if nOpc ==1.Or.nOpc ==3
	cBody :="<BODY LANG='pt-BR' DIR='LTR'>"
	//
   cBody +="		<TD WIDTH=133 HEIGHT=15>"
	cBody +="			<P><FONT FACE='verdana, Arial, Helvetica, sans-serif',font color = '#FF0000', sans-serif''><strong>ROSENBERGER</FONT><br><br></P>"
 	//cBody +="			<FONT FACE='verdana, Arial, Helvetica, sans-serif',font color = '#000000', sans-serif''><small>Domex</FONT></P>"   
	cBody +="		</TD>"
    //
	cBody +="<TABLE WIDTH=595 BORDER=1 CELLPADDING=4 CELLSPACING=0 STYLE='page-break-before: always'>"
	cBody +="	<COL WIDTH=133>"
	cBody +="	<COL WIDTH=209>"
	cBody +="	<COL WIDTH=229>"
	cBody +="	<TR>"
	cBody +="		<TD COLSPAN=3 WIDTH=587 HEIGHT=15 VALIGN=TOP BGCOLOR = '#DFDFE0'>"
	cBody +="			<P ALIGN=CENTER><FONT FACE=''Calibri ,font color = '#990000', sans-serif''><FONT SIZE=4 STYLE=''font-size: 16pt''><B>"
	cBody +="			Aviso" 
	cBody +="					- Troca de Turno</B></FONT></FONT></P>"
	cBody +="		</TD>"
	cBody +="	</TR>"
	cBody +="	<TR>"
	cBody +="		<TD COLSPAN=3 WIDTH=587 HEIGHT=15 VALIGN=BOTTOM>"
	cBody +="			<P><BR>"
	cBody +="			</P>"
	cBody +="		</TD>"
	cBody +="	</TR>"
	cBody +="	<TR VALIGN=BOTTOM>"
	cBody +="		<TD WIDTH=133 HEIGHT=15>"
	cBody +="			<P><FONT FACE=''Calibri, sans-serif''>Funcionário:</FONT></P>"
	cBody +="		</TD>"
	cBody +="		<TD COLSPAN=2 WIDTH=446>"
	cBody +="			<P><FONT FACE=''Calibri, sans-serif''>"+SRA->RA_NOME+"</FONT></P>"
	cBody +="		</TD>"
	cBody +="	</TR>"
	cBody +="	<TR VALIGN=TOP>"
	cBody +="		<TD WIDTH=133 HEIGHT=7>"
	cBody +="			<P><FONT FACE=''Calibri, sans-serif''>Matricula:</FONT></P>"
	cBody +="		</TD>"
	cBody +="		<TD COLSPAN=2 WIDTH=446>"
	cBody +="			<P><FONT FACE=''Calibri, sans-serif''>"+SRA->RA_MAT+"</FONT></P>"
	cBody +="		</TD>"
	cBody +="	</TR>"
	cBody +="	<TR VALIGN=TOP>"
	cBody +="		<TD WIDTH=133 HEIGHT=7>"
	cBody +="			<P><FONT FACE=''Calibri, sans-serif''>Telefone:</FONT></P>"
	cBody +="		</TD>"
	cBody +="		<TD COLSPAN=2 WIDTH=446>"
	cBody +="			<P><FONT FACE=''Calibri, sans-serif''>"+IIF(!Empty(Alltrim(SRA->RA_DDDFONE)),"(" + SRA->RA_DDDFONE+") ","")+Alltrim(SRA->RA_TELEFON)+" / "+iif(!Empty(Alltrim(SRA->RA_DDDCELU)),"(" + Alltrim(SRA->RA_DDDCELU) + ") ","") + SRA->RA_NUMCELU+"</FONT></P>"
	cBody +="		</TD>"
	cBody +="	</TR>"
	cBody +="	<TR VALIGN=TOP>"
	cBody +="		<TD WIDTH=133 HEIGHT=15>"
	cBody +="			<P><FONT FACE=''Calibri, sans-serif''>Endere&ccedil;o:</FONT></P>"
	cBody +="		</TD>"
	cBody +="		<TD COLSPAN=2 WIDTH=446>"
	cBody +="			<P><FONT FACE=''Calibri, sans-serif''>"+Alltrim(SRA->RA_ENDEREC)+", " + Alltrim(SRA->RA_NUMENDE) +"</FONT></P>"
	cBody +="		</TD>"
	cBody +="	</TR>"
	cBody +="	<TR VALIGN=TOP>"
	cBody +="		<TD WIDTH=133 HEIGHT=15>"
	cBody +="			<P><FONT FACE=''Calibri, sans-serif''>Bairro/Cidade:</FONT></P>"
	cBody +="		</TD>"
	cBody +="		<TD COLSPAN=2 WIDTH=446>"
	cBody +="			<P><FONT FACE=''Calibri, sans-serif''>"+SRA->RA_BAIRRO+" / "+SRA->RA_MUNICIP+"</FONT></P>"
	cBody +="		</TD>"
	cBody +="	</TR>"
	cBody +="	<TR VALIGN=TOP>"
	cBody +="		<TD WIDTH=133 HEIGHT=15>"
	cBody +="			<P><FONT FACE=''Calibri, sans-serif''>Data Altera&ccedil;&atilde;o:</FONT></P>"
	cBody +="		</TD>"
	cBody +="		<TD COLSPAN=2 WIDTH=446>"
	cBody +="			<P><FONT FACE=''Calibri, sans-serif''>"+DtoC(dDataBase)+"</FONT></P>"
	cBody +="		</TD>"
	cBody +="	</TR>"
	cBody +="	<TR VALIGN=TOP>"
	cBody +="		<TD WIDTH=133 HEIGHT=15 BGCOLOR='#FFFFFF'>"
	cBody +="			<P><FONT FACE=''Calibri, sans-serif''>Alterado por:</FONT></P>"
	cBody +="		</TD>"
	cBody +="		<TD COLSPAN=2 WIDTH=446 BGCOLOR='#FFFFFF'>"
	cBody +="			<P><FONT FACE=''Calibri, sans-serif''>"+Substr(cUsuario,7,15)+"</FONT></P>"
	cBody +="		</TD>"
	cBody +="	</TR>"
	cBody +="	<TR>"
	cBody +="		<TD COLSPAN=3 WIDTH=587 HEIGHT=15 VALIGN=TOP>"
	cBody +="			<P><br>"
	cBody +="			</P>"
	cBody +="		</TD>"
	cBody +="	</TR>"
	cBody +="	<TR VALIGN=TOP>"
	cBody +="		<TD WIDTH=133 HEIGHT=15 BGCOLOR='#DFDFE0'>"
	cBody +="			<P><FONT FACE=''Calibri, sans-serif''><FONT SIZE=2><b>Data Início:</FONT></P>"
	cBody +="		</TD>"
	cBody +="		<TD WIDTH=209 BGCOLOR='#DFDFE0'>"
	cBody +="			<P><FONT FACE=''Calibri, sans-serif''><FONT SIZE=2><b>De:</FONT></P>"
	cBody +="		</TD>"
	cBody +="		<TD WIDTH=229 BGCOLOR='#DFDFE0'>"
	cBody +="			<P><FONT FACE=''Calibri, sans-serif''><FONT SIZE=2><b>Para:</FONT></P>"
	cBody +="		</TD>"
	cBody +="	</TR>"
	DbSelectArea("SR6")
	DbSetOrder(1)
	if nOpc ==1 //ilclusão
		for i:= 1 To (len(aInc))
			cBody +="	<TR VALIGN=TOP>"
			cBody +="		<TD WIDTH=133 HEIGHT=15>"
			cBody +="			<P><FONT FACE=''Calibri, sans-serif''><FONT SIZE=2>"+DtoC(aInc[i][1])+"</FONT></FONT></P>"
			cBody +="		</TD>"
			cBody +="		<TD WIDTH=209>"
			If DbSeek(xFilial("SR6") + aInc[i][2]) //turno de
				cBody +="			<P><FONT FACE=''Calibri, sans-serif''><FONT SIZE=2>"+aInc[i][2]+"-"+AllTrim(SR6->R6_DESC)+"</FONT></FONT></P>"
				aInc[i][4]:=AllTrim(SR6->R6_DESC)
			Endif
			cBody +="		</TD>"
			cBody +="		<TD WIDTH=229>"
			If DbSeek(xFilial("SR6") + aInc[i][3]) //turno para
				cBody +="			<P><FONT FACE=''Calibri, sans-serif''><FONT SIZE=2>"+aInc[i][3]+"-"+AllTrim(SR6->R6_DESC)+"</FONT></FONT></P>"
				aInc[i][4]:=AllTrim(SR6->R6_DESC)
			Endif
			cBody +="		</TD>"
			cBody +="	</TR>"
		Next
	endif
	if nOpc ==3 //alteração
		for i:= 1 To (len(aAlt))
			cBody +="	<TR VALIGN=TOP>"
			cBody +="		<TD WIDTH=133 HEIGHT=15>"
			cBody +="			<P><FONT FACE=''Calibri, sans-serif''><FONT SIZE=2>"+DtoC(aAlt[i][1])+"</FONT></FONT></P>"
			cBody +="		</TD>"
			cBody +="		<TD WIDTH=209>"
			If DbSeek(xFilial("SR6") + aAlt[i][2]) //turno de
				cBody +="			<P><FONT FACE=''Calibri, sans-serif''><FONT SIZE=2>"+aAlt[i][2]+"-"+AllTrim(SR6->R6_DESC)+"</FONT></FONT></P>"
				aAlt[i][8]:=AllTrim(SR6->R6_DESC)
			Endif
			cBody +="		</TD>"
			cBody +="		<TD WIDTH=229>"
			If DbSeek(xFilial("SR6") + aAlt[i][4]) //turno para
				cBody +="			<P><FONT FACE=''Calibri, sans-serif''><FONT SIZE=2>"+aAlt[i][4]+"-"+AllTrim(SR6->R6_DESC)+"</FONT></FONT></P>"
				aAlt[i][9]:=AllTrim(SR6->R6_DESC)
			Endif
			cBody +="		</TD>"
			cBody +="	</TR>"
			
		Next
	Endif
	cBody +="	<TR>"
	cBody +="		<TD COLSPAN=3 WIDTH=587 HEIGHT=3 BGCOLOR='#FFFFFF'>"
	cBody +="			<P><BR>"
	cBody +="			</P>"
	cBody +="		</TD>"
	cBody +="	</TR>"
	
	if !Empty(SRA->RA_FRETADO)
   	if SRA->RA_FRETADO == "S" 
 	 		cVTrans :="Sim" 
   	else
	   	cVTrans :="Não"
  		endif			
 	else
   	cVTrans :="Não"
   endif   
    
	cBody +="	<TR>" 
	cBody +="		<TD WIDTH=113 BGCOLOR='#DFDFE0'>"
	cBody +="			<P><FONT FACE='Calibri, sans-serif'><FONT SIZE=2><b>Possui V.T.?</FONT></FONT></P>"
	cBody +="		</TD>"
	cBody +="		<TD COLSPAN=2 WIDTH=446 BGCOLOR='#FFFFFF'>"
	cBody +="			<P><FONT FACE='Calibri, sans-serif'><FONT SIZE=2>"+cVTrans+"</FONT></FONT></P>"
	cBody +="		</TD>"
	cBody +="	</TR>"
	cBody +="	<TR>"
	cBody +="		<TD WIDTH=113 BGCOLOR='#DFDFE0'>"
	cBody +="			<P>  <FONT FACE='Calibri, sans-serif'><FONT SIZE=2><b>Motivo:</FONT></FONT></P>"
	cBody +="		</TD>"
	cBody +="		<TD COLSPAN=2 WIDTH=446 BGCOLOR='#ffffff'>"
	
	if nOpc ==1
		for i:= 1 To (len(aInc))
			cBody +="			<P><FONT FACE='Calibri, sans-serif'><FONT SIZE=2>"+AllTrim(aInc[i][5])+"</FONT></FONT></P>"
		Next
	elseif nOpc ==3
	    for i:= 1 To (len(aAlt))
		   cBody +="			<P><FONT FACE='Calibri, sans-serif'><FONT SIZE=2>"+AllTrim(aAlt[i][5])+"</FONT></FONT></P>"
		Next
	endif
	cBody +="		</TD>"
	cBody +="	</TR>"
	cBody +="</TABLE>"
	cBody +="		<TD WIDTH=133 HEIGHT=100>"
	cBody +="			<FONT FACE='Calibri, sans-serif'><small><small>Rosenberger - Departamento de Sistemas - Microsiga Protheus</FONT>"
    cBody +="		</TD>"
	cBody +="<P><BR><BR>"
	cBody +="</P>"
	cBody +="</BODY>"
	cBody +="</HTML>"	
	cAssunto:="Troca de Turno(s) " + DTOC(DDATABASE)
Endif

//exclusao
if nOpc ==2
	cBody +="<BODY LANG='pt-BR' DIR='LTR'>"
	cBody +="		<TD WIDTH=133 HEIGHT=15>"
	cBody +="			<P><FONT FACE='verdana, Arial, Helvetica, sans-serif',font color = '#FF0000', sans-serif''><strong>ROSENBERGER</FONT><br><br></P>"
   //cBody +="			<FONT FACE='verdana, Arial, Helvetica, sans-serif',font color = '#000000', sans-serif''><small>Domex</FONT></P>"   
	cBody +="		</TD>"
	cBody +="<TABLE WIDTH=595 BORDER=1 CELLPADDING=4 CELLSPACING=0 STYLE='page-break-before: always'>"
	cBody +="	<COL WIDTH=133>"
	cBody +="	<COL WIDTH=109>"
	cBody +="	<COL WIDTH=229>"
	cBody +="	<TR>"
	cBody +="		<TD COLSPAN=5 WIDTH=446 BGCOLOR='#DFDFE0' VALIGN=TOP>"
	cBody +="			<P ALIGN=CENTER><FONT FACE=''Calibri ,font color = '#990000', sans-serif''><FONT SIZE=4><B>Foi"
	cBody +="			excluído o registro referente a troca de turno:</FONT></FONT></P>"
	cBody +="		</TD>"
	cBody +="	</TR>"
  	cBody +="	<TR VALIGN=TOP>"
	cBody +="		<TD COLSPAN=5 WIDTH=446>"
	cBody +="			<P><BR>"
	cBody +="			</P>"
	cBody +="		</TD>"
	cBody +="	</TR>"     
	cBody +="	<TR VALIGN=TOP>"
	cBody +="		<TD COLSPAN=5 WIDTH=446 BGCOLOR='#ffffff'>"
	cBody +="			<P><FONT FACE='Calibri, sans-serif'>"+SRA->RA_MAT+" - <br></FONT>"
	cBody +="			<FONT FACE='Calibri, sans-serif'>"+SRA->RA_NOME+"</FONT></P>"
	cBody +="		</TD>"
	for i:=1 To Len(aExc)
		DbSelectArea("SR6")
		DbSetOrder(1)
		cBody +="	<TR VALIGN=TOP>"
		cBody +="		<TD WIDTH=133>"
		cBody +="			<P><FONT FACE='Calibri, sans-serif'><FONT SIZE=2>"+DtoC(aExc[i][1])+"</FONT></P>"
		cBody +="		</TD>"
		cBody +="		<TD COLSPAN=3 WIDTH=209>"
		If DbSeek(xFilial("SR6") + aExc[i][2]) //turno de
			cBody +="			<P><FONT FACE=''Calibri, sans-serif''><FONT SIZE=2>"+aExc[i][2]+"-"+AllTrim(SR6->R6_DESC)+"</FONT></FONT></P>"
		Endif
		cBody +="		</TD>"
		cBody +="		<TD WIDTH=229>"
		If DbSeek(xFilial("SR6") + aExc[i][3]) //turno para
			cBody +="			<P><FONT FACE=''Calibri, sans-serif''><FONT SIZE=2>"+aExc[i][3]+"-"+AllTrim(SR6->R6_DESC)+"</FONT></FONT></P>"
		Endif
		cBody +="		</TD>"
		cBody +="	</TR>"
	Next
	cBody +="</TABLE>"
	cBody +="<TD WIDTH=133 HEIGHT=100>"
	cBody +="<FONT FACE='Calibri, sans-serif'><small><small>Rosenberger - Departamento de Sistemas - Microsiga Protheus</FONT>"
    cBody +="</TD>"
	cBody +="<P STYLE='margin-bottom: 0cm'><BR>"
	cBody +="</P>"
	cBody +="</BODY>"
	cAssunto:="Exclusao de Turno(s) " + DTOC(DDATABASE)
endif

Return(cBody)

//impressao
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Funcao que gera docuemnto do word.                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function ImpTurn()
Local cDia 		:= AllTrim(Str(Day(dDataBase)))
Local aMes 		:= {"Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}
Local cMes  	:= aMes[Month(dDataBase)]
Local cAno  	:= AllTrim(Str(Year(dDataBase)))
Local cTurno1,cTurno2,cTurno3,cTurno4,cTurno5 :="-"//cDescTd
Local cDt2,cDt3,cDt4,cDt5 :="-"
Local cDt1 := date()
Local cFunc		:= AllTrim(SRA->RA_NOME)
Local cMat 		:= Alltrim(SRA->RA_MAT)
Local cPath	    := AllTrim(GetTempPath())

DbSelectArea("SR6")
DbSetOrder(1)
If DbSeek(xFilial("SR6") + SPF->PF_TURNOPA)
	cTurno := AllTrim(SR6->R6_DESC)  
Endif
//ALERT(M->PF_TURNOPA)
oWord:=OLE_CreateLink()

If File(cPath+"\trocadeturno.dot")
	FErase(cPath+"\trocadeturno.dot")
endif


if(CpyS2T("\word\trocadeturno.dot",cPath,.F.)) //.And.CpyS2T("\system\dots\trocaturnos.dot",cPath,.F.))
 

	//INCLUSAO
	if Len(aInc)==1.And.nOpc ==1
		Ole_NewFile (oWord,cPath+"trocadeturno.dot")
		Ole_SetDocumentVar(oWord,"cTurno1",aInc[1][4])		
		Ole_SetDocumentVar(oWord,"cDt1",aInc[1][1])   
		
 
	/* não utilizado
	elseif Len(aInc)>1.And.nOpc ==1
		Ole_NewFile (oWord,cPath+"trocaturnos.dot")
		for i:=1 To Len(aInc)
			if i==1
				Ole_SetDocumentVar(oWord,"cTurno1",aInc[i][4])
				Ole_SetDocumentVar(oWord,"cDt1",aInc[i][1])
			elseif i==2
				Ole_SetDocumentVar(oWord,"cTurno2",aInc[i][4])
				Ole_SetDocumentVar(oWord,"cDt2",aInc[i][1])
			elseif i==3
				Ole_SetDocumentVar(oWord,"cTurno3",aInc[i][4])
				Ole_SetDocumentVar(oWord,"cDt3",aInc[i][1])
			elseif i==4
				Ole_SetDocumentVar(oWord,"cTurno4",aInc[i][4])
				Ole_SetDocumentVar(oWord,"cDt4",aInc[i][1])
			elseif i==5
				Ole_SetDocumentVar(oWord,"cTurno5",aInc[i][4])
				Ole_SetDocumentVar(oWord,"cDt5",aInc[i][1])
			endif
		next
		
		for i:= len(aInc)+1 To 5
			if i==3
				Ole_SetDocumentVar(oWord,"cTurno3","")
				Ole_SetDocumentVar(oWord,"cDt3","")
			elseif i==4
				Ole_SetDocumentVar(oWord,"cTurno4","")
				Ole_SetDocumentVar(oWord,"cDt4","-")
			elseif i==5
				Ole_SetDocumentVar(oWord,"cTurno5","")
				Ole_SetDocumentVar(oWord,"cDt5","")
			endif
		next
	*/
	endif
	
	if Len(aAlt)==1.And.nOpc ==3
	//	Ole_NewFile (oWord,cPath+"trocaturno.dot")
	//	Ole_SetDocumentVar(oWord,"cTurno1",aAlt[1][8]+" / "+aAlt[1][9])
	//	Ole_SetDocumentVar(oWord,"cDt1",aAlt[1][4])
	/* desabilitado
	elseif Len(aAlt)>1.And.nOpc ==3
		Ole_NewFile (oWord,cPath+"trocaturnos.dot")
		for i:=1 To Len(aAlt)
			if i==1
				Ole_SetDocumentVar(oWord,"cTurno1",aAlt[i][8]+" / "+aAlt[i][9])
				Ole_SetDocumentVar(oWord,"cDt1",aAlt[i][1])
			elseif i==2
				Ole_SetDocumentVar(oWord,"cTurno2",aAlt[i][8]+" / "+aAlt[i][9])
				Ole_SetDocumentVar(oWord,"cDt2",aAlt[i][1])
			elseif i==3
				Ole_SetDocumentVar(oWord,"cTurno3",aAlt[i][8]+" / "+aAlt[i][9])
				Ole_SetDocumentVar(oWord,"cDt3",aAlt[i][1])
			elseif i==4
				Ole_SetDocumentVar(oWord,"cTurno4",aAlt[i][8]+" / "+aAlt[i][9])
				Ole_SetDocumentVar(oWord,"cDt4",aAlt[i][1])
			elseif i==5
				Ole_SetDocumentVar(oWord,"cTurno5",aAlt[i][8]+" / "+aAlt[i][9])
				Ole_SetDocumentVar(oWord,"cDt5",aAlt[i][1])
			endif
		next
		for i:= len(aAlt)+1 To 5
			if i==3
				Ole_SetDocumentVar(oWord,"cTurno3","")
				Ole_SetDocumentVar(oWord,"cDt3","")
			elseif i==4
				Ole_SetDocumentVar(oWord,"cTurno4","")
				Ole_SetDocumentVar(oWord,"cDt4","")
			elseif i==5
				Ole_SetDocumentVar(oWord,"cTurno5","")
				Ole_SetDocumentVar(oWord,"cDt5","")
			endif
		next
	*/
	endIf
	
	Ole_SetDocumentVar(oWord,"cdia",cDia)
	Ole_SetDocumentVar(oWord,"cMes",cMes)
	Ole_SetDocumentVar(oWord,"cAno",cAno)
	//Ole_SetDocumentVar(oWord,"cUsuario", Substr(cUsuario,7,15))
	Ole_SetDocumentVar(oWord,"cFunc",cFunc)
	Ole_SetDocumentVar(oWord,"cMat",cMat)
	Ole_UpdateFields(oWord)
	//OLE_SetProperty( oWord, oleWdVisible,   .F. )       // seto a propriedade de visibilidade do word
	//OLE_SetProperty( oWord, oleWdPrintBack, .T. )
	OLE_SetProperty( oWord, '208', .F. ) ; OLE_PrintFile( oWord,"All",,,1 ) //Ole_PrintFile(oWord,"All",,,1)
	//OLE_PrintFile( oWord ) //Ole_PrintFile(oWord,"All",,,1)
	Ole_CloseFile(oWord)
	Ole_CloseLink(oWord)
	
	
else
	Alert("Não foi possivel gerar o documento referente a Troca de Turno, comunique o T.I.")
endif

Return()

