




create view [dbo].[_vw_pass_total_last_station]
as

select 
	substring(convert(varchar,[Timestamp],120),1,15)+'0:00' [Timestamp],
	[ProductionLine],
	[Project],
	[OperationGroupID],
	[OperationGroupName],
	[StationID], 
	count(*) [total], 
	sum([Status]) [pass]
from 
	_tb_staging_traceability with(nolock)
where 
	[Project] <> 'not defined'
	and [StationID] in ('SD000084X01')
group by 
	substring(convert(varchar,[Timestamp],120),1,15), 
	[ProductionLine],
	[Project],
	[OperationGroupID],
	[OperationGroupName],
	[StationID]

GO

