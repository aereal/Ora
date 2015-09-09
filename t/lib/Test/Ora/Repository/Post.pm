package Test::Ora::Repository::Post;

use strict;
use warnings;
use feature 'state';

use parent 'Test::Ora::Repository';

use Test::Ora::Entity::Post;

sub new {
  my ($class) = @_;
  state $instance = bless {
    table => 'post',
    entity_builder => sub { Test::Ora::Entity::Post->new($_[0]) },
  }, $class;
}

sub search_by_author {
  my ($self, $author) = @_;
  return $self->search(['*'], { author_id => $author->user_id });
}

sub search_by_blog {
  my ($self, $blog) = @_;
  return $self->search(['*'], { owner_blog_id => $blog->blog_id });
}

1;
