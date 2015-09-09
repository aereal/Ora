package Test::Ora::Entity::Post;

use strict;
use warnings;

use parent 'Ora::Entity';

use Class::Accessor::Lite (
  new => 1,
  ro => [
    'post_id',
    'blog_id',
  ]
);

use Ora::Relation;

has_a 'author' => 'Test::Ora::Entity::User' => sub {
  my ($post) = @_;
  return Test::Ora::Entity::User->new(name => 'user_' . $post->post_id, user_id => $post->post_id);
};

1;
