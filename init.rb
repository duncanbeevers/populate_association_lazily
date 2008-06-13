require 'populate_association_lazily'

[ ActiveRecord::Associations::BelongsToAssociation,
  ActiveRecord::Associations::HasOneAssociation
].each do |klass|
  klass.send(:include, PopulateAssociationLazily::PopulateSingleAssocationLazily)
end

ActiveRecord::Associations::AssociationCollection.send :include,
  PopulateAssociationLazily::PopulateMultipleAssociationLazily
