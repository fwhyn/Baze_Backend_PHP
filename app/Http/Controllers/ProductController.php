<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Product;

class ProductController extends Controller
{
    public function index() {
        return response()->json(Product::all(), 200);
    }

    public function store(Request $request) {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'price' => 'required|numeric|min:0',
        ]);

        $product = Product::create($validated);
        return response()->json($product, 201);
    }

    public function show(Product $product) {
        return response()->json($product, 200);
    }

    public function update(Request $request, Product $product) {
        $validated = $request->validate([
            'name' => 'sometimes|string|max:255',
            'description' => 'nullable|string',
            'price' => 'sometimes|numeric|min:0',
        ]);

        $product->update($validated);
        return response()->json($product, 200);
    }

    public function destroy(Product $product) {
        $product->delete();
        return response()->json(['message' => 'Product deleted'], 200);
    }
}