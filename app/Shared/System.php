<?php

declare(strict_types=1);

namespace App\Shared;

use Illuminate\Contracts\Foundation\Application;
use Illuminate\Support\ServiceProvider;
use Lcobucci\Clock\Clock;
use Lcobucci\Clock\SystemClock;

final class System extends ServiceProvider
{
    public function boot(Application $app): void
    {
        $app->instance(Clock::class, SystemClock::fromSystemTimezone());
    }
}
