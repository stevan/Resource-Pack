package Test041::Dependency::FileDep1;
use Moose;

with 'Resource::Pack' => {
    traits => [ 'Resource::Pack::File' => { extension => 'js' } ],
};

1;
