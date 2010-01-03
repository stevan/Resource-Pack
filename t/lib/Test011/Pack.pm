package Test011::Pack;
use Moose;

with 'Resource::Pack' => {
    depends_on => [
        'Test011::Dependency::PackDep'
    ],
    traits => [
        'Resource::Pack::File' => { extension => 'txt' }
    ]
};

1;
