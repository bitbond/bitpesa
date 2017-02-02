require "base64"

module BitPesa

  class Api

    class << self

      # Documents

      def get_document id
        BitPesa::Client.get("/documents/#{id}")
      end

      def upload_document file_content, **options
        BitPesa::Client.post("/documents", {document: encode_document(file_content, options)})
      end

      def list_documents page=1
        BitPesa::Client.get("/documents", page: page)
      end

      # Senders

      def get_sender id
        BitPesa::Client.get("/senders/#{id}")
      end

      def create_sender data
        BitPesa::Client.post("/senders", {sender: data})
      end

      def update_sender id, data
        BitPesa::Client.patch("/senders", data)
      end

      def list_senders page=1
        BitPesa::Client.get("/senders", page: page)
      end

      def delete_sender id
        BitPesa::Client.delete("/senders/#{id}")
      end

      # Transactions

      def get_transaction id
        BitPesa::Client.get("/transactions/#{id}")
      end

      def create_transaction data
        BitPesa::Client.post("/transactions", transaction: data)
      end

      def list_transactions **filters
        BitPesa::Client.get("/transactions", filters)
      end

      def calculate_transaction data
        BitPesa::Client.post("/transactions/calculate", transaction: data)
      end

      def validate_transaction data
        BitPesa::Client.post("/transactions/validate", transaction: data)
      end

      # Webhooks

      def get_webhook id
        BitPesa::Client.get("/webhooks/#{id}")
      end

      def create_webhook url:, events:, **meta_data
        BitPesa::Client.post("/webhooks", {webhook: {url: url, events: events, metadata: meta_data}})
      end

      def list_webhooks
        BitPesa::Client.get("/webhooks")
      end

      def delete_webhook id
        BitPesa::Client.delete("/webhooks/#{id}")
      end

      # Helpers

      def encode_document file_content, file_name:, mime_type:, **meta_data
        encoded_file_content = "data:" + mime_type + ";base64," + Base64.encode64(file_content)
        {
          upload: encoded_file_content,
          upload_file_name: file_name,
          metadata: meta_data
        }
      end

    end

  end
end
