package Test021::Pack;
use Moose;

with 'Resource::Pack' => {
    depends_on => [
        'Test021::OtherPack'
    ],
    traits => [
        'Resource::Pack::Dir'
    ]
};

1;
