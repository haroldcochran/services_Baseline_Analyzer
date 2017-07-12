## services_Baseline_Analyzer.ps1
## Compares services listed with a baseline to review possible changes
##

# Universal variables
$current_Time = Get-Date -format yyyyMMdd_HHmmss

# Customized variables per environment
$output_CSV_Folder = "F:\DIMS\scripts\"
$output_CSV_File = "services_$current_Time.csv"

$baseline_CSV_Folder = "F:\DIMS\scripts\baseline\"
$baseline_CSV_File = "services_Baseline.csv"

# Create CSV of the current services with startup_types
Get-Service | Select-Object DisplayName, StartType | Export-Csv -Path $output_CSV_Folder$output_CSV_File -Encoding UTF8 -NoTypeInformation

# Compare newly-generated CSV to baseline
$baseline_Compare = Compare-Object (Import-CSV -Path $output_CSV_Folder$output_CSV_File) (Import-CSV -Path $baseline_CSV_Folder$baseline_CSV_File)

IF ($baseline_Compare.InputObject -eq $NULL)
    {
        Write-Host "No changes from baseline"
        break
    }
ELSE
    {
        Foreach ($baseline_Change in $baseline_Compare)
        {
            Write-Host "Service:" $baseline_Change.InputObject.DisplayName "is off of baseline!" -ForegroundColor Yellow -BackgroundColor Red
        }
    }
