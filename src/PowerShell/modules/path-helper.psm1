#Get the location this script is being called from.
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

function Get-AncestorItem ([string]$path, [string]$itemName) {
    $pos = $path.LastIndexOf("\$itemName\")
    
    if ($pos -lt 0) {
        if ($path.EndsWith("\$itemName")) {
            $pos = $path.LastIndexOf("\$itemName")
        } else {
            throw "Unable to locate '$itemName' in path '$path'."
        }
    }
    
    $newPath = $path.Substring(0, $pos) + "\$itemName"
    
    Resolve-Path $newPath
}

function Get-RootPath {
    #Look up to find the highest level common named folder.
    $logisticsBasePath = Get-AncestorItem (Resolve-path $scriptDir) "PowerShell"
    #Jump up two levels to get the root.
    return Resolve-Path "$logisticsBasePath\..\..\"
}

function Get-RootRelativePath ($path) {
    $root = Get-RootPath
	If (test-path "$root\$path") {
		return Resolve-Path "$root\$path"
    }
	throw ("Could not locate '$path' under '$root'.")
}

#Sets a global folders variable. Is the primary access mechanism for resolving paths. Utilizes a delegate.
function Set-Folders {
    if (-not ($script:folders)) {
        $script:folders = @{}
        $folders.scripts = [System.Func[Object,Object]]{ return (Get-RootRelativePath "logistics\scripts\$($args[0])") }
        $folders.base = [System.Func[Object,Object]]{ return (Get-RootRelativePath "$($args[0])") }
        $folders.tools = [System.Func[Object,Object]]{ return (Get-RootRelativePath "tools\$($args[0])") }
        $folders.modules = [System.Func[Object,Object]]{ return (Get-RootRelativePath "src\PowerShell\modules\$($args[0])") }
        $folders.activities = [System.Func[Object,Object]]{ return (Get-RootRelativePath "logistics\scripts\activities\$($args[0])") }
    }
}
Set-Folders
Export-ModuleMember -Variable folders