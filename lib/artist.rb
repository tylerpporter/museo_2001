class Artist
  attr_reader :id,
              :name,
              :born,
              :died,
              :country

  def initialize(params)
    @id = params[:id]
    @name = params[:name]
    @born = params[:born]
    @died = params[:died]
    @country = params[:country]
  end

end
