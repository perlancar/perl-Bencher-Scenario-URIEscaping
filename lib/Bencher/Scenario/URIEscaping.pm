package Bencher::Scenario::URIEscaping;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use utf8;
use warnings;

# we do this so URI::XSEscape does not override URI::Escape's functions, because
# obviously we want to test both
$ENV{PERL_URI_XSESCAPE} = 0;

our $scenario = {
    summary => 'Benchmark URI escaping using various modules',

    precision => 0.001,
    module_startup_precision => 0.05,

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

        {fcall_template => 'URI::Encode::uri_encode(<str>)', tags=>['escape']},
        {fcall_template => 'URI::Encode::uri_decode(<str>)', tags=>['unescape']},
        {fcall_template => 'URI::Encode::XS::uri_encode(<str>)', tags=>['escape']},
        {fcall_template => 'URI::Encode::XS::uri_decode(<str>)', tags=>['unescape']},
    ],

    datasets => [
        {
            name => 'empty',
            tags => ['escape'],
            include_participant_tags => ['escape'],
            args => {str=>''},
        },
        # sample data from URI-XSEscape distribution
        {
            name => 'ascii53',
            tags => ['escape'],
            include_participant_tags => ['escape'],
            args => {str=>'I said this: you / them ~ us & me _will_ "do-it" NOW!'},
        },
        # sample data from URI-XSEscape distribution
        {
            name => 'utf36',
            tags => ['escape', 'utf8'],
            include_participant_tags => ['escape & utf8'],
            args => {str=>'http://www.google.co.jp/search?q=小飼弾'},
        },
        # sample data from URI-XSEscape distribution
        {
            name => 'u_ascii53',
            tags => ['unescape'],
            include_participant_tags => ['unescape'],
            args => {str=>'I%20said%20this%3a%20you%20%2f%20them%20~%20us%20%26%20me%20_will_%20%22do-it%22%20NOW%21'},
        },

        # sample data from URI-Escape-XS distribution
        {
            name => 'ascii66',
            tags => ['escape'],
            include_participant_tags => ['escape'],
            args => {str=>'https://stackoverflow.com/questions/3629212/how can perls xsub die'},
        },
        # sample data from URI-Escape-XS distribution
        {
            name => 'u_ascii66',
            tags => ['unescape'],
            include_participant_tags => ['unescape'],
            args => {str=>'https%3A%2F%2Fstackoverflow.com%2Fquestions%2F3629212%2Fhow%20can%20perls%20xsub%20die'},
        },
    ],
};

1;
# ABSTRACT:

=head1 BENCHMARK NOTES

L<URI::Encode::XS> is the fastest, but it does not support custom list of safe
characters. If you don't want to encode C</> as C<%2F>, for example, you're out
of luck. For URI escaping with custom character list support, the fastest is
L<URI::XSEscape> followed by L<URI::Escape::XS>.
