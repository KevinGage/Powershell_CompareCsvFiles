# Powershell_CompareCsvFiles
This script takes two csv file names as inputs.  Both CSV files are read and only the specified column is compared.  All other columns are ignored.  The script outputs and items that have been added or removed between the two files.
  
# EXAMPLE
./CsvCompare.ps1 -OriginalCsv c:\original.csv -NewCsv c:\new.csv -ColName name
./CsvCompare.ps1 c:\original.csv c:\new.csv name
