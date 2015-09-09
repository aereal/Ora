package Ora::Relation::HasMany;

use strict;
use warnings;
use constant RELATION_TYPE => 'HAS_MANY';

use parent qw( Ora::Relation );

sub new {
  my ($class, %args) = @_;
  return $class->SUPER::new(%args,
    type  => RELATION_TYPE,
    empty => sub { [] },
    unit  => sub { [@_] },
  );
}

1;
