CREATE TABLE [dbo].[_tb_staging_traceability] (
    [id]                   INT           IDENTITY (1, 1) NOT NULL,
    [inserted_ts]          DATETIME2 (7) DEFAULT (getdate()) NULL,
    [ProductionLine]       VARCHAR (100) NOT NULL,
    [Project]              VARCHAR (100) NULL,
    [NextraceID]           INT           NOT NULL,
    [Timestamp]            DATETIME2 (7) NOT NULL,
    [StationID]            VARCHAR (100) NOT NULL,
    [Serial]               VARCHAR (150) NOT NULL,
    [Model]                VARCHAR (255) NOT NULL,
    [Status]               TINYINT       NULL,
    [PLCStatus]            VARCHAR (20)  NOT NULL,
    [PLCStatusDesc]        VARCHAR (255) NULL,
    [OperationGroupID]     SMALLINT      NOT NULL,
    [OperationGroupName]   VARCHAR (255) NOT NULL,
    [TranslationType]      VARCHAR (100) NULL,
    [TranslationTrysCount] INT           DEFAULT ((0)) NOT NULL,
    [gen_asm_id]           INT           NULL,
    CONSTRAINT [_pk_tb_staging_traceability_id] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

CREATE NONCLUSTERED INDEX [_idx_stagin_trac_project_serial]
    ON [dbo].[_tb_staging_traceability]([Project] ASC, [Serial] ASC);


GO

CREATE NONCLUSTERED INDEX [_idx_stagin_trace_proj_include]
    ON [dbo].[_tb_staging_traceability]([Project] ASC)
    INCLUDE([Timestamp], [Serial]);


GO

CREATE NONCLUSTERED INDEX [_idx_stagin_trac_stationid_model]
    ON [dbo].[_tb_staging_traceability]([StationID] ASC, [Model] ASC);


GO

CREATE NONCLUSTERED INDEX [_vw_staging_traceability_stationID_model_ts_group]
    ON [dbo].[_tb_staging_traceability]([StationID] ASC, [Model] ASC, [Timestamp] ASC)
    INCLUDE([id], [Project]);


GO

CREATE NONCLUSTERED INDEX [_idx_tb_staging_traceability_TransType]
    ON [dbo].[_tb_staging_traceability]([TranslationType] ASC, [Project] ASC, [Serial] ASC);


GO

CREATE NONCLUSTERED INDEX [_idx_stagin_trac_project_serial_ts]
    ON [dbo].[_tb_staging_traceability]([Project] ASC, [Serial] ASC, [Timestamp] DESC);


GO

CREATE NONCLUSTERED INDEX [_idx_stagin_trac_project]
    ON [dbo].[_tb_staging_traceability]([Project] ASC)
    INCLUDE([id], [Timestamp], [StationID], [Model]);


GO

