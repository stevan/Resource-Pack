package Test031::Pack;
use Moose;

with 'Resource::Pack' => {
    depends_on => [
        'Test031::Dependency::PackDep'
    ],
    traits => [
        'Resource::Pack::URL' => {
            url => 'http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js'
        }
    ]
};

1;