require './lib/loadable.rb'
require './lib/photograph.rb'
require './lib/artist.rb'

class Curator
  include Loadable
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

  def load_photographs(file_path)
    from_csv(file_path, Photograph, @photographs)
  end

  def load_artists(file_path)
    from_csv(file_path, Artist, @artists)
  end

  def artists_photographs_by_age(artist)
    photos_by_age = {}
    photographs_by_artist[artist].each do |photo|
      artist_age = photo.year.to_i - artist.born.to_i
      photos_by_age[artist_age] = photo.name
    end
    photos_by_age
  end

end
