require 'populate_association_from_hash'

[ ActiveRecord::Associations::BelongsToAssociation,
  ActiveRecord::Associations::HasOneAssociation
].each do |klass|
  klass.send(:include, PopulateAssociationFromHash)
end
