# This script assume that EF Core tooling has already been installed
# To install the latest tooling, run: dotnet tool install -g dotnet-ef

# This will update the LocalDB database from the migrations

$json = dotnet user-secrets list --json
# To support PS < 6, strip off the comments
$json = $json -replace "//BEGIN" -replace "//END"
$secrets = $json | ConvertFrom-Json 
$connectionString = $secrets.{ConnectionStrings:AppsDatabase}
dotnet ef database update --connection "$connectionString"