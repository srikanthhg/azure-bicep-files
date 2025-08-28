targetScope='subscription'

param resourceGroupName string = 'myRG'
param resourceGroupLocation string = 'eastus'

module rg './resourcegroup/resourcegroup.bicep' = {

params: {
  resourceGroupName: resourceGroupName
  resourceGroupLocation: resourceGroupLocation
  tags: {
    environment: 'Development'
    project: 'MyProject'
    owner: 'YourName'
    costCenter: '12345'
    department: 'IT'
    application: 'MyApplication'
    version: '1.0'
    createdBy: 'Srikanth'
    updatedBy: 'Srikanth'
  }
}
}
output resourceGroupId string = rg.outputs.resourceGroupId
// az deployment sub create --location eastus --template-file 01-main.bicep --what-if
// az group delete --name myRG --yes --no-wait

