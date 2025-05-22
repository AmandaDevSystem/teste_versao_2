#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

User Function HISLPCEC(nOpc)

	Local cTituloAP       := ""
	Local cTituloAR       := ""
	Local cHist           := ""
	Local cQuery          := ""
	Local cRecPag         := ""
	Local cNotaCliente    := ""
	Local cNotaFornecedor := ""
	Local cTabela         := ""
	Local cQuery          := ""
	Local cIdenTee        := SE5->E5_IDENTEE
	Local cRegPag         := SE5->E5_RECPAG

	//Query para localizar o vinculo entre os E5 e FK1 FK2
	cQuery := " SELECT SE5.E5_NUMERO, SE5.E5_BENEF, SE5.E5_RECPAG,E5_CLIENTE "
	cQuery += " FROM "+RetSqlName("SE5")+" SE5 "

	If cRegPag == "R"

		cQuery += " INNER JOIN "+RetSqlName("FK1")+" FK1 "
		cQuery += " ON SE5.E5_IDENTEE = FK1.FK1_IDPROC "

	ElseIf cRegPag == "P"

		cQuery += " INNER JOIN "+RetSqlName("FK2")+" FK2 "
		cQuery += " ON SE5.E5_IDENTEE = FK2.FK2_IDPROC "
	EndIf

	cQuery += " WHERE SE5.D_E_L_E_T_ = '' "

	If cRegPag == "R"

		cQuery += " AND FK1.D_E_L_E_T_ = '' "

	ElseIf cRegPag == "P"

		cQuery += " AND FK2.D_E_L_E_T_ = '' "
	EndIf

	cQuery += " AND SE5.E5_FILIAL = '"+xFilial("SE5")+"' "

	If cRegPag == "R"

		cQuery += " AND FK1.FK1_IDPROC = '"+cIdenTee+"' "

	ElseIf cRegPag == "P"

		cQuery += " AND FK2.FK2_IDPROC = '"+cIdenTee+"' "
	EndIf

	fCloseArea("QSE5")
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QSE5",.T.,.T.)

/*
	NUM COMP     NFREC           NFPAGTO       FORNECEDOR             NOME CLIENTE  
	EST CEC 000048     NF 12345789 NF 123456789 SEGREDOS PORTAS AUTOMATICAS  E DISTRIBUI 
    "EST CEC" + "-" + STRLCTPAD +"-"+ NF: CLIENTE: 0000000001 / NF: FORNEC: 00000000010 +"-"+LEFT(SA2->A2_NOME,40) +"-"+"CLI"+ SE5->E5_CLIENTE    
*/
	DbSelectArea("QSE5")
	QSE5->(DbGoTop())
	If QSE5->(!Eof())
		
        If cRegPag == "R"

			cHist :="EST CEC "+cIdenTee +" NF: CLIENTE:"+("QSE5")->E5_NUMERO+" / NF: FORNEC:"+("QSE5")->E5_NUMERO+"-"+LEFT(SA2->A2_NOME,40) +"-"+"CLI"+ ("QSE5")->E5_CLIENTE

		ElseIf cRegPag == "P"

			cHist :="EST CEC "+cIdenTee +"NF: CLIENTE:"+("QSE5")->E5_NUMERO+"/ NF: FORNEC:"+("QSE5")->E5_NUMERO+"-"+LEFT(SA2->A2_NOME,40) +"-"+"CLI"+ SE5->E5_CLIENTE
		EndIf
	EndIf

Return cHist

/*
	If nOpc == 1  // Contas a receber/Nota de saida.

		cTabela:="FK1"
	ElseIf nOpc == 2 //Contas a pagar /Doc. Entrada.

		cTabela:="FK2"
	EndIf
*/

/*
    cQuery += " AND E1.E1_TIPO = 'NCC' "
    cQuery += " AND E1.E1_CLIENTE = '"+SF1->F1_FORNECE+"' "
    cQuery += " AND E1.E1_LOJA = '"+SF1->F1_LOJA+"' "
*/

// Monta a query SQL com os campos necessários
/* cQuery := "SELECT SE5.E5_NUMERO, SE5.E5_BENEF, SE5.E5_RECPAG " + ;
            "FROM FK1010 AS FK1 " + ;
            "INNER JOIN FK2010 AS FK2 ON FK1.FK1_IDPROC = FK2.FK2_IDPROC " + ;
            "INNER JOIN SE5010 AS SE5 ON SE5.E5_IDENTEE = FK1.FK1_IDPROC"

// Executa a query
oQuery := TCQuery(cQuery)

// Percorre os resultados
While !oQuery:Eof()
    cRecPag := AllTrim(oQuery:E5_RECPAG)

    If cRecPag == "P" .And. Empty(cTituloAP)
        cTituloAP := oQuery:E5_NUMERO
    ElseIf cRecPag == "R" .And. Empty(cTituloAR)
        cTituloAR := oQuery:E5_NUMERO
    EndIf

    oQuery:Skip()
EndDo

// Fecha o cursor
oQuery:Close()

// Monta a string explicativa
If !Empty(cTituloAP) .And. !Empty(cTituloAR)
    cHist := "Título AP: " + cTituloAP + " / Título AR: " + cTituloAR
ElseIf !Empty(cTituloAP)
    cHist := "Título AP: " + cTituloAP
ElseIf !Empty(cTituloAR)
    cHist := "Título AR: " + cTituloAR
Else
    cHist := "Nenhum título encontrado"
EndIf
*/

/*
    dbSelectArea(cChave)
    dbSetOrder(1)
    If dbSeek(xFilial()+cIdenTee)

    E5_IDENTEE == FK1_IDPROC
    E5_IDORIG  == FK1_IDFK1   8BE03981FD254011BCA0005056964842 
                                8BE03981FD254011BCA0005056964842
    E5_NUMERO
    E5_RECPAG

    EndIf
*/


//--------------------------------------------------------------------------
/* {Protheus.doc} fCloseArea
Funcao para verificar se existe tabela e exclui-la
Empresa -
@author Nome Sobrenome
@since 01/06/2016
@version P11 R8
*/
//--------------------------------------------------------------------------
Static Function fCloseArea(pParTabe)

	If (Select(pParTabe)!= 0)
		dbSelectArea(pParTabe)
		dbCloseArea()
		If File(pParTabe+GetDBExtension())
			FErase(pParTabe+GetDBExtension())
		EndIf
	EndIf

Return
