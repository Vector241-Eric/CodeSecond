$global:solutionPaths = @{}
$solutionPaths.src = [System.IO.Path]::GetDirectoryName($dte.Solution.FullName)
$solutionPaths.repositoryRoot = Split-Path -Path $solutionPaths.src -Parent
$solutionPaths.tempBackupPath = Join-Path -Path "$($solutionPaths.repositoryRoot)" -ChildPath "Database\Backup\"
$solutionPaths.packages = Resolve-Path -Path "$($solutionPaths.src)\packages"