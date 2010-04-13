package Test041::Dependency::File2;
use Moose;

with 'Resource::Pack' => {
    traits     => [ 'Resource::Pack::File' => { extension => 'js' } ],
    depends_on => [
        'Test041::Dependency::File1',
        'Test041::Dependency::FileDep2'
    ],
};

1;
