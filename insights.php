<?php

declare(strict_types=1);

use PhpCsFixer\Fixer\Import\OrderedImportsFixer;

return [
    'requirements' => [
        'min-architecture' => 100,
        'min-complexity' => 95,
        'min-quality' => 100,
        'min-style' => 100,
    ],
    'config' => [
        OrderedImportsFixer::class => [
            'imports_order' => ['class', 'const', 'function'],
            'sort_algorithm' => 'alpha',
        ],
    ],
];
