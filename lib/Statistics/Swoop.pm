package Statistics::Swoop;
use strict;
use warnings;
use Carp qw/croak/;
use Class::Accessor::Lite (
    rw  => [qw/list/],
    ro  => [qw/count max min range sum avg/],
);

our $VERSION = '0.01';

sub new {
    my ($class, $list) = @_;

    croak "first arg is required as array ref" unless ref($list) eq 'ARRAY'; 

    my $self = bless +{
        list  => $list,
        count => scalar @{$list},
    } => $class;

    $self->_calc if $self->count;
    return $self;
}

sub _calc {
    my $self = shift;

    my $sum;
    my $max = $self->list->[0];
    my $min = $self->list->[0];
    my $range;
    my $avg;

    for my $i (@{$self->list}) {
        $sum += $i;
        $max = $i if $max < $i;
        $min = $i if $min > $i;
    }

    if ($self->count == 1) {
        $self->{range} = $max;
        $self->{avg}   = $max;
    }
    elsif ($self->count > 1) {
        $self->{range} = $max - $min;
        $self->{avg}   = $sum / $self->count;
    }
    $self->{sum} = $sum;
    $self->{max} = $max;
    $self->{min} = $min;
}

sub maximum { $_[0]->max }
sub minimum { $_[0]->min }
sub average { $_[0]->avg }

sub result {
    my $self = shift;

    return +{
        count => $self->count,
        max   => $self->max,
        min   => $self->min,
        range => $self->range,
        sum   => $self->sum,
        avg   => $self->avg,
    };
}

1;

__END__

=head1 NAME

Statistics::Swoop - getting basic stats of a list in one fell swoop


=head1 SYNOPSIS

    use Statistics::Swoop;

    my @list = (qw/1 2 3 4 5 6 7 8 9 10/);
    my $ss = Statistics::Swoop->new(\@list);

    print $ss->max;   # 10
    print $ss->min;   # 1
    print $ss->sum;   # 55
    print $ss->avg;   # 5.5
    print $ss->range; # 9


=head1 DESCRIPTION

Usually, If we calculate some stats from list, we want maximum/minimum/sum/average/range. So Statistics::Swoop calculates them at only one loop.


=head1 METHODS

=head2 new($list)

constractor

=head2 max, maximum

getting the maximum value in $list

=head2 min, minimum

getting the minimum value in $list

=head2 range

getting the range value in $list

=head2 sum

getting the sum in $list

=head2 avg, average

getting the average in $list

=head2 count

getting the count of element

=head2 result

getting the all results as hash


=head1 BENCHMARK

See the source in this modules directory(demos/*.pl).

=head2 Statistics::Swoop vs Statistics::Lite

    $ perl demos/benchmark.pl
    Benchmark: running Lite, Swoop for at least 1 CPU seconds...
          Lite:  1 wallclock secs ( 1.08 usr +  0.00 sys =  1.08 CPU) @ 103.70/s (n=112)
         Swoop:  1 wallclock secs ( 1.09 usr +  0.00 sys =  1.09 CPU) @ 236.70/s (n=258)
           Rate  Lite Swoop
    Lite  104/s    --  -56%
    Swoop 237/s  128%    --

C<Statistics::Swoop> is 110-130% faster than L<Statistics::Lite>.
Actually, when you calculate very small list, then L<Statistics::Lite> is bit faster than C<Statistics::Swoop>.


=head1 REPOSITORY

Statistics::Swoop is hosted on github
<http://github.com/bayashi/Statistics-Swoop>

Welcome your patches and issues :D


=head1 AUTHOR

Dai Okabayashi E<lt>bayashi@cpan.orgE<gt>


=head1 SEE ALSO


=head1 LICENSE

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut
