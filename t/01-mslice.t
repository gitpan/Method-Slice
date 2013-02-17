#!perl

# stupid class just to have some methods to test
package Point;
use strict;
use warnings;

# constructor
sub new {
  my $class = shift;
  bless {x => shift, y => shift}, $class;
}

# x and y accessors
for my $meth qw/x y/ {
  no strict 'refs';
  *$meth = sub { my $self = shift;
                 $self->{$meth} = shift if @_;
                 return $self->{$meth}; };
}


package main;
use strict;
use warnings;
use Method::Slice;
use Test::More;

plan tests => 6;

my $point = Point->new(5, 7);
is($point->x, 5);
is($point->y, 7);

# transpose
(mslice($point, qw/x y/)) = mslice($point, qw/y x/);
is($point->x, 7);
is($point->y, 5);

# move 10 units on x and y axes
(mslice($point, qw/x y/)) = map {$_ + 10} @{[mslice($point, qw/x y/)]};
is($point->x, 17);
is($point->y, 15);

# The line below won't work because that's an lvalue context without ASSIGN
# (mslice($point, qw/x y/)) = map {$_ - 2} mslice($point, qw/y x/);

# These won't work because they assign to a throwaway copy
# $_ += 50 for mslice($point, qw/x y/);
# is($point->x, 67);
# is($point->y, 65);
