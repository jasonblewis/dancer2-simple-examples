package MyApp::Schema::Result::Cd;

use warnings;
use strict;

use DateTime::Format::DateParse;

use base qw( DBIx::Class::Core );

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('cd');

__PACKAGE__->add_columns(
  cdid => {
    data_type => 'integer',
    is_auto_increment => 1
  },
  artistid => {
    data_type => 'integer',
  },
  title => {
    data_type => 'text',
  },
  year => {
      data_type => 'date',
      is_nullable => 1,
  },
);

__PACKAGE__->set_primary_key('cdid');

__PACKAGE__->add_unique_constraint([qw( title artistid )]);

__PACKAGE__->belongs_to('artist' => 'MyApp::Schema::Result::Artist', 'artistid');
__PACKAGE__->has_many('tracks' => 'MyApp::Schema::Result::Track', 'cdid');

# # if we just want to store the date, not the full ISO8601 datetime
# __PACKAGE__->inflate_column('year', {
#   inflate => sub {
#     my ($raw_value, $result_object) = @_;
#     DateTime::Format::DateParse->parse_datetime($raw_value);
#   },
#   deflate => sub {
#     my ($datetime, $result_object) = @_;
#     $datetime->strftime('%Y-%m-%d');
#   },
# });

1;
