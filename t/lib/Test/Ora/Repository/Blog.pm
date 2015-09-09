package Test::Ora::Repository::Blog;

use strict;
use warnings;
use feature 'state';

use parent 'Test::Ora::Repository';

use Test::Ora::Entity::Blog;

sub new {
  my ($class) = @_;
  state $instance = bless {
    table => 'blog',
    entity_builder => sub { Test::Ora::Entity::Blog->new($_[0]) },
  }, $class;
}

sub search_by_owner {
  my ($self, $owner) = @_;
  return $self->search(['*'], { owner_id => $owner->user_id });
}

1;
