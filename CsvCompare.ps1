<#
.SYNOPSIS
  This script is used to compare two csv files and output any new or removed lines.
.DESCRIPTION
  This script takes two csv file names as inputs.  Both CSV files are read and only the specified column is compared.  All other columns are ignored.
  The script outputs and items that have been added or removed between the two files.
.INPUTS
  The script requires two properly formed CSV files with at least one column of data.  It also requires a column name to be specified. 
.NOTES
  Version:        1
  Author:         Kevin Gage
  Creation Date:  01/07/2020
  Purpose/Change: Initial script development
 		Version		Release Date    Description
		=======		============    ===========
		1.0			01/07/2020		Initial script development
.EXAMPLE
  ./CsvCompare.ps1 -OriginalCsv c:\original.csv -NewCsv c:\new.csv -ColName name
  ./CsvCompare.ps1 c:\original.csv c:\new.csv name
#>

param (
    [Parameter(Position=0, Mandatory=$true)]
    [string]$OriginalCsv,
    [Parameter(Position=1, Mandatory=$true)]
    [string]$NewCsv,
    [Parameter(Position=2, Mandatory=$true)]
    [string]$CompareColName
)

$OldData = @()
$NewData = @()
$RemovedSoftware = New-Object System.Collections.ArrayList
$NewSoftware = New-Object System.Collections.ArrayList

try {
    $OldData = Import-Csv $OriginalCsv
}
catch {
    Write-Error "$OriginalCsv is not a properly formed csv file"
    exit 1
}

$OriginalCsvProperties = $OldData |gm
if (-Not ($OriginalCsvProperties.Name -contains $CompareColName )){
    Write-Error "$OriginalCsv does not contain column $CompareColName"
    exit 1
}

try {
    $NewData = Import-Csv $NewCsv
}
catch {
    Write-Error "$NewCsv is not a properly formed csv file"
    exit 1
}
$NewCsvProperties = $NewData |gm
if (-Not ($NewCsvProperties.Name -contains $CompareColName )){
    Write-Error "$NewCsv does not contain column $CompareColName"
    exit 1
}

$Differences = Compare-Object -ReferenceObject ($NewData | Sort-Object -Property $CompareColName) -DifferenceObject ($OldData | Sort-Object -Property $CompareColName) -Property $CompareColName

if ($Differences){
    Foreach ($Difference in $Differences) {
        if ($Difference.SideIndicator -eq '<=') {
            $NewSoftware.Add($Difference.$CompareColName) | Out-Null
        }
        else {
            $RemovedSoftware.Add($Difference.$CompareColName) | Out-Null
        }
    }
}

if ($NewSoftware.Count -gt 0) {
    Write-Host "New Items Detected"
    Foreach ($Software in $NewSoftware) {
        Write-Host "`t $Software"
    }
}
if ($RemovedSoftware.Count -gt 0) {
    Write-Host "Removed Items Detected"
    Foreach ($Software in $RemovedSoftware) {
        Write-Host "`t $Software"
    }
}