
create view _vw_filtered_staging_traceability
as
	select 
		[Timestamp],
		[Serial],
		[ProductionLine],
		[Project],
		[OperationGroupID],
		[OperationGroupName],
		[StationID], 
		[Status],
		[Shift],
		[ShiftDay]
	from 
		_tb_staging_traceability with(nolock)
	where 
		[Project] <> 'not defined'
	group by 
		[Timestamp],
		[Serial],
		[ProductionLine],
		[Project],
		[OperationGroupID],
		[OperationGroupName],
		[StationID], 
		[Status],
		[Shift],
		[ShiftDay]

GO

