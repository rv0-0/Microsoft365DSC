function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Text","Integer","Decimal","DateTime","YesNo","Double","Binary")]
        [System.String]
        $Type,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $Searchable,

        [Parameter()]
        [System.String]
        $FullTextIndex,

        [Parameter()]
        [System.Int32]
        $FullTextContext,

        [Parameter()]
        [System.Boolean]
        $Queryable,

        [Parameter()]
        [System.Boolean]
        $Retrievable,

        [Parameter()]
        [System.Boolean]
        $AllowMultipleValues,

        [Parameter()]
        [ValidateSet("No", "Yes - latent", "Yes")]
        [System.String]
        $Refinable,

        [Parameter()]
        [ValidateSet("No", "Yes - latent", "Yes")]
        [System.String]
        $Sortable,

        [Parameter()]
        [System.Boolean]
        $Safe,

        [Parameter()]
        [System.String[]]
        $Aliases,

        [Parameter()]
        [System.Boolean]
        $TokenNormalization,

        [Parameter()]
        [System.Boolean]
        $CompleteMatching,

        [Parameter()]
        [System.Boolean]
        $LanguageNeutralTokenization,

        [Parameter()]
        [System.Boolean]
        $FinerQueryTokenization,

        [Parameter()]
        [System.String[]]
        $MappedCrawledProperties,

        [Parameter()]
        [System.Boolean]
        $CompanyNameExtraction,

        [Parameter()] 
        [ValidateSet("Present","Absent")] 
        [System.String] 
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    Test-PnPOnlineConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

    $nullReturn = @{
        Name = $Name
        Type = $null
        Description = $null
        Searchable = $null
        FullTextIndex = $null
        FullTextContext = $null
        Queryable = $null
        Retrievable = $null
        AllowMultipleValues = $null
        Refinable = $null
        Sortable = $null
        Safe = $null
        Aliases = $null
        TokenNormalization = $null
        CompleteMatching = $null
        LanguageNeutralTokenization = $null
        FinerQueryTokenization = $null
        MappedCrawledProperties = $null
        CompanyNameExtraction = $null
        Ensure = "Absent"
        CentralAdminUrl = $CentralAdminUrl
    }

    $SearchConfig = [Xml] (Get-PnPSearchConfiguration -Scope Subscription)
    $property =  $SearchConfig.SearchConfigurationSettings.SearchSchemaConfigurationSettings.ManagedProperties.dictionary.KeyValueOfstringManagedPropertyInfoy6h3NzC8 `
                    | Where-Object { $_.Value.Name -eq $Name }

    if ($null -eq $property)
    {
        Write-Verbose "The specified Managed Property {$($Name)} doesn't already exist."
        return $nullReturn
    }

    $CompanyNameExtraction = $false
    if ($property.Value.EntityExtractorBitMap -eq "4161")
    {
        $CompanyNameExtraction = $true
    }
    $FullTextIndex = $null
    if ([string] $property.Value.FullTextIndex -ne "System.Xml.XmlElement")
    {
        $FullTextIndex = [string] $property.Value.FullTextIndex
    }

    # Get Mapped Crawled Properties
    $currentManagedPID = [string] $property.Value.Pid
    $mappedProperties = $SearchConfig.SearchConfigurationSettings.SearchSchemaConfigurationSettings.Mappings.dictionary.KeyValueOfstringMappingInfoy6h3NzC8 `
                            | Where-Object { $_.Value.ManagedPid -eq $currentManagedPID }

    $mappings = @()
    foreach ($mappedProperty in $mappedProperties)
    {
        $mappings += $mappedProperty.Value.CrawledPropertyName.ToString()
    }

    return @{
        Name = [string] $property.Value.Name
        Type = [string] $property.Value.ManagedType
        Description = [string] $property.Value.Description
        Searchable = [boolean] $property.Value.Searchable
        FullTextIndex = $FullTextIndex
        FullTextContext = [System.Int32] $property.Value.Context
        Queryable = [boolean] $property.Value.Queryable
        Retrievable = [boolean] $property.Value.Retrievable
        AllowMultipleValues = [boolean] $property.Value.HasMultipleValues
        Refinable = [boolean] $property.Value.Refinable
        Sortable = [boolean] $property.Value.Sortable
        Safe = [boolean] $property.Value.SafeForAnonymous
        Aliases = [boolean] $property.Value.Aliases
        TokenNormalization = [boolean] $property.Value.TokenNormalization
        CompleteMatching = [boolean] $property.Value.CompleteMatching
        LanguageNeutralTokenization = [boolean] $property.Value.LanguageNeutralWordBreaker
        FinerQueryTokenization = [boolean] $property.Value.ExpandSegments
        MappedCrawledProperties = $mappings
        CompanyNameExtraction = $CompanyNameExtraction
        CentralAdminUrl = $CentralAdminUrl
        Ensure = "Present"
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Text","Integer","Decimal","DateTime","YesNo","Double","Binary")]
        [System.String]
        $Type,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $Searchable,

        [Parameter()]
        [System.String]
        $FullTextIndex,

        [Parameter()]
        [System.Int32]
        $FullTextContext,

        [Parameter()]
        [System.Boolean]
        $Queryable,

        [Parameter()]
        [System.Boolean]
        $Retrievable,

        [Parameter()]
        [System.Boolean]
        $AllowMultipleValues,

        [Parameter()]
        [ValidateSet("No", "Yes - latent", "Yes")]
        [System.String]
        $Refinable,

        [Parameter()]
        [ValidateSet("No", "Yes - latent", "Yes")]
        [System.String]
        $Sortable,

        [Parameter()]
        [System.Boolean]
        $Safe,

        [Parameter()]
        [System.String[]]
        $Aliases,

        [Parameter()]
        [System.Boolean]
        $TokenNormalization,

        [Parameter()]
        [System.Boolean]
        $CompleteMatching,

        [Parameter()]
        [System.Boolean]
        $LanguageNeutralTokenization,

        [Parameter()]
        [System.Boolean]
        $FinerQueryTokenization,

        [Parameter()]
        [System.String[]]
        $MappedCrawledProperties,

        [Parameter()]
        [System.Boolean]
        $CompanyNameExtraction,

        [Parameter()] 
        [ValidateSet("Present","Absent")]
        [System.String] 
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    Test-PnPOnlineConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount
    $SearchConfigTemplatePath =  Join-Path -Path $PSScriptRoot `
                                           -ChildPath "..\Dependencies\SearchConfigurationSettings.xml" `
                                           -Resolve
    $SearchConfigXML = [Xml] (Get-Content $SearchConfigTemplatePath -Raw)
    # Get the managed property back if it already exists.
    $currentConfigXML = [XML] (Get-PnpSearchCOnfiguration -Scope Subscription)
    $property =  $currentConfigXML.SearchConfigurationSettings.SearchSchemaConfigurationSettings.ManagedProperties.dictionary.KeyValueOfstringManagedPropertyInfoy6h3NzC8 `
                    | Where-Object { $_.Value.Name -eq $Name }
    if ($null -ne $property)
    {
        $currentPID = $property.Value.Pid
    }

    $prop = $SearchConfigXml.ChildNodes[0].SearchSchemaConfigurationSettings.ManagedProperties.dictionary
    $newManagedPropertyElement = $SearchConfigXML.CreateElement("d4p1:KeyValueOfstringManagedPropertyInfoy6h3NzC8", `
                                                                "http://schemas.microsoft.com/2003/10/Serialization/Arrays")
    $keyNode = $SearchConfigXML.CreateElement("d4p1:Key", `
                                              "http://schemas.microsoft.com/2003/10/Serialization/Arrays")
    $keyNode.InnerText = $Name
    $catch = $newManagedPropertyElement.AppendChild($keyNode)

    $valueNode = $SearchConfigXML.CreateElement("d4p1:Value", `
                                              "http://schemas.microsoft.com/2003/10/Serialization/Arrays")

    $node = $SearchConfigXML.CreateElement("d3p1:Name", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $Name
    $catch = $valueNode.AppendChild($node)

    $node = $SearchConfigXML.CreateElement("d3p1:CompleteMatching", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $CompleteMatching.ToString().Replace("$", "").ToLower()
    $catch = $valueNode.AppendChild($node)

    $node = $SearchConfigXML.CreateElement("d3p1:Context", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $FullTextContext.ToString()
    $catch = $valueNode.AppendChild($node)

    $node = $SearchConfigXML.CreateElement("d3p1:DeleteDisallowed", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = "false"
    $catch = $valueNode.AppendChild($node)

    $node = $SearchConfigXML.CreateElement("d3p1:Description", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")

    $node.InnerText = $Description
    $catch = $valueNode.AppendChild($node)

    $node = $SearchConfigXML.CreateElement("d3p1:EnabledForScoping", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = "false"
    $catch = $valueNode.AppendChild($node)

    #region EntiryExtractionBitMap
    $node = $SearchConfigXML.CreateElement("d3p1:EntityExtractorBitMap", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")

    if ($CompanyNameExtraction)
    {
        $node.InnerText = "4161"
    }
    else
    {
        $node.InnerText = "0"
    }    
    $catch = $valueNode.AppendChild($node)
    #endregion
    
    $node = $SearchConfigXML.CreateElement("d3p1:ExpandSegments", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $FinerQueryTokenization.ToString().Replace("$", "").ToLower()
    $catch = $valueNode.AppendChild($node)
    
    $node = $SearchConfigXML.CreateElement("d3p1:FullTextIndex", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $FullTextIndex
    $catch = $valueNode.AppendChild($node)
    
    $node = $SearchConfigXML.CreateElement("d3p1:HasMultipleValues", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $AllowMultipleValues.ToString().Replace("$", "").ToLower()
    $catch = $valueNode.AppendChild($node)
    
    $node = $SearchConfigXML.CreateElement("d3p1:IndexOptions", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = "0"
    $catch = $valueNode.AppendChild($node)

    $node = $SearchConfigXML.CreateElement("d3p1:IsImplicit", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = "false"
    $catch = $valueNode.AppendChild($node)

    $node = $SearchConfigXML.CreateElement("d3p1:IsReadOnly", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = "false"
    $catch = $valueNode.AppendChild($node)

    #region LanguageNeutralWordBreaker
    if ($LanguageNeutralTokenization -and $CompleteMatching)
    {
        throw "You cannot have CompleteMatching set to $true if LanguageNeutralTokenization is set to $true"
    }
    $node = $SearchConfigXML.CreateElement("d3p1:LanguageNeutralWordBreaker", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $LanguageNeutralTokenization.ToString().Replace("$", "").ToLower()
    $catch = $valueNode.AppendChild($node)
    #endregion
    
    $node = $SearchConfigXML.CreateElement("d3p1:ManagedType", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $Type
    $catch = $valueNode.AppendChild($node)
    
    $node = $SearchConfigXML.CreateElement("d3p1:MappingDisallowed", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = "false"
    $catch = $valueNode.AppendChild($node)

    #region PID
    if ($null -ne $currentPID)
    {
        $node = $SearchConfigXML.CreateElement("d3p1:Pid", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
        $node.InnerText = $currentPid
        $catch = $valueNode.AppendChild($node)
    }
    #endregion
    
    $node = $SearchConfigXML.CreateElement("d3p1:Queryable", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $Queryable.ToString().Replace("$", "").ToLower()
    $catch = $valueNode.AppendChild($node)
    
    #region Refinable
    $node = $SearchConfigXML.CreateElement("d3p1:Refinable", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $Refinable.ToString().Replace("$", "").ToLower()
    $catch = $valueNode.AppendChild($node)

    $node = $SearchConfigXML.CreateElement("d3p1:RefinerConfiguration", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")

    $subNode = $SearchConfigXML.CreateElement("d3p1:Anchoring", `
                                              "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $subNode.InnerText = "Auto"
    $catch = $node.AppendChild($subNode)

    $subNode = $SearchConfigXML.CreateElement("d3p1:CutoffMaxBuckets", `
                                              "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $subNode.InnerText = "1000"
    $catch = $catch = $node.AppendChild($subNode)
        
    $subNode = $SearchConfigXML.CreateElement("d3p1:Divisor", `
                                              "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $subNode.InnerText = "1"
    $catch = $node.AppendChild($subNode)
        
    $subNode = $SearchConfigXML.CreateElement("d3p1:Intervals", `
                                              "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $subNode.InnerText = "4"
    $catch = $node.AppendChild($subNode)
        
    $subNode = $SearchConfigXML.CreateElement("d3p1:Resolution", `
                                              "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $subNode.InnerText = "1"
    $catch = $node.AppendChild($subNode)
        
    $subNode = $SearchConfigXML.CreateElement("d3p1:Type", `
                                              "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $subNode.InnerText = "Deep"
    $catch = $node.AppendChild($subNode)

    $catch = $valueNode.AppendChild($node)
    #endregion    

    $node = $SearchConfigXML.CreateElement("d3p1:RemoveDuplicates", `
                                              "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = "true"
    $catch = $valueNode.AppendChild($node)    

    $node = $SearchConfigXML.CreateElement("d3p1:RespectPriority", `
                                              "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = "false"
    $catch = $valueNode.AppendChild($node)

    $node = $SearchConfigXML.CreateElement("d3p1:Retrievable", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $Retrievable.ToString().Replace("$", "").ToLower()
    $catch = $valueNode.AppendChild($node)

    $node = $SearchConfigXML.CreateElement("d3p1:SafeForAnonymous", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $Safe.ToString().Replace("$", "").ToLower()
    $catch = $valueNode.AppendChild($node)

    $node = $SearchConfigXML.CreateElement("d3p1:Searchable", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $Searchable.ToString().Replace("$", "").ToLower()
    $catch = $valueNode.AppendChild($node)
    
    $node = $SearchConfigXML.CreateElement("d3p1:Sortable", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $Sortable.ToString().Replace("$", "").ToLower()
    $catch = $valueNode.AppendChild($node)    
    
    $node = $SearchConfigXML.CreateElement("d3p1:SortableType", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = "Enabled"
    $catch = $valueNode.AppendChild($node)
    
    $node = $SearchConfigXML.CreateElement("d3p1:TokenNormalization", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $TokenNormalization.ToString().Replace("$", "").ToLower()
    $catch = $valueNode.AppendChild($node)

    $newManagedPropertyElement.AppendChild($valueNode)
    $catch = $prop.AppendChild($newManagedPropertyElement)

    $tempPath = $ENV:TEMP + "\" + (New-Guid).ToString().SPlit('-')[0] + ".config"
    $SearchConfigXML.OuterXml | Out-File $tempPath

    # Create the Managed Property if it doesn't already exist
    Set-PnPSearchConfiguration -Scope Subscription -Path $tempPath

    #region Aliases
    if ($null -ne $Aliases)
    {
        $aliasesArray = $Aliases.Split(';')
        $aliasProp = $SearchConfigXml.ChildNodes[0].SearchSchemaConfigurationSettings.Aliases.dictionary

        if ($null -eq $currentPID)
        {
            # Get the managed property back. This is the only way to ensure we have the right PID
            $currentConfigXML = [XML] (Get-PnpSearchCOnfiguration -Scope Subscription)
            $property =  $currentConfigXML.SearchConfigurationSettings.SearchSchemaConfigurationSettings.ManagedProperties.dictionary.KeyValueOfstringManagedPropertyInfoy6h3NzC8 `
                            | Where-Object { $_.Value.Name -eq $Name }
            $currentPID = $property.Value.Pid

            $node = $SearchConfigXML.CreateElement("d3p1:Pid", `
                                                   "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
            $node.InnerText = $currentPID

            # The order in which we list the properties matters. Pid is to appear right after MappingDisallowed.
            $namespaceMgr = New-Object System.Xml.XmlNamespaceManager($SearchConfigXML.NameTable);
            $namespaceMgr.AddNamespace("d3p1", "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
            $previousNode = $SearchConfigXML.SelectSingleNode("//d3p1:MappingDisallowed", $namespaceMgr)
            $catch = $previousNode.ParentNode.InsertAfter($node, $previousNode)
        }

        foreach ($alias in $aliasesArray)
        {
            $mainNode = $SearchConfigXML.CreateElement("d4p1:KeyValueOfstringAliasInfoy6h3NzC8", `
                                                   "http://schemas.microsoft.com/2003/10/Serialization/Arrays")
            $keyNode = $SearchConfigXML.CreateElement("d4p1:Key", `
                                                      "http://schemas.microsoft.com/2003/10/Serialization/Arrays")
            $keyNode.InnerText = $alias

            $valueNode = $SearchConfigXML.CreateElement("d4p1:Value", `
                                                      "http://schemas.microsoft.com/2003/10/Serialization/Arrays")
            $node = $SearchConfigXML.CreateElement("d3p1:Name", `
                                                   "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
            $node.InnerText = $alias
            $catch = $valueNode.AppendChild($node)

            $node = $SearchConfigXML.CreateElement("d3p1:ManagedPid", `
                                                   "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
            $node.InnerText = $currentPID
            $catch = $valueNode.AppendChild($node)

            $node = $SearchConfigXML.CreateElement("d3p1:SchemaId", `
                                                   "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
            $node.InnerText = "6408"
            $catch = $valueNode.AppendChild($node)

            $catch = $mainNode.AppendChild($keyNode)
            $catch = $catch = $mainNode.AppendChild($valueNode)
            $aliasProp.AppendChild($mainNode)
        }

        $tempPath = $ENV:TEMP + "\" + (New-Guid).ToString().SPlit('-')[0] + ".config"
        $SearchConfigXML.OuterXml | Out-File $tempPath

        # Create the aliases on the Managed Property
        Set-PnPSearchConfiguration -Scope Subscription -Path $tempPath
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Text","Integer","Decimal","DateTime","YesNo","Double","Binary")]
        [System.String]
        $Type,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $Searchable,

        [Parameter()]
        [System.String]
        $FullTextIndex,

        [Parameter()]
        [System.Int32]
        $FullTextContext,

        [Parameter()]
        [System.Boolean]
        $Queryable,

        [Parameter()]
        [System.Boolean]
        $Retrievable,

        [Parameter()]
        [System.Boolean]
        $AllowMultipleValues,

        [Parameter()]
        [ValidateSet("No", "Yes - latent", "Yes")] 
        [System.String]
        $Refinable,

        [Parameter()]
        [ValidateSet("No", "Yes - latent", "Yes")] 
        [System.String]
        $Sortable,

        [Parameter()]
        [System.Boolean]
        $Safe,

        [Parameter()]
        [System.String[]]
        $Aliases,

        [Parameter()]
        [System.Boolean]
        $TokenNormalization,

        [Parameter()]
        [System.Boolean]
        $CompleteMatching,

        [Parameter()]
        [System.Boolean]
        $LanguageNeutralTokenization,

        [Parameter()]
        [System.Boolean]
        $FinerQueryTokenization,

        [Parameter()]
        [System.String[]]
        $MappedCrawledProperties,

        [Parameter()]
        [System.Boolean]
        $CompanyNameExtraction,

        [Parameter()] 
        [ValidateSet("Present","Absent")] 
        [System.String] 
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    $CurrentValues = Get-TargetResource @PSBoundParameters
    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
                                           -DesiredValues $PSBoundParameters `
                                           -ValuesToCheck @("Ensure", `
                                                            "Name")
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Text","Integer","Decimal","DateTime","YesNo","Double","Binary")]
        [System.String]
        $Type,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName $GlobalAdminAccount.UserName
    $content = "        SPOSearchManagedProperty " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
