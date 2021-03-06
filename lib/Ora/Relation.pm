package Ora::Relation;

use strict;
use warnings;

use Exporter 'import';
use Sub::Install;

use Class::Accessor::Lite (
  new   => 1,
  ro => [
    'name',           # 'Str',
    'type',           # 'Str',
    'resolver',       # 'CodeRef',
    'relation_class', # 'Class',
    'target_class',   # 'Class',
    'unit',           # 'CodeRef',
    'empty',          # 'CodeRef',
  ],
);

use Ora::Relation::HasA;
use Ora::Relation::HasMany;

our @EXPORT = qw( has_a has_many );

# DSL

sub has_a {
  my ($name, $relation_class, $resolver) = @_;
  my ($target_class) = caller();
  my $relation = Ora::Relation::HasA->new(
    name           => $name,
    relation_class => $relation_class,
    resolver       => $resolver,
    target_class   => $target_class,
  );
  $relation->install;
}

sub has_many {
  my ($name, $relation_class, $resolver) = @_;
  my ($target_class) = caller();
  my $relation = Ora::Relation::HasMany->new(
    name           => $name,
    relation_class => $relation_class,
    resolver       => $resolver,
    target_class   => $target_class,
  );
  $relation->install;
}

# Instance methods

# CodeRef
sub method {
  my ($relation) = @_;
  my $resolved = {};
  return sub {
    my ($entity) = @_;
    if (!$resolved->{$relation->name}) {
      if ($entity->should_resolve) {
        $entity->{$relation->name} = $relation->unit->($relation->resolver->($entity));
        $resolved->{$relation->name} = 1;
      } else {
        $entity->{$relation->name} //= $relation->empty->();
      }
    }
    return $entity->{$relation->name};
  };
}

sub _install_relation {
  my ($self) = @_;
  $self->target_class->relations->{$self->type} //= {};
  $self->target_class->relations->{$self->type}->{$self->name} = $self;
}

sub _install_method {
  my ($self) = @_;
  Sub::Install::install_sub({
    code => $self->method,
    into => $self->target_class,
    as   => $self->name,
  });
}

sub install {
  my ($self) = @_;
  $self->_install_relation;
  $self->_install_method;
}

1;
