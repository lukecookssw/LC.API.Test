param projectName string
param location string = resourceGroup().location
param environment string

param keyVaultName string

param sqlAdministratorsLoginName string
param sqlAdministratorsObjectId string

param databaseSku object = {
  name: 'Basic'
}

param databaseProperties object = {
  collation: 'SQL_Latin1_General_CP1_CI_AS'
  maxSizeBytes: 2 * 1073741824 // 2GB
}

param now string 

var sqlserverName = 'sql-${projectName}-${environment}'
var databaseName = 'db-${projectName}-${environment}'
var sqlAdministratorLogin = '${projectName}-${environment}-admin'
var sqlAdministratorLoginPassword = guid(sqlserverName, databaseName, now)

resource sqlServer 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: sqlserverName
  location: location
  properties: {
    administratorLogin: sqlAdministratorLogin
    administratorLoginPassword: sqlAdministratorLoginPassword
    administrators: {
      administratorType: 'ActiveDirectory'
      login: sqlAdministratorsLoginName
      sid: sqlAdministratorsObjectId
      tenantId: tenant().tenantId
      principalType: 'Group'
      azureADOnlyAuthentication: false
    }
    version: '12.0'
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  parent: sqlServer
  name: databaseName
  location: location
  sku: databaseSku
  properties: databaseProperties
}

resource allowAllWindowsAzureIps 'Microsoft.Sql/servers/firewallRules@2021-02-01-preview' = {
  parent: sqlServer
  name: 'AllowAllWindowsAzureIps'
  properties: {
    endIpAddress: '0.0.0.0'
    startIpAddress: '0.0.0.0'
  }
}

module connectionStringSecret 'create-secrets.bicep' = {
  name: 'connectionStringSecret-${now}'
  params:{
    keyVaultName: keyVaultName
    secretName: 'SqlConnectionString'
    secretValue: 'Server=tcp:${sqlServer.properties.fullyQualifiedDomainName},1433;Initial Catalog=${databaseName};Persist Security Info=False;User ID=${sqlAdministratorLogin};Password=${sqlAdministratorLoginPassword};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'
  }
}
