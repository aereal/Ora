package Ora::Declare::Property;

use strict;
use warnings;

use Exporter 'import';
use Sub::Install;

use Ora::Property;

our @EXPORT = qw( property );

sub property {
  my ($name, $type) = @_;
  my ($class) = caller();
  my $property = Ora::Property->new(
    name => $name,
    type => $type,
  );
  $property->install($class);
}

1;
