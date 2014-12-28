@echo off
rem This is a script to upload/download/list/delete file to/from apricot
setlocal

if [%1] == [] goto :usage
set method=%1

if exist config.txt (
  for /f "delims=" %%x in (config.txt) do (set %%x)
  shift
  goto :%method%
) else (
  echo config.txt is not found.
  goto :end
)

:usage
echo ap.cmd [get^|put^|list^|del] filename
goto :end

:put
echo Start uploading file(s) ...
set files=%1
for %%f in (%files%) do echo Uploading %%~nxf && cmd /c curl -X POST -k -u %user%:%passwd% -T %%f https://apricot.ddns.net/db/col/fs/file/%%~nxf | json -a -C msg
goto :end

:get
echo Start downloading file(s) ...
set file=%1
echo Downloading %file%
cmd /c curl -k -u %user%:%passwd% https://apricot.ddns.net/db/col/fs/file/%file% > %file%
goto :end

:del
echo Start deleting file(s) ...
set file=%1
echo Deleting %file%
cmd /c curl -X DELETE -k -u %user%:%passwd% https://apricot.ddns.net/db/col/fs/file/%file% | json -a -C msg
goto :end

:list
echo Listing files ...
cmd /c curl -k -u %user%:%passwd% https://apricot.ddns.net/db/col/fs/files | json -a -C filename length uploadDate
goto :end


:end
