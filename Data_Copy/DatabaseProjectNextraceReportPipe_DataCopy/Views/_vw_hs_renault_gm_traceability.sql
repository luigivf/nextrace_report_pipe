CREATE VIEW [dbo].[_vw_hs_renault_gm_traceability]
  select 
		'HS_RENAULT_GM' [ProductionLine],
		[t].[ID] [NextraceID],
		[t].[Timestamp],
		[t].[StationID],
		[t].[Serial],
		[t].[Model],
		[t].[Status],
		[t].[PLC_Status] [PLCStatus],
		[t].[FTQ_Desc] [PLCStatusDesc],
		[o].id_GROUP [OperationGroupID],
		[g].[Description] [OperationGroupName],
		max([asm].Assembly_ID) [gen_asm_id]
	from [HS_RENAULT_GM_Nextrace].[dbo]._TRACEABILITY [t] with(nolock)
	join [HS_RENAULT_GM_Nextrace].[dbo].TA_LINE_OPERATION [o] with(nolock)
		on [o].StationID = [t].[StationID]
	join [HS_RENAULT_GM_Nextrace].[dbo].TA_LINE_GROUP [g] with(nolock)
		on [g].id = [o].id_GROUP
	join [HS_RENAULT_GM_Nextrace].[dbo].[_ASSEMBLY_TABLE] [asm] with(nolock)
		on [t].[Serial] = [asm].Assembly_Data
	where [o].Deleted = 0
		and [Serial] not like 'Empty serial%'
		and [t].[Model] not like 'PECA BOA%'
	group by 
			[t].[ID],
			[t].[Timestamp],
			[t].[StationID],
			[t].[Serial],
			[t].[Model],
			[t].[Status],
			[t].[PLC_Status],
			[t].[FTQ_Desc],
			[o].id_GROUP,
			[g].[Description]
