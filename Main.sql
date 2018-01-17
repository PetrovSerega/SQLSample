
-- Создание тестовой таблицы
--CREATE TABLE [Test].[dbo].[Person](
--	[ID] int IDENTITY(1,1) NOT NULL
--	-- Фамилия, имя, отчество сотрудника
--	, [FIO] nvarchar(50) NOT NULL
--	-- Учёная степень (0 - нет, 1 - к.н., 2 - д.н.)
--	, [AcademicDegree] int NOT NULL
--	-- Учёная степень (0 - нет, 1 - доц., 2 - проф.)
--	, [AcademicRank] int NOT NULL
--	-- Должность (1 - ассистент, 2 - старший преподаватель, 3 - доцент, 4 - профессор, 5 - зав. кафедрой)
--	, [Position] int NOT NULL
--	-- Ставка
--	, [Rate] decimal(2,1) NOT NULL
--)

SET NOCOUNT ON

delete from [Test].[dbo].[Person]
-- Размер тестовой выборки
declare @personCount int = 1500

declare @counter int = 0
declare @newAcademicDegree int = 0
declare @newAcademicRank int = 0
declare @newRate decimal(2,1) = 0
declare @newPosition int = 0

declare @randomPosition int = 0
declare @randomAcademicDegree int = 0
declare @randomAcademicRank int = 0

declare @academicDegreeKN int = 0
declare @academicDegreeDN int = 0

declare @academicRankDoc int = 0
declare @academicRankProf int = 0

while @counter <= @personCount
begin
	set @counter = @counter + 1

	-- Вычисление ставки
	set @newRate = cast(cast(RAND() * 10 + 1 as int) as decimal(10,2)) / 10
	
	SET @randomPosition = (RAND() * 100) + 1
	
	--[1,3] - Зав.каф.
	--[4,24] - Профессор
	--[25,68] - Доцент
	--[69,88] - Старший преподаватель
	--[89,100] - Ассистент
	if(@randomPosition <= 3)
	begin
		set @newPosition = 5
		set @academicDegreeDN = 50
		set @academicDegreeKN = 43
		set @academicRankProf = 41
		set @academicRankDoc = 37
	end
	else if(@randomPosition <= 24)
	begin
		set @newPosition = 4
		set @academicDegreeDN = 78
		set @academicDegreeKN = 21
		set @academicRankProf = 61
		set @academicRankDoc = 24
	end
	else if(@randomPosition <= 68)
	begin
		set @newPosition = 3
		set @academicDegreeDN = 1
		set @academicDegreeKN = 91
		set @academicRankProf = 0
		set @academicRankDoc = 49
	end
	else if(@randomPosition <= 88)
	begin
		set @newPosition = 2
		set @academicDegreeDN = 0
		set @academicDegreeKN = 22
		set @academicRankProf = 0
		set @academicRankDoc = 1
	end
	else -- if(@positionRand <= 100)
	begin
		set @newPosition = 1
		set @academicDegreeDN = 0
		set @academicDegreeKN = 10
		set @academicRankProf = 0
		set @academicRankDoc = 0
	end

	set @randomAcademicDegree = (RAND() * 100) + 1
	set @newAcademicDegree = 0
	if(@randomAcademicDegree <= @academicDegreeDN)
	begin
		set @newAcademicDegree = 2
	end
	else if(@randomAcademicDegree <= @academicDegreeDN + @academicDegreeKN)
	begin
		set @newAcademicDegree = 1
	end

	SET @randomAcademicRank = (RAND() * 100) + 1
	set @newAcademicRank = 0
	if(@randomAcademicRank <= @academicRankProf)
	begin
		set @newAcademicRank = 2
	end
	else if(@randomAcademicRank <= @academicRankProf + @academicRankDoc)
	begin
		set @newAcademicRank = 1
	end

	insert into [Test].[dbo].[Person] ([FIO], [AcademicDegree], [AcademicRank], [Rate],[Position])
	values ('Фамилия Имя Отчество № ' + cast(@counter as nvarchar(10))
			, @newAcademicDegree
			, @newAcademicRank
			, @newRate
			, @newPosition)
end

print 'table count: ' + cast(@personCount as nvarchar(10))

declare @start datetime
set @start = getdate()

