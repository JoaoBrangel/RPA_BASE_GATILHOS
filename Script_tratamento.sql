

DECLARE @DIRETORIO			VARCHAR(200)
DECLARE @COMANDO			VARCHAR(200)
DECLARE @ARQUIVOESCOLHIDO	VARCHAR(200)
DECLARE	@DIA				VARCHAR(20)		=	DAY(GETDATE())
DECLARE	@ANO				VARCHAR(20)		=	YEAR(GETDATE())
DECLARE	@MES				VARCHAR(20)		
DECLARE @PASTA_DIA_MES		VARCHAR(200)	=	(select replace(convert(varchar(5), getdate(), 103), '/', '_'))
DECLARE @COPY				VARCHAR(200)
DECLARE @DESTINO			VARCHAR(200	)	=	'\\192.168.0.48\ti$\Analistas\João\RPA_BASE_GATILHOS\PROCESSADOS' -- lev
--		PRINT @PASTA_DIA_MES

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
 print @ARQUIVOESCOLHIDO
-- ============================================================================================================


-- Comando para copiar o arquivo usando o comando COPY do Windows
SET @COPY = 'COPY ' + @DIRETORIO + '\'+ @ARQUIVOESCOLHIDO + '"  "' + @DESTINO +'"';

PRINT @COPY 
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
    Alcada_Mesa VARCHAR(255)
);


bulk insert #temp_base_gatilho
from '\\192.168.0.48\ti$\Analistas\João\RPA_BASE_GATILHOS\lista.csv'  -- ====================== trocar dps ===============================================
with(
	FIELDTERMINATOR = ';', -- Delimitador de campo (vírgula no caso de um arquivo CSV)
    ROWTERMINATOR = '0x0a', -- Delimitador de linha (nova linha)
    FIRSTROW = 2 
);
-- select * from #temp_base_gatilho

-- =======================================================================================

		truncate table TBL_PJ_DICA_FINAL_BASE_GATILHOS_INSERIR_TEMP; -- TRUNCANDO
		print 'TBL_PJ_DICA_FINAL_BASE_GATILHOS_INSERIR_TEMP Truncada'
		PRINT ' '
		PRINT '-------------------------------------------------------------------------------------'

		insert INTO TBL_PJ_DICA_FINAL_BASE_GATILHOS_INSERIR_TEMP
		SELECT 
		RIGHT(CNPJ_COMPLETO, 15)		AS	CNPJ_COMPLETO,
		''								AS	CONTRATO_TIT,
										DICA_CLI_FINAL
		FROM	#temp_base_gatilho
		where	CNPJ_COMPLETO			is not null
		and     DICA_CLI_FINAL			is not null

-- ======================================================================================

		truncate table TBL_MELHORES_TAXAS_ITAU_PJ_INSERIR_TEMP; -- TRUNCANDO
		print 'TBL_MELHORES_TAXAS_ITAU_PJ_INSERIR Truncada'
		PRINT ' '
		PRINT '-------------------------------------------------------------------------------------'


		insert INTO TBL_MELHORES_TAXAS_ITAU_PJ_INSERIR_TEMP
		SELECT 
		RIGHT(CNPJ_COMPLETO, 15)		AS	CNPJ_COMPLETO,
		NOME_CLI						AS	NOME_CLI,
		TAXA_CLI_ANT					AS	taxa_ant,
		TAXA_CLI_ATUAL					AS	taxa_atual
		FROM	#temp_base_gatilho
		where	CNPJ_COMPLETO			IS NOT NULL
		and     TAXA_CLI_ANT			IS NOT NULL
		AND		TAXA_CLI_ATUAL			IS NOT NULL


-- =======================================================================

truncate table TBL_MESA_SEM_ATUACAO_INSERIR_TEMP; -- TRUNCANDO
		print 'TBL_MESA_SEM_ATUACAO_INSERIR_TEMP Truncada'
		PRINT ' '
		PRINT '-------------------------------------------------------------------------------------'

		insert INTO TBL_MESA_SEM_ATUACAO_INSERIR_TEMP
		SELECT 
		RIGHT(CNPJ_COMPLETO, 15)		AS	CNPJ_COMPLETO,
		NOME_CLI						AS	NOME_CLI,
		''								AS	ATR_CLI,
		''								AS	VLR_CA6_CLI,
		''								AS	FILA,
		Alcada_Mesa						AS	Alcada_Mesa
		FROM	ESPELHO_GATILHO_TEMP3
		where	CNPJ_COMPLETO			IS NOT NULL
		AND     NOME_CLI				IS NOT NULL
		AND		Alcada_Mesa				IS NOT NULL

		select  top 10 * from TBL_PJ_DICA_FINAL_BASE_GATILHOS_INSERIR_TEMP
		select  top 10 * from TBL_MELHORES_TAXAS_ITAU_PJ_INSERIR_TEMP
		select  top 10 * from TBL_MESA_SEM_ATUACAO_INSERIR_TEMP
























			
	--create table	TBL_MELHORES_TAXAS_ITAU_PJ_INSERIR_TEMP(
	--	CNPJ_COMPLETO	VARCHAR(255),
	--	NOME_CLI	VARCHAR(255),
	--	taxa_ant	VARCHAR(255),
	--	taxa_atual	VARCHAR(255)
	--)


	--create table TBL_MESA_SEM_ATUACAO_INSERIR_TEMP(
	--CNPJ_COMPLETO	VARCHAR(255),
	--NOME_CLI		VARCHAR(255),
	--ATR_CLI			VARCHAR(255),
	--VLR_CA6_CLI		VARCHAR(255),	
	--FILA			VARCHAR(255),
	--Alcada_Mesa		VARCHAR(255)

	--)