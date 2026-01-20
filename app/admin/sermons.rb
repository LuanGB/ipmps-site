ActiveAdmin.register Sermon do
  menu priority: 3

  permit_params :title, :description, :link, :youtube_video_id, :thumbnail_url, :published_at, :duration, :view_count, :auto_imported

  # Ação customizada para importar sermões do YouTube
  action_item :import_from_youtube, only: :index do
    link_to "Importar do YouTube", import_youtube_admin_sermons_path, method: :post, data: { confirm: "Isso irá buscar os últimos vídeos do canal do YouTube configurado. Continuar?" }
  end

  collection_action :import_youtube, method: :post do
    # Executa o job de forma síncrona para feedback imediato
    ImportYoutubeSermonsJob.new.perform

    redirect_to admin_sermons_path, notice: "Importação em andamento"
  end

  index do
    selectable_column
    id_column
    column :title
    column "Origem" do |sermon|
      sermon.auto_imported? ? status_tag("Auto", class: "ok") : status_tag("Manual", class: "info")
    end
    column :published_at
    column :duration
    column :view_count do |sermon|
      number_with_delimiter(sermon.view_count) if sermon.view_count
    end
    column "Thumbnail" do |sermon|
      if sermon.thumbnail_url.present?
        image_tag sermon.thumbnail_url, style: "max-width: 100px;"
      end
    end
    actions
  end

  filter :title
  filter :auto_imported, as: :select, collection: [ [ "Importados", true ], [ "Manuais", false ] ]
  filter :published_at
  filter :created_at

  show do
    attributes_table do
      row :id
      row :title
      row :description
      row :youtube_video_id
      row "URL do YouTube" do |sermon|
        if sermon.youtube_url.present?
          link_to sermon.youtube_url, sermon.youtube_url, target: "_blank"
        end
      end
      row "Vídeo" do |sermon|
        if sermon.youtube_embed_url.present?
          content_tag(:iframe, nil, src: sermon.youtube_embed_url, width: 560, height: 315, frameborder: 0, allowfullscreen: true)
        end
      end
      row :thumbnail_url do |sermon|
        if sermon.thumbnail_url.present?
          image_tag sermon.thumbnail_url, style: "max-width: 300px;"
        end
      end
      row :published_at
      row :duration
      row :view_count do |sermon|
        number_with_delimiter(sermon.view_count) if sermon.view_count
      end
      row :auto_imported do |sermon|
        sermon.auto_imported? ? status_tag("Sim", class: "ok") : status_tag("Não", class: "info")
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs "Detalhes do Sermão" do
      f.input :title, label: "Título"
      f.input :description, label: "Descrição", as: :text, input_html: { rows: 3 }
      f.input :link, label: "Link do YouTube", placeholder: "https://youtube.com/watch?v=..."
      f.input :published_at, label: "Data de Publicação", as: :datepicker
      f.input :auto_imported, label: "Importado automaticamente?", hint: "Marque se foi importado do YouTube"
    end

    f.inputs "Informações Adicionais (preenchidas automaticamente)" do
      f.input :youtube_video_id, label: "ID do Vídeo (YouTube)", hint: "Será extraído automaticamente do link"
      f.input :thumbnail_url, label: "URL da Thumbnail"
      f.input :duration, label: "Duração", placeholder: "Ex: 45:30"
      f.input :view_count, label: "Número de Visualizações"
    end

    f.actions
  end
end
