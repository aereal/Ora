package Test::Ora::Entity::Post;

use strict;
use warnings;

use parent 'Ora::Entity';

use Class::Accessor::Lite (
  new => 1,
  ro => [
    'post_id',     # 'Int',
    'author_name', # 'Str',
  ]
);

use Ora::Relation;

has_a 'author' => 'Test::Ora::Entity::User' => sub {
  my ($post) = @_;
  return Test::Ora::Entity::User->new(name => $post->author_name);
};

1;
