/****** Script for SelectTopNRows command from SSMS  ******/

create procedure _sp_define_shift
	@top int = 10000
as
begin
set nocount on;

create table #shifttable (
	[id] int,
	[ShiftName] varchar(100),
	[ShiftDay] date
)

insert into #shifttable ([id],[ShiftName], [ShiftDay])
SELECT
	top (@top)
	[t].[id],
	[s].[ShiftName],
	case [s].[PreviousDayAnchored]
		when 1 then convert(date,dateadd(day,-1, [t].[Timestamp]))
		when 0 then convert(date,[t].[Timestamp])
	end [ShiftDay]
FROM 
	[NextraceReportPipe].[dbo].[_tb_staging_traceability] [t]
join 
	[NextraceReportPipe].[dbo].[_tb_dict_shift_per_production_line] [s]
	on 
		[t].[ProductionLine] = [s].ProducionLine
		and convert(time, [t].[Timestamp]) between [s].[Begin] and [s].[End]
where [t].[Shift] is null
--and [t].[Timestamp] > '20220817'

select *
from #shifttable

while exists(select 1 from #shifttable)
begin
	declare @id int;
	declare @shift varchar(100);
	declare @shiftday date;

	select top 1
		@id = [id],
		@shift = [ShiftName],
		@shiftday = [ShiftDay]
	from #shifttable

	update _tb_staging_traceability
	set [Shift] = @shift, [ShiftDay] = @shiftday
	where [id] = @id

	delete from #shifttable where [id] = @id;
end

drop table #shifttable
end

GO

