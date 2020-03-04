class Curator
  attr_reader :photographs,
              :artists

  def initialize
    @photographs = []
    @artists = []
  end

  def add_photograph(photo)
    @photographs << photo
  end

  def add_artist(artist)
    @artists << artist
  end

  def find_artist_by_id(id)
    @artists.find {|artist| artist.id == id}
  end

  def photographs_by_artist
    @artists.inject({}) do |by_artist, artist|
      by_artist[artist] = @photographs.select {|photo| photo.artist_id == artist.id}
      by_artist
    end
  end

  def artists_with_multiple_photographs
    artists = @artists.select {|artist| (photographs_by_artist[artist].size > 1)}
    artists.map(&:name)
  end

  def photographs_taken_by_artist_from(country)
    from_country = []
    photographs_by_artist.each do |artist, photos|
      photos.each {|photo| from_country << photo if artist.country == country}
    end
    from_country
  end

  def photographs_taken_between(range)
    @photographs.select {|photo| range.include?(photo.year.to_i)}
  end

end
