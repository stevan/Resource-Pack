package Test040::Pack;
use Moose;

with 'Resource::Pack' => {
    traits     => [ 'Resource::Pack::Dir' ],
    depends_on => [
        'Test040::Dependency::File',
        'Test040::Dependency::FileWithDep',
    ],
};

1;
