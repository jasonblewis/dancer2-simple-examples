package MyApp::Form::Artist;

use HTML::FormHandler::Moose;

extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Table';

has '+item_class' => ( default => 'Artist' );
has '+is_html5' => ( default => 1 );

has_field 'artistid' => ( type => 'Integer');
has_field 'name' => ( type => 'Text' );

has_field 'cds' => (type => 'Repeatable');
has_field 'cds.cdid' => ( type => 'PrimaryKey' );
has_field 'cds.title';

has_field 'cds.year' => (
    type => 'Date', format => 'dd/mm/y',
);

has_field submit => ( type => 'Submit', value => 'Update', element_class => ['btn'], noupdate => 1 );

no HTML::FormHandler::Moose;

1;
