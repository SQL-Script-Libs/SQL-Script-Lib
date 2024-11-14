$modelXmlPath = Read-Host "model.xml file path"

$hasher = [System.Security.Cryptography.HashAlgorithm]::Create("System.Security.Cryptography.SHA256CryptoServiceProvider")

$fileStream = new-object System.IO.FileStream ` -ArgumentList @($modelXmlPath, [System.IO.FileMode]::Open)

$hash = $hasher.ComputeHash($fileStream)

$hashString = ""

Foreach ($b in $hash) { $hashString += $b.ToString("X2") }

$fileStream.Close()

$hashString
