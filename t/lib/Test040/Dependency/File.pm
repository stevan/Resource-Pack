package Test040::Dependency::File;
use Moose;

with 'Resource::Pack' => {
    traits => [ 'Resource::Pack::File' => { extension => 'js' } ],
};

1;
