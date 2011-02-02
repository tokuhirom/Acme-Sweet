package Acme::Sweet;
use strict;
use warnings;
use 5.012002;
our $VERSION = '0.01';
use parent qw/Exporter/;

use mro 'c3';
use URI::Escape qw/uri_escape uri_unescape/;
use HTML::Entities ();
use Time::Piece;
use Encode;
use File::Path qw/mkpath rmtree/;
use List::Util qw/min max first reduce sum shuffle/;
use autobox;
use true;
use Perl6::Caller; # makes caller() returns object in scalar context
use autodie;
use File::stat;
use IO::Handle;
use Log::Minimal;
use autovivification;
use JSON;
use Data::Dumper;
use Class::Load qw/:all/;
use Perl6::Perl qw/p perl/;

STDOUT->autoflush(1);
STDERR->autoflush(1);

sub uniq (@) {
    my %seen = ();
    grep { not $seen{$_}++ } @_;
}

our %EXPORT_TAGS = (
    encode => [qw/encode decode decode_utf8 encode_utf8/],
    file   => [qw/slurp mkpath rmtree/],
    list   => [qw/min max uniq first reduce sum shuffle/],
    time   => [qw/localtime gmtime/],
    json   => [qw/encode_json decode_json/],
    debug  => [qw/p perl/],
    core   => [qw/stat caller/],
    load   => [qw/is_class_loaded load_class load_optional_class try_load_class/],

    web    => [qw/html_escape html_unescape uri_escape uri_unescape/],
    log    => [qw/infof warnf critf ddf/],

);
our @EXPORT = map { @$_ } @EXPORT_TAGS{qw/encode file list debug core time/};
$EXPORT_TAGS{all} = (map { @$_ } values %EXPORT_TAGS);
our @EXPORT_OK = $EXPORT_TAGS{all};

sub import {
    my ($class, @args) = @_;

    strict->import;
    warnings->import;
    feature->import( ':5.10' );
    mro::set_mro( scalar caller(), 'c3' );
    true->import;
    autodie->import;

    require indirect;
    indirect->unimport(':fatal');
    autovivification->unimport();

    $class->export_to_level(1, @_);
}

sub html_unescape ($) {
    HTML::Entities::decode_entities(shift)
}

sub html_escape($) {
    HTML::Entities::encode_entities(shift, q{<>&"'});
}

# same strategy with Perl6
sub slurp($;$$) {
    my ($stuff, $binary, $encoding) = @_;
    $encoding ||= 'utf8';
    my $fh;
    if (ref $stuff) {
        $fh = $stuff;
    } else {
        open $fh, "<:encoding($encoding)", $stuff or die "Cannot open file: $stuff";
    }
    binmode $fh if $binary;
    do { local $/; <$fh> };
}

__END__

=encoding utf8

=head1 NAME

Acme::Sweet -

=head1 SYNOPSIS

  use Acme::Sweet;

=head1 DESCRIPTION

Acme::Sweet is

=head1 TODO

    autoboxing
    lazy loading
    testing

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom AAJKLFJEF GMAIL COME<gt>

=head1 SEE ALSO

=head1 LICENSE

Copyright (C) Tokuhiro Matsuno

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
