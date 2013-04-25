# Can't use the invocation path because the path is not set on the invocation when called from solution scripts

Function global:ImportCustomModules() {
	$repoRoot = $solutionPaths.repositoryRoot;
	Import-Module "$repoRoot\src\PowerShell\modules\path-helper.psm1"
#	. "$($folders.activities.invoke('build\development.vars.ps1'))"
#	Import-Module "$($folders.activities.invoke('common.psm1'))"
#	Import-Module "$($folders.modules.invoke('database\database-management.psm1'))"
	Import-Module "$($folders.modules.invoke('dbModule.psm1'))"
#	Import-Module "$repoRoot\logistics\scripts\modules\database\database-management-metricsdb.psm1"
}

Function global:Remove-CustomModules() {
	Remove-Module dbModule
#	Remove-Module database-management
#	Remove-Module common
	Remove-Module path-helper
}

Function global:Reset-CustomModules() {
	Remove-CustomModules
	ImportCustomModules
}

ImportCustomModules