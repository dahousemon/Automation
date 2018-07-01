#Login into Azure
#Login-AzureRMAccount


#Authenticate using Certificate
$TenantID = "26633ef6-38a7-478b-b705-03cbcf875ca7"
$AppID = "639f803f-8af9-47fd-bf21-030c71cdf9ed"
$Thumbprint = (Get-ChildItem cert:\CurrentUser\My\ | Where-Object {$_.Subject -match "CN=houseScriptCert2"}).Thumbprint

Login-AzureRmAccount -ServicePrincipal -CertificateThumbprint $Thumbprint `
-ApplicationId $AppID -TenantId $TenantID

# Need to ask for Azure Subsciption name
$subscr="Visual Studio Enterprise"
Get-AzureRmSubscription -SubscriptionName $subscr | Select-AzureRmSubscription


$vmos = Read-Host -Prompt "Type Of OS.  0 = 2016 DataCenter / 1 = 2008-R2-SP1 "

$testnum = Read-Host -Prompt "Test Number Identifier "





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



switch ($vmos) {

0 {$useimage = "MicrosoftWindowsServer:WindowsServer:2016-Datacenter-with-Containers:latest" }
1 {$useimage = "MicrosoftWindowsServer:WindowsServer:2008-R2-SP1:latest" }



}






New-AzureRmVm  `
    -Name $vmDCName `
    -Location $locName `
    -VirtualNetworkName $vnName `
    -SubnetName $vnSubnetName `
    -PublicIpAddressName $vmPublicIPname `
    -OpenPorts 3389 `
    -ImageName $useimage `
    -ResourceGroupName $rgName `
    -size "Standard_A1" `
    -Credential $cred
 
  
    #-Credential $cred `

   #-ImageName "MicrosoftWindowsServer:WindowsServer:2016-Datacenter-with-Containers:latest" `

   
    #Local Network Gateway
 New-AzureRmLocalNetworkGateway -Name $localNetworkGatewayName -ResourceGroupName $rgName `
-Location $locName -GatewayIpAddress '225.36.12.24' -AddressPrefix '192.168.1.0/27'

<# 

#Create New Virtal Network
$vrNWname = "VirtualNetwork" + $testnum

#New-AzureRmVirtualNetwork -Name $vrNWname -Location $locName -ResourceGroupName $rgName -AddressPrefix '10.0.0.0/16'
$ngwpip = New-AzureRMPublicIpAddress -Name ngwpip -ResourceGroupName $rgName -Location $locName  -AllocationMethod Dynamic
$ngwipconfig = New-AzureRMVirtualNetworkGatewayIpConfig -Name ngwipconfig -SubnetId $subnet.Id -PublicIpAddressId $ngwpip.Id
$newvnetgateway = New-AzureRmVirtualNetworkGateway -Name myNGW -ResourceGroupName $rgName -Location $locName  -IpConfigurations $ngwIpConfig  -GatewayType "Vpn" -VpnType "RouteBased" -GatewaySku "Basic"



   #Connect VPN to Local NetworkGateway
$foo = Get-AzureRmLocalNetworkGateway -Name $localNetworkGatewayName -ResourceGroupName $rgName
$foo2 = Get-AzureRmVirtualNetworkGateway -Name $vnName -ResourceGroupName $rgName

New-AzureRmVirtualNetworkGatewayConnection -Name $localNetworkGatewayConnection -ResourceGroupName $rgName `
-Location $locName -VirtualNetworkGateway1 $foo2 
-ConnectionType IPsec -RoutingWeight 10 -SharedKey 'GoodMorning'

#>

Set-AzureRmVMExtension -ResourceGroupName $rgName -Location $locName `
 -extensiontype "NetworkWatcherAgentWindows"  `
 -name "NetworkWatcherAgentWindows" `
 -Publisher "Microsoft.Azure.NetworkWatcher" `
 -TypeHandlerVersion "1.0" `
 -Settings @{"workspaceId" = "WorkspaceID"} `
 -VMName $vmDCName `
 -ProtectedSettings @{"workspaceKey"= "workspaceID"}



 #Encrypt VM Disk that was just created.
 $encryptVaultName = "VauktPOCRH111"
 #$aadAppName = ( Get-AzureADApplication -SearchString 'housescripting')


 #Get the Vault for Encryption
 Get-AzureKeyVaultKey –VaultName 'VauktPOCRH111'


#Get service Principals
#$SvcPrincipals = (Get-AzureRmADServicePrincipal -SearchString $aadAppName)

<#

 # Define required information for our Key Vault and keys
$keyVault = Get-AzureRmKeyVault -VaultName $keyVaultName -ResourceGroupName $rgName;
$diskEncryptionKeyVaultUrl = $keyVault.VaultUri;
$keyVaultResourceId = $keyVault.ResourceId;
$keyEncryptionKeyUrl = (Get-AzureKeyVaultKey -VaultName $keyVaultName -Name "myKey").Key.kid;

 #Encrypt VM Disk
 Set-AzureRmVMDiskEncryptionExtension `
    -ResourceGroupName $rgName `
    -VMName $vmDCName `
    -AadClientID $app.ApplicationId `
    -DiskEncryptionKeyVaultUrl $diskEncryptionKeyVaultUrl `
    -DiskEncryptionKeyVaultId $keyVaultResourceId `
    -KeyEncryptionKeyUrl $keyEncryptionKeyUrl `
   
   #>

    #   -AadClientSecret $securePassword `