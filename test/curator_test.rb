require_relative 'test_helper.rb'
require './lib/curator.rb'
require './lib/photograph.rb'
require './lib/artist.rb'

class CuratorTest < Minitest::Test

  def setup
    @curator = Curator.new
    @photo_1 = Photograph.new({
         id: "1",
         name: "Rue Mouffetard, Paris (Boy with Bottles)",
         artist_id: "1",
         year: "1954"
    })
    @photo_2 = Photograph.new({
         id: "2",
         name: "Moonrise, Hernandez",
         artist_id: "2",
         year: "1941"
    })
    @photo_3 = Photograph.new({
         id: "3",
         name: "Identical Twins, Roselle, New Jersey",
         artist_id: "3",
         year: "1967"
    })
    @photo_4 = Photograph.new({
         id: "4",
         name: "Monolith, The Face of Half Dome",
         artist_id: "3",
         year: "1927"
    })
    @artist_1 = Artist.new({
        id: "1",
        name: "Henri Cartier-Bresson",
        born: "1908",
        died: "2004",
        country: "France"
    })
    @artist_2 = Artist.new({
        id: "2",
        name: "Ansel Adams",
        born: "1902",
        died: "1984",
        country: "United States"
    })
    @artist_3 = Artist.new({
         id: "3",
         name: "Diane Arbus",
         born: "1923",
         died: "1971",
         country: "United States"
    })
  end

  def test_it_exists
    assert_instance_of Curator, @curator
  end

  def test_it_has_attributes
    assert_equal [], @curator.photographs
    assert_equal [], @curator.artists
  end

  def test_it_can_add_photos
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    assert_equal [@photo_1, @photo_2], @curator.photographs
  end

  def test_it_can_add_artists
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    assert_equal [@artist_1, @artist_2], @curator.artists
  end

  def test_it_can_find_artist_by_id
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    assert_equal @artist_1, @curator.find_artist_by_id("1")
  end

  def test_it_can_group_photographs_by_artist
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    @curator.add_artist(@artist_3)
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)
    expected = {
      @artist_1 => [@photo_1],
      @artist_2 => [@photo_2],
      @artist_3 => [@photo_3, @photo_4]
    }
    assert_equal expected, @curator.photographs_by_artist
  end

  def test_it_can_select_artists_with_multiple_photographs
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    @curator.add_artist(@artist_3)
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    assert_equal [], @curator.artists_with_multiple_photographs
    @curator.add_photograph(@photo_4)
    assert_equal ["Diane Arbus"], @curator.artists_with_multiple_photographs
  end

  def test_it_can_select_photographs_taken_by_artist_from_given_country
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    @curator.add_artist(@artist_3)
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)
    expected = [@photo_2, @photo_3, @photo_4]
    assert_equal expected, @curator.photographs_taken_by_artist_from("United States")
    assert_equal [], @curator.photographs_taken_by_artist_from("Argentina")
  end

  def test_it_can_select_photos_taken_between_a_range_of_dates
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)
    assert_equal [@photo_1, @photo_2], @curator.photographs_taken_between(1940..1960)
    assert_equal [], @curator.photographs_taken_between(1910..1915)
  end

  def test_it_can_create_objects_from_csv
    @curator.from_csv('./data/photographs.csv', Photograph, @curator.photographs)
    assert_equal 4, @curator.photographs.size
    assert_instance_of Photograph, @curator.photographs.sample
  end

  def test_it_can_create_photograph_objects_from_csv
    @curator.load_photographs('./data/photographs.csv')
    assert_equal %w(1 2 3 4), @curator.photographs.map(&:id)
    assert_equal 4, @curator.photographs.size
    assert_instance_of Photograph, @curator.photographs.sample
  end

  def test_it_can_create_artist_objects_from_csv
    @curator.load_artists('./data/artists.csv')
    assert_equal 6, @curator.artists.size
    assert_instance_of Artist, @curator.artists.sample
  end

  def test_it_can_sort_an_artists_photos_by_the_age_they_took_them
    @curator.load_photographs('./data/photographs.csv')
    @curator.load_artists('./data/artists.csv')
    diane_arbus = @curator.find_artist_by_id("3")
    expected = {
      44=>"Identical Twins, Roselle, New Jersey",
      39=>"Child with Toy Hand Grenade in Central Park"
    }
    assert_equal expected, @curator.artists_photographs_by_age(diane_arbus)
  end

end
