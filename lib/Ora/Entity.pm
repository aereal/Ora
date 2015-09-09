package Ora::Entity;

use strict;
use warnings;

sub relations {
  my ($class) = @_;
  no strict 'refs';
  return ${"$class\::RELATIONS"} //= {};
}

sub new {
  my ($class, %args) = @_;
  return bless \%args, $class;
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
