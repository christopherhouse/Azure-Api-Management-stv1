param apimServiceName string
param location string
@allowed(['Developer', 'Premium'])
param skuName string = 'Developer'
param skuCapacity int = 1
param subnetResourceId string = ''
param provisionVnet bool = false
param publisherName string
param publisherEmail string

var vnetName = uniqueString(apimServiceName, 'vnet')

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01'= if (provisionVnet) {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }  
}

resource apimSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = if (provisionVnet) {
  name: 'apim-subnet'
  parent: vnet
  properties: {
    addressPrefix: '10.1.0.0/24'
  }
}

var subnet = provisionVnet ? apimSubnet.id : subnetResourceId

// Important:  To ensure this deploys on stv1, you MUST use Internal VNET mode and you 
// MUST NOT specify a public IP address for the APIM service.
resource apim 'Microsoft.ApiManagement/service@2023-03-01-preview' = {
  name: apimServiceName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: skuName
    capacity: skuCapacity
  }
  properties: {
    apiVersionConstraint: {
      minApiVersion: '2021-08-01'
    }
    publisherEmail: publisherEmail
    publisherName: publisherName
    virtualNetworkConfiguration: {
      subnetResourceId: subnet
    }
    virtualNetworkType: 'Internal'
  }
}
