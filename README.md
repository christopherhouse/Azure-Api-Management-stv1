# 🚀 Deploying Azure API Management on stv1 Compute Platform
On Aug. 31, 2024, the stv1 version of Azure API Management's compute platform is being retired.  Customers who have not migrated to stv2 by this date may face outages.  As you work to prepare for the migration, you may find it useful to be able to deploy stv1 APIM resources so you can test your migration strategy.  While it is no longer possible to provision an stv1 resource in the Azure portal, it is possible with ARM/Bicep.  When you create your template, you **must** configure your APIM resource to use Internal vnet mode and you **must not** assign a public IP address to the APIM resource.  The Bicep template in this repo will help you deploy an stv1 APIM resource in a VNet.  You can optionally provide an existing subnet or have the template create a new vnet/subnet.

**Caveat**: While this loophole to provision stv1 compute works today, I don't have any insight how much longer it will work.

## 🏗️ Azure Resources

The Bicep template will deploy the following Azure resources:

- Azure API Management (APIM) service
- Virtual Network (VNet) and Subnet (optional)

## 📝 How to Use

You can deploy the Bicep template using Azure CLI or PowerShell.

### Azure CLI

```bash
az deployment group create --name ExampleDeployment --resource-group ExampleGroup --template-file ./infrastructure/main.bicep --parameters apimServiceName=ExampleAPIM location=westus2 skuName=Developer skuCapacity=1 subnetResourceId=/subscriptions/subId/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/subnet provisionVnet=false publisherName=ExamplePublisher publisherEmail=example@example.com
```

### PowerShell

```powershell
New-AzResourceGroupDeployment -Name ExampleDeployment -ResourceGroupName ExampleGroup -TemplateFile ./infrastructure/main.bicep -apimServiceName ExampleAPIM -location westus2 -skuName Premium -skuCapacity 3 -provisionVnet $true -publisherName ExamplePublisher -publisherEmail example@example.com
```

## 📚 Parameters

| Parameter | Description | Default |
| --- | --- | --- |
| `apimServiceName` | The name of the APIM service. | |
| `location` | The location of the resources. | |
| `skuName` | The pricing tier of the APIM service. Allowed values: 'Developer', 'Premium'. | 'Developer' |
| `skuCapacity` | The capacity of the APIM service.  Only applicable for Premium SKU. | 1 |
| `subnetResourceId` | The resource ID of the subnet. Do not set this parameter if you set `provisionVnet` to `true`| '' |
| `provisionVnet` | Whether to provision a new VNet and subnet. | false.  Do not set this to `true` if you provide a value for `subnetResourceId`|
| `publisherName` | The name of the publisher. | |
| `publisherEmail` | The email of the publisher. | |

## 📜 License

This project is licensed under the MIT License - see the [`LICENSE`](command:_github.copilot.openRelativePath?%5B%22LICENSE%22%5D "LICENSE") file for details.
