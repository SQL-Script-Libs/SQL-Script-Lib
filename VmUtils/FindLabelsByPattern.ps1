$packagesDir = 'J:\AOSService\PackagesLocalDirectory\'
$labelFiles = ls $packagesDir\*\*\AxLabelFile\LabelResources\[Language]\*.txt
$labelFiles | Select-String -Pattern '[LabelText]' | select Line, Filename, LineNumber
