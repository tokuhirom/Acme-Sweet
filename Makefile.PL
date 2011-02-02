use inc::Module::Install;
use Module::Install::AuthorTests;

name 'Acme-Sweet';
all_from 'lib/Acme/Sweet.pm';

requires
	'Exporter' => 5.63, # use Exporter 'import';
	'Text::Xslate' => 0,
	'HTML::Entities' => 0,
	'URI::Escape' => 0,
	'Time::Piece' => 0,
	'indirect' => 0.23,
	'Smart::Args' => 0,
	'parent' => 0,
	'true' => 0,
	'File::stat' => 0,
	'Time::y2038' => 0,
	'Log::Minimal' => 0,
	'autovivification' => 0,
	'Class::Load' => 0,
	'Perl6::Perl' => 0,
	;

tests 't/*.t t/*/*.t t/*/*/*.t t/*/*/*/*.t';
test_requires 'Test::More' => 0.96; # done_testing, subtest
# test_requires 'Test::Requires';
author_tests('xt');
WriteAll;
