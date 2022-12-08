
CREATE procedure [dbo].[_sp_translate_by_station_history]
	@verbose bit = 0,
	@top int = 1000
as
begin

	if @verbose = 1
	print 'translation by station history...'

	/*
	create table #per_station_hist (
		[id] int,
		[timestamp] datetime2,
		[stationid] varchar(100),
		[model] varchar(100)
		)
	*/

	declare @per_station_hist table(
		[id] int,
		[timestamp] datetime2,
		[stationid] varchar(100),
		[model] varchar(100)
		)

	--insert into #per_station_hist
	insert into @per_station_hist
	select --top (@top) 
		[ID],[Timestamp],[StationID],[Model]
	from _tb_staging_traceability
	where [Project] = 'not defined'
	and [TranslationTrysCount] < 100


	--while exists(select 1 from #per_station_hist)
	while exists(select 1 from @per_station_hist)
	begin

		/*
		declare @tb_scan table ([id] int, [timestamp] datetime2,[project] varchar(100));
		*/

		declare @stationId varchar(100) = NULL;
		declare @model varchar(100) = NULL;
		declare @ts datetime2 = NULL;
		declare @ids int = NULL;
		
		select top 1
			@ids = [id],
			@ts = [timestamp],
			@stationId = [stationid],
			@model = [model]
		--from #per_station_hist
		from @per_station_hist
		order by [timestamp] asc

		declare @nextProject varchar(100) = 'not defined'
		declare @previousProject varchar(100) = 'not defined'

		select @nextProject = [next_project],
			   @previousProject = [previous_project]
		from(
			select [id],[Timestamp], [Project], lead(project,1,0) over(order by [timestamp] asc) [next_project], lag(project,1,0) over(order by [timestamp] asc) [previous_project]
			from _tb_staging_traceability
			where [StationID] = @stationId
			--and [Model] = @model
			and [Timestamp] between dateadd(minute,-30, @ts) and dateadd(minute,30, @ts)
		) as [a]
		where [a].[Timestamp] = @ts


		if (@nextProject <> 'not defined') and (@nextProject <> '0')
		begin
			update _tb_staging_traceability
			set [Project] = @nextProject, 
				[TranslationType] = 'StationHistoryNext',
				[TranslationTrysCount] = [TranslationTrysCount] + 1
			where [ID] = @ids
		end
		else if (@previousProject <> 'not defined') and (@previousProject <> '0')
		begin
			update _tb_staging_traceability
			set [Project] = @previousProject, 
				[TranslationType] = 'StationHistoryPrevious',
				[TranslationTrysCount] = [TranslationTrysCount] + 1
			where [ID] = @ids
		end

		/*
		insert into @tb_scan
		select [id],[Timestamp], [Project]
		from _tb_staging_traceability
		where [StationID] = @stationId
		and [Model] = @model
		and [Timestamp] between @ts and dateadd(minute,30, @ts)
		order by [Timestamp] asc

		declare @nextProject varchar(100) = 'not defined'

		select top 1 @nextProject = lead(project,1,0) over(order by [timestamp] asc)
		from @tb_scan

		if (@nextProject <> 'not defined') and (@nextProject <> '0')
		begin
			update _tb_staging_traceability
			set [Project] = @nextProject, 
				[TranslationType] = 'StationHistoryNext',
				[TranslationTrysCount] = [TranslationTrysCount] + 1
			where [ID] = @ids
		end
		else
		begin

			delete from @tb_scan

			insert into @tb_scan
			select [id],[Timestamp], [Project]
			from _tb_staging_traceability
			where [StationID] = @stationId
			and [Model] = @model
			and [Timestamp] between dateadd(minute,-30, @ts) and @ts
			order by [Timestamp] asc

			declare @previousProject varchar(100) = 'not defined'

			select top 1 @previousProject = lead(project,1,0) over(order by [timestamp] desc)
			from @tb_scan

			if (@previousProject <> 'not defined') and (@previousProject <> '0')
			begin
				update _tb_staging_traceability
				set [Project] = @previousProject, 
					[TranslationType] = 'StationHistoryPrevious',
					[TranslationTrysCount] = [TranslationTrysCount] + 1
				where [ID] = @ids
			end
			else
			begin
				update _tb_staging_traceability
				set [TranslationTrysCount] = [TranslationTrysCount] + 1
				where [ID] = @ids
			end
		end

		delete from @tb_scan
		*/
		--delete from #per_station_hist where [id] = @ids
		delete from @per_station_hist where [id] = @ids
	end

--drop table #per_station_hist

end

GO

