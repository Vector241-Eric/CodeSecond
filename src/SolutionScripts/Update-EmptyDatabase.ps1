Function global:Update-EmptyDatabase()
{
    Write-Host "Updating database with following parameters"
    Write-Host "    Migrations Project: $($emptyDatabase.migrationsProject)"
    Write-Host "    Config Project:     $($emptyDatabase.appConfigProject)"

    Write-Host "Migrating database"
    Update-Database -ProjectName $($emptyDatabase.migrationsProject) -StartUpProjectName $($emptyDatabase.appConfigProject)
    Write-Host "Database migrated." -ForegroundColor DarkGreen
}