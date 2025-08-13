

///////////////////
param location string = resourceGroup().location

param managed_identity_name string = 'myManagedIdentity'

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managed_identity_name
  location: location
}

@description('Name of the AKS cluster')
param aks_name string = 'myaksCluster'
var my_aks_name = '${aks_name}-${location}'

@description('SSH public key for the AKS cluster')
@minLength(1)
param sshPublicKey string

@description('Admin username for the AKS cluster')
param username string = 'adminUserName'

@description('Disk size (in GB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023. Specifying 0 will apply the default disk size for that agentVMSize.')
@minValue(0)
@maxValue(30720)
param osDiskSizeGB int = 30720

@description('The number of nodes for the cluster.')
@minValue(1)
@maxValue(50)
param agentCount int = 2

@description('The size of the Virtual Machine.')
param agentVMSize string = 'standard_d2s_v3'

@minValue(1)
@maxValue(250)
param maxPods int = 50

@description('The maximum number of pods that can run on each node in the agent pool.')
param agentPools array = [
  {
    name: 'agentpool'
    osDiskSizeGB: osDiskSizeGB
    count: agentCount
    maxCount: 2
    vmSize: agentVMSize
    osType: 'Linux'
    mode: 'System'
    maxPods: maxPods
    osDiskType: 'Ephemeral'
    enableEncryptionAtHost: true
    vnetSubnetID: ''
  }
]


resource aksCluster 'Microsoft.ContainerService/managedClusters@2025-05-01' = {
  name: my_aks_name
  location: location
  sku: {
    name: 'Basic'
    tier: 'Free'
  }

  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  
  properties: {
    kubernetesVersion: '1.31'
    dnsPrefix: 'aksdns'
    enableRBAC: true
    autoUpgradeProfile: {
      upgradeChannel: 'patch'
    }
    
    networkProfile: {
      networkPolicy: 'azure'
      loadBalancerSku: 'standard'
    }

    addonProfiles:{
      omsagent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: 'myLogAnalyticsWorkspaceResourceID'
        }
      }
      kubeDashboard: {
        enabled: false
      }
    }
   
    disableLocalAccounts: true

    agentPoolProfiles: agentPools

    linuxProfile: {
      adminUsername: username
      ssh: {
        publicKeys: [
          {
            keyData: sshPublicKey
          }
        ]
      }
    }
  }
}

// az deployment group create --resource-group myRG --template-file aks.bicep --parameters sshPublicKey="$(Get-Content -Raw .\aks_ssh_key.pub)"