select case p.Position
			when '5' then 'Зав. каф.'
			when '4' then 'Профессор'
			when '3' then 'Доцент'
			when '2' then 'Стар. преп.'
			when '1' then 'Ассистент'
		end as 'Должность'
	   , count(*) as 'Всего'
	   --, cast(cast(count(*) as decimal(10,2)) / @counter * 100 as decimal(10,2)) as 'Процент от общего кол-ва'
	   , sum (case when p.AcademicDegree = 1 then 1 else 0 end) as 'к.н.'
	   , sum (case when p.AcademicDegree = 2 then 1 else 0 end) as 'д.н.'
	   , sum (case when p.AcademicRank = 1 then 1 else 0 end) as 'доц.'
	   , sum (case when p.AcademicRank = 2 then 1 else 0 end) as 'проф.'
	   , sum (case when p.Rate >= 0.1 and p.Rate < 0.2 then 1 else 0 end) as '0.1'
	   , sum (case when p.Rate >= 0.2 and p.Rate < 0.3 then 1 else 0 end) as '0.2'
	   , sum (case when p.Rate >= 0.3 and p.Rate < 0.4 then 1 else 0 end) as '0.3'
	   , sum (case when p.Rate >= 0.4 and p.Rate < 0.5 then 1 else 0 end) as '0.4'
	   , sum (case when p.Rate >= 0.5 and p.Rate < 0.6 then 1 else 0 end) as '0.5'
	   , sum (case when p.Rate >= 0.6 and p.Rate < 0.7 then 1 else 0 end) as '0.6'
	   , sum (case when p.Rate >= 0.7 and p.Rate < 0.8 then 1 else 0 end) as '0.7'
	   , sum (case when p.Rate >= 0.8 and p.Rate < 0.9 then 1 else 0 end) as '0.8'
	   , sum (case when p.Rate >= 0.9 and p.Rate < 1   then 1 else 0 end) as '0.9'
	   , sum (case when p.Rate = 1 then 1 else 0 end) as '1.0'
from [Test].[dbo].[Person] p
group by p.Position
order by p.Position desc

print 'group by, ms: ' + cast(datediff(ms,@start,getdate()) as nvarchar(10))

-- Вариант с детализацией
set @start = getdate()

declare @logRowName nvarchar(20) = '1'
declare @logColName nvarchar(20) = '3'
--declare @logRowName nvarchar(20) = null
--declare @logColName nvarchar(20) = null


declare @logMode bit = 0
if(@logRowName is not null or @logColName is not null)
begin
	set @logMode = 1

	declare @log TABLE 
	(
		FIO nvarchar(50)
	)

end
else
begin
	
	declare @res TABLE 
	(
		c1 nvarchar(5)
		, c2 nvarchar(50)
		, c3 int default 0
	
		, c4 int default 0
		, c5 int default 0
	
		, c6 int default 0
		, c7 int default 0
	
		, c8 int default 0
		, c9 int default 0
		, c10 int default 0
		, c11 int default 0
		, c12 int default 0
		, c13 int default 0
		, c14 int default 0
		, c15 int default 0
		, c16 int default 0
		, c17 int default 0
	)

	insert into @res (c1, c2)
	values ('1', 'Ассистент'), ('2', 'Стар. преп.'), ('3', 'Доцент'), ('4', 'Профессор'), ('5', 'Зав. каф.')
end

declare @fio nvarchar(50)
declare @position int
declare @academicDegree int
declare @academicRank int
declare @rate decimal(2,1)

declare personCursor cursor local fast_forward for
select 
	p.Position
	, p.AcademicDegree
	, p.AcademicRank
	, p.Rate
	, p.FIO
from [Test].[dbo].[Person] p

OPEN personCursor

FETCH NEXT FROM personCursor INTO @position, @academicDegree, @academicRank, @rate, @fio
	
declare @targetRowCodes nvarchar(100)
declare @targetColCodes nvarchar(100)

