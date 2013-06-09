use strict;
use warnings;
use Statistics::Swoop;
use Statistics::Lite qw//;

use Benchmark qw/timethese cmpthese/;

my @LIST = (1..10000);

my $swoop = sub {
    my $ss = Statistics::Swoop->new(\@LIST);
    return(
        $ss->sum,
        $ss->max,
        $ss->min,
        $ss->range,
        $ss->avg,
    );
};

my $lite = sub {
    return(
        Statistics::Lite::sum(@LIST),
        Statistics::Lite::max(@LIST),
        Statistics::Lite::min(@LIST),
        Statistics::Lite::range(@LIST),
        Statistics::Lite::mean(@LIST),
    );
};

my $result = timethese( -1 => +{
    'Swoop' => $swoop,
    'Lite'  => $lite,
});

cmpthese $result;
