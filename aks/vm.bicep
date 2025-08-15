@description('location for the VM')
param location string

// resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' = {
//   name: 'bootstrapvmstorageacc'
//   location: location
//   kind: 'Storage'

//   sku: {
//     name: 'Standard_LRS'
//   }
// }



//////////////////////////////


///////////////////////////////////


param publicIPAllocationMethod string = 'Static'

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: 'BootstrapVM-PIP'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: publicIPAllocationMethod
    dnsSettings: {
      domainNameLabel: 'bootstrapvm-${uniqueString(resourceGroup().id)}'
    }
  }
}


/////////////////////////////

param subnetid string

resource networkInterface 'Microsoft.Network/networkInterfaces@2024-07-01' = {
  name: 'BootstrapVMNIC'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          publicIPAddress: {
            id: publicIPAddress.id // Replace with actual public IP address resource ID if needed
          }
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetid
          }
        }
      }
    ]
  }
}



/////////////////////


@description('Name of VM')
param name string = 'BootstrapVM'

@description('Password for the Virtual Machine.')
@minLength(5)
@secure()
param adminPassword string

@description('Admin username for the Virtual Machine')
param adminUsername string = 'adminUserName'

@description('Allowed VM sizes for the Virtual Machine')
@allowed([
  'Standard_B1s'
  'Standard_B1ms'
])
param vmSize string = 'Standard_B1s'

@description('SSH public key for the Virtual Machine')
param sshPublicKey string

resource ubuntuVM 'Microsoft.Compute/virtualMachines@2024-11-01' = {
  name: name
  location: location
  
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }

    osProfile: {
      customData: loadFileAsBase64('bootstrap.sh')
      computerName: 'computerName'
      adminUsername: adminUsername
      adminPassword: adminPassword
      linuxConfiguration: {
        disablePasswordAuthentication: false
        ssh: {
          publicKeys: [
            {
              path: '/home/${adminUsername}/.ssh/authorized_keys'
              keyData: sshPublicKey // Use the SSH public key parameter if needed
            }
          ]
        }
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts'
        version: 'latest'
      }
      osDisk: {
        name: 'BootstrapVMOsDisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
    // diagnosticsProfile: {
    //   bootDiagnostics: {
    //     enabled: true
    //     storageUri: storageAccount.properties.primaryEndpoints.blob
    //   }
    // }
  }
}

