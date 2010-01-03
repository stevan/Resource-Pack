package Test010::Pack;
use Moose;

with 'Resource::Pack' => {
    traits => [
        'Resource::Pack::File'
    ]
};

1;
