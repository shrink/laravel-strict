<?php

declare(strict_types=1);

return [
    'default' => env('CACHE_DRIVER', 'array'),
    'stores' => [
        'array' => [
            'driver' => 'array',
        ],
    ],
];
