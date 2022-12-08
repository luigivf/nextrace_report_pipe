




CREATE view [dbo].[_vw_ceps_traceability]
as
	select 
		'CEPS' [ProductionLine],
		[t].[ID] [NextraceID],
		[t].[Timestamp],
		[t].[StationID],
		[t].[Serial],
		[t].[Model],
		[t].[Status],
		[t].[PLC_Status] [PLCStatus],
		[t].[FTQ_Desc] [PLCStatusDesc],
		[o].id_GROUP [OperationGroupID],
		[g].[Description] [OperationGroupName]
	from [MFGCLUSTER\SQLTRACE].[FIASA_Nextrace].[dbo]._TRACEABILITY [t] with(nolock)
	join [MFGCLUSTER\SQLTRACE].[FIASA_Nextrace].[dbo].TA_LINE_OPERATION [o] with(nolock)
		on [o].StationID = [t].[StationID]
	join [MFGCLUSTER\SQLTRACE].[FIASA_Nextrace].[dbo].TA_LINE_GROUP [g] with(nolock)
		on [g].id = [o].id_GROUP
	where [o].Deleted = 0
		and [Serial] not like 'Empty serial%'
		and [t].[Model] not like 'PECA BOA%'

GO

