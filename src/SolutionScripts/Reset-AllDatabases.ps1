Function global:Reset-AllDatabases
{
	Write-RunMessage "Reset-IntegrationDatabase"
	Reset-IntegrationDatabase

	Write-RunMessage "Reset-TestDatabase"
	Reset-EmptyDatabase
}