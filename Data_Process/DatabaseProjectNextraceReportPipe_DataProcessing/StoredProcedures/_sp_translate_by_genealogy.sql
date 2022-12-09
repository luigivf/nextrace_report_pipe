CREATE procedure [dbo].[_sp_translate_by_genealogy]
--declare	
	@verbose bit = 0,
	@top int = 10000
as
begin

	if @verbose = 1
	print 'translation by Genealogy Assembly ID...'

	declare @count int = 0;

	select 
		@count = count(*)
	from 
		_tb_staging_traceability
	where 
		[Project] = 'not defined'

	create table #gen_asm_projec (
			[id] int identity(1,1)
			,[gen_asm] int
			,[project] varchar(100)
			,[productionLine] varchar(100)
		)

	if @count > 0 
	begin

		-- 2.2 descoberta por troca de PN
		insert into 
			#gen_asm_projec
		select distinct 
			 [gen_asm_id]
			,[Project]
			,[ProductionLine]
		from 
			_tb_staging_traceability
		where 
				[Project] <> 'not defined'
			and [gen_asm_id] in (
					select 
						distinct [gen_asm_id]
					from 
						_tb_staging_traceability
					where 
							[Project] = 'not defined'
						and [TranslationTrysCount] < 100
				)

		declare @gen_asm int = NULL;
		declare @project varchar(100) = 'not defined';
		declare @productionLine varchar(100) = NULL;
		declare @id int = 1;
		declare @lastId int;

		select top 1 
			@lastId = [id]
		from 
			#gen_asm_projec
		order by 
			[id] desc
	
		while @id <= @lastId
		begin

			select 
				 @gen_asm = [gen_asm]
				,@project = [project]
				,@productionLine = [ProductionLine]
			from #gen_asm_projec
			where [id] = @id

			if @project <> 'not defined'
			begin
				update _tb_staging_traceability
				set [Project] = @project,
					[TranslationType] = 'SerialHistory',
					[TranslationTrysCount] = [TranslationTrysCount] + 1
				where 
						[gen_asm_id] = @gen_asm
					and [Project] = 'not defined'
					and [ProductionLine] = @productionLine
			end

			set @id = @id + 1

			set @project = 'not defined';
			set @gen_asm = NULL;
			set @productionLine = NULL;
		end

	end

	drop table #gen_asm_projec
end

GO

