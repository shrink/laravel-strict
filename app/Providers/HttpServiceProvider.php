<?php

declare(strict_types=1);

namespace App\Providers;

use Illuminate\Contracts\Foundation\Application;
use Illuminate\Routing\Router;
use Illuminate\Routing\RouteRegistrar;
use Illuminate\Support\ServiceProvider;

final class HttpServiceProvider extends ServiceProvider
{
    /**
     * Application's route registrar.
     */
    private RouteRegistrar $registrar;

    public function __construct(
        Application $app,
        ?RouteRegistrar $registrar = null
    ) {
        $this->registrar = $registrar ?? $app->make(RouteRegistrar::class);
    }

    /**
     * Register the HTTP routes for the application.
     *
     * @return void
     */
    public function boot(): void
    {
        $this->registrar->group(static function (Router $router): void {
            $router->get('/', static function () {
                return json_encode(['greeting' => 'Hello, World!']);
            });
        });
    }
}
