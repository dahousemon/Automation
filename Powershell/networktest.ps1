

Login-AzureRmAccount 

Get-AzureRmSubscription -SubscriptionId "e30f6c19-1499-4b61-ad0c-730cb9faed54"

Set-AzureSubscription -SubscriptionId "e30f6c19-1499-4b61-ad0c-730cb9faed54"

Get-AzureRmResourceGroup -Verbose


$gateway1 = Get-AzureRmVirtualNetworkGateway -Name myNGW -ResourceGroupName "HouseTest99"
$gateway2 = Get-AzureRmVirtualNetworkGateway -Name vnet-gateway -ResourceGroupName "HouseTest99"


New-AzureRmVirtualNetworkGatewayConnection -Name VNet1toSite1 -ResourceGroupName HouseTest99 `
-Location 'West US' -VirtualNetworkGateway1 $gateway1 -VirtualNetworkGateway2  $gateway2 `
-ConnectionType IPsec -RoutingWeight 10 -SharedKey 'abc123'

