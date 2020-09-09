<?php

declare(strict_types=1);

use Monolog\Handler\StreamHandler;

return [
    'default' => env('LOG_CHANNEL', 'stdout'),
    'channels' => [
        'stdout' => [
            'driver' => 'monolog',
            'handler' => StreamHandler::class,
            'with' => [
                'stream' => 'php://stdout',
                'level' => 'warning',
            ],
        ],
        'stack' => [
            'driver' => 'stack',
            'channels' => ['daily'],
            'ignore_exceptions' => false,
        ],
        'daily' => [
            'driver' => 'daily',
            'path' => storage_path('logs/laravel.log'),
            'level' => 'debug',
            'days' => 14,
        ],
    ],
];
