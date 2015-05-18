#!/usr/bin/env perl

use strict;
use warnings;
use Carp::Always;

use MyApp::Schema;

use MyApp::Form::Artist;
use Data::Dumper;
use DateTime;

use Dancer2;
use Dancer2::Plugin::DBIC qw(schema resultset rset);
use DBIx::Class::ResultClass::HashRefInflator;
use Path::Class;

use JSON;

set port         => 5000;
set session      => 'Simple';
set template     => 'template_toolkit';
set logger       => 'console';
set log          => 'debug';
set show_errors  => 1;
set startup_info => 1;
set warnings     => 1;
set layout       => 'main';



get '/' => sub {
  my @all_artists = rset('Artist')->all;
  template 'artists', {
                       artists => \@all_artists,
                      };
};

get '/artist/:artistid' => sub {
  my $artist = rset('Artist')->find(params->{artistid});
  if ($artist) {
    my $artist_form = MyApp::Form::Artist->new($artist);
    template 'artist' => {
                          form => $artist_form,
                         };
  } else {
    return "artist not found";
  }
};

get '/a/:artistid' => sub {
  my $artist = rset('Artist')->find(params->{artistid});

  my $artist_form = MyApp::Form::Artist->new($artist);
  print Dumper( ($artist->cds)[0]->year );
  template 'artist' => {
                        form => $artist_form,
                       };
};

get '/artist/' => sub {
  my $artist_form = MyApp::Form::Artist->new();
  template 'artist' => {
                        form => $artist_form,
                       };
  # return 'get artist';
};

post '/artist/' => sub {
  my $artist = rset('Artist')->find_or_new(scalar params);

  my $artist_form = MyApp::Form::Artist->new();
  if ($artist_form->process( item => $artist,
                             params => scalar params )) {
    # form validated ok.
    print "value: " . Dumper($artist_form->value);
    $artist->insert;
  } else {
    return 'error validating form';
  }

  print Dumper($artist_form)
};


get '/artist.json/:artistid' => sub {
  my $artist = rset('Artist')->find(params->{artistid});
  $artist->result_class('DBIx::Class::ResultClass::HashRefInflator');
  #print Dumper $artist;
  my $json = JSON::XS->new;
  my $data = $json->convert_blessed->encode($artist);
  #print $q->header('application/json;charset=utf-8'), $data;
  return $data;
};

# post '/artist' => sub {
#   my $artist = rset('Artist')->find(params->{artistid});

#   my $artist_form = MyApp::Form::Artist->new($artist);
#   print Dumper (scalar params);
#   $artist_form->process(item_id => params->{artistid},
#                         schema => schema,
#                         params => scalar params);
# };


start;



