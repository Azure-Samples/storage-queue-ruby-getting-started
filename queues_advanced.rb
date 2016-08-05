#-------------------------------------------------------------------------------
# Microsoft Developer & Platform Evangelism
#
# Copyright (c) Microsoft Corporation. All rights reserved.
#
# THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
# EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
#-------------------------------------------------------------------------------
# The example companies, organizations, products, domain names,
# e-mail addresses, logos, people, places, and events depicted
# herein are fictitious.  No association with any real company,
# organization, product, domain name, email address, logo, person,
# places, or events is intended or should be inferred.
#-------------------------------------------------------------------------------

# -------------------------------------------------------------
# Azure Queue Service Sample - The Queue Service provides reliable messaging for
# workflow processing and for communication between loosely coupled components
# of cloud services. This sample demonstrates how to perform common tasks
# including inserting, peeking, getting and deleting queue messages, as well as
# creating and deleting queues.
#
# Documentation References:
# - What is a Storage Account - http://azure.microsoft.com/en-us/documentation/articles/storage-whatis-account/
# - Getting Started with Queues - https://azure.microsoft.com/en-us/documentation/articles/storage-ruby-how-to-use-queue-storage/
# - Queue Service Concepts - http://msdn.microsoft.com/en-us/library/dd179353.aspx
# - Queue Service REST API - http://msdn.microsoft.com/en-us/library/dd179363.aspx
# - Queue Service Ruby API - http://azure.github.io/azure-storage-ruby/
# - Storage Emulator - http://msdn.microsoft.com/en-us/library/azure/hh403989.aspx
# </summary>
# -------------------------------------------------------------

require './random_string'

class QueueAdvancedSamples
  def run_all_samples(client)
    queue_service = Azure::Storage::Queue::QueueService.new(client: client)

    puts "\n\n* List queues *\n"
    list_queues(queue_service)

    puts "\n\n* Set Cors *\n"
    cors_rules(queue_service)

    puts "\n\n* Queue Metadata *\n"
    queue_metadata(queue_service)

    puts "\n\n* Service Properties *\n"
    service_properties(queue_service)

    puts "\n\nAzure Queue Advanced samples - Completed"

  rescue Azure::Core::Http::HTTPError => ex
    if AzureConfig::IS_EMULATED
      puts 'Error occurred in the sample. If you are using the emulator, '\
      "please make sure the emulator is running. #{ex}"
    else
      puts 'Error occurred in the sample. Please make sure the account name'\
      " and key are correct. #{ex}"
    end
  end

  def list_queues(queue_service)
    queue_prefix = 'queue-' + RandomString.random_name

    puts "Create multiple queues with prefix #{queue_prefix}"

    for i in 0..4
      queue_service.create_queue(queue_prefix + i.to_s)
    end

    puts "List queues with prefix: #{queue_prefix}"

    queues = queue_service.list_queues(queue_prefix: queue_prefix)

    queues.each do |queue|
      puts "Queue name #{queue.name}"
    end

    puts "Delete queues with prefix #{queue_prefix}"
    for i in (0..4)
      queue_service.delete_queue(queue_prefix + i.to_s)
    end

    puts 'List queues sample completed'
  end

  def cors_rules(queue_service)
    cors_rule = Azure::Storage::Service::CorsRule.new
    cors_rule.allowed_origins = ['*']
    cors_rule.allowed_methods = %w(POST GET)
    cors_rule.allowed_headers = ['*']
    cors_rule.exposed_headers = ['*']
    cors_rule.max_age_in_seconds = 3600

    puts 'Get Cors Rules'

    original_service_properties = queue_service.get_service_properties

    print 'Overwrite Cors Rules'

    service_properties = Azure::Storage::Service::StorageServiceProperties.new
    service_properties.cors.cors_rules = [cors_rule]

    queue_service.set_service_properties(service_properties)

    puts 'Revert Cors Rules back the original ones'
    # reverting cors rules back to the original ones
    queue_service.set_service_properties(original_service_properties)

    puts 'CORS sample completed'
  end

  def queue_metadata(queue_service)
    queue_name = 'queue' + RandomString.random_name

    puts 'Create queue'
    queue_service.create_queue(queue_name)

    metadata = { 'MetadataKey1' => 'MetaDataValue1',
                 'MetadataKey2' => 'MetaDataValue2' }

    puts 'Set queue metadata'
    queue_service.set_queue_metadata queue_name, metadata

    puts 'Get queue metadata'
    result = queue_service.get_queue_metadata queue_name

    puts "Metadata:\n"
    result[1].each do |key, value|
      puts "#{key}: #{value}\n"
    end

    puts 'Delete queue'
    queue_service.delete_queue(queue_name)

    puts 'Queue metadata sample completed'
  end

  def service_properties(queue_service)
    # get service properties
    puts 'Get Service Properties'

    original_properties = queue_service.get_service_properties

    # set service properties
    puts 'Overwrite Service Properties'

    properties = Azure::Storage::Service::StorageServiceProperties.new
    properties.logging.delete = true
    properties.logging.read = true
    properties.logging.write = true
    properties.logging.retention_policy.enabled = true
    properties.logging.retention_policy.days = 10

    queue_service.set_service_properties properties

    # reverting service properties back to the original ones
    puts 'Revert Service Properties back the original ones'
    queue_service.set_service_properties original_properties

    puts 'Service Properties sample completed'
  end
end
