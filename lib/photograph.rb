class Photograph
  attr_reader :id,
              :name,
              :artist_id,
              :year

  def initialize(params)
    @id = params[:id]
    @name = params[:name]
    @artist_id = params[:artist_id]
    @year = params[:year]
  end
  
end
