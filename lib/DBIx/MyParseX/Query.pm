package DBIx::MyParseX::Query;
  our $VERSION = '0.05';
  use base 'DBIx::MyParse::Query';    
    1;

# ---------------------------------------------------------------------
# package DBIx::MyParse::Query
#   WE set the package to 'DBIx::MyParse::Query' since this package 
#   provides ONLY extension methods and no methods in its own namespace
#
package DBIx::MyParse::Query;   

use 5.008008;
use strict;
use warnings;
use DBIx::MyParse;
use DBIx::MyParse::Query;
use DBIx::MyParseX;


# --------------------------------------------------------------------
# SUB: renameTable 
#
#   package: DBIx::MyParse::Query
#   Usage:
#       $q->renameTable( old_name, new_name )
#
#   Given a query, will rename all the tables with the new name
#   has no return value, exists for the side-effects.
#
#   Modifies tables in the select, from, where, group by clauses
#   by calling: 
#     renameTableSelect 
#     renameTableFrom 
#     renameTableWhere 
#     renameGroupBy
#
# --------------------------------------------------------------------
sub renameTable {

    my $q = shift;  # The DBIx::MyParse::Query object

    carp( "A non DBIx:;MyParse::Query Object was passed to renameTable()" ) 
        if ( ref $q  ne 'DBIx::MyParse::Query' );
    
    my $old_table_name = shift;
    my $new_table_name = shift;
     
  # Handle FROM clause
    $q->renameTableSelect( $old_table_name, $new_table_name );
    $q->renameTableFrom( $old_table_name, $new_table_name );
    $q->renameTableWhere( $old_table_name, $new_table_name ); 
    # $q->renameTableGroup( $old_table_name, $new_table_name );
    $q->renameTableOrder( $old_table_name, $new_table_name );
    $q->renameTableHaving( $old_table_name, $new_table_name );

    # $q->renameTableGroupBy( $old_table_name, $new_table_name );
    
} # END sub: renameTable


# ----------------------------------------------------------------------
# SUB: renameTableSelect 
#   package: DBIx::MyParse::Query
#   USAGE:
#     $q->renameTablesSelect( $old_table_name, $new_table_name );
#
# Renames all the tables in the Select Clause.
# * It seems that 
# ----------------------------------------------------------------------
sub renameTableSelect {

    my $q = shift;  # DBIx::MyParse::Query object

    my $old_table_name = shift;
    my $new_table_name = shift;

    return 1 if ( ! $q->getSelectItems );   # Trap non-existant SELECT clause;

    foreach my $item ( @{ $q->getSelectItems } ) {
        
        $item->renameTable( $old_table_name, $new_table_name );

    }
        
} # End sub: rename TableSelect


# --------------------------------------------------------------------
# SUB: renameTableOrder
#   Usage:
#     $q->renameTableOrder( $old_table_name, $new_table_name );
#
# --------------------------------------------------------------------
sub renameTableOrder {
    
    my $q = shift; # DBIx::MyParse::Query
        
    my $old_table_name = shift;
    my $new_table_name = shift; 
    
    return 1 if ( ! $q->getOrder );     # Trap non existant ORDER BY clause

    foreach my $item ( @{ $q->getOrder } ) {

        $item->renameTable( $old_table_name, $new_table_name );

    }
    
}


# --------------------------------------------------------------------
# SUB: renameTableGroup
#   Usage:
#     $q->renameTableGroup( $old_table_name, $new_table_name );
#
#  Renames $old_table_name to $new_table_name in the GROUP BY clause   
# --------------------------------------------------------------------
sub renameTableGroup {

    my $q = shift; # DBIx::MyParse::Query object

    my $old_table_name = shift;
    my $new_table_name = shift; 

    return 1 if ( ! $q->getGroup ) ; # Trap no GROUP BY clause 

    foreach my $item ( @{ $q->getGroup } ) {

        $item->renameTable( $old_table_name, $new_table_name );

    }

} # END SUB: renameTableGroup



