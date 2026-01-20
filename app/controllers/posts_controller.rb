class PostsController < ApplicationController
  PAGE_TITLES = {
    news: "Últimas Notícias",
    events: "Próximos Eventos"
  }

  # GET /posts
  def index
    filter = { category: params[:category] }.compact
    scope = filter.present? ? Post.where(filter) : Post.all
    @posts = scope.order(publication_date: :desc).page(params[:page]).per(12)
    @page_title = PAGE_TITLES[params[:category]&.to_sym] || "Todos os Posts"
  end

  def show
    @post = Post.find(params[:id])
  end
end
