require File.join(File.dirname(__FILE__), 'test_helper')

class PopulatesAssociationLazilyTest < Test::Unit::TestCase
  def test_user_should_have_has_one_reflection_to_wristband
    assert_equal :has_one, User.reflections[:wristband].macro, 'User should have has_one association to Wristband'
  end

  def test_user_should_have_has_many_reflection_to_favorites
    assert_equal :has_many, User.reflections[:favorites].macro, 'User should have has_many assocation to Favorites'
  end

  def test_user_should_have_has_many_through_reflection_to_favorite_wristbands
    assert_equal :has_many, User.reflections[:favorite_wristbands].macro, 'User should have has_many through assocation to favorite Wristbands'
  end

  def test_wristband_should_have_belongs_to_reflection_to_users
    assert_equal :belongs_to, Wristband.reflections[:user].macro, 'Wristband should have belongs_to association to User'
  end

  def test_wristband_should_have_polymorphic_belongs_to_something
    reflection = Wristband.reflections[:something]
    # Really!??!
    assert_equal :belongs_to, reflection.macro, 'Wristband should have polymorphic belongs_to assocation to something'
    assert reflection.options[:polymorphic],'Wristband should have polymorphic belongs_to assocation to something'
  end

  def test_should_populate_via_hash_through_has_one_association
    assert_kind_of Wristband, User.new(:wristband => { } ).wristband, 'Association assigned via hash should populate object of association type'
  end

  def test_should_populate_via_hash_with_property_through_has_one_association
    assert_equal 'orange', User.new(:wristband => { :color => 'orange' } ).wristband.color, 'Object populated on association via hash should use hash properties'
  end

  def test_should_populate_via_hash_through_belongs_to_association
    assert_kind_of User, Wristband.new(:user => { :username => 'andre' } ).user
  end

  def test_should_populate_via_array_through_has_many_association
    assert_equal 1, User.new(:favorites => [ Favorite.new ] ).favorites.size, 'Should have populated a favorite on favorites association'
  end

  def test_should_populate_via_array_through_has_many_association_with_nested_hashes
    assert_kind_of Favorite, User.new(:favorites => [ { } ] ).favorites.first
  end

  def test_should_populate_properites_via_array_through_has_many_association_with_nested_hashes
    assert_equal 1, User.new(:favorites => [ { :wristband_id => 1 } ] ).favorites.first.wristband_id
  end

  def test_should_populate_via_array_through_has_many_through_association
    assert_equal 'maroon', User.new(:favorite_wristbands => [ { :color => 'maroon' } ] ).favorite_wristbands.first.color
  end

  def test_should_raise_on_populate_through_polymorphic_belongs_to_when_type_is_not_specified
    assert_raise ArgumentError do
      Wristband.new(:something => { })
    end
  end

  def test_should_raise_on_populate_through_polymorphic_belongs_to_when_bad_type_is_specified
    assert_raise NameError, 'No class NoSuchClass should exist' do
      NoSuchClass
    end
    assert_raise NameError do
      Wristband.new(:something => { :type => 'NoSuchClass' } )
    end
  end

  def test_should_populate_via_has_through_polymorphic_belongs_to_association
    assert_kind_of User, Wristband.new(:something => { :type => 'User' } ).something,
      'Should populate polymorphic belongs_to with type declaration'
    assert_kind_of Favorite, Wristband.new(:something => { :type => 'Favorite' } ).something,
      'Should populate polymorphic belongs_to with type declaration'
  end

  def test_should_populate_errors_on_association
    user = User.new(:wristband => { })
    user.valid?
    assert user.errors.on(:wristband), 'Should have errors on association'
  end

  def test_should_populate_errors_on_associationr
    user = User.new(:wristband => { })
    user.valid?
    assert user.wristband.errors.on(:color), 'Should have errors on underlying object'
  end

end
