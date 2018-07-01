workflow TestConnection
{
    $Conn = Get-AutomationConnection -Name AzureRunAsConnection
Login-AzureRmAccount -ServicePrincipal -Tenant $Conn.TenantID -ApplicationId $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint
Stop-AzureRmVM -Name 'clduscentPOC000' -ResourceGroupName 'TestPOCRH000'
$foo = GET-AzureRMVm -Name 'clduscentPOC000' -ResourceGroupName 'TestPOCRH000'
write-output $foo
}