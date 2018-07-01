#Authenticate using Certificate
$TenantID = "26633ef6-38a7-478b-b705-03cbcf875ca7"
$AppID = "af5a9051-f0d1-49fd-9256-f402b486f72b"
$Thumbprint = (Get-ChildItem cert:\CurrentUser\My\ | Where-Object {$_.Subject -match "CN=houseScriptCert"}).Thumbprint

Login-AzureRmAccount -ServicePrincipal -CertificateThumbprint $Thumbprint `
-ApplicationId $AppID -TenantId $TenantID


$rgName = "HouseTest99"
$locName = "West US"
$VNetName = "Centeral_US_Region_Network"
$localNetworkGatewayConnection = "FooConnect"
$localNetworkGatewayName = "localVnet"

New-AzureRmResourceGroup -Location $locName -Name $rgName

$subnet = New-AzureRMVirtualNetworkSubnetConfig -Name 'gatewaysubnet' -AddressPrefix '10.254.0.0/27'

$ngwpip = New-AzureRMPublicIpAddress -Name ngwpip -ResourceGroupName $rgName -Location $locName  -AllocationMethod Dynamic
$vnet = New-AzureRmVirtualNetwork -AddressPrefix "10.254.0.0/27" -Location $locName  -Name vnet-gateway -ResourceGroupName $rgName -Subnet $subnet
$subnet = Get-AzureRmVirtualNetworkSubnetConfig -name 'gatewaysubnet' -VirtualNetwork $vnet
$ngwipconfig = New-AzureRMVirtualNetworkGatewayIpConfig -Name ngwipconfig -SubnetId $subnet.Id -PublicIpAddressId $ngwpip.Id

$newvnetgateway = New-AzureRmVirtualNetworkGateway -Name myNGW -ResourceGroupName $rgName -Location $locName  -IpConfigurations $ngwIpConfig  -GatewayType "Vpn" -VpnType "RouteBased" -GatewaySku "Basic"

 
 #Local Network Gateway
 New-AzureRmLocalNetworkGateway -Name $localNetworkGatewayName -ResourceGroupName $rgName `
-Location $locName -GatewayIpAddress '225.36.12.24' -AddressPrefix '192.168.1.0/27'


New-AzureRmVirtualNetworkGatewayConnection -Name $localNetworkGatewayConnection -ResourceGroupName $rgName `
-Location $locName -VirtualNetworkGateway1 $newvnetgateway -LocalNetworkGateway2 $localNetworkGatewayName `
-ConnectionType IPsec -RoutingWeight 10 -SharedKey 'GoodMorning'
