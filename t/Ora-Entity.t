package t::Ora::Entity;

use strict;
use warnings;
use parent qw( Test::Class );
use Test::More;

sub init : Test(startup => 1) {
  require_ok 'Ora::Entity';
}

sub resolve : Tests {
  my $resolve = 0;
  {
    package t::Post;
    use parent 'Ora::Entity';
    use Ora::Declare::Property;
    use Ora::Relation;

    has_a 'author' => 't::User' => sub {
      my ($post) = @_;
      $resolve++;
      return t::User->new(name => $post->author_name);
    };

    property post_id => 'Int';
    property author_name => 'Str';
  };
  {
    package t::User;
    use parent 'Ora::Entity';
    use Ora::Declare::Property;
    use Ora::Relation;

    property name => 'Str';

    has_many posts => 't::Post' => sub {
      my ($user) = @_;
      return map { t::Post->new(post_id => $_, author_name => $user->name) } (1..5);
    };
  };
  can_ok 't::User', 'resolve';
  can_ok 't::User', 'posts';
  can_ok 't::Post', 'resolve';
  can_ok 't::Post', 'author';
  my $post = new_ok 't::Post', [ post_id => 1, author_name => 'aereal' ];
  ok ! $post->should_resolve;
  $post->author for (0..3);
  is $resolve, 0, 'not called yet';
  $post->resolve->author for (0..3);
  ok $post->should_resolve;
  is $resolve, 1, 'called';

  my $user = t::User->new(name => 'aereal');
  my $posts = $user->resolve->posts;
}

__PACKAGE__->runtests;

1;
