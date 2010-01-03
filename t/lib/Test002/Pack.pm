package Test002::Pack;
use Moose;

with 'Resource::Pack' => {
    depends_on => [
        'Test002::Dependency::Pack'
    ]
};

1;
