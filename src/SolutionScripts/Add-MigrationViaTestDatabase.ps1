Function global:Add-MigrationViaTestDatabase([string]$migrationName) 
{
    if ([string]::IsNullOrEmpty($migrationName))
    {
        $migrationName = read-host "Migration name: "
    }

    # Make sure the database is clean
    Reset-TestDatabase

    # Generate the migration
    Add-Migration -Name $migrationName -ProjectName $testDatabase.migrationsProject -StartupProjectName $testDatabase.appConfigProject -ConnectionStringName $testDatabase.connectionStringName
}
