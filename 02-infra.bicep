targetScope = 'resourceGroup'


module nsg './vnet/nsg.bicep' = {
  // scope: resourceGroup()
  params: {
    location: resourceGroup().location
  }
}

module vnet './vnet/vnet.bicep'= {
  name : 'myVNetModule'
  params: {
    vNet_Name: 'myVNet'
    location: resourceGroup().location
    vNet_AddressSpace: ['172.19.0.0/16']
    subnets: [
      {
        name: 'Subnet-0'
        addressPrefix: '172.19.1.0/24'
        networkSecurityGroupId: nsg.outputs.nsgId // Optional, can be omitted if not needed
      }
      {
        name: 'Subnet-1'
        addressPrefix: '172.19.2.0/24'
        networkSecurityGroupId: nsg.outputs.nsgId[1] // Optional, can be omitted if not needed
      }
    ]
  }
}
// az deployment group create --resource-group myRG --template-file 02-infra.bicep
// az deployment group delete -g myRG -n myVNetModule 
// az network vnet delete --resource-group myRG --name myVNet

// az deployment group create --resource-group myRG --template-file 02-infra.bicep --parameters param1=value1 param2=value2

// we need to define this `param deployModule string`
// az deployment group create --resource-group myRG --template-file main.bicep --parameters deployModule='app'



@description('Name of the AKS cluster')
param aks_name string = 'myaksCluster'
var my_aks_name = '${aks_name}-${resourceGroup().location}'

module aks './aks/aks.bicep' = {
  name: 'aksDeployment'
  scope: resourceGroup()
  params: {
    aks_name: aks_name
    location: resourceGroup().location
    ismanagedIdentityIdrequired: true
  
    identityConfiguration: {
      type: 'UserAssigned'
      userAssignedIdentities: {
        
      }
    }
    sshPublicKey: loadTextContent('./bicep.pub')
    subnetid: vnet.outputs.subnetIds[1].id
  }

}
//////////////////////////
output aksClusterName string = aks.outputs.aksClusterName
output aksClusterId string = aks.outputs.aksClusterId
output aksKubeConfig string = aks.outputs.kubeConfig

module vm './aks/vm.bicep' = {
  scope: resourceGroup()
  params: {
    location: resourceGroup().location
    name: 'BootstrapVM'
    adminPassword: 'HelloWorld@123!'
    adminUsername: 'adminUserName'
    vmSize: 'Standard_B1s'
    sshPublicKey: loadTextContent('./bicep.pub')
    subnetid: vnet.outputs.subnetIds[0].id

  }
  // dependsOn: [
  //   aks
  // ]
}

// param argocdValues string = loadFileAsBase64('./argocd-custom-values.yaml')
// resource aksCluster 'Microsoft.ContainerService/managedClusters@2024-07-01' existing = {
//   name: my_aks_name
//   scope: resourceGroup()
// }

// resource argocd 'Microsoft.KubernetesConfiguration/extensions@2024-11-01' = {
//   name: 'my-argocd-release'
//   scope: aksCluster
//   location: resourceGroup().location
//   properties: {
//     extensionType: 'helm'
//     releaseTrain: 'stable' // autoUpgradeMinorVersion: true --> No "version" property, if autoUpgradeMinorVersion: false, version: 'x.y.z'  // Specify exact version here
//     scope: {
//       cluster: {
//         releaseNamespace: 'argocd'
//       }
//     }
//     configurationProtectedSettings: {
//       kubeConfig: aks.outputs.kubeConfig
//     }
//     configurationSettings: {
//       chart: 'argo-cd'
//       repositoryUrl: 'https://argoproj.github.io/argo-helm'
//       releaseName: 'my-argocd-release'
//       version: '8.3.0'
//       namespace: 'argocd'
//     }
//     configurationSettingsFiles: {
//       'values.yaml': argocdValues
//     }
//   }
// }

// param nginxValues string = loadFileAsBase64('./ingress-nginx-values.yaml')
// resource nginx_ingress 'Microsoft.KubernetesConfiguration/extensions@2024-11-01' = {
//   name: 'my-nginx-release'
//   scope: aksCluster
//   location: resourceGroup().location
//   properties: {
//     extensionType: 'helm'
//     releaseTrain: 'stable'
//     scope: {
//       cluster: {
//         releaseNamespace: 'nginx'
//       }
//     }
//     configurationProtectedSettings: {
//       kubeConfig: aks.outputs.kubeConfig
//     }
//     configurationSettings: {
//       chart: 'ingress-nginx'
//       repositoryUrl: 'https://kubernetes.github.io/ingress-nginx'
//       releaseName: 'my-nginx-release'
//       version: '4.13.1'
//       namespace: 'nginx'
//     }
//     configurationSettingsFiles: {
//       'values.yaml': nginxValues
//     }
//   }
// }
