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
  require Test::Ora::Repository::Post;
  Test::Ora::Repository::Post->new->search_by_blog($blog);
};

1;
