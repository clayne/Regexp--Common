#!/usr/bin/perl

use strict;
use warnings;
no  warnings 'syntax';

use Regexp::Common;
use Test::More;

my $r = eval "require Test::Regexp; 1";

unless ($r) {
    print "1..0 # SKIP Test::Regexp not found\n";
    exit;
}

my @valid = ((map {sprintf "%04d" => $_}
               200,          800 ..  801,  804,          810 ..  815,
               820 ..  822,  828 ..  832,  834 ..  840,  845 ..  847,
               850 ..  854,  860 ..  862,  870 ..  875,  880 ..  881,
               885 ..  886,  909),

              1215,   1220, 1225,   1230, 1235,   1240, 1300,   1335, 
              1340,   1350, 1355,   1360, 1435,   1445, 1450,   1455,
              1460,         1465 .. 1466, 1470,   1475, 1480 .. 1481,
              1485,   1490, 1495,   1499, 1515,   1560, 1565,   1570,
              1585,   1590, 1595,   1630, 1635,   1640, 1655,   1660,
              1670,   1675, 1680,   1685, 1700 .. 1701, 1710,   1715,
              1730,   1750, 1755,   1765, 1790,   1800, 1805,   1811,
              1825,   1835, 1851,   1860, 1871,   1875, 1885,   1890,

              2000 .. 2002, 2004,         2006 .. 2012, 2015 .. 2050,
              2052,   2057, 2059 .. 2077, 2079 .. 2090, 2092 .. 2097,
              2099 .. 2138, 2140 .. 2148, 2150 .. 2168, 2170 .. 2179,
              2190 .. 2200, 2203 .. 2214, 2216 .. 2234, 2250 .. 2251,
              2256 .. 2265, 2267,   2278, 2280 .. 2287, 2289 .. 2300,
              2302 .. 2312, 2314 .. 2330, 2333 .. 2348, 2350 .. 2361,
              2365,         2369 .. 2372, 2379 .. 2382, 2386 .. 2388,
              2390,         2395 .. 2406, 2408 .. 2411, 2415,
              2420 .. 2431, 2439 .. 2441, 2443 .. 2450, 2452 .. 2456,
              2460,         2462 .. 2466, 2469 .. 2490, 2500,   2502,
              2505 .. 2506, 2508,         2515 .. 2520, 2522,
              2525 .. 2530, 2533 .. 2541, 2545 .. 2546, 2548 .. 2551,
              2555 .. 2560, 2563 .. 2588, 2590,   2594,
              2600 .. 2612, 2614 .. 2633, 2640 .. 2653, 2655 .. 2656,
              2658 .. 2661, 2663,         2665 .. 2666, 2668 .. 2669,
              2671 .. 2672, 2675,   2678, 2680 .. 2681, 2700 .. 2703,
              2705 .. 2708, 2710 .. 2717, 2720 .. 2722, 2725 .. 2727,
              2729 .. 2739, 2745,         2747 .. 2754, 2756 .. 2763,
              2765 .. 2770, 2773 .. 2780, 2782 .. 2787, 2790 .. 2795,
              2797 .. 2800, 2803 .. 2810, 2817 .. 2818, 2820 .. 2836,
              2838 .. 2840, 2842 .. 2850, 2852,         2864 .. 2871,
              2873 .. 2880, 2890,         2898 .. 2906, 2911 .. 2914,



);

my %valid        =   map {$_  =>  1} @valid;
my %invalid      =   map {$_  =>  1} grep {!$valid {$_}} "0000" .. "2999";
my @invalid      =  sort {$a <=> $b} keys %invalid;


my $Test = Test::Regexp:: -> new -> init (
    pattern       =>  $RE {zip} {Australia},
    keep_pattern  =>  $RE {zip} {Australia} {-keep},
    name          => "Australian zip codes",
);


#
# Test all valid numbers
#
foreach my $valid (@valid) {
    $Test -> match ($valid,
                   [$valid, undef, $valid],
                   test => "Postal code $valid");
}

#
# Test all invalid 4-digit numbers
#
foreach my $invalid (@invalid) {
    $Test -> no_match ($invalid, reason => "Unused zip code $invalid");
}


#
# Can we prefix the zip code?
#
$Test -> match ("AU-0909",
               ["AU-0909", "AU", "0909"],
               test => "Use iso prefix");

$Test -> match ("AUS-0909",
               ["AUS-0909", "AUS", "0909"],
               test => "Use cept prefix");

$Test -> no_match ("AUT-0909", reason => "Invalid prefix");

done_testing;