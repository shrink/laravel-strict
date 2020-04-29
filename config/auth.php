<?php

declare(strict_types=1);

return [
    'defaults' => [
        'guard' => 'web',
    ],
    'guards' => [
        'web' => [
            'driver' => 'session',
        ],
    ],
];
