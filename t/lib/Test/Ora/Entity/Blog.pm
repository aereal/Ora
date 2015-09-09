package Test::Ora::Entity::Blog;

use strict;
use warnings;
use feature 'state';

use parent 'Ora::Entity';

use Class::Accessor::Lite (
  new => 1,
  ro => [
    'blog_id',
    'author_id',
  ],
);

use Ora::Relation;

has_many posts => 'Test::Ora::Entity::Post' => sub {
  my ($blog) = @_;
  return map { Test::Ora::Entity::Post->new(post_id => $_, blog_id => $blog->blog_id) } (1..5);
};

1;