WHILE @@FETCH_STATUS = 0
BEGIN

	-- Переменная для записи строк, к которым относится текущая запись
	set @targetRowCodes = ''
	-- Добавление строки с должностью
	set @targetRowCodes = @targetRowCodes + cast(@position as nvarchar(10))

	-- Переменная для записи столбцов, к которым относится текущая запись
	set @targetColCodes = ''
	-- Добавление столбца всего
	set @targetColCodes = @targetColCodes + ';3;'

	-- Добавление столбца с соответствующей учёной степенью
	if (@academicDegree = 1)
		set @targetColCodes = @targetColCodes + ';4;'
	else if (@academicDegree = 2)
		set @targetColCodes = @targetColCodes + ';5;'

	if(@academicRank = 1)
		set @targetColCodes = @targetColCodes + ';6;'
	else if (@academicRank = 2)
		set @targetColCodes = @targetColCodes + ';7;'

	if (@rate = 1)
		set @targetColCodes = @targetColCodes + ';17;'
	else if (@rate >= 0.9)
		set @targetColCodes = @targetColCodes + ';16;'
	else if (@rate >= 0.8)
		set @targetColCodes = @targetColCodes + ';15;'
	else if (@rate >= 0.7)
		set @targetColCodes = @targetColCodes + ';14;'
	else if (@rate >= 0.6)
		set @targetColCodes = @targetColCodes + ';13;'
	else if (@rate >= 0.5)
		set @targetColCodes = @targetColCodes + ';12;'
	else if (@rate >= 0.4)
		set @targetColCodes = @targetColCodes + ';11;'
	else if (@rate >= 0.3)
		set @targetColCodes = @targetColCodes + ';10;'
	else if (@rate >= 0.2)
		set @targetColCodes = @targetColCodes + ';9;'
	else if (@rate >= 0.1)
		set @targetColCodes = @targetColCodes + ';8;'

	if @logMode = 0
	begin
		-- Инкрементирование значения необходимых ячеек
		update @res
		set 
			c3 = CASE WHEN @targetColCodes like  '%;3;%'  THEN c3 + 1  ELSE c3 END
			, c4 = CASE WHEN @targetColCodes like  '%;4;%'  THEN c4 + 1  ELSE c4 END
			, c5 = CASE WHEN @targetColCodes like  '%;5;%'  THEN c5 + 1  ELSE c5 END
			, c6 = CASE WHEN @targetColCodes like  '%;6;%'  THEN c6 + 1  ELSE c6 END
			, c7 = CASE WHEN @targetColCodes like  '%;7;%'  THEN c7 + 1  ELSE c7 END
			, c8 = CASE WHEN @targetColCodes like  '%;8;%'  THEN c8 + 1  ELSE c8 END
			, c9 = CASE WHEN @targetColCodes like  '%;9;%'  THEN c9 + 1  ELSE c9 END
			, c10 = CASE WHEN @targetColCodes like '%;10;%' THEN c10 + 1 ELSE c10 END
			, c11 = CASE WHEN @targetColCodes like '%;11;%' THEN c11 + 1 ELSE c11 END
			, c12 = CASE WHEN @targetColCodes like '%;12;%' THEN c12 + 1 ELSE c12 END
			, c13 = CASE WHEN @targetColCodes like '%;13;%' THEN c13 + 1 ELSE c13 END
			, c14 = CASE WHEN @targetColCodes like '%;14;%' THEN c14 + 1 ELSE c14 END
			, c15 = CASE WHEN @targetColCodes like '%;15;%' THEN c15 + 1 ELSE c15 END
			, c16 = CASE WHEN @targetColCodes like '%;16;%' THEN c16 + 1 ELSE c16 END
			, c17 = CASE WHEN @targetColCodes like '%;17;%' THEN c17 + 1 ELSE c17 END
		where @targetRowCodes like '%' + c1 + '%'
	end
	else 
	if (@targetColCodes like '%;' + @logColName + ';%') and (@targetRowCodes like '%' + @logRowName + '%')
	begin
		-- Вставка текущей записи в таблицу детализации
		insert into @log(FIO) values (@fio)
	end

	FETCH NEXT FROM personCursor INTO @position, @academicDegree, @academicRank, @rate, @fio
END

CLOSE personCursor
DEALLOCATE personCursor

if( @logMode = 0)
	select 
		--c1  
		--, 
		c2 as 'Должность'
		, c3 as 'Всего'
		, c4 as 'к.н.'
		, c5 as 'д.н.'
		, c6 as 'доц.'
		, c7 as 'проф.'
		, c8 as '0.1'
		, c9  as '0.2'
		, c10 as '0.3'
		, c11 as '0.4'
		, c12 as '0.5'
		, c13 as '0.6'
		, c14 as '0.7'
		, c15 as '0.8'
		, c16 as '0.9'
		, c17 as '1.0'

	from @res
	order by c1 desc
else
	select * from @log

print 'query with detail, ms: ' + cast(datediff(ms,@start,getdate()) as nvarchar(10))
