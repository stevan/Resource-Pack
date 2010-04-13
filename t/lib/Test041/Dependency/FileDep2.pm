package Test041::Dependency::FileDep2;
use Moose;

with 'Resource::Pack' => {
    traits => [ 'Resource::Pack::File' => { extension => 'js' } ],
};

1;
