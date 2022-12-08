
CREATE procedure [dbo].[_sp_get_data_from_nextrace]
	@ProductionLine varchar(100) = 'CEPS',
	@top int = 10000
as
begin
	declare @nId int = 0;

	select @nId = [ic].LastNextraceId
	from _tb_integration_control [ic]
	where [ic].ProductionLine = @ProductionLine

	/*---- Getting data from specific Nextrace Database ----*/
	if @ProductionLine = 'CEPS'
	begin
		truncate table _tb_staging_traceability

		insert into _tb_staging_traceability (
					[ProductionLine],
					[Project],
					[NextraceID],
					[Timestamp],
					[StationID],
					[Serial],
					[Model],
					[Status],
					[PLCStatus],
					[PLCStatusDesc],
					[OperationGroupID],
					[OperationGroupName],
					[gen_asm_id]
		)
		select top (@top) 
				[ProductionLine],
				'not defined',
				[NextraceID],
				[Timestamp],
				[StationID],
				[Serial],
				[Model],
				[Status],
				[PLCStatus],
				[PLCStatusDesc],
				[OperationGroupID],
				[OperationGroupName],
				[gen_asm_id]
		from _vw_ceps_traceability
		where [NextraceID] > @nId
		order by [Timestamp] asc
	end


	/*---- inserting data into final repository ----*/
	if exists(select top 1 * from _tb_staging_traceability)
	begin
		declare @lastId int;

		select top 1
			@lastId = [NextraceID]
		from _tb_staging_traceability
		order by [Timestamp] desc

		insert into [BRRSPOR-DB03].[NextraceReportPipe].[dbo]._tb_staging_traceability (
					[ProductionLine],
					[Project],
					[NextraceID],
					[Timestamp],
					[StationID],
					[Serial],
					[Model],
					[Status],
					[PLCStatus],
					[PLCStatusDesc],
					[OperationGroupID],
					[OperationGroupName],
					[gen_asm_id]
		)
		select 
			[ProductionLine],
			[Project],
			[NextraceID],
			[Timestamp],
			[StationID],
			[Serial],
			[Model],
			[Status],
			[PLCStatus],
			[PLCStatusDesc],
			[OperationGroupID],
			[OperationGroupName],
			[gen_asm_id]
		from _tb_staging_traceability

		update _tb_integration_control
		set [LastNextraceId] = @lastId
		where [ProductionLine] = @ProductionLine

		truncate table _tb_staging_traceability
		
	end

end

GO

