#-------------------------------------------------------------------------
# Microsoft Developer & Platform Evangelism
#
# Copyright (c) Microsoft Corporation. All rights reserved.
#
# THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
# EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED
#  WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
#-------------------------------------------------------------------------------
# The example companies, organizations, products, domain names,
# e-mail addresses, logos, people, places, and events depicted
# herein are fictitious. No association with any real company,
# organization, product, domain name, email address, logo, person,
# places, or events is intended or should be inferred.
#--------------------------------------------------------------------------

# This sample can be run using either the Azure Storage Emulator (Windows) or by
# updating the azure_config.rb file with your Storage account name and key.

# To run the sample using the Storage Emulator (default option):
# 1.Download and install the Azure Storage Emulator https://azure.microsoft.com/en-us/downloads/
# 2.Start the emulator (once only) by pressing the Start button or the Windows
#   key and searching for it by typing "Azure Storage Emulator". Select it from
#   the list of applications to start it.
# 3.Set breakpoints and run the project.

# To run the sample using the Storage Service
# 1.Open the azure_config.rb file and set IS_EMULATED to false
# 2.Create a Storage Account through the Azure Portal and set
# STORAGE_ACCOUNT_NAME and STORAGE_ACCOUNT_KEY in the azure_config.rb file.
# See https://azure.microsoft.com/en-us/documentation/articles/storage-create-storage-account/
# for more information
# 3.Set breakpoints and run the project.
#---------------------------------------------------------------------------

require 'openssl'
require 'azure/storage'
require './azure_config'
require './queues_basic'
require './queues_advanced'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

puts 'Azure Queue Storage samples for Ruby'

client = nil

if AzureConfig::IS_EMULATED
  client = Azure::Storage.client(use_development_storage: true)
else
  client = Azure::Storage.client(
    storage_account_name: AzureConfig::STORAGE_ACCOUNT_NAME,
    storage_access_key: AzureConfig::STORAGE_ACCOUNT_KEY
  )
end

# Basic Queue samples
puts '---------------------------------------------------------------'
puts 'Azure Queue samples'
queue_basic_samples = QueueBasicSamples.new
queue_basic_samples.run_all_samples(client)

# Advanced Queue samples
puts '---------------------------------------------------------------'
puts 'Azure Advanced Queue samples'
queue_advanced_samples = QueueAdvancedSamples.new
queue_advanced_samples.run_all_samples(client)