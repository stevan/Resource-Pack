package Test040::Dependency::FileWithDep;
use Moose;

with 'Resource::Pack' => {
    traits => [ 'Resource::Pack::File' => { extension => 'js' } ],
    depends_on => [
        'Test040::Dependency::File',
    ],
};

1;
