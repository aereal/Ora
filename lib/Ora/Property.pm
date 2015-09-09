package Ora::Property;

use strict;
use warnings;

sub new {
  my ($class, %args) = @_;
  return bless \%args, $class;
}

sub name {
  my ($self) = @_;
  return $self->{name};
}

sub type {
  my ($self) = @_;
  return $self->{type};
}

sub code {
  my ($self) = @_;
  return sub { $_[0]->{$self->name} };
}

sub install {
  my ($self, $target_class) = @_;
  Sub::Install::install_sub({
    code => $self->code,
    into => $target_class,
    as   => $self->name,
  });
  {
    no strict 'refs';
    my $v = join '::', $target_class, 'PROPERTIES';
    ${$v} //= {};
    ${$v}->{$self->name} = $self;
  };
}

1;
