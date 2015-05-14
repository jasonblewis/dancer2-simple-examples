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
use Path::Class;

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


post '/artist' => sub {
  my $artist = rset('Artist')->find(params->{artistid});

  my $artist_form = MyApp::Form::Artist->new($artist);
  print Dumper (scalar params);
  $artist_form->process(item_id => params->{artistid},
                        schema => schema,
                        params => scalar params);
};


start;



