/*
DATA: 17/04/2024
NOME DO JOB: [ITAU PJ] - BASE GATILHOS INSERIR:
AUTOR: JOÃO LUIZ - TI
SOLICITANTE: MICHELI ENKIN
MOTIVO: AUTOMATIZAR O PROCESSO, ESTAVAMOS FAZENDO MANUALMENTE.

TUTORIAL: extraia o arquivo do .zip e deixe ele com a nomeclatura ( base_gatilho_data.csv ) e execute o job.


OBS: O SCRIPT ELE BUSCA A PASTA DO EDI ANTES DAS 14:00H NO MODELO (DIA_MES) E DEPOIS DAS 14:00H NO MODELO (DIA_MES_1)
*/


use safra;

DECLARE @DIRETORIO				VARCHAR(200)
DECLARE @COMANDO				VARCHAR(200)
DECLARE @ARQUIVOESCOLHIDO		VARCHAR(200)
DECLARE	@DIA					VARCHAR(20)		=	DAY(GETDATE())
DECLARE	@ANO					VARCHAR(20)		=	YEAR(GETDATE())
DECLARE	@MES					VARCHAR(20)		
DECLARE @PASTA_DIA_MES			VARCHAR(200)	=	(select replace(convert(varchar(5), getdate(), 103), '/', '_'))
DECLARE @COPY					VARCHAR(200)
DECLARE @MOVE					VARCHAR(255)
DECLARE @CAMINHO_PROCESSADOS	VARCHAR(255)	=   '\\192.168.0.46\import_cobweb\ITAU_BASE_GATILHOS\PROCESSADOS'
DECLARE @DESTINO				VARCHAR(200)	=	'\\192.168.0.46\import_cobweb\ITAU_BASE_GATILHOS' -- lev
DECLARE @RENAME					VARCHAR(255);

SET		@MES	=	(
						CASE 
							WHEN	MONTH(GETDATE())	=	1	THEN	'01 - JANEIRO'
							WHEN	MONTH(GETDATE())	=	2	THEN	'02 - FEVEREIRO'
							WHEN	MONTH(GETDATE())	=	3	THEN	'03 - MARÇO'
							WHEN	MONTH(GETDATE())	=	4	THEN	'04 - ABRIL'
							WHEN	MONTH(GETDATE())	=	5	THEN	'05 - MAIO'
							WHEN	MONTH(GETDATE())	=	6	THEN	'06 - JUNHO'
							WHEN	MONTH(GETDATE())	=	7	THEN	'07 - JULHO'
							WHEN	MONTH(GETDATE())	=	8	THEN	'08 - AGOSTO'
							WHEN	MONTH(GETDATE())	=	9	THEN	'09 - SETEMBRO'
							WHEN	MONTH(GETDATE())	=	10	THEN	'10 - OUTUBRO'
							WHEN	MONTH(GETDATE())	=	11	THEN	'11 - NOVEMBRO'
							WHEN	MONTH(GETDATE())	=	12	THEN	'12 - DEZEMBRO'
						END
					)

IF(convert(varchar(5),GETDATE(),108)) < '14:00' 
begin
		SET	@DIRETORIO	=	'"\\192.168.0.48\EDI\' + @ano + '\' + @MES + '\' + @PASTA_DIA_MES
		SET	@COMANDO	=	'dir ' + @DIRETORIO + '" /b'
end
else
begin
		SET	@DIRETORIO	=	'"\\192.168.0.48\EDI\' + @ano + '\' + @MES + '\' + @PASTA_DIA_MES + '_' + '1'
		SET	@COMANDO	=	'dir ' + @DIRETORIO + '" /b'

end

-- ============================================================================================================
		
DROP TABLE IF EXISTS #ARQUIVOS

CREATE TABLE #ARQUIVOS
(	NOMEARQUIVO VARCHAR (200)
)

INSERT INTO #ARQUIVOS
EXEC xp_cmdshell	@comando 


