package Test011::Dependency::PackDep;
use Moose;

with 'Resource::Pack' => {
    traits => [
        'Resource::Pack::File' => { extension => 'txt' }
    ]
};

1;
