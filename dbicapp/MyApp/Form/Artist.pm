package MyApp::Form::Artist;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';

has '+item_class' => ( default => 'Artist' );

has_field 'artistid' => ( type => 'Integer');
has_field 'name' => ( type => 'Text' );

has_field 'cds' => (type => 'Repeatable');
has_field 'cds.cdid' => ( type => 'PrimaryKey' );
has_field 'cds.title';
has_field 'cds.year';

no HTML::FormHandler::Moose;

1;
