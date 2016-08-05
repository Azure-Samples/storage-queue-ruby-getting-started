---
services: storage
platforms: ruby
author: pcibraro
---

# Azure Storage: Getting Started with Azure Storage in Ruby
Samples documenting basic operations with Azure Queue storage services in Ruby. 

## Running this sample
This sample can be run using either the Azure Storage Emulator (Windows) or by using your Azure Storage account name and key. Please update the azure_config.ruby file with the appropriate properties.

To run the sample using the Storage Emulator:
1. Download and install the Azure Storage Emulator https://azure.microsoft.com/en-us/downloads/ 
2. Start the emulator (once only) by pressing the Start button or the Windows key and searching for it by typing "Azure Storage Emulator". Select it from the list of applications to start it.
3. Run the project. 

To run the sample using the Storage Service
1. Open the azure_config.rb file and set the config setting IS_EMULATED to false. Also configure the settings STORAGE_ACCOUNT_NAME and STORAGE_ACCOUNT_KEY with the account name and account key from your subscription. See https://azure.microsoft.com/en-us/documentation/articles/storage-create-storage-account/ for more information
3.Set breakpoints and run the project. 

## Deploy this sample 

Either fork the sample to a local folder or download the zip file from https://github.com/Azure-Samples/storage-queue-ruby-getting-started/

To get the source code of the SDK via git, type:
git clone git://github.com/Azure-Samples/storage-queue-ruby-getting-started.git
cd .\storage-queue-ruby-getting-started

##Minimum Requirements
Ruby 2.0, 2.1, or 2.2.
To install Ruby, please go to https://www.ruby-lang.org

## More information
  - What is a Storage Account - http://azure.microsoft.com/en-us/documentation/articles/storage-whatis-account/  
  - Getting Started with Queues - https://azure.microsoft.com/en-us/documentation/articles/storage-ruby-how-to-use-queue-storage/
  - Queue Service Concepts - http://msdn.microsoft.com/en-us/library/dd179353.aspx
  - Queue Service REST API - http://msdn.microsoft.com/en-us/library/dd179363.aspx
  - Queue Service Ruby API - http://azure.github.io/azure-storage-ruby/
  - Storage Emulator - http://azure.microsoft.com/en-us/documentation/articles/storage-use-emulator/