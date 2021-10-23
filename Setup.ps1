# This script is expected to be run after the DEV SQL server is deployed
# You must be logged into your azure account with access to the SQL server

$resourceGroup = "Demo-Dev"
$sqlServer = "demodevsql"
$databaseName = "app-db"

$ip = (Invoke-WebRequest http://ident.me).Content;
$currentUser = $(az account show --query user.name);
az sql server firewall-rule create --name "DEV-$currentUser" --resource-group "$resourceGroup" --server "$sqlServer" --start-ip-address "$ip" --end-ip-address "$ip"
$connectionString = $(az sql db show-connection-string --name "$databaseName" --server "$sqlServer" --client ado.net --auth-type ADIntegrated)
#trim off quotes
$connectionString = $connectionString.Substring(1, $connectionString.Length - 2)
dotnet user-secrets set "ConnectionStrings:AppsDatabase" "$connectionString" --project .\ToppingsApi\ToppingsApi\ToppingsApi.csproj