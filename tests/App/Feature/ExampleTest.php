<?php

declare(strict_types=1);

namespace Tests\App\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\App\TestCase;

final class ExampleTest extends TestCase
{
    /**
     * A basic test example.
     */
    public function testBasicTest(): void
    {
        $response = $this->get('/');

        $response->assertStatus(200);
        $response->assertJson(['greeting' => 'Hello, World!']);
    }
}
