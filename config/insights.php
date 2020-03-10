<?php

declare(strict_types=1);

use ObjectCalisthenics\Sniffs\Metrics\MethodPerClassLimitSniff;

return [

    /*
    |--------------------------------------------------------------------------
    | PHP Insights
    |--------------------------------------------------------------------------
    |
    | Configure options used by PHP Insights when running architecture,
    | code, complexity and style checks.
    |
    */

    'remove' => [
        MethodPerClassLimitSniff::class,
    ],

    'requirements' => [
        'min-architecture' => 95,
        'min-complexity' => 95,
        'min-quality' => 95,
        'min-style' => 100,
    ],
];
