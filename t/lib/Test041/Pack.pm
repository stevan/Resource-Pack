package Test041::Pack;
use Moose;

with 'Resource::Pack' => {
    traits     => [ 'Resource::Pack::Dir' ],
    depends_on => [
        'Test041::Dependency::File1',
        'Test041::Dependency::File2',
    ],
};

1;
