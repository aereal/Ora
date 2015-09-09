package Ora::Entity;

use strict;
use warnings;

sub relations {
  my ($class) = @_;
  no strict 'refs';
  return ${"$class\::RELATIONS"} //= {};
}

sub properties {
  my ($class) = @_;
  no strict 'refs';
  return ${"$class\::PROPERTIES"} //= {};
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

sub has_resolved {
  my ($self, $name) = @_;
  return $self->resolved_relations->{$name} ? 1 : 0;
}

sub resolved_relations {
  my ($self) = @_;
  return $self->{resolved_relations} //= {};
}

sub resolve_relation {
  my ($self, $name) = @_;
  $self->resolved_relations->{$name} = 1;
}

1;
