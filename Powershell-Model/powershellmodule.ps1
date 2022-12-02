# Set Global Variable as required

$resourceGroupName = "Mars_GP"
$dataFactoryName = "MarsADF-Dev2"
$region = "westeurope"

#SPN for deploying ADF:
$tenantId = [System.Environment]::GetEnvironmentVariable('AZURE_TENANT_ID')
$subscriptionId = [System.Environment]::GetEnvironmentVariable('AZURE_SUBSCRIPTION_ID')
$spId = [System.Environment]::GetEnvironmentVariable('AZURE_SUBSCRIPTION_ID')
$spKey = [System.Environment]::GetEnvironmentVariable('AZURE_SUBSCRIPTION_ID')

#Modules
Import-Module -Name "Az"
#Update-Module -Name "Az"

Import-Module -Name "Az.DataFactory"
#Update-Module -Name "Az.DataFactory"

Install-Module -Name "azure.datafactory.tools" -force
Import-Module -Name "azure.datafactory.tools"
Get-Module "*datafactory*"

#Login as a Service principal
if ($subscriptionId) {
    $passwd = ConvertTo-SecureString $spKey -AsPlainTest -Force
    $pscredential = New-Object System.Management.Automation.PSCredential($spId, $passwd)
    Connect-AzAccount -ServicePrincipal -Credential $pscredential - TenantId $tenantId | Out-Null
}
else {
     Get-AzContext
}
#Get Deploy Objects and Param Files
#$scriptPath = (Join-Path -Path (Get-Location) -ChildPath  "Pipeline.Workspace") 
$scriptPath = ((Get-Location))
$deploymentFilePath = $scriptPath 

Write-Host $scriptPath
#$yesNo = Write-Host -Prompt -Force "$scriptPath Y/N:"
#Write-Host -RootFolder "$scriptPath"
#$opt = New-AdfPublishOption

#$opt.CreateNewInstance = $true
#$opt.DeleteNotInSource = $false
#$opt.Excludes.Add("LinkedServices","")
#$opt.Excludes.Add("linkedService.*","")
#$opt.Excludes.Add("dataset.*","")
#$opt.Includes.Add()
#$opt.Excludes.Add("pipeline.SHIR_Test","")
#$opt.DoNotDeleteExcludedObjects = $false
$opt.StopStartTriggers = $true

Publish-AdfV2FromJson -RootFolder "$scriptPath" -ResourceGroupName "$resourceGroupName" -DataFactoryName "$dataFactoryName" -Location "$region" -Option $opt