# --------------------------------------------------------------------
#  SUB: renameTableHaving
#    USAGE:
#      $q->renameTableHaving( $old_table_name, $new_table_name );
#
#  Renames all $old_table_name to $new_table_name for each table in 
#  the Having clause
#
# --------------------------------------------------------------------
sub renameTableHaving {

    my $q = shift;

    my $old_table_name = shift;
    my $new_table_name = shift;

    return 1 if ( ! $q->getHaving ); # Trap no HAVING clause

    $q->getHaving->renameTable( $old_table_name, $new_table_name );
    
} # END SUB: renameTableHaving



# --------------------------------------------------------------------
# SUB: renameTableWhere
#   Simple dispatch to renameTable since getWhere returns type
#   DBIx::MyParse::Item
# --------------------------------------------------------------------
sub renameTableWhere {

    my $q = shift;  # DBIx::MyParse::Query object

    my $old_table_name = shift;
    my $new_table_name = shift;

    return 1 if ( ! $q->getWhere );     # Trap non-existant WHERE clause 

  # getWhere
    $q->getWhere->renameTable( $old_table_name, $new_table_name );

}


# ----------------------------------------------------------------------
# SUB: renameTableFrom 
#  package: DBIx::MyParse::Query 
#  USAGE:
#    $q->renameTablesFrom( old_table_name, new_table_name ) 
#  
#  This is a liollt more complicated than the other renameTableXX methods
#  since it requires a recursion
#
#  This is refactored from parse.pl:doTables
# ----------------------------------------------------------------------
sub renameTableFrom {
        
    my $q = shift;  # DBIx::MyParse::Query or DBIx::MyParse::Item object. 
    # carp( "A non DBIx:;MyParse::Query Object was passed to renameTableFrom()" ) 
    #    if ( ref( $q )  ne 'DBIx::MyParse::Query' );

    my $old_table_name = shift;
    my $new_table_name = shift;


    my $tables; 
    if ( ref $q eq 'DBIx::MyParse::Query' ) { 
      # Retrieve the tables from the FROM clause 
      # Somewhat surprisingly this is the getTables method
        $tables = $q->getTables();
    } else {
        $tables = $q ;
    }
    

  # COLLECTIONS
    if ( ref $q eq 'DBIx::MyParse::Query' ) { 
  
        foreach my $table ( @$tables ) {

            &renameTableFrom( $table, $old_table_name, $new_table_name );
            
        }
             

  # SINGLE DBIx::MyParse::Item            

    } elsif ( ref $tables eq  'DBIx::MyParse::Item' ) {

      # Calls the proper method based on the object type.
        # $tables->renameTable( $old_table_name, $new_table_name );

      # DBIx::MyParseX::Item::renameTable()
      #     Handles cases for each type of item 
        $tables->renameTable( $old_table_name, $new_table_name );

    } else {

        Carp( "Rename tables failed.\n" );

    }

} # END sub: renameTableFrom


1;


__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

DBIx::MyParseX::Query - Extended methods to DBIx::MyParse::Query

=head1 SYNOPSIS

    use DBIx::MyParseX;
    my $p = DBIx::MyParse->new();
    my $q = $p->parse( "select ..." );

  # Query Manipulation methods
    $q->renameTable( 'old_table', 'new_table' );  


=head1 DESCRIPTION

This extension provides exteneded functionality for the DBIx::MyParse::Query 
module.  Calls DBIx::MyParse::Query and DBIx::MyParseX.  Extends 
DBIx::MyParse::Query.   

All methods are defined in the DBIx::MyParse::Query package space


=head2 EXPORT

None by default.

=head1 TODO

Refactor to reduce the number of renameTableXX subroutines.


=head1 SEE ALSO

DBIx::MyParse, DBIx::MyParse::Query, DBIx::MyParseX, MySQL

http://www.opendatagroup.com

=head1 AUTHOR

Christopher Brown, E<lt>ctbrown@cpan.org<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by Open Data Group 

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
