package MyApp::Form::Artist;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Table';

has '+item_class' => ( default => 'Artist' );

has_field 'artistid' => ( type => 'Integer');
has_field 'name' => ( type => 'Text' );

has_field 'cds' => (type => 'Repeatable');
has_field 'cds.cdid' => ( type => 'PrimaryKey' );
has_field 'cds.title';

has_field 'cds.year' => (
    type => 'Compound',
    apply => [ { transform => sub{ DateTime->new( $_[0] ) } } ],
    deflation => sub { { myyear => $_[0]->year, mymonth => $_[0]->month, myday => $_[0]->day } },
    fif_from_value => 1,
);
has_field 'cds.year.year' ;
#has_field 'cds.year.month';
#has_field 'cds.year.day'  ;

has_field submit => ( type => 'Submit', value => 'Update', element_class => ['btn'] );

no HTML::FormHandler::Moose;

1;
