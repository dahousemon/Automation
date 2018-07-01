$gateway1 = Get-AzureRmVirtualNetworkGateway -Name VNet1GW -ResourceGroupName HouseTest99
$local = Get-AzureRmLocalNetworkGateway -Name Site1 -ResourceGroupName HouseTest99



New-AzureRmVirtualNetworkGatewayConnection -Name VNet1toSite1 -ResourceGroupName HouseTest99 `
-Location 'East US' -VirtualNetworkGateway1 $gateway1 -LocalNetworkGateway2 $local `
-ConnectionType IPsec -RoutingWeight 10 -SharedKey 'abc123'