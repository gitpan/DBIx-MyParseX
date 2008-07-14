package DBIx::MyParseX::Item;
  our $VERSION = '0.05';
    
  use 5.008008;
  use base 'DBIx::MyParse::Item';
  use DBIx::MyParse;
  use DBIx::MyParse::Item;
  use DBIx::MyParseX;


  1;

# ---------------------------------------------------------------------
# package DBIx::MyParse::Item
#   WE set the package to 'DBIx::MyParse::Item' since this package 
#   provides ONLY extension methods and no methods in its own namespace
#
package DBIx::MyParse::Item;

use strict;
use warnings;
use Carp;

use List::MoreUtils qw( any );
use Perl6::Say;
use YAML;

# Preloaded methods go here.

# ----------------------------------------------------------------------
# SUB: renameTable
#   USAGE: $table_item->rename( $new_name ) 
#
#   No return value, exist solely for it's side-effects.  Case switches
#   based on the type of item.
#
#   TODO: 
#     x Generalize to any DBIx::MyParse::Item?
#     - Handle subquery objects 
#
# ----------------------------------------------------------------------
sub renameTable {

    my $item = shift;

    my $old_table_name = shift;
    my $new_table_name = shift;

  # TRAP non DBIx::MyParse::Items
    Carp( "Cannot renameTable for non-DBIx::MyParse::Item" ) 
        if ( ref $item ne 'DBIx::MyParse::Item' );

  # CASE-SWITCH on DBIx::MyParse::Item::Type

  # ----------------------------------------------------------
  # CASE: JOIN_ITEM
  #   JOIN_ITEMs contains more than one table therefore, we 
  #   recurse on each subitem.   
  # ----------------------------------------------------------
    if ( $item->getItemType eq 'JOIN_ITEM' ) {

        foreach my $join_item ( @{ $item->getJoinItems } ) {
            
            $join_item->renameTable( $old_table_name, $new_table_name );

        }

    } # END CASE: JOIN_ITEM


  # ---------------------------------------------------------- 
  # CASE: FUNC_ITEMi, COND_ITEM, COND_AND_FUNC
  #   similar to JOIN_ITEM.  Dispatch on getArguments
  # ---------------------------------------------------------- 
   if ( 
        any { $item->getItemType eq $_ }  
        qw( FUNC_ITEM COND_ITEM COND_AND_FUNC ) 
   ) {
           
        foreach my $arg ( @{ $item->getArguments } ) {

            $arg->renameTable( $old_table_name, $new_table_name );

        }
          
   } # END CASE: FUNC_ITEM               
                            
            
  # ----------------------------------------------------------
  # CASE: TABLE_ITEM, FIELD_ITEM
  #    match on regular expression match
  # ----------------------------------------------------------
    if ( 
         any { $item->getItemType eq $_  }  qw( TABLE_ITEM FIELD_ITEM ) 
    ) {
      
      # TEST for match on old table name. 
      # TableName must exist and match for it to be changed otherwise ...
      # there is nothing to change
        if ( 
             $item->getTableName && 
             $item->getTableName  =~ m/$old_table_name/ 
        ) {
            
            $item->setTableName( $new_table_name );

        }

    } # END CASE: TABLE_ITEM 

            
    
} # END SUB: renameTable




1;
__END__

=head1 NAME

DBIx::MyParseX::Item - Extensions to DBIx::MyParse::Item

=head1 SYNOPSIS

  use DBIx::MyParseX::Item;

  $item->renameTable( 'old_table', 'new_table' );

=head1 DESCRIPTION

This extension provides exteneded functionality for the DBIx::MyParse::Item 
module.  
  
Calls DBIx::MyParse, DBIx::MyParseX and DBIx::MyParse::Item.

=head1 METHOD

=head2 renameTable

$item->renameTable( 'old_name', 'new_name' )


=head1 Disadvantages

Since the orignal DBIx::MyParse package does not make seperate objects for each ot the
items, relying instead on ItemType, we must follow the framework.

=head1 TODO

- Create objects for each of the item types that inherit from DBI::MyParse::Item/


=head2 EXPORT

None by default.



=head1 SEE ALSO

DBIx::MyParse, DBIx::MyParse::Item, DBIx::MyParseX:, MySQL 

http://www.opendatagroup.com

=head1 AUTHOR

Christopher Brown, E<lt>ctbrown@cpan.org<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by Open Data Group 

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
