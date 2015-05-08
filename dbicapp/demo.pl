#!/usr/bin/env perl

use strict;
use warnings;

use MyApp::Schema;

use MyApp::Form::Artist;

use Dancer2;

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

get '/artist' => sub {
    my $db_fn = file($INC{'MyApp/Schema.pm'})->dir->parent->file('db/example.db');
    # for other DSNs, e.g. MySql, see the perldoc for the relevant dbd
    # driver, e.g perldoc L<DBD::mysql>.
    my $schema = MyApp::Schema->connect("dbi:SQLite:$db_fn");
    my $artist = $schema->resultset('Artist')->find(1);


    my $artist_form = MyApp::Form::Artist->new($artist);
    template 'artist' => {
        form => $artist_form,
    };
};

post '/artist' => sub {
    
};

start;



