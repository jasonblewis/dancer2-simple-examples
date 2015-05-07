use 5.014;
use Dancer2;
use lib './lib';
use Dancer2::Plugin::Auth::Tiny;
use Dancer2::Session::YAML;

set 'template'     => 'template_toolkit';
set 'logger'       => 'console';
set 'log'          => 'debug';
set 'show_errors'  => 1;
set 'startup_info' => 1;
set 'warnings'     => 1;
set 'layout'       => 'main';



get '/private' => needs login => sub {
    say "in private";
    return "you reached a private url";
};

get '/login' => sub {
    template 'login' => { return_url => params->{return_url} };
};

post '/login' => sub {
    if ( _is_valid( params->{user}, params->{password} ) ) {
        session user => params->{user};
        return redirect params->{return_url} || '/';
    } else {
        template 'login' => { error => "invalid username or password" };
    }
};

sub _is_valid {
    my ($user,$password) = @_;
    return 1;
};


dance;

#curl -v -c cookies.txt --data-urlencode "user=jason" --data-urlencode "password=mypass" --data-urlencode "return_url=http://debian:5000/private" -L http://debian:5000/login
