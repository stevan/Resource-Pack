package Test041::Dependency::File1;
use Moose;

with 'Resource::Pack' => {
    traits     => [ 'Resource::Pack::File' => { extension => 'js' } ],
    depends_on => [ 'Test041::Dependency::FileDep1' ],
};

1;
