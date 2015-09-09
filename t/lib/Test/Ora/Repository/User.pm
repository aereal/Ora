package Test::Ora::Repository::User;

use strict;
use warnings;
use feature 'state';

use parent 'Test::Ora::Repository';

use Test::Ora::Entity::User;

sub new {
  my ($class) = @_;
  state $instance = bless {
    table => 'user',
    entity_builder => sub { Test::Ora::Entity::User->new($_[0]) },
  }, $class;
}

1;
