package DBIx::MyParseX;
    our $VERSION = '0.05';

use 5.008008;
use strict;
use warnings;
use DBIx::MyParse;
use DBIx::MyParseX::Query;
use DBIx::MyParseX::Item;

use base 'DBIx::MyParse';

# Preloaded methods go here.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

DBIx::MyParseX - Extensions to DBIx::MyParse

=head1 SYNOPSIS

  use DBIx::MyParseX;

=head1 DESCRIPTION

This extension provides exteneded functionality for the DBIx::MyParse 
module.  Calls DBIx::MyParseX::Query and DBIx::MyParseX::Item

=head2 EXPORT

None by default.



=head1 SEE ALSO

DBIx::MyParse

http://www.opendatagroup.com

=head1 AUTHOR

Christopher Brown, E<lt>ctbrown@cpan.org<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by Open Data Group 

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
