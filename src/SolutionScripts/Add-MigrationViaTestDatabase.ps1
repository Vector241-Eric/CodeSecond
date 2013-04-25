Function global:Add-MigrationViaTestDatabase([string]$migrationName) 
{
    if ([string]::IsNullOrEmpty($migrationName))
    {
        $migrationName = read-host "Migration name: "
    }

    # Make sure the database is clean
    Reset-EmptyDatabase

    # Generate the migration
    Add-Migration -Name $migrationName -ProjectName $emptyDatabase.migrationsProject -StartupProjectName $emptyDatabase.appConfigProject -ConnectionStringName $emptyDatabase.connectionStringName
}
