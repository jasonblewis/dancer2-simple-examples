#!/usr/bin/env perl

use strict;
use warnings;

use MyApp::Schema;

use MyApp::Form::Artist;
use Data::Dumper;
use DateTime;

use Dancer2;
set port => '5000';


set 'session'      => 'Simple';
set 'template'     => 'template_toolkit';
set 'logger'       => 'console';
set 'log'          => 'debug';
set 'show_errors'  => 1;
set 'startup_info' => 1;
set 'warnings'     => 1;
set 'layout'       => 'main';


use Path::Class 'file';

get '/' => sub {
    my $db_fn = file($INC{'MyApp/Schema.pm'})->dir->parent->file('db/example.db');
    # for other DSNs, e.g. MySql, see the perldoc for the relevant dbd
    # driver, e.g perldoc L<DBD::mysql>.
    my $schema = MyApp::Schema->connect("dbi:SQLite:$db_fn");
    my @all_artists = $schema->resultset('Artist')->all;
    template 'artists', {
        artists => \@all_artists,
    };
};

get '/artist/:artistid' => sub {
    my $db_fn = file($INC{'MyApp/Schema.pm'})->dir->parent->file('db/example.db');
    # for other DSNs, e.g. MySql, see the perldoc for the relevant dbd
    # driver, e.g perldoc L<DBD::mysql>.
    my $schema = MyApp::Schema->connect("dbi:SQLite:$db_fn");
    my $artist = $schema->resultset('Artist')->find(params->{artistid});


    my $artist_form = MyApp::Form::Artist->new($artist);
    print Dumper( ($artist->cds)[0]->year );
    template 'artist' => {
        form => $artist_form,
    };
};

post '/artist' => sub {
    my $db_fn = file($INC{'MyApp/Schema.pm'})->dir->parent->file('db/example.db');
    # for other DSNs, e.g. MySql, see the perldoc for the relevant dbd
    # driver, e.g perldoc L<DBD::mysql>.
    my $schema = MyApp::Schema->connect("dbi:SQLite:$db_fn");
    my $artist = $schema->resultset('Artist')->find(params->{artistid});

    my $artist_form = MyApp::Form::Artist->new($artist);
    print Dumper (scalar params);
    $artist_form->process(item_id => params->{artistid},
                          schema => $schema,
                          params => scalar params);
};


start;



