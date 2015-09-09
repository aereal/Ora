package Test::Ora::Entity::User;

use strict;
use warnings;

use parent 'Ora::Entity';

use Class::Accessor::Lite (
  new => 1,
  ro => [
    'user_id', # Int
    'name', # 'Str',
  ]
);

use Ora::Relation;

has_many blogs => 'Test::Ora::Entity::Blog' => sub {
  my ($user) = @_;
  require Test::Ora::Repository::Blog;
  return Test::Ora::Repository::Blog->new->search_by_owner($user);
};

1;
