package Ora::Relation;

use strict;
use warnings;

use Exporter 'import';
use Sub::Install;

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

# Class methods

sub new {
  my ($class, %args) = @_;
  return bless \%args, $class;
}

# Instance methods

# CodeRef
sub empty {
  my ($self) = @_;
  return $self->{empty};
}

sub unit {
  my ($self) = @_;
  return $self->{unit};
}

# Str
sub type {
  my ($self) = @_;
  return $self->{type};
}

# Str
sub name {
  my ($self) = @_;
  return $self->{name};
}

# CodeRef
sub resolver {
  my ($self) = @_;
  return $self->{resolver};
}

# Class
sub relation_class {
  my ($self) = @_;
  return $self->{relation_class};
}

sub target_class {
  my ($self) = @_;
  return $self->{target_class};
}

# CodeRef
sub method {
  my ($relation) = @_;
  return sub {
    my ($o) = @_;
    if (!$o->has_resolved($relation->name)) {
      if ($o->should_resolve) {
        $o->{$relation->name} = $relation->unit->($relation->resolver->($o));
        $o->resolve_relation($relation->name);
      } else {
        $o->{$relation->name} //= $relation->empty->();
      }
    }
    return $o->{$relation->name};
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
