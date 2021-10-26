# This script is expected to be run after the DEV SQL server is deployed
# You must be logged into your azure account with access to the SQL server

# It will load a copy of the dev database into a LocalDb instance. If you
# don't have LocalDb installed it can be done from the Visual Studio installer:
# More information: https://docs.microsoft.com/sql/database-engine/configure-windows/sql-server-express-localdb 



$resourceGroup = "Demo-Dev"
$sqlServer = "demodevsql"
$databaseName = "app-db"
$storageContainer = "sqlbackups"
$bacpacFile = "dev.bacpac"

$user = az account show --query user.name
$blobName = "$user-$bacpacFile"

Write-Host "Creating database backup for $user"

Write-Host "Getting storage account for SQL backup"
$sqlBackupStorageAccount = $(az storage account list -g "$resourceGroup" --query "[? starts_with(name, 'sqlbackup')].name | [0]")
$accessKey = $(az storage account keys list -n $sqlBackupStorageAccount -g "$resourceGroup" --query [0].value)

Write-Host "Getting SQL database credentials"
Push-Location Infrastructure/env/dev
$adminLogin = $(terraform output sql_server_admin_login)
$adminPassword = $(terraform output sql_server_admin_password)
Pop-Location

Write-Host "Exporting database backup"
az sql db export `
    --server "$sqlServer" `
    --name "$databaseName" `
    --resource-group "$resourceGroup" `
    --admin-user "$adminLogin" `
    --admin-password "$adminPassword" `
    --storage-key $accessKey `
    --storage-key-type StorageAccessKey `
    --storage-uri "https://$sqlBackupStorageAccount.blob.core.windows.net/$storageContainer/$blobName" `
    | Out-Null

Write-Host "Downloading database backup from blob"
az storage blob download `
    --container-name "$storageContainer" `
    --file "$bacpacFile" `
    --name "$blobName" `
    --account-name "$sqlBackupStorageAccount" `
    --account-key "$accessKey" `
    | Out-Null

Write-Host "Removing blob"
az storage blob delete `
    --container-name "$storageContainer" `
    --name "$blobName" `
    --account-name "$sqlBackupStorageAccount" `
    --account-key "$accessKey" `
    | Out-Null

Write-Host "Restoring to LocalDb"
$vsWherePath = "${env:ProgramFiles(x86)}/Microsoft Visual Studio/Installer/vswhere.exe"
if (!(Test-Path $vsWherePath)) {
    Write-Error "Could not find vswhere.exe at $vsWherePath. Ensure Visual Studio is installed."
    return 1
}
$vsInstallLocation = & $vsWherePath -all -latest -prerelease -format value -property installationPath
$sqlPackageLocation  = "$vsInstallLocation\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\SqlPackage.exe"
if (!(Test-Path $sqlPackageLocation)) {
    Write-Error "Could not find SqlPackage.exe at $sqlPackageLocation. Ensure LocalDb is installed via the Visual Studio Installer."
    return 1
}

$connectionString = "Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=$databaseName;Integrated Security=true;"
& $sqlPackageLocation /Action:Import /SourceFile:"$bacpacFile" /TargetConnectionString:"$connectionString"
Remove-Item $bacpacFile

Write-Host "Updating ToppingsApi secrets"
dotnet user-secrets set "ConnectionStrings:AppsDatabase" "$connectionString" --project .\ToppingsApi\ToppingsApi\ToppingsApi.csproj
