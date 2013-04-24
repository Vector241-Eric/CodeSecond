function global:Get-AncestorItem ([string]$path, [string]$itemName) {
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

function global:ParseConnectionString([string]$cs) {
    $connectionStringTokens = $cs.split(";")
    $tokens = @{};

    foreach($token in $connectionStringTokens)
    {
        $nameValue = $token.split("=")
        $name = $nameValue[0]

        switch -regex ($name.ToLower())
        {
            "data source"
            {
                $tokens.serverName = $nameValue[1]
            }
            "initial catalog"
            {
                $tokens.databaseName = $nameValue[1]
            }
            "user id"
            {
                $tokens.databaseLogin = $nameValue[1]
            }
            "password"
            {
                $tokens.databasePassword = $nameValue[1]
            }
        }
    }

    return $tokens;
}

    
Function global:Load-ConnectionString([string]$connectionStringName, [string]$solutionRelativePath) {
    $absolutePath = Join-Path -Path $solutionPaths.src -ChildPath $solutionRelativePath
    $absolutePath = Resolve-Path $absolutePath

    # initialize the xml object
    $appConfig = New-Object XML
    # load the config file as an xml object
    $appConfig.Load($absolutePath)
    # iterate over the settings
    # TODO:  Separate out a function to find the connection string
    foreach($connectionString in $appConfig.configuration.connectionStrings.add)
    {
        if ($connectionString.name -eq $connectionStringName)
        {
            return $connectionString.connectionString
        }
    }
}

Function global:DumpErrors() {
    #Dump any errors in red
    if ($Error -ne '') {
        write-host "ERROR: $Error" -fore Red
        exit $error.Count
    }
}

Function global:XmlPeekInnerText($filePath, $xpath) { 
    [xml] $fileXml = Get-Content $filePath 
    return $fileXml.SelectSingleNode($xpath).InnerText 
} 

Function global:XmlPokeInnerText($filePath, $xpath, $value) { 
    [xml] $fileXml = Get-Content $filePath 
    $node = $fileXml.SelectSingleNode($xpath) 
    if ($node) { 
        $node.InnerText = $value 

        $fileXml.Save($filePath)  
    } 
}

Function global:Ensure-PathExists ([string]$path) {
    # Write-Host "DEBUG: Checking for path at '$path'"
    if (-not (Test-Path $path)) {
        #Write-Host "Creating directory $path"
        New-Item -ItemType directory -Path $path
    }
}

Function global:Write-RunMessage([string]$message) {
    Write-Host
    Write-Host "RUN:: $message" -Fore Cyan
    Write-Host
}