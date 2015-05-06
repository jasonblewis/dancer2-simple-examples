use 5.014;
use Dancer2;
use Dancer2::Plugin::DBIC qw(schema resultset rset);
use lib './lib';
use Dancer2::Plugin::Auth::Tiny;
use Dancer2::Session::Simple;

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
    # put 'return_url' in a hidden form field
    template 'login' => { return_url => params->{return_url} };
};

post '/login' => sub {
    printf "params user: %s password: %s\n", params->{user}, params->{password};
    if ( _is_valid( params->{user}, params->{password} ) ) {
        say "setting session user";
        session user => params->{user};
        say "user session is: " . session('user') . "< return_url is: ". params->{'return_url'} ; 
        return redirect params->{return_url} || '/';
    } else {
        template 'login' => { error => "invalid username or password" };
    }
};

sub _is_valid {
    my ($user,$password) = @_;
    printf "got user %s pass %s\n",$user, $password;
    return 1;
};


dance;
