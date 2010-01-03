package Test020::Pack;
use Moose;

with 'Resource::Pack' => {
    traits => [
        'Resource::Pack::Dir'
    ]
};

1;
