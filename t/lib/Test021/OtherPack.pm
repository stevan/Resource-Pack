package Test021::OtherPack;
use Moose;

with 'Resource::Pack' => {
    traits => [
        'Resource::Pack::Dir'
    ]
};

1;
