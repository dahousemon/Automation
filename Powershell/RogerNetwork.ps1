#Authenticate using Certificate
$TenantID = "26633ef6-38a7-478b-b705-03cbcf875ca7"
$AppID = "af5a9051-f0d1-49fd-9256-f402b486f72b"
$Thumbprint = (Get-ChildItem cert:\CurrentUser\My\ | Where-Object {$_.Subject -match "CN=houseScriptCert"}).Thumbprint

Login-AzureRmAccount -ServicePrincipal -CertificateThumbprint $Thumbprint `
-ApplicationId $AppID -TenantId $TenantID


New-AzureRmResourceGroup -Name TestRGRTH2 -Location 'WestUS'


$subnet1 = New-AzureRmVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -AddressPrefix 10.1.255.0/27
$subnet2 = New-AzureRmVirtualNetworkSubnetConfig -Name 'Frontend' -AddressPrefix 10.1.0.0/24


New-AzureRmVirtualNetwork -Name VNet1 -ResourceGroupName TestRGRTH2 `
-Location 'WestUS' -AddressPrefix 10.1.0.0/16 -Subnet $subnet1, $subnet2

New-AzureRmVirtualNetwork -Name VNet1 -ResourceGroupName TestRGRTH2 `
-Location 'WestUS' -AddressPrefix 10.1.0.0/16 -Subnet $subnet1, $subnet2


New-AzureRmVirtualNetwork -Name VNet1 -ResourceGroupName TestRGRTH2 `
-Location 'WestUS' -AddressPrefix 10.1.0.0/16 -Subnet $subnet1, $subnet2