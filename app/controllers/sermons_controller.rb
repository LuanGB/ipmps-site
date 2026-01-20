class SermonsController < InheritedResources::Base
  def index
    @sermons = Sermon.order(published_at: :desc).page(params[:page]).per(9)
  end
end
