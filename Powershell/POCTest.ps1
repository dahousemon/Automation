#Login into Azure
#Login-AzureRMAccount

#Authenticate using Certificate
$TenantID = "26633ef6-38a7-478b-b705-03cbcf875ca7"
$AppID = "af5a9051-f0d1-49fd-9256-f402b486f72b"
$Thumbprint = (Get-ChildItem cert:\CurrentUser\My\ | Where-Object {$_.Subject -match "CN=houseScriptCert"}).Thumbprint

Login-AzureRmAccount -ServicePrincipal -CertificateThumbprint $Thumbprint `
-ApplicationId $AppID -TenantId $TenantID



# Need to ask for Azure Subsciption name
$subscr="Visual Studio Enterprise"
Get-AzureRmSubscription -SubscriptionName $subscr | Select-AzureRmSubscription

#TestNumber

$testnum = "24"

#Create Azure Resource Group
#NEED Ask Resource Group Name 
$rgName= "TestPOCRH" + $testnum



write-host $rgName

#NEED Ask Resroucue Group Location
$locName="WestUS"
New-AzureRMResourceGroup -Name $rgName -Location $locName

$localNetworkGatewayName = "POC1test_VPN_IP" + $testnum
$localNetworkGatewayConnection = "POC1test_VPN" + $testnum
$pipName = "clduscentPOCdc1-ip" + $testnum
$networkinterface = "clduscentpocdc1230" + $testnum







#Create VM
$vmDCName = "clduscentPOC" + $testnum
$vnName = "Centeral_US_Region_Network" + $testnum
$vnSubnetName = "TMI_Subnet" + $testnum
$vmPublicIPname= "clduscentPOCDC1-IP" + $testnum


$cred=Get-Credential -Message "Type the name and password of the local administrator account."

New-AzureRmVm  `
    -Name $vmDCName `
    -Location $locName `
    -VirtualNetworkName $vnName `
    -SubnetName $vnSubnetName `
    -PublicIpAddressName $vmPublicIPname `
    -OpenPorts 3389 `
    -Credential $cred `
    -ImageName "MicrosoftWindowsServer:WindowsServer:2016-Datacenter-with-Containers:latest" `
    -ResourceGroupName $rgName `
    -size "Standard_A1"
    
    
    #Local Network Gateway
 New-AzureRmLocalNetworkGateway -Name $localNetworkGatewayName -ResourceGroupName $rgName `
-Location $locName -GatewayIpAddress '225.36.12.24' -AddressPrefix '192.168.1.0/27'



#Create New Virtal Network
$vrNWname = "VirtualNetwork" + $testnum

New-AzureRmVirtualNetwork -Name $vrNWname -Location $locName -ResourceGroupName $rgName -AddressPrefix '10.0.0.0/16'



   #Connect VPN to Local NetworkGateway
$foo = Get-AzureRmLocalNetworkGateway -Name $localNetworkGatewayName -ResourceGroupName $rgName
$foo2 = Get-AzureRmVirtualNetworkGateway -Name $vnName -ResourceGroupName $rgName

New-AzureRmVirtualNetworkGatewayConnection -Name $localNetworkGatewayConnection -ResourceGroupName $rgName `
-Location $locName -VirtualNetworkGateway1 $foo2 -LocalNetworkGateway2 $foo `
-ConnectionType IPsec -RoutingWeight 10 -SharedKey 'GoodMorning'



Set-AzureRmVMExtension -ResourceGroupName $rgName -Location $locName `
 -extensiontype "NetworkWatcherAgentWindows"  `
 -name "NetworkWatcherAgentWindows" `
 -Publisher "Microsoft.Azure.NetworkWatcher" `
 -TypeHandlerVersion "1.0" `
 -Settings @{"workspaceId" = "WorkspaceID"} `
 -VMName $vmDCName `
 -ProtectedSettings @{"workspaceKey"= "workspaceID"}