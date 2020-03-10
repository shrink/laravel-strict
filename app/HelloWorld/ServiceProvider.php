<?php

declare(strict_types=1);

namespace App\HelloWorld;

use Illuminate\Http\JsonResponse;
use Illuminate\Routing\Router;
use Illuminate\Routing\RouteRegistrar;
use Illuminate\Support\ServiceProvider as LaravelServiceProvider;

final class ServiceProvider extends LaravelServiceProvider
{
    /**
     * Register simple Hello World component.
     */
    public function boot(RouteRegistrar $registrar): void
    {
        $registrar->group(static function (Router $router): void {
            $router->get('/', static function () {
                return new JsonResponse(['greeting' => 'Hello, World!'], 200);
            });
        });
    }
}
