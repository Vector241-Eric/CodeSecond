# Can't use the invocation path because the path is not set on the invocation when called from solution scripts

Function global:ImportCustomModules() {
	$repoRoot = $solutionPaths.repositoryRoot;
	Import-Module "$repoRoot\src\PowerShell\modules\path-helper.psm1"
	Import-Module "$($folders.modules.invoke('dbModule.psm1'))"
}

Function global:Remove-CustomModules() {
	Remove-Module dbModule
	Remove-Module path-helper
}

Function global:Reset-CustomModules() {
	Remove-CustomModules
	ImportCustomModules
}

ImportCustomModules