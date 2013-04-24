$global:testDatabase = @{}
$testDatabase.migrationsProject = "Data.Entities"
$testDatabase.appConfigProject = "EmptyDatabaseTests"
$testDatabase.connectionStringName = "emptyTestDatabase"

$global:integrationDatabase = @{}
$integrationDatabase.migrationsProject = "Data.Entities"
$integrationDatabase.appConfigProject = "FullDatabaseTests"
$integrationDatabase.connectionStringName = "FullTestDatabase"

$global:unmigratedDatabase = @{}
$unmigratedDatabase.appConfigProject = "UnmigratedDatabaseTests"
$unmigratedDatabase.connectionStringName = "UnmigratedTestDatabase"

$global:appDataSettingsPath = Join-Path -Path $env:APPDATA -ChildPath "MetricsDB/DeveloperConfig"
$global:workingCopySettingsPath = Join-Path -Path $solutionPaths.repositoryRoot -ChildPath "DeveloperConfig"