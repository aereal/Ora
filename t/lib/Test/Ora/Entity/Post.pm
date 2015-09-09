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

has_a author => 'Test::Ora::Entity::User' => sub {
  my ($post) = @_;
  require Test::Ora::Repository::User;
  return Test::Ora::Repository::User->new->find({ user_id => $post->author_id });
};

1;
