


<<<<<<< HEAD
temp_base_gatilhos


truncate table temp_base_gatilhos

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
from '\\192.168.0.48\ti$\Analistas\João\RPA_BASE_GATILHOS\lista.csv'
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
























			
	create table	TBL_MELHORES_TAXAS_ITAU_PJ_INSERIR_TEMP(
		CNPJ_COMPLETO	VARCHAR(255),
		NOME_CLI	VARCHAR(255),
		taxa_ant	VARCHAR(255),
		taxa_atual	VARCHAR(255)
	)


	create table TBL_MESA_SEM_ATUACAO_INSERIR_TEMP(
	CNPJ_COMPLETO	VARCHAR(255),
	NOME_CLI		VARCHAR(255),
	ATR_CLI			VARCHAR(255),
	VLR_CA6_CLI		VARCHAR(255),	
	FILA			VARCHAR(255),
	Alcada_Mesa		VARCHAR(255)

	)
=======
>>>>>>> fdcb5834883646e46c24cb117c7dedb1dc039786
