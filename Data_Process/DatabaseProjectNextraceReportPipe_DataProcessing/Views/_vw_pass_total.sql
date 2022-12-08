





CREATE view [dbo].[_vw_pass_total]
as

select 
	substring(convert(varchar,[Timestamp],120),1,10)+' 00:00:00' [Timestamp],
	[ProductionLine],
	[Project],
	[OperationGroupID],
	[OperationGroupName],
	[StationID], 
	count(*) [total], 
	sum([Status]) [pass],
	[Shift],
	[ShiftDay]
from 
	_vw_filtered_staging_traceability with(nolock)
where 
	[Project] <> 'not defined'
group by 
	substring(convert(varchar,[Timestamp],120),1,10), 
	[ProductionLine],
	[Project],
	[OperationGroupID],
	[OperationGroupName],
	[StationID],
	[Shift],
	[ShiftDay]
/*
order by 
	[Timestamp] desc, 
	[ProductionLine],
	[Project],
	[OperationGroupID],
	[OperationGroupName],
	[StationID]
*/

GO

