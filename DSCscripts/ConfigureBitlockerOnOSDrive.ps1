Configuration ConfigureBitlockerOnOSDrive

{

    Import-DscResource -Module xBitlocker



    Node "TestVM"

    {

        #First install the required Bitlocker features

        WindowsFeature BitlockerFeature

        {

            Name                 = 'Bitlocker'

            Ensure               = 'Present'

            IncludeAllSubFeature = $true

        }



        WindowsFeature BitlockerToolsFeature

        {

            Name                 = 'RSAT-Feature-Tools-Bitlocker'

            Ensure               = 'Present'

            IncludeAllSubFeature = $true

        }



      

    }

}



