package t::Ora::Entity;

use strict;
use warnings;
use parent qw( Test::Class );
use Test::More;

use Test::Ora::Entity::Post;
use Test::Ora::Entity::User;

sub init : Test(startup => 1) {
  require_ok 'Ora::Entity';
}

sub resolve : Tests {
  can_ok 'Test::Ora::Entity::User', 'resolve';
  can_ok 'Test::Ora::Entity::User', 'posts';
  can_ok 'Test::Ora::Entity::Post', 'resolve';
  can_ok 'Test::Ora::Entity::Post', 'author';
  my $post = new_ok 'Test::Ora::Entity::Post', [ post_id => 1, author_name => 'aereal' ];
  ok ! $post->should_resolve;
  $post->author for (0..3);
  $post->resolve->author for (0..3);
  ok $post->should_resolve;

  my $user = Test::Ora::Entity::User->new(name => 'aereal');
  my $posts = $user->resolve->posts;
}

__PACKAGE__->runtests;

1;
