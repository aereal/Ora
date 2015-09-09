package Ora::Relation::HasA;

use strict;
use warnings;
use constant RELATION_TYPE => 'HAS_A';

use parent qw( Ora::Relation );

use Data::Monad::Maybe ();

sub new {
  my ($class, %args) = @_;
  return $class->SUPER::new(%args,
    type  => RELATION_TYPE,
    empty => \&Data::Monad::Maybe::nothing,
    unit  => \&Data::Monad::Maybe::just,
  );
}

1;
