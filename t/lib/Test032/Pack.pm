package Test032::Pack;
use Moose;

with 'Resource::Pack' => {
    depends_on => [
        'Test032::Dependency::PackUrl'
    ],
    traits => [
        'Resource::Pack::Dir'
    ]
};

1;
