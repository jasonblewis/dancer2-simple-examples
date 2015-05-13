package datatables;

use Dancer2;
use Dancer2::Plugin::REST;
 
prepare_serializer_for_format;
 
# get '/user/:id.:format' => sub {
#     User->find(params->{id});
# };

my %myhash = (
    "42" => "jason",
    "43" => "zaphod",
    "45" => "abc",
    "46" => "def",
);

get qr{^/users\.(?<format>\w+)} => sub {
    return {%myhash};
};

get qr{^/user/(?<id>\d+)\.(?<format>\w+)} => sub {
    return { id => $myhash{captures->{id}}
         };
};

get '/' => sub {
    template 'index';
};

start;

