# Create a Data Factory
resource "azurerm_data_factory" "adf" {
  name                = var.adf_name
  location            = var.location
  resource_group_name = var.resource_group_name

  identity {
    type = "SystemAssigned"
  }
}




# Create a storage account
data "azurerm_storage_account" "source_folder_storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
}


# Create a storage account
data "azurerm_storage_account" "destination_folder_storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
}



# Create a linked service for Azure Blob Storage
resource "azurerm_data_factory_linked_service_azure_blob_storage" "source" {
  name                = "source-storage"
  #resource_group_name = azurerm_resource_group.example.name
  #data_factory_name   = azurerm_data_factory.example.name
  data_factory_id = azurerm_data_factory.adf.id
  connection_string   = data.azurerm_storage_account.source_folder_storage.primary_connection_string
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "destination" {
  name                = "destination-storage"
  #resource_group_name = azurerm_resource_group.example.name
 # data_factory_name   = azurerm_data_factory.example.name
  data_factory_id = azurerm_data_factory.adf.id
  connection_string   = data.azurerm_storage_account.destination_folder_storage.primary_connection_string
}



# source and sink dataset 


# Create a dataset for Azure Blob Storage
resource "azurerm_data_factory_dataset_binary" "source_dataset" {
  name                = "source_dataset"
  data_factory_id     = azurerm_data_factory.adf.id
 # resource_group_name = azurerm_resource_group.example.name
#  data_factory_name   = azurerm_data_factory.example.name
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.source.name


  sftp_server_location {
    filename = "test.txt"
    path = "source"
  }
}

resource "azurerm_data_factory_dataset_binary" "destination_dataset" {
  name                = "destination_dataset"
  data_factory_id     = azurerm_data_factory.adf.id
  #resource_group_name = azurerm_resource_group.example.name
#  data_factory_name   = azurerm_data_factory.example.name
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.destination.name



  sftp_server_location {
    filename = "test-${formatdate("YYYY-MM-DD-hh-mm-ss", timestamp())}.txt"
    path = "destination"
  }
}

# Create a pipeline
resource "azurerm_data_factory_pipeline" "copy_data" {
  name            = "copy_data_pipeline"
  data_factory_id = azurerm_data_factory.adf.id
  activities_json = jsonencode([
    {
      name = "CopyFromSourceToDestination"
      type = "Copy"
      inputs = [
        {
          referenceName = "source_dataset"
          type          = "DatasetReference"
        }
      ]
      outputs = [
        {
          referenceName = "destination_dataset"
          type          = "DatasetReference"
        }
      ]
      typeProperties = {
        source = {
          type      = "BinarySource"
          recursive = true
        }
        sink = {
          type = "BinarySink"
        }
        enableStaging = false
      }
      policy = {
        timeout                = "7.00:00:00"
        retry                  = 0
        retryIntervalInSeconds = 30
        secureOutput           = false
        secureInput            = false
      }
    }
  ])

  depends_on = [
    azurerm_data_factory_dataset_binary.source_dataset,
    azurerm_data_factory_dataset_binary.destination_dataset
  ]
}