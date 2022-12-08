
CREATE view _vw_status
as

	select 
		[Timestamp],
		[ShiftDay],
		[Shift],
		[ProductionLine],
		[Project],
		[StationID],
		[Status],
		[PLCStatus]+' '+[PLCStatusDesc] [StatusDesc]
	from _tb_staging_traceability

GO

