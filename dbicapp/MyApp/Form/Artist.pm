package MyApp::Form::Artist;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';

has '+item_class' => ( default => 'Artist' );

has_field 'name' => ( type => 'Text' );

no HTML::FormHandler::Moose;

1;
