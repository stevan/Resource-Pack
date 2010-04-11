package Test032::Dependency::PackUrl;
use Moose;

with 'Resource::Pack' => {
    traits => [
        'Resource::Pack::URL' => {
            url     => 'http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js',
            sub_dir => 'js'
        }
    ]
};

1;
