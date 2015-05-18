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
  # print Dumper(scalar params);
  my $artist = rset('Artist')->new_result({});
  my $artist_form = MyApp::Form::Artist->new(schema => schema);
  if ($artist_form->process(
                            # item_id => params->{artistid},
                            item => $artist,
                            params => scalar params
                           )) {
    # form validated ok.
    # print "value: " . Dumper($artist_form->value);
    redirect sprintf "/artist/%d", $artist->artistid;
  } else {
    return sprintf "%s\n%s\n",
      Dumper($artist_form->errors),
      Dumper($artist_form->error_field_names);
  }
};


get '/artist.json/:artistid' => sub {
  my $artist = rset('Artist')->find(params->{artistid});



  return $data;
};



start;



