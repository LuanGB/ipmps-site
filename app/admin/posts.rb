# frozen_string_literal: true

ActiveAdmin.register Post do
  before_save do |object, _args|
    resource.publication_date ||= Time.current
  end

  permit_params :title, :description, :category, :publication_date, :content, :cover, :thumbnail# , author_ids: [], category_ids: [], tag_ids: []

  collection_action :upload, method: [ :post ] do
    result = {  success: resource.content_files.attach(params[:file_upload]) }
    result[:url] = url_for(resource.content_files.last) if result[:success]
    render json: result
  end

  filter :title
  filter :publication_date
  filter :created_at

  show do
    attributes_table do
      row :title
      row :link do |post|
        link_to post.title, post_path(post), target: "_blank"
      end
      row :description
      row :category
      row :publication_date
      row :cover do |post|
        image_tag post.cover_path, width: "1280px"
      end
      row :thumbnail do |post|
        image_tag post.thumbnail_path, width: "720px"
      end
    end
    attributes_table do
      row :html_safe_content
    end
  end

  index do
    selectable_column
    id_column
    column :title
    column :category
    column :publication_date
    actions
  end

  form html: { multipart: true } do |f|
    semantic_errors
    inputs "Details" do
      input :title
      input :description, as: :string
      input :publication_date, as: :date_time_picker
      input :category, as: :select_2, collection: Post::CATEGORIES
      input :cover, as: :file, hint: !object.new_record? && image_tag(object.cover_path, width: "1280px")
      input :thumbnail, as: :file, hint: !object.new_record? && image_tag(object.thumbnail_path, width: "720px")
      li "Created at #{f.object.created_at}" unless f.object.new_record?
    end
    inputs "Content" do
      input :content, label: false, as: :quill_editor, style: "background: black", input_html: {
        data: {
          options: {
            modules: {
              toolbar: [
                [ { font: [] }, { size: [] } ],
                %w[bold italic underline strike],
                [ { color: [] }, { background: [] } ],
                [ { script: "super" }, { script: "sub" } ],
                [ { header: "1" }, { header: "2" }, "blockquote", "code-block" ],
                [ { list: "ordered" }, { list: "bullet" }, { indent: "-1" }, { indent: "+1" } ],
                [ "direction", { align: [] } ],
                %w[link image video formula],
                [ "clean" ]
              ]
            }
          },
          plugins: { image_uploader: { server_url: upload_admin_posts_path, field_name: "file_upload" } }
        }
      }
    end
    actions
  end
end
