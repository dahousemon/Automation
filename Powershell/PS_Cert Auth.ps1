Login-AzureRmAccount

#Create a certificate and create the service Principal
$cert = New-SelfSignedCertificate -CertStoreLocation "Cert:\CurrentUser\My" `
-subject "CN=houseScriptCert2" -KeySpec KeyExchange
$KeyVaule = [System.Convert]::ToBase64String($cert.GetRawCertData())

$sp = New-AzureRMADServicePrincipal -DisplayName housescripting -CertValue $KeyVaule `
-EndDate $cert.NotAfter -StartDate $cert.NotBefore

Sleep 30
New-AzureRmRoleAssignment -RoleDefinitionName Contributor -ServicePrincipalName $sp.ApplicationId



#Authenticate using Certificate
$TenantID = "26633ef6-38a7-478b-b705-03cbcf875ca7"
$AppID = "639f803f-8af9-47fd-bf21-030c71cdf9ed"
$Thumbprint = (Get-ChildItem cert:\CurrentUser\My\ | Where-Object {$_.Subject -match "CN=houseScriptCert2"}).Thumbprint

Login-AzureRmAccount -ServicePrincipal -CertificateThumbprint $Thumbprint `
-ApplicationId $AppID -TenantId $TenantID

