package Test031::Dependency::PackDep;
use Moose;

with 'Resource::Pack' => {
    traits => [
        'Resource::Pack::File' => { extension => 'js' }
    ]
};

1;
