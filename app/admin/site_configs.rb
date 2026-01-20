ActiveAdmin.register SiteConfig do
  before_save do |object, _args|
    resource.last_updated_by = current_admin_user
    object.class.columns_hash.select { |_key, attr| attr.type.in? [ :json, :jsonb ] }.keys.each do |key|
      next unless params[resource_request_name].key? key
      json_data = params[resource_request_name][key]
      data = json_data == "null" || json_data.blank? ? {} : JSON.parse(json_data)
      object.attributes = { key => data }
    end
  end

  permit_params :active, :site_data, slides_attributes: [ :id, :image, :title, :subtitle, :content, :_destroy ], verses_attributes: [ :id, :content, :reference, :_destroy ], services_attributes: [ :id, :image, :title, :description, :schedule, :_destroy ]

  show do
    attributes_table do
      row :active
      row :last_updated_by
      row :slides
      row :verses
      row :services
      row :site_config
    end
  end

  index do
    selectable_column
    id_column
    column :active
    column :last_updated_by
    column :created_at
    column :updated_at
    actions
  end

  form html: { multipart: true } do |f|
    semantic_errors
    inputs "Details" do
      input :active
      input :site_data, as: :jsonb, value: f.object.site_data || {}
    end
    inputs "Slides" do
      f.has_many :slides, allow_destroy: true do |s|
        s.input :image, as: :file, hint: !s.object.new_record? ? image_tag(s.object.image_path, style: "max-width: 200px;") : content_tag(:span, "No image uploaded yet")
        s.input :title
        s.input :subtitle
        s.input :content
      end
    end
    inputs "Verses" do
      f.has_many :verses, allow_destroy: true do |v|
        v.input :content, label: "Versículo", as: :text, input_html: { rows: 3 }
        v.input :reference, label: "Referência", placeholder: "Ex: João 3:16"
      end
    end
    inputs "Services (Reuniões)" do
      f.has_many :services, allow_destroy: true do |s|
        s.input :image, as: :file, hint: !s.object.new_record? ? image_tag(s.object.image_path, style: "max-width: 200px;") : content_tag(:span, "No image uploaded yet")
        s.input :title, label: "Título", placeholder: "Ex: Culto de Celebração"
        s.input :description, label: "Descrição", as: :text, input_html: { rows: 3 }
        s.input :schedule, label: "Horário", placeholder: "Ex: Domingos às 10h"
      end
    end
    actions
  end
end
