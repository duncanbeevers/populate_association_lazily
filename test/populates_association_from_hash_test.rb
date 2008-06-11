require File.join(File.dirname(__FILE__), 'test_helper')

class PopulatesAssociationFromHashTest < Test::Unit::TestCase
  def test_should_populate_via_hash_through_has_one_association
    assert_equal :has_one, User.reflections[:wristband].macro, 'User should have has_one association to Wristband'
    assert_kind_of Wristband, User.new(:wristband => { :color => 'orange' } ).wristband
  end

  def test_should_populate_via_hash_through_belongs_to_association
    assert_equal :belongs_to, Wristband.reflections[:user].macro, 'Wristband should have belongs_to association to User'
    assert_kind_of User, Wristband.new(:user => { :username => 'andre' } ).user
  end

  def test_should_populate_errors_on_association
    user = User.new(:wristband => { })
    user.valid?
    assert user.errors.on(:wristband), 'Should have errors on association'
  end

  def test_should_populate_errors_on_association
    user = User.new(:wristband => { })
    user.valid?
    assert user.wristband.errors.on(:color), 'Should have errors on underlying object'
  end

end
