class SiteController < ApplicationController
  def home
    @latest_news = Post.where("publication_date < ?", Time.now).where(category: :news).order(publication_date: :desc).limit(4)
    @latest_events = Post.where("publication_date < ?", Time.now).where(category: :events).order(publication_date: :desc).limit(4)
  end

  def about
  end
end
