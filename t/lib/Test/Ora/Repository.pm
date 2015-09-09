package Test::Ora::Repository;

use strict;
use warnings;
use feature 'state';

use Class::Accessor::Lite (
  ro => [qw( table entity_builder )],
);

sub db {
  state $db = Test::Ora::Repository::Infra->new;
}

sub find {
  my ($self, @args) = @_;
  my $row = $self->db->find($self->table, ['*'], @args);
  return $row ? $self->entity_builder->($row) : undef;
}

sub search {
  my ($self, @args) = @_;
  my $rows = $self->db->search($self->table, @args);
  return [ map { $self->entity_builder->($_) } @$rows ];
}

sub insert {
  my ($self, @args) = @_;
  $self->db->insert($self->table, @args);
}

sub update {
  my ($self, @args) = @_;
  $self->db->update($self->table, @args);
}

package Test::Ora::Repository::Infra;
use strict;
use warnings;
use feature 'state';
use parent qw( DBIx::Handler::Sunny );

use SQL::Maker;
use SQL::NamedPlaceholder;

sub new {
  my ($class) = @_;
  return $class->SUPER::new(
    'dbi:mysql:dbname=ora;host=localhost',
    'root',
    '',
    {
      AutoInactiveDestroy  => 1,
      PrintError           => 1,
      RaiseError           => 1,
      ShowErrorStatement   => 1,
      mysql_auto_reconnect => 1,
      mysql_enable_utf8    => 1,
    },
    {
      trace_query => 1,
      on_connect_do => [
        q| SET NAMES utf8mb4 |,
        q| SET @@SESSION.sql_mode = 'TRADITIONAL,NO_AUTO_VALUE_ON_ZERO,ONLY_FULL_GROUP_BY'|,
      ],
    },
  );
}

sub replace_named_placeholder {
    my ($self, $sql, $binds_hashref) = @_;
    ($sql, my $binds) = SQL::NamedPlaceholder::bind_named($sql, $binds_hashref);
    return ($sql, $binds);
}

sub sql_maker {
  return SQL::Maker->new(
    driver => 'mysql',
    strict => 1,
  );
}

sub search {
  my ($self, @sql_maker_args) = @_;
  return $self->select_all(
    $self->sql_maker->select(@sql_maker_args)
  );
}

sub find {
  my ($self, @sql_maker_args) = @_;
  return $self->select_row(
    $self->sql_maker->select(@sql_maker_args)
  );
}

sub insert {
  my ($self, @sql_maker_args) = @_;
  return $self->query(
    $self->sql_maker->insert(@sql_maker_args)
  );
}

sub update {
  my ($self, @sql_maker_args) = @_;
  return $self->query(
    $self->sql_maker->update(@sql_maker_args)
  );
}

1;
