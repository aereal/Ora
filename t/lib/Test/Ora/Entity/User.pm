package Test::Ora::Entity::User;

use strict;
use warnings;

use parent 'Ora::Entity';

use Class::Accessor::Lite (
  new => 1,
  ro => [
    'name', # 'Str',
  ]
);

use Ora::Relation;

has_many posts => 't::Post' => sub {
  my ($user) = @_;
  return map { Test::Ora::Entity::Post->new(post_id => $_, author_name => $user->name) } (1..5);
};

1;
