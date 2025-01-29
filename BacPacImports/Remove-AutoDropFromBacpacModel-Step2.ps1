# This script can be used to remove AutoDrop properties from the model file of a
# SQL Server 2022 (or equivalient Azure SQL) bacpac backup.
# This enables restoring the bacpac on a SQL server 2019.
# See also https://github.com/d365collaborative/d365fo.tools/issues/747
# Original script by @batetech in https://www.yammer.com/dynamicsaxfeedbackprograms/#/Threads/show?threadId=2382104258371584
# Minor changes by @FH-Inway
# Gist of script: https://gist.github.com/FH-Inway/f485c720b43b72bffaca5fb6c094707e

Param(
    [Parameter(Mandatory=$true)] [string]$BacpacFileName,
    [Parameter(Mandatory=$false)] [string]$ModelFile = "BacpacModel.xml",
    [Parameter(Mandatory=$false)] [string]$ModelUpdatedFile = "BacpacModelUpdated.xml",
    [Parameter(Mandatory=$false)] [string]$NewDatabaseName = "AxDB_FromBACPAC",
    [Parameter(Mandatory=$false)] [string]$DiagnosticFile = "ImportLog.txt"
)

#################################################################################################
# Remove all occureces of property AutoDrop in $sourceFile and create a copy at $destinationFile
#################################################################################################

function Local-FixBacPacModelFile
{
    param(
        [string]$sourceFile, 

        [string]$destinationFile,

        [int]$flushCnt = 500000
    )

    if($sourceFile.Equals($destinationFile, [System.StringComparison]::CurrentCultureIgnoreCase))
    {
        throw "Source and destination files must not be the same."
        return;
    }

    $searchForString = '<Property Name="AutoDrop" Value="True" />';
    $replaceWithString = '';

    #using performance suggestions from here: https://learn.microsoft.com/en-us/powershell/scripting/dev-cross-plat/performance/script-authoring-considerations
    # * use List<String> instead of PS Array @()
    # * use StreamReader instead of Get-Content
    $buffer = [System.Collections.Generic.List[string]]::new($flushCnt) #much faster than PS array using +=
    $buffCnt = 0;

    #delete dest file if it already exists.
    if(Test-Path -LiteralPath $destinationFile)
    {
        Remove-Item -LiteralPath $destinationFile -Force;
    }

    try
    {
        $stream = [System.IO.StreamReader]::new($sourceFile)
        $streamEncoding = $stream.CurrentEncoding;
        Write-Verbose "StreamReader.CurrentEncoding: $($streamEncoding.BodyName) $($streamEncoding.CodePage)"

        while ($stream.Peek() -ge 0)
        {
            $line = $stream.ReadLine()
            if(-not [string]::IsNullOrEmpty($line))
            {
                $buffer.Add($line.Replace($searchForString,$replaceWithString));
            }
            else
            {
                $buffer.Add($line);
            }

            $buffCnt++;
            if($buffCnt -ge $flushCnt)
            {
                Write-Verbose "$(Get-Date -Format 'u') Flush buffer"
                $buffer | Add-Content -LiteralPath $destinationFile -Encoding UTF8
                $buffer = [System.Collections.Generic.List[string]]::new($flushCnt);
                $buffCnt = 0;
                Write-Verbose "$(Get-Date -Format 'u') Flush complete"
            }
        }
    }
    finally
    {
        $stream.Dispose()
        Write-Verbose 'Stream disposed'
    }

    #flush anything still remaining in the buffer
    if($buffCnt -gt 0)
    {
        $buffer | Add-Content -LiteralPath $destinationFile -Encoding UTF8
        $buffer = $null;
        $buffCnt = 0;
    }

}


Write-Host "Check files and directories"
$filePath = (Get-Location).Path

$bacpacFileNameAndPath = (Join-Path -Path $filePath -ChildPath $BacpacFileName)
if (!(Test-Path $bacpacFileNameAndPath))
{
    Write-Host "File $bacpacFileNameAndPath does not exists!" -ForegroundColor Red
    Return -1
}

$modelFilePath = (Join-Path -Path $filePath -ChildPath $ModelFile)
if (Test-Path $modelFilePath)
{
    Write-Host "Delete old file $modelFilePath now!" -ForegroundColor Yellow
}

$modelFileUpdatedPath = (Join-Path -Path $filePath -ChildPath $ModelUpdatedFile)
if (Test-Path $modelFilePath)
{
    Write-Host "Delete old file $modelFileUpdatedPath now!" -ForegroundColor Yellow
}

$DiagnosticFilePath = (Join-Path -Path $filePath -ChildPath $DiagnosticFile)
if (Test-Path $DiagnosticFilePath)
{
    Write-Host "Delete old file $DiagnosticFilePath now!" -ForegroundColor Yellow
}

Write-Host "Extract model file from BACPAC to $modelFilePath"
## Export-D365BacpacModelFile -Path $bacpacFileNameAndPath -OutputPath $modelFilePath -Force

Write-Host "Remove AutoDrop property and write to $modelFileUpdatedPath"
## Local-FixBacPacModelFile -sourceFile $modelFilePath -destinationFile $modelFileUpdatedPath

Write-Host "Import BACPAC to database $NewDatabaseName"
Import-D365Bacpac -ImportModeTier1 -BacpacFile "$bacpacFileNameAndPath" -ModelFile $modelFileUpdatedPath -NewDatabaseName $NewDatabaseName -DiagnosticFile $DiagnosticFilePath

Write-Host "Import is done. For logs see at file $DiagnosticFile"
Return 1