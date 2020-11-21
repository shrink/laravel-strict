<?php

declare(strict_types=1);

namespace App\Shared;

use Illuminate\Contracts\Foundation\Application;
use Illuminate\Support\ServiceProvider;
use Lcobucci\Clock\Clock;
use Shrink\Conductor\AggregateDependency;
use Shrink\Conductor\Laravel\CollectsApplicationDependencyChecks;
use Shrink\Conductor\Laravel\Dependencies\DatabaseSchema;

final class Health extends ServiceProvider
{
    public function boot(Application $app): void
    {
        /** @var Clock $clock */
        $clock = $app->make(Clock::class);

        /** @var CollectsApplicationDependencyChecks $checks */
        $checks = $app->make(CollectsApplicationDependencyChecks::class);

        /** @var DatabaseSchema $databaseSchema */
        $databaseSchema = $app->make(DatabaseSchema::class);

        $checks->addDependencyCheck('schema', $databaseSchema);

        $application = new AggregateDependency($clock, [
            $databaseSchema,
        ]);

        $checks->addDependencyCheck('application', $application);
    }
}
