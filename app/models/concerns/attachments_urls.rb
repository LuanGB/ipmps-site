# frozen_string_literal: true

module AttachmentsUrls
  extend ActiveSupport::Concern

  included do
    include Rails.application.routes.url_helpers

    reflect_on_all_attachments.map(&:name).each do |image_type|
      define_method :"#{image_type}_path" do
        unless send(image_type).attached? && send(image_type).attachment.blob.present? && send(image_type).attachment.blob.persisted?
          return ''
        end

        rails_blob_path(send(image_type), only_path: true)
      end
    end
  end
end
