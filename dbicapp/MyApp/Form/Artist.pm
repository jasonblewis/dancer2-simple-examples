package MyApp::Form::Artist;

use HTML::FormHandler::Moose;

extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Table';

use DateTime::Format::DateParse;

has '+item_class' => ( default => 'Artist' );
has '+is_html5' => ( default => 1 );

has_field 'artistid' => ( type => 'Integer', inactive => 1 );
has_field 'name' => ( type => 'Text' );

has_field 'cds' => (type => 'Repeatable');
has_field 'cds.cdid' => ( type => 'PrimaryKey' );
has_field 'cds.title';

has_field 'cds.year' => (
                         type => 'Date',
                         format => '%Y-%m-%d',
                         inflate_method => \&inflate_date,
                         deflate_method => \&deflate_date,
                        );

has_field submit => ( type => 'Submit', value => 'Update', element_class => ['btn'], noupdate => 1 );

no HTML::FormHandler::Moose;

sub inflate_date {
  my ($self, $value) = @_;
  my $dt;
  if (ref $value) {
    $dt = $value;
  } else {
    $dt = DateTime::Format::DateParse->parse_datetime($value);
  }
  return $dt;
}

sub deflate_date {
  my ($self, $value) = @_;
  my $dt;
  if (ref $value) {
    $dt = $value;
  } else {
    $dt = DateTime::Format::DateParse->parse_datetime($value);
  }
  return $dt->strftime('%Y-%m-%d');
}

1;
