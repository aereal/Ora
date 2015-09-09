package Ora::Entity;

use strict;
use warnings;

use Class::Accessor::Lite (
  new => 1,
);

sub relations {
  my ($class) = @_;
  no strict 'refs';
  return ${"$class\::RELATIONS"} //= {};
}

sub resolve {
  my ($self) = @_;
  $self->{should_resolve} = 1;
  return $self;
}

sub should_resolve {
  my ($self) = @_;
  return $self->{should_resolve} ? 1 : 0;
}

1;
