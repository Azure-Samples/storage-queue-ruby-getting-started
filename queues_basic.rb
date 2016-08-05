#-------------------------------------------------------------------------------
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

# Queue Basic Samples
class QueueBasicSamples
  def run_all_samples(client)
    queue_service = Azure::Storage::Queue::QueueService.new(client: client)

    puts "\n\n* Basic queue operations *\n"
    basic_queue_operations(queue_service)

    puts "\n\n* Basic message operations *\n"
    basic_message_operations(queue_service)

    puts "\n\nAzure Queue samples - Completed"

  rescue Azure::Core::Http::HTTPError => ex
    if AzureConfig::IS_EMULATED
      puts 'Error occurred in the sample. If you are using the emulator, '\
      "please make sure the emulator is running. #{ex}"
    else
      puts 'Error occurred in the sample. Please make sure the account name'\
      " and key are correct. #{ex}"
    end
  end

  def basic_queue_operations(queue_service)
    queue_prefix = 'queue-' + RandomString.random_name

    puts "Create multiple queues with prefix #{queue_prefix}"

    for i in 0..5
      queue_service.create_queue(queue_prefix + i.to_s)
    end

    puts "List queues with prefix #{queue_prefix}"
    queues = queue_service.list_queues(prefix: queue_prefix)

    queues.each do |queue|
      puts "  queue: #{queue.name}"
    end

    puts "Delete queues with prefix #{queue_prefix}"
    for i in 0..5
      queue_service.delete_queue(queue_prefix + i.to_s)
    end
  end

  def basic_message_operations(queue_service)
    queue_name = 'queue-' + RandomString.random_name

    puts "Create queue with name #{queue_name}"
    queue_service.create_queue(queue_name)

    # Add a number of messages to the queue.
    # if you do not specify time_to_live, the message will expire after 7 days
    # if you do not specify visibility_timeout, the message will be immediately
    # visible
    message = 'test message '
    for i in 1..10
      queue_service.create_message(queue_name, message + i.to_s)
      puts 'Successfully added message: ' + message + i.to_s
    end

    puts "Get number of messages in the queue #{queue_name}"
    # Get length of queue
    # Retrieve queue metadata which contains the approximate message count
    # ie.. length.
    # Note that this may not be accurate given dequeueing operations that could
    # be happening in parallel
    result = queue_service.get_queue_metadata(queue_name)

    puts "Approximate length of the queue: #{result[0]}"

    puts 'Peek first message from queue without changing visibility'
    # Look at the first message without dequeueing it
    messages = queue_service.peek_messages(queue_name)
    messages.each do |msg|
      puts "Peeked message content is: #{msg.message_text}"
    end

    puts 'Peek first messages from queue without changing visibility'
    # Look at the first 5 messages without dequeueing it
    messages = queue_service.peek_messages(queue_name, number_of_messages: 5)
    messages.each do |msg|
      puts "Peeked message content is: #{msg.message_text}"
    end

    messages = queue_service.list_messages(queue_name, 60)
    messages.each do |msg|
      puts "Dequeued message content is: #{msg.message_text}"

      # Then delete it.
      # Delete requires the message id and pop receipt returned by get_messages
      # Attempt for 60 seconds. Timeout if it does not complete by that time.
      queue_service.delete_message(queue_name, msg.id, msg.pop_receipt)
      puts 'Successfully dequeued message'
    end

    # Clear out all messages from the queue
    queue_service.clear_messages(queue_name)
    puts 'Successfully cleared out all queue messages'

    puts "Delete queue with name #{queue_name}"
    queue_service.delete_queue(queue_name)
  end
end
