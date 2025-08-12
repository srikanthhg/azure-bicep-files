module rg 'br:github.com/srikanthhg/azure_bicep_modules.github.io/resource-group/resourceGroup.bicep:main' = {
  name: 'createRG'
  params: {
    resourceGroupName: 'myRG'
    resourceGroupLocation: 'westeurope'
    // other params...
  }
}
