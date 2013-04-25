$global:emptyDatabase = @{}
$emptyDatabase.migrationsProject = "Chinook.Data"
$emptyDatabase.appConfigProject = "EmptyDatabaseTests"
$emptyDatabase.connectionStringName = "ChinookContext"

$global:integrationDatabase = @{}
$integrationDatabase.migrationsProject = "Chinook.Data"
$integrationDatabase.appConfigProject = "FullDatabaseTests"
$integrationDatabase.connectionStringName = "ChinookContext"