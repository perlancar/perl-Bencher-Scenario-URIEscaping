package Bencher::Scenario::URIEscaping;

# DATE
# VERSION

use 5.010001;
use strict;
use utf8;
use warnings;

# we do this so URI::XSEscaoe does not override URI::Escape's functions, because
# obviously we want to test both
$ENV{PERL_URI_XSESCAPE} = 0;

our $scenario = {
    summary => 'Benchmark URI escaping using various modules',

    precision => 0.001,

    participants => [
        {fcall_template => 'URI::Escape::uri_escape(<str>)', tags=>['escape']},
        {fcall_template => 'URI::Escape::uri_escape_utf8(<str>)', tags=>['escape', 'utf8']},
        {fcall_template => 'URI::Escape::uri_unescape(<str>)', tags=>['unescape']},
        {fcall_template => 'URI::XSEscape::uri_escape(<str>)', tags=>['escape']},
        {fcall_template => 'URI::XSEscape::uri_escape_utf8(<str>)', tags=>['escape', 'utf8']},
        {fcall_template => 'URI::XSEscape::uri_unescape(<str>)', tags=>['unescape']},
        {fcall_template => 'URI::Escape::XS::uri_escape(<str>)', tags=>['escape']},
        #{fcall_template => 'URI::Escape::XS::uri_escape_utf8(<str>)', tags=>['escape', 'utf8']},
        {fcall_template => 'URI::Escape::XS::uri_unescape(<str>)', tags=>['unescape']},
    ],

    datasets => [
        {
            name => 'empty',
            tags => ['escape'],
            include_participant_tags => ['escape'],
            args => {str=>''},
        },
        {
            name => 'ascii53',
            tags => ['escape'],
            include_participant_tags => ['escape'],
            args => {str=>'I said this: you / them ~ us & me _will_ "do-it" NOW!'},
        },
        {
            name => 'utf36',
            tags => ['escape', 'utf8'],
            include_participant_tags => ['escape & utf8'],
            args => {str=>'http://www.google.co.jp/search?q=小飼弾'},
        },
        {
            name => 'u_ascii53',
            tags => ['unescape'],
            include_participant_tags => ['unescape'],
            args => {str=>'I%20said%20this%3a%20you%20%2f%20them%20~%20us%20%26%20me%20_will_%20%22do-it%22%20NOW%21'},
        },
    ],
};

1;
# ABSTRACT:
