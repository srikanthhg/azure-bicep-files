targetScope='subscription'

@description('resourceGroupName: Name of the resource group to create')
param resourceGroupName string

@description('resourceGroupLocation: Location for the resource group')
param resourceGroupLocation string

@description('The environment for the resource group, e.g., Production, Development')
param environment string = 'Development' // Default value, can be overridden
@description('Project name for the resource group')
param project string = 'MyProject' // Default value, can be overridden
@description('Owner of the resource group')
param owner string = 'YourName' // Default value, can be overridden
@description('Cost center for the resource group')
param costCenter string = '12345' // Default value, can be overridden
@description('Department for the resource group')
param department string = 'IT' // Default value, can be overridden
@description('Application name for the resource group')
param application string = 'MyApplication' // Default value, can be overridden
@description('Version of the resource group template')
param version string = '1.0' // Default value, can be overridden
@description('Created by information for the resource group')
param createdBy string = 'YourName' // Default value, can be overridden
@description('Updated by information for the resource group')
param updatedBy string = 'YourName' // Default value, can be overridden

@description('Tags for the resource group')
param tags object = {
  environment: environment
  project: project
  owner: owner
  costCenter: costCenter
  department: department
  application: application
  version: version
  createdBy: createdBy
  updatedBy: updatedBy

}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceGroupLocation
  tags: tags

//   tags: union({   user can add custom tags here, same as merge function in terraform
//   businessUnit: 'Finance'
//   priority: 'High'
// }, tags)

}

output resourceGroupId string = resourceGroup.id
