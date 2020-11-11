<?php

declare(strict_types=1);

use Illuminate\Config\Repository as Config;
use Illuminate\Contracts\Foundation\Application;
use Illuminate\Foundation\Application as Laravel;
use Illuminate\Foundation\Bootstrap\LoadConfiguration;

$app = new Laravel(dirname(__DIR__));

$app->instance(LoadConfiguration::class, new class {
    public function bootstrap(Application $app) {
        return;
    }
});

$app->instance('config', new Config([
    'app' => [
        'name' => 'Laravel Project',

        'key' => env('APP_KEY'),
        'cipher' => 'AES-256-CBC',

        'debug' => env('APP_DEBUG', false),
        'env' => $app->env = env('APP_ENV', 'production'),
        'url' => env('APP_URL', 'http://localhost'),
        'asset_url' => env('ASSET_URL', null),

        'timezone' => (static function (string $timezone): string {
            date_default_timezone_set($timezone);
            return $timezone;
        })('UTC'),

        'encoding' => (static function (string $encoding): string {
            mb_internal_encoding($encoding);
            return $encoding;
        })('UTF-8'),

        'locale' => 'en',
        'fallback_locale' => 'en',

        'providers' => [
            Illuminate\Auth\AuthServiceProvider::class,
            Illuminate\Broadcasting\BroadcastServiceProvider::class,
            Illuminate\Bus\BusServiceProvider::class,
            Illuminate\Cache\CacheServiceProvider::class,
            Illuminate\Foundation\Providers\ConsoleSupportServiceProvider::class,
            Illuminate\Cookie\CookieServiceProvider::class,
            Illuminate\Database\DatabaseServiceProvider::class,
            Illuminate\Encryption\EncryptionServiceProvider::class,
            Illuminate\Filesystem\FilesystemServiceProvider::class,
            Illuminate\Foundation\Providers\FoundationServiceProvider::class,
            Illuminate\Hashing\HashServiceProvider::class,
            Illuminate\Mail\MailServiceProvider::class,
            Illuminate\Notifications\NotificationServiceProvider::class,
            Illuminate\Pagination\PaginationServiceProvider::class,
            Illuminate\Pipeline\PipelineServiceProvider::class,
            Illuminate\Queue\QueueServiceProvider::class,
            Illuminate\Redis\RedisServiceProvider::class,
            Illuminate\Auth\Passwords\PasswordResetServiceProvider::class,
            Illuminate\Session\SessionServiceProvider::class,
            Illuminate\Translation\TranslationServiceProvider::class,
            Illuminate\Validation\ValidationServiceProvider::class,
            Illuminate\View\ViewServiceProvider::class,
            App\HelloWorld\ServiceProvider::class,

            App\Shared\System::class,

            Shrink\Conductor\Laravel\Conductor::class,
        ],
    ],
    'auth' => [
        [
            'defaults' => [
                'guard' => 'web',
            ],
            'guards' => [
                'web' => [
                    'driver' => 'session',
                ],
            ],
        ],
    ],
    'cache' => [
        'default' => env('CACHE_DRIVER', 'array'),
        'stores' => [
            'array' => [
                'driver' => 'array',
            ],
        ],
    ],
    'database' => [
        'default' => env('DB_CONNECTION'),
        'connections' => [
            'sqlite' => [
                'driver' => 'sqlite',
                'url' => '',
                'database' => env('DB_DATABASE'),
                'prefix' => '',
                'foreign_key_constraints' => true,
            ],
            'mysql' => [
                'driver' => 'mysql',
                'url' => '',
                'host' => env('DB_HOST'),
                'port' => env('DB_PORT'),
                'database' => env('DB_DATABASE'),
                'username' => env('DB_USERNAME'),
                'password' => env('DB_PASSWORD'),
                'unix_socket' => '',
                'charset' => 'utf8mb4',
                'collation' => 'utf8mb4_unicode_ci',
                'prefix' => '',
                'prefix_indexes' => true,
                'strict' => true,
                'engine' => null,
                'options' => [],
            ],
        ],
        'migrations' => 'migrations',
    ],
    'logging' => [
        'default' => 'stdout',
        'channels' => [
            'stdout' => [
                'driver' => 'monolog',
                'handler' => Monolog\Handler\StreamHandler::class,
                'with' => [
                    'stream' => 'php://stdout',
                    'level' => 'warning',
                ],
            ],
        ],
    ],
    'session' => [
        'driver' => env('SESSION_DRIVER', 'array'),
    ],
    'view' => [
        'paths' => [resource_path('views')],
        'compiled' => storage_path('views'),
    ],
]));

$app->singleton(
    Illuminate\Contracts\Http\Kernel::class,
    Illuminate\Foundation\Http\Kernel::class
);

$app->singleton(
    Illuminate\Contracts\Console\Kernel::class,
    Illuminate\Foundation\Console\Kernel::class
);

$app->singleton(
    Illuminate\Contracts\Debug\ExceptionHandler::class,
    Illuminate\Foundation\Exceptions\Handler::class
);

return $app;
