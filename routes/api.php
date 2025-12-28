<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\ProductController;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::delete('/delete-account', [AuthController::class, 'deleteAccount']);

    Route::apiResource('categories', CategoryController::class);

    Route::apiResource('products', ProductController::class);
    Route::get('/products/search/{name}', [ProductController::class, 'search']);
    Route::get('/products/category/{id}', [ProductController::class, 'getByCategoryId']);
});
