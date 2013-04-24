Function global:Get-ProjectDirectory([string]$projectName) {
	$project = Get-Project -Name $projectName

	#Write-Host "DEBUG:: Project $projectName at $($project.FullName)"

	$file = Get-ChildItem $($project.FullName)
	#Write-Host "DEBUG:: $file"
	$projectDirectory = $file.DirectoryName
	#Write-Host "DEBUG:: $projectDirectory"

	return $projectDirectory
}