SET @ARQUIVOESCOLHIDO = (
							SELECT 
									NOMEARQUIVO 
							FROM	#ARQUIVOS	
							WHERE	NOMEARQUIVO LIKE	'%base_gatilho%'
							and		NOMEARQUIVO LIKE	'%' + @DIA + '%' + SUBSTRING(@MES, 1, 2) + '%' + @ANO + '%'
						)
 --print @ARQUIVOESCOLHIDO


 if exists(select * from #ARQUIVOS where NOMEARQUIVO LIKE	'%base_gatilho%')
 begin
  




		-- ============================================================================================================

		-- Comando para copiar o arquivo usando o comando COPY do Windows
		SET @COPY = 'COPY ' + @DIRETORIO + '\'+ @ARQUIVOESCOLHIDO + '"  "' + @DESTINO +'"';

		--PRINT @COPY 
		-- Executar o comando usando xp_cmdshell
		EXEC xp_cmdshell @COPY;
		-- ============================================================================================================
		--truncate table temp_base_gatilhos

		drop table if exists #temp_base_gatilho
		CREATE TABLE #temp_base_gatilho (
			ESCRITORIOFINAL VARCHAR(255),
			CGCCPF VARCHAR(255),
			CNPJ_COMPLETO VARCHAR(255),
			NOME_CLI VARCHAR(255),
			cprodlim VARCHAR(255),
			numctror VARCHAR(255),
			atr_ctr VARCHAR(255),
			atr_cli VARCHAR(255),
			vl_ser VARCHAR(255),
			VLR_SER_CLI VARCHAR(255),
			vl_ca6 VARCHAR(255),
			VLR_CA6_CLI VARCHAR(255),
			segmento_novo VARCHAR(255),
			FILA VARCHAR(255),
			QTD_CONTRATO VARCHAR(255),
			FX_ATRASO VARCHAR(255),
			FX_ATRASO_cli VARCHAR(255),
			DICA_CLI_FINAL VARCHAR(255),
			DESC_VISTA_CLI VARCHAR(255),
			DESC_PARC_CLI VARCHAR(255),
			Melhora_Oferta_Vista_CTR VARCHAR(255),
			Melhora_Oferta_Parc_CTR VARCHAR(255),
			Reducao_de_PMT_CTR VARCHAR(255),
			FX_VISTA VARCHAR(255),
			FX_PARC VARCHAR(255),
			VAP_VISTA_ant VARCHAR(255),
			VAP_VISTA_atual VARCHAR(255),
			VAP_PARC_ant VARCHAR(255),
			VAP_PARC_atual VARCHAR(255),
			PARCELA_ANT VARCHAR(255),
			PARCELA_ATUAL VARCHAR(255),
			taxa_ant VARCHAR(255),
			taxa_atual VARCHAR(255),
			prazo_ant VARCHAR(255),
			prazo_atual VARCHAR(255),
			Melhora_Oferta_Vista_CLI VARCHAR(255),
			Melhora_Oferta_Parc_CLI VARCHAR(255),
			Reducao_de_PMT_CLI VARCHAR(255),
			FX_VISTA_CLI VARCHAR(255),
			FX_PARC_CLI VARCHAR(255),
			VAP_VISTA_CLI_ANT VARCHAR(255),
			VAP_VISTA_CLI_ATUAL VARCHAR(255),
			VAP_PARC_CLI_ANT VARCHAR(255),
			VAP_PARC_CLI_ATUAL VARCHAR(255),
			PARCELA_CLI_ANT VARCHAR(255),
			PARCELA_CLI_ATUAL VARCHAR(255),
			TAXA_CLI_ANT VARCHAR(255),
			TAXA_CLI_ATUAL VARCHAR(255),
			PRAZO_CLI_ANT VARCHAR(255),
			PRAZO_CLI_ATUAL VARCHAR(255),
			PN_HOT VARCHAR(255),
			DATA_PN_HOT VARCHAR(255),
			VLR_SOLICITADO_PN_HOT VARCHAR(255),
			negociacao_PN_HOT VARCHAR(255),
			prazo_solic_PN_HOT VARCHAR(255),
			desconto_solic_PN_HOT VARCHAR(255),
			taxa_solic_PN_HOT VARCHAR(255),
			ALCADA_PN_HOT VARCHAR(255),
			PUBLICO_PN_HOT VARCHAR(255),
			Flag_Quitacao_Parcela_cli VARCHAR(255),
			Alcada_Mesa NVARCHAR(max)
		);

		DECLARE @SQL_BULK NVARCHAR(MAX);
		DECLARE @CAMINHO_COMPLETO	VARCHAR(255)	=    @DESTINO +'\'+ @ARQUIVOESCOLHIDO

		SET @SQL_BULK = '
		BULK INSERT #temp_base_gatilho
		FROM ''' + @CAMINHO_COMPLETO + '''
		WITH (
			FIELDTERMINATOR = '';'', -- Delimitador de campo (vírgula no caso de um arquivo CSV)
			ROWTERMINATOR = ''0x0a'', -- Delimitador de linha (nova linha)
			FIRSTROW = 2 ,
			CODEPAGE = ''acp''
		);';

		EXEC sp_executesql @SQL_BULK;
		--select top 10 * from #temp_base_gatilho

		-- =======================================================================================

				truncate table TBL_PJ_DICA_FINAL_BASE_GATILHOS_INSERIR; -- TRUNCANDO
			
				insert INTO TBL_PJ_DICA_FINAL_BASE_GATILHOS_INSERIR
				SELECT	distinct 
				RIGHT(CNPJ_COMPLETO, 15)		AS	CNPJ_COMPLETO,
				''								AS	CONTRATO_TIT,
				max(DICA_CLI_FINAL)				as [DICA_CLI_FINAL]
				FROM	#temp_base_gatilho
				where	CNPJ_COMPLETO			is not null
				and     DICA_CLI_FINAL			is not null
				group by CNPJ_COMPLETO

		-- ======================================================================================

				truncate table TBL_MELHORES_TAXAS_ITAU_PJ_INSERIR; -- TRUNCANDO
			
				insert INTO TBL_MELHORES_TAXAS_ITAU_PJ_INSERIR
				SELECT distinct
				RIGHT(CNPJ_COMPLETO, 15)		AS	CNPJ_COMPLETO,
				NOME_CLI						AS	NOME_CLI,
				CAST(REPLACE(TAXA_CLI_ANT	,	',', '.') AS FLOAT) AS taxa_ant,
				CAST(REPLACE(TAXA_CLI_ATUAL	,	',', '.') AS FLOAT) AS taxa_atual
				FROM	#temp_base_gatilho
				where	CNPJ_COMPLETO			IS NOT NULL
				and     TAXA_CLI_ANT			IS NOT NULL
				AND		TAXA_CLI_ATUAL			IS NOT NULL


		-- =======================================================================

				truncate table TBL_MESA_SEM_ATUACAO_INSERIR; -- TRUNCANDO
			
				insert INTO TBL_MESA_SEM_ATUACAO_INSERIR
				SELECT distinct
				RIGHT(CNPJ_COMPLETO, 15)		AS	CNPJ_COMPLETO,
				NOME_CLI						AS	NOME_CLI,
				''								AS	ATR_CLI,
				''								AS	VLR_CA6_CLI,
				''								AS	FILA,
				Alcada_Mesa						AS	Alcada_Mesa
				FROM	#temp_base_gatilho
				where	CNPJ_COMPLETO			IS NOT NULL
				AND     NOME_CLI				IS NOT NULL
				AND		Alcada_Mesa				IS NOT NULL



		-- ============================================================== Criando a tabela para enviar no e-mail a quantidade de casos que vão entrar
		drop table if exists #temp_qtde_entradas_gatilhos
		create table #temp_qtde_entradas_gatilhos
		(
			qtde_DICA_FINAL				varchar(100)not null,
			qtde_MESA_SEM_ATUACAO		varchar(100)not null,
			qtde_MELHORES_TAXAS_ITAU	varchar(100)not null
		)



		INSERT INTO #temp_qtde_entradas_gatilhos (qtde_DICA_FINAL, qtde_MESA_SEM_ATUACAO, qtde_MELHORES_TAXAS_ITAU)
		SELECT
			(	SELECT 
				COUNT		(ai.CNPJ_COMPLETO)
				FROM		TBL_PJ_DICA_FINAL_BASE_GATILHOS_INSERIR	ai
				LEFT JOIN	TBL_PJ_DICA_FINAL_BASE_GATILHOS			ma 
				ON			ai.CNPJ_COMPLETO						= ma.CNPJ_COMPLETO
				where		ma.CNPJ_COMPLETO is null
				)	
																	AS qtde_DICA_FINAL,
			(	SELECT 
				COUNT		(ai.CNPJ_COMPLETO)
				FROM		TBL_MESA_SEM_ATUACAO_INSERIR			ai
				LEFT JOIN	TBL_MESA_SEM_ATUACAO					ma 
				ON			ai.CNPJ_COMPLETO						= ma.CNPJ_COMPLETO
				where		ma.CNPJ_COMPLETO is null				
				)	
																	AS qtde_MESA_SEM_ATUACAO,

			(	SELECT 
				COUNT		(ai.CNPJ_COMPLETO)
				FROM		TBL_MELHORES_TAXAS_ITAU_PJ_INSERIR		ai
				LEFT JOIN	TBL_MELHORES_TAXAS_ITAU_PJ				ma 
				ON			ai.CNPJ_COMPLETO						= ma.CNPJ_COMPLETO
				where		ma.CNPJ_COMPLETO is null
				) 
																	AS qtde_MELHORES_TAXAS_ITAU;


		-- =========================================================== inserindo nas tabelas que vão visualizar no zaap
		MERGE 
			TBL_PJ_DICA_FINAL_BASE_GATILHOS AS Destino
		USING 
			TBL_PJ_DICA_FINAL_BASE_GATILHOS_INSERIR AS Origem ON (Origem.CNPJ_COMPLETO = Destino.CNPJ_COMPLETO)
 
		-- Registro existe nas 2 tabelas
		WHEN MATCHED THEN
			UPDATE SET 
				Destino.DICA_CLI_FINAL = Origem.DICA_CLI_FINAL
        
		-- Registro não existe no destino. Vamos inserir.
		WHEN NOT MATCHED THEN
			INSERT
			VALUES(Origem.CNPJ_COMPLETO, Origem.DICA_CLI_FINAL)
		;


		--================================================================================================================================--
		--================================================================================================================================--

		--INSERIR CASOS DE MESAS SEM ATUAÇÃO

		MERGE 
			TBL_MESA_SEM_ATUACAO AS Destino
		USING 
			TBL_MESA_SEM_ATUACAO_INSERIR AS ORIGEM ON (ORIGEM.CNPJ_COMPLETO = DESTINO.CNPJ_COMPLETO)
 
		-- Registro não existe no destino. Vamos inserir.
		WHEN NOT MATCHED THEN
			INSERT
			VALUES(ORIGEM.CNPJ_COMPLETO, ORIGEM.NOME_CLI, ATR_CLI, VLR_CA6_CLI, FILA, ALCADA_MESA)

		-- Registro existe no destino, mas, não existe na origem

		--WHEN NOT MATCHED BY SOURCE THEN
		--    DELETE
		;



		--================================================================================================================================--
		--================================================================================================================================--

		--SELECT TOP 1 * FROM	TBL_MELHORES_TAXAS_ITAU_PJ --TAXA

		--SELECT
		--*
		--FROM	 TBL_MELHORES_TAXAS_ITAU_PJ_INSERIR
		--TAXAS - TEMOS QUE ALIMENTAR A TABELA ORIGEM

		MERGE 
			TBL_MELHORES_TAXAS_ITAU_PJ			AS Destino
		USING 
			TBL_MELHORES_TAXAS_ITAU_PJ_INSERIR	AS Origem 
												ON (Origem.CNPJ_COMPLETO 
												= Destino.CNPJ_COMPLETO)
 
		-- Registro existe nas 2 tabelas
		WHEN MATCHED 
		THEN
				UPDATE SET 
				Destino.TAXA_ANT	=	Origem.TAXA_ANT,
				Destino.TAXA_ATUAL	=	Origem.TAXA_ATUAL
        
		-- Registro não existe no destino. Vamos inserir.
		WHEN NOT MATCHED 
		THEN
			INSERT
			VALUES(Origem.CNPJ_COMPLETO, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ORIGEM.TAXA_ANT, ORIGEM.TAXA_ATUAL,  NULL, NULL)
		;

		--================================================================================================================================--



		SET @MOVE = 'MOVE "' + @DESTINO + '\' + @ARQUIVOESCOLHIDO + '" "' + @CAMINHO_PROCESSADOS + '\' + @ARQUIVOESCOLHIDO + '"';
		--PRINT @COPY 
		EXEC xp_cmdshell @MOVE;	-- Executar o comando usando xp_cmdshell


		-- ================================================================================================================================

		DECLARE @COMPLEMENTO_NOME		VARCHAR(255);
		DECLARE @NOVO_NOME_ARQUIVO		VARCHAR(255);
		DECLARE @Renomear				VARCHAR(500);

		-- Remove os primeiros três caracteres
		SET @ARQUIVOESCOLHIDO = LEFT(@ARQUIVOESCOLHIDO, LEN(@ARQUIVOESCOLHIDO) - 4);

		-- Gera o complemento do nome com segundos e milissegundos
		SET @COMPLEMENTO_NOME = RIGHT('0'	+ CONVERT(VARCHAR(2), DATEPART(SECOND, GETDATE())), 2) + 
								RIGHT('000' + CONVERT(VARCHAR(4), DATEPART(MILLISECOND, GETDATE())), 3);

		-- Monta o novo nome do arquivo com o complemento de nome e a nova extensão
		SET @NOVO_NOME_ARQUIVO = @ARQUIVOESCOLHIDO + '_' + @COMPLEMENTO_NOME + '.csv';

		-- Monta o comando de renomear o arquivo
		SET @Renomear = 'REN "' + @CAMINHO_PROCESSADOS + '\' + @ARQUIVOESCOLHIDO + '.csv" "' + @NOVO_NOME_ARQUIVO + '"';

		-- Imprime o comando de renomear para verificação
		PRINT @Renomear;

		-- Executar o comando usando xp_cmdshell
		EXEC xp_cmdshell @Renomear;

		-- ==========================================================================================================================

			DECLARE @para VARCHAR(1000) = '';
			DECLARE @assunto VARCHAR(1000) = 'BASE GATILHOS - ' + CONVERT(varchar,CAST(GETDATE()AS date));
			DECLARE @mensagem VARCHAR(MAX) = '';

			--SET @para += 'everton.santos@novaquest.com.br>;';
			--SET @para += 'victor.luis@novaquest.com.br;';
			--SET @para += 'marcos.damasceno@novaquest.com.br;';
			--SET @para += 'mariuxa.tiburcio@novaquest.com.br;';
			SET @para += 'joao.reis@novaquest.com.br;';
			--SET @para += 'vinicius@novaquest.com.br;';
			--SET @para += 'micheli@novaquest.com.br';
			--SET @para += 'sistemas@novaquest.com.br';

			SET @mensagem += '<style type="text/css">';
			SET @mensagem += 'table, th, td {border: 1px solid black; border-collapse: collapse; padding: 0 5px 0 5px;}';
			SET @mensagem += 'p {font-size: 12pt;}';
			SET @mensagem += '</style>';
			SET @mensagem += '<style type="text/css">';
			SET @mensagem += 'table, th, td {border: 1px solid black; border-collapse: collapse; padding: 0 5px 0 5px;}';
			SET @mensagem += 'th {background-color: #FF7200;color:white}'; -- Estilo para o cabeçalho
			SET @mensagem += 'p {font-size: 12pt;}';
			SET @mensagem += '</style>';

			SET @mensagem += '<h3 style="text-align: center;">Base gatilhos importada em sistemas</h3>';
			SET @mensagem += '<h4 style="text-align: center;">Quantidades de casos importados</h4>';
			SET @mensagem += '</br>';
			SET @mensagem += '<table align="center" style="text-align: center;" >';
			SET @mensagem += '<tr>';
			SET @mensagem += '<th>DICA_FINAL</th>';
			SET @mensagem += '<th>MESA_SEM_ATUACAO</th>';
			SET @mensagem += '<th>MELHORES_TAXAS_ITAU_PJ</th>';
			SET @mensagem += '</tr>';
			SET @mensagem += (SELECT
								'<tr><td>' +qtde_DICA_FINAL + '</td>' +
								'<td>' +	qtde_MESA_SEM_ATUACAO + '</td>' +
								'<td>' +	qtde_MELHORES_TAXAS_ITAU + '</td></tr>'
							 FROM #temp_qtde_entradas_gatilhos
							 FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)');

			SET @mensagem += '</table>';
			SET @mensagem += '</br>';
			SET @mensagem += '<h5 style="text-align: center;">Nome do job: [ITAU PJ] - BASE GATILHOS INSERIR </h5>';

			EXEC MSDB.DBO.SP_SEND_DBMAIL
				@recipients = @para,
				@subject = @assunto,
				@body = @mensagem,
				@body_format = 'HTML';
 end
	else
	 begin
			
			DECLARE @para1 VARCHAR(1000)		= '';
			DECLARE @assunto1 VARCHAR(1000) = 'BASE GATILHOS - ' + CONVERT(varchar,CAST(GETDATE()AS date));
			DECLARE @mensagem1 VARCHAR(MAX)	= '';

			SET @assunto1 = 'Base gatilhos teste';

			SET @para1 += 'joao.reis@novaquest.com.br;';
			SET @para1 += 'vinicius@novaquest.com.br;';
			SET @para1 += 'micheli@novaquest.com.br';
			SET @para1 += 'sistemas@novaquest.com.br';
			SET @para1 += 'jefferson.pereira@novaquest.com.br';

			SET @mensagem1 += '<style type="text/css">';
			SET @mensagem1 += 'table, th, td {border: 1px solid black; border-collapse: collapse; padding: 0 5px 0 5px;}';
			SET @mensagem1 += 'p {font-size: 12pt;}';
			SET @mensagem1 += '</style>';
			SET @mensagem1 += '<style type="text/css">';
			SET @mensagem1 += 'table, th, td {border: 1px solid black; border-collapse: collapse; padding: 0 5px 0 5px;}';
			SET @mensagem1 += 'th {background-color: #f28500;color:white}'; -- Estilo para o cabeçalho
			SET @mensagem1 += 'p {font-size: 12pt;}';
			SET @mensagem1 += '</style>';

			SET @mensagem1 += '<h3 style="text-align: center;">Base gatilhos ERRO</h3>';
			SET @mensagem1 += '<h4 style="text-align: center;">Arquivo não encontrado</h4>';
			SET @mensagem1 += '</br>';
			SET @mensagem1 += '<table align="center" style="text-align: center;" >';
			SET @mensagem1 += '<tr>';
			SET @mensagem1 += '<th>Arquivo não encontrado</th>';
			--SET @mensagem += '<th>MESA_SEM_ATUACAO</th>';
			--SET @mensagem += '<th>MELHORES_TAXAS_ITAU_PJ</th>';
			--SET @mensagem += '</tr>';
			--SET @mensagem += (SELECT
			--					'<tr><td>' +qtde_DICA_FINAL + '</td>' +
			--					'<td>' +	qtde_MESA_SEM_ATUACAO + '</td>' +
			--					'<td>' +	qtde_MELHORES_TAXAS_ITAU + '</td></tr>'
			--				 FROM #temp_qtde_entradas_gatilhos
			--				 FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)');

			SET @mensagem1 += '</table>';
			SET @mensagem1 += '</br>';
			SET @mensagem1 += '<h5 style="text-align: center;">Nome do job: [ITAU PJ] - BASE GATILHOS INSERIR: </h5>';

			EXEC MSDB.DBO.SP_SEND_DBMAIL
				@recipients = @para1,
				@subject = @assunto1,
				@body = @mensagem1,
				@body_format = 'HTML';
	 end



/*
	
	As tabelas ja tem as index CLUSTERED criadas!!!!!

	create CLUSTERED INDEX IX_CNPJ_COMPLETO on TBL_MESA_SEM_ATUACAO (CNPJ_COMPLETO)

	create CLUSTERED INDEX IX_CNPJ_COMPLETO_DICA_FINAL on TBL_PJ_DICA_FINAL_BASE_GATILHOS(CNPJ_COMPLETO)

	create CLUSTERED INDEX IX_CNPJ_COMPLETO_MELHORES_TAXAS on TBL_MELHORES_TAXAS_ITAU_PJ(CNPJ_COMPLETO)

*/