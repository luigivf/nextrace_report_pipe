
--drop procedure [dbo].[_sp_project_direct_translation]
CREATE procedure [dbo].[_sp_translate_by_direct_match]
--declare	
	@verbose bit = 0,
	@top int = 10000
as
begin

	if @verbose = 1
	print 'direct translation...'

	create table #ids_proj(
		[id] int,
		[project] varchar(100)
	)

	create table #proj(
		[project] varchar(100)
	)

	insert into #ids_proj
	select [t].id, [p].Project
	from _tb_staging_traceability [t]
	join _tb_dict_partnumber_to_project [p]
		on [t].Model = [p].Partnumber
	where [t].Project = 'not defined'
	and [TranslationTrysCount] = 0

	insert into #proj
	select distinct [project]
	from #ids_proj

	declare @proj varchar(100) = 'not defined';

	while exists(select 1 from #proj)
	begin
		select top 1
			@proj = [project]
		from 
			#proj

		update _tb_staging_traceability
		set [Project] = @proj,
				[TranslationType] = 'DirectTranslation',
				[TranslationTrysCount] = [TranslationTrysCount] + 1
		where [ID] in (select [id] from #ids_proj where [project] = @proj)

		delete from 
			#proj 
		where 
			[project] = @proj

		set @proj = 'not defined'
	end

	drop table #ids_proj
	drop table #proj
end

GO

