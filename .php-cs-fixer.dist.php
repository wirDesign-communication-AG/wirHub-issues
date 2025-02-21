<?php

$finder = (new PhpCsFixer\Finder())
    ->in([
        __DIR__ . '/migrations',
        __DIR__ . '/src',
        __DIR__ . '/tests',
        __DIR__ . '/vendor/wirdesign-communication-ag/wirhub/Command',
        __DIR__ . '/vendor/wirdesign-communication-ag/wirhub/Controller',
        __DIR__ . '/vendor/wirdesign-communication-ag/wirhub/DataFixtures',
        __DIR__ . '/vendor/wirdesign-communication-ag/wirhub/DependencyInjection',
        __DIR__ . '/vendor/wirdesign-communication-ag/wirhub/Domain',
        __DIR__ . '/vendor/wirdesign-communication-ag/wirhub/Entity',
        __DIR__ . '/vendor/wirdesign-communication-ag/wirhub/EventListener',
        __DIR__ . '/vendor/wirdesign-communication-ag/wirhub/EventSubscriber',
        __DIR__ . '/vendor/wirdesign-communication-ag/wirhub/Form',
        __DIR__ . '/vendor/wirdesign-communication-ag/wirhub/Migrations',
        __DIR__ . '/vendor/wirdesign-communication-ag/wirhub/Repository',
        __DIR__ . '/vendor/wirdesign-communication-ag/wirhub/Router',
        __DIR__ . '/vendor/wirdesign-communication-ag/wirhub/Security',
        __DIR__ . '/vendor/wirdesign-communication-ag/wirhub/Services',
        __DIR__ . '/vendor/wirdesign-communication-ag/wirhub/Tests',
        __DIR__ . '/vendor/wirdesign-communication-ag/wirhub/Twig',
    ])
    ->exclude('var');

return (new PhpCsFixer\Config())
    ->setRules([
        '@Symfony' => true,
        'concat_space' => [
            'spacing' => 'one',
        ],
        'global_namespace_import' => [
            'import_classes' => true,
            'import_constants' => true,
            'import_functions' => true,
        ],
        'phpdoc_to_comment' => [
            'ignored_tags' => ['var'],
        ],
    ])
    ->setFinder($finder)
    ->setLineEnding("\n");