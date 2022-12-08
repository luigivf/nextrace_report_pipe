CREATE procedure [dbo].[_sp_translate_by_serial_history]
--declare	
	@verbose bit = 0,
	@top int = 10000
as
begin

	if @verbose = 1
	print 'translation by Serial Number...'

	declare @count int = 0;

	select @count = count(*)
	from _tb_staging_traceability
	where [Project] = 'not defined'

	create table #serial_projec ([id] int identity(1,1),[serial] varchar(100), [project] varchar(100))

	if @count > 0 
	begin

		-- 2.2 descoberta por troca de PN
		insert into #serial_projec
		select distinct [Serial], [Project]
		from _tb_staging_traceability
		where [Project] <> 'not defined'
		and [Serial] in (
			select --top (@top)
				distinct [Serial]
			from _tb_staging_traceability
			where [Project] = 'not defined'
			and [TranslationTrysCount] < 100
			--group by [Serial]
			--order by min([Timestamp]) asc
		)

		declare @serial varchar(100) = NULL;
		declare @project varchar(100) = 'not defined';
		declare @id int = 1;
		declare @lastId int;

		select top 1 @lastId = [id]
		from #serial_projec
		order by [id] desc
	
		while @id <= @lastId
		begin

			select 
				@serial = [Serial]
				,@project = [project]
			from #serial_projec
			where [id] = @id

			if @project <> 'not defined'
			begin
				update _tb_staging_traceability
				set [Project] = @project,
					[TranslationType] = 'SerialHistory',
					[TranslationTrysCount] = [TranslationTrysCount] + 1
				where [Serial] = @serial
				and [Project] = 'not defined'
			end

			set @id = @id + 1

			set @project = 'not defined';
			set @serial = NULL;
		end

	end

	drop table #serial_projec
end

GO

